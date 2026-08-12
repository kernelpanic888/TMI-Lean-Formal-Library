import TMI.DigitalLifeTrustedPlatformEnrollment
import TMI.DigitalLifeRemoteWitnessChallenge
import TMI.DigitalLifeTransportAttestation
import TMI.DigitalLifeHardwareAttestation
import TMI.DigitalLifeFaultDomainQuorum

/-!
# I³-L16: Independent Remote Hardware Admission

This layer does not implement cryptography or hardware attestation. It composes
the independently verified receipts produced by the lower I³ layers into one
fail-closed admission decision.
-/

namespace TMI.DigitalLifeIndependentHardwareAdmission

structure AdmissionPolicy where
  protocol : String := "I3IRHAP1"
  version : Nat := 1
  policyId : String
  expectedL15PolicyDigest : String
  expectedL14ReceiptDigest : String
  expectedPlatformProfileDigest : String
  expectedTransportProfileDigest : String
  expectedChallengeDomain : String
  expectedTlsPeerDigest : String
  expectedMeasurementPolicyDigest : String
  expectedWitnessPolicyDigest : String
  minIndependentWitnesses : Nat
  minFaultDomains : Nat
  maxEvidenceAge : Nat
  deriving DecidableEq, Repr

structure AdmissionEvidence where
  protocol : String := "I3IRHAE1"
  version : Nat := 1
  policyId : String
  l15PolicyDigest : String
  l14ReceiptDigest : String
  platformProfileDigest : String
  transportProfileDigest : String
  challengeDomain : String
  tlsPeerDigest : String
  measurementPolicyDigest : String
  witnessPolicyDigest : String
  observedAt : Nat
  witnessCount : Nat
  faultDomainCount : Nat
  l15EnrollmentReady : Bool
  localHardwarePass : Bool
  freshRemoteChallenge : Bool
  remoteResponseSignatureValid : Bool
  transportAttestationValid : Bool
  platformQuoteChainTrusted : Bool
  measurementsAccepted : Bool
  splitCustodyApproved : Bool
  witnessSignaturesValid : Bool
  faultDomainQuorumIndependent : Bool
  deriving DecidableEq, Repr

def Digest64 (value : String) : Prop := value.length = 64

def PolicyWellFormed (p : AdmissionPolicy) : Prop :=
  p.protocol = "I3IRHAP1" ∧
  p.version = 1 ∧
  p.policyId ≠ "" ∧
  Digest64 p.expectedL15PolicyDigest ∧
  Digest64 p.expectedL14ReceiptDigest ∧
  Digest64 p.expectedPlatformProfileDigest ∧
  Digest64 p.expectedTransportProfileDigest ∧
  p.expectedChallengeDomain ≠ "" ∧
  Digest64 p.expectedTlsPeerDigest ∧
  Digest64 p.expectedMeasurementPolicyDigest ∧
  Digest64 p.expectedWitnessPolicyDigest ∧
  1 < p.minIndependentWitnesses ∧
  1 < p.minFaultDomains ∧
  0 < p.maxEvidenceAge

def IndependentHardwareAdmitted
    (p : AdmissionPolicy) (e : AdmissionEvidence) (now : Nat) : Prop :=
  PolicyWellFormed p ∧
  e.protocol = "I3IRHAE1" ∧
  e.version = 1 ∧
  e.policyId = p.policyId ∧
  e.l15PolicyDigest = p.expectedL15PolicyDigest ∧
  e.l14ReceiptDigest = p.expectedL14ReceiptDigest ∧
  e.platformProfileDigest = p.expectedPlatformProfileDigest ∧
  e.transportProfileDigest = p.expectedTransportProfileDigest ∧
  e.challengeDomain = p.expectedChallengeDomain ∧
  e.tlsPeerDigest = p.expectedTlsPeerDigest ∧
  e.measurementPolicyDigest = p.expectedMeasurementPolicyDigest ∧
  e.witnessPolicyDigest = p.expectedWitnessPolicyDigest ∧
  e.observedAt ≤ now ∧
  now - e.observedAt ≤ p.maxEvidenceAge ∧
  p.minIndependentWitnesses ≤ e.witnessCount ∧
  p.minFaultDomains ≤ e.faultDomainCount ∧
  e.l15EnrollmentReady = true ∧
  e.localHardwarePass = true ∧
  e.freshRemoteChallenge = true ∧
  e.remoteResponseSignatureValid = true ∧
  e.transportAttestationValid = true ∧
  e.platformQuoteChainTrusted = true ∧
  e.measurementsAccepted = true ∧
  e.splitCustodyApproved = true ∧
  e.witnessSignaturesValid = true ∧
  e.faultDomainQuorumIndependent = true

instance (p : AdmissionPolicy) : Decidable (PolicyWellFormed p) := by
  unfold PolicyWellFormed Digest64
  infer_instance
instance (p : AdmissionPolicy) (e : AdmissionEvidence) (now : Nat) :
    Decidable (IndependentHardwareAdmitted p e now) := by
  unfold IndependentHardwareAdmitted
  infer_instance

inductive AdmissionStatus where
  | hold
  | globalHardwareAdmitted
  deriving DecidableEq, Repr

def evaluate (p : AdmissionPolicy) (e : AdmissionEvidence) (now : Nat) : AdmissionStatus :=
  if IndependentHardwareAdmitted p e now then
    .globalHardwareAdmitted
  else
    .hold

theorem admitted_iff (p : AdmissionPolicy) (e : AdmissionEvidence) (now : Nat) :
    evaluate p e now = .globalHardwareAdmitted ↔ IndependentHardwareAdmitted p e now := by
  simp [evaluate]

theorem exact_stack_admits
    (p : AdmissionPolicy) (e : AdmissionEvidence) (now : Nat)
    (h : IndependentHardwareAdmitted p e now) :
    evaluate p e now = .globalHardwareAdmitted := by
  exact (admitted_iff p e now).2 h

theorem rejected_stack_holds
    (p : AdmissionPolicy) (e : AdmissionEvidence) (now : Nat)
    (h : ¬ IndependentHardwareAdmitted p e now) :
    evaluate p e now = .hold := by
  simp [evaluate, h]

theorem admission_carries_every_gate
    (p : AdmissionPolicy) (e : AdmissionEvidence) (now : Nat)
    (h : evaluate p e now = .globalHardwareAdmitted) :
    IndependentHardwareAdmitted p e now := by
  exact (admitted_iff p e now).1 h

theorem invalid_remote_signature_holds
    (p : AdmissionPolicy) (e : AdmissionEvidence) (now : Nat)
    (h : e.remoteResponseSignatureValid = false) :
    evaluate p e now = .hold := by
  apply rejected_stack_holds
  intro admitted
  simp [IndependentHardwareAdmitted, h] at admitted

theorem shared_fault_domain_holds
    (p : AdmissionPolicy) (e : AdmissionEvidence) (now : Nat)
    (h : e.faultDomainQuorumIndependent = false) :
    evaluate p e now = .hold := by
  apply rejected_stack_holds
  intro admitted
  simp [IndependentHardwareAdmitted, h] at admitted

theorem missing_local_hardware_receipt_holds
    (p : AdmissionPolicy) (e : AdmissionEvidence) (now : Nat)
    (h : e.localHardwarePass = false) :
    evaluate p e now = .hold := by
  apply rejected_stack_holds
  intro admitted
  simp [IndependentHardwareAdmitted, h] at admitted

end TMI.DigitalLifeIndependentHardwareAdmission
