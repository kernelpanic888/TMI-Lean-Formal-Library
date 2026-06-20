/-
TMI-Core-Proof 0.2-A7 primitive Core contracts.

This module names the terminal assumptions that the Lean layer still accepts
as contract rules. Derived closure lemmas live in `TMI.Core.Axioms`.
-/

import TMI.Core.Signature

namespace TMI
namespace Core

def StructuralLiftInput (s : Structure) : Prop :=
  MaxStruct s ∧ InterfaceStructure s ∧ StructLift s

theorem StructuralLiftInput_intro : ∀ s : Structure,
    MaxStruct s → InterfaceStructure s → StructLift s → StructuralLiftInput s := by
  intro s hm hi hl
  exact ⟨hm, hi, hl⟩

theorem StructuralLiftInput_has_maximality : ∀ s : Structure,
    StructuralLiftInput s → MaxStruct s := by
  intro s h
  exact h.left

theorem StructuralLiftInput_has_interface_structure : ∀ s : Structure,
    StructuralLiftInput s → InterfaceStructure s := by
  intro s h
  exact h.right.left

theorem StructuralLiftInput_has_lift : ∀ s : Structure,
    StructuralLiftInput s → StructLift s := by
  intro s h
  exact h.right.right

axiom StructuralLift_interface_obligation : ∀ s : Structure,
  StructuralLiftInput s → Ispace (StructObj s)

axiom StructuralLift_boundary_isolation_obligation : ∀ s : Structure,
  StructuralLiftInput s → BoundaryIsolation s (BoundaryOfStruct s)

theorem A12_maxstruct_lift : ∀ s : Structure,
    MaxStruct s → InterfaceStructure s → StructLift s →
      Ispace (StructObj s) ∧ BoundaryIsolation s (BoundaryOfStruct s) := by
  intro s hm hi hl
  have hinput : StructuralLiftInput s := StructuralLiftInput_intro s hm hi hl
  exact ⟨StructuralLift_interface_obligation s hinput, StructuralLift_boundary_isolation_obligation s hinput⟩

def HasSubinterfaces (x : Obj) : Prop :=
  ∃ sub : Obj, SubinterfaceOf sub x ∧ Ispace sub

def InterfaceGraphAround (x : Obj) : Prop :=
  Ispace x ∧ HasSubinterfaces x

axiom Interface_contains_subinterfaces_obligation : ∀ x : Obj,
  Ispace x → HasSubinterfaces x

theorem Ispace_contains_subinterfaces : ∀ x : Obj,
    Ispace x → HasSubinterfaces x := by
  intro x h
  exact Interface_contains_subinterfaces_obligation x h

theorem Ispace_has_interface_graph : ∀ x : Obj,
    Ispace x → InterfaceGraphAround x := by
  intro x h
  exact ⟨h, Ispace_contains_subinterfaces x h⟩

def PrimaryInterfaceFootprint
    (transition left right : Obj) : Prop :=
  left ≠ right ∧
  TransitionBetween transition left right ∧
  Der transition primaryI0

def PrimaryInterfaceCarrier (transition : Obj) : Prop :=
  ∃ left right : Obj, PrimaryInterfaceFootprint transition left right

def MinimalIntelligenceInterface (transition : Obj) : Prop :=
  PrimaryInterfaceCarrier transition

theorem primary_interface_footprint_has_two_objects
    (transition left right : Obj) :
    PrimaryInterfaceFootprint transition left right ->
      left ≠ right := by
  intro h
  exact h.left

theorem primary_interface_footprint_has_transition
    (transition left right : Obj) :
    PrimaryInterfaceFootprint transition left right ->
      TransitionBetween transition left right := by
  intro h
  exact h.right.left

theorem primary_interface_footprint_has_primary_derivation
    (transition left right : Obj) :
    PrimaryInterfaceFootprint transition left right ->
      Der transition primaryI0 := by
  intro h
  exact h.right.right

theorem minimal_intelligence_interface_has_primary_interface
    (transition : Obj) :
    MinimalIntelligenceInterface transition ->
      ∃ left right : Obj,
        left ≠ right ∧
        TransitionBetween transition left right ∧
        Der transition primaryI0 := by
  intro h
  rcases h with ⟨left, right, hFootprint⟩
  exact ⟨left, right, hFootprint⟩

def AutomationEvidence (x : Obj) : Prop :=
  AutoBox x

theorem AutomationEvidence_intro : ∀ x : Obj, AutoBox x → AutomationEvidence x := by
  intro x h
  exact h

theorem AutomationEvidence_has_autobox : ∀ x : Obj, AutomationEvidence x → AutoBox x := by
  intro x h
  exact h

def ReachableTrigger (x : Obj) : Prop :=
  ReachTrig x

