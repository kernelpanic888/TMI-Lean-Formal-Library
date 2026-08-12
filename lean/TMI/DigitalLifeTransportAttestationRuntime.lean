import TMI.DigitalLifeTransportAttestation
import TMI.DigitalLifeRemoteWitnessChallengeRuntime

/-! Executable file protocol for I³-L12 independently attested witnesses. -/

namespace TMI.DigitalLifeTransportAttestationRuntime

open TMI.DigitalLifeExternalRollbackWitness
open TMI.DigitalLifeExternalRollbackWitnessRuntime
open TMI.DigitalLifeValidationWireRuntime
open TMI.DigitalLifeRemoteWitnessChallengeRuntime
open TMI.DigitalLifeTransportAttestation

def attestationPolicyProtocol : String := "I3APOL1"
def nodeAttestationProtocol : String := "I3NATT1"
def transportObservationProtocol : String := "I3TOBS1"
def evidenceReceiptProtocol : String := "I3AER1"
def evidenceCertificateProtocol : String := "I3AEC1"

structure RuntimeAttestationProfile where
  profile : AttestationProfile
  attestationPublicKeyPath : String
  observerPublicKeyPath : String
  deriving DecidableEq, Repr

structure RuntimeAttestationPolicy where
  policy : AttestationPolicy
  verifierPublicKeyPath : String
  profiles : List RuntimeAttestationProfile
  deriving DecidableEq, Repr

structure NodeAttestationEnvelope where
  protocolVersion : Nat
  policyId : String
  challengeId : String
  challengeDigest : String
  responseDigest : String
  witnessId : String
  nodeId : String
  custodyDomain : String
  attestationKeyId : String
  endpointId : String
  tlsPeerDigest : String
  bootMeasurement : String
  runtimeDigest : String
  issuedAt : Nat
  expiresAt : Nat
  anchor : LocalAnchor
  deriving DecidableEq, Repr

structure TransportObservationEnvelope where
  protocolVersion : Nat
  policyId : String
  challengeId : String
  challengeDigest : String
  responseDigest : String
  witnessId : String
  observerId : String
  observerCustodyDomain : String
  observerKeyId : String
  endpointId : String
  tlsPeerDigest : String
  observedAt : Nat
  deriving DecidableEq, Repr

structure AttestedEvidenceCertificate where
  protocolVersion : Nat
  policyId : String
  threshold : Nat
  witnessIds : List String
  custodyDomains : List String
  receiptDigests : List String
  deriving DecidableEq, Repr

private def safeToken (value : String) : Bool :=
  !value.isEmpty &&
  !value.toList.any (fun c => c == '|' || c == ',' || c == '\n' || c == '\r')

private def parseRuntimeProfile (line : String) : Option RuntimeAttestationProfile := do
  match line.trim.splitOn "|" with
  | ["NODE", witnessId, nodeId, custodyDomain, attestationKeyId,
      attestationPublicKeyPath, observerId, observerCustodyDomain, observerKeyId,
      observerPublicKeyPath] =>
      if !safeToken witnessId || !safeToken nodeId || !safeToken custodyDomain ||
          !safeToken attestationKeyId || attestationPublicKeyPath.isEmpty ||
          !safeToken observerId || !safeToken observerCustodyDomain ||
          !safeToken observerKeyId || observerPublicKeyPath.isEmpty then none
      else some ({
        profile := {
          witnessId := witnessId
          nodeId := nodeId
          custodyDomain := custodyDomain
          attestationKeyId := attestationKeyId
          observerId := observerId
          observerCustodyDomain := observerCustodyDomain
          observerKeyId := observerKeyId }
        attestationPublicKeyPath := attestationPublicKeyPath
        observerPublicKeyPath := observerPublicKeyPath } : RuntimeAttestationProfile)
  | _ => none

