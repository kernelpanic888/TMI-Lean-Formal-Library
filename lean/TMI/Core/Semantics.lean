/-
TMI-Core-Proof 0.2-A7 primitive semantic model layer.

This module gives the axiom-shell signature an explicit model-indexed mirror.
It does not replace the public signature yet; it names the target shape for
moving primitive sorts and predicates toward definitions.
-/

import TMI.Core.Contracts
import TMI.Core.NonInflation

namespace TMI
namespace Core

structure CoreSemanticModel where
  ObjT : Type
  EventT : Type
  TimeT : Type
  BoundaryT : Type
  StructureT : Type
  RoleT : Type
  primaryI0 : ObjT
  der : ObjT -> ObjT -> Prop
  preIspace : ObjT -> Prop
  ispace : ObjT -> Prop
  validStr : ObjT -> Prop
  dyn : ObjT -> Prop
  staticPred : ObjT -> Prop
  nonStatic : ObjT -> Prop
  autoBox : ObjT -> Prop
  reachTrig : ObjT -> Prop
  extControl : ObjT -> BoundaryT -> Prop
  boundaryOf : ObjT -> BoundaryT
  causalFrame : ObjT -> Prop
  integrated : ObjT -> Prop
  absoluteIsolation : ObjT -> Prop
  staticOnly : ObjT -> Prop
  passiveChannel : ObjT -> Prop
  eventAt : EventT -> ObjT -> TimeT -> Prop
  statusChanged : ObjT -> Prop
  preInterfaceStructure : StructureT -> Prop
  interfaceStructure : StructureT -> Prop
  inStructure : ObjT -> StructureT -> Prop
  structurallyLinked : ObjT -> StructureT -> Prop
  maxStruct : StructureT -> Prop
  structLift : StructureT -> Prop
  boundaryOfStruct : StructureT -> BoundaryT
  boundaryIsolation : StructureT -> BoundaryT -> Prop
  structObj : StructureT -> ObjT
  domTMI : ObjT -> Prop
  meaningful : ObjT -> Prop
  distinguishable : ObjT -> Prop
  typedInInterfaceDomain : ObjT -> Prop
  typedAs : ObjT -> RoleT -> Prop
  roleInterface : RoleT

namespace CoreSemanticModel

def ValidIntComponentsIn (M : CoreSemanticModel) (x : M.ObjT) : Prop :=
  M.validStr x
  ∧ M.dyn x
  ∧ M.autoBox x
  ∧ M.nonStatic x
  ∧ M.causalFrame x
  ∧ M.integrated x
  ∧ (∃ s : M.StructureT,
      M.preInterfaceStructure s ∧ M.inStructure x s ∧ M.structurallyLinked x s)
  ∧ ¬ M.absoluteIsolation x

theorem ValidIntComponentsIn_intro : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.validStr x →
    M.dyn x →
    M.autoBox x →
    M.nonStatic x →
    M.causalFrame x →
    M.integrated x →
    (∃ s : M.StructureT,
      M.preInterfaceStructure s ∧ M.inStructure x s ∧ M.structurallyLinked x s) →
    ¬ M.absoluteIsolation x →
    M.ValidIntComponentsIn x := by
  intro M x hvalid hdyn hauto hnonstatic hcausal hint hstruct hnotabs
  exact ⟨hvalid, hdyn, hauto, hnonstatic, hcausal, hint, hstruct, hnotabs⟩

theorem ValidIntComponentsIn_has_valid_str : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.ValidIntComponentsIn x → M.validStr x := by
  intro M x h
  exact h.left

theorem ValidIntComponentsIn_has_dyn : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.ValidIntComponentsIn x → M.dyn x := by
  intro M x h
  exact h.right.left

theorem ValidIntComponentsIn_has_auto_box : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.ValidIntComponentsIn x → M.autoBox x := by
  intro M x h
  exact h.right.right.left

theorem ValidIntComponentsIn_has_non_static : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.ValidIntComponentsIn x → M.nonStatic x := by
  intro M x h
  exact h.right.right.right.left

theorem ValidIntComponentsIn_has_causal_frame : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.ValidIntComponentsIn x → M.causalFrame x := by
  intro M x h
  exact h.right.right.right.right.left

theorem ValidIntComponentsIn_has_integrated : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.ValidIntComponentsIn x → M.integrated x := by
  intro M x h
  exact h.right.right.right.right.right.left

theorem ValidIntComponentsIn_has_structure_link : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.ValidIntComponentsIn x →
      ∃ s : M.StructureT,
        M.preInterfaceStructure s ∧ M.inStructure x s ∧ M.structurallyLinked x s := by
  intro M x h
  exact h.right.right.right.right.right.right.left

theorem ValidIntComponentsIn_not_absolute_isolation : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.ValidIntComponentsIn x → ¬ M.absoluteIsolation x := by
  intro M x h
  exact h.right.right.right.right.right.right.right

theorem ValidIntComponentsIn_dyn_nonstatic_outputs : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.ValidIntComponentsIn x → M.dyn x ∧ M.nonStatic x := by
  intro M x h
  exact ⟨
    M.ValidIntComponentsIn_has_dyn x h,
    M.ValidIntComponentsIn_has_non_static x h
  ⟩

theorem ValidIntComponentsIn_causal_frame_output : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.ValidIntComponentsIn x → M.causalFrame x := by
  intro M x h
  exact M.ValidIntComponentsIn_has_causal_frame x h

theorem ValidIntComponentsIn_integrated_output : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.ValidIntComponentsIn x → M.integrated x := by
  intro M x h
  exact M.ValidIntComponentsIn_has_integrated x h

theorem ValidIntComponentsIn_structural_link_output : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.ValidIntComponentsIn x →
      ∃ s : M.StructureT,
        M.preInterfaceStructure s ∧ M.inStructure x s ∧ M.structurallyLinked x s := by
  intro M x h
  exact M.ValidIntComponentsIn_has_structure_link x h

def InterfaceClosureInputIn (M : CoreSemanticModel) (x : M.ObjT) : Prop :=
  M.preIspace x ∧ M.ValidIntComponentsIn x

theorem InterfaceClosureInputIn_intro : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.preIspace x → M.ValidIntComponentsIn x → M.InterfaceClosureInputIn x := by
  intro M x hpre hvalid
  exact ⟨hpre, hvalid⟩

theorem InterfaceClosureInputIn_has_candidate : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.InterfaceClosureInputIn x → M.preIspace x := by
  intro M x h
  exact h.left

theorem InterfaceClosureInputIn_has_valid_components : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.InterfaceClosureInputIn x → M.ValidIntComponentsIn x := by
  intro M x h
  exact h.right

def InterfaceClosureIntroObligationIn (M : CoreSemanticModel) : Prop :=
  ∀ x : M.ObjT, M.InterfaceClosureInputIn x → M.ispace x

def InterfaceClosureSoundnessObligationIn (M : CoreSemanticModel) : Prop :=
  ∀ x : M.ObjT, M.ispace x → M.InterfaceClosureInputIn x

theorem InterfaceClosureIntroObligationIn_apply : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.InterfaceClosureIntroObligationIn → M.InterfaceClosureInputIn x → M.ispace x := by
  intro M x hobligation hinput
  exact hobligation x hinput

theorem InterfaceClosureSoundnessObligationIn_apply : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.InterfaceClosureSoundnessObligationIn → M.ispace x → M.InterfaceClosureInputIn x := by
  intro M x hobligation hispace
  exact hobligation x hispace

def StructuralLiftInputIn (M : CoreSemanticModel) (s : M.StructureT) : Prop :=
  M.maxStruct s ∧ M.interfaceStructure s ∧ M.structLift s

theorem StructuralLiftInputIn_intro : ∀ (M : CoreSemanticModel) (s : M.StructureT),
    M.maxStruct s → M.interfaceStructure s → M.structLift s → M.StructuralLiftInputIn s := by
  intro M s hmax hinterface hlift
  exact ⟨hmax, hinterface, hlift⟩

theorem StructuralLiftInputIn_has_maximality : ∀ (M : CoreSemanticModel) (s : M.StructureT),
    M.StructuralLiftInputIn s → M.maxStruct s := by
  intro M s h
  exact h.left

theorem StructuralLiftInputIn_has_interface_structure : ∀ (M : CoreSemanticModel) (s : M.StructureT),
    M.StructuralLiftInputIn s → M.interfaceStructure s := by
  intro M s h
  exact h.right.left

theorem StructuralLiftInputIn_has_lift : ∀ (M : CoreSemanticModel) (s : M.StructureT),
    M.StructuralLiftInputIn s → M.structLift s := by
  intro M s h
  exact h.right.right

def StructuralLiftInterfaceObligationIn (M : CoreSemanticModel) : Prop :=
  ∀ s : M.StructureT, M.StructuralLiftInputIn s → M.ispace (M.structObj s)

def StructuralLiftBoundaryIsolationObligationIn (M : CoreSemanticModel) : Prop :=
  ∀ s : M.StructureT, M.StructuralLiftInputIn s → M.boundaryIsolation s (M.boundaryOfStruct s)

theorem StructuralLiftInterfaceObligationIn_apply : ∀ (M : CoreSemanticModel) (s : M.StructureT),
    M.StructuralLiftInterfaceObligationIn → M.StructuralLiftInputIn s → M.ispace (M.structObj s) := by
  intro M s hobligation hinput
  exact hobligation s hinput

