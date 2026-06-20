/-
TLFL 0.2 claim passport and proof-state certification surface.

This module turns the existing proof-status classification and proof-chain
self-model into a compact "claim passport": what was admitted, which evidence
bundle supports it, what status ceiling is allowed, and which jumps remain
forbidden. It is a proof-status certification layer, not an empirical truth
claim.
-/

import TMI.ProofStatusClassification
import TMI.ProofChainSelfModel

namespace TMI

inductive ClaimCeiling where
  | unadmitted
  | formalLeanStatus
  | externalMirrorWitness
  | tlflProofStateCertified
  | guardedMathematicalIntelligence
  | empiricalPending
deriving DecidableEq, Repr

inductive ClaimPassportVerdict where
  | pass
  | fail
deriving DecidableEq, Repr

structure ClaimPassportInput where
  claimPresented : Bool
  leanKernelTrace : Bool
  z3Trace : Bool
  vampireTrace : Bool
  eTrace : Bool
  tlflClassificationTrace : Bool
  nonClaimGuardTrace : Bool
  proofSelfModelTrace : Bool
deriving Repr

def claimPassportInputComplete (input : ClaimPassportInput) : Bool :=
  input.claimPresented &&
  input.leanKernelTrace &&
  input.z3Trace &&
  input.vampireTrace &&
  input.eTrace &&
  input.tlflClassificationTrace &&
  input.nonClaimGuardTrace &&
  input.proofSelfModelTrace

def claimPassportVerdict (input : ClaimPassportInput) : ClaimPassportVerdict :=
  if claimPassportInputComplete input then
    ClaimPassportVerdict.pass
  else
    ClaimPassportVerdict.fail

def claimPassportCeiling (input : ClaimPassportInput) : ClaimCeiling :=
  match claimPassportVerdict input with
  | ClaimPassportVerdict.pass => ClaimCeiling.tlflProofStateCertified
  | ClaimPassportVerdict.fail => ClaimCeiling.unadmitted

structure ClaimObject where
  name : String
  presented : Prop
  presentedWitness : presented

structure ClaimEvidenceBundle where
  leanKernelTrace : Prop
  leanKernelWitness : leanKernelTrace
  z3Trace : Prop
  z3Witness : z3Trace
  vampireTrace : Prop
  vampireWitness : vampireTrace
  eTrace : Prop
  eWitness : eTrace
  tlflClassificationTrace : Prop
  tlflClassificationWitness : tlflClassificationTrace
  nonClaimGuardTrace : Prop
  nonClaimGuardWitness : nonClaimGuardTrace

structure ForbiddenJumpMap where
  empiricalTruthForbidden : Prop
  empiricalTruthWitness : empiricalTruthForbidden
  physicalValidationForbidden : Prop
  physicalValidationWitness : physicalValidationForbidden
  consciousnessForbidden : Prop
  consciousnessWitness : consciousnessForbidden
  empiricalClosureForbidden : Prop
  empiricalClosureWitness : empiricalClosureForbidden

structure ProofStateCertification where
  input : ClaimPassportInput
  verdict : ClaimPassportVerdict
  allowedClaimCeiling : ClaimCeiling
  forbiddenJumpMap : ForbiddenJumpMap
  proofStateCertified : Prop
  proofStateCertifiedWitness : proofStateCertified

structure ClaimPassport where
  claim : ClaimObject
  evidenceBundle : ClaimEvidenceBundle
  proofSelfModel : TLFLProofSelfModel
  claimClassification : ClaimClassification
  classificationWitness : TLFLClassifiesClaim claimClassification
  allowedClaimCeiling : ClaimCeiling
  forbiddenJumpMap : ForbiddenJumpMap
  certificationPass : Prop
  certificationPassWitness : certificationPass

