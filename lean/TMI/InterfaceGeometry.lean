import Std

/-!
# IG-01: Interface Geometry

Contact points carry a field label. Interfaces have ordered, nonempty contact
lists. A time slice carries incidence and a separate placement of contacts.
The response criterion is an operational definition for a proposed experiment.
-/
namespace TMI.InterfaceGeometry

universe u v w

structure Contact (Field : Type u) (Point : Type v) where
  field : Field
  point : Point

structure Interface (Field : Type u) (Point : Type v) where
  first : Contact Field Point
  rest : List (Contact Field Point)

def Interface.contacts (edge : Interface Field Point) : List (Contact Field Point) :=
  edge.first :: edge.rest

def SharedContact (left right : Interface Field Point) : Prop :=
  ∃ p, p ∈ left.contacts ∧ p ∈ right.contacts

theorem sharedContact_symm {left right : Interface Field Point}
    (h : SharedContact left right) : SharedContact right left := by
  obtain ⟨p, hl, hr⟩ := h
  exact ⟨p, hr, hl⟩

structure Slice (Field : Type u) (Point : Type v) (Position : Type w) where
  time : Nat
  interfaces : List (Interface Field Point)
  placement : Contact Field Point → Position

def Slice.redraw (slice : Slice Field Point Position)
    (placement : Contact Field Point → Position) : Slice Field Point Position :=
  { slice with placement := placement }

theorem redraw_preserves_incidence (slice : Slice Field Point Position)
    (placement : Contact Field Point → Position) :
    (slice.redraw placement).interfaces = slice.interfaces := rfl

/-- Each response magnitude uses the same predeclared measurement scale. -/
structure Probe where
  afterDrive : Bool
  delay : Nat
  magnitude : Nat

def Probe.passes (window threshold : Nat) (probe : Probe) : Prop :=
  probe.afterDrive = true ∧ probe.delay ≤ window ∧ threshold ≤ probe.magnitude

/-- Require at least two repeats and a qualifying response on every repeat. -/
def Qualifies (window threshold : Nat) (trials : List Probe) : Prop :=
  2 ≤ trials.length ∧ ∀ probe ∈ trials, probe.passes window threshold

def BornBetween (before after : Slice Field Point Position)
    (edge : Interface Field Point) : Prop :=
  before.time < after.time ∧ edge ∉ before.interfaces ∧ edge ∈ after.interfaces

/-- Compare empirical proportions by cross-multiplication on valid counts. -/
def MoreFrequent (nearHits nearTotal farHits farTotal : Nat) : Prop :=
  0 < nearTotal ∧ 0 < farTotal ∧ nearHits ≤ nearTotal ∧ farHits ≤ farTotal ∧
  farHits * nearTotal < nearHits * farTotal

theorem equal_counts_do_not_support (hits total : Nat) :
    ¬ MoreFrequent hits total hits total := by
  intro h
  exact (Nat.lt_irrefl _) h.2.2.2.2

end TMI.InterfaceGeometry
