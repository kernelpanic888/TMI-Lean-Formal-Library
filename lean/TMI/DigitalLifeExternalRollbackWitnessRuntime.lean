import TMI.DigitalLifeExternalRollbackWitness
import TMI.DigitalLifeAtomicTrustStoreRuntime

namespace TMI.DigitalLifeExternalRollbackWitnessRuntime

open TMI.DigitalLifeAtomicTrustStore
open TMI.DigitalLifeAtomicTrustStoreRuntime
open TMI.DigitalLifeExternalRollbackWitness
open TMI.DigitalLifePersistentTrustRuntime
open TMI.DigitalLifeValidationWireRuntime

def witnessRecordProtocol : String := "I3WITNESS1"
def witnessRequestProtocol : String := "I3WITREQ1"

structure WitnessAppendRequest where
  witnessId : String
  expectedSequence : Nat
  expectedWitnessHead : String
  priorGeneration : Nat
  priorReceiptHead : String
  nextGeneration : Nat
  nextReceiptHead : String
  nonce : String
  keyId : String
  deriving DecidableEq, Repr

structure WitnessRecord where
  witnessId : String
  sequence : Nat
  previousWitnessHead : String
  priorGeneration : Nat
  priorReceiptHead : String
  anchoredGeneration : Nat
  anchoredReceiptHead : String
  nonce : String
  checkpointDigest : String
  deriving DecidableEq, Repr

def encodeWitnessRequest (request : WitnessAppendRequest) : String :=
  s!"{witnessRequestProtocol}|{request.witnessId}|{request.expectedSequence}|{request.expectedWitnessHead}|{request.priorGeneration}|{request.priorReceiptHead}|{request.nextGeneration}|{request.nextReceiptHead}|{request.nonce}|{request.keyId}\n"

def parseWitnessRequest (text : String) : Option WitnessAppendRequest := do
  match text.trim.splitOn "|" with
  | [protocol, witnessId, sequenceText, witnessHead, priorGenerationText,
      priorReceiptHead, nextGenerationText, nextReceiptHead, nonce, keyId] =>
      if protocol != witnessRequestProtocol then none
      else
        let expectedSequence ← sequenceText.toNat?
        let priorGeneration ← priorGenerationText.toNat?
        let nextGeneration ← nextGenerationText.toNat?
        some (WitnessAppendRequest.mk witnessId expectedSequence witnessHead
          priorGeneration priorReceiptHead nextGeneration nextReceiptHead nonce keyId)
  | _ => none

def encodeWitnessRecord (record : WitnessRecord) : String :=
  s!"{witnessRecordProtocol}|{record.witnessId}|{record.sequence}|{record.previousWitnessHead}|{record.priorGeneration}|{record.priorReceiptHead}|{record.anchoredGeneration}|{record.anchoredReceiptHead}|{record.nonce}|{record.checkpointDigest}\n"

def parseWitnessRecord (text : String) : Option WitnessRecord := do
  match text.trim.splitOn "|" with
  | [protocol, witnessId, sequenceText, previousWitnessHead, priorGenerationText,
      priorReceiptHead, generationText, receiptHead, nonce, checkpointDigest] =>
      if protocol != witnessRecordProtocol then none
      else
        let sequence ← sequenceText.toNat?
        let priorGeneration ← priorGenerationText.toNat?
        let anchoredGeneration ← generationText.toNat?
        some (WitnessRecord.mk witnessId sequence previousWitnessHead priorGeneration
          priorReceiptHead anchoredGeneration receiptHead nonce checkpointDigest)
  | _ => none

def writeWitnessRequest (path : String) (request : WitnessAppendRequest) : IO Unit :=
  IO.FS.writeFile path (encodeWitnessRequest request)

def readWitnessRequest (path : String) : IO (Option WitnessAppendRequest) := do
  pure (parseWitnessRequest (← IO.FS.readFile path))

private def lockPath (root : String) : String := root ++ "/.lock"
private def checkpointPath (root : String) (sequence : Nat) : String :=
  root ++ "/checkpoint." ++ toString sequence ++ ".i3w"
