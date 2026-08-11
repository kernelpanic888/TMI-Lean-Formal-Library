/-!
AISOControlLoop.lean

A proof-carrying model of admissible improvement.
The file proves local properties of a selected transition. It does not prove
that a domain model, quality function, validator, or physical adapter is sound.
-/

universe u v w x y

structure AISOMetrics where
  improvement : Int
  risk : Int
  cost : Int
  entropy : Int

structure AISOWeights where
  alpha : Int
  beta : Int
  gamma : Int
  lambda : Int

def weightedObjective (weights : AISOWeights) (metrics : AISOMetrics) : Int :=
  weights.alpha * metrics.improvement
    - weights.beta * metrics.risk
    - weights.gamma * metrics.cost
    - weights.lambda * metrics.entropy

structure AISO
    (State : Type u)
    (Model : Type v)
    (Action : Type w)
    (Invariant : Type x)
    (RollbackReceipt : Type y) where
  stateAt : Nat → State
  modelAt : Nat → Model
  available : Nat → Action → Prop
  apply : State → Action → State
  noOp : Action
  metrics : State → Action → AISOMetrics
  weights : AISOWeights
  riskBound : Int
  constraints : State → Action → Prop
  validate : Model → State → Action → Prop
  permit : State → Action → Prop
  safe : State → Action → Prop
  protectedInvariant : Invariant → Prop
  holds : Invariant → State → Prop
  quality : State → Int
  postVerify : State → Action → State → Prop
  rollback : State → RollbackReceipt → State → Prop
  learn : Model → State → Action → State → Model

def objective
    {State : Type u} {Model : Type v} {Action : Type w}
    {Invariant : Type x} {RollbackReceipt : Type y}
    (sys : AISO State Model Action Invariant RollbackReceipt)
    (state : State) (action : Action) : Int :=
  weightedObjective sys.weights (sys.metrics state action)

def preservesProtected
    {State : Type u} {Model : Type v} {Action : Type w}
    {Invariant : Type x} {RollbackReceipt : Type y}
    (sys : AISO State Model Action Invariant RollbackReceipt)
    (state : State) (action : Action) : Prop :=
  ∀ invariant,
    sys.protectedInvariant invariant →
    sys.holds invariant state →
    sys.holds invariant (sys.apply state action)

structure Admissible
    {State : Type u} {Model : Type v} {Action : Type w}
    {Invariant : Type x} {RollbackReceipt : Type y}
    (sys : AISO State Model Action Invariant RollbackReceipt)
    (time : Nat) (action : Action) : Prop where
  available : sys.available time action
  constrained : sys.constraints (sys.stateAt time) action
  positiveImprovement : 0 < (sys.metrics (sys.stateAt time) action).improvement
  riskWithinBound :
    (sys.metrics (sys.stateAt time) action).risk ≤ sys.riskBound
  validated : sys.validate (sys.modelAt time) (sys.stateAt time) action
  permitted : sys.permit (sys.stateAt time) action
  safe : sys.safe (sys.stateAt time) action
  preservesInvariant : preservesProtected sys (sys.stateAt time) action
  qualityImproves :
    sys.quality (sys.stateAt time) <
      sys.quality (sys.apply (sys.stateAt time) action)
  rollbackWitness :
    ∃ receipt,
      sys.rollback
        (sys.apply (sys.stateAt time) action)
        receipt
        (sys.stateAt time)

structure BestAdmissible
    {State : Type u} {Model : Type v} {Action : Type w}
    {Invariant : Type x} {RollbackReceipt : Type y}
    (sys : AISO State Model Action Invariant RollbackReceipt)
    (time : Nat) (chosen : Action) : Prop where
  admissible : Admissible sys time chosen
  maximal :
    ∀ candidate,
      Admissible sys time candidate →
      objective sys (sys.stateAt time) candidate ≤
        objective sys (sys.stateAt time) chosen

inductive Decision
    {State : Type u} {Model : Type v} {Action : Type w}
    {Invariant : Type x} {RollbackReceipt : Type y}
    (sys : AISO State Model Action Invariant RollbackReceipt)
    (time : Nat) where
  | act (chosen : Action) (certificate : BestAdmissible sys time chosen)
  | hold (none : ∀ candidate, ¬ Admissible sys time candidate)

def selectedAction
    {State : Type u} {Model : Type v} {Action : Type w}
    {Invariant : Type x} {RollbackReceipt : Type y}
    (sys : AISO State Model Action Invariant RollbackReceipt)
    (time : Nat) (decision : Decision sys time) : Action :=
  match decision with
  | .act chosen _ => chosen
  | .hold _ => sys.noOp

