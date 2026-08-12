import TMI.DigitalLifeRemoteWitnessChallenge
import TMI.DigitalLifeFaultDomainQuorumRuntime

/-! Executable file protocol for I³-L11 fresh remote witness responses. -/

namespace TMI.DigitalLifeRemoteWitnessChallengeRuntime

open TMI.DigitalLifeExternalRollbackWitness
open TMI.DigitalLifeExternalRollbackWitnessRuntime
open TMI.DigitalLifeAtomicTrustStore
open TMI.DigitalLifeAtomicTrustStoreRuntime
open TMI.DigitalLifeValidationWireRuntime
open TMI.DigitalLifeWitnessQuorum
open TMI.DigitalLifeFaultDomainQuorum
open TMI.DigitalLifeFaultDomainQuorumRuntime
open TMI.DigitalLifeRemoteWitnessChallenge

def remotePolicyProtocol : String := "I3RPOL1"
def challengeProtocol : String := "I3CHAL1"
def responseProtocol : String := "I3RSP1"
def remoteReceiptProtocol : String := "I3RREC1"

structure RuntimeRemoteProfile where
  profile : RemoteWitnessProfile
  publicKeyPath : String
  deriving DecidableEq, Repr

structure RuntimeRemotePolicy where
  policy : RemoteWitnessPolicy
  verifierPublicKeyPath : String
  profiles : List RuntimeRemoteProfile
  deriving DecidableEq, Repr

structure ChallengeEnvelope where
  protocolVersion : Nat
  policyId : String
  domainPolicyDigest : String
  challengeId : String
  verifierId : String
  verifierKeyId : String
  round : Nat
  issuedAt : Nat
  expiresAt : Nat
  target : LocalAnchor
  witnessId : String
  keyId : String
  endpointId : String
  tlsPeerDigest : String
  deriving DecidableEq, Repr

structure ResponseEnvelope where
  protocolVersion : Nat
  policyId : String
  domainPolicyDigest : String
  challengeId : String
  challengeDigest : String
  round : Nat
  witnessId : String
  keyId : String
  endpointId : String
  tlsPeerDigest : String
  respondedAt : Nat
  anchor : LocalAnchor
  checkpointDigest : String
  deriving DecidableEq, Repr

structure RemoteResponseReceipt where
  protocolVersion : Nat
  policyId : String
  challengeId : String
  challengeDigest : String
  responseDigest : String
  witnessId : String
  endpointId : String
  tlsPeerDigest : String
  anchor : LocalAnchor
  deriving DecidableEq, Repr

private def safeToken (value : String) : Bool :=
  !value.isEmpty &&
  !value.toList.any (fun c => c == '|' || c == ',' || c == '\n' || c == '\r')

private def parseRuntimeProfile (line : String) : Option RuntimeRemoteProfile := do
  match line.trim.splitOn "|" with
  | ["MEMBER", witnessId, keyId, publicKeyPath, adminDomain, networkDomain,
      hostDomain, endpointId, endpointUrl, tlsPeerDigest] =>
      if !safeToken witnessId || !safeToken keyId || publicKeyPath.isEmpty ||
          !safeToken adminDomain || !safeToken networkDomain || !safeToken hostDomain ||
          !safeToken endpointId || !endpointUrl.startsWith "https://" ||
          tlsPeerDigest.length != 64 then
        none
      else
        some {
          profile := {
            domain := {
              member := { witnessId, keyId }, adminDomain, networkDomain, hostDomain },
            endpointId, endpointUrl, tlsPeerDigest },
          publicKeyPath }
  | _ => none

def parseRuntimeRemotePolicy (text : String) : Option RuntimeRemotePolicy := do
  match text.trim.splitOn "\n" with
  | header :: rows =>
      match header.trim.splitOn "|" with
      | [protocol, versionText, policyId, thresholdText, verifierId,
          verifierKeyId, verifierPublicKeyPath, maxLifetimeText] =>
          if protocol != remotePolicyProtocol || !safeToken policyId ||
              !safeToken verifierId || !safeToken verifierKeyId ||
              verifierPublicKeyPath.isEmpty then none
          let version ← versionText.toNat?
          if version != remoteChallengeProtocolVersion then none
          let threshold ← thresholdText.toNat?
          let maxLifetime ← maxLifetimeText.toNat?
          let profiles ← rows.mapM parseRuntimeProfile
          let remoteProfiles := profiles.map (fun runtime => runtime.profile)
          let domainProfiles := remoteProfiles.map (fun profile => profile.domain)
          let quorum : QuorumPolicy := {
            policyId, threshold,
            members := domainProfiles.map (fun profile => profile.member) }
          let domainPolicy : FaultDomainPolicy := { quorum, profiles := domainProfiles }
          let policy : RemoteWitnessPolicy := {
            domainPolicy, verifierId, verifierKeyId, maxLifetime,
            profiles := remoteProfiles }
          if RemotePolicyWellFormed policy then
            some { policy, verifierPublicKeyPath, profiles }
          else none
      | _ => none
  | _ => none