private def nextPath (root : String) (sequence : Nat) : String :=
  root ++ "/.next." ++ toString sequence

private def acquireLock (root : String) : IO Bool := do
  try
    IO.FS.createDir (lockPath root)
    pure true
  catch _ =>
    pure false

private def releaseLock (root : String) : IO Unit := do
  try
    IO.FS.removeDir (lockPath root)
  catch _ =>
    pure ()

private def withWitnessLock (root : String) (action : IO α) : IO (Option α) := do
  if !(← acquireLock root) then
    pure none
  else
    try
      let result ← action
      releaseLock root
      pure (some result)
    catch error =>
      releaseLock root
      throw error

private def readWitnessRecords (root : String) : IO (Option (List WitnessRecord)) := do
  let entries ← (root : System.FilePath).readDir
  let mut records : List WitnessRecord := []
  for entry in entries do
    if entry.fileName.startsWith "checkpoint." && entry.fileName.endsWith ".i3w" then
      match parseWitnessRecord (← IO.FS.readFile entry.path) with
      | none => return none
      | some record => records := record :: records
  pure (some records)

private def recordAt (records : List WitnessRecord) (sequence : Nat) : Option WitnessRecord :=
  match records.filter (fun record => record.sequence == sequence) with
  | [record] => some record
  | _ => none

private def validateWitnessRecords (records : List WitnessRecord) : Option WitnessState := do
  let genesis ← recordAt records 0
  if genesis.previousWitnessHead != "ROOT" ||
      genesis.priorGeneration != genesis.anchoredGeneration ||
      genesis.priorReceiptHead != genesis.anchoredReceiptHead ||
      genesis.nonce != "GENESIS" || genesis.checkpointDigest.length != 64 then
    none
  else
    let initial : WitnessState :=
      { witnessId := genesis.witnessId
        sequence := 0
        anchoredGeneration := genesis.anchoredGeneration
        anchoredReceiptHead := genesis.anchoredReceiptHead
        witnessHead := genesis.checkpointDigest
        consumedNonces := [] }
    let rec loop (sequence remaining : Nat) (state : WitnessState) : Option WitnessState :=
      match remaining with
      | 0 => some state
      | count + 1 => do
          let record ← recordAt records sequence
          if record.witnessId != state.witnessId ||
              record.previousWitnessHead != state.witnessHead ||
              record.priorGeneration != state.anchoredGeneration ||
              record.priorReceiptHead != state.anchoredReceiptHead ||
              record.anchoredGeneration != state.anchoredGeneration + 1 ||
              record.anchoredReceiptHead == state.anchoredReceiptHead ||
              record.nonce.length != 64 || record.nonce ∈ state.consumedNonces ||
              record.checkpointDigest.length != 64 then
            none
          else
            loop (sequence + 1) count
              { witnessId := state.witnessId
                sequence := record.sequence
                anchoredGeneration := record.anchoredGeneration
                anchoredReceiptHead := record.anchoredReceiptHead
                witnessHead := record.checkpointDigest
                consumedNonces := record.nonce :: state.consumedNonces }
    loop 1 (records.length - 1) initial

def readWitnessState (root : String) : IO (Option WitnessState) := do
  match (← readWitnessRecords root) with
  | none => pure none
  | some records => pure (validateWitnessRecords records)

private def atomicCreateRecord
    (root : String)
    (record : WitnessRecord) : IO Bool := do
  let target := checkpointPath root record.sequence
  if (← (target : System.FilePath).pathExists) then
    pure false
  else
    let temporary := nextPath root record.sequence
    IO.FS.writeFile temporary (encodeWitnessRecord record)
    IO.FS.rename temporary target
    pure true

inductive WitnessAppendOutcome where
  | appended (state : WitnessState)
  | stale (state : WitnessState)
  | rejected (reason : String)
  | lockBusy
  deriving Repr

