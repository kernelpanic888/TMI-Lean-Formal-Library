import TMI.InterfaceFoundations.QuantumComparisonBoundary
import TMI.InterfaceFoundations.RelativeTemporalInterfaceAudit

/-!
# Quantum comparison boundary: finite audit

The finite witnesses distinguish a wholly preserving branch family from a
mixed family in which a reversing branch is supplied explicitly. They are
logical audit objects, not quantum states or physical spacetime models.
-/

namespace TMI.InterfaceFoundations.QuantumComparisonBoundaryAudit

open TMI.InterfaceFoundations.RelativeTemporalInterface
open TMI.InterfaceFoundations.RelativeTemporalInterfaceAudit
open TMI.InterfaceFoundations.QuantumComparisonBoundary

inductive Branch
  | first
  | second
deriving DecidableEq

def preservingCandidate :
    QuantumComparisonCandidate language Nat Event.q Event.p where
  Branch := Branch
  amplitude := fun branch =>
    match branch with
    | .first => 1
    | .second => 2
  active := fun _ => True
  comparison := fun _ => preservingComparison .q .p

theorem preserving_candidate_all_active_branches_preserve_future :
    AllActiveBranchesPreserveFuture language preservingCandidate := by
  intro branch active
  exact preserving_reads_future_as_future .q .p

theorem preserving_candidate_has_no_reversing_branch :
    Not (HasReversingBranch language preservingCandidate) := by
  exact all_active_branches_preserving_excludes_reversal language
    preservingCandidate
    ⟨Direction.future, rfl⟩
    preserving_candidate_all_active_branches_preserve_future

def mixedCandidate :
    QuantumComparisonCandidate language Nat Event.q Event.p where
  Branch := Branch
  amplitude := fun _ => 1
  active := fun _ => True
  comparison := fun branch =>
    match branch with
    | .first => preservingComparison .q .p
    | .second => reversingComparison .q .p

theorem mixed_candidate_reversal_is_explicit_branch_data :
    HasReversingBranch language mixedCandidate := by
  refine ⟨.second, trivial, ?_⟩
  exact reversing_reads_future_as_past .q .p

#print axioms all_active_branches_preserving_excludes_reversal
#print axioms preserving_candidate_is_not_quantum_time_machine
#print axioms preserving_candidate_has_no_reversing_branch
#print axioms mixed_candidate_reversal_is_explicit_branch_data

end TMI.InterfaceFoundations.QuantumComparisonBoundaryAudit