theorem ReachableTrigger_intro : ∀ x : Obj, ReachTrig x → ReachableTrigger x := by
  intro x h
  exact h

theorem ReachableTrigger_has_reach_trigger : ∀ x : Obj, ReachableTrigger x → ReachTrig x := by
  intro x h
  exact h

def NoExternalSelector (x : Obj) : Prop :=
  ¬ ExtControl x (BoundaryOf x)

def InternalAutomaticity (x : Obj) : Prop :=
  AutoBox x ∧ NoExternalSelector x

def ExternallyDrivenAutomaticity (x : Obj) : Prop :=
  AutoBox x ∧ ExtControl x (BoundaryOf x)

theorem NoExternalSelector_intro : ∀ x : Obj,
    ¬ ExtControl x (BoundaryOf x) → NoExternalSelector x := by
  intro x h
  exact h

theorem NoExternalSelector_excludes_external_control : ∀ x : Obj,
    NoExternalSelector x → ¬ ExtControl x (BoundaryOf x) := by
  intro x h
  exact h

theorem InternalAutomaticity_intro : ∀ x : Obj,
    AutoBox x → NoExternalSelector x → InternalAutomaticity x := by
  intro x hauto hnoext
  exact ⟨hauto, hnoext⟩

theorem InternalAutomaticity_has_autobox : ∀ x : Obj,
    InternalAutomaticity x → AutoBox x := by
  intro x h
  exact h.left

theorem InternalAutomaticity_has_no_external_selector : ∀ x : Obj,
    InternalAutomaticity x → NoExternalSelector x := by
  intro x h
  exact h.right

theorem InternalAutomaticity_excludes_external_control : ∀ x : Obj,
    InternalAutomaticity x → ¬ ExtControl x (BoundaryOf x) := by
  intro x h
  exact NoExternalSelector_excludes_external_control x h.right

theorem InternalAutomaticity_excludes_externally_driven : ∀ x : Obj,
    InternalAutomaticity x → ¬ ExternallyDrivenAutomaticity x := by
  intro x hinternal hexternal
  exact InternalAutomaticity_excludes_external_control x hinternal hexternal.right

axiom AutomationEvidence_reachability_obligation : ∀ x : Obj,
  AutomationEvidence x → ReachableTrigger x

axiom AutomationEvidence_no_external_selector_obligation : ∀ x : Obj,
  AutomationEvidence x → NoExternalSelector x

theorem A5_auto_reach : ∀ x : Obj, AutoBox x → ReachTrig x := by
  intro x h
  exact ReachableTrigger_has_reach_trigger x
    (AutomationEvidence_reachability_obligation x (AutomationEvidence_intro x h))

theorem A6_auto_no_external_selector : ∀ x : Obj, AutoBox x → ¬ ExtControl x (BoundaryOf x) := by
  intro x h
  exact NoExternalSelector_excludes_external_control x
    (AutomationEvidence_no_external_selector_obligation x (AutomationEvidence_intro x h))

theorem AutoBox_gives_internal_automaticity : ∀ x : Obj,
    AutoBox x → InternalAutomaticity x := by
  intro x hauto
  exact InternalAutomaticity_intro x hauto
    (NoExternalSelector_intro x (A6_auto_no_external_selector x hauto))

def EventObservation (e : Event) (x : Obj) (t : Time) : Prop :=
  EventAt e x t

theorem EventObservation_intro : ∀ (e : Event) (x : Obj) (t : Time),
    EventAt e x t → EventObservation e x t := by
  intro e x t h
  exact h

theorem EventObservation_has_event : ∀ (e : Event) (x : Obj) (t : Time),
    EventObservation e x t → EventAt e x t := by
  intro e x t h
  exact h

def CandidateEvidence (x : Obj) : Prop :=
  PreIspace x

theorem CandidateEvidence_intro : ∀ x : Obj, PreIspace x → CandidateEvidence x := by
  intro x hcandidate
  exact hcandidate

theorem CandidateEvidence_has_candidate : ∀ x : Obj, CandidateEvidence x → PreIspace x := by
  intro x hcandidate
  exact hcandidate

def StatusChangeEvidence (x : Obj) : Prop :=
  StatusChanged x

theorem StatusChangeEvidence_intro : ∀ x : Obj, StatusChanged x → StatusChangeEvidence x := by
  intro x hstatus
  exact hstatus

theorem StatusChangeEvidence_has_status_change : ∀ x : Obj, StatusChangeEvidence x → StatusChanged x := by
  intro x hstatus
  exact hstatus

axiom EventObservation_candidate_obligation : ∀ (e : Event) (x : Obj) (t : Time),
  EventObservation e x t → CandidateEvidence x

axiom EventObservation_status_change_obligation : ∀ (e : Event) (x : Obj) (t : Time),
  EventObservation e x t → StatusChangeEvidence x

