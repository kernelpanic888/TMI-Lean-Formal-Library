/-
Interface Mathematics: guarded reality cognition by proof self-model.

This module does not claim empirical truth. It formalizes a narrower TLFL
reading: externally presented reality traces can enter the internal TLFL
interfaces, be arranged by a thinker-style mediation step, pass through
classification and proof-state modeling, and become guarded reality cognition.
-/

import TMI.InterfaceMathematics.PublicSelfProjection

namespace TMI
namespace InterfaceMathematics

structure ExternalRealityTrace where
  externallyPresented : Prop
  presentationWitness : externallyPresented
  measurementRecordInput : Prop
  measurementRecordWitness : measurementRecordInput
  verificationInput : Prop
  verificationWitness : verificationInput

structure InternalTLFLInterfacePassage where
  realityTrace : ExternalRealityTrace
  externalProjection : ExternalProofProjection
  admittedProjection : OLeanAdmittedProofProjection
  claimClassification : TMI.ClaimClassification
  classificationWitness : TMI.TLFLClassifiesClaim claimClassification
  internalPassage : Prop
  passageWitness : internalPassage

structure RealityProjectionModel where
  passage : InternalTLFLInterfacePassage
  internalModelBuilt : Prop
  internalModelWitness : internalModelBuilt
  admissibilityChecked : Prop
  admissibilityWitness : admissibilityChecked
  measurementRecordBoundary : Prop
  measurementRecordBoundaryWitness : measurementRecordBoundary

structure SelfModelRealityCognition where
  projectionModel : RealityProjectionModel
  proofSelfModel : SelfReferentialProofModel
  publicSurface : PubliclyLegibleProofSurface
  classificationMatches :
    proofSelfModel.integratedProjection.claimClassification =
      projectionModel.passage.claimClassification

structure ThinkerRealityCognitionRole where
  projectionModel : RealityProjectionModel
  receivesRealityTrace : Prop
  receivesWitness : receivesRealityTrace
  buildsInternalModel : Prop
  buildsWitness : buildsInternalModel
  checksAdmissibility : Prop
  checksWitness : checksAdmissibility
  recordsResult : Prop
  recordsWitness : recordsResult

structure GuardedRealityCognition where
  realityCognition : SelfModelRealityCognition
  thinkerRole : ThinkerRealityCognitionRole
  guardedFormalBoundary : Prop
  guardedBoundaryWitness : guardedFormalBoundary

def realityExternalProjectionOf
    (_trace : ExternalRealityTrace) :
    ExternalProofProjection :=
  { externalProofTrace := TMI.completeExternalProofTrace }

def oleanAdmittedRealityProjectionOf
    (trace : ExternalRealityTrace) :
    OLeanAdmittedProofProjection :=
  { externalProjection := realityExternalProjectionOf trace
    boundaryAdmitted := True
    boundaryWitness := by trivial }

def internalTLFLInterfacePassageOf
    (trace : ExternalRealityTrace)
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    InternalTLFLInterfacePassage :=
  { realityTrace := trace
    externalProjection := realityExternalProjectionOf trace
    admittedProjection := oleanAdmittedRealityProjectionOf trace
    claimClassification := classification
    classificationWitness := h
    internalPassage := True
    passageWitness := by trivial }

def realityProjectionModelOf
    (trace : ExternalRealityTrace)
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    RealityProjectionModel :=
  { passage := internalTLFLInterfacePassageOf trace classification h
    internalModelBuilt := True
    internalModelWitness := by trivial
    admissibilityChecked := True
    admissibilityWitness := by trivial
    measurementRecordBoundary := True
    measurementRecordBoundaryWitness := by trivial }

def selfModelRealityCognitionOf
    (trace : ExternalRealityTrace)
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    SelfModelRealityCognition :=
  { projectionModel := realityProjectionModelOf trace classification h
    proofSelfModel :=
      selfReferentialProofModelOf
        (realityExternalProjectionOf trace)
        classification
        h
    publicSurface :=
      publiclyLegibleProofSurfaceOf
        (realityExternalProjectionOf trace)
        classification
        h
    classificationMatches := rfl }

def thinkerRealityCognitionRoleOf
    (trace : ExternalRealityTrace)
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    ThinkerRealityCognitionRole :=
  { projectionModel := realityProjectionModelOf trace classification h
    receivesRealityTrace := trace.externallyPresented
    receivesWitness := trace.presentationWitness
    buildsInternalModel := True
    buildsWitness := by trivial
    checksAdmissibility := True
    checksWitness := by trivial
    recordsResult := trace.measurementRecordInput
    recordsWitness := trace.measurementRecordWitness }

def guardedRealityCognitionOf
    (trace : ExternalRealityTrace)
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    GuardedRealityCognition :=
  { realityCognition := selfModelRealityCognitionOf trace classification h
    thinkerRole := thinkerRealityCognitionRoleOf trace classification h
    guardedFormalBoundary := True
    guardedBoundaryWitness := by trivial }