theorem StructuralLiftBoundaryIsolationObligationIn_apply : ∀ (M : CoreSemanticModel) (s : M.StructureT),
    M.StructuralLiftBoundaryIsolationObligationIn →
      M.StructuralLiftInputIn s →
      M.boundaryIsolation s (M.boundaryOfStruct s) := by
  intro M s hobligation hinput
  exact hobligation s hinput

def PIPathCoreIn (M : CoreSemanticModel) (x : M.ObjT) : Prop :=
  M.meaningful x ∧ M.distinguishable x ∧ M.der x M.primaryI0

theorem PIPathCoreIn_intro : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.meaningful x → M.distinguishable x → M.der x M.primaryI0 → M.PIPathCoreIn x := by
  intro M x hmeaning hdist hder
  exact ⟨hmeaning, hdist, hder⟩

theorem PIPathCoreIn_has_meaning : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.PIPathCoreIn x → M.meaningful x := by
  intro M x h
  exact h.left

theorem PIPathCoreIn_has_distinguishable : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.PIPathCoreIn x → M.distinguishable x := by
  intro M x h
  exact h.right.left

theorem PIPathCoreIn_has_derivation : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.PIPathCoreIn x → M.der x M.primaryI0 := by
  intro M x h
  exact h.right.right

def PIPathDomainClosureObligationIn (M : CoreSemanticModel) : Prop :=
  ∀ x : M.ObjT, M.PIPathCoreIn x → M.domTMI x

theorem PIPathDomainClosureObligationIn_apply : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.PIPathDomainClosureObligationIn → M.PIPathCoreIn x → M.domTMI x := by
  intro M x hobligation hpath
  exact hobligation x hpath

def PICTypedDomainIn (M : CoreSemanticModel) (x : M.ObjT) : Prop :=
  M.domTMI x ∧ M.meaningful x

theorem PICTypedDomainIn_intro : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.domTMI x → M.meaningful x → M.PICTypedDomainIn x := by
  intro M x hdom hmeaning
  exact ⟨hdom, hmeaning⟩

theorem PICTypedDomainIn_has_domain : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.PICTypedDomainIn x → M.domTMI x := by
  intro M x h
  exact h.left

theorem PICTypedDomainIn_has_meaning : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.PICTypedDomainIn x → M.meaningful x := by
  intro M x h
  exact h.right

def PICDomainMeaningTypingObligationIn (M : CoreSemanticModel) : Prop :=
  ∀ x : M.ObjT, M.PICTypedDomainIn x → M.typedInInterfaceDomain x

theorem PICDomainMeaningTypingObligationIn_apply : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.PICDomainMeaningTypingObligationIn → M.PICTypedDomainIn x → M.typedInInterfaceDomain x := by
  intro M x hobligation hinput
  exact hobligation x hinput

def InterfaceRoleTypingIn (M : CoreSemanticModel) (x : M.ObjT) : Prop :=
  M.typedAs x M.roleInterface

theorem InterfaceRoleTypingIn_intro : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.typedAs x M.roleInterface → M.InterfaceRoleTypingIn x := by
  intro M x htyped
  exact htyped

theorem InterfaceRoleTypingIn_has_role_typing : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.InterfaceRoleTypingIn x → M.typedAs x M.roleInterface := by
  intro M x h
  exact h

def InterfaceRoleSoundnessObligationIn (M : CoreSemanticModel) : Prop :=
  ∀ x : M.ObjT, M.InterfaceRoleTypingIn x → M.ispace x

def InterfaceRoleCompletenessObligationIn (M : CoreSemanticModel) : Prop :=
  ∀ x : M.ObjT, M.ispace x → M.InterfaceRoleTypingIn x

theorem InterfaceRoleSoundnessObligationIn_apply : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.InterfaceRoleSoundnessObligationIn → M.InterfaceRoleTypingIn x → M.ispace x := by
  intro M x hobligation hrole
  exact hobligation x hrole

theorem InterfaceRoleCompletenessObligationIn_apply : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.InterfaceRoleCompletenessObligationIn → M.ispace x → M.InterfaceRoleTypingIn x := by
  intro M x hobligation hispace
  exact hobligation x hispace

def CandidateEvidenceIn (M : CoreSemanticModel) (x : M.ObjT) : Prop :=
  M.preIspace x

theorem CandidateEvidenceIn_intro : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.preIspace x → M.CandidateEvidenceIn x := by
  intro M x hcandidate
  exact hcandidate

theorem CandidateEvidenceIn_has_candidate : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.CandidateEvidenceIn x → M.preIspace x := by
  intro M x hcandidate
  exact hcandidate

def StatusChangeEvidenceIn (M : CoreSemanticModel) (x : M.ObjT) : Prop :=
  M.statusChanged x

theorem StatusChangeEvidenceIn_intro : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.statusChanged x → M.StatusChangeEvidenceIn x := by
  intro M x hstatus
  exact hstatus

theorem StatusChangeEvidenceIn_has_status_change : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.StatusChangeEvidenceIn x → M.statusChanged x := by
  intro M x hstatus
  exact hstatus

def EventObservationIn (M : CoreSemanticModel) (e : M.EventT) (x : M.ObjT) (t : M.TimeT) : Prop :=
  M.eventAt e x t

theorem EventObservationIn_intro : ∀ (M : CoreSemanticModel) (e : M.EventT) (x : M.ObjT) (t : M.TimeT),
    M.eventAt e x t → M.EventObservationIn e x t := by
  intro M e x t hevent
  exact hevent

theorem EventObservationIn_has_event : ∀ (M : CoreSemanticModel) (e : M.EventT) (x : M.ObjT) (t : M.TimeT),
    M.EventObservationIn e x t → M.eventAt e x t := by
  intro M e x t h
  exact h

def EventObservationCandidateObligationIn (M : CoreSemanticModel) : Prop :=
  ∀ (e : M.EventT) (x : M.ObjT) (t : M.TimeT),
    M.EventObservationIn e x t → M.CandidateEvidenceIn x

def EventObservationStatusChangeObligationIn (M : CoreSemanticModel) : Prop :=
  ∀ (e : M.EventT) (x : M.ObjT) (t : M.TimeT),
    M.EventObservationIn e x t → M.StatusChangeEvidenceIn x

theorem EventObservationCandidateObligationIn_apply :
    ∀ (M : CoreSemanticModel) (e : M.EventT) (x : M.ObjT) (t : M.TimeT),
      M.EventObservationCandidateObligationIn → M.EventObservationIn e x t → M.CandidateEvidenceIn x := by
  intro M e x t hobligation hobs
  exact hobligation e x t hobs

theorem EventObservationStatusChangeObligationIn_apply :
    ∀ (M : CoreSemanticModel) (e : M.EventT) (x : M.ObjT) (t : M.TimeT),
      M.EventObservationStatusChangeObligationIn → M.EventObservationIn e x t → M.StatusChangeEvidenceIn x := by
  intro M e x t hobligation hobs
  exact hobligation e x t hobs

def PrimaryDerivationIn (M : CoreSemanticModel) (x : M.ObjT) : Prop :=
  M.der x M.primaryI0

theorem PrimaryDerivationIn_intro : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.der x M.primaryI0 → M.PrimaryDerivationIn x := by
  intro M x hder
  exact hder

theorem PrimaryDerivationIn_has_derivation : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.PrimaryDerivationIn x → M.der x M.primaryI0 := by
  intro M x h
  exact h

def PrimaryDerivationCandidateObligationIn (M : CoreSemanticModel) : Prop :=
  ∀ x : M.ObjT, M.PrimaryDerivationIn x → M.CandidateEvidenceIn x

theorem PrimaryDerivationCandidateObligationIn_apply : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.PrimaryDerivationCandidateObligationIn → M.PrimaryDerivationIn x → M.CandidateEvidenceIn x := by
  intro M x hobligation hder
  exact hobligation x hder

structure EventDerivationEvidenceTheory (M : CoreSemanticModel) where
  eventObservationCandidate : M.EventObservationCandidateObligationIn
  eventObservationStatusChange : M.EventObservationStatusChangeObligationIn
  primaryDerivationCandidate : M.PrimaryDerivationCandidateObligationIn

theorem EventDerivationEvidenceTheory_event_observation_candidate_evidence :
    ∀ (M : CoreSemanticModel) (_ : M.EventDerivationEvidenceTheory)
      (e : M.EventT) (x : M.ObjT) (t : M.TimeT),
      M.EventObservationIn e x t → M.CandidateEvidenceIn x := by
  intro M T e x t hobs
  exact M.EventObservationCandidateObligationIn_apply e x t T.eventObservationCandidate hobs

theorem EventDerivationEvidenceTheory_event_observation_candidate :
    ∀ (M : CoreSemanticModel) (_ : M.EventDerivationEvidenceTheory)
      (e : M.EventT) (x : M.ObjT) (t : M.TimeT),
      M.EventObservationIn e x t → M.preIspace x := by
  intro M T e x t hobs
  exact M.CandidateEvidenceIn_has_candidate x
    (M.EventDerivationEvidenceTheory_event_observation_candidate_evidence T e x t hobs)

