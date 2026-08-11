import TMI.DigitalLifeNeuralProposer

/-!
# Bounded learning for the digital-life runtime

The neural component may propose a parameter delta. It does not authorize
that delta. A separate learning gate admits an update only when the delta is
componentwise bounded and an external validation loss does not increase.

This is an internal transition contract. It does not establish intelligence,
consciousness, optimal learning, or empirical predictive power.
-/

namespace TMI.DigitalLifeBoundedLearning

open TMI.DigitalLifeNeuralProposer

structure ParameterDelta where
  wx : Int
  wy : Int
  wz : Int
  wm : Int
  wr : Int
  bias : Int
  deriving DecidableEq, Repr

def UnitStep (v : Int) : Prop := v = -1 ∨ v = 0 ∨ v = 1

def BoundedDelta (d : ParameterDelta) : Prop :=
  UnitStep d.wx ∧ UnitStep d.wy ∧ UnitStep d.wz ∧
  UnitStep d.wm ∧ UnitStep d.wr ∧ UnitStep d.bias

instance (v : Int) : Decidable (UnitStep v) := by
  unfold UnitStep
  infer_instance

instance (d : ParameterDelta) : Decidable (BoundedDelta d) := by
  unfold BoundedDelta
  infer_instance

def trainingProposal (error : Int) : ParameterDelta :=
  { wx := quantize error
    wy := quantize (-error)
    wz := quantize error
    wm := quantize error
    wr := quantize (-error)
    bias := quantize error }

theorem trainingProposal_bounded (error : Int) :
    BoundedDelta (trainingProposal error) := by
  unfold BoundedDelta trainingProposal
  constructor
  · exact quantize_cases error
  constructor
  · exact quantize_cases (-error)
  constructor
  · exact quantize_cases error
  constructor
  · exact quantize_cases error
  constructor
  · exact quantize_cases (-error)
  · exact quantize_cases error

def applyDelta (p : NeuralParameters) (d : ParameterDelta) : NeuralParameters :=
  { wx := p.wx + d.wx
    wy := p.wy + d.wy
    wz := p.wz + d.wz
    wm := p.wm + d.wm
    wr := p.wr + d.wr
    bias := p.bias + d.bias }

structure LearningState where
  modelIdentity : Nat
  version : Nat
  parameters : NeuralParameters
  validationLoss : Nat
  receipt : Nat
  deriving DecidableEq, Repr

def candidateState
    (before : LearningState)
    (delta : ParameterDelta)
    (validatedLoss : Nat) : LearningState :=
  { modelIdentity := before.modelIdentity
    version := before.version + 1
    parameters := applyDelta before.parameters delta
    validationLoss := validatedLoss
    receipt := before.receipt + 1 }

def LearningAdmissible
    (before : LearningState)
    (delta : ParameterDelta)
    (validatedLoss : Nat)
    (after : LearningState) : Prop :=
  validatedLoss ≤ before.validationLoss ∧
  BoundedDelta delta ∧
  after = candidateState before delta validatedLoss

instance
    (before : LearningState)
    (delta : ParameterDelta)
    (validatedLoss : Nat)
    (after : LearningState) :
    Decidable (LearningAdmissible before delta validatedLoss after) := by
  unfold LearningAdmissible
  infer_instance

structure LearningReceipt
    (before : LearningState)
    (delta : ParameterDelta)
    (validatedLoss : Nat)
    (after : LearningState) : Prop where
  admitted : LearningAdmissible before delta validatedLoss after
  identityPreserved : after.modelIdentity = before.modelIdentity
  versionExtended : after.version = before.version + 1
  receiptExtended : after.receipt = before.receipt + 1

theorem admitted_preserves_identity
    (h : LearningAdmissible before delta validatedLoss after) :
    after.modelIdentity = before.modelIdentity := by
  rcases h with ⟨_, _, rfl⟩
  rfl

theorem admitted_extends_version
    (h : LearningAdmissible before delta validatedLoss after) :
    after.version = before.version + 1 := by
  rcases h with ⟨_, _, rfl⟩
  rfl

theorem admitted_extends_receipt
    (h : LearningAdmissible before delta validatedLoss after) :
    after.receipt = before.receipt + 1 := by
  rcases h with ⟨_, _, rfl⟩
  rfl

def receiptOfAdmitted
    (h : LearningAdmissible before delta validatedLoss after) :
    LearningReceipt before delta validatedLoss after :=
  { admitted := h
    identityPreserved := admitted_preserves_identity h
    versionExtended := admitted_extends_version h
    receiptExtended := admitted_extends_receipt h }

def learnOrHold
    (before : LearningState)
    (delta : ParameterDelta)
    (validatedLoss : Nat) : LearningState :=
  let after := candidateState before delta validatedLoss
  if LearningAdmissible before delta validatedLoss after then after else before

theorem learn_accepts
    (hLoss : validatedLoss ≤ before.validationLoss)
    (hDelta : BoundedDelta delta) :
    learnOrHold before delta validatedLoss =
      candidateState before delta validatedLoss := by
  simp [learnOrHold, LearningAdmissible, hLoss, hDelta]

theorem learn_holds_on_worse_loss
    (hWorse : before.validationLoss < validatedLoss) :
    learnOrHold before delta validatedLoss = before := by
  simp [learnOrHold, LearningAdmissible, Nat.not_le_of_lt hWorse]

theorem learn_holds_on_unbounded_delta
    (hUnbounded : ¬ BoundedDelta delta) :
    learnOrHold before delta validatedLoss = before := by
  simp [learnOrHold, LearningAdmissible, hUnbounded]

def initialLearningState : LearningState :=
  { modelIdentity := 1
    version := 0
    parameters := demoParameters
    validationLoss := 10
    receipt := 0 }

def safeDemoDelta : ParameterDelta := trainingProposal 3

def outOfFieldDelta : ParameterDelta :=
  { wx := 7, wy := 0, wz := 0, wm := 0, wr := 0, bias := 0 }

theorem safe_demo_is_admitted :
    learnOrHold initialLearningState safeDemoDelta 8 =
      candidateState initialLearningState safeDemoDelta 8 := by
  native_decide

theorem worse_validation_holds :
    learnOrHold initialLearningState safeDemoDelta 12 = initialLearningState := by
  native_decide

theorem out_of_field_holds :
    learnOrHold initialLearningState outOfFieldDelta 8 = initialLearningState := by
  native_decide

end TMI.DigitalLifeBoundedLearning
