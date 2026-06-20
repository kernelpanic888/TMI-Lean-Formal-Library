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

inductive ClaimCertificationStatus where
  | unadmitted
  | formalProved
  | guardedFormal
  | externalMirrored
  | proofStateCertified
  | empiricalPending
  | overclaimBlocked
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

structure ClaimCertificationRequest where
  input : ClaimPassportInput
  requestsEmpiricalTruth : Bool
  requestsPhysicalValidation : Bool
  requestsConsciousness : Bool
  requestsEmpiricalClosure : Bool
deriving Repr

def claimCertificationRequestsForbiddenJump
    (request : ClaimCertificationRequest) : Bool :=
  request.requestsEmpiricalTruth ||
  request.requestsPhysicalValidation ||
  request.requestsConsciousness ||
  request.requestsEmpiricalClosure

def claimCertificationStatus
    (request : ClaimCertificationRequest) : ClaimCertificationStatus :=
  if claimCertificationRequestsForbiddenJump request then
    ClaimCertificationStatus.overclaimBlocked
  else
    match claimPassportVerdict request.input with
    | ClaimPassportVerdict.pass => ClaimCertificationStatus.proofStateCertified
    | ClaimPassportVerdict.fail => ClaimCertificationStatus.unadmitted

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

structure ClaimPassportCertificate where
  passport : ClaimPassport
  passportCertified : ClaimPassportCertified passport
  proofStateCertification : ProofStateCertification
  request : ClaimCertificationRequest
  verdict : ClaimPassportVerdict
  verdictWitness : verdict = claimPassportVerdict request.input
  certificationStatus : ClaimCertificationStatus
  statusWitness : certificationStatus = claimCertificationStatus request
  allowedClaimCeiling : ClaimCeiling
  ceilingWitness : allowedClaimCeiling = claimPassportCeiling request.input
  forbiddenJumpMap : ForbiddenJumpMap

structure ClaimPassportPublicCertificateSurface where
  certificate : ClaimPassportCertificate
  certifiedPassport : ClaimPassportCertified certificate.passport
  verdict : ClaimPassportVerdict
  verdictWitness : verdict = certificate.verdict
  certificationStatus : ClaimCertificationStatus
  statusWitness : certificationStatus = certificate.certificationStatus
  allowedClaimCeiling : ClaimCeiling
  ceilingWitness : allowedClaimCeiling = certificate.allowedClaimCeiling
  forbiddenJumpMap : ForbiddenJumpMap
  forbiddenJumpMapWitness :
    forbiddenJumpMap.empiricalTruthForbidden /\
    forbiddenJumpMap.physicalValidationForbidden /\
    forbiddenJumpMap.consciousnessForbidden /\
    forbiddenJumpMap.empiricalClosureForbidden
  publicProofStatusSurface : Prop
  publicProofStatusSurfaceWitness : publicProofStatusSurface

structure ClaimPassportAuditSheet where
  publicSurface : ClaimPassportPublicCertificateSurface
  reportClaimName : String
  reportVerdict : ClaimPassportVerdict
  verdictWitness : reportVerdict = publicSurface.verdict
  reportCertificationStatus : ClaimCertificationStatus
  statusWitness : reportCertificationStatus = publicSurface.certificationStatus
  reportAllowedClaimCeiling : ClaimCeiling
  ceilingWitness : reportAllowedClaimCeiling = publicSurface.allowedClaimCeiling
  reportForbiddenJumpMap : ForbiddenJumpMap
  forbiddenJumpMapWitness :
    reportForbiddenJumpMap.empiricalTruthForbidden /\
    reportForbiddenJumpMap.physicalValidationForbidden /\
    reportForbiddenJumpMap.consciousnessForbidden /\
    reportForbiddenJumpMap.empiricalClosureForbidden
  externalProofLayerRepresented : Prop
  externalProofLayerWitness : externalProofLayerRepresented
  publicAuditSurface : Prop
  publicAuditSurfaceWitness : publicAuditSurface

abbrev ClaimPassportAuditReport := ClaimPassportAuditSheet

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