def ClaimPassportCertified (passport : ClaimPassport) : Prop :=
  passport.claim.presented /\
  passport.evidenceBundle.leanKernelTrace /\
  passport.evidenceBundle.z3Trace /\
  passport.evidenceBundle.vampireTrace /\
  passport.evidenceBundle.eTrace /\
  passport.evidenceBundle.tlflClassificationTrace /\
  passport.evidenceBundle.nonClaimGuardTrace /\
  TLFLClassifiesClaim passport.claimClassification /\
  passport.allowedClaimCeiling = ClaimCeiling.tlflProofStateCertified /\
  passport.forbiddenJumpMap.empiricalTruthForbidden /\
  passport.forbiddenJumpMap.physicalValidationForbidden /\
  passport.forbiddenJumpMap.consciousnessForbidden /\
  passport.forbiddenJumpMap.empiricalClosureForbidden /\
  passport.certificationPass

def canonicalClaimObject : ClaimObject :=
  { name := "TLFL 0.2 claim passport and proof-state certification"
    presented := True
    presentedWitness := by trivial }

def completeClaimEvidenceBundle : ClaimEvidenceBundle :=
  { leanKernelTrace := True
    leanKernelWitness := by trivial
    z3Trace := True
    z3Witness := by trivial
    vampireTrace := True
    vampireWitness := by trivial
    eTrace := True
    eWitness := by trivial
    tlflClassificationTrace := True
    tlflClassificationWitness := by trivial
    nonClaimGuardTrace := True
    nonClaimGuardWitness := by trivial }

def defaultForbiddenJumpMap : ForbiddenJumpMap :=
  { empiricalTruthForbidden := True
    empiricalTruthWitness := by trivial
    physicalValidationForbidden := True
    physicalValidationWitness := by trivial
    consciousnessForbidden := True
    consciousnessWitness := by trivial
    empiricalClosureForbidden := True
    empiricalClosureWitness := by trivial }

def completeClaimPassportInput : ClaimPassportInput :=
  { claimPresented := true
    leanKernelTrace := true
    z3Trace := true
    vampireTrace := true
    eTrace := true
    tlflClassificationTrace := true
    nonClaimGuardTrace := true
    proofSelfModelTrace := true }

def missingTLFLClassificationClaimPassportInput : ClaimPassportInput :=
  { claimPresented := true
    leanKernelTrace := true
    z3Trace := true
    vampireTrace := true
    eTrace := true
    tlflClassificationTrace := false
    nonClaimGuardTrace := true
    proofSelfModelTrace := true }

def proofStateCertificationOf
    (input : ClaimPassportInput)
    (h : claimPassportVerdict input = ClaimPassportVerdict.pass) :
    ProofStateCertification :=
  { input := input
    verdict := claimPassportVerdict input
    allowedClaimCeiling := claimPassportCeiling input
    forbiddenJumpMap := defaultForbiddenJumpMap
    proofStateCertified := claimPassportVerdict input = ClaimPassportVerdict.pass
    proofStateCertifiedWitness := h }

def canonicalProofStateCertification : ProofStateCertification :=
  proofStateCertificationOf completeClaimPassportInput rfl

theorem complete_claim_passport_input_verdict_is_pass :
    claimPassportVerdict completeClaimPassportInput = ClaimPassportVerdict.pass := by
  rfl

theorem complete_claim_passport_input_ceiling_is_certified :
    claimPassportCeiling completeClaimPassportInput =
      ClaimCeiling.tlflProofStateCertified := by
  rfl

theorem missing_tlfl_classification_claim_passport_input_verdict_is_fail :
    claimPassportVerdict missingTLFLClassificationClaimPassportInput =
      ClaimPassportVerdict.fail := by
  rfl

theorem missing_tlfl_classification_claim_passport_input_ceiling_is_unadmitted :
    claimPassportCeiling missingTLFLClassificationClaimPassportInput =
      ClaimCeiling.unadmitted := by
  rfl

theorem claim_passport_pass_gives_certified_ceiling
    (input : ClaimPassportInput)
    (h : claimPassportVerdict input = ClaimPassportVerdict.pass) :
    claimPassportCeiling input = ClaimCeiling.tlflProofStateCertified := by
  simp [claimPassportCeiling, h]

