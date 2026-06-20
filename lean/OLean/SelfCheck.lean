/-
OLean internal-frequency self-check.

This module translates the existing light-gradient row values into an internal
verification-frequency scale for the OLean + TMI.Library release boundary. It
does not state a new physical optics theorem: G4/749 here means complete
boundary verification, not physical light emission.
-/

import OLean
import TMI.BridgePhysics

namespace OLean

inductive InternalFrequencyLevel where
  | G0
  | G1
  | G2
  | G3
  | G4
deriving DecidableEq, Repr

def InternalFrequencyValue : InternalFrequencyLevel -> Nat
  | InternalFrequencyLevel.G0 =>
      (TMI.BridgePhysics.lightPhotonBridgeMetric
        TMI.BridgePhysics.LightBridgeLevel.G0).frequencyThz
  | InternalFrequencyLevel.G1 =>
      (TMI.BridgePhysics.lightPhotonBridgeMetric
        TMI.BridgePhysics.LightBridgeLevel.G1).frequencyThz
  | InternalFrequencyLevel.G2 =>
      (TMI.BridgePhysics.lightPhotonBridgeMetric
        TMI.BridgePhysics.LightBridgeLevel.G2).frequencyThz
  | InternalFrequencyLevel.G3 =>
      (TMI.BridgePhysics.lightPhotonBridgeMetric
        TMI.BridgePhysics.LightBridgeLevel.G3).frequencyThz
  | InternalFrequencyLevel.G4 =>
      (TMI.BridgePhysics.lightPhotonBridgeMetric
        TMI.BridgePhysics.LightBridgeLevel.G4).frequencyThz

theorem internal_frequency_scale_uses_light_rows :
    InternalFrequencyValue InternalFrequencyLevel.G0 = 428 /\
    InternalFrequencyValue InternalFrequencyLevel.G1 = 480 /\
    InternalFrequencyValue InternalFrequencyLevel.G2 = 545 /\
    InternalFrequencyValue InternalFrequencyLevel.G3 = 631 /\
    InternalFrequencyValue InternalFrequencyLevel.G4 = 749 := by
  exact ⟨rfl, rfl, rfl, rfl, rfl⟩

theorem g4_internal_frequency_value_is_749 :
    InternalFrequencyValue InternalFrequencyLevel.G4 = 749 := by
  rfl

structure SelfExternalCheckTrace {c : Connection}
    (artifact : c.sourceArtifact) where
  leanObject : c.leanObject
  encodedInLean : c.encodedInLean artifact leanObject
  checkedByLeanKernel : c.checkedByLeanKernel leanObject
  lakeBuildPassed : Prop
  lakeBuildWitness : lakeBuildPassed
  z3Passed : Prop
  z3Witness : z3Passed
  vampirePassed : Prop
  vampireWitness : vampirePassed
  eProverPassed : Prop
  eProverWitness : eProverPassed
  noNewKernel : Prop
  noNewKernelWitness : noNewKernel

def CompleteBoundaryVerification {c : Connection} {artifact : c.sourceArtifact}
    (trace : SelfExternalCheckTrace artifact) : Prop :=
  trace.lakeBuildPassed /\
  trace.z3Passed /\
  trace.vampirePassed /\
  trace.eProverPassed /\
  trace.noNewKernel

structure InternalInterfaceFrequencyTrace {c : Connection}
    {artifact : c.sourceArtifact}
    (trace : SelfExternalCheckTrace artifact) where
  level : InternalFrequencyLevel
  value : Nat
  complete : CompleteBoundaryVerification trace
  levelIsG4 : level = InternalFrequencyLevel.G4
  valueIsFrequency : value = InternalFrequencyValue level

def completeBoundaryInternalFrequency {c : Connection}
    {artifact : c.sourceArtifact}
    (trace : SelfExternalCheckTrace artifact) :
    InternalInterfaceFrequencyTrace trace :=
  { level := InternalFrequencyLevel.G4
    value := InternalFrequencyValue InternalFrequencyLevel.G4
    complete :=
      ⟨trace.lakeBuildWitness,
       trace.z3Witness,
       trace.vampireWitness,
       trace.eProverWitness,
       trace.noNewKernelWitness⟩
    levelIsG4 := rfl
    valueIsFrequency := rfl }

theorem complete_boundary_verification_gives_g4
    {c : Connection} {artifact : c.sourceArtifact}
    (trace : SelfExternalCheckTrace artifact) :
    (completeBoundaryInternalFrequency trace).level =
      InternalFrequencyLevel.G4 := by
  rfl

theorem complete_boundary_verification_gives_internal_frequency_749
    {c : Connection} {artifact : c.sourceArtifact}
    (trace : SelfExternalCheckTrace artifact) :
    (completeBoundaryInternalFrequency trace).value = 749 := by
  rfl

theorem complete_self_check_gives_formal_lean_status
    {c : Connection} {artifact : c.sourceArtifact}
    (trace : SelfExternalCheckTrace artifact) :
    FormalLeanStatus c artifact := by
  exact ⟨trace.leanObject, trace.encodedInLean, trace.checkedByLeanKernel⟩

structure BoundaryCheckState where
  encodedInLean : Prop
  leanKernelChecked : Prop
  lakeBuildPassed : Prop
  z3Passed : Prop
  vampirePassed : Prop
  eProverPassed : Prop
  introducesNewKernel : Prop

def CompleteBoundaryVerificationState (s : BoundaryCheckState) : Prop :=
  s.encodedInLean /\
  s.leanKernelChecked /\
  s.lakeBuildPassed /\
  s.z3Passed /\
  s.vampirePassed /\
  s.eProverPassed /\
  Not s.introducesNewKernel