def nextState
    {State : Type u} {Model : Type v} {Action : Type w}
    {Invariant : Type x} {RollbackReceipt : Type y}
    (sys : AISO State Model Action Invariant RollbackReceipt)
    (time : Nat) (decision : Decision sys time) : State :=
  match decision with
  | .act chosen _ => sys.apply (sys.stateAt time) chosen
  | .hold _ => sys.stateAt time

structure VerifiedTransition
    {State : Type u} {Model : Type v} {Action : Type w}
    {Invariant : Type x} {RollbackReceipt : Type y}
    (sys : AISO State Model Action Invariant RollbackReceipt)
    (time : Nat) (action : Action) where
  next : State
  applied : next = sys.apply (sys.stateAt time) action
  postVerified : sys.postVerify (sys.stateAt time) action next
  qualityImproved : sys.quality (sys.stateAt time) < sys.quality next
  invariantsPreserved :
    ∀ invariant,
      sys.protectedInvariant invariant →
      sys.holds invariant (sys.stateAt time) →
      sys.holds invariant next

structure LearningStep
    {State : Type u} {Model : Type v} {Action : Type w}
    {Invariant : Type x} {RollbackReceipt : Type y}
    (sys : AISO State Model Action Invariant RollbackReceipt)
    (time : Nat) (action : Action) where
  transition : VerifiedTransition sys time action
  nextModel : Model
  learned :
    nextModel =
      sys.learn
        (sys.modelAt time)
        (sys.stateAt time)
        action
        transition.next

theorem selected_action_is_admissible
    {State : Type u} {Model : Type v} {Action : Type w}
    {Invariant : Type x} {RollbackReceipt : Type y}
    {sys : AISO State Model Action Invariant RollbackReceipt}
    {time : Nat} {action : Action}
    (certificate : BestAdmissible sys time action) :
    Admissible sys time action :=
  certificate.admissible

theorem selected_action_is_objective_maximal
    {State : Type u} {Model : Type v} {Action : Type w}
    {Invariant : Type x} {RollbackReceipt : Type y}
    {sys : AISO State Model Action Invariant RollbackReceipt}
    {time : Nat} {action : Action}
    (certificate : BestAdmissible sys time action) :
    ∀ candidate,
      Admissible sys time candidate →
      objective sys (sys.stateAt time) candidate ≤
        objective sys (sys.stateAt time) action :=
  certificate.maximal

theorem selected_action_improves_quality
    {State : Type u} {Model : Type v} {Action : Type w}
    {Invariant : Type x} {RollbackReceipt : Type y}
    {sys : AISO State Model Action Invariant RollbackReceipt}
    {time : Nat} {action : Action}
    (certificate : BestAdmissible sys time action) :
    sys.quality (sys.stateAt time) <
      sys.quality (sys.apply (sys.stateAt time) action) :=
  certificate.admissible.qualityImproves

theorem selected_action_preserves_protected_invariants
    {State : Type u} {Model : Type v} {Action : Type w}
    {Invariant : Type x} {RollbackReceipt : Type y}
    {sys : AISO State Model Action Invariant RollbackReceipt}
    {time : Nat} {action : Action}
    (certificate : BestAdmissible sys time action) :
    preservesProtected sys (sys.stateAt time) action :=
  certificate.admissible.preservesInvariant

theorem selected_action_has_rollback_witness
    {State : Type u} {Model : Type v} {Action : Type w}
    {Invariant : Type x} {RollbackReceipt : Type y}
    {sys : AISO State Model Action Invariant RollbackReceipt}
    {time : Nat} {action : Action}
    (certificate : BestAdmissible sys time action) :
    ∃ receipt,
      sys.rollback
        (sys.apply (sys.stateAt time) action)
        receipt
        (sys.stateAt time) :=
  certificate.admissible.rollbackWitness

theorem hold_selects_noop
    {State : Type u} {Model : Type v} {Action : Type w}
    {Invariant : Type x} {RollbackReceipt : Type y}
    (sys : AISO State Model Action Invariant RollbackReceipt)
    (time : Nat) (none : ∀ candidate, ¬ Admissible sys time candidate) :
    selectedAction sys time (.hold none) = sys.noOp :=
  rfl

theorem hold_preserves_state
    {State : Type u} {Model : Type v} {Action : Type w}
    {Invariant : Type x} {RollbackReceipt : Type y}
    (sys : AISO State Model Action Invariant RollbackReceipt)
    (time : Nat) (none : ∀ candidate, ¬ Admissible sys time candidate) :
    nextState sys time (.hold none) = sys.stateAt time :=
  rfl

theorem learning_requires_post_verification
    {State : Type u} {Model : Type v} {Action : Type w}
    {Invariant : Type x} {RollbackReceipt : Type y}
    {sys : AISO State Model Action Invariant RollbackReceipt}
    {time : Nat} {action : Action}
    (step : LearningStep sys time action) :
    sys.postVerify
      (sys.stateAt time)
      action
      step.transition.next :=
  step.transition.postVerified