theorem A2_event_candidate : ∀ (e : Event) (x : Obj) (t : Time),
    EventAt e x t → PreIspace x := by
  intro e x t h
  exact CandidateEvidence_has_candidate x
    (EventObservation_candidate_obligation e x t (EventObservation_intro e x t h))

theorem A3_event_status_changed : ∀ (e : Event) (x : Obj) (t : Time),
    EventAt e x t → StatusChanged x := by
  intro e x t h
  exact StatusChangeEvidence_has_status_change x
    (EventObservation_status_change_obligation e x t (EventObservation_intro e x t h))

def PrimaryDerivation (x : Obj) : Prop :=
  Der x primaryI0

theorem PrimaryDerivation_intro : ∀ x : Obj, Der x primaryI0 → PrimaryDerivation x := by
  intro x h
  exact h

theorem PrimaryDerivation_has_derivation : ∀ x : Obj, PrimaryDerivation x → Der x primaryI0 := by
  intro x h
  exact h

axiom PrimaryDerivation_candidate_obligation : ∀ x : Obj,
  PrimaryDerivation x → CandidateEvidence x

theorem A1_der_candidate : ∀ x : Obj, Der x primaryI0 → PreIspace x := by
  intro x h
  exact CandidateEvidence_has_candidate x
    (PrimaryDerivation_candidate_obligation x (PrimaryDerivation_intro x h))

def ValidIntComponents (x : Obj) : Prop :=
  ValidStr x
  ∧ Dyn x
  ∧ AutoBox x
  ∧ NonStatic x
  ∧ CausalFrame x
  ∧ Integrated x
  ∧ (∃ s : Structure, PreInterfaceStructure s ∧ InStructure x s ∧ StructurallyLinked x s)
  ∧ ¬ AbsoluteIsolation x

def ValidInt (x : Obj) : Prop :=
  ValidIntComponents x

theorem ValidInt_iff_components : ∀ x : Obj, ValidInt x ↔ ValidIntComponents x := by
  intro x
  rfl

theorem ValidInt_has_internal_automaticity : ∀ x : Obj,
    ValidInt x → InternalAutomaticity x := by
  intro x hvalid
  have hcomponents : ValidIntComponents x :=
    (ValidInt_iff_components x).mp hvalid
  have hauto : AutoBox x := hcomponents.right.right.left
  exact AutoBox_gives_internal_automaticity x hauto

def InterfaceClosureInput (x : Obj) : Prop :=
  PreIspace x ∧ ValidInt x

theorem InterfaceClosureInput_intro : ∀ x : Obj,
    PreIspace x → ValidInt x → InterfaceClosureInput x := by
  intro x hp hv
  exact ⟨hp, hv⟩

theorem InterfaceClosureInput_has_candidate : ∀ x : Obj,
    InterfaceClosureInput x → PreIspace x := by
  intro x h
  exact h.left

theorem InterfaceClosureInput_has_valid_int : ∀ x : Obj,
    InterfaceClosureInput x → ValidInt x := by
  intro x h
  exact h.right

axiom InterfaceClosure_intro_obligation : ∀ x : Obj,
  InterfaceClosureInput x → Ispace x

axiom InterfaceClosure_soundness_obligation : ∀ x : Obj,
  Ispace x → InterfaceClosureInput x

theorem A7_interface_intro_obligation : ∀ x : Obj,
    PreIspace x → ValidInt x → Ispace x := by
  intro x hp hv
  exact InterfaceClosure_intro_obligation x (InterfaceClosureInput_intro x hp hv)

theorem A7_interface_soundness_obligation : ∀ x : Obj,
    Ispace x → PreIspace x ∧ ValidInt x := by
  intro x h
  exact InterfaceClosure_soundness_obligation x h

theorem Ispace_iff_valid : ∀ x : Obj, Ispace x ↔ PreIspace x ∧ ValidInt x := by
  intro x
  constructor
  · intro h
    exact A7_interface_soundness_obligation x h
  · intro h
    exact A7_interface_intro_obligation x h.left h.right

theorem Ispace_has_internal_automaticity : ∀ x : Obj,
    Ispace x → InternalAutomaticity x := by
  intro x hispace
  exact ValidInt_has_internal_automaticity x
    (A7_interface_soundness_obligation x hispace).right

axiom Meaningfulness_distinguishability_obligation : ∀ x : Obj,
  Meaningful x → Distinguishable x

theorem PIPath_meaning_distinguishability_obligation : ∀ x : Obj,
    Meaningful x → Distinguishable x := by
  intro x h
  exact Meaningfulness_distinguishability_obligation x h

axiom Distinguishability_primary_derivation_obligation : ∀ x : Obj,
  Distinguishable x → Der x primaryI0

