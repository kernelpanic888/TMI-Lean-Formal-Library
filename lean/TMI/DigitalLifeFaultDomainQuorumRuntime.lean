import TMI.DigitalLifeFaultDomainQuorum
import TMI.DigitalLifeWitnessQuorumRuntime

/-! Executable file protocol for I³-L10 independent witness quorums. -/

namespace TMI.DigitalLifeFaultDomainQuorumRuntime

open TMI.DigitalLifeExternalRollbackWitness
open TMI.DigitalLifeExternalRollbackWitnessRuntime
open TMI.DigitalLifeAtomicTrustStore
open TMI.DigitalLifeAtomicTrustStoreRuntime
open TMI.DigitalLifeValidationWireRuntime
open TMI.DigitalLifeWitnessQuorum
open TMI.DigitalLifeWitnessQuorumRuntime
open TMI.DigitalLifeFaultDomainQuorum

def domainPolicyProtocol : String := "I3DPOL1"
def domainVoteProtocol : String := "I3DVOTE1"
def domainCertificateProtocol : String := "I3DCERT1"

structure RuntimeFaultDomainMember where
  profile : FaultDomainProfile
  publicKeyPath : String
  deriving DecidableEq, Repr

structure RuntimeFaultDomainPolicy where
  policy : FaultDomainPolicy
  members : List RuntimeFaultDomainMember
  deriving DecidableEq, Repr

structure FaultDomainVoteEnvelope where
  protocolVersion : Nat
  policyId : String
  domainPolicyDigest : String
  round : Nat
  witnessId : String
  keyId : String
  anchor : LocalAnchor
  checkpointDigest : String
  deriving DecidableEq, Repr

structure FaultDomainQuorumCertificate where
  protocolVersion : Nat
  policyId : String
  domainPolicyDigest : String
  round : Nat
  anchor : LocalAnchor
  threshold : Nat
  witnessIds : List String
  voteDigests : List String
  adminDomains : List String
  networkDomains : List String
  hostDomains : List String
  deriving DecidableEq, Repr

private def safeToken (value : String) : Bool :=
  !value.isEmpty &&
  !value.toList.any (fun c => c == '|' || c == ',' || c == '\n' || c == '\r')

private def parseRuntimeMember (line : String) : Option RuntimeFaultDomainMember := do
  match line.trim.splitOn "|" with
  | ["MEMBER", witnessId, keyId, publicKeyPath, adminDomain, networkDomain,
      hostDomain] =>
      if !safeToken witnessId || !safeToken keyId || publicKeyPath.isEmpty ||
          !safeToken adminDomain || !safeToken networkDomain || !safeToken hostDomain then
        none
      else
        some {
          profile := {
            member := { witnessId, keyId }, adminDomain, networkDomain, hostDomain },
          publicKeyPath }
  | _ => none

def parseRuntimeFaultDomainPolicy (text : String) : Option RuntimeFaultDomainPolicy := do
  match text.trim.splitOn "\n" with
  | header :: rows =>
      match header.trim.splitOn "|" with
      | [protocol, versionText, policyId, thresholdText] =>
          if protocol != domainPolicyProtocol || !safeToken policyId then none
          let version ← versionText.toNat?
          if version != faultDomainProtocolVersion then none
          let threshold ← thresholdText.toNat?
          let members ← rows.mapM parseRuntimeMember
          let profiles := members.map (fun runtime => runtime.profile)
          let quorum : QuorumPolicy :=
            { policyId, threshold,
              members := profiles.map (fun profile => profile.member) }
          let policy : FaultDomainPolicy := { quorum, profiles }
          if DomainPolicyWellFormed policy then some { policy, members } else none
      | _ => none
  | _ => none

def readRuntimeFaultDomainPolicy
    (path : String) : IO (Option RuntimeFaultDomainPolicy) := do
  pure (parseRuntimeFaultDomainPolicy (← IO.FS.readFile path))

def encodeDomainVote (vote : FaultDomainVoteEnvelope) : String :=
  String.intercalate "|"
    [ domainVoteProtocol, toString vote.protocolVersion, vote.policyId,
      vote.domainPolicyDigest, toString vote.round, vote.witnessId, vote.keyId,
      toString vote.anchor.generation, vote.anchor.receiptHead,
      vote.checkpointDigest ] ++ "\n"

def parseDomainVote (text : String) : Option FaultDomainVoteEnvelope := do
  match text.trim.splitOn "|" with
  | [protocol, versionText, policyId, policyDigest, roundText, witnessId, keyId,
      generationText, receiptHead, checkpointDigest] =>
      if protocol != domainVoteProtocol || !safeToken policyId ||
          !safeToken witnessId || !safeToken keyId then none
      let protocolVersion ← versionText.toNat?
      let round ← roundText.toNat?
      let generation ← generationText.toNat?
      some {
        protocolVersion, policyId, domainPolicyDigest := policyDigest, round,
        witnessId, keyId, anchor := LocalAnchor.mk generation receiptHead,
        checkpointDigest }
  | _ => none