def parseRuntimeAttestationPolicy (text : String) : Option RuntimeAttestationPolicy := do
  match text.trim.splitOn "\n" with
  | header :: rows =>
      match header.trim.splitOn "|" with
      | [protocol, versionText, policyId, verifierKeyId, verifierPublicKeyPath,
          maxLifetimeText] =>
          if protocol != attestationPolicyProtocol || !safeToken policyId ||
              !safeToken verifierKeyId || verifierPublicKeyPath.isEmpty then none
          let version ← versionText.toNat?
          if version != transportAttestationProtocolVersion then none
          let maxLifetime ← maxLifetimeText.toNat?
          let profiles ← rows.mapM parseRuntimeProfile
          let policy : AttestationPolicy := {
            policyId, verifierKeyId, maxLifetime,
            profiles := profiles.map (fun p => p.profile) }
          if AttestationPolicyWellFormed policy then
            some ({
              policy := policy
              verifierPublicKeyPath := verifierPublicKeyPath
              profiles := profiles } : RuntimeAttestationPolicy)
          else none
      | _ => none
  | _ => none

def readRuntimeAttestationPolicy (path : String) : IO (Option RuntimeAttestationPolicy) := do
  pure (parseRuntimeAttestationPolicy (← IO.FS.readFile path))

private def findRuntimeProfile
    (profiles : List RuntimeAttestationProfile)
    (witnessId : String) : Option RuntimeAttestationProfile :=
  match profiles with
  | [] => none
  | profile :: rest =>
      if profile.profile.witnessId == witnessId then some profile
      else findRuntimeProfile rest witnessId

def parseRemoteReceipt (text : String) : Option VerifiedRemoteReceipt := do
  match text.trim.splitOn "|" with
  | [protocol, versionText, policyId, challengeId, challengeDigest, responseDigest,
      witnessId, endpointId, tlsPeerDigest, generationText, receiptHead] =>
      if protocol != remoteReceiptProtocol then none
      let version ← versionText.toNat?
      if version != 1 then none
      let generation ← generationText.toNat?
      some ({
        policyId := policyId
        challengeId := challengeId
        challengeDigest := challengeDigest
        responseDigest := responseDigest
        witnessId := witnessId
        endpointId := endpointId
        tlsPeerDigest := tlsPeerDigest
        anchor := LocalAnchor.mk generation receiptHead } : VerifiedRemoteReceipt)
  | _ => none

def encodeNodeAttestation (a : NodeAttestationEnvelope) : String :=
  String.intercalate "|" [nodeAttestationProtocol, toString a.protocolVersion,
    a.policyId, a.challengeId, a.challengeDigest, a.responseDigest, a.witnessId,
    a.nodeId, a.custodyDomain, a.attestationKeyId, a.endpointId, a.tlsPeerDigest,
    a.bootMeasurement, a.runtimeDigest, toString a.issuedAt, toString a.expiresAt,
    toString a.anchor.generation, a.anchor.receiptHead] ++ "\n"

def parseNodeAttestation (text : String) : Option NodeAttestationEnvelope := do
  match text.trim.splitOn "|" with
  | [protocol, versionText, policyId, challengeId, challengeDigest, responseDigest,
      witnessId, nodeId, custodyDomain, attestationKeyId, endpointId, tlsPeerDigest,
      bootMeasurement, runtimeDigest, issuedText, expiresText, generationText,
      receiptHead] =>
      if protocol != nodeAttestationProtocol then none
      let protocolVersion ← versionText.toNat?
      let issuedAt ← issuedText.toNat?
      let expiresAt ← expiresText.toNat?
      let generation ← generationText.toNat?
      some ({
        protocolVersion := protocolVersion
        policyId := policyId
        challengeId := challengeId
        challengeDigest := challengeDigest
        responseDigest := responseDigest
        witnessId := witnessId
        nodeId := nodeId
        custodyDomain := custodyDomain
        attestationKeyId := attestationKeyId
        endpointId := endpointId
        tlsPeerDigest := tlsPeerDigest
        bootMeasurement := bootMeasurement
        runtimeDigest := runtimeDigest
        issuedAt := issuedAt
        expiresAt := expiresAt
        anchor := LocalAnchor.mk generation receiptHead } : NodeAttestationEnvelope)
  | _ => none

def encodeObservation (o : TransportObservationEnvelope) : String :=
  String.intercalate "|" [transportObservationProtocol, toString o.protocolVersion,
    o.policyId, o.challengeId, o.challengeDigest, o.responseDigest, o.witnessId,
    o.observerId, o.observerCustodyDomain, o.observerKeyId, o.endpointId,
    o.tlsPeerDigest, toString o.observedAt] ++ "\n"

