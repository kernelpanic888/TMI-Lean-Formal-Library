import Mathlib.Data.Set.Defs

/-!
# Memory and nearby-goal field

A candidate goal survives memory, slack, and an explicit boundary. Noise is a
record of exploration, not by itself an error theorem.
-/

universe u v

namespace TMI.InterfaceFoundations.MemoryGoalField

structure ContextMemory (Slice : Type u) where
  pastSlices : List Slice
  noisyTrace : List Slice
  retained : Slice -> Prop

structure Wandering (Slice : Type u) where
  step : Slice -> Slice -> Prop

structure Context (Slice : Type u) where
  memory : ContextMemory Slice
  current : Slice
  wandering : Wandering Slice
  withinSlack : Slice -> Slice -> Prop
  preservesBoundary : Slice -> Prop

def nearestGoalField {Slice : Type u} (ctx : Context Slice) : Set Slice :=
  { target |
    ctx.wandering.step ctx.current target /\
      ctx.memory.retained target /\
      ctx.withinSlack ctx.current target /\
      ctx.preservesBoundary target }

structure NearestGoal {Slice : Type u} (ctx : Context Slice) where
  target : Slice
  wanderingStep : ctx.wandering.step ctx.current target
  retainedByFilter : ctx.memory.retained target
  withinAllowedSlack : ctx.withinSlack ctx.current target
  preservesDistinction : ctx.preservesBoundary target

theorem nearestGoal_mem_field
    {Slice : Type u} {ctx : Context Slice}
    (goal : NearestGoal ctx) :
    goal.target ∈ nearestGoalField ctx :=
  ⟨goal.wanderingStep, goal.retainedByFilter,
    goal.withinAllowedSlack, goal.preservesDistinction⟩

structure WanderingFieldBridge (Carrier : Type v) (Slice : Type u) where
  context : Carrier -> Context Slice
  wanderingAutomaticity : Carrier -> Prop
  areaProbing : Carrier -> Prop
  singleLineSearch : Carrier -> Prop
  wanderingNoise : Carrier -> Prop
  wanderingProbesArea : forall carrier,
    wanderingAutomaticity carrier ->
      areaProbing carrier /\ Not (singleLineSearch carrier)
  areaProbingProducesNoise : forall carrier,
    areaProbing carrier -> wanderingNoise carrier

theorem wandering_opens_area_not_single_line
    {Carrier : Type v} {Slice : Type u}
    (bridge : WanderingFieldBridge Carrier Slice)
    (carrier : Carrier)
    (h : bridge.wanderingAutomaticity carrier) :
    bridge.areaProbing carrier /\ Not (bridge.singleLineSearch carrier) :=
  bridge.wanderingProbesArea carrier h

theorem area_probing_has_noise
    {Carrier : Type v} {Slice : Type u}
    (bridge : WanderingFieldBridge Carrier Slice)
    (carrier : Carrier)
    (h : bridge.areaProbing carrier) :
    bridge.wanderingNoise carrier :=
  bridge.areaProbingProducesNoise carrier h

end TMI.InterfaceFoundations.MemoryGoalField

namespace TMI.InterfaceFoundations.MemoryGoalField

/-!
The field is set-valued. Selection is a separate operation and therefore an
extra commitment: admissible possibilities do not choose themselves.
-/

universe x y z

structure FieldOfNearestGoalsFrame
    (Context : Type x)
    (Action : Type y)
    (Noise : Type z) where
  transition : Context -> Action -> Noise -> Context
  actionAllowed : Context -> Action -> Prop
  noiseAllowed : Context -> Noise -> Prop
  boundary : Context -> Prop
  quality : Context -> Context -> Prop
  nearby : Context -> Context -> Prop

def FieldOfNearestGoals
    {Context : Type x} {Action : Type y} {Noise : Type z}
    (frame : FieldOfNearestGoalsFrame Context Action Noise)
    (current : Context) : Set Context :=
  fun candidate =>
    frame.boundary candidate /\
      frame.nearby current candidate /\
      frame.quality current candidate /\
      exists action : Action,
        frame.actionAllowed current action /\
          exists noise : Noise,
            frame.noiseAllowed current noise /\
              frame.transition current action noise = candidate

def FieldOfNearestGoalsSelection
    {Context : Type x} {Action : Type y} {Noise : Type z}
    (frame : FieldOfNearestGoalsFrame Context Action Noise)
    (choose : Context -> Context) : Prop :=
  forall current : Context,
    FieldOfNearestGoals frame current (choose current)

theorem fieldOfNearestGoals_nonempty_of_selection
    {Context : Type x} {Action : Type y} {Noise : Type z}
    (frame : FieldOfNearestGoalsFrame Context Action Noise)
    (choose : Context -> Context)
    (selection : FieldOfNearestGoalsSelection frame choose)
    (current : Context) :
    exists candidate : Context,
      FieldOfNearestGoals frame current candidate :=
  ⟨choose current, selection current⟩

def WanderingInsideGoalField
    {Context : Type x} {Action : Type y} {Noise : Type z}
    (frame : FieldOfNearestGoalsFrame Context Action Noise)
    (areaProbe : Context -> Action -> Prop)
    (current : Context) : Prop :=
  exists action : Action,
    areaProbe current action /\
      exists noise : Noise,
        FieldOfNearestGoals frame current
          (frame.transition current action noise)

theorem selection_is_additional_data
    {Context : Type x} {Action : Type y} {Noise : Type z}
    (frame : FieldOfNearestGoalsFrame Context Action Noise)
    (choose : Context -> Context)
    (selection : FieldOfNearestGoalsSelection frame choose) :
    forall current : Context,
      FieldOfNearestGoals frame current (choose current) :=
  selection

end TMI.InterfaceFoundations.MemoryGoalField