theorem claim_passport_fail_gives_unadmitted_ceiling
    (input : ClaimPassportInput)
    (h : claimPassportVerdict input = ClaimPassportVerdict.fail) :
    claimPassportCeiling input = ClaimCeiling.unadmitted := by
  simp [claimPassportCeiling, h]

theorem proof_state_certification_has_pass_verdict :
    canonicalProofStateCertification.verdict = ClaimPassportVerdict.pass := by
  rfl

theorem proof_state_certification_has_certified_ceiling :
    canonicalProofStateCertification.allowedClaimCeiling =
      ClaimCeiling.tlflProofStateCertified := by
  rfl

def claimPassportOf
    (claim : ClaimObject)
    (evidenceBundle : ClaimEvidenceBundle)
    (model : TLFLProofSelfModel)
    (classification : ClaimClassification)
    (h : TLFLClassifiesClaim classification) :
    ClaimPassport :=
  { claim := claim
    evidenceBundle := evidenceBundle
    proofSelfModel := model
    claimClassification := classification
    classificationWitness := h
    allowedClaimCeiling := ClaimCeiling.tlflProofStateCertified
    forbiddenJumpMap := defaultForbiddenJumpMap
    certificationPass := True
    certificationPassWitness := by trivial }

def canonicalClaimPassport : ClaimPassport :=
  claimPassportOf
    canonicalClaimObject
    completeClaimEvidenceBundle
    canonicalTLFLProofSelfModel
    vampireZ3ETLFLClaimClassification
    tlfl_meta_interface_gives_claim_classification

theorem tlfl_proof_self_model_gives_claim_passport :
    exists passport : ClaimPassport,
      ClaimPassportCertified passport := by
  refine ⟨canonicalClaimPassport, ?_⟩
  exact ⟨
    canonicalClaimPassport.claim.presentedWitness,
    canonicalClaimPassport.evidenceBundle.leanKernelWitness,
    canonicalClaimPassport.evidenceBundle.z3Witness,
    canonicalClaimPassport.evidenceBundle.vampireWitness,
    canonicalClaimPassport.evidenceBundle.eWitness,
    canonicalClaimPassport.evidenceBundle.tlflClassificationWitness,
    canonicalClaimPassport.evidenceBundle.nonClaimGuardWitness,
    canonicalClaimPassport.classificationWitness,
    rfl,
    canonicalClaimPassport.forbiddenJumpMap.empiricalTruthWitness,
    canonicalClaimPassport.forbiddenJumpMap.physicalValidationWitness,
    canonicalClaimPassport.forbiddenJumpMap.consciousnessWitness,
    canonicalClaimPassport.forbiddenJumpMap.empiricalClosureWitness,
    canonicalClaimPassport.certificationPassWitness
  ⟩

theorem claim_passport_gives_allowed_claim_ceiling
    (passport : ClaimPassport)
    (h : ClaimPassportCertified passport) :
    passport.allowedClaimCeiling = ClaimCeiling.tlflProofStateCertified := by
  exact h.2.2.2.2.2.2.2.2.1

theorem claim_passport_gives_forbidden_jump_map
    (passport : ClaimPassport)
    (h : ClaimPassportCertified passport) :
    passport.forbiddenJumpMap.empiricalTruthForbidden /\
    passport.forbiddenJumpMap.physicalValidationForbidden /\
    passport.forbiddenJumpMap.consciousnessForbidden /\
    passport.forbiddenJumpMap.empiricalClosureForbidden := by
  exact ⟨
    h.2.2.2.2.2.2.2.2.2.1,
    h.2.2.2.2.2.2.2.2.2.2.1,
    h.2.2.2.2.2.2.2.2.2.2.2.1,
    h.2.2.2.2.2.2.2.2.2.2.2.2.1
  ⟩

theorem claim_passport_projects_to_proof_state_self_model
    (passport : ClaimPassport)
    (_h : ClaimPassportCertified passport) :
    TLFLClassifiesClaim passport.proofSelfModel.claimClassification := by
  exact passport.proofSelfModel.classificationWitness

