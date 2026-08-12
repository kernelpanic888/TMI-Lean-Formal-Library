import TMI.DigitalLifeTransportAttestation

/-!
# I³-L13: hardware-bound evidence and split verifier custody

L13 accepts an L12 receipt only through a platform-verifier statement bound to
the exact receipt digest.  Final admission is not controlled by that platform
verifier: a threshold of independently configured verifier domains must sign
the same hardware-evidence digest.

The model verifies bindings and decisions.  It does not manufacture hardware
provenance.  `chainAccepted` and `measurementsAccepted` are claims made by the
configured platform verifier and must be backed by a real TPM/TEE verifier in a
deployment that wants to claim physical attestation.
-/

namespace TMI.DigitalLifeHardwareAttestation

def hardwareAttestationProtocolVersion : Nat := 1

structure HardwareProfile where
  witnessId : String
  nodeId : String
  platformId : String
  attestationRootId : String
  platformVerifierId : String
  platformVerifierCustody : String
  deriving DecidableEq, Repr

structure SplitVerifierProfile where
  verifierId : String
  custodyDomain : String
  deriving DecidableEq, Repr

structure HardwarePolicy where
  policyId : String
  basePolicyId : String
  maxQuoteLifetime : Nat
  minApprovals : Nat
  hardwareProfiles : List HardwareProfile
  verifierProfiles : List SplitVerifierProfile
  deriving DecidableEq, Repr

structure VerifiedAttestedEvidenceRef where
  basePolicyId : String
  evidenceDigest : String
  witnessId : String
  nodeId : String
  signatureVerified : Bool
  deriving DecidableEq, Repr

structure PlatformVerifierReceipt where
  policyId : String
  baseEvidenceDigest : String
  witnessId : String
  nodeId : String
  platformId : String
  attestationRootId : String
  platformVerifierId : String
  platformVerifierCustody : String
  quoteNonce : String
  rawQuoteDigest : String
  pcrDigest : String
  eventLogDigest : String
  firmwareDigest : String
  issuedAt : Nat
  expiresAt : Nat
  quoteSignatureVerified : Bool
  chainAccepted : Bool
  measurementsAccepted : Bool
  platformVerifierSignatureVerified : Bool
  deriving DecidableEq, Repr

structure SplitVerifierApproval where
  policyId : String
  hardwareEvidenceDigest : String
  verifierId : String
  custodyDomain : String
  decision : Bool
  signatureVerified : Bool
  deriving DecidableEq, Repr

structure HardwareAdmissionCertificate where
  protocolVersion : Nat
  policyId : String
  threshold : Nat
  baseEvidenceDigest : String
  hardwareEvidenceDigest : String
  verifierIds : List String
  custodyDomains : List String
  approvalDigests : List String
  deriving DecidableEq, Repr

def findHardwareProfile
    (profiles : List HardwareProfile) (witnessId : String) : Option HardwareProfile :=
  match profiles with
  | [] => none
  | profile :: rest =>
      if profile.witnessId == witnessId then some profile
      else findHardwareProfile rest witnessId

def findSplitVerifierProfile
    (profiles : List SplitVerifierProfile) (verifierId : String) : Option SplitVerifierProfile :=
  match profiles with
  | [] => none
  | profile :: rest =>
      if profile.verifierId == verifierId then some profile
      else findSplitVerifierProfile rest verifierId

def HardwarePolicyWellFormed (policy : HardwarePolicy) : Prop :=
  policy.policyId ≠ "" ∧ policy.basePolicyId ≠ "" ∧
  0 < policy.maxQuoteLifetime ∧ 0 < policy.minApprovals ∧
  policy.minApprovals ≤ policy.verifierProfiles.length ∧
  (policy.hardwareProfiles.map (fun p => p.witnessId)).Nodup ∧
  (policy.hardwareProfiles.map (fun p => p.nodeId)).Nodup ∧
  (policy.hardwareProfiles.map (fun p => p.platformId)).Nodup ∧
  (policy.verifierProfiles.map (fun p => p.verifierId)).Nodup ∧
  (policy.verifierProfiles.map (fun p => p.custodyDomain)).Nodup ∧
  (∀ hp ∈ policy.hardwareProfiles,
    hp.witnessId ≠ "" ∧ hp.nodeId ≠ "" ∧ hp.platformId ≠ "" ∧
    hp.attestationRootId ≠ "" ∧ hp.platformVerifierId ≠ "" ∧
    hp.platformVerifierCustody ≠ "") ∧
  (∀ vp ∈ policy.verifierProfiles,
    vp.verifierId ≠ "" ∧ vp.custodyDomain ≠ "") ∧
  ∀ hp ∈ policy.hardwareProfiles, ∀ vp ∈ policy.verifierProfiles,
    hp.platformVerifierCustody ≠ vp.custodyDomain

