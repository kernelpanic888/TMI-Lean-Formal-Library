import TMI.DigitalLifeBoundedLearning

/-!
# Independent validation adapter for I3 learning

The trainer receives only `TrainerView`. The validator receives only
`ValidatorView` and computes the candidate loss itself. No API accepts a loss
chosen by the trainer. The bounded learning gate remains the sole authority
that can turn a proposal into a parameter update.

This module proves an internal separation-of-authority contract. It does not
claim statistical generalization, dataset quality, or intelligence.
-/

namespace TMI.DigitalLifeValidationAdapter

open TMI.DigitalLifeNeuralProposer
open TMI.DigitalLifeBoundedLearning

structure Sample where
  id : Nat
  x : Int
  y : Int
  z : Int
  memory : Int
  reflection : Int
  target : Int
  deriving DecidableEq, Repr

structure TrainerView where
  samples : List Sample
  deriving DecidableEq, Repr

structure ValidatorView where
  holdout : List Sample
  deriving DecidableEq, Repr

structure DatasetSplit where
  training : TrainerView
  validation : ValidatorView
  disjoint : ∀ sample, sample ∈ training.samples → sample ∉ validation.holdout

def predict (p : NeuralParameters) (sample : Sample) : Int :=
  p.wx * sample.x +
  p.wy * sample.y +
  p.wz * sample.z +
  p.wm * sample.memory +
  p.wr * sample.reflection +
  p.bias

def sampleLoss (p : NeuralParameters) (sample : Sample) : Nat :=
  (predict p sample - sample.target).natAbs

def datasetLoss (p : NeuralParameters) (samples : List Sample) : Nat :=
  samples.foldl (fun total sample => total + sampleLoss p sample) 0

def aggregateTrainingError (p : NeuralParameters) (view : TrainerView) : Int :=
  view.samples.foldl
    (fun total sample => total + (sample.target - predict p sample)) 0

structure TrainingProposal where
  delta : ParameterDelta
  bounded : BoundedDelta delta

def runTrainer (p : NeuralParameters) (view : TrainerView) : TrainingProposal :=
  let delta := trainingProposal (aggregateTrainingError p view)
  { delta := delta
    bounded := trainingProposal_bounded _ }

def holdoutFingerprint (view : ValidatorView) : Nat :=
  view.holdout.foldl (fun digest sample => digest * 16777619 + sample.id) 2166136261

structure ValidationReport where
  holdoutFingerprint : Nat
  beforeLoss : Nat
  candidateLoss : Nat
  deriving DecidableEq, Repr

def runValidator
    (before : LearningState)
    (view : ValidatorView)
    (proposal : TrainingProposal) : ValidationReport :=
  { holdoutFingerprint := holdoutFingerprint view
    beforeLoss := datasetLoss before.parameters view.holdout
    candidateLoss := datasetLoss
      (applyDelta before.parameters proposal.delta) view.holdout }

def independentLearningCycle
    (before : LearningState)
    (training : TrainerView)
    (validation : ValidatorView) : LearningState :=
  let proposal := runTrainer before.parameters training
  let report := runValidator before validation proposal
  learnOrHold before proposal.delta report.candidateLoss

theorem validator_computes_candidate_loss
    (before : LearningState)
    (validation : ValidatorView)
    (proposal : TrainingProposal) :
    (runValidator before validation proposal).candidateLoss =
      datasetLoss (applyDelta before.parameters proposal.delta) validation.holdout := by
  rfl

theorem independent_cycle_accepts
    (hLoss :
      (runValidator before validation (runTrainer before.parameters training)).candidateLoss ≤
        before.validationLoss) :
    independentLearningCycle before training validation =
      candidateState before
        (runTrainer before.parameters training).delta
        (runValidator before validation (runTrainer before.parameters training)).candidateLoss := by
  unfold independentLearningCycle
  exact learn_accepts hLoss (runTrainer before.parameters training).bounded

theorem independent_cycle_holds_on_worse_validation
    (hWorse :
      before.validationLoss <
        (runValidator before validation (runTrainer before.parameters training)).candidateLoss) :
    independentLearningCycle before training validation = before := by
  unfold independentLearningCycle
  exact learn_holds_on_worse_loss hWorse

def zeroParameters : NeuralParameters :=
  { wx := 0, wy := 0, wz := 0, wm := 0, wr := 0, bias := 0 }

def trainingSample : Sample :=
  { id := 0, x := 0, y := 0, z := 0, memory := 0, reflection := 0, target := 1 }

def improvingHoldoutSample : Sample :=
  { id := 1, x := 0, y := 0, z := 0, memory := 0, reflection := 0, target := 1 }

def adversarialHoldoutSample : Sample :=
  { id := 2, x := 0, y := 0, z := 0, memory := 0, reflection := 0, target := -1 }

def demoTraining : TrainerView := { samples := [trainingSample] }
def improvingValidation : ValidatorView := { holdout := [improvingHoldoutSample] }
def adversarialValidation : ValidatorView := { holdout := [adversarialHoldoutSample] }

def improvingSplit : DatasetSplit :=
  { training := demoTraining
    validation := improvingValidation
    disjoint := by
      intro sample hTraining
      have hSample : sample = trainingSample := by
        simpa [demoTraining] using hTraining
      subst sample
      simp [improvingValidation, trainingSample, improvingHoldoutSample] }

def demoState : LearningState :=
  { modelIdentity := 1
    version := 0
    parameters := zeroParameters
    validationLoss := 1
    receipt := 0 }

theorem improving_holdout_admits :
    independentLearningCycle demoState demoTraining improvingValidation =
      candidateState demoState
        (runTrainer demoState.parameters demoTraining).delta 0 := by
  native_decide

theorem adversarial_holdout_holds :
    independentLearningCycle demoState demoTraining adversarialValidation = demoState := by
  native_decide

theorem admitted_cycle_preserves_identity :
    (independentLearningCycle demoState demoTraining improvingValidation).modelIdentity =
      demoState.modelIdentity := by
  native_decide

end TMI.DigitalLifeValidationAdapter