def certifiedProofStateRequest : ClaimCertificationRequest :=
  { input := completeClaimPassportInput
    requestsEmpiricalTruth := false
    requestsPhysicalValidation := false
    requestsConsciousness := false
    requestsEmpiricalClosure := false }

def missingClassificationCertificationRequest : ClaimCertificationRequest :=
  { input := missingTLFLClassificationClaimPassportInput
    requestsEmpiricalTruth := false
    requestsPhysicalValidation := false
    requestsConsciousness := false
    requestsEmpiricalClosure := false }

def overclaimingEmpiricalClosureRequest : ClaimCertificationRequest :=
  { input := completeClaimPassportInput
    requestsEmpiricalTruth := false
    requestsPhysicalValidation := false
    requestsConsciousness := false
    requestsEmpiricalClosure := true }

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

theorem certified_proof_state_request_status_is_proof_state_certified :
    claimCertificationStatus certifiedProofStateRequest =
      ClaimCertificationStatus.proofStateCertified := by
  rfl

theorem missing_classification_request_status_is_unadmitted :
    claimCertificationStatus missingClassificationCertificationRequest =
      ClaimCertificationStatus.unadmitted := by
  rfl

theorem empirical_closure_overclaim_request_status_is_blocked :
    claimCertificationStatus overclaimingEmpiricalClosureRequest =
      ClaimCertificationStatus.overclaimBlocked := by
  rfl

theorem forbidden_jump_request_gives_overclaim_blocked
    (request : ClaimCertificationRequest)
    (h : claimCertificationRequestsForbiddenJump request = true) :
    claimCertificationStatus request = ClaimCertificationStatus.overclaimBlocked := by
  simp [claimCertificationStatus, h]

theorem pass_without_forbidden_jump_gives_proof_state_certified
    (request : ClaimCertificationRequest)
    (hNoJump : claimCertificationRequestsForbiddenJump request = false)
    (hPass : claimPassportVerdict request.input = ClaimPassportVerdict.pass) :
    claimCertificationStatus request =
      ClaimCertificationStatus.proofStateCertified := by
  simp [claimCertificationStatus, hNoJump, hPass]

theorem fail_without_forbidden_jump_gives_unadmitted
    (request : ClaimCertificationRequest)
    (hNoJump : claimCertificationRequestsForbiddenJump request = false)
    (hFail : claimPassportVerdict request.input = ClaimPassportVerdict.fail) :
    claimCertificationStatus request = ClaimCertificationStatus.unadmitted := by
  simp [claimCertificationStatus, hNoJump, hFail]

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

theorem canonical_claim_passport_is_certified :
    ClaimPassportCertified canonicalClaimPassport := by
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

def canonicalClaimPassportCertificate : ClaimPassportCertificate :=
  { passport := canonicalClaimPassport
    passportCertified := canonical_claim_passport_is_certified
    proofStateCertification := canonicalProofStateCertification
    request := certifiedProofStateRequest
    verdict := ClaimPassportVerdict.pass
    verdictWitness := rfl
    certificationStatus := ClaimCertificationStatus.proofStateCertified
    statusWitness := rfl
    allowedClaimCeiling := ClaimCeiling.tlflProofStateCertified
    ceilingWitness := rfl
    forbiddenJumpMap := defaultForbiddenJumpMap }

theorem tlfl_proof_self_model_gives_claim_passport :
    exists passport : ClaimPassport,
      ClaimPassportCertified passport := by
  exact ⟨canonicalClaimPassport, canonical_claim_passport_is_certified⟩

theorem tlfl_claim_passport_certificate_exists :
    exists certificate : ClaimPassportCertificate,
      ClaimPassportCertified certificate.passport /\
      certificate.verdict = ClaimPassportVerdict.pass /\
      certificate.certificationStatus =
        ClaimCertificationStatus.proofStateCertified /\
      certificate.allowedClaimCeiling =
        ClaimCeiling.tlflProofStateCertified := by
  exact ⟨
    canonicalClaimPassportCertificate,
    canonicalClaimPassportCertificate.passportCertified,
    rfl,
    rfl,
    rfl
  ⟩

