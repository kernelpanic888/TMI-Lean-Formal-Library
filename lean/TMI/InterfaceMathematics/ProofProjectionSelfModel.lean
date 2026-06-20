/-
Interface Mathematics: proof projection to self-model.

This layer makes explicit a stricter reading of the canonical
`TLFL + Z3 + Vampire + E proof layer` chain. External prover traces are not yet a strict
self-model. They must first be admitted through a formal boundary and only then
be integrated by TLFL into an internally referential proof-state model.
-/

import TMI.ProofChainSelfModel
import TMI.InterfaceMathematics.SelfModelingProver

namespace TMI
namespace InterfaceMathematics

structure ExternalProofProjection where
  externalProofTrace : TMI.ExternalProofTrace

structure IntegratedProofProjection where
  externalProjection : ExternalProofProjection
  claimClassification : TMI.ClaimClassification
  classificationWitness : TMI.TLFLClassifiesClaim claimClassification

structure SelfReferentialProofModel where
  integratedProjection : IntegratedProofProjection
  proofSelfModel : TMI.TLFLProofSelfModel
  chainNameIsCanonical :
    proofSelfModel.chainName = "TLFL + Z3 + Vampire + E proof layer"
  classificationMatches :
    proofSelfModel.claimClassification =
      integratedProjection.claimClassification

structure OLeanAdmittedProofProjection where
  externalProjection : ExternalProofProjection
  boundaryAdmitted : Prop
  boundaryWitness : boundaryAdmitted

structure OLeanAdmittedIntegratedProjection where
  admittedProjection : OLeanAdmittedProofProjection
  claimClassification : TMI.ClaimClassification
  classificationWitness : TMI.TLFLClassifiesClaim claimClassification

structure OLeanAdmittedSelfModel where
  admittedIntegratedProjection : OLeanAdmittedIntegratedProjection
  selfModel : SelfReferentialProofModel
  admittedClassificationMatches :
    selfModel.integratedProjection.claimClassification =
      admittedIntegratedProjection.claimClassification

def integratedProofProjectionOf
    (projection : ExternalProofProjection)
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    IntegratedProofProjection :=
  { externalProjection := projection
    claimClassification := classification
    classificationWitness := h }

def selfReferentialProofModelOf
    (projection : ExternalProofProjection)
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    SelfReferentialProofModel :=
  { integratedProjection := integratedProofProjectionOf projection classification h
    proofSelfModel :=
      TMI.proofChainSelfModelOf projection.externalProofTrace classification h
    chainNameIsCanonical := by rfl
    classificationMatches := rfl }

def oleanAdmittedIntegratedProjectionOf
    (projection : OLeanAdmittedProofProjection)
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    OLeanAdmittedIntegratedProjection :=
  { admittedProjection := projection
    claimClassification := classification
    classificationWitness := h }

def oleanAdmittedSelfModelOf
    (projection : OLeanAdmittedProofProjection)
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    OLeanAdmittedSelfModel :=
  { admittedIntegratedProjection :=
      oleanAdmittedIntegratedProjectionOf projection classification h
    selfModel :=
      selfReferentialProofModelOf projection.externalProjection classification h
    admittedClassificationMatches := rfl }

theorem external_projection_and_tlfl_classification_give_integrated_projection
    (projection : ExternalProofProjection)
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    exists p : IntegratedProofProjection,
      p = integratedProofProjectionOf projection classification h := by
  exact ⟨integratedProofProjectionOf projection classification h, rfl⟩

theorem integrated_projection_gives_self_referential_proof_model
    (projection : ExternalProofProjection)
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    exists m : SelfReferentialProofModel,
      m = selfReferentialProofModelOf projection classification h := by
  exact ⟨selfReferentialProofModelOf projection classification h, rfl⟩

theorem olean_admitted_projection_and_tlfl_classification_give_admitted_integrated_projection
    (projection : OLeanAdmittedProofProjection)
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    exists p : OLeanAdmittedIntegratedProjection,
      p = oleanAdmittedIntegratedProjectionOf projection classification h := by
  exact ⟨oleanAdmittedIntegratedProjectionOf projection classification h, rfl⟩

theorem olean_admitted_projection_and_tlfl_classification_give_strict_admitted_self_model
    (projection : OLeanAdmittedProofProjection)
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    exists m : OLeanAdmittedSelfModel,
      m = oleanAdmittedSelfModelOf projection classification h := by
  exact ⟨oleanAdmittedSelfModelOf projection classification h, rfl⟩

structure ProofProjectionScenario where
  externalProjection : Prop
  oleanAdmitted : Prop
  tlflClassified : Prop
  strictSelfModel : Prop
  empiricalClosure : Prop
  consciousness : Prop

theorem external_proof_projection_alone_does_not_imply_self_model :
    exists s : ProofProjectionScenario,
      s.externalProjection /\
      Not s.strictSelfModel := by
  let s : ProofProjectionScenario :=
    { externalProjection := True
      oleanAdmitted := False
      tlflClassified := False
      strictSelfModel := False
      empiricalClosure := False
      consciousness := False }
  exact ⟨s, by trivial, fun h => h⟩

theorem olean_admission_alone_does_not_imply_self_model :
    exists s : ProofProjectionScenario,
      s.oleanAdmitted /\
      Not s.strictSelfModel := by
  let s : ProofProjectionScenario :=
    { externalProjection := False
      oleanAdmitted := True
      tlflClassified := False
      strictSelfModel := False
      empiricalClosure := False
      consciousness := False }
  exact ⟨s, by trivial, fun h => h⟩

theorem tlfl_classification_without_olean_admission_does_not_imply_strict_admitted_self_model :
    exists s : ProofProjectionScenario,
      s.tlflClassified /\
      Not s.oleanAdmitted /\
      Not s.strictSelfModel := by
  let s : ProofProjectionScenario :=
    { externalProjection := True
      oleanAdmitted := False
      tlflClassified := True
      strictSelfModel := False
      empiricalClosure := False
      consciousness := False }
  exact ⟨s, by trivial, fun h => h, fun h => h⟩

theorem olean_admitted_self_model_does_not_imply_empirical_closure :
    exists s : ProofProjectionScenario,
      s.strictSelfModel /\
      Not s.empiricalClosure := by
  let s : ProofProjectionScenario :=
    { externalProjection := True
      oleanAdmitted := True
      tlflClassified := True
      strictSelfModel := True
      empiricalClosure := False
      consciousness := False }
  exact ⟨s, by trivial, fun h => h⟩

theorem olean_admitted_self_model_does_not_imply_consciousness :
    exists s : ProofProjectionScenario,
      s.strictSelfModel /\
      Not s.consciousness := by
  let s : ProofProjectionScenario :=
    { externalProjection := True
      oleanAdmitted := True
      tlflClassified := True
      strictSelfModel := True
      empiricalClosure := False
      consciousness := False }
  exact ⟨s, by trivial, fun h => h⟩

end InterfaceMathematics
end TMI