theorem PIPath_distinguishability_derivation_obligation : ∀ x : Obj,
    Distinguishable x → Der x primaryI0 := by
  intro x h
  exact Distinguishability_primary_derivation_obligation x h

theorem PI_meaning_distinguishable : ∀ x : Obj, Meaningful x → Distinguishable x := by
  intro x h
  exact PIPath_meaning_distinguishability_obligation x h

theorem PI_distinguishable_der : ∀ x : Obj, Distinguishable x → Der x primaryI0 := by
  intro x h
  exact PIPath_distinguishability_derivation_obligation x h

def PICTypedDomain (x : Obj) : Prop :=
  DomTMI x ∧ Meaningful x

theorem PICTypedDomain_has_domain : ∀ x : Obj, PICTypedDomain x → DomTMI x := by
  intro x h
  exact h.left

theorem PICTypedDomain_has_meaning : ∀ x : Obj, PICTypedDomain x → Meaningful x := by
  intro x h
  exact h.right

axiom PICDomainMeaning_interface_typing_obligation : ∀ x : Obj,
  DomTMI x → Meaningful x → TypedInInterfaceDomain x

theorem PICTypedDomain_interface_typing_obligation : ∀ x : Obj,
    PICTypedDomain x → TypedInInterfaceDomain x := by
  intro x h
  exact PICDomainMeaning_interface_typing_obligation
    x
    (PICTypedDomain_has_domain x h)
    (PICTypedDomain_has_meaning x h)

theorem PIC_meaningful_interface_typing : ∀ x : Obj, PICTypedDomain x → TypedInInterfaceDomain x := by
  intro x h
  exact PICTypedDomain_interface_typing_obligation x h

def PIPathSemanticCore (x : Obj) : Prop :=
  Meaningful x ∧ Distinguishable x ∧ Der x primaryI0

def PIPath (x : Obj) : Prop :=
  PIPathSemanticCore x

theorem PIPath_iff_semantic_core : ∀ x : Obj, PIPath x ↔ PIPathSemanticCore x := by
  intro x
  rfl

theorem PIPath_has_meaning : ∀ x : Obj, PIPath x → Meaningful x := by
  intro x h
  exact h.left

theorem PIPath_has_distinguishable : ∀ x : Obj, PIPath x → Distinguishable x := by
  intro x h
  exact h.right.left

theorem PIPath_has_derivation : ∀ x : Obj, PIPath x → Der x primaryI0 := by
  intro x h
  exact h.right.right

axiom PIPathSemanticCore_domain_membership_obligation : ∀ x : Obj,
  Meaningful x → Distinguishable x → Der x primaryI0 → DomTMI x

theorem PIPath_domain_membership_obligation : ∀ x : Obj,
    PIPath x → DomTMI x := by
  intro x h
  exact PIPathSemanticCore_domain_membership_obligation
    x
    (PIPath_has_meaning x h)
    (PIPath_has_distinguishable x h)
    (PIPath_has_derivation x h)

theorem PIPath_domain_closure : ∀ x : Obj, PIPath x → DomTMI x := by
  intro x h
  exact PIPath_domain_membership_obligation x h

theorem A0_PI_domain_closure : ∀ x : Obj, PIPath x → DomTMI x := by
  intro x h
  exact PIPath_domain_closure x h

def InterfaceRoleTyping (x : Obj) : Prop :=
  TypedAs x roleInterface

theorem InterfaceRoleTyping_intro : ∀ x : Obj, TypedAs x roleInterface → InterfaceRoleTyping x := by
  intro x h
  exact h

theorem InterfaceRoleTyping_has_role : ∀ x : Obj, InterfaceRoleTyping x → TypedAs x roleInterface := by
  intro x h
  exact h

axiom InterfaceRoleTyping_soundness_obligation : ∀ x : Obj,
  InterfaceRoleTyping x → Ispace x

axiom InterfaceRoleTyping_completeness_obligation : ∀ x : Obj,
  Ispace x → InterfaceRoleTyping x

theorem RoleInterface_typing_soundness_obligation : ∀ x : Obj,
    TypedAs x roleInterface → Ispace x := by
  intro x h
  exact InterfaceRoleTyping_soundness_obligation x (InterfaceRoleTyping_intro x h)

theorem RoleInterface_typing_completeness_obligation : ∀ x : Obj,
    Ispace x → TypedAs x roleInterface := by
  intro x h
  exact InterfaceRoleTyping_has_role x (InterfaceRoleTyping_completeness_obligation x h)

theorem RoleInterface_equiv : ∀ x : Obj, TypedAs x roleInterface ↔ Ispace x := by
  intro x
  constructor
  · intro h
    exact RoleInterface_typing_soundness_obligation x h
  · intro h
    exact RoleInterface_typing_completeness_obligation x h

end Core
end TMI