def parseObservation (text : String) : Option TransportObservationEnvelope := do
  match text.trim.splitOn "|" with
  | [protocol, versionText, policyId, challengeId, challengeDigest, responseDigest,
      witnessId, observerId, observerCustodyDomain, observerKeyId, endpointId,
      tlsPeerDigest, observedText] =>
      if protocol != transportObservationProtocol then none
      let protocolVersion ← versionText.toNat?
      let observedAt ← observedText.toNat?
      some ({
        protocolVersion := protocolVersion
        policyId := policyId
        challengeId := challengeId
        challengeDigest := challengeDigest
        responseDigest := responseDigest
        witnessId := witnessId
        observerId := observerId
        observerCustodyDomain := observerCustodyDomain
        observerKeyId := observerKeyId
        endpointId := endpointId
        tlsPeerDigest := tlsPeerDigest
        observedAt := observedAt } : TransportObservationEnvelope)
  | _ => none

def encodeEvidenceReceipt (r : AttestedEvidenceReceipt) : String :=
  String.intercalate "|" [evidenceReceiptProtocol,
    toString transportAttestationProtocolVersion, r.policyId, r.verifierKeyId,
    r.witnessId, r.nodeId, r.custodyDomain, r.observerId,
    r.observerCustodyDomain, r.challengeId, r.challengeDigest, r.responseDigest,
    r.attestationDigest, r.observationDigest, toString r.anchor.generation,
    r.anchor.receiptHead] ++ "\n"

def parseEvidenceReceipt (text : String) : Option AttestedEvidenceReceipt := do
  match text.trim.splitOn "|" with
  | [protocol, versionText, policyId, verifierKeyId, witnessId, nodeId,
      custodyDomain, observerId, observerCustodyDomain, challengeId,
      challengeDigest, responseDigest, attestationDigest, observationDigest,
      generationText, receiptHead] =>
      if protocol != evidenceReceiptProtocol then none
      let version ← versionText.toNat?
      if version != transportAttestationProtocolVersion then none
      let generation ← generationText.toNat?
      some ({
        policyId := policyId
        verifierKeyId := verifierKeyId
        witnessId := witnessId
        nodeId := nodeId
        custodyDomain := custodyDomain
        observerId := observerId
        observerCustodyDomain := observerCustodyDomain
        challengeId := challengeId
        challengeDigest := challengeDigest
        responseDigest := responseDigest
        attestationDigest := attestationDigest
        observationDigest := observationDigest
        anchor := LocalAnchor.mk generation receiptHead
        signatureVerified := false } : AttestedEvidenceReceipt)
  | _ => none

private def formalAttestation (a : NodeAttestationEnvelope) (verified : Bool) : NodeAttestation :=
  { policyId := a.policyId, challengeId := a.challengeId,
    challengeDigest := a.challengeDigest, responseDigest := a.responseDigest,
    witnessId := a.witnessId, nodeId := a.nodeId, custodyDomain := a.custodyDomain,
    attestationKeyId := a.attestationKeyId, endpointId := a.endpointId,
    tlsPeerDigest := a.tlsPeerDigest, bootMeasurement := a.bootMeasurement,
    runtimeDigest := a.runtimeDigest, issuedAt := a.issuedAt, expiresAt := a.expiresAt,
    anchor := a.anchor, signatureVerified := verified }

private def formalObservation (o : TransportObservationEnvelope) (verified : Bool) : TransportObservation :=
  { policyId := o.policyId, challengeId := o.challengeId,
    challengeDigest := o.challengeDigest, responseDigest := o.responseDigest,
    witnessId := o.witnessId, observerId := o.observerId,
    observerCustodyDomain := o.observerCustodyDomain, observerKeyId := o.observerKeyId,
    endpointId := o.endpointId, tlsPeerDigest := o.tlsPeerDigest,
    observedAt := o.observedAt, signatureVerified := verified }

