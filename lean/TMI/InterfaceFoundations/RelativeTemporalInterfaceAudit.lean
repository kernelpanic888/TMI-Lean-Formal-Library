import TMI.InterfaceFoundations.RelativeTemporalInterface

/-!
# Relative temporal interface: finite audit witnesses

The finite model below checks that the new definitions are inhabited and that
differential aging does not, by itself, force a reversed local-time reading.
It is a logical audit model, not a black-hole spacetime or empirical result.
-/

namespace TMI.InterfaceFoundations.RelativeTemporalInterfaceAudit

open TMI.InterfaceFoundations.RelativeTemporalInterface

inductive Event
  | p
  | q
deriving DecidableEq

inductive Direction
  | future
  | past
deriving DecidableEq

def language : Language where
  Event := Event
  PhysicalTime := Nat
  InternalTime := Nat
  time := {
    admissible := fun physical internal => internal = physical + 10
  }
  labRecorded := fun event time =>
    match event with
    | .p => time = 0
    | .q => time = 1
  relicOrdered := fun event time =>
    match event with
    | .p => time = 10
    | .q => time = 11
  Direction := fun _ => Direction
  future := fun direction => direction = .future
  past := fun direction => direction = .past
  futurePastDisjoint := by
    intro event direction hFuture hPast
    cases direction with
    | future => cases hPast
    | past => cases hFuture

def preservingComparison
    (source target : Event) : Comparison language source target where
  map := id

def reversingComparison
    (source target : Event) : Comparison language source target where
  map := fun direction =>
    match direction with
    | .future => .past
    | .past => .future

theorem preserving_reads_future_as_future
    (source target : Event) :
    FutureReadsAsFuture language (preservingComparison source target) := by
  intro direction hFuture
  exact hFuture

theorem preserving_does_not_read_future_as_past
    (source target : Event) :
    Not (FutureReadsAsPast language (preservingComparison source target)) := by
  intro reversed
  have impossible := reversed Direction.future rfl
  cases impossible

theorem reversing_reads_future_as_past
    (source target : Event) :
    FutureReadsAsPast language (reversingComparison source target) := by
  intro direction hFuture
  subst direction
  rfl

def relativeReversal : RelativeReversal language .q .p where
  comparison := reversingComparison .q .p
  sourceHasFuture := ⟨.future, rfl⟩
  readsFutureAsPast := reversing_reads_future_as_past .q .p

def sourceTouch : EventTimeTouch language .q := by
  unfold EventTimeTouch
  exact ⟨(1 : Nat), (11 : Nat), rfl, rfl, rfl⟩

def targetTouch : EventTimeTouch language .p := by
  unfold EventTimeTouch
  exact ⟨(0 : Nat), (10 : Nat), rfl, rfl, rfl⟩

def reversedTouch :
    RelativelyReversedTouch language .q .p where
  sourceTouch := sourceTouch
  targetTouch := targetTouch
  reversal := relativeReversal

theorem reversed_touch_reuses_existing_two_axis_time :
    exists sourceCoordinate : Nat × Nat,
    exists targetCoordinate : Nat × Nat,
      language.time.admissible sourceCoordinate.1 sourceCoordinate.2 /\
        language.labRecorded .q sourceCoordinate.1 /\
        language.relicOrdered .q sourceCoordinate.2 /\
        language.time.admissible targetCoordinate.1 targetCoordinate.2 /\
        language.labRecorded .p targetCoordinate.1 /\
        language.relicOrdered .p targetCoordinate.2 :=
  relatively_reversed_touch_has_two_axis_readings language reversedTouch

inductive Path
  | traveler
  | earth
deriving DecidableEq

def reunionExperiment : ReunionExperiment language Path Nat where
  departure := .p
  reunion := .q
  travelerPath := .traveler
  earthPath := .earth
  connects := fun _ before after => before = .p /\ after = .q
  travelerConnects := ⟨rfl, rfl⟩
  earthConnects := ⟨rfl, rfl⟩
  properTime := fun path =>
    match path with
    | .traveler => 1
    | .earth => 1000
  travelerAgesLess := by decide

theorem differential_aging_is_inhabited :
    reunionExperiment.properTime reunionExperiment.travelerPath <
      reunionExperiment.properTime reunionExperiment.earthPath := by
  decide

/-- A finite countermodel to the inference
`differential aging -> reversed relative orientation`: the reunion witness
coexists with a future-preserving comparison that is not future-reversing. -/
theorem differential_aging_does_not_force_relative_reversal :
    Nonempty (ReunionExperiment language Path Nat) /\
      exists comparison : Comparison language .q .p,
        FutureReadsAsFuture language comparison /\
          Not (FutureReadsAsPast language comparison) := by
  exact
    ⟨⟨reunionExperiment⟩,
      preservingComparison .q .p,
      preserving_reads_future_as_future .q .p,
      preserving_does_not_read_future_as_past .q .p⟩

#print axioms future_reading_cannot_be_both
#print axioms relatively_reversed_touch_has_two_axis_readings
#print axioms reunion_exhibits_shared_endpoints_and_differential_aging
#print axioms reversed_touch_reuses_existing_two_axis_time
#print axioms differential_aging_does_not_force_relative_reversal

end TMI.InterfaceFoundations.RelativeTemporalInterfaceAudit
