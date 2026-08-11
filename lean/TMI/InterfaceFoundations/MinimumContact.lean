import Mathlib

/-!
# Minimum-contact boundary

Positive contact does not by itself imply a least positive contact.
-/

universe u v

namespace TMI.InterfaceFoundations.MinimumContact

variable {Signal : Type u} {Strength : Type v} [Preorder Strength]

def MinimalTouch
    (strength : Signal -> Strength)
    (admissible : Signal -> Prop)
    (signal : Signal) : Prop :=
  admissible signal /\
    forall other : Signal, admissible other -> strength signal <= strength other

def HasTouch (admissible : Signal -> Prop) : Prop :=
  exists signal : Signal, admissible signal

def HasMinimalTouch
    (strength : Signal -> Strength)
    (admissible : Signal -> Prop) : Prop :=
  exists signal : Signal, MinimalTouch strength admissible signal

theorem positiveRealTouches_have_no_minimal :
    HasTouch (fun x : Real => 0 < x) /\
      Not (HasMinimalTouch (fun x : Real => x) (fun x : Real => 0 < x)) := by
  constructor
  · exact ⟨1, by norm_num⟩
  · intro hMinimal
    rcases hMinimal with ⟨x, hPositive, hLeast⟩
    have hHalfPositive : 0 < x / 2 := by linarith
    have hImpossible : x <= x / 2 := hLeast (x / 2) hHalfPositive
    linarith

end TMI.InterfaceFoundations.MinimumContact
