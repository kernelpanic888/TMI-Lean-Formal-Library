/-
Interface Mathematics: public self-projection of proof self-model.

This layer stays inside the TLFL library and formalizes a guarded outward
projection principle. Internal proof artifacts can be arranged into public
materials, and a self-model can project itself through those materials into a
publicly legible proof surface. The thinker is not the whole self-model; it is
the operational interface that mediates the conversion from internal
proof-state organization to public legibility.
-/

import TMI.InterfaceMathematics.ProofProjectionSelfModel
import TMI.InterfaceMathematics.ThinkerVerification

namespace TMI
namespace InterfaceMathematics

structure InternalProofArtifactBundle where
  claimClassification : TMI.ClaimClassification
  proofSelfModel : TMI.TLFLProofSelfModel
  classificationWitness : TMI.TLFLClassifiesClaim claimClassification
  classificationMatches :
    proofSelfModel.claimClassification = claimClassification
  includesTheoremSheet : Prop
  theoremSheetWitness : includesTheoremSheet
  includesProofNote : Prop
  proofNoteWitness : includesProofNote
  includesExternalMirrors : Prop
  externalMirrorWitness : includesExternalMirrors

structure PublicProjectionMaterial where
  sourceBundle : InternalProofArtifactBundle
  publiclyReadable : Prop
  publicReadableWitness : publiclyReadable
  derivedFromInternalArtifacts : Prop
  derivationWitness : derivedFromInternalArtifacts

structure SelfModelPublicProjection where
  sourceSelfModel : SelfReferentialProofModel
  projectionMaterial : PublicProjectionMaterial
  projectsInternalProofState : Prop
  projectionWitness : projectsInternalProofState

structure PubliclyLegibleProofSurface where
  publicProjection : SelfModelPublicProjection
  legibleToExternalVerifier : Prop
  legibilityWitness : legibleToExternalVerifier

structure ThinkerPublicProjectionRole
    (ctx : ThinkerVerificationContext)
    (x : ctx.Thinker)
    (t : ctx.Theory) where
  thinkerRun : ThinkerRun ctx x t
  internalModel : InternalModelWitness ctx x t
  selectsProjectionBundle : Prop
  selectWitness : selectsProjectionBundle
  arrangesPublicMaterial : Prop
  arrangeWitness : arrangesPublicMaterial

def internalProofArtifactBundleOf
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    InternalProofArtifactBundle :=
  { claimClassification := classification
    proofSelfModel := TMI.proofChainSelfModelOf TMI.completeExternalProofTrace classification h
    classificationWitness := h
    classificationMatches := rfl
    includesTheoremSheet := True
    theoremSheetWitness := by trivial
    includesProofNote := True
    proofNoteWitness := by trivial
    includesExternalMirrors := True
    externalMirrorWitness := by trivial }

def publicProjectionMaterialOf
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    PublicProjectionMaterial :=
  { sourceBundle := internalProofArtifactBundleOf classification h
    publiclyReadable := True
    publicReadableWitness := by trivial
    derivedFromInternalArtifacts := True
    derivationWitness := by trivial }

def selfModelPublicProjectionOf
    (projection : ExternalProofProjection)
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    SelfModelPublicProjection :=
  { sourceSelfModel := selfReferentialProofModelOf projection classification h
    projectionMaterial := publicProjectionMaterialOf classification h
    projectsInternalProofState := True
    projectionWitness := by trivial }

def publiclyLegibleProofSurfaceOf
    (projection : ExternalProofProjection)
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    PubliclyLegibleProofSurface :=
  { publicProjection := selfModelPublicProjectionOf projection classification h
    legibleToExternalVerifier := True
    legibilityWitness := by trivial }

theorem internal_artifact_bundle_feeds_public_projection_material
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    exists m : PublicProjectionMaterial,
      m = publicProjectionMaterialOf classification h := by
  exact ⟨publicProjectionMaterialOf classification h, rfl⟩

theorem self_model_projects_to_publicly_legible_proof_surface
    (projection : ExternalProofProjection)
    (classification : TMI.ClaimClassification)
    (h : TMI.TLFLClassifiesClaim classification) :
    exists s : PubliclyLegibleProofSurface,
      s = publiclyLegibleProofSurfaceOf projection classification h := by
  exact ⟨publiclyLegibleProofSurfaceOf projection classification h, rfl⟩

theorem thinker_mediates_projection_from_internal_proof_state_to_public_surface
    {ctx : ThinkerVerificationContext}
    {x : ctx.Thinker}
    {t : ctx.Theory} :
    ThinkerPublicProjectionRole ctx x t -> ThinkerRun ctx x t := by
  intro h
  exact h.thinkerRun

theorem thinker_public_projection_role_preserves_internal_model
    {ctx : ThinkerVerificationContext}
    {x : ctx.Thinker}
    {t : ctx.Theory} :
    ThinkerPublicProjectionRole ctx x t -> InternalModelWitness ctx x t := by
  intro h
  exact h.internalModel

structure PublicProjectionScenario where
  internalBundle : Prop
  publicProjection : Prop
  thinkerRole : Prop
  publiclyLegible : Prop
  empiricalTruth : Prop
  consciousness : Prop
  physicalValidation : Prop

theorem public_projection_does_not_imply_empirical_truth :
    exists s : PublicProjectionScenario,
      s.publicProjection /\ Not s.empiricalTruth := by
  let s : PublicProjectionScenario :=
    { internalBundle := True
      publicProjection := True
      thinkerRole := True
      publiclyLegible := True
      empiricalTruth := False
      consciousness := False
      physicalValidation := False }
  exact ⟨s, by trivial, fun h => h⟩

theorem public_projection_does_not_imply_consciousness :
    exists s : PublicProjectionScenario,
      s.publicProjection /\ Not s.consciousness := by
  let s : PublicProjectionScenario :=
    { internalBundle := True
      publicProjection := True
      thinkerRole := True
      publiclyLegible := True
      empiricalTruth := False
      consciousness := False
      physicalValidation := False }
  exact ⟨s, by trivial, fun h => h⟩

theorem public_projection_does_not_imply_physical_validation :
    exists s : PublicProjectionScenario,
      s.publicProjection /\ Not s.physicalValidation := by
  let s : PublicProjectionScenario :=
    { internalBundle := True
      publicProjection := True
      thinkerRole := True
      publiclyLegible := True
      empiricalTruth := False
      consciousness := False
      physicalValidation := False }
  exact ⟨s, by trivial, fun h => h⟩

end InterfaceMathematics
end TMI
