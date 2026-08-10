import TMI.BoundaryEvent
import TMI.InterfaceFoundationsAlpha

/-!
# Spinor ontology: an experimental TMI interpretation scaffold

This module is opt-in.  It does not change `TMI.Library`, the existing
experimental `TwoSidedLanguage`, or the stable boundary-event surface.  It
packages small adapters around those abstractions.

## Claim boundary

The declarations below are kernel-checked definitions and consequences of
their explicit fields.  The proposed reading

*primary interface -> distinction -> internal transition -> projection ->
measurement event*

is a **TMI interpretation and research hypothesis**, not accepted physics and
not an empirical result.  In particular, this file does not derive quantum
mechanics, identify a physical spinor with a TMI interface, solve a measurement
problem, or derive the Dirac equation.

## Standard-theory reference formulas (comments only)

The following formulas are supplied only as conventional physics context; they
are not theorem statements proved by this module.

* A pure two-level state can be written
  `|psi> = alpha |0> + beta |1>`, with
  `|alpha|^2 + |beta|^2 = 1` after normalization.
  Reference: MIT OpenCourseWare, Quantum Physics I, qubit lecture transcript:
  https://ocw.mit.edu/courses/8-04-quantum-physics-i-spring-2013/174d620cf96b5724f6a73bc7f8ffda6a_awpnsGl08bc.pdf

* Physical pure states are rays: `psi ~ lambda psi` for nonzero
  `lambda : Complex`.  Normalized representatives differ by an overall phase.
  Reference: David Tong, Quantum Mechanics, section 1.1:
  https://www.damtp.cam.ac.uk/user/tong/qm/qmhtml/S1.html

* For spin one-half, `S = (hbar / 2) sigma`, and an axis-angle rotation is
  conventionally represented by
  `U(theta, n) = exp (-i theta (n dot sigma) / 2)`.
  References: David Skinner, Principles of Quantum Mechanics, chapter 5,
  https://www.damtp.cam.ac.uk/user/dbs26/PQM/chap5.pdf
  and Cambridge PQM supplementary notes,
  https://www.damtp.cam.ac.uk/user/examples/D18S.pdf

* Relativistic context: in units with `hbar = c = 1`, the free Dirac equation
  is `(i gamma^mu partial_mu - m) psi = 0`.  With metric convention
  `eta = diag(+1,-1,-1,-1)`, the gamma matrices obey
  `{gamma^mu, gamma^nu} = 2 eta^{mu nu} 1`.
  Reference: David Tong, Quantum Field Theory, section 4:
  https://www.damtp.cam.ac.uk/user/tong/qft/qfthtml/S4.html

Sign and phase conventions vary.  These standard equations constrain a future
physical realization; they do not validate the TMI interpretation.

## Existing formal lineage found in this repository

The new names are deliberately namespaced and do not replace the following
surfaces:

* `TMI.InterfaceFoundationsAlpha.TwoSidedLanguage` supplies left/right types,
  an interface carrier `Sigma`, directional contacts, distinguishability, and
  interface evolution;
* `TMI.BoundaryEvent.BoundaryEventContext` supplies states, events,
  boundaries, before/after predicates, crossing, admissibility, and records;
* `TMI.Core.CoreSemanticModel` is the model-indexed mirror of the older core
  interface signature;
* `TMI.InterfaceMathematics.MeasurementDecoherenceContext` separates a guarded
  measurement/decoherence reading from its stronger identification context;
* `ExternalProofProjection`, `IntegratedProofProjection`,
  `SelfReferentialProofModel`, and the `Model` fields of the thinker contexts
  already use projection/model language for proof self-modeling rather than
  for physical spinors.

`SpinorOntology.Projection` and `SpinorOntologyModel` therefore remain local to
this experimental namespace.
-/

namespace TMI
namespace SpinorOntology

universe uState uObservation