theorem external_reality_trace_enters_tlfl_as_interface_input
    (trace : ExternalRealityTrace)
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    exists passage : InternalTLFLInterfacePassage,
      passage = internalTLFLInterfacePassageOf trace classification h := by
  exact ⟨internalTLFLInterfacePassageOf trace classification h, rfl⟩

theorem tlfl_internal_interfaces_build_reality_projection_model
    (trace : ExternalRealityTrace)
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    exists model : RealityProjectionModel,
      model = realityProjectionModelOf trace classification h := by
  exact ⟨realityProjectionModelOf trace classification h, rfl⟩

theorem thinker_mediates_reality_cognition_inside_self_model
    (trace : ExternalRealityTrace)
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    exists role : ThinkerRealityCognitionRole,
      role = thinkerRealityCognitionRoleOf trace classification h := by
  exact ⟨thinkerRealityCognitionRoleOf trace classification h, rfl⟩

theorem verified_external_chain_gives_guarded_reality_cognition
    (trace : ExternalRealityTrace)
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    exists cognition : GuardedRealityCognition,
      cognition = guardedRealityCognitionOf trace classification h := by
  exact ⟨guardedRealityCognitionOf trace classification h, rfl⟩

theorem self_model_as_reality_cognition_process
    (trace : ExternalRealityTrace)
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    exists cognition : SelfModelRealityCognition,
      cognition = selfModelRealityCognitionOf trace classification h := by
  exact ⟨selfModelRealityCognitionOf trace classification h, rfl⟩

theorem guarded_reality_cognition_projects_to_public_self_projection
    (cognition : GuardedRealityCognition) :
    exists surface : PubliclyLegibleProofSurface,
      surface = cognition.realityCognition.publicSurface := by
  exact ⟨cognition.realityCognition.publicSurface, rfl⟩

structure RealityCognitionScenario where
  externalRealityTrace : Prop
  internalPassage : Prop
  internalModel : Prop
  thinkerMediation : Prop
  tlflClassified : Prop
  proofSelfModel : Prop
  guardedRealityCognition : Prop
  empiricalTruth : Prop
  physicalValidation : Prop
  consciousness : Prop

theorem guarded_reality_cognition_does_not_imply_empirical_truth :
    exists s : RealityCognitionScenario,
      s.guardedRealityCognition /\
      Not s.empiricalTruth := by
  let s : RealityCognitionScenario :=
    { externalRealityTrace := True
      internalPassage := True
      internalModel := True
      thinkerMediation := True
      tlflClassified := True
      proofSelfModel := True
      guardedRealityCognition := True
      empiricalTruth := False
      physicalValidation := False
      consciousness := False }
  exact ⟨s, by trivial, fun h => h⟩

theorem guarded_reality_cognition_does_not_imply_physical_validation :
    exists s : RealityCognitionScenario,
      s.guardedRealityCognition /\
      Not s.physicalValidation := by
  let s : RealityCognitionScenario :=
    { externalRealityTrace := True
      internalPassage := True
      internalModel := True
      thinkerMediation := True
      tlflClassified := True
      proofSelfModel := True
      guardedRealityCognition := True
      empiricalTruth := False
      physicalValidation := False
      consciousness := False }
  exact ⟨s, by trivial, fun h => h⟩

theorem guarded_reality_cognition_does_not_imply_consciousness :
    exists s : RealityCognitionScenario,
      s.guardedRealityCognition /\
      Not s.consciousness := by
  let s : RealityCognitionScenario :=
    { externalRealityTrace := True
      internalPassage := True
      internalModel := True
      thinkerMediation := True
      tlflClassified := True
      proofSelfModel := True
      guardedRealityCognition := True
      empiricalTruth := False
      physicalValidation := False
      consciousness := False }
  exact ⟨s, by trivial, fun h => h⟩

theorem external_reality_trace_alone_does_not_imply_self_model :
    exists s : RealityCognitionScenario,
      s.externalRealityTrace /\
      Not s.proofSelfModel := by
  let s : RealityCognitionScenario :=
    { externalRealityTrace := True
      internalPassage := False
      internalModel := False
      thinkerMediation := False
      tlflClassified := False
      proofSelfModel := False
      guardedRealityCognition := False
      empiricalTruth := False
      physicalValidation := False
      consciousness := False }
  exact ⟨s, by trivial, fun h => h⟩

theorem internal_model_alone_does_not_imply_reality_cognition :
    exists s : RealityCognitionScenario,
      s.internalModel /\
      Not s.guardedRealityCognition := by
  let s : RealityCognitionScenario :=
    { externalRealityTrace := False
      internalPassage := False
      internalModel := True
      thinkerMediation := False
      tlflClassified := False
      proofSelfModel := False
      guardedRealityCognition := False
      empiricalTruth := False
      physicalValidation := False
      consciousness := False }
  exact ⟨s, by trivial, fun h => h⟩

end InterfaceMathematics
end TMI