def initializeWitness
    (root : String)
    (storePath : String)
    (witnessId : String) : IO Bool := do
  IO.FS.createDirAll root
  match ← withWitnessLock root (do
      match (← readWitnessRecords root), (← readAtomicSnapshot storePath),
          (← sha256File storePath) with
      | some [], some snapshot, some digest =>
          if witnessId.isEmpty || digest.length != 64 then pure false
          else
            atomicCreateRecord root
              { witnessId := witnessId, sequence := 0, previousWitnessHead := "ROOT",
                priorGeneration := snapshot.generation,
                priorReceiptHead := snapshot.trust.receiptHead,
                anchoredGeneration := snapshot.generation,
                anchoredReceiptHead := snapshot.trust.receiptHead,
                nonce := "GENESIS", checkpointDigest := digest }
      | _, _, _ => pure false) with
  | none => pure false
  | some result => pure result

def makeWitnessRequest
    (root : String)
    (storePath : String)
    (requestPath : String)
    (nonce : String)
    (keyId : String) : IO (Option WitnessAppendRequest) := do
  match (← readWitnessState root), (← readAtomicSnapshot storePath) with
  | some witness, some snapshot =>
      if snapshot.generation != witness.anchoredGeneration + 1 ||
          snapshot.trust.receiptHead == witness.anchoredReceiptHead ||
          nonce.length != 64 || nonce ∈ witness.consumedNonces || keyId.isEmpty then
        pure none
      else
        let request : WitnessAppendRequest :=
          { witnessId := witness.witnessId
            expectedSequence := witness.sequence
            expectedWitnessHead := witness.witnessHead
            priorGeneration := witness.anchoredGeneration
            priorReceiptHead := witness.anchoredReceiptHead
            nextGeneration := snapshot.generation
            nextReceiptHead := snapshot.trust.receiptHead
            nonce := nonce
            keyId := keyId }
        writeWitnessRequest requestPath request
        pure (some request)
  | _, _ => pure none

def appendWitness
    (trustedPublicKey : String)
    (trustedKeyId : String)
    (root : String)
    (requestPath : String)
    (signaturePath : String) : IO WitnessAppendOutcome := do
  match ← withWitnessLock root (do
      match (← readWitnessState root), (← readWitnessRequest requestPath),
          (← sha256File requestPath) with
      | some current, some request, some digest =>
          if request.keyId != trustedKeyId then
            pure (.rejected "witness signing key id is not trusted")
          else
            let signatureVerified ← verifyFile trustedPublicKey requestPath signaturePath
            let intent : WitnessAppendIntent :=
              { witnessId := request.witnessId
                expectedSequence := request.expectedSequence
                expectedWitnessHead := request.expectedWitnessHead
                priorGeneration := request.priorGeneration
                priorReceiptHead := request.priorReceiptHead
                nextGeneration := request.nextGeneration
                nextReceiptHead := request.nextReceiptHead
                nonce := request.nonce
                checkpointDigest := digest
                certificateVerified := signatureVerified }
            if h : WitnessAppendReady current intent then
              let next := applyWitnessAppend current intent
              let created ← atomicCreateRecord root
                { witnessId := next.witnessId
                  sequence := next.sequence
                  previousWitnessHead := current.witnessHead
                  priorGeneration := current.anchoredGeneration
                  priorReceiptHead := current.anchoredReceiptHead
                  anchoredGeneration := next.anchoredGeneration
                  anchoredReceiptHead := next.anchoredReceiptHead
                  nonce := request.nonce
                  checkpointDigest := digest }
              if created then pure (.appended next)
              else pure (.rejected "immutable witness checkpoint already exists")
            else
              pure (.stale current)
      | _, _, _ => pure (.rejected "witness log, request, or digest parse failed")) with
  | none => pure .lockBusy
  | some outcome => pure outcome

def checkLocal
    (root : String)
    (storePath : String) : IO (Option RollbackVerdict) := do
  match (← readWitnessState root), (← readAtomicSnapshot storePath) with
  | some witness, some snapshot =>
      pure (some (classifyLocal (anchorOfSnapshot snapshot) witness))
  | _, _ => pure none

end TMI.DigitalLifeExternalRollbackWitnessRuntime
