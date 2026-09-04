/-
Interface Mathematics: context that cannot be erased.

This module turns CTX-01 into a Lean carrier.  It separates four claims:

1. visible values are indexed by their context;
2. a global state exists only when it realizes every local reading;
3. a probe reveals rather than creates an obstruction only when it preserves
   the probed state;
4. an unknown classical context is not a coherent quantum context.  Quantum
   coherence requires a nonzero off-diagonal density-kernel witness.

The final layer is an abstract density-matrix signature.  It records exactly
the multiplicative fragment needed by the coherence proof and does not claim a
new physical theory or identify a software interface with a quantum system.
-/

namespace TMI
namespace InterfaceMathematics
namespace ContextualInterface

universe uContext uState uValue uScalar

/-! ## Context-indexed readings and global gluing -/

structure Frame where
  Context : Type uContext
  State : Type uState
  Value : Type uValue
  project : Context -> State -> Value
  overlaps : Context -> Context -> Prop
  agrees : Value -> Value -> Prop
  globalProjectionsAgree :
    forall state left right,
      overlaps left right ->
        agrees (project left state) (project right state)

abbrev LocalFamily (frame : Frame) : Type _ :=
  frame.Context -> frame.Value

def HasGlobalSection
    (frame : Frame)
    (readings : LocalFamily frame) : Prop :=
  exists state : frame.State,
    forall context : frame.Context,
      frame.project context state = readings context

def ContextualObstruction
    (frame : Frame)
    (readings : LocalFamily frame) : Prop :=
  Not (HasGlobalSection frame readings)

def PairwiseCompatible
    (frame : Frame)
    (readings : LocalFamily frame) : Prop :=
  forall left right : frame.Context,
    frame.overlaps left right ->
      frame.agrees (readings left) (readings right)

structure GlobalSection
    (frame : Frame)
    (readings : LocalFamily frame) where
  state : frame.State
  realizes : forall context : frame.Context,
    frame.project context state = readings context

theorem has_global_section_iff_nonempty_witness
    {frame : Frame}
    {readings : LocalFamily frame} :
    HasGlobalSection frame readings <->
      Nonempty (GlobalSection frame readings) := by
  constructor
  · intro h
    rcases h with ⟨state, realizes⟩
    exact ⟨⟨state, realizes⟩⟩
  · intro h
    rcases h with ⟨witness⟩
    exact ⟨witness.state, witness.realizes⟩

theorem global_section_gives_pairwise_compatible
    {frame : Frame}
    {readings : LocalFamily frame}
    (global : HasGlobalSection frame readings) :
    PairwiseCompatible frame readings := by
  rcases global with ⟨state, realizes⟩
  intro left right overlap
  have h := frame.globalProjectionsAgree state left right overlap
  simpa only [realizes left, realizes right] using h

theorem contextual_obstruction_is_no_global_section
    {frame : Frame}
    {readings : LocalFamily frame} :
    ContextualObstruction frame readings <->
      Not (HasGlobalSection frame readings) := by
  rfl

/-! ## A finite source-index example -/

inductive PlanSurface where
  | billing
  | usage
  deriving DecidableEq

inductive PlanValue where
  | free
  | pro
  deriving DecidableEq

def planFamily : PlanSurface -> PlanValue
  | .billing => .free
  | .usage => .pro

theorem billing_reading_is_free :
    planFamily .billing = .free := by
  rfl

theorem usage_reading_is_pro :
    planFamily .usage = .pro := by
  rfl

theorem erasing_the_context_index_forces_a_false_identification :
    Not (exists value : PlanValue,
      value = .free /\ value = .pro) := by
  intro h
  rcases h with ⟨value, isFree, isPro⟩
  have impossible : PlanValue.free = PlanValue.pro :=
    isFree.symm.trans isPro
  cases impossible

def DisjointPlanFrame : Frame where
  Context := PlanSurface
  State := Unit
  Value := PlanValue
  project := fun _ _ => .free
  overlaps := fun _ _ => False
  agrees := Eq
  globalProjectionsAgree := by
    intro state left right overlap
    exact False.elim overlap

theorem plan_family_is_pairwise_compatible :
    PairwiseCompatible DisjointPlanFrame planFamily := by
  intro left right overlap
  exact False.elim overlap

theorem plan_family_has_contextual_obstruction :
    ContextualObstruction DisjointPlanFrame planFamily := by
  intro global
  rcases global with ⟨state, realizes⟩
  have impossible := realizes PlanSurface.usage
  change PlanValue.free = PlanValue.pro at impossible
  cases impossible

theorem pairwise_compatibility_does_not_imply_global_gluing :
    PairwiseCompatible DisjointPlanFrame planFamily /\
      ContextualObstruction DisjointPlanFrame planFamily :=
  ⟨plan_family_is_pairwise_compatible,
    plan_family_has_contextual_obstruction⟩

/-! ## Nondisturbing probes: reveal versus create -/

structure ProbeFrame where
  State : Type uState
  probe : State -> State
  obstruction : State -> Prop
  witnessVisible : State -> Prop

def NondisturbingAt
    (frame : ProbeFrame)
    (state : frame.State) : Prop :=
  frame.probe state = state