instance (policy : HardwarePolicy) : Decidable (HardwarePolicyWellFormed policy) := by
  unfold HardwarePolicyWellFormed
  infer_instance

def PlatformReceiptBound
    (policy : HardwarePolicy)
    (profile : HardwareProfile)
    (base : VerifiedAttestedEvidenceRef)
    (now : Nat)
    (receipt : PlatformVerifierReceipt) : Prop :=
  base.signatureVerified = true ∧
  base.basePolicyId = policy.basePolicyId ∧
  base.evidenceDigest.length = 64 ∧
  receipt.platformVerifierSignatureVerified = true ∧
  receipt.quoteSignatureVerified = true ∧
  receipt.chainAccepted = true ∧
  receipt.measurementsAccepted = true ∧
  receipt.policyId = policy.policyId ∧
  receipt.baseEvidenceDigest = base.evidenceDigest ∧
  receipt.witnessId = base.witnessId ∧
  receipt.nodeId = base.nodeId ∧
  receipt.witnessId = profile.witnessId ∧
  receipt.nodeId = profile.nodeId ∧
  receipt.platformId = profile.platformId ∧
  receipt.attestationRootId = profile.attestationRootId ∧
  receipt.platformVerifierId = profile.platformVerifierId ∧
  receipt.platformVerifierCustody = profile.platformVerifierCustody ∧
  receipt.quoteNonce = base.evidenceDigest ∧
  receipt.rawQuoteDigest.length = 64 ∧ receipt.pcrDigest.length = 64 ∧
  receipt.eventLogDigest.length = 64 ∧ receipt.firmwareDigest.length = 64 ∧
  receipt.issuedAt ≤ now ∧ now ≤ receipt.expiresAt ∧
  receipt.issuedAt < receipt.expiresAt ∧
  receipt.expiresAt - receipt.issuedAt ≤ policy.maxQuoteLifetime

instance (policy : HardwarePolicy) (profile : HardwareProfile)
    (base : VerifiedAttestedEvidenceRef) (now : Nat)
    (receipt : PlatformVerifierReceipt) :
    Decidable (PlatformReceiptBound policy profile base now receipt) := by
  unfold PlatformReceiptBound
  infer_instance

def SplitApprovalBound
    (policy : HardwarePolicy) (evidenceDigest : String)
    (approval : SplitVerifierApproval) : Prop :=
  match findSplitVerifierProfile policy.verifierProfiles approval.verifierId with
  | none => False
  | some profile =>
      approval.signatureVerified = true ∧ approval.decision = true ∧
      approval.policyId = policy.policyId ∧
      approval.hardwareEvidenceDigest = evidenceDigest ∧
      approval.custodyDomain = profile.custodyDomain

instance (policy : HardwarePolicy) (evidenceDigest : String)
    (approval : SplitVerifierApproval) :
    Decidable (SplitApprovalBound policy evidenceDigest approval) := by
  classical
  unfold SplitApprovalBound
  split <;> infer_instance

def IndependentApprovalSet
    (policy : HardwarePolicy) (evidenceDigest : String)
    (approvals : List SplitVerifierApproval) : Prop :=
  policy.minApprovals ≤ approvals.length ∧
  (approvals.map (fun a => a.verifierId)).Nodup ∧
  (approvals.map (fun a => a.custodyDomain)).Nodup ∧
  ∀ approval ∈ approvals, SplitApprovalBound policy evidenceDigest approval

instance (policy : HardwarePolicy) (evidenceDigest : String)
    (approvals : List SplitVerifierApproval) :
    Decidable (IndependentApprovalSet policy evidenceDigest approvals) := by
  unfold IndependentApprovalSet
  infer_instance

