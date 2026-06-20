/-
Formula-as-Pure-Interface semantic model layer for TMI-Core-Proof 0.2-A7.

This module mirrors the FormulaInterface signature in a model-indexed form and
keeps QF bridge reconstruction one-way.
-/

import TMI.FormulaInterface.Contracts

namespace TMI
namespace FormulaInterface

open Core

structure FormulaSemanticModel where
  ObjT : Type
  FormulaT : Type
  RecordT : Type
  CarrierT : Type
  BridgeTargetT : Type
  formulaObj : FormulaT -> ObjT
  recordObj : RecordT -> ObjT
  carrierObj : CarrierT -> ObjT
  recOf : FormulaT -> RecordT
  carrierOfRecord : RecordT -> CarrierT
  pureInterfaceObj : ObjT -> Prop
  mdTarget : BridgeTargetT
  bridgeTyped : FormulaT -> BridgeTargetT -> Prop
  bridgeCandidateFormula : FormulaT -> Prop
  coreAdmissibleBridge : FormulaT -> Prop

namespace FormulaSemanticModel

def FormulaValidityComponentsIn (M : FormulaSemanticModel) (f : M.FormulaT) : Prop :=
  M.pureInterfaceObj (M.formulaObj f)
  ∧ ¬ M.pureInterfaceObj (M.recordObj (M.recOf f))
  ∧ ¬ M.pureInterfaceObj (M.carrierObj (M.carrierOfRecord (M.recOf f)))
  ∧ M.formulaObj f ≠ M.recordObj (M.recOf f)
  ∧ M.recordObj (M.recOf f) ≠ M.carrierObj (M.carrierOfRecord (M.recOf f))

def ValidFormulaIn (M : FormulaSemanticModel) (f : M.FormulaT) : Prop :=
  M.FormulaValidityComponentsIn f

theorem FormulaValidityComponentsIn_intro :
    ∀ (M : FormulaSemanticModel) (f : M.FormulaT),
      M.pureInterfaceObj (M.formulaObj f) →
      ¬ M.pureInterfaceObj (M.recordObj (M.recOf f)) →
      ¬ M.pureInterfaceObj (M.carrierObj (M.carrierOfRecord (M.recOf f))) →
      M.formulaObj f ≠ M.recordObj (M.recOf f) →
      M.recordObj (M.recOf f) ≠ M.carrierObj (M.carrierOfRecord (M.recOf f)) →
      M.FormulaValidityComponentsIn f := by
  intro M f hpure hnotRecord hnotCarrier hneqRecord hneqCarrier
  exact ⟨hpure, hnotRecord, hnotCarrier, hneqRecord, hneqCarrier⟩

theorem FormulaValidityComponentsIn_has_formula_interface :
    ∀ (M : FormulaSemanticModel) (f : M.FormulaT),
      M.FormulaValidityComponentsIn f → M.pureInterfaceObj (M.formulaObj f) := by
  intro M f h
  exact h.left

theorem FormulaValidityComponentsIn_record_not_interface :
    ∀ (M : FormulaSemanticModel) (f : M.FormulaT),
      M.FormulaValidityComponentsIn f → ¬ M.pureInterfaceObj (M.recordObj (M.recOf f)) := by
  intro M f h
  exact h.right.left

theorem FormulaValidityComponentsIn_carrier_not_interface :
    ∀ (M : FormulaSemanticModel) (f : M.FormulaT),
      M.FormulaValidityComponentsIn f →
        ¬ M.pureInterfaceObj (M.carrierObj (M.carrierOfRecord (M.recOf f))) := by
  intro M f h
  exact h.right.right.left

theorem FormulaValidityComponentsIn_formula_record_distinct :
    ∀ (M : FormulaSemanticModel) (f : M.FormulaT),
      M.FormulaValidityComponentsIn f → M.formulaObj f ≠ M.recordObj (M.recOf f) := by
  intro M f h
  exact h.right.right.right.left

theorem FormulaValidityComponentsIn_record_carrier_distinct :
    ∀ (M : FormulaSemanticModel) (f : M.FormulaT),
      M.FormulaValidityComponentsIn f →
        M.recordObj (M.recOf f) ≠ M.carrierObj (M.carrierOfRecord (M.recOf f)) := by
  intro M f h
  exact h.right.right.right.right