def CoversWitnessAt
    (frame : ProbeFrame)
    (state : frame.State) : Prop :=
  frame.witnessVisible (frame.probe state)

def RevealedAt
    (frame : ProbeFrame)
    (state : frame.State) : Prop :=
  frame.obstruction (frame.probe state) /\
    frame.witnessVisible (frame.probe state)

theorem nondisturbing_probe_reveals_preexisting_obstruction
    {frame : ProbeFrame}
    {state : frame.State}
    (latent : frame.obstruction state)
    (preserves : NondisturbingAt frame state)
    (covers : CoversWitnessAt frame state) :
    RevealedAt frame state := by
  change frame.probe state = state at preserves
  constructor
  · rw [preserves]
    exact latent
  · exact covers

theorem obstruction_revealed_by_nondisturbing_probe_was_preexisting
    {frame : ProbeFrame}
    {state : frame.State}
    (preserves : NondisturbingAt frame state)
    (revealed : RevealedAt frame state) :
    frame.obstruction state := by
  change frame.probe state = state at preserves
  rcases revealed with ⟨postProbe, visible⟩
  rw [preserves] at postProbe
  exact postProbe

inductive ProbeState where
  | coherent
  | obstructed
  deriving DecidableEq

def CreatingProbeFrame : ProbeFrame where
  State := ProbeState
  probe := fun _ => .obstructed
  obstruction := fun state => state = .obstructed
  witnessVisible := fun state => state = .obstructed

theorem disturbing_probe_can_create_a_revealed_obstruction :
    RevealedAt CreatingProbeFrame .coherent := by
  constructor <;> rfl

theorem creating_probe_has_no_preexisting_obstruction :
    Not (CreatingProbeFrame.obstruction .coherent) := by
  intro impossible
  cases impossible

theorem creating_probe_is_not_nondisturbing :
    Not (NondisturbingAt CreatingProbeFrame .coherent) := by
  intro impossible
  cases impossible

/-! ## Physics boundary: classical mixture versus coherent context -/

abbrev DensityKernel
    (Context : Type uContext)
    (Scalar : Type uScalar) : Type _ :=
  Context -> Context -> Scalar

structure QuantumScalarSignature (Scalar : Type uScalar) where
  zero : Scalar
  mul : Scalar -> Scalar -> Scalar
  conj : Scalar -> Scalar
  mul_ne_zero : forall {left right : Scalar},
    left ≠ zero -> right ≠ zero -> mul left right ≠ zero
  conj_ne_zero : forall {value : Scalar},
    value ≠ zero -> conj value ≠ zero

def ClassicalContextKernel
    (scalar : QuantumScalarSignature Scalar)
    (density : DensityKernel Context Scalar) : Prop :=
  forall {left right : Context},
    left ≠ right -> density left right = scalar.zero

def CoherenceWitness
    (scalar : QuantumScalarSignature Scalar)
    (density : DensityKernel Context Scalar) : Prop :=
  exists left right : Context,
    left ≠ right /\ density left right ≠ scalar.zero

def classicalMixtureKernel
    [DecidableEq Context]
    (scalar : QuantumScalarSignature Scalar)
    (weight : Context -> Scalar) : DensityKernel Context Scalar :=
  fun left right =>
    if left = right then weight left else scalar.zero

def pureContextKernel
    (scalar : QuantumScalarSignature Scalar)
    (amplitude : Context -> Scalar) : DensityKernel Context Scalar :=
  fun left right =>
    scalar.mul (amplitude left) (scalar.conj (amplitude right))

theorem classical_mixture_kernel_is_diagonal
    [DecidableEq Context]
    (scalar : QuantumScalarSignature Scalar)
    (weight : Context -> Scalar) :
    ClassicalContextKernel scalar
      (classicalMixtureKernel scalar weight) := by
  intro left right different
  exact if_neg different

theorem classical_context_has_no_coherence_witness
    {scalar : QuantumScalarSignature Scalar}
    {density : DensityKernel Context Scalar}
    (classical : ClassicalContextKernel scalar density) :
    Not (CoherenceWitness scalar density) := by
  intro coherent
  rcases coherent with ⟨left, right, different, offDiagonal⟩
  exact offDiagonal (classical different)

theorem pure_context_has_coherence_from_two_supported_indices
    {scalar : QuantumScalarSignature Scalar}
    {amplitude : Context -> Scalar}
    {left right : Context}
    (different : left ≠ right)
    (leftSupported : amplitude left ≠ scalar.zero)
    (rightSupported : amplitude right ≠ scalar.zero) :
    CoherenceWitness scalar (pureContextKernel scalar amplitude) := by
  refine ⟨left, right, different, ?_⟩
  exact scalar.mul_ne_zero
    leftSupported
    (scalar.conj_ne_zero rightSupported)

theorem unknown_classical_context_is_not_quantum_coherence
    [DecidableEq Context]
    (scalar : QuantumScalarSignature Scalar)
    (weight : Context -> Scalar) :
    Not (CoherenceWitness scalar
      (classicalMixtureKernel scalar weight)) := by
  exact classical_context_has_no_coherence_witness
    (classical_mixture_kernel_is_diagonal scalar weight)

end ContextualInterface
end InterfaceMathematics
end TMI
