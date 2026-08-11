import Std

/-!
AgentZeroValidationKernel.lean

Agent Zero executes an action exactly when self-validation, external
validation, and the safety contour all accept that same action.
-/

namespace AgentZeroValidationKernel

universe u

abbrev Validator (Action : Type u) := Action -> Bool

structure Gate (Action : Type u) where
  selfValidate : Validator Action
  externalValidate : Validator Action
  safe : Validator Action

def admitted {Action : Type u} (gate : Gate Action) (action : Action) : Bool :=
  gate.selfValidate action &&
  gate.externalValidate action &&
  gate.safe action

def execute {Action : Type u} (gate : Gate Action) (action : Action) : Option Action :=
  if admitted gate action then some action else none

theorem execute_some_iff_triple_admission
    {Action : Type u} (gate : Gate Action) (action : Action) :
    execute gate action = some action <->
      gate.selfValidate action = true /\
      gate.externalValidate action = true /\
      gate.safe action = true := by
  simp [execute, admitted, Bool.and_eq_true]

theorem execute_none_iff_rejected
    {Action : Type u} (gate : Gate Action) (action : Action) :
    execute gate action = none <->
      not (
        gate.selfValidate action = true /\
        gate.externalValidate action = true /\
        gate.safe action = true) := by
  cases self : gate.selfValidate action <;>
  cases external : gate.externalValidate action <;>
  cases safety : gate.safe action <;>
  simp [execute, admitted, self, external, safety]

theorem self_rejection_means_noop
    {Action : Type u} (gate : Gate Action) (action : Action)
    (rejected : gate.selfValidate action = false) :
    execute gate action = none := by
  simp [execute, admitted, rejected]

theorem external_rejection_means_noop
    {Action : Type u} (gate : Gate Action) (action : Action)
    (rejected : gate.externalValidate action = false) :
    execute gate action = none := by
  simp [execute, admitted, rejected]

theorem safety_rejection_means_noop
    {Action : Type u} (gate : Gate Action) (action : Action)
    (rejected : gate.safe action = false) :
    execute gate action = none := by
  simp [execute, admitted, rejected]

theorem execution_never_substitutes_action
    {Action : Type u} (gate : Gate Action) (input output : Action)
    (executed : execute gate input = some output) :
    output = input := by
  unfold execute at executed
  split at executed
  · exact (Option.some.inj executed).symm
  · simp at executed

end AgentZeroValidationKernel
