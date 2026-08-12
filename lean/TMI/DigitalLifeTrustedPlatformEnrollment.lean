import TMI.DigitalLifePhysicalHardwareChallenge

/-!
# I³-L15: trusted platform enrollment

L15 authorizes the *next hardware probe*.  It does not claim that a hardware
operation succeeded.  Admission requires one exact intersection of the L14
policy digest, Apple signing team, signing identifier, designated requirement,
provisioning profile, effective entitlements, keychain group and helper binary.

This keeps code identity distinct from code-signing identity and prevents any
single self-declared field from opening the physical boundary.
-/

namespace TMI.DigitalLifeTrustedPlatformEnrollment

def trustedEnrollmentProtocolVersion : Nat := 1

structure TrustedEnrollmentPolicy where
  policyId : String
  expectedL14PolicyDigest : String
  expectedTeamIdentifier : String
  expectedSigningIdentifier : String
  expectedDesignatedRequirementDigest : String
  expectedProvisioningProfileDigest : String
  expectedEntitlementsDigest : String
  expectedKeychainGroup : String
  expectedHelperDigest : String
  maxObservationAge : Nat
  deriving DecidableEq, Repr

structure PlatformEnrollmentObservation where
  policyId : String
  l14PolicyDigest : String
  teamIdentifier : String
  signingIdentifier : String
  designatedRequirementDigest : String
  provisioningProfileDigest : String
  entitlementsDigest : String
  keychainGroup : String
  helperDigest : String
  observedAt : Nat
  appleChainValidated : Bool
  signatureValid : Bool
  profileAuthorizesEntitlements : Bool
  effectiveEntitlementsMatch : Bool
  hardenedRuntimeEnabled : Bool
  deriving DecidableEq, Repr

inductive EnrollmentStatus where
  | hold
  | readyForHardwareProbe
  deriving DecidableEq, Repr

def TrustedEnrollmentPolicyWellFormed (policy : TrustedEnrollmentPolicy) : Prop :=
  policy.policyId != "" ∧
  policy.expectedL14PolicyDigest.length = 64 ∧
  policy.expectedTeamIdentifier != "" ∧
  policy.expectedSigningIdentifier != "" ∧
  policy.expectedDesignatedRequirementDigest.length = 64 ∧
  policy.expectedProvisioningProfileDigest.length = 64 ∧
  policy.expectedEntitlementsDigest.length = 64 ∧
  policy.expectedKeychainGroup != "" ∧
  policy.expectedHelperDigest.length = 64 ∧
  0 < policy.maxObservationAge

instance (policy : TrustedEnrollmentPolicy) :
    Decidable (TrustedEnrollmentPolicyWellFormed policy) := by
  unfold TrustedEnrollmentPolicyWellFormed
  infer_instance

def TrustedPlatformEnrolled
    (policy : TrustedEnrollmentPolicy)
    (now : Nat)
    (observation : PlatformEnrollmentObservation) : Prop :=
  TrustedEnrollmentPolicyWellFormed policy ∧
  observation.policyId = policy.policyId ∧
  observation.l14PolicyDigest = policy.expectedL14PolicyDigest ∧
  observation.teamIdentifier = policy.expectedTeamIdentifier ∧
  observation.signingIdentifier = policy.expectedSigningIdentifier ∧
  observation.designatedRequirementDigest =
    policy.expectedDesignatedRequirementDigest ∧
  observation.provisioningProfileDigest =
    policy.expectedProvisioningProfileDigest ∧
  observation.entitlementsDigest = policy.expectedEntitlementsDigest ∧
  observation.keychainGroup = policy.expectedKeychainGroup ∧
  observation.helperDigest = policy.expectedHelperDigest ∧
  observation.observedAt ≤ now ∧
  now - observation.observedAt ≤ policy.maxObservationAge ∧
  observation.appleChainValidated = true ∧
  observation.signatureValid = true ∧
  observation.profileAuthorizesEntitlements = true ∧
  observation.effectiveEntitlementsMatch = true ∧
  observation.hardenedRuntimeEnabled = true

instance (policy : TrustedEnrollmentPolicy) (now : Nat)
    (observation : PlatformEnrollmentObservation) :
    Decidable (TrustedPlatformEnrolled policy now observation) := by
  unfold TrustedPlatformEnrolled
  infer_instance

def evaluateEnrollment
    (policy : TrustedEnrollmentPolicy)
    (now : Nat)
    (observation : PlatformEnrollmentObservation) : EnrollmentStatus :=
  if TrustedPlatformEnrolled policy now observation then
    .readyForHardwareProbe
  else .hold

theorem exact_enrollment_authorizes_probe
    (h : TrustedPlatformEnrolled policy now observation) :
    evaluateEnrollment policy now observation = .readyForHardwareProbe := by
  simp [evaluateEnrollment, h]

theorem rejected_enrollment_holds
    (h : ¬ TrustedPlatformEnrolled policy now observation) :
    evaluateEnrollment policy now observation = .hold := by
  simp [evaluateEnrollment, h]

theorem ready_implies_exact_enrollment
    (h : evaluateEnrollment policy now observation = .readyForHardwareProbe) :
    TrustedPlatformEnrolled policy now observation := by
  unfold evaluateEnrollment at h
  split at h <;> simp_all

theorem one_failed_gate_prevents_probe
    (h : observation.signatureValid = false) :
    evaluateEnrollment policy now observation = .hold := by
  apply rejected_enrollment_holds
  intro enrolled
  unfold TrustedPlatformEnrolled at enrolled
  simp_all

end TMI.DigitalLifeTrustedPlatformEnrollment