theorem EventDerivationEvidenceTheory_event_observation_status_change_evidence :
    ∀ (M : CoreSemanticModel) (_ : M.EventDerivationEvidenceTheory)
      (e : M.EventT) (x : M.ObjT) (t : M.TimeT),
      M.EventObservationIn e x t → M.StatusChangeEvidenceIn x := by
  intro M T e x t hobs
  exact M.EventObservationStatusChangeObligationIn_apply e x t T.eventObservationStatusChange hobs

theorem EventDerivationEvidenceTheory_event_observation_status_change :
    ∀ (M : CoreSemanticModel) (_ : M.EventDerivationEvidenceTheory)
      (e : M.EventT) (x : M.ObjT) (t : M.TimeT),
      M.EventObservationIn e x t → M.statusChanged x := by
  intro M T e x t hobs
  exact M.StatusChangeEvidenceIn_has_status_change x
    (M.EventDerivationEvidenceTheory_event_observation_status_change_evidence T e x t hobs)

theorem EventDerivationEvidenceTheory_event_observation_evidence :
    ∀ (M : CoreSemanticModel) (_ : M.EventDerivationEvidenceTheory)
      (e : M.EventT) (x : M.ObjT) (t : M.TimeT),
      M.EventObservationIn e x t → M.CandidateEvidenceIn x ∧ M.StatusChangeEvidenceIn x := by
  intro M T e x t hobs
  exact And.intro
    (M.EventDerivationEvidenceTheory_event_observation_candidate_evidence T e x t hobs)
    (M.EventDerivationEvidenceTheory_event_observation_status_change_evidence T e x t hobs)

theorem EventDerivationEvidenceTheory_event_observation_outputs :
    ∀ (M : CoreSemanticModel) (_ : M.EventDerivationEvidenceTheory)
      (e : M.EventT) (x : M.ObjT) (t : M.TimeT),
      M.EventObservationIn e x t → M.preIspace x ∧ M.statusChanged x := by
  intro M T e x t hobs
  exact And.intro
    (M.EventDerivationEvidenceTheory_event_observation_candidate T e x t hobs)
    (M.EventDerivationEvidenceTheory_event_observation_status_change T e x t hobs)

theorem EventDerivationEvidenceTheory_primary_derivation_candidate_evidence :
    ∀ (M : CoreSemanticModel) (_ : M.EventDerivationEvidenceTheory) (x : M.ObjT),
      M.PrimaryDerivationIn x → M.CandidateEvidenceIn x := by
  intro M T x hder
  exact M.PrimaryDerivationCandidateObligationIn_apply x T.primaryDerivationCandidate hder

theorem EventDerivationEvidenceTheory_primary_derivation_candidate :
    ∀ (M : CoreSemanticModel) (_ : M.EventDerivationEvidenceTheory) (x : M.ObjT),
      M.PrimaryDerivationIn x → M.preIspace x := by
  intro M T x hder
  exact M.CandidateEvidenceIn_has_candidate x
    (M.EventDerivationEvidenceTheory_primary_derivation_candidate_evidence T x hder)

theorem EventDerivationEvidenceTheory_primary_derivation_evidence :
    ∀ (M : CoreSemanticModel) (_ : M.EventDerivationEvidenceTheory) (x : M.ObjT),
      M.PrimaryDerivationIn x → M.CandidateEvidenceIn x := by
  intro M T x hder
  exact M.EventDerivationEvidenceTheory_primary_derivation_candidate_evidence T x hder

theorem EventDerivationEvidenceTheory_primary_derivation_outputs :
    ∀ (M : CoreSemanticModel) (_ : M.EventDerivationEvidenceTheory) (x : M.ObjT),
      M.PrimaryDerivationIn x → M.preIspace x := by
  intro M T x hder
  exact M.EventDerivationEvidenceTheory_primary_derivation_candidate T x hder

def AutomationEvidenceIn (M : CoreSemanticModel) (x : M.ObjT) : Prop :=
  M.autoBox x

theorem AutomationEvidenceIn_intro : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.autoBox x → M.AutomationEvidenceIn x := by
  intro M x hauto
  exact hauto

theorem AutomationEvidenceIn_has_autobox : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.AutomationEvidenceIn x → M.autoBox x := by
  intro M x h
  exact h

def ReachableTriggerIn (M : CoreSemanticModel) (x : M.ObjT) : Prop :=
  M.reachTrig x

theorem ReachableTriggerIn_intro : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.reachTrig x → M.ReachableTriggerIn x := by
  intro M x hreach
  exact hreach

theorem ReachableTriggerIn_has_reach_trigger : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.ReachableTriggerIn x → M.reachTrig x := by
  intro M x hreach
  exact hreach

def NoExternalSelectorIn (M : CoreSemanticModel) (x : M.ObjT) : Prop :=
  ¬ M.extControl x (M.boundaryOf x)

theorem NoExternalSelectorIn_intro : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    ¬ M.extControl x (M.boundaryOf x) → M.NoExternalSelectorIn x := by
  intro M x hnotExternal
  exact hnotExternal

theorem NoExternalSelectorIn_excludes_external_control :
    ∀ (M : CoreSemanticModel) (x : M.ObjT),
      M.NoExternalSelectorIn x → ¬ M.extControl x (M.boundaryOf x) := by
  intro M x hnotExternal
  exact hnotExternal

def AutomationReachabilityObligationIn (M : CoreSemanticModel) : Prop :=
  ∀ x : M.ObjT, M.AutomationEvidenceIn x → M.ReachableTriggerIn x

def AutomationNoExternalSelectorObligationIn (M : CoreSemanticModel) : Prop :=
  ∀ x : M.ObjT, M.AutomationEvidenceIn x → M.NoExternalSelectorIn x

theorem AutomationReachabilityObligationIn_apply : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.AutomationReachabilityObligationIn → M.AutomationEvidenceIn x → M.ReachableTriggerIn x := by
  intro M x hobligation hauto
  exact hobligation x hauto

theorem AutomationNoExternalSelectorObligationIn_apply : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.AutomationNoExternalSelectorObligationIn →
      M.AutomationEvidenceIn x →
      M.NoExternalSelectorIn x := by
  intro M x hobligation hauto
  exact hobligation x hauto

structure AutomationEvidenceTheory (M : CoreSemanticModel) where
  reachability : M.AutomationReachabilityObligationIn
  noExternalSelector : M.AutomationNoExternalSelectorObligationIn

theorem AutomationEvidenceTheory_reachable_trigger :
    ∀ (M : CoreSemanticModel) (_ : M.AutomationEvidenceTheory) (x : M.ObjT),
      M.AutomationEvidenceIn x → M.ReachableTriggerIn x := by
  intro M T x hauto
  exact M.AutomationReachabilityObligationIn_apply x T.reachability hauto

theorem AutomationEvidenceTheory_reachability :
    ∀ (M : CoreSemanticModel) (_ : M.AutomationEvidenceTheory) (x : M.ObjT),
      M.AutomationEvidenceIn x → M.reachTrig x := by
  intro M T x hauto
  exact M.ReachableTriggerIn_has_reach_trigger x
    (M.AutomationEvidenceTheory_reachable_trigger T x hauto)

theorem AutomationEvidenceTheory_no_external_selector :
    ∀ (M : CoreSemanticModel) (_ : M.AutomationEvidenceTheory) (x : M.ObjT),
      M.AutomationEvidenceIn x → M.NoExternalSelectorIn x := by
  intro M T x hauto
  exact M.AutomationNoExternalSelectorObligationIn_apply x T.noExternalSelector hauto

theorem AutomationEvidenceTheory_evidence :
    ∀ (M : CoreSemanticModel) (_ : M.AutomationEvidenceTheory) (x : M.ObjT),
      M.AutomationEvidenceIn x → M.ReachableTriggerIn x ∧ M.NoExternalSelectorIn x := by
  intro M T x hauto
  exact And.intro
    (M.AutomationEvidenceTheory_reachable_trigger T x hauto)
    (M.AutomationEvidenceTheory_no_external_selector T x hauto)

theorem AutomationEvidenceTheory_outputs :
    ∀ (M : CoreSemanticModel) (_ : M.AutomationEvidenceTheory) (x : M.ObjT),
      M.AutomationEvidenceIn x → M.reachTrig x ∧ ¬ M.extControl x (M.boundaryOf x) := by
  intro M T x hauto
  exact And.intro
    (M.AutomationEvidenceTheory_reachability T x hauto)
    (M.NoExternalSelectorIn_excludes_external_control x
      (M.AutomationEvidenceTheory_no_external_selector T x hauto))

def StaticOnlyEvidenceIn (M : CoreSemanticModel) (x : M.ObjT) : Prop :=
  M.staticOnly x

theorem StaticOnlyEvidenceIn_intro : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.staticOnly x → M.StaticOnlyEvidenceIn x := by
  intro M x hstaticOnly
  exact hstaticOnly

theorem StaticOnlyEvidenceIn_has_static_only : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.StaticOnlyEvidenceIn x → M.staticOnly x := by
  intro M x h
  exact h

def StaticOnlyStaticObligationIn (M : CoreSemanticModel) : Prop :=
  ∀ x : M.ObjT, M.StaticOnlyEvidenceIn x → M.staticPred x

