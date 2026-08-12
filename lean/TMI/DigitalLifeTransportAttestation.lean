import TMI.DigitalLifeRemoteWitnessChallenge

/-!
# I³-L12: independently attested multi-host witnesses

L11 proves that a fresh response is bound to a challenge and a pinned transport
identity.  L12 adds two independently signed views of that same response: a
node-state attestation from a separately held key and a transport observation
from a different custody domain.  A label alone is never evidence.

The formal layer reasons over verified signatures and measurements.  It does
not prove that a measurement was produced by genuine hardware, that operators
are honest, or that two declared custody domains are physically independent.
-/

namespace TMI.DigitalLifeTransportAttestation

open TMI.DigitalLifeExternalRollbackWitness
open TMI.DigitalLifeRemoteWitnessChallenge

def transportAttestationProtocolVersion : Nat := 1

structure AttestationProfile where
  witnessId : String
  nodeId : String
  custodyDomain : String
  attestationKeyId : String
  observerId : String
  observerCustodyDomain : String
  observerKeyId : String
  deriving DecidableEq, Repr

structure AttestationPolicy where
  policyId : String
  verifierKeyId : String
  maxLifetime : Nat
  profiles : List AttestationProfile
  deriving DecidableEq, Repr

structure VerifiedRemoteReceipt where
  policyId : String
  challengeId : String
  challengeDigest : String
  responseDigest : String
  witnessId : String
  endpointId : String
  tlsPeerDigest : String
  anchor : LocalAnchor
  deriving DecidableEq, Repr

structure NodeAttestation where
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
  signatureVerified : Bool
  deriving DecidableEq, Repr

structure TransportObservation where
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
  signatureVerified : Bool
  deriving DecidableEq, Repr

structure AttestedEvidenceReceipt where
  policyId : String
  verifierKeyId : String
  witnessId : String
  nodeId : String
  custodyDomain : String
  observerId : String
  observerCustodyDomain : String
  challengeId : String
  challengeDigest : String
  responseDigest : String
  attestationDigest : String
  observationDigest : String
  anchor : LocalAnchor
  signatureVerified : Bool
  deriving DecidableEq, Repr

def findAttestationProfile
    (profiles : List AttestationProfile)
    (witnessId : String) : Option AttestationProfile :=
  match profiles with
  | [] => none
  | profile :: rest =>
      if profile.witnessId == witnessId then some profile
      else findAttestationProfile rest witnessId

def AttestationPolicyWellFormed (policy : AttestationPolicy) : Prop :=
  policy.policyId ≠ "" ∧
  policy.verifierKeyId ≠ "" ∧
  0 < policy.maxLifetime ∧
  (policy.profiles.map (fun p => p.witnessId)).Nodup ∧
  (policy.profiles.map (fun p => p.nodeId)).Nodup ∧
  (policy.profiles.map (fun p => p.custodyDomain)).Nodup ∧
  (policy.profiles.map (fun p => p.attestationKeyId)).Nodup ∧
  (policy.profiles.map (fun p => p.observerId)).Nodup ∧
  (policy.profiles.map (fun p => p.observerKeyId)).Nodup ∧
  ∀ profile ∈ policy.profiles,
    profile.witnessId ≠ "" ∧ profile.nodeId ≠ "" ∧
    profile.custodyDomain ≠ "" ∧ profile.attestationKeyId ≠ "" ∧
    profile.observerId ≠ "" ∧ profile.observerCustodyDomain ≠ "" ∧
    profile.observerKeyId ≠ "" ∧
    profile.custodyDomain ≠ profile.observerCustodyDomain

instance (policy : AttestationPolicy) : Decidable (AttestationPolicyWellFormed policy) := by
  unfold AttestationPolicyWellFormed
  infer_instance