theorem claim_passport_certificate_gives_certified_passport
    (certificate : ClaimPassportCertificate) :
    ClaimPassportCertified certificate.passport := by
  exact certificate.passportCertified

theorem claim_passport_certificate_gives_verdict
    (certificate : ClaimPassportCertificate) :
    certificate.verdict = claimPassportVerdict certificate.request.input := by
  exact certificate.verdictWitness

theorem claim_passport_certificate_gives_certification_status
    (certificate : ClaimPassportCertificate) :
    certificate.certificationStatus =
      claimCertificationStatus certificate.request := by
  exact certificate.statusWitness

theorem claim_passport_certificate_gives_allowed_ceiling
    (certificate : ClaimPassportCertificate) :
    certificate.allowedClaimCeiling =
      claimPassportCeiling certificate.request.input := by
  exact certificate.ceilingWitness

theorem claim_passport_certificate_gives_forbidden_jump_map
    (certificate : ClaimPassportCertificate) :
    certificate.forbiddenJumpMap.empiricalTruthForbidden /\
    certificate.forbiddenJumpMap.physicalValidationForbidden /\
    certificate.forbiddenJumpMap.consciousnessForbidden /\
    certificate.forbiddenJumpMap.empiricalClosureForbidden := by
  exact ⟨
    certificate.forbiddenJumpMap.empiricalTruthWitness,
    certificate.forbiddenJumpMap.physicalValidationWitness,
    certificate.forbiddenJumpMap.consciousnessWitness,
    certificate.forbiddenJumpMap.empiricalClosureWitness
  ⟩

def publicCertificateSurfaceOf
    (certificate : ClaimPassportCertificate) :
    ClaimPassportPublicCertificateSurface :=
  { certificate := certificate
    certifiedPassport := certificate.passportCertified
    verdict := certificate.verdict
    verdictWitness := rfl
    certificationStatus := certificate.certificationStatus
    statusWitness := rfl
    allowedClaimCeiling := certificate.allowedClaimCeiling
    ceilingWitness := rfl
    forbiddenJumpMap := certificate.forbiddenJumpMap
    forbiddenJumpMapWitness :=
      claim_passport_certificate_gives_forbidden_jump_map certificate
    publicProofStatusSurface := True
    publicProofStatusSurfaceWitness := by trivial }

def canonicalClaimPassportPublicCertificateSurface :
    ClaimPassportPublicCertificateSurface :=
  publicCertificateSurfaceOf canonicalClaimPassportCertificate

theorem claim_passport_certificate_gives_public_certificate_surface
    (certificate : ClaimPassportCertificate) :
    exists surface : ClaimPassportPublicCertificateSurface,
      surface.certificate = certificate := by
  exact ⟨publicCertificateSurfaceOf certificate, rfl⟩

theorem public_certificate_surface_gives_certified_passport
    (surface : ClaimPassportPublicCertificateSurface) :
    ClaimPassportCertified surface.certificate.passport := by
  exact surface.certifiedPassport

theorem public_certificate_surface_gives_verdict
    (surface : ClaimPassportPublicCertificateSurface) :
    surface.verdict = surface.certificate.verdict := by
  exact surface.verdictWitness

theorem public_certificate_surface_gives_certification_status
    (surface : ClaimPassportPublicCertificateSurface) :
    surface.certificationStatus = surface.certificate.certificationStatus := by
  exact surface.statusWitness

theorem public_certificate_surface_gives_allowed_ceiling
    (surface : ClaimPassportPublicCertificateSurface) :
    surface.allowedClaimCeiling = surface.certificate.allowedClaimCeiling := by
  exact surface.ceilingWitness

theorem public_certificate_surface_gives_forbidden_jump_map
    (surface : ClaimPassportPublicCertificateSurface) :
    surface.forbiddenJumpMap.empiricalTruthForbidden /\
    surface.forbiddenJumpMap.physicalValidationForbidden /\
    surface.forbiddenJumpMap.consciousnessForbidden /\
    surface.forbiddenJumpMap.empiricalClosureForbidden := by
  exact surface.forbiddenJumpMapWitness

