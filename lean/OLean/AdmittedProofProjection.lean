/-
OLean-admitted proof projection.

This module instantiates the strict projection reading: external proof traces
from `Z3/Vampire/E` become part of a strict self-model only after admission by
the OLean boundary and TLFL integration.
-/

import OLean.SelfCheck
import OLean.SelfCheckAsThinker
import TMI.InterfaceMathematics.ProofProjectionSelfModel

namespace OLean

def selfCheckExternalProofProjection :
    TMI.InterfaceMathematics.ExternalProofProjection :=
  { externalProofTrace := TMI.completeExternalProofTrace }

def selfCheckOLeanAdmittedProofProjection :
    TMI.InterfaceMathematics.OLeanAdmittedProofProjection :=
  { externalProjection := selfCheckExternalProofProjection
    boundaryAdmitted :=
      boundaryCheckVerdict SelfCheckTargetTheory = CheckVerdict.pass
    boundaryWitness := self_check_target_verdict_is_pass }

def selfCheckOLeanAdmittedIntegratedProjection :
    TMI.InterfaceMathematics.OLeanAdmittedIntegratedProjection :=
  TMI.InterfaceMathematics.oleanAdmittedIntegratedProjectionOf
    selfCheckOLeanAdmittedProofProjection
    TMI.vampireZ3ETLFLClaimClassification
    TMI.tlfl_meta_interface_gives_claim_classification

def selfCheckOLeanAdmittedSelfModel :
    TMI.InterfaceMathematics.OLeanAdmittedSelfModel :=
  TMI.InterfaceMathematics.oleanAdmittedSelfModelOf
    selfCheckOLeanAdmittedProofProjection
    TMI.vampireZ3ETLFLClaimClassification
    TMI.tlfl_meta_interface_gives_claim_classification

theorem olean_admits_external_proof_projection :
    selfCheckOLeanAdmittedProofProjection.boundaryAdmitted := by
  exact selfCheckOLeanAdmittedProofProjection.boundaryWitness

theorem olean_admitted_projection_is_tlfl_integrable :
    TMI.TLFLClassifiesClaim
      selfCheckOLeanAdmittedIntegratedProjection.claimClassification := by
  exact selfCheckOLeanAdmittedIntegratedProjection.classificationWitness

theorem olean_admitted_projection_integrates_to_self_model :
    exists m : TMI.InterfaceMathematics.SelfReferentialProofModel,
      m = selfCheckOLeanAdmittedSelfModel.selfModel := by
  exact ⟨selfCheckOLeanAdmittedSelfModel.selfModel, rfl⟩

theorem olean_admitted_self_model_is_canonical_witness :
    selfCheckOLeanAdmittedSelfModel.selfModel.proofSelfModel.chainName =
      "TLFL + Z3 + Vampire + E proof layer" := by
  exact selfCheckOLeanAdmittedSelfModel.selfModel.chainNameIsCanonical

theorem self_check_gives_olean_admitted_projection :
    exists p : TMI.InterfaceMathematics.OLeanAdmittedProofProjection,
      p = selfCheckOLeanAdmittedProofProjection := by
  exact ⟨selfCheckOLeanAdmittedProofProjection, rfl⟩

theorem olean_admitted_projection_gives_self_model :
    exists m : TMI.InterfaceMathematics.OLeanAdmittedSelfModel,
      m = selfCheckOLeanAdmittedSelfModel := by
  exact ⟨selfCheckOLeanAdmittedSelfModel, rfl⟩

end OLean