def NodeAttestationBound
    (policy : AttestationPolicy)
    (profile : AttestationProfile)
    (remote : VerifiedRemoteReceipt)
    (now : Nat)
    (attestation : NodeAttestation) : Prop :=
  attestation.signatureVerified = true ∧
  attestation.policyId = policy.policyId ∧
  attestation.challengeId = remote.challengeId ∧
  attestation.challengeDigest = remote.challengeDigest ∧
  attestation.responseDigest = remote.responseDigest ∧
  attestation.witnessId = remote.witnessId ∧
  attestation.nodeId = profile.nodeId ∧
  attestation.custodyDomain = profile.custodyDomain ∧
  attestation.attestationKeyId = profile.attestationKeyId ∧
  attestation.endpointId = remote.endpointId ∧
  attestation.tlsPeerDigest = remote.tlsPeerDigest ∧
  attestation.bootMeasurement.length = 64 ∧
  attestation.runtimeDigest.length = 64 ∧
  attestation.issuedAt ≤ now ∧ now ≤ attestation.expiresAt ∧
  attestation.issuedAt < attestation.expiresAt ∧
  attestation.expiresAt - attestation.issuedAt ≤ policy.maxLifetime ∧
  attestation.anchor = remote.anchor

instance (policy : AttestationPolicy) (profile : AttestationProfile)
    (remote : VerifiedRemoteReceipt) (now : Nat) (attestation : NodeAttestation) :
    Decidable (NodeAttestationBound policy profile remote now attestation) := by
  unfold NodeAttestationBound
  infer_instance

def TransportObservationBound
    (policy : AttestationPolicy)
    (profile : AttestationProfile)
    (remote : VerifiedRemoteReceipt)
    (attestation : NodeAttestation)
    (now : Nat)
    (observation : TransportObservation) : Prop :=
  observation.signatureVerified = true ∧
  observation.policyId = policy.policyId ∧
  observation.challengeId = remote.challengeId ∧
  observation.challengeDigest = remote.challengeDigest ∧
  observation.responseDigest = remote.responseDigest ∧
  observation.witnessId = remote.witnessId ∧
  observation.observerId = profile.observerId ∧
  observation.observerCustodyDomain = profile.observerCustodyDomain ∧
  observation.observerKeyId = profile.observerKeyId ∧
  observation.endpointId = remote.endpointId ∧
  observation.tlsPeerDigest = remote.tlsPeerDigest ∧
  attestation.issuedAt ≤ observation.observedAt ∧
  observation.observedAt ≤ now ∧
  observation.observedAt ≤ attestation.expiresAt ∧
  profile.custodyDomain ≠ profile.observerCustodyDomain

instance (policy : AttestationPolicy) (profile : AttestationProfile)
    (remote : VerifiedRemoteReceipt) (attestation : NodeAttestation)
    (now : Nat) (observation : TransportObservation) :
    Decidable (TransportObservationBound policy profile remote attestation now observation) := by
  unfold TransportObservationBound
  infer_instance

def IndependentlyAttestedNode
    (policy : AttestationPolicy)
    (remote : VerifiedRemoteReceipt)
    (now : Nat)
    (attestation : NodeAttestation)
    (observation : TransportObservation) : Prop :=
  AttestationPolicyWellFormed policy ∧
  ∃ profile ∈ policy.profiles,
    profile.witnessId = remote.witnessId ∧
    NodeAttestationBound policy profile remote now attestation ∧
    TransportObservationBound policy profile remote attestation now observation

instance (policy : AttestationPolicy) (remote : VerifiedRemoteReceipt)
    (now : Nat) (attestation : NodeAttestation) (observation : TransportObservation) :
    Decidable (IndependentlyAttestedNode policy remote now attestation observation) := by
  unfold IndependentlyAttestedNode
  infer_instance

def attestedNodeAdmitOrHold
    (policy : AttestationPolicy)
    (remote : VerifiedRemoteReceipt)
    (now : Nat)
    (attestation : NodeAttestation)
    (observation : TransportObservation) : Option VerifiedRemoteReceipt :=
  if IndependentlyAttestedNode policy remote now attestation observation then
    some remote
  else none

