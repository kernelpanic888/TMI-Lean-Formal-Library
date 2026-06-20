/-
QC branch placeholder for TMI-Lean Formal Library 0.1.

QC is reserved for quantum-computation-oriented interface-event work.
-/

namespace TMI
namespace Branches
namespace QC

def branchCode : String := "QC"

def branchName : String :=
  "Quantum Computation"

def branchIsGuarded : Prop := True

theorem qc_branch_is_guarded : branchIsGuarded := by
  trivial

end QC
end Branches
end TMI