def StaticOnlyNoDynamicObligationIn (M : CoreSemanticModel) : Prop :=
  ∀ x : M.ObjT, M.StaticOnlyEvidenceIn x → ¬ M.dyn x

theorem StaticOnlyStaticObligationIn_apply : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.StaticOnlyStaticObligationIn → M.StaticOnlyEvidenceIn x → M.staticPred x := by
  intro M x hobligation hstaticOnly
  exact hobligation x hstaticOnly

theorem StaticOnlyNoDynamicObligationIn_apply : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.StaticOnlyNoDynamicObligationIn → M.StaticOnlyEvidenceIn x → ¬ M.dyn x := by
  intro M x hobligation hstaticOnly
  exact hobligation x hstaticOnly

def PassiveChannelEvidenceIn (M : CoreSemanticModel) (x : M.ObjT) : Prop :=
  M.passiveChannel x

theorem PassiveChannelEvidenceIn_intro : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.passiveChannel x → M.PassiveChannelEvidenceIn x := by
  intro M x hpassive
  exact hpassive

theorem PassiveChannelEvidenceIn_has_passive_channel : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.PassiveChannelEvidenceIn x → M.passiveChannel x := by
  intro M x h
  exact h

def PassiveChannelNoDynamicObligationIn (M : CoreSemanticModel) : Prop :=
  ∀ x : M.ObjT, M.PassiveChannelEvidenceIn x → ¬ M.dyn x

theorem PassiveChannelNoDynamicObligationIn_apply : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.PassiveChannelNoDynamicObligationIn → M.PassiveChannelEvidenceIn x → ¬ M.dyn x := by
  intro M x hobligation hpassive
  exact hobligation x hpassive

def StaticNonstaticConflictIn (M : CoreSemanticModel) (x : M.ObjT) : Prop :=
  M.staticPred x ∧ M.nonStatic x

theorem StaticNonstaticConflictIn_intro : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.staticPred x → M.nonStatic x → M.StaticNonstaticConflictIn x := by
  intro M x hstatic hnonstatic
  exact ⟨hstatic, hnonstatic⟩

theorem StaticNonstaticConflictIn_has_static : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.StaticNonstaticConflictIn x → M.staticPred x := by
  intro M x h
  exact h.left

theorem StaticNonstaticConflictIn_has_non_static : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.StaticNonstaticConflictIn x → M.nonStatic x := by
  intro M x h
  exact h.right

def StaticNonstaticConflictExclusionObligationIn (M : CoreSemanticModel) : Prop :=
  ∀ x : M.ObjT, M.StaticNonstaticConflictIn x → False

theorem StaticNonstaticConflictExclusionObligationIn_apply : ∀ (M : CoreSemanticModel) (x : M.ObjT),
    M.StaticNonstaticConflictExclusionObligationIn → M.StaticNonstaticConflictIn x → False := by
  intro M x hobligation hconflict
  exact hobligation x hconflict

structure NonInflationTheory (M : CoreSemanticModel) where
  staticOnlyStatic : M.StaticOnlyStaticObligationIn
  staticOnlyNoDynamic : M.StaticOnlyNoDynamicObligationIn
  passiveChannelNoDynamic : M.PassiveChannelNoDynamicObligationIn
  staticNonstaticConflictExclusion : M.StaticNonstaticConflictExclusionObligationIn

theorem NonInflationTheory_static_only_static :
    ∀ (M : CoreSemanticModel) (_ : M.NonInflationTheory) (x : M.ObjT),
      M.StaticOnlyEvidenceIn x → M.staticPred x := by
  intro M T x hstaticOnly
  exact M.StaticOnlyStaticObligationIn_apply x T.staticOnlyStatic hstaticOnly

theorem NonInflationTheory_static_only_no_dynamic :
    ∀ (M : CoreSemanticModel) (_ : M.NonInflationTheory) (x : M.ObjT),
      M.StaticOnlyEvidenceIn x → ¬ M.dyn x := by
  intro M T x hstaticOnly
  exact M.StaticOnlyNoDynamicObligationIn_apply x T.staticOnlyNoDynamic hstaticOnly

theorem NonInflationTheory_passive_channel_no_dynamic :
    ∀ (M : CoreSemanticModel) (_ : M.NonInflationTheory) (x : M.ObjT),
      M.PassiveChannelEvidenceIn x → ¬ M.dyn x := by
  intro M T x hpassive
  exact M.PassiveChannelNoDynamicObligationIn_apply x T.passiveChannelNoDynamic hpassive

theorem NonInflationTheory_static_nonstatic_conflict_exclusion :
    ∀ (M : CoreSemanticModel) (_ : M.NonInflationTheory) (x : M.ObjT),
      M.StaticNonstaticConflictIn x → False := by
  intro M T x hconflict
  exact M.StaticNonstaticConflictExclusionObligationIn_apply x T.staticNonstaticConflictExclusion hconflict

theorem NonInflationTheory_static_only_outputs :
    ∀ (M : CoreSemanticModel) (_ : M.NonInflationTheory) (x : M.ObjT),
      M.StaticOnlyEvidenceIn x → M.staticPred x ∧ ¬ M.dyn x := by
  intro M T x hstaticOnly
  exact And.intro
    (M.NonInflationTheory_static_only_static T x hstaticOnly)
    (M.NonInflationTheory_static_only_no_dynamic T x hstaticOnly)

theorem NonInflationTheory_passive_channel_outputs :
    ∀ (M : CoreSemanticModel) (_ : M.NonInflationTheory) (x : M.ObjT),
      M.PassiveChannelEvidenceIn x → ¬ M.dyn x := by
  intro M T x hpassive
  exact M.NonInflationTheory_passive_channel_no_dynamic T x hpassive

theorem NonInflationTheory_static_nonstatic_conflict_outputs :
    ∀ (M : CoreSemanticModel) (_ : M.NonInflationTheory) (x : M.ObjT),
      M.StaticNonstaticConflictIn x → False := by
  intro M T x hconflict
  exact M.NonInflationTheory_static_nonstatic_conflict_exclusion T x hconflict

structure CoreSemanticTheory (M : CoreSemanticModel) where
  interfaceClosureIntro : M.InterfaceClosureIntroObligationIn
  interfaceClosureSoundness : M.InterfaceClosureSoundnessObligationIn
  structuralLiftInterface : M.StructuralLiftInterfaceObligationIn
  structuralLiftBoundaryIsolation : M.StructuralLiftBoundaryIsolationObligationIn
  piPathDomainClosure : M.PIPathDomainClosureObligationIn
  picDomainMeaningTyping : M.PICDomainMeaningTypingObligationIn
  eventDerivation : M.EventDerivationEvidenceTheory
  automation : M.AutomationEvidenceTheory
  nonInflation : M.NonInflationTheory

theorem CoreSemanticTheory_interface_closure_intro :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.InterfaceClosureInputIn x → M.ispace x := by
  intro M T x hinput
  exact M.InterfaceClosureIntroObligationIn_apply x T.interfaceClosureIntro hinput

theorem CoreSemanticTheory_interface_closure_soundness :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.ispace x → M.InterfaceClosureInputIn x := by
  intro M T x hispace
  exact M.InterfaceClosureSoundnessObligationIn_apply x T.interfaceClosureSoundness hispace

theorem CoreSemanticTheory_interface_closure_soundness_components :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.ispace x → M.preIspace x ∧ M.ValidIntComponentsIn x := by
  intro M T x hispace
  have hinput : M.InterfaceClosureInputIn x :=
    M.CoreSemanticTheory_interface_closure_soundness T x hispace
  exact ⟨
    M.InterfaceClosureInputIn_has_candidate x hinput,
    M.InterfaceClosureInputIn_has_valid_components x hinput
  ⟩

theorem CoreSemanticTheory_interface_closure_outputs :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.InterfaceClosureInputIn x → M.ispace x ∧ M.preIspace x ∧ M.ValidIntComponentsIn x := by
  intro M T x hinput
  exact ⟨
    M.CoreSemanticTheory_interface_closure_intro T x hinput,
    M.InterfaceClosureInputIn_has_candidate x hinput,
    M.InterfaceClosureInputIn_has_valid_components x hinput
  ⟩

theorem CoreSemanticTheory_structural_lift_interface :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (s : M.StructureT),
      M.StructuralLiftInputIn s → M.ispace (M.structObj s) := by
  intro M T s hinput
  exact M.StructuralLiftInterfaceObligationIn_apply s T.structuralLiftInterface hinput

theorem CoreSemanticTheory_structural_lift_boundary_isolation :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (s : M.StructureT),
      M.StructuralLiftInputIn s → M.boundaryIsolation s (M.boundaryOfStruct s) := by
  intro M T s hinput
  exact M.StructuralLiftBoundaryIsolationObligationIn_apply s T.structuralLiftBoundaryIsolation hinput

theorem CoreSemanticTheory_structural_lift_outputs :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (s : M.StructureT),
      M.StructuralLiftInputIn s →
        M.ispace (M.structObj s) ∧ M.boundaryIsolation s (M.boundaryOfStruct s) := by
  intro M T s hinput
  exact ⟨
    M.CoreSemanticTheory_structural_lift_interface T s hinput,
    M.CoreSemanticTheory_structural_lift_boundary_isolation T s hinput
  ⟩

