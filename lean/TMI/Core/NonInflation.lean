/-
TMI-Core-Proof 0.2-A7 non-inflation contracts.

These assumptions protect negative/interface-exclusion behavior: static,
passive, or externally-selected objects must not be inflated into valid
interfaces by typed-domain facts alone.
-/

import TMI.Core.Signature

namespace TMI
namespace Core

def StaticOnlyEvidence (x : Obj) : Prop :=
  StaticOnly x

theorem StaticOnlyEvidence_intro : ∀ x : Obj, StaticOnly x → StaticOnlyEvidence x := by
  intro x h
  exact h

axiom StaticOnly_static_obligation : ∀ x : Obj,
  StaticOnlyEvidence x → Static x

axiom StaticOnly_no_dynamic_obligation : ∀ x : Obj,
  StaticOnlyEvidence x → ¬ Dyn x

theorem StaticOnly_no_dyn : ∀ x : Obj, StaticOnly x → Static x ∧ ¬ Dyn x := by
  intro x h
  exact ⟨
    StaticOnly_static_obligation x (StaticOnlyEvidence_intro x h),
    StaticOnly_no_dynamic_obligation x (StaticOnlyEvidence_intro x h)
  ⟩

def PassiveChannelEvidence (x : Obj) : Prop :=
  PassiveChannel x

theorem PassiveChannelEvidence_intro : ∀ x : Obj, PassiveChannel x → PassiveChannelEvidence x := by
  intro x h
  exact h

axiom PassiveChannel_no_dynamic_obligation : ∀ x : Obj,
  PassiveChannelEvidence x → ¬ Dyn x

theorem PassiveChannel_no_dyn : ∀ x : Obj, PassiveChannel x → ¬ Dyn x := by
  intro x h
  exact PassiveChannel_no_dynamic_obligation x (PassiveChannelEvidence_intro x h)

def StaticNonstaticConflict (x : Obj) : Prop :=
  Static x ∧ NonStatic x

theorem StaticNonstaticConflict_intro :
    ∀ x : Obj, Static x → NonStatic x → StaticNonstaticConflict x := by
  intro x hs hns
  exact ⟨hs, hns⟩

axiom StaticNonstaticConflict_exclusion_obligation : ∀ x : Obj,
  StaticNonstaticConflict x → False

theorem Static_nonstatic_consistency : ∀ x : Obj, ¬ (Static x ∧ NonStatic x) := by
  intro x h
  exact StaticNonstaticConflict_exclusion_obligation x h

end Core
end TMI