def HardwareAdmitted
    (policy : HardwarePolicy) (profile : HardwareProfile)
    (base : VerifiedAttestedEvidenceRef) (now : Nat)
    (receipt : PlatformVerifierReceipt) (hardwareEvidenceDigest : String)
    (approvals : List SplitVerifierApproval) : Prop :=
  HardwarePolicyWellFormed policy ∧
  findHardwareProfile policy.hardwareProfiles base.witnessId = some profile ∧
  PlatformReceiptBound policy profile base now receipt ∧
  hardwareEvidenceDigest.length = 64 ∧
  IndependentApprovalSet policy hardwareEvidenceDigest approvals

instance (policy : HardwarePolicy) (profile : HardwareProfile)
    (base : VerifiedAttestedEvidenceRef) (now : Nat)
    (receipt : PlatformVerifierReceipt) (hardwareEvidenceDigest : String)
    (approvals : List SplitVerifierApproval) :
    Decidable (HardwareAdmitted policy profile base now receipt hardwareEvidenceDigest approvals) := by
  unfold HardwareAdmitted
  infer_instance

theorem hardware_and_split_custody_admits
    (policy : HardwarePolicy) (profile : HardwareProfile)
    (base : VerifiedAttestedEvidenceRef) (now : Nat)
    (receipt : PlatformVerifierReceipt) (digest : String)
    (approvals : List SplitVerifierApproval)
    (hPolicy : HardwarePolicyWellFormed policy)
    (hProfile : findHardwareProfile policy.hardwareProfiles base.witnessId = some profile)
    (hQuote : PlatformReceiptBound policy profile base now receipt)
    (hDigest : digest.length = 64)
    (hApprovals : IndependentApprovalSet policy digest approvals) :
    HardwareAdmitted policy profile base now receipt digest approvals := by
  exact ⟨hPolicy, hProfile, hQuote, hDigest, hApprovals⟩

theorem unsigned_platform_receipt_holds
    (policy : HardwarePolicy) (profile : HardwareProfile)
    (base : VerifiedAttestedEvidenceRef) (now : Nat)
    (receipt : PlatformVerifierReceipt)
    (hUnsigned : receipt.platformVerifierSignatureVerified = false) :
    ¬ PlatformReceiptBound policy profile base now receipt := by
  intro h
  exact Bool.noConfusion (h.2.2.2.1.symm.trans hUnsigned)

theorem untrusted_quote_chain_holds
    (policy : HardwarePolicy) (profile : HardwareProfile)
    (base : VerifiedAttestedEvidenceRef) (now : Nat)
    (receipt : PlatformVerifierReceipt)
    (hChain : receipt.chainAccepted = false) :
    ¬ PlatformReceiptBound policy profile base now receipt := by
  intro h
  exact Bool.noConfusion (h.2.2.2.2.2.1.symm.trans hChain)

theorem rejected_measurements_hold
    (policy : HardwarePolicy) (profile : HardwareProfile)
    (base : VerifiedAttestedEvidenceRef) (now : Nat)
    (receipt : PlatformVerifierReceipt)
    (hMeasurements : receipt.measurementsAccepted = false) :
    ¬ PlatformReceiptBound policy profile base now receipt := by
  intro h
  exact Bool.noConfusion (h.2.2.2.2.2.2.1.symm.trans hMeasurements)

theorem insufficient_split_approvals_hold
    (policy : HardwarePolicy) (digest : String)
    (approvals : List SplitVerifierApproval)
    (hShort : approvals.length < policy.minApprovals) :
    ¬ IndependentApprovalSet policy digest approvals := by
  intro h
  exact (Nat.not_le_of_gt hShort) h.1

theorem duplicate_verifier_domain_holds
    (policy : HardwarePolicy) (digest : String)
    (a b : SplitVerifierApproval)
    (hSame : a.custodyDomain = b.custodyDomain) :
    ¬ IndependentApprovalSet policy digest [a, b] := by
  intro h
  have hNodup := h.2.2
  simp [hSame] at hNodup

theorem denied_approval_holds
    (policy : HardwarePolicy) (digest : String)
    (approval : SplitVerifierApproval)
    (hDenied : approval.decision = false) :
    ¬ SplitApprovalBound policy digest approval := by
  intro h
  unfold SplitApprovalBound at h
  split at h
  · exact h
  · exact Bool.noConfusion (h.2.1.symm.trans hDenied)

end TMI.DigitalLifeHardwareAttestation
