/-
Formula-as-Pure-Interface derived closure layer for TMI-Core-Proof 0.2-A7.
-/

import TMI.FormulaInterface.Semantics

namespace TMI
namespace FormulaInterface

theorem FormulaValidity_elim : ∀ f : Formula, ValidFormula f → FormulaValidityComponents f := by
  intro f hv
  exact (FormulaValidity_iff_components f).mp hv

theorem FormulaValidity_intro : ∀ f : Formula, FormulaValidityComponents f → ValidFormula f := by
  intro f hc
  exact (FormulaValidity_iff_components f).mpr hc

theorem FormulaValidity_components : ∀ f : Formula, ValidFormula f → FormulaValidityComponents f := by
  intro f hv
  exact FormulaSemanticModel.AxiomShellFormulaTheory_validity_components_outputs f hv

theorem formula_validity : ∀ f : Formula, ValidFormula f → FormulaValidityComponents f := by
  intro f hv
  exact FormulaValidity_components f hv

theorem QFBridgeInput_intro : ∀ f : Formula,
    ValidFormula f → BridgeTyped f mdTarget → QFBridgeInput f := by
  intro f hv hb
  exact ⟨hv, hb⟩

theorem QFBridge_candidate : ∀ f : Formula,
    ValidFormula f → BridgeTyped f mdTarget → BridgeCandidateFormula f := by
  intro f hv hb
  exact FormulaSemanticModel.AxiomShellFormulaTheory_qf_bridge_candidate
    f
    (QFBridgeInput_intro f hv hb)

theorem QFBridge_admissible : ∀ f : Formula,
    ValidFormula f → BridgeTyped f mdTarget → CoreAdmissibleBridge f := by
  intro f hv hb
  exact FormulaSemanticModel.AxiomShellFormulaTheory_qf_bridge_admissible
    f
    (QFBridgeInput_intro f hv hb)

theorem QFBridge_components : ∀ f : Formula,
    ValidFormula f → BridgeTyped f mdTarget → QFBridgeComponents f := by
  intro f hv hb
  exact FormulaSemanticModel.AxiomShellFormulaTheory_qf_bridge_components
    f
    (QFBridgeInput_intro f hv hb)

theorem qf_bridge_admissibility : ∀ f : Formula,
    ValidFormula f → BridgeTyped f mdTarget → QFBridgeComponents f := by
  intro f hv hb
  exact QFBridge_components f hv hb

end FormulaInterface
end TMI
