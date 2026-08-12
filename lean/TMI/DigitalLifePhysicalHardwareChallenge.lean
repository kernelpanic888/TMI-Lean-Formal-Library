import TMI.DigitalLifeHardwareAttestation

/-!
# I³-L14: physical hardware challenge

This layer separates a local hardware operation from global physical admission.
A fresh challenge binds the exact L13 certificate digest to a configured
non-exportable signing key.  A valid local signature can establish
`localHardwarePass`.  It cannot establish `globalHardwareAdmitted` without a
separate remote attestation statement and an independent physical quorum.

The formal model checks bindings and decisions.  The platform adapter remains
responsible for establishing that the key operation really occurred inside the
named hardware boundary.
-/

namespace TMI.DigitalLifePhysicalHardwareChallenge

def physicalHardwareProtocolVersion : Nat := 1

structure PhysicalHardwareProfile where
  witnessId : String
  nodeId : String
  platformId : String
  providerId : String
  keyHandle : String
  custodyDomain : String
  trustedPublicKeyDigest : String
  deriving DecidableEq, Repr

structure PhysicalHardwarePolicy where
  policyId : String
  basePolicyId : String
  expectedBaseEvidenceDigest : String
  maxChallengeLifetime : Nat
  minRemoteApprovals : Nat
  profile : PhysicalHardwareProfile
  deriving DecidableEq, Repr

structure PhysicalChallenge where
  policyId : String
  policyDigest : String
  basePolicyId : String
  baseEvidenceDigest : String
  challengeId : String
  issuedAt : Nat
  expiresAt : Nat
  witnessId : String
  nodeId : String
  platformId : String
  keyHandle : String
  quoteNonce : String
  deriving DecidableEq, Repr

structure LocalHardwareReceipt where
  policyId : String
  challengeId : String
  challengeDigest : String
  baseEvidenceDigest : String
  witnessId : String
  nodeId : String
  platformId : String
  providerId : String
  keyHandle : String
  custodyDomain : String
  publicKeyDigest : String
  signedAt : Nat
  signatureVerified : Bool
  hardwareTokenVerified : Bool
  privateKeyNonExportable : Bool
  deriving DecidableEq, Repr

structure RemotePhysicalEvidence where
  policyId : String
  localReceiptDigest : String
  platformVerifierId : String
  platformVerifierCustody : String
  attestationChainAccepted : Bool
  measurementsAccepted : Bool
  platformSignatureVerified : Bool
  verifierIds : List String
  custodyDomains : List String
  decisions : List Bool
  deriving DecidableEq, Repr

inductive PhysicalAdmissionStatus where
  | hold
  | localHardwarePass
  | globalHardwareAdmitted
  deriving DecidableEq, Repr

def PhysicalPolicyWellFormed (policy : PhysicalHardwarePolicy) : Prop :=
  policy.policyId != "" ∧
  policy.basePolicyId != "" ∧
  policy.expectedBaseEvidenceDigest.length = 64 ∧
  0 < policy.maxChallengeLifetime ∧
  0 < policy.minRemoteApprovals ∧
  policy.profile.witnessId != "" ∧
  policy.profile.nodeId != "" ∧
  policy.profile.platformId != "" ∧
  policy.profile.providerId != "" ∧
  policy.profile.keyHandle != "" ∧
  policy.profile.custodyDomain != "" ∧
  policy.profile.trustedPublicKeyDigest.length = 64

instance (policy : PhysicalHardwarePolicy) :
    Decidable (PhysicalPolicyWellFormed policy) := by
  unfold PhysicalPolicyWellFormed
  infer_instance

def LocalHardwareBound
    (policy : PhysicalHardwarePolicy)
    (policyDigest challengeDigest : String)
    (now : Nat)
    (challenge : PhysicalChallenge)
    (receipt : LocalHardwareReceipt) : Prop :=
  PhysicalPolicyWellFormed policy ∧
  policyDigest.length = 64 ∧
  challengeDigest.length = 64 ∧
  challenge.policyId = policy.policyId ∧
  challenge.policyDigest = policyDigest ∧
  challenge.basePolicyId = policy.basePolicyId ∧
  challenge.baseEvidenceDigest = policy.expectedBaseEvidenceDigest ∧
  challenge.challengeId.length = 64 ∧
  challenge.issuedAt < challenge.expiresAt ∧
  challenge.expiresAt - challenge.issuedAt ≤ policy.maxChallengeLifetime ∧
  challenge.issuedAt ≤ now ∧ now ≤ challenge.expiresAt ∧
  challenge.witnessId = policy.profile.witnessId ∧
  challenge.nodeId = policy.profile.nodeId ∧
  challenge.platformId = policy.profile.platformId ∧
  challenge.keyHandle = policy.profile.keyHandle ∧
  challenge.quoteNonce = challenge.baseEvidenceDigest ∧
  receipt.policyId = challenge.policyId ∧
  receipt.challengeId = challenge.challengeId ∧
  receipt.challengeDigest = challengeDigest ∧
  receipt.baseEvidenceDigest = challenge.baseEvidenceDigest ∧
  receipt.witnessId = policy.profile.witnessId ∧
  receipt.nodeId = policy.profile.nodeId ∧
  receipt.platformId = policy.profile.platformId ∧
  receipt.providerId = policy.profile.providerId ∧
  receipt.keyHandle = policy.profile.keyHandle ∧
  receipt.custodyDomain = policy.profile.custodyDomain ∧
  receipt.publicKeyDigest = policy.profile.trustedPublicKeyDigest ∧
  challenge.issuedAt ≤ receipt.signedAt ∧
  receipt.signedAt ≤ now ∧
  receipt.signedAt ≤ challenge.expiresAt ∧
  receipt.signatureVerified = true ∧
  receipt.hardwareTokenVerified = true ∧
  receipt.privateKeyNonExportable = true

