import TMI.DigitalLifeWitnessQuorum
import TMI.DigitalLifeExternalRollbackWitnessRuntime

/-! Executable file protocol for I³-L09 witness quorum. -/

namespace TMI.DigitalLifeWitnessQuorumRuntime

open TMI.DigitalLifeExternalRollbackWitness
open TMI.DigitalLifeExternalRollbackWitnessRuntime
open TMI.DigitalLifeAtomicTrustStore
open TMI.DigitalLifeAtomicTrustStoreRuntime
open TMI.DigitalLifeValidationWireRuntime
open TMI.DigitalLifeWitnessQuorum

def runtimePolicyProtocol : String := "I3QPOL1"
def voteProtocol : String := "I3QVOTE1"
def certificateProtocol : String := "I3QCERT1"

structure RuntimeMember where
  member : QuorumMember
  publicKeyPath : String
  deriving DecidableEq, Repr

structure RuntimePolicy where
  policy : QuorumPolicy
  members : List RuntimeMember
  deriving DecidableEq, Repr

structure VoteEnvelope where
  protocolVersion : Nat
  policyId : String
  round : Nat
  witnessId : String
  keyId : String
  anchor : LocalAnchor
  checkpointDigest : String
  deriving DecidableEq, Repr

structure QuorumCertificate where
  protocolVersion : Nat
  policyId : String
  round : Nat
  anchor : LocalAnchor
  threshold : Nat
  witnessIds : List String
  voteDigests : List String
  deriving DecidableEq, Repr

private def safeToken (value : String) : Bool :=
  !value.isEmpty &&
  !value.toList.any (fun c => c == '|' || c == ',' || c == '\n' || c == '\r')

private def parseRuntimeMember (line : String) : Option RuntimeMember := do
  match line.trim.splitOn "|" with
  | ["MEMBER", witnessId, keyId, publicKeyPath] =>
      if !safeToken witnessId || !safeToken keyId || publicKeyPath.isEmpty then none
      else some { member := { witnessId, keyId }, publicKeyPath }
  | _ => none

def parseRuntimePolicy (text : String) : Option RuntimePolicy := do
  match text.trim.splitOn "\n" with
  | header :: rows =>
      match header.trim.splitOn "|" with
      | [protocol, versionText, policyId, thresholdText] =>
          if protocol != runtimePolicyProtocol || !safeToken policyId then none
          let version ← versionText.toNat?
          if version != quorumProtocolVersion then none
          let threshold ← thresholdText.toNat?
          let members ← rows.mapM parseRuntimeMember
          let policy : QuorumPolicy :=
            { policyId, threshold, members := members.map (fun runtime => runtime.member) }
          if PolicyWellFormed policy then some { policy, members } else none
      | _ => none
  | _ => none

def readRuntimePolicy (path : String) : IO (Option RuntimePolicy) := do
  pure (parseRuntimePolicy (← IO.FS.readFile path))

def encodeVote (vote : VoteEnvelope) : String :=
  String.intercalate "|"
    [ voteProtocol, toString vote.protocolVersion, vote.policyId,
      toString vote.round, vote.witnessId, vote.keyId,
      toString vote.anchor.generation, vote.anchor.receiptHead,
      vote.checkpointDigest ] ++ "\n"

def parseVote (text : String) : Option VoteEnvelope := do
  match text.trim.splitOn "|" with
  | [protocol, versionText, policyId, roundText, witnessId, keyId,
      generationText, receiptHead, checkpointDigest] =>
      if protocol != voteProtocol || !safeToken policyId ||
          !safeToken witnessId || !safeToken keyId then none
      let protocolVersion ← versionText.toNat?
      let round ← roundText.toNat?
      let generation ← generationText.toNat?
      some {
        protocolVersion := protocolVersion
        policyId := policyId
        round := round
        witnessId := witnessId
        keyId := keyId
        anchor := LocalAnchor.mk generation receiptHead
        checkpointDigest := checkpointDigest }
  | _ => none

def encodeCertificate (certificate : QuorumCertificate) : String :=
  String.intercalate "|"
    [ certificateProtocol, toString certificate.protocolVersion,
      certificate.policyId, toString certificate.round,
      toString certificate.anchor.generation, certificate.anchor.receiptHead,
      toString certificate.threshold,
      String.intercalate "," certificate.witnessIds,
      String.intercalate "," certificate.voteDigests ] ++ "\n"

def parseCertificate (text : String) : Option QuorumCertificate := do
  match text.trim.splitOn "|" with
  | [protocol, versionText, policyId, roundText, generationText, receiptHead,
      thresholdText, witnessIdsText, voteDigestsText] =>
      if protocol != certificateProtocol || !safeToken policyId then none
      let protocolVersion ← versionText.toNat?
      let round ← roundText.toNat?
      let generation ← generationText.toNat?
      let threshold ← thresholdText.toNat?
      let witnessIds := if witnessIdsText.isEmpty then [] else witnessIdsText.splitOn ","
      let voteDigests := if voteDigestsText.isEmpty then [] else voteDigestsText.splitOn ","
      some {
        protocolVersion := protocolVersion
        policyId := policyId
        round := round
        anchor := LocalAnchor.mk generation receiptHead
        threshold := threshold
        witnessIds := witnessIds
        voteDigests := voteDigests }
  | _ => none