def readRuntimeRemotePolicy (path : String) : IO (Option RuntimeRemotePolicy) := do
  pure (parseRuntimeRemotePolicy (← IO.FS.readFile path))

private def findRuntimeProfile
    (profiles : List RuntimeRemoteProfile)
    (witnessId keyId : String) : Option RuntimeRemoteProfile :=
  match profiles with
  | [] => none
  | profile :: rest =>
      if profile.profile.domain.member.witnessId == witnessId &&
          profile.profile.domain.member.keyId == keyId then some profile
      else findRuntimeProfile rest witnessId keyId

def encodeChallenge (challenge : ChallengeEnvelope) : String :=
  String.intercalate "|"
    [ challengeProtocol, toString challenge.protocolVersion, challenge.policyId,
      challenge.domainPolicyDigest, challenge.challengeId, challenge.verifierId,
      challenge.verifierKeyId, toString challenge.round,
      toString challenge.issuedAt, toString challenge.expiresAt,
      toString challenge.target.generation, challenge.target.receiptHead,
      challenge.witnessId, challenge.keyId, challenge.endpointId,
      challenge.tlsPeerDigest ] ++ "\n"

def parseChallenge (text : String) : Option ChallengeEnvelope := do
  match text.trim.splitOn "|" with
  | [protocol, versionText, policyId, policyDigest, challengeId, verifierId,
      verifierKeyId, roundText, issuedAtText, expiresAtText, generationText,
      receiptHead, witnessId, keyId, endpointId, tlsPeerDigest] =>
      if protocol != challengeProtocol then none
      let protocolVersion ← versionText.toNat?
      let round ← roundText.toNat?
      let issuedAt ← issuedAtText.toNat?
      let expiresAt ← expiresAtText.toNat?
      let generation ← generationText.toNat?
      some {
        protocolVersion, policyId, domainPolicyDigest := policyDigest, challengeId,
        verifierId, verifierKeyId, round, issuedAt, expiresAt,
        target := LocalAnchor.mk generation receiptHead,
        witnessId, keyId, endpointId, tlsPeerDigest }
  | _ => none

def encodeResponse (response : ResponseEnvelope) : String :=
  String.intercalate "|"
    [ responseProtocol, toString response.protocolVersion, response.policyId,
      response.domainPolicyDigest, response.challengeId, response.challengeDigest,
      toString response.round, response.witnessId, response.keyId,
      response.endpointId, response.tlsPeerDigest, toString response.respondedAt,
      toString response.anchor.generation, response.anchor.receiptHead,
      response.checkpointDigest ] ++ "\n"

def parseResponse (text : String) : Option ResponseEnvelope := do
  match text.trim.splitOn "|" with
  | [protocol, versionText, policyId, policyDigest, challengeId, challengeDigest,
      roundText, witnessId, keyId, endpointId, tlsPeerDigest, respondedAtText,
      generationText, receiptHead, checkpointDigest] =>
      if protocol != responseProtocol then none
      let protocolVersion ← versionText.toNat?
      let round ← roundText.toNat?
      let respondedAt ← respondedAtText.toNat?
      let generation ← generationText.toNat?
      some {
        protocolVersion, policyId, domainPolicyDigest := policyDigest, challengeId,
        challengeDigest, round, witnessId, keyId, endpointId, tlsPeerDigest,
        respondedAt, anchor := LocalAnchor.mk generation receiptHead,
        checkpointDigest }
  | _ => none

