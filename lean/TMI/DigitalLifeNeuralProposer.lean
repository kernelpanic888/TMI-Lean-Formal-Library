import TMI.DigitalLifeRuntimeAdapter

/-!
# DL-05 minimal neural proposer

This module adds a deliberately small neural proposal layer to the executable
DL-04 runtime. The proposer computes a signed linear score and quantizes it to
one of three candidate inputs. It does not own the action field, the selector,
time admission, policy, identity, verification, or receipt extension.

Red boundary: this is a formal proposer interface, not a claim of artificial
general intelligence, consciousness, learning, or autonomous authority.
-/

namespace TMI.DigitalLifeNeuralProposer

open TMI.DigitalLifeTwoAxisTick
open TMI.DigitalLifeRuntimeAdapter

structure NeuralParameters where
  wx : Int
  wy : Int
  wz : Int
  wm : Int
  wr : Int
  bias : Int
  deriving DecidableEq, Repr

def score (parameters : NeuralParameters) (state : DL04State) : Int :=
  parameters.wx * state.x +
  parameters.wy * state.y +
  parameters.wz * state.z +
  parameters.wm * state.memory +
  parameters.wr * state.reflection +
  parameters.bias

def quantize (value : Int) : Int :=
  if value < 0 then -1 else if value = 0 then 0 else 1

def proposeInput (parameters : NeuralParameters) (state : DL04State) : Int :=
  quantize (score parameters state)

def proposeAction (parameters : NeuralParameters) (state : DL04State) : DL04Action :=
  .advance (proposeInput parameters state)

def neuralActionField : List DL04Action :=
  [.advance (-1), .advance 0, .advance 1]

def eventFromAction (state : DL04State) (action : DL04Action) :
    TickEnvelope DL04State DL04Action Nat Nat :=
  { before := state
    field := neuralActionField
    action := action
    after := applyAction state action
    previousTime := ⟨state.n, state.n⟩
    nextTime := ⟨state.n + 1, state.n + 1⟩ }

def neuralEnvelope (parameters : NeuralParameters) (state : DL04State) :
    TickEnvelope DL04State DL04Action Nat Nat :=
  eventFromAction state (proposeAction parameters state)

theorem quantize_cases (value : Int) :
    quantize value = -1 ∨ quantize value = 0 ∨ quantize value = 1 := by
  by_cases hNegative : value < 0
  · exact Or.inl (by simp [quantize, hNegative])
  · by_cases hZero : value = 0
    · exact Or.inr (Or.inl (by simp [quantize, hNegative, hZero]))
    · exact Or.inr (Or.inr (by simp [quantize, hNegative, hZero]))

theorem neural_proposal_in_field
    (parameters : NeuralParameters)
    (state : DL04State) :
    proposeAction parameters state ∈ neuralActionField := by
  rcases quantize_cases (score parameters state) with h | h | h
  · simp [proposeAction, proposeInput, neuralActionField, h]
  · simp [proposeAction, proposeInput, neuralActionField, h]
  · simp [proposeAction, proposeInput, neuralActionField, h]

theorem neural_generated_admitted
    (parameters : NeuralParameters)
    (state : DL04State)
    (hSafe : safe state) :
    AdmittedTick contract (neuralEnvelope parameters state) := by
  let action := proposeAction parameters state
  have hField : action ∈ neuralActionField :=
    neural_proposal_in_field parameters state
  have hSafeAfter : safe (applyAction state action) :=
    safe_after_apply state action hSafe
  exact
    { timeAdmissible := rfl
      laboratoryAdvances := rfl
      relationalAdvances := rfl
      selectedFromField := by
        simpa [neuralEnvelope, eventFromAction, action] using hField
      applied := rfl
      policyAdmits := ⟨hSafe, hSafeAfter⟩
      identityPreserved := by cases action <;> rfl
      safeAfter := hSafeAfter
      postVerified := ⟨rfl, hSafeAfter⟩
      certificateExtended := by cases action <;> rfl }

def neuralExecute (parameters : NeuralParameters) (state : DL04State) : DL04State :=
  nextOrHold validator (neuralEnvelope parameters state)

def demoParameters : NeuralParameters :=
  { wx := 1, wy := -1, wz := 1, wm := 1, wr := -1, bias := 1 }

def outOfFieldEnvelope : TickEnvelope DL04State DL04Action Nat Nat :=
  eventFromAction seed (.advance 7)

theorem demo_action_at_seed :
    proposeAction demoParameters seed = .advance 1 := by
  native_decide

theorem neural_first_tick_admitted :
    AdmittedTick contract (neuralEnvelope demoParameters seed) :=
  neural_generated_admitted demoParameters seed seed_is_safe

theorem out_of_field_is_rejected :
    check outOfFieldEnvelope = false := by
  native_decide

theorem out_of_field_holds_seed :
    nextOrHold validator outOfFieldEnvelope = seed := by
  native_decide

end TMI.DigitalLifeNeuralProposer