def writeNodeAttestation (policyPath remoteReceiptPath : String)
    (issuedAt lifetime : Nat) (bootMeasurement runtimeDigest privateKey output sig : String) : IO Bool := do
  match (← readRuntimeAttestationPolicy policyPath),
      parseRemoteReceipt (← IO.FS.readFile remoteReceiptPath) with
  | some runtime, some remote =>
      match findRuntimeProfile runtime.profiles remote.witnessId with
      | none => pure false
      | some profile =>
          if lifetime = 0 || runtime.policy.maxLifetime < lifetime ||
              bootMeasurement.length != 64 || runtimeDigest.length != 64 then pure false
          else
            let a : NodeAttestationEnvelope := {
              protocolVersion := transportAttestationProtocolVersion,
              policyId := runtime.policy.policyId, challengeId := remote.challengeId,
              challengeDigest := remote.challengeDigest, responseDigest := remote.responseDigest,
              witnessId := remote.witnessId, nodeId := profile.profile.nodeId,
              custodyDomain := profile.profile.custodyDomain,
              attestationKeyId := profile.profile.attestationKeyId,
              endpointId := remote.endpointId, tlsPeerDigest := remote.tlsPeerDigest,
              bootMeasurement, runtimeDigest, issuedAt, expiresAt := issuedAt + lifetime,
              anchor := remote.anchor }
            IO.FS.writeFile output (encodeNodeAttestation a)
            signFile privateKey output sig
  | _, _ => pure false

def writeTransportObservation (policyPath remoteReceiptPath : String)
    (observedAt : Nat) (privateKey output sig : String) : IO Bool := do
  match (← readRuntimeAttestationPolicy policyPath),
      parseRemoteReceipt (← IO.FS.readFile remoteReceiptPath) with
  | some runtime, some remote =>
      match findRuntimeProfile runtime.profiles remote.witnessId with
      | none => pure false
      | some profile =>
          let o : TransportObservationEnvelope := {
            protocolVersion := transportAttestationProtocolVersion,
            policyId := runtime.policy.policyId, challengeId := remote.challengeId,
            challengeDigest := remote.challengeDigest, responseDigest := remote.responseDigest,
            witnessId := remote.witnessId, observerId := profile.profile.observerId,
            observerCustodyDomain := profile.profile.observerCustodyDomain,
            observerKeyId := profile.profile.observerKeyId,
            endpointId := remote.endpointId, tlsPeerDigest := remote.tlsPeerDigest,
            observedAt }
          IO.FS.writeFile output (encodeObservation o)
          signFile privateKey output sig
  | _, _ => pure false

inductive AttestationOutcome where
  | verified (receipt : AttestedEvidenceReceipt)
  | hold (reason : String)
  deriving Repr

def verifyAttestedEvidence (policyPath remoteReceiptPath attestationPath
    attestationSig observationPath observationSig verifierPrivateKey receiptPath
    receiptSig : String) (now : Nat) : IO AttestationOutcome := do
  match (← readRuntimeAttestationPolicy policyPath),
      parseRemoteReceipt (← IO.FS.readFile remoteReceiptPath),
      parseNodeAttestation (← IO.FS.readFile attestationPath),
      (← sha256File attestationPath),
      parseObservation (← IO.FS.readFile observationPath),
      (← sha256File observationPath) with
  | some runtime, some remote, some a, some aDigest, some o, some oDigest =>
      match findRuntimeProfile runtime.profiles remote.witnessId with
      | none => pure (.hold "unknown attestation profile")
      | some profile =>
          let aVerified ← verifyFile profile.attestationPublicKeyPath attestationPath attestationSig
          let oVerified ← verifyFile profile.observerPublicKeyPath observationPath observationSig
          let fa := formalAttestation a aVerified
          let fo := formalObservation o oVerified
          if IndependentlyAttestedNode runtime.policy remote now fa fo then
            let receipt : AttestedEvidenceReceipt := {
              policyId := runtime.policy.policyId, verifierKeyId := runtime.policy.verifierKeyId,
              witnessId := remote.witnessId, nodeId := profile.profile.nodeId,
              custodyDomain := profile.profile.custodyDomain,
              observerId := profile.profile.observerId,
              observerCustodyDomain := profile.profile.observerCustodyDomain,
              challengeId := remote.challengeId, challengeDigest := remote.challengeDigest,
              responseDigest := remote.responseDigest, attestationDigest := aDigest,
              observationDigest := oDigest, anchor := remote.anchor,
              signatureVerified := true }
            IO.FS.writeFile receiptPath (encodeEvidenceReceipt receipt)
            if (← signFile verifierPrivateKey receiptPath receiptSig) then pure (.verified receipt)
            else pure (.hold "verifier could not sign evidence receipt")
          else if aVerified != true then pure (.hold "invalid node attestation signature")
          else if oVerified != true then pure (.hold "invalid transport observer signature")
          else if a.expiresAt < now then pure (.hold "node attestation expired")
          else if a.endpointId != remote.endpointId || o.endpointId != remote.endpointId then
            pure (.hold "endpoint binding changed")
          else if a.tlsPeerDigest != remote.tlsPeerDigest || o.tlsPeerDigest != remote.tlsPeerDigest then
            pure (.hold "TLS peer binding changed")
          else pure (.hold "evidence is not bound to this response, node, custody, time or observer")
  | _, _, _, _, _, _ => pure (.hold "policy, remote receipt, attestation or observation parse failed")