instance (policy : PhysicalHardwarePolicy) (policyDigest challengeDigest : String)
    (now : Nat) (challenge : PhysicalChallenge) (receipt : LocalHardwareReceipt) :
    Decidable (LocalHardwareBound policy policyDigest challengeDigest now challenge receipt) := by
  unfold LocalHardwareBound
  infer_instance

def IndependentRemoteEvidence
    (policy : PhysicalHardwarePolicy)
    (localReceiptDigest : String)
    (evidence : RemotePhysicalEvidence) : Prop :=
  localReceiptDigest.length = 64 ∧
  evidence.policyId = policy.policyId ∧
  evidence.localReceiptDigest = localReceiptDigest ∧
  evidence.platformVerifierId != "" ∧
  evidence.platformVerifierCustody != "" ∧
  evidence.platformVerifierCustody != policy.profile.custodyDomain ∧
  evidence.attestationChainAccepted = true ∧
  evidence.measurementsAccepted = true ∧
  evidence.platformSignatureVerified = true ∧
  policy.minRemoteApprovals ≤ evidence.verifierIds.length ∧
  evidence.verifierIds.length = evidence.custodyDomains.length ∧
  evidence.verifierIds.length = evidence.decisions.length ∧
  evidence.verifierIds.Nodup ∧
  evidence.custodyDomains.Nodup ∧
  policy.profile.custodyDomain ∉ evidence.custodyDomains ∧
  evidence.platformVerifierCustody ∉ evidence.custodyDomains ∧
  ∀ decision ∈ evidence.decisions, decision = true

instance (policy : PhysicalHardwarePolicy) (localReceiptDigest : String)
    (evidence : RemotePhysicalEvidence) :
    Decidable (IndependentRemoteEvidence policy localReceiptDigest evidence) := by
  unfold IndependentRemoteEvidence
  infer_instance

def evaluatePhysicalAdmission
    (policy : PhysicalHardwarePolicy)
    (policyDigest challengeDigest localReceiptDigest : String)
    (now : Nat)
    (challenge : PhysicalChallenge)
    (receipt : LocalHardwareReceipt)
    (remote : Option RemotePhysicalEvidence) : PhysicalAdmissionStatus :=
  if LocalHardwareBound policy policyDigest challengeDigest now challenge receipt then
    match remote with
    | none => .localHardwarePass
    | some evidence =>
        if IndependentRemoteEvidence policy localReceiptDigest evidence then
          .globalHardwareAdmitted
        else .localHardwarePass
  else .hold

theorem local_hardware_pass_without_remote
    (hLocal : LocalHardwareBound policy policyDigest challengeDigest now challenge receipt) :
    evaluatePhysicalAdmission policy policyDigest challengeDigest receiptDigest now
      challenge receipt none = .localHardwarePass := by
  simp [evaluatePhysicalAdmission, hLocal]

theorem global_hardware_admission_requires_both
    (hLocal : LocalHardwareBound policy policyDigest challengeDigest now challenge receipt)
    (hRemote : IndependentRemoteEvidence policy receiptDigest evidence) :
    evaluatePhysicalAdmission policy policyDigest challengeDigest receiptDigest now
      challenge receipt (some evidence) = .globalHardwareAdmitted := by
  simp [evaluatePhysicalAdmission, hLocal, hRemote]

theorem invalid_local_evidence_holds
    (hLocal : ¬ LocalHardwareBound policy policyDigest challengeDigest now challenge receipt) :
    evaluatePhysicalAdmission policy policyDigest challengeDigest receiptDigest now
      challenge receipt remote = .hold := by
  simp [evaluatePhysicalAdmission, hLocal]

theorem rejected_remote_evidence_is_not_global
    (hLocal : LocalHardwareBound policy policyDigest challengeDigest now challenge receipt)
    (hRemote : ¬ IndependentRemoteEvidence policy receiptDigest evidence) :
    evaluatePhysicalAdmission policy policyDigest challengeDigest receiptDigest now
      challenge receipt (some evidence) = .localHardwarePass := by
  simp [evaluatePhysicalAdmission, hLocal, hRemote]

end TMI.DigitalLifePhysicalHardwareChallenge
