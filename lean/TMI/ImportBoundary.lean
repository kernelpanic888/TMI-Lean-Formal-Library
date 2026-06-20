/-
Lean import-boundary discipline for TMI-Core-Proof 0.2-A7.

This module mirrors the accepted rule from `TMI_IMPORT_BOUNDARY_MAP_0_2.md`:
Core may be imported by outer layers, but Core must not import Branch, Bridge,
AppliedMode, or ExperimentalBridge as axioms.
-/

namespace TMI
namespace ImportBoundary

inductive Layer where
  | core
  | branch
  | bridge
  | appliedMode
  | experimentalBridge
deriving DecidableEq, Repr

open Layer

def CanImport : Layer → Layer → Prop
  | core, core => True
  | branch, core => True
  | branch, branch => True
  | bridge, core => True
  | bridge, branch => True
  | bridge, bridge => True
  | appliedMode, core => True
  | appliedMode, branch => True
  | appliedMode, bridge => True
  | appliedMode, appliedMode => True
  | experimentalBridge, core => True
  | experimentalBridge, branch => True
  | experimentalBridge, bridge => True
  | experimentalBridge, experimentalBridge => True
  | _, _ => False

def MayModifyCore : Layer → Prop
  | core => True
  | _ => False

theorem T_branch_may_import_core : CanImport branch core := by
  trivial

theorem T_bridge_may_import_core : CanImport bridge core := by
  trivial

theorem T_applied_mode_may_import_core : CanImport appliedMode core := by
  trivial

theorem T_experimental_bridge_may_import_core : CanImport experimentalBridge core := by
  trivial

theorem T_core_must_not_import_branch : ¬ CanImport core branch := by
  intro h
  exact h

theorem T_core_must_not_import_bridge : ¬ CanImport core bridge := by
  intro h
  exact h

theorem T_core_must_not_import_applied_mode : ¬ CanImport core appliedMode := by
  intro h
  exact h

theorem T_core_must_not_import_experimental_bridge : ¬ CanImport core experimentalBridge := by
  intro h
  exact h

theorem T_branch_cannot_modify_core : ¬ MayModifyCore branch := by
  intro h
  exact h

theorem T_bridge_cannot_modify_core : ¬ MayModifyCore bridge := by
  intro h
  exact h

theorem T_applied_mode_cannot_modify_core : ¬ MayModifyCore appliedMode := by
  intro h
  exact h

theorem T_experimental_bridge_cannot_modify_core : ¬ MayModifyCore experimentalBridge := by
  intro h
  exact h

end ImportBoundary
end TMI
