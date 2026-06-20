/-
TMI wrapper-top hypothesis layer.

This module formalizes the controlled claim:

If an interface is also a wrapper of a system, and every wrapper layer of that
system is below it in the wrapper order, then the interface is the top wrapper
layer for that system.

It does not claim that every interface is automatically the highest wrapper,
and it does not claim that every wrapper is an interface.
-/

import TMI.Core

namespace TMI
namespace WrapperTop

open Core

/-- `Wrapper w s` means that `w` is a wrapper layer of system/object `s`. -/
axiom Wrapper : Obj → Obj → Prop

/-- `WrapperLe w i` means that wrapper `w` is below or equal to wrapper `i`. -/
axiom WrapperLe : Obj → Obj → Prop

/-- `MediatedBy w i` means wrapper `w` operationally passes through `i`. -/
axiom MediatedBy : Obj → Obj → Prop

/-- A top wrapper of `s` is a wrapper of `s` above all wrappers of `s`. -/
def TopWrapper (i s : Obj) : Prop :=
  Wrapper i s ∧ ∀ w : Obj, Wrapper w s → WrapperLe w i

/-- `i` is an upper bound for the wrapper layers of `s`. -/
def WrapperUpperBound (i s : Obj) : Prop :=
  ∀ w : Obj, Wrapper w s → WrapperLe w i

/-- `i` is a wrapper maximum for `s`: it is a wrapper and an upper bound. -/
def WrapperMaximum (i s : Obj) : Prop :=
  Wrapper i s ∧ WrapperUpperBound i s

/-- Interface-and-wrapper candidate, before any maximality claim. -/
def InterfaceWrapperCandidate (i s : Obj) : Prop :=
  Ispace i ∧ Wrapper i s

/--
Controlled input package for the interface-as-top-wrapper hypothesis.

The `Ispace i` field keeps the TMI interface boundary explicit; the top-wrapper
conclusion still requires a separate wrapper relation and wrapper order.
-/
def InterfaceTopWrapperInput (i s : Obj) : Prop :=
  Ispace i ∧ Wrapper i s ∧ ∀ w : Obj, Wrapper w s → WrapperLe w i

/-- Stronger named input: interface-wrapper candidate plus wrapper upper bound. -/
def InterfaceWrapperDominanceInput (i s : Obj) : Prop :=
  InterfaceWrapperCandidate i s ∧ WrapperUpperBound i s

/-- All wrapper layers of `s` are mediated by `i`. -/
def WrapperMediationCoverage (i s : Obj) : Prop :=
  ∀ w : Obj, Wrapper w s → MediatedBy w i

/-- Mediation through `i` is sound for the wrapper order of `s`. -/
def WrapperMediationSoundness (i s : Obj) : Prop :=
  ∀ w : Obj, Wrapper w s → MediatedBy w i → WrapperLe w i

/-- `TopWrapper` is exactly the wrapper-maximum condition. -/
theorem top_wrapper_iff_wrapper_maximum
    (i s : Obj) :
    TopWrapper i s ↔ WrapperMaximum i s := by
  rfl

/-- A top wrapper is a wrapper of the system. -/
theorem top_wrapper_is_wrapper
    (i s : Obj)
    (h : TopWrapper i s) :
    Wrapper i s := by
  exact h.left

/-- A top wrapper is an upper bound for all wrapper layers of the system. -/
theorem top_wrapper_upper_bound
    (i s : Obj)
    (h : TopWrapper i s) :
    WrapperUpperBound i s := by
  exact h.right

/--
If the controlled input package is present, the interface is a top wrapper.
-/
theorem interface_top_wrapper_from_input
    (i s : Obj)
    (h : InterfaceTopWrapperInput i s) :
    TopWrapper i s := by
  exact And.intro h.right.left h.right.right

/--
If an interface-wrapper candidate dominates all wrappers of the system, it is a
top wrapper. This separates interfacehood from the wrapper-order obligation.
-/
theorem interface_top_wrapper_from_dominance
    (i s : Obj)
    (h : InterfaceWrapperDominanceInput i s) :
    TopWrapper i s := by
  exact And.intro h.left.right h.right

/--
Direct upper-bound form: interfacehood is carried as an explicit boundary
premise, while the top-wrapper conclusion comes from wrapperhood plus dominance.
-/
theorem interface_top_wrapper_from_upper_bound
    (i s : Obj)
    (_hI : Ispace i)
    (hWrapper : Wrapper i s)
    (hUpper : WrapperUpperBound i s) :
    TopWrapper i s := by
  exact And.intro hWrapper hUpper

/--
Mediation form: if every wrapper of `s` is mediated by `i`, and mediation is
sound for the wrapper order, then `i` is the top wrapper of `s`.
-/
theorem interface_top_wrapper_from_mediation
    (i s : Obj)
    (_hI : Ispace i)
    (hWrapper : Wrapper i s)
    (hAllMediated : ∀ w : Obj, Wrapper w s → MediatedBy w i)
    (hMediationSound : ∀ w : Obj, Wrapper w s → MediatedBy w i → WrapperLe w i) :
    TopWrapper i s := by
  exact And.intro hWrapper (fun w hw => hMediationSound w hw (hAllMediated w hw))

/--
Named mediation-profile form. This packages coverage and soundness separately
so future work can strengthen either side without changing the theorem target.
-/
theorem interface_top_wrapper_from_mediation_profile
    (i s : Obj)
    (_hI : Ispace i)
    (hWrapper : Wrapper i s)
    (hCoverage : WrapperMediationCoverage i s)
    (hSound : WrapperMediationSoundness i s) :
    TopWrapper i s := by
  exact And.intro hWrapper (fun w hw => hSound w hw (hCoverage w hw))

end WrapperTop
end TMI
