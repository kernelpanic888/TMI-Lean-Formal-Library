import TMI.InterfaceFoundations.RelativeTemporalInterface

/-!
# Quantum comparison boundary

This module adds only the minimum typed surface needed to state the quantum
question raised by RTI-01. A candidate consists of labeled branches,
amplitude data left completely abstract, an activity predicate, and one
event-local comparison map per branch.

The name `QuantumComparisonCandidate` is intentionally conditional. No
Hilbert space, normalization law, interference rule, unitary evolution,
measurement model, Lorentzian metric, or physical realization is derived.
The checked result is a no-smuggling boundary: a family whose every active
branch preserves the future sector cannot count as having a reversing branch.
-/

universe x y z d a b

namespace TMI.InterfaceFoundations.QuantumComparisonBoundary

open TMI.InterfaceFoundations.RelativeTemporalInterface

variable (L : Language)

/-- A deliberately weak carrier for the open quantum hypothesis. Amplitudes
and active branches are recorded, but no quantum dynamics is postulated. -/
structure QuantumComparisonCandidate
    (Amplitude : Type a)
    (source target : L.Event) where
  Branch : Type b
  amplitude : Branch -> Amplitude
  active : Branch -> Prop
  comparison : Branch -> Comparison L source target

/-- One active branch preserves every source-future direction. -/
def ActiveBranchPreservesFuture
    {Amplitude : Type a}
    {source target : L.Event}
    (candidate : QuantumComparisonCandidate L Amplitude source target)
    (branch : candidate.Branch) : Prop :=
  candidate.active branch /\
    FutureReadsAsFuture L (candidate.comparison branch)

/-- Every branch that participates in the candidate preserves future. -/
def AllActiveBranchesPreserveFuture
    {Amplitude : Type a}
    {source target : L.Event}
    (candidate : QuantumComparisonCandidate L Amplitude source target) : Prop :=
  forall branch : candidate.Branch,
    candidate.active branch ->
      FutureReadsAsFuture L (candidate.comparison branch)

/-- One active branch explicitly reads source future as target past. -/
def ActiveBranchReadsFutureAsPast
    {Amplitude : Type a}
    {source target : L.Event}
    (candidate : QuantumComparisonCandidate L Amplitude source target)
    (branch : candidate.Branch) : Prop :=
  candidate.active branch /\
    FutureReadsAsPast L (candidate.comparison branch)

/-- The minimal logical content of the proposed reversal-bearing quantum
candidate: at least one active branch carries explicit reversal data. -/
def HasReversingBranch
    {Amplitude : Type a}
    {source target : L.Event}
    (candidate : QuantumComparisonCandidate L Amplitude source target) : Prop :=
  exists branch : candidate.Branch,
    ActiveBranchReadsFutureAsPast L candidate branch

/-- The article's quantum-time-machine phrase is represented only as an open
hypothesis on a supplied candidate, never as a derived physical conclusion. -/
def QuantumTimeMachineHypothesis
    {Amplitude : Type a}
    {source target : L.Event}
    (candidate : QuantumComparisonCandidate L Amplitude source target) : Prop :=
  HasReversingBranch L candidate

/-- No-smuggling theorem: branch labels or abstract amplitudes cannot turn a
wholly future-preserving family into a reversal-bearing candidate. -/
theorem all_active_branches_preserving_excludes_reversal
    {Amplitude : Type a}
    {source target : L.Event}
    (candidate : QuantumComparisonCandidate L Amplitude source target)
    (sourceHasFuture : exists direction : L.Direction source, L.future direction)
    (preserved : AllActiveBranchesPreserveFuture L candidate) :
    Not (HasReversingBranch L candidate) := by
  intro hasReversal
  rcases hasReversal with ⟨branch, active, reversed⟩
  exact future_reading_cannot_be_both L
    (candidate.comparison branch)
    sourceHasFuture
    (preserved branch active)
    reversed

/-- The same boundary stated in the article's intentionally provocative
vocabulary. -/
theorem preserving_candidate_is_not_quantum_time_machine
    {Amplitude : Type a}
    {source target : L.Event}
    (candidate : QuantumComparisonCandidate L Amplitude source target)
    (sourceHasFuture : exists direction : L.Direction source, L.future direction)
    (preserved : AllActiveBranchesPreserveFuture L candidate) :
    Not (QuantumTimeMachineHypothesis L candidate) :=
  all_active_branches_preserving_excludes_reversal L
    candidate sourceHasFuture preserved

end TMI.InterfaceFoundations.QuantumComparisonBoundary
