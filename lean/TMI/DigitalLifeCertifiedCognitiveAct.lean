import TMI.DigitalLifeNeuralProposer
import TMI.DigitalLifeIndependentHardwareAdmission

/-!
# I³-L17: Certified Cognitive Act

This layer does not claim consciousness. It separates an untrusted neural
proposal from an independently admitted, two-axis, traceable state transition.
-/

namespace TMI.DigitalLifeCertifiedCognitiveAct

open TMI.DigitalLifeRuntimeAdapter
open TMI.DigitalLifeNeuralProposer
open TMI.DigitalLifeTwoAxisTick
open TMI.DigitalLifeIndependentHardwareAdmission

structure CognitivePolicy where
  protocol : String := "I3CAP1"
  version : Nat := 1
  policyId : String
  expectedModelDigest : String
  expectedSelectorDigest : String
  maxCandidateAge : Nat
  deriving DecidableEq, Repr

structure CognitiveCandidate where
  protocol : String := "I3CAE1"
  version : Nat := 1
  policyId : String
  actId : String
  modelDigest : String
  selectorDigest : String
  observedAt : Nat
  before : DL04State
  parameters : NeuralParameters
  declaredInput : Int
  deriving DecidableEq, Repr

structure CognitiveTrace where
  actId : String
  before : DL04State
  parameters : NeuralParameters
  score : Int
  proposedInput : Int
  after : DL04State
  deriving DecidableEq, Repr

def CognitiveDigest64 (value : String) : Prop := value.length = 64

def CognitivePolicyWellFormed (p : CognitivePolicy) : Prop :=
  p.protocol = "I3CAP1" ∧
  p.version = 1 ∧
  p.policyId ≠ "" ∧
  CognitiveDigest64 p.expectedModelDigest ∧
  CognitiveDigest64 p.expectedSelectorDigest ∧
  0 < p.maxCandidateAge

def candidateAction (c : CognitiveCandidate) : DL04Action :=
  .advance c.declaredInput

def candidateEvent (c : CognitiveCandidate) :=
  eventFromAction c.before (candidateAction c)

def canonicalSelector (c : CognitiveCandidate) : Bool :=
  decide (candidateAction c ∈ neuralActionField)

def traceOf (c : CognitiveCandidate) : CognitiveTrace := {
  actId := c.actId
  before := c.before
  parameters := c.parameters
  score := TMI.DigitalLifeNeuralProposer.score c.parameters c.before
  proposedInput := c.declaredInput
  after := applyAction c.before (candidateAction c)
}

def replay (trace : CognitiveTrace) : DL04State :=
  applyAction trace.before (.advance trace.proposedInput)

def returnTo (trace : CognitiveTrace) : DL04State :=
  trace.before

def CognitiveAdmitted
    (p : CognitivePolicy)
    (c : CognitiveCandidate)
    (hardwarePolicy : AdmissionPolicy)
    (hardwareEvidence : AdmissionEvidence)
    (now : Nat) : Prop :=
  CognitivePolicyWellFormed p ∧
  c.protocol = "I3CAE1" ∧
  c.version = 1 ∧
  c.policyId = p.policyId ∧
  c.modelDigest = p.expectedModelDigest ∧
  c.selectorDigest = p.expectedSelectorDigest ∧
  c.observedAt ≤ now ∧
  now - c.observedAt ≤ p.maxCandidateAge ∧
  IndependentHardwareAdmitted hardwarePolicy hardwareEvidence now ∧
  safe c.before ∧
  c.declaredInput = proposeInput c.parameters c.before ∧
  canonicalSelector c = true ∧
  TMI.DigitalLifeRuntimeAdapter.check (candidateEvent c) = true

instance (p : CognitivePolicy) : Decidable (CognitivePolicyWellFormed p) := by
  unfold CognitivePolicyWellFormed CognitiveDigest64
  infer_instance

local instance (state : DL04State) : Decidable (safe state) := by
  unfold safe
  infer_instance

instance
    (p : CognitivePolicy)
    (c : CognitiveCandidate)
    (hardwarePolicy : AdmissionPolicy)
    (hardwareEvidence : AdmissionEvidence)
    (now : Nat) :
    Decidable (CognitiveAdmitted p c hardwarePolicy hardwareEvidence now) := by
  unfold CognitiveAdmitted
  infer_instance