def encodeRemoteReceipt (receipt : RemoteResponseReceipt) : String :=
  String.intercalate "|"
    [ remoteReceiptProtocol, toString receipt.protocolVersion, receipt.policyId,
      receipt.challengeId, receipt.challengeDigest, receipt.responseDigest,
      receipt.witnessId, receipt.endpointId, receipt.tlsPeerDigest,
      toString receipt.anchor.generation, receipt.anchor.receiptHead ] ++ "\n"

private def formalChallenge
    (envelope : ChallengeEnvelope)
    (signatureVerified : Bool) : RemoteChallenge := {
  policyId := envelope.policyId,
  domainPolicyDigest := envelope.domainPolicyDigest,
  challengeId := envelope.challengeId,
  verifierId := envelope.verifierId,
  verifierKeyId := envelope.verifierKeyId,
  round := envelope.round,
  issuedAt := envelope.issuedAt,
  expiresAt := envelope.expiresAt,
  target := envelope.target,
  witnessId := envelope.witnessId,
  keyId := envelope.keyId,
  endpointId := envelope.endpointId,
  tlsPeerDigest := envelope.tlsPeerDigest,
  signatureVerified }

private def formalResponse
    (envelope : ResponseEnvelope)
    (signatureVerified : Bool) : RemoteResponse := {
  policyId := envelope.policyId,
  domainPolicyDigest := envelope.domainPolicyDigest,
  challengeId := envelope.challengeId,
  challengeDigest := envelope.challengeDigest,
  round := envelope.round,
  witnessId := envelope.witnessId,
  keyId := envelope.keyId,
  endpointId := envelope.endpointId,
  tlsPeerDigest := envelope.tlsPeerDigest,
  respondedAt := envelope.respondedAt,
  anchor := envelope.anchor,
  checkpointDigest := envelope.checkpointDigest,
  signatureVerified }

def issueSignedChallenge
    (policyPath storePath witnessId : String)
    (round issuedAt lifetime : Nat)
    (challengeId verifierPrivateKey challengePath signaturePath : String) : IO Bool := do
  match (← readRuntimeRemotePolicy policyPath), (← sha256File policyPath),
      (← readAtomicSnapshot storePath) with
  | some runtime, some policyDigest, some snapshot =>
      if round = 0 || challengeId.length != 64 || lifetime = 0 ||
          runtime.policy.maxLifetime < lifetime || policyDigest.length != 64 then
        pure false
      else
        match findRemoteProfile runtime.policy.profiles witnessId with
        | none => pure false
        | some profile =>
            let challenge : ChallengeEnvelope := {
              protocolVersion := remoteChallengeProtocolVersion,
              policyId := runtime.policy.domainPolicy.quorum.policyId,
              domainPolicyDigest := policyDigest, challengeId,
              verifierId := runtime.policy.verifierId,
              verifierKeyId := runtime.policy.verifierKeyId,
              round, issuedAt, expiresAt := issuedAt + lifetime,
              target := anchorOfSnapshot snapshot,
              witnessId := profile.domain.member.witnessId,
              keyId := profile.domain.member.keyId,
              endpointId := profile.endpointId,
              tlsPeerDigest := profile.tlsPeerDigest }
            IO.FS.writeFile challengePath (encodeChallenge challenge)
            signFile verifierPrivateKey challengePath signaturePath
  | _, _, _ => pure false

def writeSignedRemoteResponse
    (policyPath challengePath challengeSignaturePath : String)
    (now : Nat)
    (witnessRoot witnessPrivateKey responsePath responseSignaturePath : String) : IO Bool := do
  match (← readRuntimeRemotePolicy policyPath), (← sha256File policyPath),
      parseChallenge (← IO.FS.readFile challengePath),
      (← sha256File challengePath), (← readWitnessState witnessRoot) with
  | some runtime, some policyDigest, some challenge, some challengeDigest,
      some witness =>
      let challengeSignatureVerified ← verifyFile runtime.verifierPublicKeyPath
        challengePath challengeSignaturePath
      let formal := formalChallenge challenge challengeSignatureVerified
      if challenge.protocolVersion != remoteChallengeProtocolVersion ||
          !decide (ChallengeBound runtime.policy policyDigest challenge.target formal) ||
          !decide (ChallengeFreshAt now formal) then
        pure false
      else
        match findRuntimeProfile runtime.profiles challenge.witnessId challenge.keyId with
        | none => pure false
        | some _ =>
            let response : ResponseEnvelope := {
              protocolVersion := remoteChallengeProtocolVersion,
              policyId := challenge.policyId,
              domainPolicyDigest := challenge.domainPolicyDigest,
              challengeId := challenge.challengeId, challengeDigest,
              round := challenge.round, witnessId := witness.witnessId,
              keyId := challenge.keyId, endpointId := challenge.endpointId,
              tlsPeerDigest := challenge.tlsPeerDigest, respondedAt := now,
              anchor := anchorOfWitness witness,
              checkpointDigest := witness.witnessHead }
            IO.FS.writeFile responsePath (encodeResponse response)
            signFile witnessPrivateKey responsePath responseSignaturePath
  | _, _, _, _, _ => pure false

