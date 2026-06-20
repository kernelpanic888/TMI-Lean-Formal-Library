/-
QG branch placeholder for TMI-Lean Formal Library 0.1.

QG is reserved for quantum-gravity-oriented interface-event work.
-/

namespace TMI
namespace Branches
namespace QG

def branchCode : String := "QG"

def branchName : String :=
  "Quantum Gravity"

def branchIsGuarded : Prop := True

theorem qg_branch_is_guarded : branchIsGuarded := by
  trivial

end QG
end Branches
end TMI
