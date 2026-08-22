import TMI.BoundaryEvent
import TMI.InterfaceFoundationsAlpha

/-!
# Invariant Transport Closure

This module records a compact formal bridge:

* persistence is carried by an explicit transition together with transport of
  a selected invariant;
* a full turn is a typed path returning to its base state;
* closure records return of a selected invariant after that turn;
* boundary and stable-record evidence remain separate witnesses.

## Claim boundary

The declarations below do **not** prove that local imbalance produces an
orbit, that a closed path is dynamically stable, or that return of one selected
invariant makes the whole transport equivalence the identity.  A concrete
dynamics and a nontrivial stability theorem remain external obligations.
-/

namespace TMI
namespace InvariantTransportClosure

universe uState uInvariant

/-- This bridge remains on the opt-in experimental surface. -/
def moduleStatus : TMI.InterfaceFoundationsAlpha.FormalStatus :=
  .experimental

theorem module_status_is_experimental :
    moduleStatus = TMI.InterfaceFoundationsAlpha.FormalStatus.experimental :=
  rfl

/-- A small dependency-free equivalence used for invariant transport. -/
structure TransportEquiv (Source : Type uInvariant) (Target : Type uInvariant) where
  forward : Source -> Target
  backward : Target -> Source
  leftInverse : forall source, backward (forward source) = source
  rightInverse : forall target, forward (backward target) = target

namespace TransportEquiv

def refl (Carrier : Type uInvariant) : TransportEquiv Carrier Carrier where
  forward := id
  backward := id
  leftInverse := by intro source; rfl
  rightInverse := by intro target; rfl

def trans
    {A B C : Type uInvariant}
    (first : TransportEquiv A B)
    (second : TransportEquiv B C) :
    TransportEquiv A C where
  forward := fun source => second.forward (first.forward source)
  backward := fun target => first.backward (second.backward target)
  leftInverse := by
    intro source
    rw [second.leftInverse, first.leftInverse]
  rightInverse := by
    intro target
    rw [first.rightInverse, second.rightInverse]

end TransportEquiv

/-- A transition system equipped with transport for a state-indexed invariant.
No dynamics, topology, metric, or stability law is assumed. -/
structure TransportSystem
    (State : Type uState)
    (Invariant : State -> Type uInvariant) where
  Step : State -> State -> Prop
  transport :
    {src dst : State} -> Step src dst ->
      TransportEquiv (Invariant src) (Invariant dst)

/-- A persistence record explicitly contains both the transition and the
invariant transport, together with agreement with the ambient system. -/
structure PersistenceStep
    {State : Type uState}
    {Invariant : State -> Type uInvariant}
    (system : TransportSystem State Invariant)
    (src dst : State) where
  transition : system.Step src dst
  invariantTransport : TransportEquiv (Invariant src) (Invariant dst)
  transportAgrees : invariantTransport = system.transport transition

/-- A persistence record always exposes a transition witness.  This is weaker
than the physical claim that absence of dynamics causes decay. -/
theorem PersistenceStep.has_transition
    {State : Type uState}
    {Invariant : State -> Type uInvariant}
    {system : TransportSystem State Invariant}
    {src dst : State}
    (step : PersistenceStep system src dst) :
    Nonempty (system.Step src dst) :=
  ⟨step.transition⟩

/-- The selected invariant is transported exactly by the equivalence named in
the persistence record. -/
theorem PersistenceStep.carries
    {State : Type uState}
    {Invariant : State -> Type uInvariant}
    {system : TransportSystem State Invariant}
    {src dst : State}
    (step : PersistenceStep system src dst)
    (selected : Invariant src) :
    step.invariantTransport.forward selected =
      (system.transport step.transition).forward selected := by
  rw [step.transportAgrees]

/-- The A-09-shaped growth carrier.  g_D and tau_g are data; the structure
does not claim that an arbitrary physical growth process supplies them. -/
structure GrowthTransport
    {State : Type uState}
    {Invariant : State -> Type uInvariant}
    (system : TransportSystem State Invariant)
    (src dst : State) where
  g_D : system.Step src dst
  tau_g : TransportEquiv (Invariant src) (Invariant dst)
  carriesInvariant : tau_g = system.transport g_D

def GrowthTransport.toPersistenceStep
    {State : Type uState}
    {Invariant : State -> Type uInvariant}
    {system : TransportSystem State Invariant}
    {src dst : State}
    (growth : GrowthTransport system src dst) :
    PersistenceStep system src dst where
  transition := growth.g_D
  invariantTransport := growth.tau_g
  transportAgrees := growth.carriesInvariant

/-- Typed finite paths in the transition system. -/
inductive Path
    {State : Type uState}
    {Invariant : State -> Type uInvariant}
    (system : TransportSystem State Invariant) :
    State -> State -> Type (max uState uInvariant) where
  | nil (state : State) : Path system state state
  | cons {src next dst : State} :
      system.Step src next -> Path system next dst -> Path system src dst

/-- Composite invariant transport along a typed path. -/
def Path.transport
    {State : Type uState}
    {Invariant : State -> Type uInvariant}
    {system : TransportSystem State Invariant}
    {src dst : State} :
    Path system src dst -> TransportEquiv (Invariant src) (Invariant dst)
  | .nil _ => TransportEquiv.refl _
  | .cons step rest =>
      TransportEquiv.trans (system.transport step) rest.transport