def encodeDomainCertificate (certificate : FaultDomainQuorumCertificate) : String :=
  String.intercalate "|"
    [ domainCertificateProtocol, toString certificate.protocolVersion,
      certificate.policyId, certificate.domainPolicyDigest,
      toString certificate.round, toString certificate.anchor.generation,
      certificate.anchor.receiptHead, toString certificate.threshold,
      String.intercalate "," certificate.witnessIds,
      String.intercalate "," certificate.voteDigests,
      String.intercalate "," certificate.adminDomains,
      String.intercalate "," certificate.networkDomains,
      String.intercalate "," certificate.hostDomains ] ++ "\n"

private def parseCsv (text : String) : List String :=
  if text.isEmpty then [] else text.splitOn ","

def parseDomainCertificate (text : String) : Option FaultDomainQuorumCertificate := do
  match text.trim.splitOn "|" with
  | [protocol, versionText, policyId, policyDigest, roundText, generationText,
      receiptHead, thresholdText, witnessIdsText, voteDigestsText,
      adminDomainsText, networkDomainsText, hostDomainsText] =>
      if protocol != domainCertificateProtocol || !safeToken policyId then none
      let protocolVersion ← versionText.toNat?
      let round ← roundText.toNat?
      let generation ← generationText.toNat?
      let threshold ← thresholdText.toNat?
      some {
        protocolVersion, policyId, domainPolicyDigest := policyDigest, round,
        anchor := LocalAnchor.mk generation receiptHead, threshold,
        witnessIds := parseCsv witnessIdsText,
        voteDigests := parseCsv voteDigestsText,
        adminDomains := parseCsv adminDomainsText,
        networkDomains := parseCsv networkDomainsText,
        hostDomains := parseCsv hostDomainsText }
  | _ => none

private def findRuntimeMember
    (members : List RuntimeFaultDomainMember)
    (witnessId keyId : String) : Option RuntimeFaultDomainMember :=
  match members with
  | [] => none
  | member :: rest =>
      if member.profile.member.witnessId == witnessId &&
          member.profile.member.keyId == keyId then
        some member
      else
        findRuntimeMember rest witnessId keyId

def writeSignedFaultDomainVote
    (policyPath : String)
    (round : Nat)
    (witnessRoot keyId privateKey votePath signaturePath : String) : IO Bool := do
  match (← readRuntimeFaultDomainPolicy policyPath), (← sha256File policyPath),
      (← readWitnessState witnessRoot) with
  | some policy, some policyDigest, some witness =>
      if round = 0 || policyDigest.length != 64 || witness.witnessHead.length != 64 then
        pure false
      else
        match findRuntimeMember policy.members witness.witnessId keyId with
        | none => pure false
        | some _ =>
            let vote : FaultDomainVoteEnvelope := {
              protocolVersion := faultDomainProtocolVersion,
              policyId := policy.policy.quorum.policyId, domainPolicyDigest := policyDigest,
              round, witnessId := witness.witnessId, keyId,
              anchor := anchorOfWitness witness,
              checkpointDigest := witness.witnessHead }
            IO.FS.writeFile votePath (encodeDomainVote vote)
            signFile privateKey votePath signaturePath
  | _, _, _ => pure false

private def collectVotes
    (policy : RuntimeFaultDomainPolicy)
    (voteDir : String) :
    IO (Except String (List (FaultDomainVote × String))) := do
  let entries ← (voteDir : System.FilePath).readDir
  let mut votes : List (FaultDomainVote × String) := []
  for entry in entries do
    if entry.fileName.endsWith ".i3dv" then
      match parseDomainVote (← IO.FS.readFile entry.path),
          (← sha256File entry.path.toString) with
      | some envelope, some digest =>
          if envelope.protocolVersion != faultDomainProtocolVersion then
            return .error s!"unsupported vote protocol in {entry.fileName}"
          match findRuntimeMember policy.members envelope.witnessId envelope.keyId with
          | none => return .error s!"unknown witness or key in {entry.fileName}"
          | some member =>
              let signatureVerified ←
                verifyFile member.publicKeyPath entry.path.toString
                  (entry.path.toString ++ ".sig")
              let base : SignedWitnessVote := {
                policyId := envelope.policyId, round := envelope.round,
                witnessId := envelope.witnessId, keyId := envelope.keyId,
                anchor := envelope.anchor,
                checkpointDigest := envelope.checkpointDigest,
                signatureVerified }
              votes := ({ base, domainPolicyDigest := envelope.domainPolicyDigest }, digest) :: votes
      | _, _ => return .error s!"vote or digest parse failed in {entry.fileName}"
  pure (.ok votes.reverse)

