import Std

/-!
AISOValidationKernel.lean

K-00: two validated states close into an interface act only when the
left state, the right state, and their interface compatibility all agree.
-/

namespace AISOValidationKernel

universe u v

abbrev Validator (State : Type u) := State -> Bool
abbrev Compatibility (StateA : Type u) (StateB : Type v) := StateA -> StateB -> Bool

structure CandidateAct (StateA : Type u) (StateB : Type v) where
  stateA : StateA
  stateB : StateB

structure InterfaceGate (StateA : Type u) (StateB : Type v) where
  validateA : Validator StateA
  validateB : Validator StateB
  compatible : Compatibility StateA StateB

def closed {StateA : Type u} {StateB : Type v}
    (gate : InterfaceGate StateA StateB) (act : CandidateAct StateA StateB) : Bool :=
  gate.validateA act.stateA &&
  gate.validateB act.stateB &&
  gate.compatible act.stateA act.stateB

def execute {StateA : Type u} {StateB : Type v}
    (gate : InterfaceGate StateA StateB) (act : CandidateAct StateA StateB) :
    Option (CandidateAct StateA StateB) :=
  if closed gate act then some act else none

theorem execute_some_iff_triple_closure
    {StateA : Type u} {StateB : Type v}
    (gate : InterfaceGate StateA StateB) (act : CandidateAct StateA StateB) :
    execute gate act = some act <->
      gate.validateA act.stateA = true /\
      gate.validateB act.stateB = true /\
      gate.compatible act.stateA act.stateB = true := by
  simp [execute, closed, Bool.and_eq_true]

theorem execute_none_iff_silence
    {StateA : Type u} {StateB : Type v}
    (gate : InterfaceGate StateA StateB) (act : CandidateAct StateA StateB) :
    execute gate act = none <->
      not (
        gate.validateA act.stateA = true /\
        gate.validateB act.stateB = true /\
        gate.compatible act.stateA act.stateB = true) := by
  cases left : gate.validateA act.stateA <;>
  cases right : gate.validateB act.stateB <;>
  cases interface : gate.compatible act.stateA act.stateB <;>
  simp [execute, closed, left, right, interface]

theorem left_rejection_means_silence
    {StateA : Type u} {StateB : Type v}
    (gate : InterfaceGate StateA StateB) (act : CandidateAct StateA StateB)
    (rejected : gate.validateA act.stateA = false) :
    execute gate act = none := by
  simp [execute, closed, rejected]

theorem right_rejection_means_silence
    {StateA : Type u} {StateB : Type v}
    (gate : InterfaceGate StateA StateB) (act : CandidateAct StateA StateB)
    (rejected : gate.validateB act.stateB = false) :
    execute gate act = none := by
  simp [execute, closed, rejected]

theorem incompatibility_means_silence
    {StateA : Type u} {StateB : Type v}
    (gate : InterfaceGate StateA StateB) (act : CandidateAct StateA StateB)
    (rejected : gate.compatible act.stateA act.stateB = false) :
    execute gate act = none := by
  simp [execute, closed, rejected]

theorem execution_never_substitutes_act
    {StateA : Type u} {StateB : Type v}
    (gate : InterfaceGate StateA StateB)
    (input output : CandidateAct StateA StateB)
    (executed : execute gate input = some output) :
    output = input := by
  unfold execute at executed
  split at executed
  · exact (Option.some.inj executed).symm
  · simp at executed

end AISOValidationKernel