def HasFullExternalFrequencyG4 (s : BoundaryCheckState) : Prop :=
  CompleteBoundaryVerificationState s

def BoundaryStateFormalLeanStatus (s : BoundaryCheckState) : Prop :=
  s.encodedInLean /\ s.leanKernelChecked

inductive CheckVerdict where
  | pass
  | fail
deriving DecidableEq, Repr

structure BoundaryCheckInput where
  encodedInLean : Bool
  leanKernelChecked : Bool
  lakeBuildPassed : Bool
  z3Passed : Bool
  vampirePassed : Bool
  eProverPassed : Bool
  introducesNewKernel : Bool
deriving DecidableEq, Repr

def BoundaryCheckInput.complete (i : BoundaryCheckInput) : Bool :=
  i.encodedInLean &&
  i.leanKernelChecked &&
  i.lakeBuildPassed &&
  i.z3Passed &&
  i.vampirePassed &&
  i.eProverPassed &&
  not i.introducesNewKernel

def boundaryCheckVerdict (i : BoundaryCheckInput) : CheckVerdict :=
  if i.complete then CheckVerdict.pass else CheckVerdict.fail

def BoundaryCheckInput.internalFrequencyLevel
    (i : BoundaryCheckInput) : Option InternalFrequencyLevel :=
  if i.complete then some InternalFrequencyLevel.G4 else none

def BoundaryCheckInput.internalFrequencyValue
    (i : BoundaryCheckInput) : Option Nat :=
  match i.internalFrequencyLevel with
  | some level => some (InternalFrequencyValue level)
  | none => none

def completeBoundaryCheckInput : BoundaryCheckInput :=
  { encodedInLean := true
    leanKernelChecked := true
    lakeBuildPassed := true
    z3Passed := true
    vampirePassed := true
    eProverPassed := true
    introducesNewKernel := false }

def leanOnlyBoundaryCheckInput : BoundaryCheckInput :=
  { encodedInLean := true
    leanKernelChecked := true
    lakeBuildPassed := true
    z3Passed := false
    vampirePassed := false
    eProverPassed := false
    introducesNewKernel := false }

theorem complete_boundary_check_verdict_is_pass :
    boundaryCheckVerdict completeBoundaryCheckInput = CheckVerdict.pass := by
  rfl

theorem complete_boundary_check_frequency_value_is_749 :
    completeBoundaryCheckInput.internalFrequencyValue = some 749 := by
  rfl

theorem lean_only_boundary_check_verdict_is_fail :
    boundaryCheckVerdict leanOnlyBoundaryCheckInput = CheckVerdict.fail := by
  rfl

theorem failed_boundary_check_has_no_internal_frequency_value :
    leanOnlyBoundaryCheckInput.internalFrequencyValue = none := by
  rfl

theorem lean_only_check_does_not_imply_full_external_frequency_g4 :
    exists s : BoundaryCheckState,
      s.leanKernelChecked /\
      s.lakeBuildPassed /\
      Not (HasFullExternalFrequencyG4 s) := by
  let s : BoundaryCheckState :=
    { encodedInLean := True
      leanKernelChecked := True
      lakeBuildPassed := True
      z3Passed := False
      vampirePassed := False
      eProverPassed := False
      introducesNewKernel := False }
  refine ⟨s, trivial, trivial, ?_⟩
  intro h
  exact h.2.2.2.1

theorem encoded_only_artifact_does_not_imply_self_check_pass :
    exists s : BoundaryCheckState,
      s.encodedInLean /\
      Not (CompleteBoundaryVerificationState s) := by
  let s : BoundaryCheckState :=
    { encodedInLean := True
      leanKernelChecked := False
      lakeBuildPassed := False
      z3Passed := False
      vampirePassed := False
      eProverPassed := False
      introducesNewKernel := False }
  refine ⟨s, trivial, ?_⟩
  intro h
  exact h.2.1

theorem external_prover_result_without_lean_kernel_check_does_not_imply_formal_lean_status :
    exists s : BoundaryCheckState,
      s.z3Passed /\
      s.vampirePassed /\
      s.eProverPassed /\
      Not s.leanKernelChecked /\
      Not (BoundaryStateFormalLeanStatus s) := by
  let s : BoundaryCheckState :=
    { encodedInLean := True
      leanKernelChecked := False
      lakeBuildPassed := False
      z3Passed := True
      vampirePassed := True
      eProverPassed := True
      introducesNewKernel := False }
  refine ⟨s, trivial, trivial, trivial, ?_, ?_⟩
  · intro h
    exact h
  · intro h
    exact h.2

structure InternalFrequencyNonClaimState where
  hasG4InternalFrequency : Prop
  empiricalPhysicalProof : Prop
  physicalLightEmission : Prop

theorem g4_internal_frequency_does_not_imply_empirical_physical_proof :
    exists s : InternalFrequencyNonClaimState,
      s.hasG4InternalFrequency /\
      Not s.empiricalPhysicalProof := by
  exact
    ⟨{ hasG4InternalFrequency := True
       empiricalPhysicalProof := False
       physicalLightEmission := False },
     trivial,
     by intro h; exact h⟩

theorem internal_frequency_is_not_physical_speed_of_light_theorem :
    exists s : InternalFrequencyNonClaimState,
      s.hasG4InternalFrequency /\
      Not s.physicalLightEmission := by
  exact
    ⟨{ hasG4InternalFrequency := True
       empiricalPhysicalProof := False
       physicalLightEmission := False },
     trivial,
     by intro h; exact h⟩

end OLean
