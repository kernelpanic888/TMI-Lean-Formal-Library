/-
TMI-Core-Proof 0.2-A7 Lean derived closure layer.

Primitive assumptions are isolated in `TMI.Core.Contracts` and
`TMI.Core.NonInflation`. This module derives closure and component-elimination
rules from those contract assumptions.
-/

import TMI.Core.Semantics

namespace TMI
namespace Core

theorem ValidInt_elim : ∀ x : Obj, ValidInt x → ValidIntComponents x := by
  intro x h
  exact (ValidInt_iff_components x).mp h

theorem AxiomShellTheory_valid_int_components_outputs : ∀ x : Obj,
    ValidInt x → ValidIntComponents x := by
  intro x h
  exact ValidInt_elim x h

theorem AxiomShellTheory_valid_int_dyn_nonstatic_outputs : ∀ x : Obj,
    ValidInt x → Dyn x ∧ NonStatic x := by
  intro x h
  have hc : ValidIntComponents x :=
    AxiomShellTheory_valid_int_components_outputs x h
  exact CoreSemanticModel.ValidIntComponentsIn_dyn_nonstatic_outputs
    AxiomShellModel
    x
    hc

theorem AxiomShellTheory_valid_int_causal_frame_output : ∀ x : Obj,
    ValidInt x → CausalFrame x := by
  intro x h
  have hc : ValidIntComponents x :=
    AxiomShellTheory_valid_int_components_outputs x h
  exact CoreSemanticModel.ValidIntComponentsIn_causal_frame_output
    AxiomShellModel
    x
    hc

theorem AxiomShellTheory_valid_int_integrated_output : ∀ x : Obj,
    ValidInt x → Integrated x := by
  intro x h
  have hc : ValidIntComponents x :=
    AxiomShellTheory_valid_int_components_outputs x h
  exact CoreSemanticModel.ValidIntComponentsIn_integrated_output
    AxiomShellModel
    x
    hc

theorem AxiomShellTheory_valid_int_structural_link_output : ∀ x : Obj,
    ValidInt x →
      ∃ s : Structure, PreInterfaceStructure s ∧ InStructure x s ∧ StructurallyLinked x s := by
  intro x h
  have hc : ValidIntComponents x :=
    AxiomShellTheory_valid_int_components_outputs x h
  exact CoreSemanticModel.ValidIntComponentsIn_structural_link_output
    AxiomShellModel
    x
    hc

theorem ValidInt_intro : ∀ x : Obj, ValidIntComponents x → ValidInt x := by
  intro x h
  exact (ValidInt_iff_components x).mpr h

theorem A7_intro : ∀ x : Obj, PreIspace x → ValidInt x → Ispace x := by
  intro x hp hv
  have hcomponents : AxiomShellModel.ValidIntComponentsIn x := ValidInt_elim x hv
  have hinput : AxiomShellModel.InterfaceClosureInputIn x :=
    CoreSemanticModel.InterfaceClosureInputIn_intro AxiomShellModel x hp hcomponents
  exact (AxiomShellTheory_interface_closure_outputs x hinput).left

theorem A7_soundness : ∀ x : Obj, Ispace x → PreIspace x ∧ ValidInt x := by
  intro x h
  have hcomponents : PreIspace x ∧ ValidIntComponents x :=
    AxiomShellTheory_interface_closure_soundness_components x h
  exact ⟨
    hcomponents.left,
    ValidInt_intro x hcomponents.right
  ⟩

theorem AxiomShellFullCore_typed_role_valid_int : ∀ x : Obj,
    TypedAs x roleInterface → PreIspace x ∧ ValidInt x := by
  intro x htyped
  have hrole : AxiomShellModel.InterfaceRoleTypingIn x :=
    CoreSemanticModel.InterfaceRoleTypingIn_intro AxiomShellModel x htyped
  have hispace : Ispace x :=
    AxiomShellFullCoreSemanticTheory_role_soundness x hrole
  have hcomponents : PreIspace x ∧ ValidIntComponents x :=
    AxiomShellFullCoreSemanticTheory_interface_closure_soundness_components x hispace
  exact ⟨
    hcomponents.left,
    ValidInt_intro x hcomponents.right
  ⟩