/-- Status labels separate definitions, standard reference theory, and open
interpretation.  A status value is metadata, not a physics certificate. -/
inductive ClaimStatus where
  | kernelCheckedDefinition
  | standardTheoryReference
  | tmiInterpretation
  | hypothesis
  | placeholder
deriving DecidableEq, Repr

/-- `PrimaryInterface` selects a boundary in the existing two-sided interface
language.  Calling it "primary" records the proposed TMI reading only; it does
not assert ontological or physical primacy. -/
structure PrimaryInterface
    (L : TMI.InterfaceFoundationsAlpha.TwoSidedLanguage) where
  boundary : L.Sigma

/-- A maintained distinction at the selected boundary.  This reuses the
existing distinguishability and directional-contact predicates without
strengthening them. -/
def Distinction
    {L : TMI.InterfaceFoundationsAlpha.TwoSidedLanguage}
    (interface : PrimaryInterface L)
    (left : L.L)
    (right : L.R) : Prop :=
  L.distinguishable left right /\
    L.forwardContact left interface.boundary /\
    L.reverseContact interface.boundary right

/-- An admissible state transition.  The structure carries a witness of its
own abstract admissibility predicate; it says nothing about physical dynamics. -/
structure Transition (State : Type uState) where
  source : State
  target : State
  admissible : Prop
  admissibilityWitness : admissible

/-- An internal relation on a carrier.  No symmetry, metric, causal, or
dynamical law is assumed. -/
structure InternalRelation (State : Type uState) where
  relates : State -> State -> Prop

/-- An abstract carrier for candidate spinor states.

`rayEquivalent` is required to be an equivalence relation so that observations
may be defined on projective classes.  This is not yet a construction of
`Complex^2`, a Hilbert space, `SU(2)`, a spin bundle, or a Dirac spinor. -/
structure SpinorCarrier where
  State : Type uState
  admitted : State -> Prop
  rayEquivalent : State -> State -> Prop
  ray_refl : forall psi, rayEquivalent psi psi
  ray_symm : forall {psi phi}, rayEquivalent psi phi -> rayEquivalent phi psi
  ray_trans : forall {psi phi chi},
    rayEquivalent psi phi -> rayEquivalent phi chi -> rayEquivalent psi chi
  internal : InternalRelation State

/-- An observation map that is insensitive to the chosen representative of a
ray.  This is a typed projective interface, not the Born rule. -/
structure Projection
    (carrier : SpinorCarrier)
    (Observation : Type uObservation) where
  observe : carrier.State -> Observation
  respectsRay : forall {psi phi},
    carrier.rayEquivalent psi phi -> observe psi = observe phi

/-- A recorded projection after an admitted abstract transition at a selected
interface boundary.

The name `MeasurementEvent` is intentionally structural: it does not assert
collapse, decoherence, a probability law, or a laboratory realization. -/
structure MeasurementEvent
    {L : TMI.InterfaceFoundationsAlpha.TwoSidedLanguage}
    (interface : PrimaryInterface L)
    (carrier : SpinorCarrier)
    {Observation : Type uObservation}
    (projection : Projection carrier Observation) where
  transition : Transition carrier.State
  sourceAdmitted : carrier.admitted transition.source
  targetAdmitted : carrier.admitted transition.target
  internalTransition :
    carrier.internal.relates transition.source transition.target
  outcome : Observation
  recordsProjection : projection.observe transition.target = outcome

/-- A convenient bundle of the scaffold's dependent components. -/
structure SpinorOntologyModel
    (L : TMI.InterfaceFoundationsAlpha.TwoSidedLanguage)
    (Observation : Type uObservation) where
  primaryInterface : PrimaryInterface L
  carrier : SpinorCarrier.{uState}
  projection : Projection carrier Observation

/-- The formal status of the declarations in this module. -/
def scaffoldStatus : ClaimStatus := .kernelCheckedDefinition

/-- The status of reading this scaffold as an ontology of physical spinors. -/
def physicalIdentificationStatus : ClaimStatus := .hypothesis

