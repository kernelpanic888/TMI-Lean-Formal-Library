/-!
# Two-sided interface

Visibility requires maintained distinction and a reverse trace. Reciprocity is
stronger and adds the forward channel. Neither direction is assumed symmetric.
-/

universe u v w

namespace TMI.InterfaceFoundations.TwoSidedInterface

structure Language where
  Left : Type u
  Right : Type v
  Boundary : Type w
  separated : Left -> Right -> Prop
  bounds : Boundary -> Left -> Right -> Prop
  reverseContact : Boundary -> Right -> Left -> Prop
  forwardContact : Boundary -> Left -> Right -> Prop

variable (L : Language)

def Visible (left : L.Left) (right : L.Right) : Prop :=
  exists boundary : L.Boundary,
    L.bounds boundary left right /\
      L.separated left right /\
      L.reverseContact boundary right left

def Reciprocal (left : L.Left) (right : L.Right) : Prop :=
  exists boundary : L.Boundary,
    L.bounds boundary left right /\
      L.separated left right /\
      L.reverseContact boundary right left /\
      L.forwardContact boundary left right

def Merged (left : L.Left) (right : L.Right) : Prop :=
  Not (L.separated left right)

def ReverseIsolated (left : L.Left) (right : L.Right) : Prop :=
  forall boundary : L.Boundary,
    L.bounds boundary left right ->
      Not (L.reverseContact boundary right left)

theorem visible_implies_separated
    {left : L.Left} {right : L.Right}
    (h : L.Visible left right) :
    L.separated left right := by
  rcases h with ⟨boundary, hBounds, hSeparated, hReverse⟩
  exact hSeparated

theorem merged_not_visible
    {left : L.Left} {right : L.Right}
    (hMerged : L.Merged left right) :
    Not (L.Visible left right) := by
  intro hVisible
  exact hMerged (L.visible_implies_separated hVisible)

theorem reverseIsolated_not_visible
    {left : L.Left} {right : L.Right}
    (hIsolated : L.ReverseIsolated left right) :
    Not (L.Visible left right) := by
  rintro ⟨boundary, hBounds, hSeparated, hReverse⟩
  exact (hIsolated boundary hBounds) hReverse

theorem reciprocal_implies_visible
    {left : L.Left} {right : L.Right}
    (h : L.Reciprocal left right) :
    L.Visible left right := by
  rcases h with ⟨boundary, hBounds, hSeparated, hReverse, hForward⟩
  exact ⟨boundary, hBounds, hSeparated, hReverse⟩

theorem reciprocal_has_both_arrows
    {left : L.Left} {right : L.Right}
    (h : L.Reciprocal left right) :
    exists boundary : L.Boundary,
      L.bounds boundary left right /\
        L.reverseContact boundary right left /\
        L.forwardContact boundary left right := by
  rcases h with ⟨boundary, hBounds, hSeparated, hReverse, hForward⟩
  exact ⟨boundary, hBounds, hReverse, hForward⟩

def SupraBoundaryWitness
    (isSupraDomain : L.Right -> Prop)
    (left : L.Left)
    (right : L.Right) : Prop :=
  L.Visible left right /\ isSupraDomain right

theorem visible_does_not_force_supraDomain
    {left : L.Left} {right : L.Right}
    (hVisible : L.Visible left right) :
    L.Visible left right /\
      Not (L.SupraBoundaryWitness (fun _ => False) left right) := by
  refine ⟨hVisible, ?_⟩
  rintro ⟨hStillVisible, hSupra⟩
  exact hSupra

end TMI.InterfaceFoundations.TwoSidedInterface