theorem FormulaValidityComponentsIn_interface_outputs :
    ∀ (M : FormulaSemanticModel) (f : M.FormulaT),
      M.FormulaValidityComponentsIn f →
        M.pureInterfaceObj (M.formulaObj f)
        ∧ ¬ M.pureInterfaceObj (M.recordObj (M.recOf f))
        ∧ ¬ M.pureInterfaceObj (M.carrierObj (M.carrierOfRecord (M.recOf f))) := by
  intro M f h
  exact ⟨
    M.FormulaValidityComponentsIn_has_formula_interface f h,
    M.FormulaValidityComponentsIn_record_not_interface f h,
    M.FormulaValidityComponentsIn_carrier_not_interface f h
  ⟩

def QFBridgeComponentsIn (M : FormulaSemanticModel) (f : M.FormulaT) : Prop :=
  M.bridgeCandidateFormula f ∧ M.coreAdmissibleBridge f

def QFBridgeSemanticInputIn (M : FormulaSemanticModel) (f : M.FormulaT) : Prop :=
  M.ValidFormulaIn f ∧ M.bridgeTyped f M.mdTarget

def QFBridgeInputIn (M : FormulaSemanticModel) (f : M.FormulaT) : Prop :=
  M.QFBridgeSemanticInputIn f

theorem QFBridgeInputIn_intro : ∀ (M : FormulaSemanticModel) (f : M.FormulaT),
    M.ValidFormulaIn f → M.bridgeTyped f M.mdTarget → M.QFBridgeInputIn f := by
  intro M f hv hb
  exact ⟨hv, hb⟩

theorem QFBridgeInputIn_has_valid_formula : ∀ (M : FormulaSemanticModel) (f : M.FormulaT),
    M.QFBridgeInputIn f → M.ValidFormulaIn f := by
  intro M f h
  exact h.left

theorem QFBridgeInputIn_has_bridge_typing : ∀ (M : FormulaSemanticModel) (f : M.FormulaT),
    M.QFBridgeInputIn f → M.bridgeTyped f M.mdTarget := by
  intro M f h
  exact h.right

def QFBridgeCandidateObligationIn (M : FormulaSemanticModel) : Prop :=
  ∀ f : M.FormulaT, M.QFBridgeInputIn f → M.bridgeCandidateFormula f

def QFBridgeAdmissibilityObligationIn (M : FormulaSemanticModel) : Prop :=
  ∀ f : M.FormulaT, M.QFBridgeInputIn f → M.coreAdmissibleBridge f

theorem QFBridgeCandidateObligationIn_apply : ∀ (M : FormulaSemanticModel) (f : M.FormulaT),
    M.QFBridgeCandidateObligationIn → M.QFBridgeInputIn f → M.bridgeCandidateFormula f := by
  intro M f hobligation hinput
  exact hobligation f hinput

theorem QFBridgeAdmissibilityObligationIn_apply : ∀ (M : FormulaSemanticModel) (f : M.FormulaT),
    M.QFBridgeAdmissibilityObligationIn → M.QFBridgeInputIn f → M.coreAdmissibleBridge f := by
  intro M f hobligation hinput
  exact hobligation f hinput

structure FormulaSemanticTheory (M : FormulaSemanticModel) where
  qfBridgeCandidate : M.QFBridgeCandidateObligationIn
  qfBridgeAdmissibility : M.QFBridgeAdmissibilityObligationIn

theorem FormulaSemanticTheory_qf_bridge_candidate :
    ∀ (M : FormulaSemanticModel) (_ : M.FormulaSemanticTheory) (f : M.FormulaT),
      M.QFBridgeInputIn f → M.bridgeCandidateFormula f := by
  intro M T f hinput
  exact M.QFBridgeCandidateObligationIn_apply f T.qfBridgeCandidate hinput

theorem FormulaSemanticTheory_qf_bridge_admissible :
    ∀ (M : FormulaSemanticModel) (_ : M.FormulaSemanticTheory) (f : M.FormulaT),
      M.QFBridgeInputIn f → M.coreAdmissibleBridge f := by
  intro M T f hinput
  exact M.QFBridgeAdmissibilityObligationIn_apply f T.qfBridgeAdmissibility hinput

theorem FormulaSemanticTheory_qf_bridge_components :
    ∀ (M : FormulaSemanticModel) (_ : M.FormulaSemanticTheory) (f : M.FormulaT),
      M.QFBridgeInputIn f → M.QFBridgeComponentsIn f := by
  intro M T f hinput
  exact ⟨
    M.FormulaSemanticTheory_qf_bridge_candidate T f hinput,
    M.FormulaSemanticTheory_qf_bridge_admissible T f hinput
  ⟩

