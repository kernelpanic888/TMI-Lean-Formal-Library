import TMI.ActivationRelicTwoAxisTime

/-!
# Relative temporal interface

This opt-in module extends the existing TLFL two-axis-time language with local
past/future direction predicates and an explicit comparison map between the
direction types at two events.

The distinction is deliberate:

* a local temporal interface contains both past and future sectors;
* a realized step supplies one future-directed local direction;
* a comparison may preserve or reverse the *reading* of a future sector;
* differential aging between two reunion paths is independent of such a
  relative reversal witness.

## Claim boundary

The module does not derive light cones from a Lorentzian metric, assert that a
physical spacetime reverses time orientation, produce a closed timelike curve,
or quantize a worldline/comparison map.  A reversing comparison is explicit
input data.  Its physical realization remains an open hypothesis.
-/

universe x y z d p t

namespace TMI.InterfaceFoundations.RelativeTemporalInterface

open TMI.ActivationRelicTwoAxisTime

/-- The compiled activation-relic two-axis-time surface, extended by event
records, local direction types, and disjoint future/past predicates. Directions
may vary with the event, so no global identification of tangent data is
assumed. -/
structure Language where
  Event : Type x
  PhysicalTime : Type y
  InternalTime : Type z
  time : TwoAxisTime PhysicalTime InternalTime
  labRecorded : Event -> PhysicalTime -> Prop
  relicOrdered : Event -> InternalTime -> Prop
  Direction : Event -> Type d
  future : {event : Event} -> Direction event -> Prop
  past : {event : Event} -> Direction event -> Prop
  futurePastDisjoint :
    forall {event : Event} {direction : Direction event},
      future direction -> past direction -> False

variable (L : Language)

/-- Reuse of the existing compiled TLFL `TimeTouch`; no second touch predicate
is introduced by RTI-01. -/
def EventTimeTouch (event : L.Event) : Prop :=
  TimeTouch L.time L.labRecorded L.relicOrdered event

/-- A rule for reading local directions at `source` through the local direction
type at `target`.  It is a plain map: invertibility, smoothness, and connection
compatibility are intentionally not assumed. -/
structure Comparison (source target : L.Event) where
  map : L.Direction source -> L.Direction target

instance {source target : L.Event} :
    CoeFun (Comparison L source target)
      (fun _ => L.Direction source -> L.Direction target) :=
  ⟨Comparison.map⟩

/-- The comparison preserves the reading of every future direction. -/
def FutureReadsAsFuture
    {source target : L.Event}
    (comparison : Comparison L source target) : Prop :=
  forall direction : L.Direction source,
    L.future direction -> L.future (comparison direction)

/-- The comparison reads every future direction at the source as past at the
target.  This is a relative-orientation statement, not a causal worldline. -/
def FutureReadsAsPast
    {source target : L.Event}
    (comparison : Comparison L source target) : Prop :=
  forall direction : L.Direction source,
    L.future direction -> L.past (comparison direction)

/-- One realized local step chooses a future direction at its source event. -/
structure OrientedStep (source target : L.Event) where
  direction : L.Direction source
  futureDirected : L.future direction

/-- A witness that one local future sector is read as a past sector through a
specified comparison map. -/
structure RelativeReversal (source target : L.Event) where
  comparison : Comparison L source target
  sourceHasFuture : exists direction : L.Direction source, L.future direction
  readsFutureAsPast : FutureReadsAsPast L comparison

/-- Disjoint future/past sectors prevent one nonempty future sector from being
both wholly preserved and wholly reversed by the same comparison. -/
theorem future_reading_cannot_be_both
    {source target : L.Event}
    (comparison : Comparison L source target)
    (sourceHasFuture : exists direction : L.Direction source, L.future direction)
    (preserved : FutureReadsAsFuture L comparison)
    (reversed : FutureReadsAsPast L comparison) :
    False := by
  rcases sourceHasFuture with ⟨direction, hFuture⟩
  exact L.futurePastDisjoint
    (preserved direction hFuture)
    (reversed direction hFuture)

/-- The open physical obligation: every pair declared admissible must be
equipped with an explicit relative-reversal witness.  Naming this proposition
does not provide such witnesses. -/
def RelativeReversalHypothesis
    (admissible : L.Event -> L.Event -> Prop) : Prop :=
  forall source target,
    admissible source target ->
      Nonempty (RelativeReversal L source target)

/-- Two time-touch events together with a comparison that reverses the reading
of the source future sector at the target interface. -/
structure RelativelyReversedTouch
    (source target : L.Event) where
  sourceTouch : EventTimeTouch L source
  targetTouch : EventTimeTouch L target
  reversal : RelativeReversal L source target

/-- Existing TLFL `TimeTouch` theorems provide the two-axis readings; the new
relative-orientation witness remains a separate conjunct. -/
theorem relatively_reversed_touch_has_two_axis_readings
    {source target : L.Event}
    (touch : RelativelyReversedTouch L source target) :
    exists sourceCoordinate : TimeCoordinate L.PhysicalTime L.InternalTime,
    exists targetCoordinate : TimeCoordinate L.PhysicalTime L.InternalTime,
      L.time.admissible sourceCoordinate.1 sourceCoordinate.2 /\
        L.labRecorded source sourceCoordinate.1 /\
        L.relicOrdered source sourceCoordinate.2 /\
        L.time.admissible targetCoordinate.1 targetCoordinate.2 /\
        L.labRecorded target targetCoordinate.1 /\
        L.relicOrdered target targetCoordinate.2 := by
  rcases timeTouch_has_two_coordinates touch.sourceTouch with
    ⟨sourceCoordinate, sourceAdmissible, sourceLab, sourceInternal⟩
  rcases timeTouch_has_two_coordinates touch.targetTouch with
    ⟨targetCoordinate, targetAdmissible, targetLab, targetInternal⟩
  exact
    ⟨sourceCoordinate, targetCoordinate,
      sourceAdmissible, sourceLab, sourceInternal,
      targetAdmissible, targetLab, targetInternal⟩

/-- A reunion experiment records two named paths with common endpoints and
different accumulated proper-time values.  The strict inequality is supplied
as evidence; no metric calculation is hidden in this structure. -/
structure ReunionExperiment
    (Path : Type p)
    (Duration : Type t)
    [LT Duration] where
  departure : L.Event
  reunion : L.Event
  travelerPath : Path
  earthPath : Path
  connects : Path -> L.Event -> L.Event -> Prop
  travelerConnects : connects travelerPath departure reunion
  earthConnects : connects earthPath departure reunion
  properTime : Path -> Duration
  travelerAgesLess : properTime travelerPath < properTime earthPath

theorem reunion_exhibits_shared_endpoints_and_differential_aging
    {Path : Type p}
    {Duration : Type t}
    [LT Duration]
    (experiment : ReunionExperiment L Path Duration) :
    experiment.connects
        experiment.travelerPath experiment.departure experiment.reunion /\
      experiment.connects
        experiment.earthPath experiment.departure experiment.reunion /\
      experiment.properTime experiment.travelerPath <
        experiment.properTime experiment.earthPath :=
  ⟨experiment.travelerConnects,
    experiment.earthConnects,
    experiment.travelerAgesLess⟩

end TMI.InterfaceFoundations.RelativeTemporalInterface