def certify
    (p : CognitivePolicy)
    (c : CognitiveCandidate)
    (hardwarePolicy : AdmissionPolicy)
    (hardwareEvidence : AdmissionEvidence)
    (now : Nat) : Option CognitiveTrace :=
  if CognitiveAdmitted p c hardwarePolicy hardwareEvidence now then
    some (traceOf c)
  else
    none

theorem certified_iff
    (p : CognitivePolicy)
    (c : CognitiveCandidate)
    (hardwarePolicy : AdmissionPolicy)
    (hardwareEvidence : AdmissionEvidence)
    (now : Nat) :
    certify p c hardwarePolicy hardwareEvidence now = some (traceOf c) ↔
      CognitiveAdmitted p c hardwarePolicy hardwareEvidence now := by
  simp [certify]

theorem admitted_requires_independent_hardware
    {p : CognitivePolicy}
    {c : CognitiveCandidate}
    {hardwarePolicy : AdmissionPolicy}
    {hardwareEvidence : AdmissionEvidence}
    {now : Nat}
    (h : CognitiveAdmitted p c hardwarePolicy hardwareEvidence now) :
    IndependentHardwareAdmitted hardwarePolicy hardwareEvidence now := by
  rcases h with ⟨_, _, _, _, _, _, _, _, hHardware, _, _, _, _⟩
  exact hHardware

theorem admitted_input_is_neural_proposal
    {p : CognitivePolicy}
    {c : CognitiveCandidate}
    {hardwarePolicy : AdmissionPolicy}
    {hardwareEvidence : AdmissionEvidence}
    {now : Nat}
    (h : CognitiveAdmitted p c hardwarePolicy hardwareEvidence now) :
    c.declaredInput = proposeInput c.parameters c.before := by
  rcases h with ⟨_, _, _, _, _, _, _, _, _, _, hInput, _, _⟩
  exact hInput

theorem admitted_proposal_is_in_field
    {p : CognitivePolicy}
    {c : CognitiveCandidate}
    {hardwarePolicy : AdmissionPolicy}
    {hardwareEvidence : AdmissionEvidence}
    {now : Nat}
    (h : CognitiveAdmitted p c hardwarePolicy hardwareEvidence now) :
    candidateAction c ∈ neuralActionField := by
  have hInput := admitted_input_is_neural_proposal h
  have hProposal := neural_proposal_in_field c.parameters c.before
  simpa [candidateAction, proposeAction, hInput] using hProposal

theorem admitted_has_two_axis_tick
    {p : CognitivePolicy}
    {c : CognitiveCandidate}
    {hardwarePolicy : AdmissionPolicy}
    {hardwareEvidence : AdmissionEvidence}
    {now : Nat}
    (h : CognitiveAdmitted p c hardwarePolicy hardwareEvidence now) :
    AdmittedTick contract (candidateEvent c) := by
  rcases h with ⟨_, _, _, _, _, _, _, _, _, _, _, _, hTick⟩
  exact validator.sound _ hTick

theorem trace_replays_exactly (c : CognitiveCandidate) :
    replay (traceOf c) = (traceOf c).after := by
  rfl

theorem trace_returns_exactly (c : CognitiveCandidate) :
    returnTo (traceOf c) = c.before := by
  rfl

theorem missing_hardware_admission_holds
    {p : CognitivePolicy}
    {c : CognitiveCandidate}
    {hardwarePolicy : AdmissionPolicy}
    {hardwareEvidence : AdmissionEvidence}
    {now : Nat}
    (hMissing : ¬ IndependentHardwareAdmitted hardwarePolicy hardwareEvidence now) :
    certify p c hardwarePolicy hardwareEvidence now = none := by
  simp only [certify]
  split
  · rename_i hAdmitted
    exact False.elim (hMissing (admitted_requires_independent_hardware hAdmitted))
  · rfl

theorem tampered_proposal_holds
    {p : CognitivePolicy}
    {c : CognitiveCandidate}
    {hardwarePolicy : AdmissionPolicy}
    {hardwareEvidence : AdmissionEvidence}
    {now : Nat}
    (hTampered : c.declaredInput ≠ proposeInput c.parameters c.before) :
    certify p c hardwarePolicy hardwareEvidence now = none := by
  simp only [certify]
  split
  · rename_i hAdmitted
    exact False.elim (hTampered (admitted_input_is_neural_proposal hAdmitted))
  · rfl

end TMI.DigitalLifeCertifiedCognitiveAct