def BridgeCandidateImpliesQFBridgeInputIn (M : FormulaSemanticModel) : Prop :=
  ∀ f : M.FormulaT, M.bridgeCandidateFormula f → M.QFBridgeInputIn f

def CoreAdmissibleBridgeImpliesQFBridgeInputIn (M : FormulaSemanticModel) : Prop :=
  ∀ f : M.FormulaT, M.coreAdmissibleBridge f → M.QFBridgeInputIn f

def QFBridgeComponentsImpliesQFBridgeInputIn (M : FormulaSemanticModel) : Prop :=
  ∀ f : M.FormulaT, M.QFBridgeComponentsIn f → M.QFBridgeInputIn f

noncomputable def AxiomShellFormulaModel : FormulaSemanticModel where
  ObjT := Obj
  FormulaT := Formula
  RecordT := Record
  CarrierT := Carrier
  BridgeTargetT := BridgeTarget
  formulaObj := FormulaObj
  recordObj := RecordObj
  carrierObj := CarrierObj
  recOf := RecOf
  carrierOfRecord := CarrierOfRecord
  pureInterfaceObj := PureInterfaceObj
  mdTarget := FormulaInterface.mdTarget
  bridgeTyped := BridgeTyped
  bridgeCandidateFormula := BridgeCandidateFormula
  coreAdmissibleBridge := CoreAdmissibleBridge

noncomputable def AxiomShellFormulaTheory : AxiomShellFormulaModel.FormulaSemanticTheory where
  qfBridgeCandidate := by
    intro f hinput
    exact QFBridgeSemanticInput_candidate_obligation f hinput.left hinput.right
  qfBridgeAdmissibility := by
    intro f hinput
    exact QFBridgeSemanticInput_admissibility_obligation f hinput.left hinput.right

theorem AxiomShellFormulaTheory_validity_components_outputs : ∀ f : Formula,
    ValidFormula f → FormulaValidityComponents f := by
  intro f hv
  exact (FormulaValidity_iff_components f).mp hv

theorem AxiomShellFormulaTheory_validity_interface_outputs : ∀ f : Formula,
    ValidFormula f →
      PureInterfaceObj (FormulaObj f)
      ∧ ¬ PureInterfaceObj (RecordObj (RecOf f))
      ∧ ¬ PureInterfaceObj (CarrierObj (CarrierOfRecord (RecOf f))) := by
  intro f hv
  exact FormulaSemanticModel.FormulaValidityComponentsIn_interface_outputs
    AxiomShellFormulaModel
    f
    (AxiomShellFormulaTheory_validity_components_outputs f hv)

theorem AxiomShellFormulaTheory_qf_bridge_candidate : ∀ f : Formula,
    AxiomShellFormulaModel.QFBridgeInputIn f → BridgeCandidateFormula f := by
  intro f hinput
  exact FormulaSemanticModel.FormulaSemanticTheory_qf_bridge_candidate
    AxiomShellFormulaModel
    AxiomShellFormulaTheory
    f
    hinput

theorem AxiomShellFormulaTheory_qf_bridge_admissible : ∀ f : Formula,
    AxiomShellFormulaModel.QFBridgeInputIn f → CoreAdmissibleBridge f := by
  intro f hinput
  exact FormulaSemanticModel.FormulaSemanticTheory_qf_bridge_admissible
    AxiomShellFormulaModel
    AxiomShellFormulaTheory
    f
    hinput

theorem AxiomShellFormulaTheory_qf_bridge_admissibility_output : ∀ f : Formula,
    ValidFormula f → BridgeTyped f FormulaInterface.mdTarget → CoreAdmissibleBridge f := by
  intro f hv hb
  exact AxiomShellFormulaTheory_qf_bridge_admissible
    f
    (QFBridgeInputIn_intro
      AxiomShellFormulaModel
      f
      (AxiomShellFormulaTheory_validity_components_outputs f hv)
      hb)

theorem AxiomShellFormulaTheory_qf_bridge_components : ∀ f : Formula,
    AxiomShellFormulaModel.QFBridgeInputIn f → QFBridgeComponents f := by
  intro f hinput
  exact FormulaSemanticModel.FormulaSemanticTheory_qf_bridge_components
    AxiomShellFormulaModel
    AxiomShellFormulaTheory
    f
    hinput

end FormulaSemanticModel

end FormulaInterface
end TMI
