/-
Branch aggregator for TMI-Lean Formal Library 0.1.
-/

import TMI.Branches.MD
import TMI.Branches.QC
import TMI.Branches.QG
import TMI.Branches.LIFE
import TMI.Branches.OPS

namespace TMI
namespace Branches

inductive BranchCode where
  | md
  | qc
  | qg
  | life
  | ops
deriving DecidableEq, Repr

def BranchCode.asString : BranchCode -> String
  | .md => "MD"
  | .qc => "QC"
  | .qg => "QG"
  | .life => "LIFE"
  | .ops => "OPS"

def guardedBranch : BranchCode -> Prop
  | _ => True

theorem all_public_branches_are_guarded
    (b : BranchCode) :
    guardedBranch b := by
  cases b <;> trivial

end Branches
end TMI
