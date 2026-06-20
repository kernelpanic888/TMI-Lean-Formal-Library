/-
MD branch placeholder for TMI-Lean Formal Library 0.1.

MD is reserved for measurement/decoherence-oriented interface-event work.
-/

import TMI.InterfaceMathematics.MeasurementDecoherence

namespace TMI
namespace Branches
namespace MD

def branchCode : String := "MD"

def branchName : String :=
  "Measurement / Decoherence"

def branchIsGuarded : Prop := True

theorem md_branch_is_guarded : branchIsGuarded := by
  trivial

end MD
end Branches
end TMI