def IndependentAttestedReceiptSet
    (policy : AttestationPolicy)
    (threshold : Nat)
    (receipts : List AttestedEvidenceReceipt) : Prop :=
  AttestationPolicyWellFormed policy ∧
  0 < threshold ∧ threshold ≤ receipts.length ∧
  (receipts.map (fun r => r.witnessId)).Nodup ∧
  (receipts.map (fun r => r.nodeId)).Nodup ∧
  (receipts.map (fun r => r.custodyDomain)).Nodup ∧
  (receipts.map (fun r => r.observerId)).Nodup ∧
  (∀ receipt ∈ receipts,
    receipt.signatureVerified = true ∧
    receipt.policyId = policy.policyId ∧
    receipt.verifierKeyId = policy.verifierKeyId ∧
    receipt.challengeDigest.length = 64 ∧ receipt.responseDigest.length = 64 ∧
    receipt.attestationDigest.length = 64 ∧ receipt.observationDigest.length = 64 ∧
    receipt.custodyDomain ≠ receipt.observerCustodyDomain)

instance (policy : AttestationPolicy) (threshold : Nat)
    (receipts : List AttestedEvidenceReceipt) :
    Decidable (IndependentAttestedReceiptSet policy threshold receipts) := by
  unfold IndependentAttestedReceiptSet
  infer_instance

def attestedQuorumAdmitOrHold
    (policy : AttestationPolicy)
    (threshold : Nat)
    (receipts : List AttestedEvidenceReceipt) : Option (List String) :=
  if IndependentAttestedReceiptSet policy threshold receipts then
    some (receipts.map (fun receipt => receipt.witnessId))
  else none

theorem independently_attested_node_admits
    (h : IndependentlyAttestedNode policy remote now attestation observation) :
    attestedNodeAdmitOrHold policy remote now attestation observation = some remote := by
  simp [attestedNodeAdmitOrHold, h]

theorem unsigned_attestation_holds
    (h : attestation.signatureVerified = false) :
    attestedNodeAdmitOrHold policy remote now attestation observation = none := by
  apply if_neg
  rintro ⟨_, profile, _, _, hAttestation, _⟩
  exact Bool.noConfusion (hAttestation.1.symm.trans h)

theorem unsigned_observation_holds
    (h : observation.signatureVerified = false) :
    attestedNodeAdmitOrHold policy remote now attestation observation = none := by
  apply if_neg
  rintro ⟨_, profile, _, _, _, hObservation⟩
  exact Bool.noConfusion (hObservation.1.symm.trans h)

theorem same_custody_observer_holds
    (h : profile.custodyDomain = profile.observerCustodyDomain)
    (hProfile : profile ∈ policy.profiles)
    (hWitness : profile.witnessId = remote.witnessId)
    (hUnique : ∀ candidate ∈ policy.profiles,
      candidate.witnessId = remote.witnessId → candidate = profile) :
    attestedNodeAdmitOrHold policy remote now attestation observation = none := by
  apply if_neg
  rintro ⟨_, candidate, hCandidate, hCandidateWitness, _, hObservation⟩
  have hc : candidate = profile := hUnique candidate hCandidate hCandidateWitness
  subst candidate
  rcases hObservation with ⟨_, _, _, _, _, _, _, _, _, _, _, _, _, _, hDifferent⟩
  exact hDifferent h

theorem independently_attested_quorum_admits
    (h : IndependentAttestedReceiptSet policy threshold receipts) :
    attestedQuorumAdmitOrHold policy threshold receipts =
      some (receipts.map (fun receipt => receipt.witnessId)) := by
  simp [attestedQuorumAdmitOrHold, h]

theorem duplicate_custody_quorum_holds
    (h : ¬(receipts.map (fun r => r.custodyDomain)).Nodup) :
    attestedQuorumAdmitOrHold policy threshold receipts = none := by
  apply if_neg
  intro ready
  exact h ready.2.2.2.2.2.1

theorem insufficient_attested_quorum_holds
    (h : receipts.length < threshold) :
    attestedQuorumAdmitOrHold policy threshold receipts = none := by
  apply if_neg
  intro ready
  exact (Nat.not_le_of_lt h) ready.2.2.1

end TMI.DigitalLifeTransportAttestation
