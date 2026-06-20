/-
TMI-Core-Proof 0.2-A7 Lean theorem targets.

This module contains the Core theorem-target mirrors compiled from the
axiom-shell skeleton.
-/

import TMI.Core.Axioms

namespace TMI
namespace Core

theorem T_ispace_preispace : ∀ x : Obj, Ispace x → PreIspace x := by
  intro x h
  exact (A7_soundness x h).left

theorem T_ispace_valid_int : ∀ x : Obj, Ispace x → ValidInt x := by
  intro x h
  exact (A7_soundness x h).right

theorem T_A1_der_gives_candidate : ∀ x : Obj, Der x primaryI0 → PreIspace x := by
  intro x h
  have hder : AxiomShellModel.PrimaryDerivationIn x :=
    CoreSemanticModel.PrimaryDerivationIn_intro AxiomShellModel x h
  exact AxiomShellTheory_primary_derivation_outputs x hder

theorem T_A3_event_changes_status : ∀ (e : Event) (x : Obj) (t : Time),
    EventAt e x t → StatusChanged x := by
  intro e x t h
  have hobs : AxiomShellModel.EventObservationIn e x t :=
    CoreSemanticModel.EventObservationIn_intro AxiomShellModel e x t h
  exact (AxiomShellTheory_event_observation_outputs e x t hobs).right

theorem T_A7_valid_interface_intro : ∀ x : Obj, PreIspace x → ValidInt x → Ispace x := by
  intro x hp hv
  have hcomponents : AxiomShellModel.ValidIntComponentsIn x := ValidInt_elim x hv
  have hinput : AxiomShellModel.InterfaceClosureInputIn x :=
    CoreSemanticModel.InterfaceClosureInputIn_intro AxiomShellModel x hp hcomponents
  exact (AxiomShellTheory_interface_closure_outputs x hinput).left

theorem T_valid_int_has_components : ∀ x : Obj,
    ValidInt x →
      ValidStr x
      ∧ Dyn x
      ∧ AutoBox x
      ∧ NonStatic x
      ∧ CausalFrame x
      ∧ Integrated x
      ∧ (∃ s : Structure, PreInterfaceStructure s ∧ InStructure x s ∧ StructurallyLinked x s)
      ∧ ¬ AbsoluteIsolation x := by
  intro x h
  exact AxiomShellTheory_valid_int_components_outputs x h

theorem T_valid_int_has_internal_automaticity : ∀ x : Obj,
    ValidInt x → InternalAutomaticity x := by
  intro x h
  exact ValidInt_has_internal_automaticity x h

theorem T_ispace_has_internal_automaticity : ∀ x : Obj,
    Ispace x → InternalAutomaticity x := by
  intro x h
  exact Ispace_has_internal_automaticity x h

theorem T_auto_nonvacuous : ∀ x : Obj, AutoBox x → ReachTrig x := by
  intro x h
  have hauto : AxiomShellModel.AutomationEvidenceIn x :=
    CoreSemanticModel.AutomationEvidenceIn_intro AxiomShellModel x h
  exact (AxiomShellTheory_automation_outputs x hauto).left

theorem T_auto_excludes_external_selector : ∀ x : Obj, AutoBox x → ¬ ExtControl x (BoundaryOf x) := by
  intro x h
  have hauto : AxiomShellModel.AutomationEvidenceIn x :=
    CoreSemanticModel.AutomationEvidenceIn_intro AxiomShellModel x h
  exact (AxiomShellTheory_automation_outputs x hauto).right

theorem T_static_only_not_interface : ∀ x : Obj, StaticOnly x → ¬ Ispace x := by
  intro x hs
  have hstaticOnly : AxiomShellModel.StaticOnlyEvidenceIn x :=
    CoreSemanticModel.StaticOnlyEvidenceIn_intro AxiomShellModel x hs
  exact (AxiomShellTheory_static_only_outputs x hstaticOnly).right.right

theorem T_passive_channel_not_interface : ∀ x : Obj, PassiveChannel x → ¬ Ispace x := by
  intro x hp
  have hpassive : AxiomShellModel.PassiveChannelEvidenceIn x :=
    CoreSemanticModel.PassiveChannelEvidenceIn_intro AxiomShellModel x hp
  exact (AxiomShellTheory_passive_channel_outputs x hpassive).right

theorem T_ext_control_not_valid_int : ∀ x : Obj, ExtControl x (BoundaryOf x) → ¬ ValidInt x := by
  intro x he
  exact (AxiomShellTheory_external_control_outputs x he).left

theorem T_ext_control_not_interface : ∀ x : Obj, ExtControl x (BoundaryOf x) → ¬ Ispace x := by
  intro x he
  exact (AxiomShellTheory_external_control_outputs x he).right

theorem T_A12_maxstruct_lift : ∀ s : Structure,
    MaxStruct s → InterfaceStructure s → StructLift s →
      Ispace (StructObj s) ∧ BoundaryIsolation s (BoundaryOfStruct s) := by
  intro s hm hi hl
  have hinput : AxiomShellModel.StructuralLiftInputIn s :=
    CoreSemanticModel.StructuralLiftInputIn_intro AxiomShellModel s hm hi hl
  exact AxiomShellTheory_structural_lift_outputs s hinput

theorem T_PIC_typed_closure : ∀ x : Obj, DomTMI x → Meaningful x → TypedInInterfaceDomain x := by
  intro x hd hm
  have hinput : AxiomShellModel.PICTypedDomainIn x :=
    CoreSemanticModel.PICTypedDomainIn_intro AxiomShellModel x hd hm
  exact AxiomShellTheory_pic_domain_meaning_typing x hinput

theorem T_PIC_typed_domain_witness : ∀ x : Obj, DomTMI x → Meaningful x → PICTypedDomain x := by
  intro x hd hm
  exact PIC_typed_domain_closure x hd hm

theorem T_PI_derivation_domain : ∀ x : Obj, Der x primaryI0 → Meaningful x → DomTMI x := by
  intro x hd hm
  have hpath : AxiomShellModel.PIPathCoreIn x :=
    CoreSemanticModel.PIPathCoreIn_intro AxiomShellModel x hm (PI_meaning_distinguishable x hm) hd
  exact AxiomShellTheory_pi_path_domain_closure x hpath

theorem T_PI_to_PIC_chain : ∀ x : Obj, Meaningful x → TypedInInterfaceDomain x := by
  intro x hm
  have hd : Der x primaryI0 := PI_derivation_from_meaning x hm
  have hpath : AxiomShellModel.PIPathCoreIn x :=
    CoreSemanticModel.PIPathCoreIn_intro AxiomShellModel x hm (PI_meaning_distinguishable x hm) hd
  exact AxiomShellTheory_pi_path_pic_typing x hpath

end Core
end TMI
