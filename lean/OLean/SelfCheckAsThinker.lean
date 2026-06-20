/-
OLean self-check as a TMI thinker.

This module verifies that the OLean boundary self-check can be read as a
thinker interface in the TMI sense: it receives a boundary input, builds an
internal model, tests admissibility, produces a verdict, and records the result.
The theorem is formal/mathematical only; it does not claim empirical physical
validation.
-/

import OLean.SelfCheck
import TMI.InterfaceMathematics
import TMI.ProofChainSelfModel

namespace OLean

structure SelfCheckThinkerModel where
  input : BoundaryCheckInput
  verdict : CheckVerdict
  frequencyValue : Option Nat
deriving DecidableEq, Repr

def selfCheckModelOf (i : BoundaryCheckInput) : SelfCheckThinkerModel :=
  { input := i
    verdict := boundaryCheckVerdict i
    frequencyValue := i.internalFrequencyValue }

def SelfCheckThinkerContext :
    TMI.InterfaceMathematics.ThinkerVerificationContext :=
  { Thinker := Unit
    Theory := BoundaryCheckInput
    Model := SelfCheckThinkerModel
    Prediction := CheckVerdict
    Measurement := CheckVerdict
    Record := CheckVerdict
    interface := fun _ => True
    receives_distinctions := fun _ => True
    input_theory := fun _ _ => True
    theory := fun _ => True
    candidate := fun _ => True
    theory_gives_candidate := by
      intro _t _hTheory
      trivial
    builds_internal_model := fun _ t m => m = selfCheckModelOf t
    tests_admissible_transitions := fun _ t m =>
      m.input = t /\ m.verdict = boundaryCheckVerdict t
    produces_conclusion := fun _ t m =>
      m.verdict = boundaryCheckVerdict t
    records_result := fun _ t m =>
      m.verdict = boundaryCheckVerdict t /\
        m.frequencyValue = t.internalFrequencyValue
    model_states := fun _ => True
    model_transitions := fun _ => True
    model_predictions := fun _ => True
    model_expected_records := fun _ => True
    prediction_of := fun t p => p = boundaryCheckVerdict t
    measurement_of := fun p m => m = p
    record_of := fun m r => r = m
    reproducible := fun _ => True }

def SelfCheckThinker : SelfCheckThinkerContext.Thinker := ()

def SelfCheckTargetTheory : SelfCheckThinkerContext.Theory :=
  completeBoundaryCheckInput

def SelfCheckTargetModel : SelfCheckThinkerContext.Model :=
  selfCheckModelOf SelfCheckTargetTheory

theorem self_check_target_verdict_is_pass :
    boundaryCheckVerdict SelfCheckTargetTheory = CheckVerdict.pass := by
  rfl

theorem self_check_target_frequency_is_749 :
    SelfCheckTargetTheory.internalFrequencyValue = some 749 := by
  rfl

theorem self_check_passes_thinker_interface :
    TMI.InterfaceMathematics.ThinkerInterface
      SelfCheckThinkerContext
      SelfCheckThinker := by
  exact ⟨by trivial, by trivial⟩

theorem self_check_has_internal_model_witness :
    TMI.InterfaceMathematics.InternalModelWitness
      SelfCheckThinkerContext
      SelfCheckThinker
      SelfCheckTargetTheory := by
  refine ⟨SelfCheckTargetModel, ?_, ?_, ?_, ?_, ?_⟩
  · rfl
  · exact ⟨rfl, rfl⟩
  · rfl
  · exact ⟨rfl, rfl⟩
  · exact ⟨by trivial, by trivial, by trivial, by trivial⟩

theorem self_check_passes_thinker_run :
    TMI.InterfaceMathematics.ThinkerRun
      SelfCheckThinkerContext
      SelfCheckThinker
      SelfCheckTargetTheory := by
  exact ⟨
    self_check_passes_thinker_interface,
    by trivial,
    by trivial,
    self_check_has_internal_model_witness
  ⟩

theorem self_check_operates_intelligence_interface :
    TMI.InterfaceMathematics.ThinkerOperatesIntelligenceInterface
      SelfCheckThinkerContext
      SelfCheckThinker
      SelfCheckTargetTheory := by
  exact TMI.InterfaceMathematics.thinker_run_gives_operates_intelligence_interface
    self_check_passes_thinker_run

def SelfCheckPassesThinkerTest : Prop :=
  TMI.InterfaceMathematics.Thinker
    SelfCheckThinkerContext
    SelfCheckThinker

theorem self_check_passes_thinker_test :
    SelfCheckPassesThinkerTest := by
  exact ⟨
    self_check_passes_thinker_interface,
    ⟨SelfCheckTargetTheory, self_check_passes_thinker_run⟩
  ⟩

def SelfCheckSelfModelingProverContext :
    TMI.InterfaceMathematics.SelfModelingProverContext :=
  { Thinker := Unit
    Theory := BoundaryCheckInput
    Model := SelfCheckThinkerModel
    Statement := CheckVerdict
    ProofObject := BoundaryCheckInput
    thinker_interface := fun _ => SelfCheckPassesThinkerTest
    theory_candidate := fun t => t.complete = true
    self_model_of_theory := fun _ t m => m = selfCheckModelOf t
    projectional_self_check := fun _ t m =>
      m.verdict = boundaryCheckVerdict t
    statement_of_theory := fun t s => s = boundaryCheckVerdict t
    proof_object_for := fun t s p =>
      p = t /\ s = boundaryCheckVerdict t
    proof_rules_checked := fun p => p.complete = true
    proof_object_verified := fun p =>
      boundaryCheckVerdict p = CheckVerdict.pass
    formal_system_closed_for := fun _ => True
    guarantee_inside_formal_system := fun _ _ _ => True
    empirical_measurement_record := fun _ => False }

theorem self_check_has_formal_self_validation :
    TMI.InterfaceMathematics.FormalSelfValidation
      SelfCheckSelfModelingProverContext
      ()
      SelfCheckTargetTheory
      CheckVerdict.pass := by
  exact ⟨
    ⟨SelfCheckTargetModel,
      self_check_passes_thinker_test,
      by rfl,
      by rfl,
      by rfl⟩,
    by rfl,
    by trivial,
    ⟨SelfCheckTargetTheory,
      ⟨rfl, rfl⟩,
      by rfl,
      by rfl,
      by trivial⟩
  ⟩

theorem self_check_is_mathematical_external_prover :
    TMI.InterfaceMathematics.MathematicalExternalProverInterface
      SelfCheckSelfModelingProverContext
      ()
      SelfCheckTargetTheory := by
  exact TMI.InterfaceMathematics.formal_self_validation_gives_mathematical_external_prover
    self_check_has_formal_self_validation

theorem self_check_thinker_test_does_not_claim_empirical_physical_validation :
    Not
      (TMI.InterfaceMathematics.EmpiricalPhysicalValidation
        SelfCheckSelfModelingProverContext
        SelfCheckTargetTheory) := by
  intro h
  exact h

theorem self_check_builds_vampire_z3_e_tlfl_proof_self_model :
    exists model : TMI.TLFLProofSelfModel,
      model.chainName = "TLFL + Z3 + Vampire + E proof layer" /\
      TMI.TLFLClassifiesClaim model.claimClassification := by
  exact TMI.vampire_z3_e_tlfl_chain_builds_proof_self_model

end OLean
