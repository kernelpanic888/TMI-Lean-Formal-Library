/-
Formula-as-Pure-Interface contracts for TMI-Core-Proof 0.2-A7.

This module keeps formula validity definitional and isolates the remaining
one-way QF bridge obligations. Derived wrappers live in
`TMI.FormulaInterface.Axioms`.
-/

import TMI.FormulaInterface.Signature

namespace TMI
namespace FormulaInterface

def FormulaValidityComponents (f : Formula) : Prop :=
  PureInterfaceObj (FormulaObj f)
  ∧ ¬ PureInterfaceObj (RecordObj (RecOf f))
  ∧ ¬ PureInterfaceObj (CarrierObj (CarrierOfRecord (RecOf f)))
  ∧ FormulaObj f ≠ RecordObj (RecOf f)
  ∧ RecordObj (RecOf f) ≠ CarrierObj (CarrierOfRecord (RecOf f))

def ValidFormula (f : Formula) : Prop :=
  FormulaValidityComponents f

theorem FormulaValidity_iff_components : ∀ f : Formula, ValidFormula f ↔ FormulaValidityComponents f := by
  intro f
  rfl

def QFBridgeComponents (f : Formula) : Prop :=
  BridgeCandidateFormula f ∧ CoreAdmissibleBridge f

def QFBridgeSemanticInput (f : Formula) : Prop :=
  ValidFormula f ∧ BridgeTyped f mdTarget

def QFBridgeInput (f : Formula) : Prop :=
  QFBridgeSemanticInput f

theorem QFBridgeInput_iff_semantic_input : ∀ f : Formula,
    QFBridgeInput f ↔ QFBridgeSemanticInput f := by
  intro f
  rfl

theorem QFBridgeInput_has_valid_formula : ∀ f : Formula,
    QFBridgeInput f → ValidFormula f := by
  intro f h
  exact h.left

theorem QFBridgeInput_has_bridge_typing : ∀ f : Formula,
    QFBridgeInput f → BridgeTyped f mdTarget := by
  intro f h
  exact h.right

axiom QFBridgeSemanticInput_candidate_obligation : ∀ f : Formula,
  ValidFormula f → BridgeTyped f mdTarget → BridgeCandidateFormula f

axiom QFBridgeSemanticInput_admissibility_obligation : ∀ f : Formula,
  ValidFormula f → BridgeTyped f mdTarget → CoreAdmissibleBridge f

theorem QFBridge_candidate_obligation : ∀ f : Formula,
    QFBridgeInput f → BridgeCandidateFormula f := by
  intro f h
  exact QFBridgeSemanticInput_candidate_obligation
    f
    (QFBridgeInput_has_valid_formula f h)
    (QFBridgeInput_has_bridge_typing f h)

theorem QFBridge_admissibility_obligation : ∀ f : Formula,
    QFBridgeInput f → CoreAdmissibleBridge f := by
  intro f h
  exact QFBridgeSemanticInput_admissibility_obligation
    f
    (QFBridgeInput_has_valid_formula f h)
    (QFBridgeInput_has_bridge_typing f h)

theorem QFBridge_input_components : ∀ f : Formula, QFBridgeInput f → QFBridgeComponents f := by
  intro f hqf
  exact ⟨
    QFBridge_candidate_obligation f hqf,
    QFBridge_admissibility_obligation f hqf
  ⟩

end FormulaInterface
end TMI