private def findRuntimeMember
    (members : List RuntimeMember)
    (witnessId keyId : String) : Option RuntimeMember :=
  match members with
  | [] => none
  | member :: rest =>
      if member.member.witnessId == witnessId && member.member.keyId == keyId then
        some member
      else
        findRuntimeMember rest witnessId keyId

def writeSignedVote
    (policyId : String)
    (round : Nat)
    (witnessRoot keyId privateKey votePath signaturePath : String) : IO Bool := do
  if round = 0 || !safeToken policyId || !safeToken keyId then pure false
  else
    match (← readWitnessState witnessRoot) with
    | none => pure false
    | some witness =>
        if !safeToken witness.witnessId || witness.witnessHead.length != 64 then pure false
        else
          let vote : VoteEnvelope :=
            { protocolVersion := quorumProtocolVersion, policyId, round,
              witnessId := witness.witnessId, keyId,
              anchor := anchorOfWitness witness,
              checkpointDigest := witness.witnessHead }
          IO.FS.writeFile votePath (encodeVote vote)
          signFile privateKey votePath signaturePath

private def collectVotes
    (policy : RuntimePolicy)
    (voteDir : String) : IO (Except String (List (SignedWitnessVote × String))) := do
  let entries ← (voteDir : System.FilePath).readDir
  let mut votes : List (SignedWitnessVote × String) := []
  for entry in entries do
    if entry.fileName.endsWith ".i3qv" then
      match parseVote (← IO.FS.readFile entry.path), (← sha256File entry.path.toString) with
      | some envelope, some digest =>
          if envelope.protocolVersion != quorumProtocolVersion then
            return .error s!"unsupported vote protocol in {entry.fileName}"
          match findRuntimeMember policy.members envelope.witnessId envelope.keyId with
          | none => return .error s!"unknown witness or key in {entry.fileName}"
          | some member =>
              let signaturePath := entry.path.toString ++ ".sig"
              let signatureVerified ←
                verifyFile member.publicKeyPath entry.path.toString signaturePath
              let vote : SignedWitnessVote :=
                { policyId := envelope.policyId, round := envelope.round,
                  witnessId := envelope.witnessId, keyId := envelope.keyId,
                  anchor := envelope.anchor,
                  checkpointDigest := envelope.checkpointDigest,
                  signatureVerified }
              votes := (vote, digest) :: votes
      | _, _ => return .error s!"vote or digest parse failed in {entry.fileName}"
  pure (.ok votes.reverse)

private def certificateOf
    (policy : QuorumPolicy)
    (target : LocalAnchor)
    (round : Nat)
    (votes : List (SignedWitnessVote × String)) : QuorumCertificate :=
  { protocolVersion := quorumProtocolVersion,
    policyId := policy.policyId, round, anchor := target,
    threshold := policy.threshold,
    witnessIds := votes.map (fun item => item.1.witnessId),
    voteDigests := votes.map (fun item => item.2) }

inductive QuorumOutcome where
  | admitted (certificate : QuorumCertificate)
  | hold (reason : String)
  deriving Repr

def evaluateQuorum
    (runtimePolicy : RuntimePolicy)
    (target : LocalAnchor)
    (round : Nat)
    (voteDir : String) : IO QuorumOutcome := do
  match (← collectVotes runtimePolicy voteDir) with
  | .error reason => pure (.hold reason)
  | .ok pairedVotes =>
      let votes := pairedVotes.map (fun item => item.1)
      if hReady : QuorumReady runtimePolicy.policy target round votes then
        pure (.admitted (certificateOf runtimePolicy.policy target round pairedVotes))
      else if !(decide (votes.map (fun vote => vote.witnessId)).Nodup) then
        pure (.hold "duplicate witness identity")
      else if votes.any (fun vote => vote.anchor != target) then
        pure (.hold "conflicting signed anchor")
      else if votes.any (fun vote => vote.signatureVerified != true) then
        pure (.hold "invalid witness signature")
      else if votes.length < runtimePolicy.policy.threshold then
        pure (.hold s!"insufficient quorum: {votes.length}/{runtimePolicy.policy.threshold}")
      else
        pure (.hold "vote is not bound to this policy, round, key, or checkpoint")

def issueCertificate
    (policyPath storePath : String)
    (round : Nat)
    (voteDir certificatePath : String) : IO QuorumOutcome := do
  match (← readRuntimePolicy policyPath), (← readAtomicSnapshot storePath) with
  | some policy, some snapshot =>
      let outcome ← evaluateQuorum policy (anchorOfSnapshot snapshot) round voteDir
      match outcome with
      | .admitted certificate =>
          IO.FS.writeFile certificatePath (encodeCertificate certificate)
          pure outcome
      | .hold _ => pure outcome
  | _, _ => pure (.hold "policy or atomic trust store parse failed")

def verifyCertificate
    (policyPath storePath : String)
    (round : Nat)
    (voteDir certificatePath : String) : IO Bool := do
  match (← readRuntimePolicy policyPath), (← readAtomicSnapshot storePath),
      parseCertificate (← IO.FS.readFile certificatePath) with
  | some policy, some snapshot, some claimed =>
      match (← evaluateQuorum policy (anchorOfSnapshot snapshot) round voteDir) with
      | .admitted recomputed => pure (claimed = recomputed)
      | .hold _ => pure false
  | _, _, _ => pure false

end TMI.DigitalLifeWitnessQuorumRuntime
