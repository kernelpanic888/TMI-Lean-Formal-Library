import TMI.InterfaceFoundations.TwoSidedInterface

/-!
# Relational two-axis time

The physical and internal axes are related through recorded interface events.
This is not a second physical timelike dimension and does not assume a global
synchronization function.
-/

universe u v w x y z

namespace TMI.InterfaceFoundations.TwoAxisTime

structure Language extends TwoSidedInterface.Language where
  Event : Type x
  PhysicalTime : Type y
  InternalTime : Type z
  crosses : Event -> Boundary -> Left -> Right -> Prop
  physicalAt : Event -> PhysicalTime -> Prop
  recordedAt : Event -> InternalTime -> Prop

variable (L : Language)

def TimeRelation
    (physicalTime : L.PhysicalTime)
    (internalTime : L.InternalTime) : Prop :=
  exists event : L.Event,
    L.physicalAt event physicalTime /\ L.recordedAt event internalTime

def TimeTouch
    (left : L.Left)
    (right : L.Right)
    (event : L.Event) : Prop :=
  exists boundary : L.Boundary,
  exists physicalTime : L.PhysicalTime,
  exists internalTime : L.InternalTime,
    L.crosses event boundary left right /\
      L.physicalAt event physicalTime /\
      L.recordedAt event internalTime

theorem timeTouch_has_two_axis_reading
    {left : L.Left} {right : L.Right} {event : L.Event}
    (hTouch : L.TimeTouch left right event) :
    exists physicalTime : L.PhysicalTime,
    exists internalTime : L.InternalTime,
      L.TimeRelation physicalTime internalTime := by
  rcases hTouch with
    ⟨boundary, physicalTime, internalTime, hCrosses, hPhysical, hRecorded⟩
  exact ⟨physicalTime, internalTime, event, hPhysical, hRecorded⟩

def FunctionallySynchronized : Prop :=
  forall physicalTime : L.PhysicalTime,
  forall internalTime₁ internalTime₂ : L.InternalTime,
    L.TimeRelation physicalTime internalTime₁ ->
      L.TimeRelation physicalTime internalTime₂ ->
        internalTime₁ = internalTime₂

theorem synchronized_readings_unique
    (hSync : L.FunctionallySynchronized)
    {physicalTime : L.PhysicalTime}
    {internalTime₁ internalTime₂ : L.InternalTime}
    (hFirst : L.TimeRelation physicalTime internalTime₁)
    (hSecond : L.TimeRelation physicalTime internalTime₂) :
    internalTime₁ = internalTime₂ :=
  hSync physicalTime internalTime₁ internalTime₂ hFirst hSecond

end TMI.InterfaceFoundations.TwoAxisTime
