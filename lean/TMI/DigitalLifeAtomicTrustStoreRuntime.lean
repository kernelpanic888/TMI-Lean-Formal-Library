import TMI.DigitalLifeAtomicTrustStore
import TMI.DigitalLifePersistentTrustRuntime

namespace TMI.DigitalLifeAtomicTrustStoreRuntime

open TMI.DigitalLifeNeuralProposer
open TMI.DigitalLifeBoundedLearning
open TMI.DigitalLifeValidationAdapter
open TMI.DigitalLifePersistentTrust
open TMI.DigitalLifePersistentTrustRuntime
open TMI.DigitalLifeValidationWireRuntime
open TMI.DigitalLifeAtomicTrustStore

def atomicStoreProtocol : String := "I3STORE1"

def encodeAtomicSnapshot (snapshot : AtomicTrustSnapshot) : String :=
  s!"{atomicStoreProtocol}|{snapshot.generation}\n{encodePersistentState snapshot.trust}\n"

def parseAtomicSnapshot (text : String) : Option AtomicTrustSnapshot := do
  match text.trim.splitOn "\n" with
  | header :: trustLine :: _ =>
      match header.splitOn "|" with
      | [protocol, generationText] =>
          if protocol != atomicStoreProtocol then none
          else
            let generation ← generationText.toNat?
            let trust ← parsePersistentState trustLine
            some { generation, trust }
      | _ => none
  | _ => none

def readAtomicSnapshot (path : String) : IO (Option AtomicTrustSnapshot) := do
  pure (parseAtomicSnapshot (← IO.FS.readFile path))

def writeAtomicSnapshot (path : String) (snapshot : AtomicTrustSnapshot) : IO Unit :=
  IO.FS.writeFile path (encodeAtomicSnapshot snapshot)

private def lockPath (storePath : String) : String := storePath ++ ".lock"
private def nextPath (storePath : String) : String := storePath ++ ".next"

private def acquireLock (storePath : String) : IO Bool := do
  try
    IO.FS.createDir (lockPath storePath)
    pure true
  catch _ =>
    pure false

private def releaseLock (storePath : String) : IO Unit := do
  try
    IO.FS.removeDir (lockPath storePath)
  catch _ =>
    pure ()

private def withStoreLock
    (storePath : String)
    (action : IO α) : IO (Option α) := do
  if !(← acquireLock storePath) then
    pure none
  else
    try
      let result ← action
      releaseLock storePath
      pure (some result)
    catch error =>
      releaseLock storePath
      throw error

private def atomicReplace
    (storePath : String)
    (snapshot : AtomicTrustSnapshot) : IO Unit := do
  let temporary := nextPath storePath
  writeAtomicSnapshot temporary snapshot
  IO.FS.rename temporary storePath

inductive AtomicCommitOutcome where
  | committed (snapshot : AtomicTrustSnapshot)
  | stale (snapshot : AtomicTrustSnapshot)
  | rejected (reason : String)
  | lockBusy
  deriving Repr

def initializeAtomicStore
    (storePath : String)
    (trustPath : String) : IO Bool := do
  match (← readPersistentState trustPath) with
  | none => pure false
  | some trust =>
      let snapshot : AtomicTrustSnapshot := { generation := 0, trust }
      let result ← withStoreLock storePath (atomicReplace storePath snapshot)
      pure result.isSome

def makeAtomicRequest
    (storePath : String)
    (requestPath : String)
    (nonce : String) : IO (Option (AtomicTrustSnapshot × StatefulWireRequest)) := do
  match (← readAtomicSnapshot storePath) with
  | none => pure none
  | some snapshot =>
      if nonce.length != 64 || nonce ∈ snapshot.trust.consumedNonces then
        pure none
      else
        let delta := (runTrainer snapshot.trust.learning.parameters demoTraining).delta
        let request := makeStatefulRequest snapshot.trust nonce delta
        writeStatefulRequest requestPath request
        pure (some (snapshot, request))

def commitReceiptCAS
    (publicKey : String)
    (storePath : String)
    (requestPath : String)
    (receiptPath : String)
    (signaturePath : String)
    (expectedGeneration : Nat)
    (expectedReceiptHead : String) : IO AtomicCommitOutcome := do
  match ← withStoreLock storePath (do
      match (← readAtomicSnapshot storePath) with
      | none => pure (.rejected "atomic trust store parse failed")
      | some current =>
          if !decide (AtomicHeadMatches current expectedGeneration expectedReceiptHead) then
            pure (.stale current)
          else
            match (← readStatefulRequest requestPath), (← readStatefulReceipt receiptPath),
                (← sha256File requestPath), (← sha256File receiptPath) with
            | some request, some receipt, some requestDigest, some receiptDigest =>
                let signatureVerified ← verifyFile publicKey receiptPath signaturePath
                let intent : ReceiptCommitIntent :=
                  { expectedGeneration, expectedReceiptHead, request, requestDigest,
                    receipt, receiptDigest, signatureVerified }
                if h : ReceiptCASReady current intent then
                  let next := applyReceiptCAS current intent
                  atomicReplace storePath next
                  pure (.committed next)
                else
                  pure (.rejected "signature, request, nonce, chain, model, delta, or loss gate failed")
            | _, _, _, _ => pure (.rejected "request, receipt, or digest parse failed")) with
  | none => pure .lockBusy
  | some outcome => pure outcome

def commitRotationCAS
    (oldPublicKey : String)
    (storePath : String)
    (rotationPath : String)
    (signaturePath : String)
    (expectedGeneration : Nat)
    (expectedReceiptHead : String) : IO AtomicCommitOutcome := do
  match ← withStoreLock storePath (do
      match (← readAtomicSnapshot storePath) with
      | none => pure (.rejected "atomic trust store parse failed")
      | some current =>
          if !decide (AtomicHeadMatches current expectedGeneration expectedReceiptHead) then
            pure (.stale current)
          else
            match (← readKeyRotation rotationPath), (← sha256File rotationPath) with
            | some request, some rotationDigest =>
                let signatureVerified ← verifyFile oldPublicKey rotationPath signaturePath
                let intent : RotationCommitIntent :=
                  { expectedGeneration, expectedReceiptHead, request, rotationDigest,
                    signatureVerified }
                if h : RotationCASReady current intent then
                  let next := applyRotationCAS current intent
                  atomicReplace storePath next
                  pure (.committed next)
                else
                  pure (.rejected "signature, epoch, key, head, or nonce gate failed")
            | _, _ => pure (.rejected "rotation or digest parse failed")) with
  | none => pure .lockBusy
  | some outcome => pure outcome

end TMI.DigitalLifeAtomicTrustStoreRuntime