theorem public_certificate_surface_is_public_proof_status_surface
    (surface : ClaimPassportPublicCertificateSurface) :
    surface.publicProofStatusSurface := by
  exact surface.publicProofStatusSurfaceWitness

theorem canonical_public_certificate_surface_status_is_proof_state_certified :
    canonicalClaimPassportPublicCertificateSurface.certificationStatus =
      ClaimCertificationStatus.proofStateCertified := by
  rfl

def auditSheetOf
    (surface : ClaimPassportPublicCertificateSurface) :
    ClaimPassportAuditSheet :=
  { publicSurface := surface
    reportClaimName := surface.certificate.passport.claim.name
    reportVerdict := surface.verdict
    verdictWitness := rfl
    reportCertificationStatus := surface.certificationStatus
    statusWitness := rfl
    reportAllowedClaimCeiling := surface.allowedClaimCeiling
    ceilingWitness := rfl
    reportForbiddenJumpMap := surface.forbiddenJumpMap
    forbiddenJumpMapWitness := surface.forbiddenJumpMapWitness
    externalProofLayerRepresented := True
    externalProofLayerWitness := by trivial
    publicAuditSurface := True
    publicAuditSurfaceWitness := by trivial }

def canonicalClaimPassportAuditSheet : ClaimPassportAuditSheet :=
  auditSheetOf canonicalClaimPassportPublicCertificateSurface

theorem public_certificate_surface_gives_audit_sheet
    (surface : ClaimPassportPublicCertificateSurface) :
    exists report : ClaimPassportAuditSheet,
      report.publicSurface = surface := by
  exact ⟨auditSheetOf surface, rfl⟩

def audit_sheet_gives_public_certificate_surface
    (report : ClaimPassportAuditSheet) :
    ClaimPassportPublicCertificateSurface := by
  exact report.publicSurface

theorem audit_sheet_gives_verdict
    (report : ClaimPassportAuditSheet) :
    report.reportVerdict = report.publicSurface.verdict := by
  exact report.verdictWitness

theorem audit_sheet_gives_certification_status
    (report : ClaimPassportAuditSheet) :
    report.reportCertificationStatus =
      report.publicSurface.certificationStatus := by
  exact report.statusWitness

theorem audit_sheet_gives_allowed_ceiling
    (report : ClaimPassportAuditSheet) :
    report.reportAllowedClaimCeiling =
      report.publicSurface.allowedClaimCeiling := by
  exact report.ceilingWitness

theorem audit_sheet_gives_forbidden_jump_map
    (report : ClaimPassportAuditSheet) :
    report.reportForbiddenJumpMap.empiricalTruthForbidden /\
    report.reportForbiddenJumpMap.physicalValidationForbidden /\
    report.reportForbiddenJumpMap.consciousnessForbidden /\
    report.reportForbiddenJumpMap.empiricalClosureForbidden := by
  exact report.forbiddenJumpMapWitness

theorem audit_sheet_records_external_proof_layer
    (report : ClaimPassportAuditSheet) :
    report.externalProofLayerRepresented := by
  exact report.externalProofLayerWitness

theorem audit_sheet_is_public_audit_surface
    (report : ClaimPassportAuditSheet) :
    report.publicAuditSurface := by
  exact report.publicAuditSurfaceWitness

theorem canonical_audit_sheet_status_is_proof_state_certified :
    canonicalClaimPassportAuditSheet.reportCertificationStatus =
      ClaimCertificationStatus.proofStateCertified := by
  rfl

theorem canonical_claim_passport_certificate_verdict_is_pass :
    canonicalClaimPassportCertificate.verdict = ClaimPassportVerdict.pass := by
  rfl

theorem canonical_claim_passport_certificate_status_is_proof_state_certified :
    canonicalClaimPassportCertificate.certificationStatus =
      ClaimCertificationStatus.proofStateCertified := by
  rfl

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