/-- The standard formulas in the module comment are references, not outputs of
the TMI formalization. -/
def referenceFormulaStatus : ClaimStatus := .standardTheoryReference

/-- The proposed interface/distinction vocabulary is an interpretive bridge. -/
def tmiReadingStatus : ClaimStatus := .tmiInterpretation

/-- A concrete Clifford/Dirac realization is future work in this module. -/
def diracFormalizationStatus : ClaimStatus := .placeholder

theorem projection_is_ray_invariant
    {carrier : SpinorCarrier}
    {Observation : Type uObservation}
    (projection : Projection carrier Observation)
    {psi phi : carrier.State}
    (hRay : carrier.rayEquivalent psi phi) :
    projection.observe psi = projection.observe phi :=
  projection.respectsRay hRay

theorem distinction_preserves_distinguishability
    {L : TMI.InterfaceFoundationsAlpha.TwoSidedLanguage}
    {interface : PrimaryInterface L}
    {left : L.L}
    {right : L.R}
    (hDistinction : Distinction interface left right) :
    L.distinguishable left right :=
  hDistinction.1

theorem distinction_has_both_contacts
    {L : TMI.InterfaceFoundationsAlpha.TwoSidedLanguage}
    {interface : PrimaryInterface L}
    {left : L.L}
    {right : L.R}
    (hDistinction : Distinction interface left right) :
    L.forwardContact left interface.boundary /\
      L.reverseContact interface.boundary right :=
  hDistinction.2

/-!
## Adapters to the existing library

`BoundaryEventContext` currently lives in `Type`, so this adapter is stated at
universe zero.  It changes neither the source context nor the general scaffold.
-/

section BoundaryEventAdapter

variable
  {L : TMI.InterfaceFoundationsAlpha.TwoSidedLanguage.{0, 0}}
  (interface : PrimaryInterface L)
  (carrier : SpinorCarrier.{0})
  {Observation : Type}
  (projection : Projection carrier Observation)

/-- View structural measurement events through the existing boundary-event
surface. -/
def measurementBoundaryContext : TMI.BoundaryEvent.BoundaryEventContext where
  State := carrier.State
  Event := MeasurementEvent interface carrier projection
  Boundary := L.Sigma
  Record := Observation
  before := fun event state => event.transition.source = state
  after := fun event state => event.transition.target = state
  crosses := fun _ boundary => boundary = interface.boundary
  admissible := fun event => event.transition.admissible
  recorded_as := fun event record => event.outcome = record

theorem measurement_event_is_recorded_boundary_event
    (event : MeasurementEvent interface carrier projection) :
    TMI.BoundaryEvent.RecordedBoundaryEvent
      (measurementBoundaryContext interface carrier projection) event := by
  constructor
  · exact
      ⟨event.transition.source,
        event.transition.target,
        interface.boundary,
        rfl,
        rfl,
        rfl,
        event.transition.admissibilityWitness⟩
  · exact ⟨event.outcome, rfl⟩

end BoundaryEventAdapter

/-!
## Explicit non-claims

These false flags make the present boundary machine-readable.  They do not
deny standard quantum theory; they deny that this scaffold has established the
listed bridges.
-/

def physicalSpinorIdentifiedWithPrimaryInterface : Prop := False

def bornRuleDerived : Prop := False

def diracEquationDerived : Prop := False

def gammaAnticommutationDerived : Prop := False

def empiricalValidationEstablished : Prop := False

theorem physical_identification_not_claimed :
    Not physicalSpinorIdentifiedWithPrimaryInterface := by
  intro h
  exact h

theorem born_rule_not_derived : Not bornRuleDerived := by
  intro h
  exact h

theorem dirac_equation_not_derived : Not diracEquationDerived := by
  intro h
  exact h

theorem gamma_anticommutation_not_derived :
    Not gammaAnticommutationDerived := by
  intro h
  exact h

theorem empirical_validation_not_claimed :
    Not empiricalValidationEstablished := by
  intro h
  exact h

end SpinorOntology
end TMI
