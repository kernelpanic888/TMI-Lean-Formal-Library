/-
TLFL v0.5.0-alpha: experimental interface foundations.

This module records an authorial formal vocabulary. It does not claim that the
vocabulary is an empirically validated physical theory. The stable aggregate
`TMI.Library` does not import this module; users opt in explicitly.
-/

namespace TMI
namespace InterfaceFoundationsAlpha

universe u v

inductive FormalStatus where
  | kernelChecked
  | experimental
  | readerOnly
  | notFormalized
  deriving Repr, DecidableEq

def moduleStatus : FormalStatus :=
  .experimental

theorem module_status_is_experimental :
    moduleStatus = FormalStatus.experimental := by
  rfl

structure TwoSidedLanguage where
  L : Type u
  R : Type u
  Sigma : Type u
  forwardContact : L -> Sigma -> Prop
  reverseContact : Sigma -> R -> Prop
  distinguishable : L -> R -> Prop
  evolves : Sigma -> Sigma -> Prop
  backreactsLeft : Sigma -> L -> L -> Prop
  backreactsRight : Sigma -> R -> R -> Prop
  Memory : Sigma -> Type v
  Energy : Sigma -> Type v

structure ThirdBodyRecord where
  stateIndependent : Prop
  evolves : Prop
  backreactsOnLeft : Prop
  backreactsOnRight : Prop
  carriesMemory : Prop
  carriesEnergy : Prop

def IsThirdBody (record : ThirdBodyRecord) : Prop :=
  record.stateIndependent /\
  record.evolves /\
  record.backreactsOnLeft /\
  record.backreactsOnRight

theorem third_body_criterion (record : ThirdBodyRecord) :
    IsThirdBody record <->
      record.stateIndependent /\
      record.evolves /\
      record.backreactsOnLeft /\
      record.backreactsOnRight := by
  rfl

structure InterfaceCorridor (Scale : Type u) where
  before : Scale -> Scale -> Prop
  admissible : Scale -> Prop
  planckTouch : Scale
  horizonTouch : Scale
  planckTouchAdmissible : admissible planckTouch
  planckTouchIsLowerBoundary :
    forall s, admissible s -> s = planckTouch \/ before planckTouch s
  horizonTouchIsExcluded : Not (admissible horizonTouch)
  horizonTouchIsUpperBoundary :
    forall s, admissible s -> before s horizonTouch

structure HorizonApproach
    {Scale : Type u}
    (corridor : InterfaceCorridor Scale) where
  Neighborhood : Type v
  inside : Scale -> Neighborhood -> Prop
  isHorizonNeighborhood : Neighborhood -> Prop
  admissibleWitness :
    forall neighborhood,
      isHorizonNeighborhood neighborhood ->
      exists s, corridor.admissible s /\ inside s neighborhood

def HasPlanckWitness
    {Scale : Type u}
    (admissible : Scale -> Prop) : Prop :=
  exists s, admissible s

def HasExcludedHorizon
    {Scale : Type u}
    (admissible : Scale -> Prop) : Prop :=
  exists s, Not (admissible s)

theorem planck_witness_does_not_force_excluded_horizon :
    exists (Scale : Type) (admissible : Scale -> Prop),
      HasPlanckWitness admissible /\
      Not (HasExcludedHorizon admissible) := by
  refine ⟨PUnit, fun _ => True, ?_, ?_⟩
  · exact ⟨PUnit.unit, by trivial⟩
  · intro horizon
    rcases horizon with ⟨point, excluded⟩
    exact excluded trivial

structure TimeRelation
    (PhysicalTime : Type u)
    (InternalTime : Type v) where
  relates : PhysicalTime -> InternalTime -> Prop

structure PredictionGate where
  baselineError : Nat
  modelError : Nat
  tolerance : Nat
  improvesBaseline : modelError < baselineError
  staysWithinTolerance : modelError <= tolerance

theorem predictive_model_improves_baseline
    (gate : PredictionGate) :
    gate.modelError < gate.baselineError := by
  exact gate.improvesBaseline

structure PrecisionBoundary where
  noncollapseGap : Prop
  measurementError : Prop
  gapIsNotDefinedAsError :
    Not (noncollapseGap <-> measurementError)

theorem gap_is_not_measurement_error
    (boundary : PrecisionBoundary) :
    Not (boundary.noncollapseGap <-> boundary.measurementError) := by
  exact boundary.gapIsNotDefinedAsError

structure AlphaClaimBoundary where
  empiricalPhysicsValidated : Prop
  consciousnessEstablished : Prop
  externalDomainDetected : Prop

def alphaClaimBoundary : AlphaClaimBoundary :=
  { empiricalPhysicsValidated := False
    consciousnessEstablished := False
    externalDomainDetected := False }

theorem alpha_does_not_claim_empirical_physics :
    Not alphaClaimBoundary.empiricalPhysicsValidated := by
  intro h
  exact h

theorem alpha_does_not_claim_consciousness :
    Not alphaClaimBoundary.consciousnessEstablished := by
  intro h
  exact h

theorem alpha_does_not_claim_external_domain_detection :
    Not alphaClaimBoundary.externalDomainDetected := by
  intro h
  exact h

end InterfaceFoundationsAlpha
end TMI