private def consumedMarker (ledgerPath challengeId : String) : System.FilePath :=
  (ledgerPath : System.FilePath) / challengeId

private def isConsumed (ledgerPath challengeId : String) : IO Bool :=
  (consumedMarker ledgerPath challengeId).pathExists

private def consumeOnce (ledgerPath challengeId : String) : IO Bool := do
  IO.FS.createDirAll ledgerPath
  try
    IO.FS.createDir (consumedMarker ledgerPath challengeId)
    pure true
  catch _ => pure false

inductive RemoteResponseOutcome where
  | verified (receipt : RemoteResponseReceipt)
  | hold (reason : String)
  deriving Repr

def verifyAndConsumeRemoteResponse
    (policyPath storePath challengePath challengeSignaturePath responsePath
      responseSignaturePath ledgerPath receiptPath : String)
    (now : Nat) : IO RemoteResponseOutcome := do
  match (← readRuntimeRemotePolicy policyPath), (← sha256File policyPath),
      (← readAtomicSnapshot storePath),
      parseChallenge (← IO.FS.readFile challengePath),
      (← sha256File challengePath),
      parseResponse (← IO.FS.readFile responsePath),
      (← sha256File responsePath) with
  | some runtime, some policyDigest, some snapshot, some challenge,
      some challengeDigest, some response, some responseDigest =>
      match findRuntimeProfile runtime.profiles response.witnessId response.keyId with
      | none => pure (.hold "unknown remote witness or key")
      | some profile =>
          let challengeSignatureVerified ← verifyFile runtime.verifierPublicKeyPath
            challengePath challengeSignaturePath
          let responseSignatureVerified ← verifyFile profile.publicKeyPath
            responsePath responseSignaturePath
          let consumed ← isConsumed ledgerPath challenge.challengeId
          let consumedIds := if consumed then [challenge.challengeId] else []
          let fChallenge := formalChallenge challenge challengeSignatureVerified
          let fResponse := formalResponse response responseSignatureVerified
          if hFresh : FreshRemoteResponse runtime.policy policyDigest challengeDigest
              (anchorOfSnapshot snapshot) now consumedIds fChallenge fResponse then
            if (← consumeOnce ledgerPath challenge.challengeId) then
              let receipt : RemoteResponseReceipt := {
                protocolVersion := remoteChallengeProtocolVersion,
                policyId := response.policyId, challengeId := response.challengeId,
                challengeDigest, responseDigest, witnessId := response.witnessId,
                endpointId := response.endpointId,
                tlsPeerDigest := response.tlsPeerDigest, anchor := response.anchor }
              IO.FS.writeFile receiptPath (encodeRemoteReceipt receipt)
              pure (.verified receipt)
            else pure (.hold "challenge replay or concurrent consumption")
          else if consumed then pure (.hold "challenge already consumed")
          else if challenge.expiresAt < now then pure (.hold "challenge expired")
          else if now < challenge.issuedAt then pure (.hold "challenge is from the future")
          else if response.endpointId != challenge.endpointId then
            pure (.hold "response endpoint differs from signed challenge")
          else if response.tlsPeerDigest != challenge.tlsPeerDigest then
            pure (.hold "TLS peer digest differs from signed challenge")
          else if challengeSignatureVerified != true then
            pure (.hold "invalid verifier challenge signature")
          else if responseSignatureVerified != true then
            pure (.hold "invalid remote witness response signature")
          else if response.anchor != anchorOfSnapshot snapshot then
            pure (.hold "remote witness anchor conflicts with current target")
          else pure (.hold "response is not bound to this policy, time, challenge or witness")
  | _, _, _, _, _, _, _ => pure (.hold "policy, store, challenge or response parse failed")

end TMI.DigitalLifeRemoteWitnessChallengeRuntime