/-- A full turn is a path returning to its base, plus return of one explicitly
selected invariant value. -/
structure ClosedTurn
    {State : Type uState}
    {Invariant : State -> Type uInvariant}
    (system : TransportSystem State Invariant)
    (base : State) where
  path : Path system base base
  selectedInvariant : Invariant base
  returns :
    path.transport.forward selectedInvariant = selectedInvariant

theorem ClosedTurn.selected_invariant_returns
    {State : Type uState}
    {Invariant : State -> Type uInvariant}
    {system : TransportSystem State Invariant}
    {base : State}
    (turn : ClosedTurn system base) :
    turn.path.transport.forward turn.selectedInvariant =
      turn.selectedInvariant :=
  turn.returns

/-- Boundary evidence is deliberately independent of cyclic closure. -/
structure BoundaryWitness
    (State : Type uState)
    (base : State) where
  boundary : State -> Prop
  holdsAtBase : boundary base

/-- Stable-record evidence is deliberately independent of cyclic closure. -/
structure StableRecordWitness
    {State : Type uState}
    (Invariant : State -> Type uInvariant)
    (base : State)
    (selected : Invariant base) where
  stableRecord : Invariant base -> Prop
  holdsForSelected : stableRecord selected

/-- The stronger public carrier joins closure, boundary, and stable record
without deriving either witness from the closed turn. -/
structure ClosureRecord
    {State : Type uState}
    {Invariant : State -> Type uInvariant}
    (system : TransportSystem State Invariant)
    (base : State) where
  turn : ClosedTurn system base
  boundaryWitness : BoundaryWitness State base
  stableRecordWitness :
    StableRecordWitness Invariant base turn.selectedInvariant

def ClosureRecord.exposes_separate_witnesses
    {State : Type uState}
    {Invariant : State -> Type uInvariant}
    {system : TransportSystem State Invariant}
    {base : State}
    (record : ClosureRecord system base) :
    Prod (BoundaryWitness State base)
      (StableRecordWitness Invariant base record.turn.selectedInvariant) :=
  ⟨record.boundaryWitness, record.stableRecordWitness⟩

/-- An explicit adapter into the existing `TMI.BoundaryEvent` record surface.
The adapter does not derive a boundary event from cyclic closure: it requires
one and only states how a closure record is encoded as its stable record. -/
structure BoundaryEventEncoding
    {State : Type uState}
    {Invariant : State -> Type uInvariant}
    (system : TransportSystem State Invariant)
    (base : State)
    (ctx : TMI.BoundaryEvent.BoundaryEventContext) where
  encode : ClosureRecord system base -> ctx.Record
  recorded :
    (record : ClosureRecord system base) ->
      (event : ctx.Event) ->
        TMI.BoundaryEvent.BoundaryEvent ctx event ->
          ctx.recorded_as event (encode record)

/-- Closure plus an independently witnessed boundary event yields the existing
library's `RecordedBoundaryEvent` through an explicit encoding. -/
theorem ClosureRecord.to_recorded_boundary_event
    {State : Type uState}
    {Invariant : State -> Type uInvariant}
    {system : TransportSystem State Invariant}
    {base : State}
    {ctx : TMI.BoundaryEvent.BoundaryEventContext}
    (encoding : BoundaryEventEncoding system base ctx)
    (record : ClosureRecord system base)
    (event : ctx.Event)
    (boundaryEvent : TMI.BoundaryEvent.BoundaryEvent ctx event) :
    TMI.BoundaryEvent.RecordedBoundaryEvent ctx event :=
  ⟨boundaryEvent, ⟨encoding.encode record,
    encoding.recorded record event boundaryEvent⟩⟩

/-! ## Negative test: selected return does not imply identity transport -/

inductive ThreePoint where
  | fixed
  | left
  | right
deriving DecidableEq, Repr

def swapSides : TransportEquiv ThreePoint ThreePoint where
  forward
    | .fixed => .fixed
    | .left => .right
    | .right => .left
  backward
    | .fixed => .fixed
    | .left => .right
    | .right => .left
  leftInverse := by
    intro point
    cases point <;> rfl
  rightInverse := by
    intro point
    cases point <;> rfl

theorem swapSides_returns_selected :
    swapSides.forward ThreePoint.fixed = ThreePoint.fixed :=
  rfl

theorem swapSides_is_not_identity :
    swapSides ≠ TransportEquiv.refl ThreePoint := by
  intro identity
  have atLeft :=
    congrArg
      (fun e : TransportEquiv ThreePoint ThreePoint =>
        e.forward ThreePoint.left)
      identity
  change ThreePoint.right = ThreePoint.left at atLeft
  cases atLeft

theorem selected_return_does_not_imply_transport_identity :
    swapSides.forward ThreePoint.fixed = ThreePoint.fixed /\
      swapSides ≠ TransportEquiv.refl ThreePoint :=
  ⟨swapSides_returns_selected, swapSides_is_not_identity⟩

end InvariantTransportClosure
end TMI