theorem CoreSemanticTheory_pi_path_domain_closure :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.PIPathCoreIn x → M.domTMI x := by
  intro M T x hpath
  exact M.PIPathDomainClosureObligationIn_apply x T.piPathDomainClosure hpath

theorem CoreSemanticTheory_pic_domain_meaning_typing :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.PICTypedDomainIn x → M.typedInInterfaceDomain x := by
  intro M T x hinput
  exact M.PICDomainMeaningTypingObligationIn_apply x T.picDomainMeaningTyping hinput

theorem CoreSemanticTheory_pi_path_pic_typing :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.PIPathCoreIn x → M.typedInInterfaceDomain x := by
  intro M T x hpath
  have hdom : M.domTMI x :=
    M.CoreSemanticTheory_pi_path_domain_closure T x hpath
  have hmeaning : M.meaningful x :=
    M.PIPathCoreIn_has_meaning x hpath
  have hpict : M.PICTypedDomainIn x :=
    M.PICTypedDomainIn_intro x hdom hmeaning
  exact M.CoreSemanticTheory_pic_domain_meaning_typing T x hpict

theorem CoreSemanticTheory_event_observation_candidate_evidence :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (e : M.EventT) (x : M.ObjT) (t : M.TimeT),
      M.EventObservationIn e x t → M.CandidateEvidenceIn x := by
  intro M T e x t hobs
  exact M.EventDerivationEvidenceTheory_event_observation_candidate_evidence T.eventDerivation e x t hobs

theorem CoreSemanticTheory_event_observation_candidate :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (e : M.EventT) (x : M.ObjT) (t : M.TimeT),
      M.EventObservationIn e x t → M.preIspace x := by
  intro M T e x t hobs
  exact M.CandidateEvidenceIn_has_candidate x
    (M.CoreSemanticTheory_event_observation_candidate_evidence T e x t hobs)

theorem CoreSemanticTheory_event_observation_status_change_evidence :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (e : M.EventT) (x : M.ObjT) (t : M.TimeT),
      M.EventObservationIn e x t → M.StatusChangeEvidenceIn x := by
  intro M T e x t hobs
  exact M.EventDerivationEvidenceTheory_event_observation_status_change_evidence T.eventDerivation e x t hobs

theorem CoreSemanticTheory_event_observation_status_change :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (e : M.EventT) (x : M.ObjT) (t : M.TimeT),
      M.EventObservationIn e x t → M.statusChanged x := by
  intro M T e x t hobs
  exact M.StatusChangeEvidenceIn_has_status_change x
    (M.CoreSemanticTheory_event_observation_status_change_evidence T e x t hobs)

theorem CoreSemanticTheory_event_observation_evidence :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (e : M.EventT) (x : M.ObjT) (t : M.TimeT),
      M.EventObservationIn e x t → M.CandidateEvidenceIn x ∧ M.StatusChangeEvidenceIn x := by
  intro M T e x t hobs
  exact M.EventDerivationEvidenceTheory_event_observation_evidence T.eventDerivation e x t hobs

theorem CoreSemanticTheory_event_observation_outputs :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (e : M.EventT) (x : M.ObjT) (t : M.TimeT),
      M.EventObservationIn e x t → M.preIspace x ∧ M.statusChanged x := by
  intro M T e x t hobs
  exact M.EventDerivationEvidenceTheory_event_observation_outputs T.eventDerivation e x t hobs

theorem CoreSemanticTheory_primary_derivation_candidate_evidence :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.PrimaryDerivationIn x → M.CandidateEvidenceIn x := by
  intro M T x hder
  exact M.EventDerivationEvidenceTheory_primary_derivation_candidate_evidence T.eventDerivation x hder

theorem CoreSemanticTheory_primary_derivation_candidate :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.PrimaryDerivationIn x → M.preIspace x := by
  intro M T x hder
  exact M.CandidateEvidenceIn_has_candidate x
    (M.CoreSemanticTheory_primary_derivation_candidate_evidence T x hder)

theorem CoreSemanticTheory_primary_derivation_evidence :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.PrimaryDerivationIn x → M.CandidateEvidenceIn x := by
  intro M T x hder
  exact M.CoreSemanticTheory_primary_derivation_candidate_evidence T x hder

theorem CoreSemanticTheory_primary_derivation_outputs :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.PrimaryDerivationIn x → M.preIspace x := by
  intro M T x hder
  exact M.CoreSemanticTheory_primary_derivation_candidate T x hder

theorem CoreSemanticTheory_automation_reachable_trigger :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.AutomationEvidenceIn x → M.ReachableTriggerIn x := by
  intro M T x hauto
  exact M.AutomationEvidenceTheory_reachable_trigger T.automation x hauto

theorem CoreSemanticTheory_automation_reachability :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.AutomationEvidenceIn x → M.reachTrig x := by
  intro M T x hauto
  exact M.ReachableTriggerIn_has_reach_trigger x
    (M.CoreSemanticTheory_automation_reachable_trigger T x hauto)

theorem CoreSemanticTheory_automation_no_external_selector :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.AutomationEvidenceIn x → M.NoExternalSelectorIn x := by
  intro M T x hauto
  exact M.AutomationEvidenceTheory_no_external_selector T.automation x hauto

theorem CoreSemanticTheory_automation_excludes_external_control :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.AutomationEvidenceIn x → ¬ M.extControl x (M.boundaryOf x) := by
  intro M T x hauto
  exact M.NoExternalSelectorIn_excludes_external_control x
    (M.CoreSemanticTheory_automation_no_external_selector T x hauto)

theorem CoreSemanticTheory_automation_evidence :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.AutomationEvidenceIn x → M.ReachableTriggerIn x ∧ M.NoExternalSelectorIn x := by
  intro M T x hauto
  exact M.AutomationEvidenceTheory_evidence T.automation x hauto

theorem CoreSemanticTheory_automation_outputs :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.AutomationEvidenceIn x → M.reachTrig x ∧ ¬ M.extControl x (M.boundaryOf x) := by
  intro M T x hauto
  exact M.AutomationEvidenceTheory_outputs T.automation x hauto

theorem CoreSemanticTheory_external_control_excludes_valid_components :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.extControl x (M.boundaryOf x) → ¬ M.ValidIntComponentsIn x := by
  intro M T x hext hcomponents
  have hauto : M.autoBox x :=
    M.ValidIntComponentsIn_has_auto_box x hcomponents
  have hevidence : M.AutomationEvidenceIn x :=
    M.AutomationEvidenceIn_intro x hauto
  exact (M.CoreSemanticTheory_automation_excludes_external_control T x hevidence) hext

theorem CoreSemanticTheory_static_only_static :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.StaticOnlyEvidenceIn x → M.staticPred x := by
  intro M T x hstaticOnly
  exact M.NonInflationTheory_static_only_static T.nonInflation x hstaticOnly

theorem CoreSemanticTheory_static_only_no_dynamic :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.StaticOnlyEvidenceIn x → ¬ M.dyn x := by
  intro M T x hstaticOnly
  exact M.NonInflationTheory_static_only_no_dynamic T.nonInflation x hstaticOnly

theorem CoreSemanticTheory_passive_channel_no_dynamic :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.PassiveChannelEvidenceIn x → ¬ M.dyn x := by
  intro M T x hpassive
  exact M.NonInflationTheory_passive_channel_no_dynamic T.nonInflation x hpassive

theorem CoreSemanticTheory_static_nonstatic_conflict_exclusion :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.StaticNonstaticConflictIn x → False := by
  intro M T x hconflict
  exact M.NonInflationTheory_static_nonstatic_conflict_exclusion T.nonInflation x hconflict

theorem CoreSemanticTheory_static_only_excludes_ispace :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.StaticOnlyEvidenceIn x → ¬ M.ispace x := by
  intro M T x hstaticOnly hispace
  have hstatic : M.staticPred x :=
    M.CoreSemanticTheory_static_only_static T x hstaticOnly
  have hcomponents : M.preIspace x ∧ M.ValidIntComponentsIn x :=
    M.CoreSemanticTheory_interface_closure_soundness_components T x hispace
  have hnonstatic : M.nonStatic x :=
    M.ValidIntComponentsIn_has_non_static x hcomponents.right
  have hconflict : M.StaticNonstaticConflictIn x :=
    M.StaticNonstaticConflictIn_intro x hstatic hnonstatic
  exact M.CoreSemanticTheory_static_nonstatic_conflict_exclusion T x hconflict

theorem CoreSemanticTheory_passive_channel_excludes_ispace :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.PassiveChannelEvidenceIn x → ¬ M.ispace x := by
  intro M T x hpassive hispace
  have hnotdyn : ¬ M.dyn x :=
    M.CoreSemanticTheory_passive_channel_no_dynamic T x hpassive
  have hcomponents : M.preIspace x ∧ M.ValidIntComponentsIn x :=
    M.CoreSemanticTheory_interface_closure_soundness_components T x hispace
  have hdyn : M.dyn x :=
    M.ValidIntComponentsIn_has_dyn x hcomponents.right
  exact hnotdyn hdyn