private def collectReceipts (runtime : RuntimeAttestationPolicy) (dir : String) :
    IO (Except String (List (AttestedEvidenceReceipt × String))) := do
  let entries ← (dir : System.FilePath).readDir
  let mut receipts : List (AttestedEvidenceReceipt × String) := []
  for entry in entries do
    if entry.fileName.endsWith ".i3ae" then
      match parseEvidenceReceipt (← IO.FS.readFile entry.path),
          (← sha256File entry.path.toString) with
      | some receipt, some digest =>
          let verified ← verifyFile runtime.verifierPublicKeyPath entry.path.toString
            (entry.path.toString ++ ".sig")
          receipts := ({ receipt with signatureVerified := verified }, digest) :: receipts
      | _, _ => return .error s!"receipt parse failed: {entry.fileName}"
  pure (.ok receipts.reverse)

def encodeEvidenceCertificate (c : AttestedEvidenceCertificate) : String :=
  String.intercalate "|" [evidenceCertificateProtocol,
    toString c.protocolVersion, c.policyId, toString c.threshold,
    String.intercalate "," c.witnessIds, String.intercalate "," c.custodyDomains,
    String.intercalate "," c.receiptDigests] ++ "\n"

inductive AttestedQuorumOutcome where
  | admitted (certificate : AttestedEvidenceCertificate)
  | hold (reason : String)
  deriving Repr

def evaluateAttestedQuorum (policyPath receiptDir certificatePath : String)
    (threshold : Nat) : IO AttestedQuorumOutcome := do
  match (← readRuntimeAttestationPolicy policyPath) with
  | none => pure (.hold "attestation policy parse failed")
  | some runtime =>
      match (← collectReceipts runtime receiptDir) with
      | .error reason => pure (.hold reason)
      | .ok paired =>
          let receipts := paired.map (fun p => p.1)
          if IndependentAttestedReceiptSet runtime.policy threshold receipts then
            let certificate : AttestedEvidenceCertificate := {
              protocolVersion := transportAttestationProtocolVersion,
              policyId := runtime.policy.policyId, threshold,
              witnessIds := receipts.map (fun r => r.witnessId),
              custodyDomains := receipts.map (fun r => r.custodyDomain),
              receiptDigests := paired.map (fun p => p.2) }
            IO.FS.writeFile certificatePath (encodeEvidenceCertificate certificate)
            pure (.admitted certificate)
          else if receipts.length < threshold then pure (.hold "insufficient attested quorum")
          else if !(decide (receipts.map (fun r => r.witnessId)).Nodup) then
            pure (.hold "duplicate witness receipt")
          else if !(decide (receipts.map (fun r => r.custodyDomain)).Nodup) then
            pure (.hold "shared key custody domain")
          else if receipts.any (fun r => r.signatureVerified != true) then
            pure (.hold "invalid verifier evidence signature")
          else pure (.hold "attested quorum violates node, observer or digest binding")

end TMI.DigitalLifeTransportAttestationRuntime