theorem AxiomShellFullCore_interface_role_and_valid_int : ∀ x : Obj,
    Ispace x → TypedAs x roleInterface ∧ PreIspace x ∧ ValidInt x := by
  intro x hispace
  have hrole : AxiomShellModel.InterfaceRoleTypingIn x :=
    AxiomShellFullCoreSemanticTheory_role_completeness x hispace
  have hcomponents : PreIspace x ∧ ValidIntComponents x :=
    AxiomShellFullCoreSemanticTheory_interface_closure_soundness_components x hispace
  exact ⟨
    CoreSemanticModel.InterfaceRoleTypingIn_has_role_typing AxiomShellModel x hrole,
    hcomponents.left,
    ValidInt_intro x hcomponents.right
  ⟩

theorem A4_interface_dyn_nonstatic : ∀ x : Obj, Ispace x → Dyn x ∧ NonStatic x := by
  intro x h
  have hv : ValidInt x := (A7_soundness x h).right
  exact AxiomShellTheory_valid_int_dyn_nonstatic_outputs x hv

theorem A9_causal_frame : ∀ x : Obj, Ispace x → CausalFrame x := by
  intro x h
  have hv : ValidInt x := (A7_soundness x h).right
  exact AxiomShellTheory_valid_int_causal_frame_output x hv

theorem A10_integrated : ∀ x : Obj, Ispace x → Integrated x := by
  intro x h
  have hv : ValidInt x := (A7_soundness x h).right
  exact AxiomShellTheory_valid_int_integrated_output x hv

theorem A11_structural_non_isolation : ∀ x : Obj, Ispace x → ∃ s : Structure, PreInterfaceStructure s ∧ InStructure x s ∧ StructurallyLinked x s := by
  intro x h
  have hv : ValidInt x := (A7_soundness x h).right
  exact AxiomShellTheory_valid_int_structural_link_output x hv

theorem PIC_typed_domain_closure : ∀ x : Obj, DomTMI x → Meaningful x → PICTypedDomain x := by
  intro x hd hm
  exact ⟨hd, hm⟩

theorem PIC_T : ∀ x : Obj, DomTMI x → Meaningful x → TypedInInterfaceDomain x := by
  intro x hd hm
  have hinput : AxiomShellModel.PICTypedDomainIn x :=
    CoreSemanticModel.PICTypedDomainIn_intro AxiomShellModel x hd hm
  exact AxiomShellTheory_pic_domain_meaning_typing x hinput

theorem PIPath_from_derivation : ∀ x : Obj, Der x primaryI0 → Meaningful x → PIPath x := by
  intro x hd hm
  exact ⟨hm, PI_meaning_distinguishable x hm, hd⟩

theorem PI_derivation_from_meaning : ∀ x : Obj, Meaningful x → Der x primaryI0 := by
  intro x hm
  exact PI_distinguishable_der x (PI_meaning_distinguishable x hm)

theorem PIPath_from_meaning : ∀ x : Obj, Meaningful x → PIPath x := by
  intro x hm
  exact ⟨hm, PI_meaning_distinguishable x hm, PI_derivation_from_meaning x hm⟩

theorem PI_derivation_domain : ∀ x : Obj, Der x primaryI0 → Meaningful x → DomTMI x := by
  intro x hd hm
  have hpath : AxiomShellModel.PIPathCoreIn x :=
    CoreSemanticModel.PIPathCoreIn_intro AxiomShellModel x hm (PI_meaning_distinguishable x hm) hd
  exact AxiomShellTheory_pi_path_domain_closure x hpath

theorem PIC_from_PI : ∀ x : Obj, Der x primaryI0 → Meaningful x → TypedInInterfaceDomain x := by
  intro x hd hm
  have hpath : AxiomShellModel.PIPathCoreIn x :=
    CoreSemanticModel.PIPathCoreIn_intro AxiomShellModel x hm (PI_meaning_distinguishable x hm) hd
  exact AxiomShellTheory_pi_path_pic_typing x hpath

end Core
end TMI