theorem CoreSemanticTheory_static_only_outputs :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.StaticOnlyEvidenceIn x → M.staticPred x ∧ ¬ M.dyn x ∧ ¬ M.ispace x := by
  intro M T x hstaticOnly
  exact And.intro
    (M.CoreSemanticTheory_static_only_static T x hstaticOnly)
    (And.intro
      (M.CoreSemanticTheory_static_only_no_dynamic T x hstaticOnly)
      (M.CoreSemanticTheory_static_only_excludes_ispace T x hstaticOnly))

theorem CoreSemanticTheory_passive_channel_outputs :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.PassiveChannelEvidenceIn x → ¬ M.dyn x ∧ ¬ M.ispace x := by
  intro M T x hpassive
  exact And.intro
    (M.CoreSemanticTheory_passive_channel_no_dynamic T x hpassive)
    (M.CoreSemanticTheory_passive_channel_excludes_ispace T x hpassive)

theorem CoreSemanticTheory_static_nonstatic_conflict_outputs :
    ∀ (M : CoreSemanticModel) (_ : M.CoreSemanticTheory) (x : M.ObjT),
      M.StaticNonstaticConflictIn x → False := by
  intro M T x hconflict
  exact M.CoreSemanticTheory_static_nonstatic_conflict_exclusion T x hconflict

structure RoleInterfaceTheory (M : CoreSemanticModel) where
  soundness : M.InterfaceRoleSoundnessObligationIn
  completeness : M.InterfaceRoleCompletenessObligationIn

theorem RoleInterfaceTheory_soundness :
    ∀ (M : CoreSemanticModel) (_ : M.RoleInterfaceTheory) (x : M.ObjT),
      M.InterfaceRoleTypingIn x → M.ispace x := by
  intro M T x hrole
  exact M.InterfaceRoleSoundnessObligationIn_apply x T.soundness hrole

theorem RoleInterfaceTheory_completeness :
    ∀ (M : CoreSemanticModel) (_ : M.RoleInterfaceTheory) (x : M.ObjT),
      M.ispace x → M.InterfaceRoleTypingIn x := by
  intro M T x hispace
  exact M.InterfaceRoleCompletenessObligationIn_apply x T.completeness hispace

structure FullCoreSemanticTheory (M : CoreSemanticModel) where
  core : M.CoreSemanticTheory
  roleInterface : M.RoleInterfaceTheory

theorem FullCoreSemanticTheory_core :
    ∀ (M : CoreSemanticModel), M.FullCoreSemanticTheory → M.CoreSemanticTheory := by
  intro M T
  exact T.core

theorem FullCoreSemanticTheory_role_interface :
    ∀ (M : CoreSemanticModel), M.FullCoreSemanticTheory → M.RoleInterfaceTheory := by
  intro M T
  exact T.roleInterface

theorem FullCoreSemanticTheory_interface_closure_intro :
    ∀ (M : CoreSemanticModel) (_ : M.FullCoreSemanticTheory) (x : M.ObjT),
      M.InterfaceClosureInputIn x → M.ispace x := by
  intro M T x hinput
  exact M.CoreSemanticTheory_interface_closure_intro T.core x hinput

theorem FullCoreSemanticTheory_interface_closure_soundness :
    ∀ (M : CoreSemanticModel) (_ : M.FullCoreSemanticTheory) (x : M.ObjT),
      M.ispace x → M.InterfaceClosureInputIn x := by
  intro M T x hispace
  exact M.CoreSemanticTheory_interface_closure_soundness T.core x hispace

theorem FullCoreSemanticTheory_interface_closure_soundness_components :
    ∀ (M : CoreSemanticModel) (_ : M.FullCoreSemanticTheory) (x : M.ObjT),
      M.ispace x → M.preIspace x ∧ M.ValidIntComponentsIn x := by
  intro M T x hispace
  exact M.CoreSemanticTheory_interface_closure_soundness_components T.core x hispace

theorem FullCoreSemanticTheory_role_soundness :
    ∀ (M : CoreSemanticModel) (_ : M.FullCoreSemanticTheory) (x : M.ObjT),
      M.InterfaceRoleTypingIn x → M.ispace x := by
  intro M T x hrole
  exact M.RoleInterfaceTheory_soundness T.roleInterface x hrole

theorem FullCoreSemanticTheory_role_completeness :
    ∀ (M : CoreSemanticModel) (_ : M.FullCoreSemanticTheory) (x : M.ObjT),
      M.ispace x → M.InterfaceRoleTypingIn x := by
  intro M T x hispace
  exact M.RoleInterfaceTheory_completeness T.roleInterface x hispace

theorem FullCoreSemanticTheory_role_interface_closure_soundness :
    ∀ (M : CoreSemanticModel) (_ : M.FullCoreSemanticTheory) (x : M.ObjT),
      M.InterfaceRoleTypingIn x → M.InterfaceClosureInputIn x := by
  intro M T x hrole
  have hispace : M.ispace x :=
    M.FullCoreSemanticTheory_role_soundness T x hrole
  exact M.FullCoreSemanticTheory_interface_closure_soundness T x hispace

end CoreSemanticModel

noncomputable def AxiomShellModel : CoreSemanticModel where
  ObjT := Obj
  EventT := Event
  TimeT := Time
  BoundaryT := Boundary
  StructureT := Structure
  RoleT := Role
  primaryI0 := primaryI0
  der := Der
  preIspace := PreIspace
  ispace := Ispace
  validStr := ValidStr
  dyn := Dyn
  staticPred := Static
  nonStatic := NonStatic
  autoBox := AutoBox
  reachTrig := ReachTrig
  extControl := ExtControl
  boundaryOf := BoundaryOf
  causalFrame := CausalFrame
  integrated := Integrated
  absoluteIsolation := AbsoluteIsolation
  staticOnly := StaticOnly
  passiveChannel := PassiveChannel
  eventAt := EventAt
  statusChanged := StatusChanged
  preInterfaceStructure := PreInterfaceStructure
  interfaceStructure := InterfaceStructure
  inStructure := InStructure
  structurallyLinked := StructurallyLinked
  maxStruct := MaxStruct
  structLift := StructLift
  boundaryOfStruct := BoundaryOfStruct
  boundaryIsolation := BoundaryIsolation
  structObj := StructObj
  domTMI := DomTMI
  meaningful := Meaningful
  distinguishable := Distinguishable
  typedInInterfaceDomain := TypedInInterfaceDomain
  typedAs := TypedAs
  roleInterface := roleInterface

noncomputable def AxiomShellTheory : AxiomShellModel.CoreSemanticTheory where
  interfaceClosureIntro := by
    intro x hinput
    exact InterfaceClosure_intro_obligation x hinput
  interfaceClosureSoundness := by
    intro x hispace
    exact InterfaceClosure_soundness_obligation x hispace
  structuralLiftInterface := by
    intro s hinput
    exact StructuralLift_interface_obligation s hinput
  structuralLiftBoundaryIsolation := by
    intro s hinput
    exact StructuralLift_boundary_isolation_obligation s hinput
  piPathDomainClosure := by
    intro x hpath
    exact PIPath_domain_membership_obligation x hpath
  picDomainMeaningTyping := by
    intro x hinput
    exact PICTypedDomain_interface_typing_obligation x hinput
  eventDerivation := {
    eventObservationCandidate := by
      intro e x t hobs
      exact EventObservation_candidate_obligation e x t hobs
    eventObservationStatusChange := by
      intro e x t hobs
      exact EventObservation_status_change_obligation e x t hobs
    primaryDerivationCandidate := by
      intro x hder
      exact PrimaryDerivation_candidate_obligation x hder
  }
  automation := {
    reachability := by
      intro x hauto
      exact AutomationEvidence_reachability_obligation x hauto
    noExternalSelector := by
      intro x hauto
      exact AutomationEvidence_no_external_selector_obligation x hauto
  }
  nonInflation := {
    staticOnlyStatic := by
      intro x hstaticOnly
      exact StaticOnly_static_obligation x hstaticOnly
    staticOnlyNoDynamic := by
      intro x hstaticOnly
      exact StaticOnly_no_dynamic_obligation x hstaticOnly
    passiveChannelNoDynamic := by
      intro x hpassive
      exact PassiveChannel_no_dynamic_obligation x hpassive
    staticNonstaticConflictExclusion := by
      intro x hconflict
      exact StaticNonstaticConflict_exclusion_obligation x hconflict
  }

noncomputable def AxiomShellRoleInterfaceTheory : AxiomShellModel.RoleInterfaceTheory where
  soundness := by
    intro x hrole
    exact InterfaceRoleTyping_soundness_obligation x hrole
  completeness := by
    intro x hispace
    exact InterfaceRoleTyping_completeness_obligation x hispace

noncomputable def AxiomShellFullCoreSemanticTheory : AxiomShellModel.FullCoreSemanticTheory where
  core := AxiomShellTheory
  roleInterface := AxiomShellRoleInterfaceTheory

theorem AxiomShellTheory_interface_closure_intro : ∀ x : Obj,
    AxiomShellModel.InterfaceClosureInputIn x → Ispace x := by
  intro x hinput
  exact CoreSemanticModel.CoreSemanticTheory_interface_closure_intro
    AxiomShellModel
    AxiomShellTheory
    x
    hinput

theorem AxiomShellTheory_interface_closure_soundness : ∀ x : Obj,
    Ispace x → AxiomShellModel.InterfaceClosureInputIn x := by
  intro x hispace
  exact CoreSemanticModel.CoreSemanticTheory_interface_closure_soundness
    AxiomShellModel
    AxiomShellTheory
    x
    hispace

