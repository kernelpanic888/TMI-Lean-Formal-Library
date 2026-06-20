/-
TLFL proof-status classification.

This module fixes TLFL as a meta-interface for classifying claims by the
admissible proof path, verification boundary, prover compatibility, and allowed
epistemic status. It does not make empirical validation claims.
-/

namespace TMI

inductive AdmissibleProofPath where
  | leanKernel
  | z3Mirror
  | vampireMirror
  | eProverMirror
  | vampireZ3ETLFL
deriving DecidableEq, Repr

inductive VerificationBoundary where
  | leanKernelBoundary
  | externalMirrorBoundary
  | tlflClassificationBoundary
  | empiricalBoundary
deriving DecidableEq, Repr

structure ProverCompatibility where
  leanKernelCompatible : Prop
  vampireCompatible : Prop
  z3Compatible : Prop
  eProverCompatible : Prop

inductive AllowedEpistemicStatus where
  | unclassified
  | formalLeanChecked
  | externallyMirrored
  | tlflClassified
  | guardedPhysicalLayer
  | empiricalPending
deriving DecidableEq, Repr

structure ClaimClassification where
  admissibleProofPath : AdmissibleProofPath
  verificationBoundary : VerificationBoundary
  proverCompatibility : ProverCompatibility
  allowedEpistemicStatus : AllowedEpistemicStatus
  nonClaimGuarded : Prop
  nonClaimGuardWitness : nonClaimGuarded

structure TLFLMetaInterface where
  classifiesByAdmissibleProofPath : Prop
  admissibleProofPathWitness : classifiesByAdmissibleProofPath
  classifiesByVerificationBoundary : Prop
  verificationBoundaryWitness : classifiesByVerificationBoundary
  classifiesByProverCompatibility : Prop
  proverCompatibilityWitness : classifiesByProverCompatibility
  classifiesByAllowedEpistemicStatus : Prop
  epistemicStatusWitness : classifiesByAllowedEpistemicStatus

def tlflMetaInterface : TLFLMetaInterface :=
  { classifiesByAdmissibleProofPath := True
    admissibleProofPathWitness := by trivial
    classifiesByVerificationBoundary := True
    verificationBoundaryWitness := by trivial
    classifiesByProverCompatibility := True
    proverCompatibilityWitness := by trivial
    classifiesByAllowedEpistemicStatus := True
    epistemicStatusWitness := by trivial }

def vampireZ3ETLFLCompatibility : ProverCompatibility :=
  { leanKernelCompatible := True
    vampireCompatible := True
    z3Compatible := True
    eProverCompatible := True }

def vampireZ3ETLFLClaimClassification : ClaimClassification :=
  { admissibleProofPath := AdmissibleProofPath.vampireZ3ETLFL
    verificationBoundary := VerificationBoundary.tlflClassificationBoundary
    proverCompatibility := vampireZ3ETLFLCompatibility
    allowedEpistemicStatus := AllowedEpistemicStatus.tlflClassified
    nonClaimGuarded := True
    nonClaimGuardWitness := by trivial }

def TLFLClassifiesClaim (c : ClaimClassification) : Prop :=
  c.admissibleProofPath = AdmissibleProofPath.vampireZ3ETLFL /\
  c.verificationBoundary = VerificationBoundary.tlflClassificationBoundary /\
  c.proverCompatibility.leanKernelCompatible /\
  c.proverCompatibility.vampireCompatible /\
  c.proverCompatibility.z3Compatible /\
  c.proverCompatibility.eProverCompatible /\
  c.allowedEpistemicStatus = AllowedEpistemicStatus.tlflClassified /\
  c.nonClaimGuarded

theorem tlfl_classifies_by_admissible_proof_path :
    tlflMetaInterface.classifiesByAdmissibleProofPath := by
  exact tlflMetaInterface.admissibleProofPathWitness

theorem tlfl_classifies_by_verification_boundary :
    tlflMetaInterface.classifiesByVerificationBoundary := by
  exact tlflMetaInterface.verificationBoundaryWitness

theorem tlfl_classifies_by_prover_compatibility :
    tlflMetaInterface.classifiesByProverCompatibility := by
  exact tlflMetaInterface.proverCompatibilityWitness

theorem tlfl_classifies_by_allowed_epistemic_status :
    tlflMetaInterface.classifiesByAllowedEpistemicStatus := by
  exact tlflMetaInterface.epistemicStatusWitness

theorem tlfl_meta_interface_gives_claim_classification :
    TLFLClassifiesClaim vampireZ3ETLFLClaimClassification := by
  exact ⟨rfl, rfl, by trivial, by trivial, by trivial, by trivial, rfl, by trivial⟩

structure ProofStatusScenario where
  vampirePass : Prop
  z3Pass : Prop
  ePass : Prop
  tlflClassifies : Prop
  empiricalClosure : Prop
  replacesExternalProofSearch : Prop

theorem vampire_z3_e_compatibility_alone_does_not_imply_empirical_closure :
    exists s : ProofStatusScenario,
      s.vampirePass /\
      s.z3Pass /\
      s.ePass /\
      Not s.empiricalClosure := by
  let s : ProofStatusScenario :=
    { vampirePass := True
      z3Pass := True
      ePass := True
      tlflClassifies := False
      empiricalClosure := False
      replacesExternalProofSearch := False }
  exact ⟨s, by trivial, by trivial, by trivial, fun h => h⟩

theorem tlfl_classification_does_not_imply_empirical_closure :
    exists s : ProofStatusScenario,
      s.tlflClassifies /\
      Not s.empiricalClosure := by
  let s : ProofStatusScenario :=
    { vampirePass := True
      z3Pass := True
      ePass := True
      tlflClassifies := True
      empiricalClosure := False
      replacesExternalProofSearch := False }
  exact ⟨s, by trivial, fun h => h⟩

theorem tlfl_classification_does_not_replace_vampire_z3_e_search :
    exists s : ProofStatusScenario,
      s.tlflClassifies /\
      Not s.replacesExternalProofSearch := by
  let s : ProofStatusScenario :=
    { vampirePass := True
      z3Pass := True
      ePass := True
      tlflClassifies := True
      empiricalClosure := False
      replacesExternalProofSearch := False }
  exact ⟨s, by trivial, fun h => h⟩

end TMI