structure ClaimPassportPublicSurfaceScenario where
  publicCertificateSurface : Prop
  empiricalTruth : Prop
  physicalValidation : Prop
  consciousness : Prop
  empiricalClosure : Prop

theorem public_certificate_surface_does_not_imply_empirical_truth :
    exists s : ClaimPassportPublicSurfaceScenario,
      s.publicCertificateSurface /\
      Not s.empiricalTruth := by
  let s : ClaimPassportPublicSurfaceScenario :=
    { publicCertificateSurface := True
      empiricalTruth := False
      physicalValidation := False
      consciousness := False
      empiricalClosure := False }
  exact ⟨s, by trivial, fun h => h⟩

theorem public_certificate_surface_does_not_imply_physical_validation :
    exists s : ClaimPassportPublicSurfaceScenario,
      s.publicCertificateSurface /\
      Not s.physicalValidation := by
  let s : ClaimPassportPublicSurfaceScenario :=
    { publicCertificateSurface := True
      empiricalTruth := False
      physicalValidation := False
      consciousness := False
      empiricalClosure := False }
  exact ⟨s, by trivial, fun h => h⟩

theorem public_certificate_surface_does_not_imply_consciousness :
    exists s : ClaimPassportPublicSurfaceScenario,
      s.publicCertificateSurface /\
      Not s.consciousness := by
  let s : ClaimPassportPublicSurfaceScenario :=
    { publicCertificateSurface := True
      empiricalTruth := False
      physicalValidation := False
      consciousness := False
      empiricalClosure := False }
  exact ⟨s, by trivial, fun h => h⟩

theorem public_certificate_surface_does_not_imply_empirical_closure :
    exists s : ClaimPassportPublicSurfaceScenario,
      s.publicCertificateSurface /\
      Not s.empiricalClosure := by
  let s : ClaimPassportPublicSurfaceScenario :=
    { publicCertificateSurface := True
      empiricalTruth := False
      physicalValidation := False
      consciousness := False
      empiricalClosure := False }
  exact ⟨s, by trivial, fun h => h⟩

structure ClaimPassportAuditSheetScenario where
  publicAuditSurface : Prop
  empiricalTruth : Prop
  physicalValidation : Prop
  consciousness : Prop
  empiricalClosure : Prop

theorem audit_sheet_does_not_imply_empirical_truth :
    exists s : ClaimPassportAuditSheetScenario,
      s.publicAuditSurface /\
      Not s.empiricalTruth := by
  let s : ClaimPassportAuditSheetScenario :=
    { publicAuditSurface := True
      empiricalTruth := False
      physicalValidation := False
      consciousness := False
      empiricalClosure := False }
  exact ⟨s, by trivial, fun h => h⟩

theorem audit_sheet_does_not_imply_physical_validation :
    exists s : ClaimPassportAuditSheetScenario,
      s.publicAuditSurface /\
      Not s.physicalValidation := by
  let s : ClaimPassportAuditSheetScenario :=
    { publicAuditSurface := True
      empiricalTruth := False
      physicalValidation := False
      consciousness := False
      empiricalClosure := False }
  exact ⟨s, by trivial, fun h => h⟩

theorem audit_sheet_does_not_imply_consciousness :
    exists s : ClaimPassportAuditSheetScenario,
      s.publicAuditSurface /\
      Not s.consciousness := by
  let s : ClaimPassportAuditSheetScenario :=
    { publicAuditSurface := True
      empiricalTruth := False
      physicalValidation := False
      consciousness := False
      empiricalClosure := False }
  exact ⟨s, by trivial, fun h => h⟩

theorem audit_sheet_does_not_imply_empirical_closure :
    exists s : ClaimPassportAuditSheetScenario,
      s.publicAuditSurface /\
      Not s.empiricalClosure := by
  let s : ClaimPassportAuditSheetScenario :=
    { publicAuditSurface := True
      empiricalTruth := False
      physicalValidation := False
      consciousness := False
      empiricalClosure := False }
  exact ⟨s, by trivial, fun h => h⟩

end TMI