theorem AxiomShellTheory_interface_closure_soundness_components : ∀ x : Obj,
    Ispace x → PreIspace x ∧ ValidIntComponents x := by
  intro x hispace
  exact CoreSemanticModel.CoreSemanticTheory_interface_closure_soundness_components
    AxiomShellModel
    AxiomShellTheory
    x
    hispace

theorem AxiomShellTheory_interface_closure_outputs : ∀ x : Obj,
    AxiomShellModel.InterfaceClosureInputIn x → Ispace x ∧ PreIspace x ∧ ValidIntComponents x := by
  intro x hinput
  exact CoreSemanticModel.CoreSemanticTheory_interface_closure_outputs
    AxiomShellModel
    AxiomShellTheory
    x
    hinput

theorem AxiomShellTheory_structural_lift_interface : ∀ s : Structure,
    AxiomShellModel.StructuralLiftInputIn s → Ispace (StructObj s) := by
  intro s hinput
  exact CoreSemanticModel.CoreSemanticTheory_structural_lift_interface
    AxiomShellModel
    AxiomShellTheory
    s
    hinput

theorem AxiomShellTheory_structural_lift_boundary_isolation : ∀ s : Structure,
    AxiomShellModel.StructuralLiftInputIn s → BoundaryIsolation s (BoundaryOfStruct s) := by
  intro s hinput
  exact CoreSemanticModel.CoreSemanticTheory_structural_lift_boundary_isolation
    AxiomShellModel
    AxiomShellTheory
    s
    hinput

theorem AxiomShellTheory_structural_lift_outputs : ∀ s : Structure,
    AxiomShellModel.StructuralLiftInputIn s →
      Ispace (StructObj s) ∧ BoundaryIsolation s (BoundaryOfStruct s) := by
  intro s hinput
  exact CoreSemanticModel.CoreSemanticTheory_structural_lift_outputs
    AxiomShellModel
    AxiomShellTheory
    s
    hinput

theorem AxiomShellTheory_pi_path_domain_closure : ∀ x : Obj,
    AxiomShellModel.PIPathCoreIn x → DomTMI x := by
  intro x hpath
  exact CoreSemanticModel.CoreSemanticTheory_pi_path_domain_closure
    AxiomShellModel
    AxiomShellTheory
    x
    hpath

theorem AxiomShellTheory_pic_domain_meaning_typing : ∀ x : Obj,
    AxiomShellModel.PICTypedDomainIn x → TypedInInterfaceDomain x := by
  intro x hinput
  exact CoreSemanticModel.CoreSemanticTheory_pic_domain_meaning_typing
    AxiomShellModel
    AxiomShellTheory
    x
    hinput

theorem AxiomShellTheory_pi_path_pic_typing : ∀ x : Obj,
    AxiomShellModel.PIPathCoreIn x → TypedInInterfaceDomain x := by
  intro x hpath
  exact CoreSemanticModel.CoreSemanticTheory_pi_path_pic_typing
    AxiomShellModel
    AxiomShellTheory
    x
    hpath

theorem AxiomShellTheory_event_observation_candidate_evidence : ∀ (e : Event) (x : Obj) (t : Time),
    AxiomShellModel.EventObservationIn e x t → AxiomShellModel.CandidateEvidenceIn x := by
  intro e x t hobs
  exact CoreSemanticModel.CoreSemanticTheory_event_observation_candidate_evidence
    AxiomShellModel
    AxiomShellTheory
    e
    x
    t
    hobs

theorem AxiomShellTheory_event_observation_candidate : ∀ (e : Event) (x : Obj) (t : Time),
    AxiomShellModel.EventObservationIn e x t → PreIspace x := by
  intro e x t hobs
  exact CoreSemanticModel.CandidateEvidenceIn_has_candidate AxiomShellModel x
    (AxiomShellTheory_event_observation_candidate_evidence e x t hobs)

theorem AxiomShellTheory_event_observation_status_change_evidence : ∀ (e : Event) (x : Obj) (t : Time),
    AxiomShellModel.EventObservationIn e x t → AxiomShellModel.StatusChangeEvidenceIn x := by
  intro e x t hobs
  exact CoreSemanticModel.CoreSemanticTheory_event_observation_status_change_evidence
    AxiomShellModel
    AxiomShellTheory
    e
    x
    t
    hobs

theorem AxiomShellTheory_event_observation_status_change : ∀ (e : Event) (x : Obj) (t : Time),
    AxiomShellModel.EventObservationIn e x t → StatusChanged x := by
  intro e x t hobs
  exact CoreSemanticModel.StatusChangeEvidenceIn_has_status_change AxiomShellModel x
    (AxiomShellTheory_event_observation_status_change_evidence e x t hobs)

theorem AxiomShellTheory_event_observation_evidence : ∀ (e : Event) (x : Obj) (t : Time),
    AxiomShellModel.EventObservationIn e x t →
      AxiomShellModel.CandidateEvidenceIn x ∧ AxiomShellModel.StatusChangeEvidenceIn x := by
  intro e x t hobs
  exact CoreSemanticModel.CoreSemanticTheory_event_observation_evidence
    AxiomShellModel
    AxiomShellTheory
    e
    x
    t
    hobs

theorem AxiomShellTheory_event_observation_outputs : ∀ (e : Event) (x : Obj) (t : Time),
    AxiomShellModel.EventObservationIn e x t → PreIspace x ∧ StatusChanged x := by
  intro e x t hobs
  exact CoreSemanticModel.CoreSemanticTheory_event_observation_outputs
    AxiomShellModel
    AxiomShellTheory
    e
    x
    t
    hobs

theorem AxiomShellTheory_primary_derivation_candidate_evidence : ∀ x : Obj,
    AxiomShellModel.PrimaryDerivationIn x → AxiomShellModel.CandidateEvidenceIn x := by
  intro x hder
  exact CoreSemanticModel.CoreSemanticTheory_primary_derivation_candidate_evidence
    AxiomShellModel
    AxiomShellTheory
    x
    hder

theorem AxiomShellTheory_primary_derivation_candidate : ∀ x : Obj,
    AxiomShellModel.PrimaryDerivationIn x → PreIspace x := by
  intro x hder
  exact CoreSemanticModel.CandidateEvidenceIn_has_candidate AxiomShellModel x
    (AxiomShellTheory_primary_derivation_candidate_evidence x hder)

theorem AxiomShellTheory_primary_derivation_evidence : ∀ x : Obj,
    AxiomShellModel.PrimaryDerivationIn x → AxiomShellModel.CandidateEvidenceIn x := by
  intro x hder
  exact AxiomShellTheory_primary_derivation_candidate_evidence x hder

theorem AxiomShellTheory_primary_derivation_outputs : ∀ x : Obj,
    AxiomShellModel.PrimaryDerivationIn x → PreIspace x := by
  intro x hder
  exact AxiomShellTheory_primary_derivation_candidate x hder

theorem AxiomShellTheory_automation_reachable_trigger : ∀ x : Obj,
    AxiomShellModel.AutomationEvidenceIn x → AxiomShellModel.ReachableTriggerIn x := by
  intro x hauto
  exact CoreSemanticModel.CoreSemanticTheory_automation_reachable_trigger
    AxiomShellModel
    AxiomShellTheory
    x
    hauto

theorem AxiomShellTheory_automation_reachability : ∀ x : Obj,
    AxiomShellModel.AutomationEvidenceIn x → ReachTrig x := by
  intro x hauto
  exact CoreSemanticModel.ReachableTriggerIn_has_reach_trigger AxiomShellModel x
    (AxiomShellTheory_automation_reachable_trigger x hauto)

theorem AxiomShellTheory_automation_no_external_selector : ∀ x : Obj,
    AxiomShellModel.AutomationEvidenceIn x → AxiomShellModel.NoExternalSelectorIn x := by
  intro x hauto
  exact CoreSemanticModel.CoreSemanticTheory_automation_no_external_selector
    AxiomShellModel
    AxiomShellTheory
    x
    hauto

theorem AxiomShellTheory_automation_excludes_external_control : ∀ x : Obj,
    AxiomShellModel.AutomationEvidenceIn x → ¬ ExtControl x (BoundaryOf x) := by
  intro x hauto
  exact CoreSemanticModel.CoreSemanticTheory_automation_excludes_external_control
    AxiomShellModel
    AxiomShellTheory
    x
    hauto

theorem AxiomShellTheory_automation_evidence : ∀ x : Obj,
    AxiomShellModel.AutomationEvidenceIn x →
      AxiomShellModel.ReachableTriggerIn x ∧ AxiomShellModel.NoExternalSelectorIn x := by
  intro x hauto
  exact CoreSemanticModel.CoreSemanticTheory_automation_evidence
    AxiomShellModel
    AxiomShellTheory
    x
    hauto

theorem AxiomShellTheory_automation_outputs : ∀ x : Obj,
    AxiomShellModel.AutomationEvidenceIn x → ReachTrig x ∧ ¬ ExtControl x (BoundaryOf x) := by
  intro x hauto
  exact CoreSemanticModel.CoreSemanticTheory_automation_outputs
    AxiomShellModel
    AxiomShellTheory
    x
    hauto

