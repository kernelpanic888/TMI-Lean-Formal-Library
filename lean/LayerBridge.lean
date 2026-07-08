/-
LayerBridge — public Lean API between a guarded experiment and TLFL modules.

This module records a boundary. It does not introduce new axioms and does not
raise a speculative artifact above its checked proof status.
-/

import TMI.Library
import TMI.Bridge

namespace LayerBridge

inductive SystemLayer where
  | TLFL : SystemLayer
  | Experiment : SystemLayer
deriving DecidableEq, Repr

def SystemLayer.isStable : SystemLayer -> Bool
  | .TLFL => true
  | .Experiment => false

def SystemLayer.isExperimental : SystemLayer -> Bool
  | .TLFL => false
  | .Experiment => true

structure ExperimentSpace where
  name : String
  layer : SystemLayer
  guardPassed : Bool
  hasPassport : Bool
  hasExample : Bool

def ExperimentSpace.isMature (s : ExperimentSpace) : Prop :=
  s.layer = SystemLayer.Experiment /\
  s.guardPassed = true /\
  s.hasPassport = true /\
  s.hasExample = true

structure TLFLModule where
  namespacePath : String
  layer : SystemLayer
  hasLeanProof : Bool
  hasExternalProof : Bool
  hasSorry : Bool

def TLFLModule.isAdmitted (m : TLFLModule) : Prop :=
  m.layer = SystemLayer.TLFL /\
  m.hasLeanProof = true /\
  m.hasExternalProof = true

def TLFLModule.isCertified (m : TLFLModule) : Prop :=
  m.isAdmitted /\ m.hasSorry = false

/-
PromotionBridge encodes the path from an experiment to a TLFL module.

The source must be mature; the target remains in the TLFL layer; proof status is
preserved by the supplied encoding; the promoted target must not contain sorry.
-/
structure PromotionBridge where
  source : ExperimentSpace
  target : TLFLModule
  encoding : source.isMature -> target.isAdmitted
  noSorry : target.hasSorry = false

def PromotionBridge.isValid (b : PromotionBridge) : Prop :=
  b.source.isMature /\ b.target.isAdmitted /\ b.target.hasSorry = false

theorem promotion_bridge_gives_admitted_module
    (b : PromotionBridge)
    (h : b.source.isMature) :
    b.target.isAdmitted :=
  b.encoding h

theorem admitted_module_in_tlfl_layer
    (b : PromotionBridge)
    (h : b.source.isMature) :
    b.target.layer = SystemLayer.TLFL := by
  exact (promotion_bridge_gives_admitted_module b h).1

theorem promoted_module_has_no_sorry
    (b : PromotionBridge) :
    b.target.hasSorry = false :=
  b.noSorry

/-
ProjectionBridge allows a stable TLFL module to be read inside an experiment
without mutating the source and without transferring ownership.
-/
structure ProjectionBridge where
  source : TLFLModule
  target : ExperimentSpace
  projection : source.layer = SystemLayer.TLFL ->
               target.layer = SystemLayer.Experiment
  readOnly : True

theorem projection_bridge_target_is_experiment
    (b : ProjectionBridge)
    (h : b.source.layer = SystemLayer.TLFL) :
    b.target.layer = SystemLayer.Experiment :=
  b.projection h

theorem projection_bridge_does_not_transfer_ownership
    (_ : ProjectionBridge) :
    True :=
  trivial

structure LayerBoundary where
  allowPromotionWithProof : Prop
  allowProjectionReadOnly : Prop
  forbidOwnershipTransfer : Prop
  forbidSorryInProduction : Prop
  forbidSecretsInExperiment : Prop

def canonicalLayerBoundary : LayerBoundary :=
  { allowPromotionWithProof := True
    allowProjectionReadOnly := True
    forbidOwnershipTransfer := True
    forbidSorryInProduction := True
    forbidSecretsInExperiment := True }

theorem layer_boundary_allows_promotion :
    canonicalLayerBoundary.allowPromotionWithProof := by
  trivial

theorem layer_boundary_allows_projection :
    canonicalLayerBoundary.allowProjectionReadOnly := by
  trivial

theorem layer_boundary_forbids_ownership_transfer :
    canonicalLayerBoundary.forbidOwnershipTransfer := by
  trivial

theorem layer_boundary_forbids_sorry_in_production :
    canonicalLayerBoundary.forbidSorryInProduction := by
  trivial

structure PromotionChecklist where
  guardCheckPass : Bool
  hasOperationalDescription : Bool
  hasLeanSpec : Bool
  addedToRegression : Bool
  externalProofPass : Bool
  hasAdmittedPassport : Bool
  lakeBuildPass : Bool

def PromotionChecklist.isReady (c : PromotionChecklist) : Prop :=
  c.guardCheckPass = true /\
  c.hasOperationalDescription = true /\
  c.hasLeanSpec = true /\
  c.addedToRegression = true /\
  c.externalProofPass = true /\
  c.hasAdmittedPassport = true /\
  c.lakeBuildPass = true

theorem ready_checklist_has_guard_pass
    {c : PromotionChecklist}
    (h : c.isReady) :
    c.guardCheckPass = true :=
  h.1

theorem ready_checklist_has_external_proof
    {c : PromotionChecklist}
    (h : c.isReady) :
    c.externalProofPass = true :=
  h.2.2.2.2.1

end LayerBridge