private def certificateOf
    (policy : FaultDomainPolicy)
    (policyDigest : String)
    (target : LocalAnchor)
    (round : Nat)
    (votes : List (FaultDomainVote × String))
    (profiles : List FaultDomainProfile) : FaultDomainQuorumCertificate :=
  { protocolVersion := faultDomainProtocolVersion,
    policyId := policy.quorum.policyId, domainPolicyDigest := policyDigest,
    round, anchor := target, threshold := policy.quorum.threshold,
    witnessIds := votes.map (fun item => item.1.base.witnessId),
    voteDigests := votes.map (fun item => item.2),
    adminDomains := profiles.map (fun profile => profile.adminDomain),
    networkDomains := profiles.map (fun profile => profile.networkDomain),
    hostDomains := profiles.map (fun profile => profile.hostDomain) }

inductive FaultDomainQuorumOutcome where
  | admitted (certificate : FaultDomainQuorumCertificate)
  | hold (reason : String)
  deriving Repr

def evaluateFaultDomainQuorum
    (runtimePolicy : RuntimeFaultDomainPolicy)
    (policyDigest : String)
    (target : LocalAnchor)
    (round : Nat)
    (voteDir : String) : IO FaultDomainQuorumOutcome := do
  match (← collectVotes runtimePolicy voteDir) with
  | .error reason => pure (.hold reason)
  | .ok pairedVotes =>
      let votes := pairedVotes.map (fun item => item.1)
      let witnessIds := votes.map (fun vote => vote.base.witnessId)
      if hReady : IndependentQuorumReady runtimePolicy.policy policyDigest target round votes then
        match profilesForWitnessIds runtimePolicy.policy witnessIds with
        | some profiles =>
            pure (.admitted
              (certificateOf runtimePolicy.policy policyDigest target round pairedVotes profiles))
        | none => pure (.hold "domain profile resolution failed")
      else if !(decide (witnessIds.Nodup)) then
        pure (.hold "duplicate witness identity")
      else if !(decide (AdminSeparated runtimePolicy.policy witnessIds)) then
        pure (.hold "shared administrative fault domain")
      else if !(decide (NetworkSeparated runtimePolicy.policy witnessIds)) then
        pure (.hold "shared network fault domain")
      else if !(decide (HostSeparated runtimePolicy.policy witnessIds)) then
        pure (.hold "shared host fault domain")
      else if votes.any (fun vote => vote.domainPolicyDigest != policyDigest) then
        pure (.hold "domain policy digest changed after signing")
      else if votes.any (fun vote => vote.base.anchor != target) then
        pure (.hold "conflicting signed anchor")
      else if votes.any (fun vote => vote.base.signatureVerified != true) then
        pure (.hold "invalid witness signature")
      else if votes.length < runtimePolicy.policy.quorum.threshold then
        pure (.hold
          s!"insufficient quorum: {votes.length}/{runtimePolicy.policy.quorum.threshold}")
      else
        pure (.hold "vote is not bound to this policy, round, key, or checkpoint")

def issueFaultDomainCertificate
    (policyPath storePath : String)
    (round : Nat)
    (voteDir certificatePath : String) : IO FaultDomainQuorumOutcome := do
  match (← readRuntimeFaultDomainPolicy policyPath), (← sha256File policyPath),
      (← readAtomicSnapshot storePath) with
  | some policy, some policyDigest, some snapshot =>
      let outcome ← evaluateFaultDomainQuorum policy policyDigest
        (anchorOfSnapshot snapshot) round voteDir
      match outcome with
      | .admitted certificate =>
          IO.FS.writeFile certificatePath (encodeDomainCertificate certificate)
          pure outcome
      | .hold _ => pure outcome
  | _, _, _ => pure (.hold "policy, digest, or atomic trust store parse failed")

def verifyFaultDomainCertificate
    (policyPath storePath : String)
    (round : Nat)
    (voteDir certificatePath : String) : IO Bool := do
  match (← readRuntimeFaultDomainPolicy policyPath), (← sha256File policyPath),
      (← readAtomicSnapshot storePath),
      parseDomainCertificate (← IO.FS.readFile certificatePath) with
  | some policy, some policyDigest, some snapshot, some claimed =>
      match (← evaluateFaultDomainQuorum policy policyDigest
          (anchorOfSnapshot snapshot) round voteDir) with
      | .admitted recomputed => pure (claimed = recomputed)
      | .hold _ => pure false
  | _, _, _, _ => pure false

end TMI.DigitalLifeFaultDomainQuorumRuntime
