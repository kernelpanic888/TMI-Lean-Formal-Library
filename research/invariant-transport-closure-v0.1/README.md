# Invariant Transport Closure · v0.1-alpha RC

`InvariantTransportClosure.lean` is a compact, opt-in formal bridge for the
working phrase “local imbalance, global closure”.  It formalizes only the
transport-and-return skeleton.  It does not supply a physical dynamics.

## Existing contour: three independent contacts

1. **A-09 / growth transport.** The connectedness reader names a transition
   `g_D`, a transport `tau_g`, and their action on a selected invariant in
   `exports/chertogi_first_distinction_public/connectedness-c01/FIELD_OF_NEAREST_GOALS_DUAL_READER.html`
   at the section headed `A-09`.  `GrowthTransport` preserves that data shape.
2. **Nearest-goal field / transition witness.** In
   `lean/TMI/InterfaceFoundations/MemoryGoalField.lean`, membership in
   `FieldOfNearestGoals` contains an allowed action, allowed noise, and the
   equality `frame.transition current action noise = candidate`.  This is an
   independent existing instance of “continuation is witnessed by a named
   transition”, not a theorem of invariant return.
3. **Boundary plus record.** `lean/TMI/BoundaryEvent.lean` defines a boundary
   event and a separately recorded boundary event.  `BoundaryEventEncoding`
   and `ClosureRecord.to_recorded_boundary_event` connect the new carrier to
   that stable public surface without deriving a boundary event from closure.

The first contact is a reader-level candidate rule, the second is existing
experimental Lean source, and the third is a kernel-built Lean import.  They
are not presented as three proofs of one physical law.

## Kernel-checked content

- `PersistenceStep` contains an explicit transition and transport agreement.
- `ClosedTurn` contains a typed path back to its base and return of one named
  invariant value.
- `ClosureRecord` joins closure, a boundary witness, and a stable-record
  witness while keeping the latter two independent obligations.
- `selected_return_does_not_imply_transport_identity` is a negative test: one
  fixed invariant value can return even when the complete transport is not the
  identity.
- The audit reports no axioms for the public bridge theorems.

Build only this opt-in surface with:

```bash
lake build TMI.InvariantTransportClosure TMI.InvariantTransportClosureAudit
```

## Claim boundary

Not established here:

- local imbalance implies an orbit;
- absence of a transition physically causes decay;
- a closed path implies dynamical stability;
- return of one selected invariant implies identity of the full transport;
- any concrete physical system instantiates `State`, `Step`, `Invariant`, or
  the boundary/stable-record witnesses.

The current result is therefore a formal bridge and claim passport, not a new
fundamental theorem of dynamics.

## Dependency seam

`MemoryGoalField.lean` currently imports Mathlib while this package's
`lake-manifest.json` declares no Mathlib package.  The source-level connection
above is exact, but it is not advertised as a compiled dependency of this RC.
The ITC module deliberately imports only buildable package roots.
