/-
Formula-as-Pure-Interface Lean theorem targets for TMI-Core-Proof 0.2-A7.
-/

import TMI.FormulaInterface.Axioms

namespace TMI
namespace FormulaInterface

theorem T_formula_is_pure_interface : ∀ f : Formula,
  ValidFormula f → PureInterfaceObj (FormulaObj f) := by
  intro f hv
  exact (FormulaSemanticModel.AxiomShellFormulaTheory_validity_interface_outputs f hv).left

theorem T_formula_record_not_pure_interface : ∀ f : Formula,
  ValidFormula f → ¬ PureInterfaceObj (RecordObj (RecOf f)) := by
  intro f hv
  exact (FormulaSemanticModel.AxiomShellFormulaTheory_validity_interface_outputs f hv).right.left

theorem T_formula_carrier_not_pure_interface : ∀ f : Formula,
  ValidFormula f → ¬ PureInterfaceObj (CarrierObj (CarrierOfRecord (RecOf f))) := by
  intro f hv
  exact (FormulaSemanticModel.AxiomShellFormulaTheory_validity_interface_outputs f hv).right.right

theorem T_formula_interface_distinction : ∀ f : Formula,
    ValidFormula f →
      PureInterfaceObj (FormulaObj f)
      ∧ ¬ PureInterfaceObj (RecordObj (RecOf f))
      ∧ ¬ PureInterfaceObj (CarrierObj (CarrierOfRecord (RecOf f))) := by
  intro f hv
  exact FormulaSemanticModel.AxiomShellFormulaTheory_validity_interface_outputs f hv

theorem T_QF_bridge_admissibility : ∀ f : Formula,
    ValidFormula f → BridgeTyped f mdTarget → CoreAdmissibleBridge f := by
  intro f hv hb
  exact FormulaSemanticModel.AxiomShellFormulaTheory_qf_bridge_admissibility_output f hv hb

end FormulaInterface
end TMI