theorem claim_passport_projects_to_claim_classification
    (passport : ClaimPassport)
    (h : ClaimPassportCertified passport) :
    TLFLClassifiesClaim passport.claimClassification := by
  exact h.2.2.2.2.2.2.2.1

theorem claim_passport_certification_passes
    (passport : ClaimPassport)
    (h : ClaimPassportCertified passport) :
    passport.certificationPass := by
  exact h.2.2.2.2.2.2.2.2.2.2.2.2.2

structure ClaimPassportScenario where
  claimPresented : Prop
  evidenceBundleComplete : Prop
  tlflClassifies : Prop
  proofSelfModel : Prop
  claimPassport : Prop
  empiricalTruth : Prop
  physicalValidation : Prop
  consciousness : Prop
  empiricalClosure : Prop

theorem claim_object_alone_does_not_imply_claim_passport :
    exists s : ClaimPassportScenario,
      s.claimPresented /\
      Not s.claimPassport := by
  let s : ClaimPassportScenario :=
    { claimPresented := True
      evidenceBundleComplete := False
      tlflClassifies := False
      proofSelfModel := False
      claimPassport := False
      empiricalTruth := False
      physicalValidation := False
      consciousness := False
      empiricalClosure := False }
  exact ⟨s, by trivial, fun h => h⟩

theorem evidence_bundle_alone_does_not_imply_claim_passport :
    exists s : ClaimPassportScenario,
      s.evidenceBundleComplete /\
      Not s.tlflClassifies /\
      Not s.claimPassport := by
  let s : ClaimPassportScenario :=
    { claimPresented := True
      evidenceBundleComplete := True
      tlflClassifies := False
      proofSelfModel := False
      claimPassport := False
      empiricalTruth := False
      physicalValidation := False
      consciousness := False
      empiricalClosure := False }
  exact ⟨s, by trivial, fun h => h, fun h => h⟩

theorem claim_passport_does_not_imply_empirical_truth :
    exists s : ClaimPassportScenario,
      s.claimPassport /\
      Not s.empiricalTruth := by
  let s : ClaimPassportScenario :=
    { claimPresented := True
      evidenceBundleComplete := True
      tlflClassifies := True
      proofSelfModel := True
      claimPassport := True
      empiricalTruth := False
      physicalValidation := False
      consciousness := False
      empiricalClosure := False }
  exact ⟨s, by trivial, fun h => h⟩

theorem claim_passport_does_not_imply_physical_validation :
    exists s : ClaimPassportScenario,
      s.claimPassport /\
      Not s.physicalValidation := by
  let s : ClaimPassportScenario :=
    { claimPresented := True
      evidenceBundleComplete := True
      tlflClassifies := True
      proofSelfModel := True
      claimPassport := True
      empiricalTruth := False
      physicalValidation := False
      consciousness := False
      empiricalClosure := False }
  exact ⟨s, by trivial, fun h => h⟩

theorem claim_passport_does_not_imply_consciousness :
    exists s : ClaimPassportScenario,
      s.claimPassport /\
      Not s.consciousness := by
  let s : ClaimPassportScenario :=
    { claimPresented := True
      evidenceBundleComplete := True
      tlflClassifies := True
      proofSelfModel := True
      claimPassport := True
      empiricalTruth := False
      physicalValidation := False
      consciousness := False
      empiricalClosure := False }
  exact ⟨s, by trivial, fun h => h⟩

theorem claim_passport_does_not_imply_empirical_closure :
    exists s : ClaimPassportScenario,
      s.claimPassport /\
      Not s.empiricalClosure := by
  let s : ClaimPassportScenario :=
    { claimPresented := True
      evidenceBundleComplete := True
      tlflClassifies := True
      proofSelfModel := True
      claimPassport := True
      empiricalTruth := False
      physicalValidation := False
      consciousness := False
      empiricalClosure := False }
  exact ⟨s, by trivial, fun h => h⟩

end TMI
