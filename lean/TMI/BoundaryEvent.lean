/-
Boundary-event surface for TMI-Lean Formal Library 0.1.

A boundary event is the minimal formal place where a transition crosses an
interface boundary and leaves a record. This file is intentionally small: it
defines the public vocabulary without committing the library to one physical
reading of boundary events.
-/

namespace TMI
namespace BoundaryEvent

structure BoundaryEventContext where
  State : Type
  Event : Type
  Boundary : Type
  Record : Type
  before : Event -> State -> Prop
  after : Event -> State -> Prop
  crosses : Event -> Boundary -> Prop
  admissible : Event -> Prop
  recorded_as : Event -> Record -> Prop

def BoundaryEvent (ctx : BoundaryEventContext) (e : ctx.Event) : Prop :=
  exists s0 s1 : ctx.State,
    exists b : ctx.Boundary,
      ctx.before e s0 /\
      ctx.after e s1 /\
      ctx.crosses e b /\
      ctx.admissible e

def RecordedBoundaryEvent
    (ctx : BoundaryEventContext)
    (e : ctx.Event) : Prop :=
  BoundaryEvent ctx e /\
  exists r : ctx.Record, ctx.recorded_as e r

theorem recorded_boundary_event_gives_boundary_event
    {ctx : BoundaryEventContext}
    {e : ctx.Event} :
    RecordedBoundaryEvent ctx e -> BoundaryEvent ctx e := by
  intro h
  exact h.1

end BoundaryEvent
end TMI