theorem AxiomShellTheory_external_control_excludes_valid_components : ∀ x : Obj,
    ExtControl x (BoundaryOf x) → ¬ AxiomShellModel.ValidIntComponentsIn x := by
  intro x hext
  exact CoreSemanticModel.CoreSemanticTheory_external_control_excludes_valid_components
    AxiomShellModel
    AxiomShellTheory
    x
    hext

theorem AxiomShellTheory_external_control_excludes_valid_int : ∀ x : Obj,
    ExtControl x (BoundaryOf x) → ¬ ValidInt x := by
  intro x hext hvalid
  have hcomponents : AxiomShellModel.ValidIntComponentsIn x :=
    (ValidInt_iff_components x).mp hvalid
  exact AxiomShellTheory_external_control_excludes_valid_components x hext hcomponents

theorem AxiomShellTheory_external_control_excludes_ispace : ∀ x : Obj,
    ExtControl x (BoundaryOf x) → ¬ Ispace x := by
  intro x hext hispace
  have hcomponents : PreIspace x ∧ AxiomShellModel.ValidIntComponentsIn x :=
    AxiomShellTheory_interface_closure_soundness_components x hispace
  exact AxiomShellTheory_external_control_excludes_valid_components x hext hcomponents.right

theorem AxiomShellTheory_external_control_outputs : ∀ x : Obj,
    ExtControl x (BoundaryOf x) → ¬ ValidInt x ∧ ¬ Ispace x := by
  intro x hext
  exact ⟨
    AxiomShellTheory_external_control_excludes_valid_int x hext,
    AxiomShellTheory_external_control_excludes_ispace x hext
  ⟩

theorem AxiomShellTheory_static_only_static : ∀ x : Obj,
    AxiomShellModel.StaticOnlyEvidenceIn x → Static x := by
  intro x hstaticOnly
  exact CoreSemanticModel.CoreSemanticTheory_static_only_static
    AxiomShellModel
    AxiomShellTheory
    x
    hstaticOnly

theorem AxiomShellTheory_static_only_no_dynamic : ∀ x : Obj,
    AxiomShellModel.StaticOnlyEvidenceIn x → ¬ Dyn x := by
  intro x hstaticOnly
  exact CoreSemanticModel.CoreSemanticTheory_static_only_no_dynamic
    AxiomShellModel
    AxiomShellTheory
    x
    hstaticOnly

theorem AxiomShellTheory_passive_channel_no_dynamic : ∀ x : Obj,
    AxiomShellModel.PassiveChannelEvidenceIn x → ¬ Dyn x := by
  intro x hpassive
  exact CoreSemanticModel.CoreSemanticTheory_passive_channel_no_dynamic
    AxiomShellModel
    AxiomShellTheory
    x
    hpassive

theorem AxiomShellTheory_static_nonstatic_conflict_exclusion : ∀ x : Obj,
    AxiomShellModel.StaticNonstaticConflictIn x → False := by
  intro x hconflict
  exact CoreSemanticModel.CoreSemanticTheory_static_nonstatic_conflict_exclusion
    AxiomShellModel
    AxiomShellTheory
    x
    hconflict

theorem AxiomShellTheory_static_only_excludes_ispace : ∀ x : Obj,
    AxiomShellModel.StaticOnlyEvidenceIn x → ¬ Ispace x := by
  intro x hstaticOnly
  exact CoreSemanticModel.CoreSemanticTheory_static_only_excludes_ispace
    AxiomShellModel
    AxiomShellTheory
    x
    hstaticOnly

theorem AxiomShellTheory_passive_channel_excludes_ispace : ∀ x : Obj,
    AxiomShellModel.PassiveChannelEvidenceIn x → ¬ Ispace x := by
  intro x hpassive
  exact CoreSemanticModel.CoreSemanticTheory_passive_channel_excludes_ispace
    AxiomShellModel
    AxiomShellTheory
    x
    hpassive

theorem AxiomShellTheory_static_only_outputs : ∀ x : Obj,
    AxiomShellModel.StaticOnlyEvidenceIn x → Static x ∧ ¬ Dyn x ∧ ¬ Ispace x := by
  intro x hstaticOnly
  exact CoreSemanticModel.CoreSemanticTheory_static_only_outputs
    AxiomShellModel
    AxiomShellTheory
    x
    hstaticOnly

theorem AxiomShellTheory_passive_channel_outputs : ∀ x : Obj,
    AxiomShellModel.PassiveChannelEvidenceIn x → ¬ Dyn x ∧ ¬ Ispace x := by
  intro x hpassive
  exact CoreSemanticModel.CoreSemanticTheory_passive_channel_outputs
    AxiomShellModel
    AxiomShellTheory
    x
    hpassive

theorem AxiomShellTheory_static_nonstatic_conflict_outputs : ∀ x : Obj,
    AxiomShellModel.StaticNonstaticConflictIn x → False := by
  intro x hconflict
  exact CoreSemanticModel.CoreSemanticTheory_static_nonstatic_conflict_outputs
    AxiomShellModel
    AxiomShellTheory
    x
    hconflict

theorem AxiomShellRoleInterfaceTheory_soundness : ∀ x : Obj,
    AxiomShellModel.InterfaceRoleTypingIn x → Ispace x := by
  intro x hrole
  exact CoreSemanticModel.RoleInterfaceTheory_soundness
    AxiomShellModel
    AxiomShellRoleInterfaceTheory
    x
    hrole

theorem AxiomShellRoleInterfaceTheory_completeness : ∀ x : Obj,
    Ispace x → AxiomShellModel.InterfaceRoleTypingIn x := by
  intro x hispace
  exact CoreSemanticModel.RoleInterfaceTheory_completeness
    AxiomShellModel
    AxiomShellRoleInterfaceTheory
    x
    hispace

theorem AxiomShellRoleInterfaceTheory_typing_soundness : ∀ x : Obj,
    TypedAs x roleInterface → Ispace x := by
  intro x htyped
  exact AxiomShellRoleInterfaceTheory_soundness x htyped

theorem AxiomShellRoleInterfaceTheory_typing_completeness : ∀ x : Obj,
    Ispace x → TypedAs x roleInterface := by
  intro x hispace
  exact CoreSemanticModel.InterfaceRoleTypingIn_has_role_typing
    AxiomShellModel
    x
    (AxiomShellRoleInterfaceTheory_completeness x hispace)

theorem AxiomShellFullCoreSemanticTheory_core :
    AxiomShellModel.CoreSemanticTheory := by
  exact CoreSemanticModel.FullCoreSemanticTheory_core
    AxiomShellModel
    AxiomShellFullCoreSemanticTheory

theorem AxiomShellFullCoreSemanticTheory_role_interface :
    AxiomShellModel.RoleInterfaceTheory := by
  exact CoreSemanticModel.FullCoreSemanticTheory_role_interface
    AxiomShellModel
    AxiomShellFullCoreSemanticTheory

theorem AxiomShellFullCoreSemanticTheory_interface_closure_intro : ∀ x : Obj,
    AxiomShellModel.InterfaceClosureInputIn x → Ispace x := by
  intro x hinput
  exact CoreSemanticModel.FullCoreSemanticTheory_interface_closure_intro
    AxiomShellModel
    AxiomShellFullCoreSemanticTheory
    x
    hinput

theorem AxiomShellFullCoreSemanticTheory_interface_closure_soundness : ∀ x : Obj,
    Ispace x → AxiomShellModel.InterfaceClosureInputIn x := by
  intro x hispace
  exact CoreSemanticModel.FullCoreSemanticTheory_interface_closure_soundness
    AxiomShellModel
    AxiomShellFullCoreSemanticTheory
    x
    hispace

theorem AxiomShellFullCoreSemanticTheory_interface_closure_soundness_components : ∀ x : Obj,
    Ispace x → PreIspace x ∧ ValidIntComponents x := by
  intro x hispace
  exact CoreSemanticModel.FullCoreSemanticTheory_interface_closure_soundness_components
    AxiomShellModel
    AxiomShellFullCoreSemanticTheory
    x
    hispace

theorem AxiomShellFullCoreSemanticTheory_role_soundness : ∀ x : Obj,
    AxiomShellModel.InterfaceRoleTypingIn x → Ispace x := by
  intro x hrole
  exact CoreSemanticModel.FullCoreSemanticTheory_role_soundness
    AxiomShellModel
    AxiomShellFullCoreSemanticTheory
    x
    hrole

theorem AxiomShellFullCoreSemanticTheory_role_completeness : ∀ x : Obj,
    Ispace x → AxiomShellModel.InterfaceRoleTypingIn x := by
  intro x hispace
  exact CoreSemanticModel.FullCoreSemanticTheory_role_completeness
    AxiomShellModel
    AxiomShellFullCoreSemanticTheory
    x
    hispace

theorem AxiomShellFullCoreSemanticTheory_role_interface_closure_soundness : ∀ x : Obj,
    AxiomShellModel.InterfaceRoleTypingIn x → AxiomShellModel.InterfaceClosureInputIn x := by
  intro x hrole
  exact CoreSemanticModel.FullCoreSemanticTheory_role_interface_closure_soundness
    AxiomShellModel
    AxiomShellFullCoreSemanticTheory
    x
    hrole

end Core
end TMI
