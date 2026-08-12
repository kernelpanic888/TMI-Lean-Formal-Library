import TMI.DigitalLifeCertifiedCognitiveAct
import TMI.DigitalLifeBoundedLearning

/-!
# I³-L18: Certified Learning Loop

A certified cognitive act may produce feedback, but feedback is not authority
to rewrite the model.  This layer admits learning only when the act is already
certified, the feedback is bound to that act, the parameter delta is the
canonical bounded proposal, validation loss does not increase, and the local
generation/head pair advances exactly once.

The rollback capsule preserves the exact pre-learning snapshot.  This is a
formal transition contract, not a claim of consciousness, optimal learning,
empirical usefulness, cryptographic security, or physical durability.
-/

namespace TMI.DigitalLifeCertifiedLearningLoop

open TMI.DigitalLifeRuntimeAdapter
open TMI.DigitalLifeNeuralProposer
open TMI.DigitalLifeBoundedLearning
open TMI.DigitalLifeCertifiedCognitiveAct
open TMI.DigitalLifeIndependentHardwareAdmission

structure LearningLoopPolicy where
  protocol : String := "I3CLLP1"
  version : Nat := 1
  policyId : String
  expectedCognitivePolicyId : String
  maxFeedbackAge : Nat
  maxValidationLoss : Nat
  deriving DecidableEq, Repr

structure LearningSnapshot where
  runtime : DL04State
  learning : LearningState
  generation : Nat
  receiptHead : String
  deriving DecidableEq, Repr

structure LearningObservation where
  protocol : String := "I3CLLO1"
  version : Nat := 1
  policyId : String
  loopId : String
  actId : String
  feedbackAt : Nat
  baselineLoss : Nat
  validatedLoss : Nat
  error : Int
  declaredDelta : ParameterDelta
  expectedGeneration : Nat
  previousReceiptHead : String
  receiptDigest : String
  deriving DecidableEq, Repr

structure LearningRollbackCapsule where
  loopId : String
  actId : String
  before : LearningSnapshot
  after : LearningSnapshot
  deriving DecidableEq, Repr

structure CertifiedLearningTrace where
  loopId : String
  actId : String
  cognitive : CognitiveTrace
  before : LearningSnapshot
  after : LearningSnapshot
  delta : ParameterDelta
  baselineLoss : Nat
  validatedLoss : Nat
  rollback : LearningRollbackCapsule
  deriving DecidableEq, Repr

def Digest64 (value : String) : Prop := value.length = 64

def LearningLoopPolicyWellFormed (p : LearningLoopPolicy) : Prop :=
  p.protocol = "I3CLLP1" ∧
  p.version = 1 ∧
  p.policyId ≠ "" ∧
  p.expectedCognitivePolicyId ≠ "" ∧
  0 < p.maxFeedbackAge

def SnapshotBound
    (before : LearningSnapshot)
    (candidate : CognitiveCandidate) : Prop :=
  before.runtime = candidate.before ∧
  before.learning.parameters = candidate.parameters ∧
  before.learning.modelIdentity = before.runtime.identity

def FeedbackBound
    (p : LearningLoopPolicy)
    (candidate : CognitiveCandidate)
    (before : LearningSnapshot)
    (observation : LearningObservation)
    (now : Nat) : Prop :=
  observation.protocol = "I3CLLO1" ∧
  observation.version = 1 ∧
  observation.policyId = p.policyId ∧
  observation.loopId ≠ "" ∧
  observation.actId = candidate.actId ∧
  candidate.observedAt ≤ observation.feedbackAt ∧
  observation.feedbackAt ≤ now ∧
  now - observation.feedbackAt ≤ p.maxFeedbackAge ∧
  observation.baselineLoss = before.learning.validationLoss ∧
  observation.validatedLoss ≤ p.maxValidationLoss

def CommitBound
    (before : LearningSnapshot)
    (observation : LearningObservation) : Prop :=
  observation.expectedGeneration = before.generation ∧
  observation.previousReceiptHead = before.receiptHead ∧
  Digest64 observation.receiptDigest ∧
  observation.receiptDigest ≠ before.receiptHead

def learnedSnapshot
    (before : LearningSnapshot)
    (candidate : CognitiveCandidate)
    (observation : LearningObservation) : LearningSnapshot :=
  { runtime := applyAction before.runtime (candidateAction candidate)
    learning := candidateState before.learning observation.declaredDelta
      observation.validatedLoss
    generation := before.generation + 1
    receiptHead := observation.receiptDigest }

def CertifiedLearningAdmitted
    (p : LearningLoopPolicy)
    (cognitivePolicy : CognitivePolicy)
    (candidate : CognitiveCandidate)
    (hardwarePolicy : AdmissionPolicy)
    (hardwareEvidence : AdmissionEvidence)
    (before : LearningSnapshot)
    (observation : LearningObservation)
    (now : Nat) : Prop :=
  LearningLoopPolicyWellFormed p ∧
  cognitivePolicy.policyId = p.expectedCognitivePolicyId ∧
  SnapshotBound before candidate ∧
  FeedbackBound p candidate before observation now ∧
  CommitBound before observation ∧
  observation.declaredDelta = trainingProposal observation.error ∧
  CognitiveAdmitted cognitivePolicy candidate hardwarePolicy hardwareEvidence now ∧
  LearningAdmissible before.learning observation.declaredDelta
    observation.validatedLoss
    (candidateState before.learning observation.declaredDelta observation.validatedLoss)

instance (p : LearningLoopPolicy) : Decidable (LearningLoopPolicyWellFormed p) := by
  unfold LearningLoopPolicyWellFormed
  infer_instance

instance (before : LearningSnapshot) (candidate : CognitiveCandidate) :
    Decidable (SnapshotBound before candidate) := by
  unfold SnapshotBound
  infer_instance

instance
    (p : LearningLoopPolicy)
    (candidate : CognitiveCandidate)
    (before : LearningSnapshot)
    (observation : LearningObservation)
    (now : Nat) : Decidable (FeedbackBound p candidate before observation now) := by
  unfold FeedbackBound
  infer_instance

instance (before : LearningSnapshot) (observation : LearningObservation) :
    Decidable (CommitBound before observation) := by
  unfold CommitBound Digest64
  infer_instance

instance
    (p : LearningLoopPolicy)
    (cognitivePolicy : CognitivePolicy)
    (candidate : CognitiveCandidate)
    (hardwarePolicy : AdmissionPolicy)
    (hardwareEvidence : AdmissionEvidence)
    (before : LearningSnapshot)
    (observation : LearningObservation)
    (now : Nat) :
    Decidable
      (CertifiedLearningAdmitted p cognitivePolicy candidate hardwarePolicy
        hardwareEvidence before observation now) := by
  unfold CertifiedLearningAdmitted
  infer_instance

def traceOfLearning
    (before : LearningSnapshot)
    (candidate : CognitiveCandidate)
    (observation : LearningObservation) : CertifiedLearningTrace :=
  let after := learnedSnapshot before candidate observation
  { loopId := observation.loopId
    actId := candidate.actId
    cognitive := traceOf candidate
    before := before
    after := after
    delta := observation.declaredDelta
    baselineLoss := observation.baselineLoss
    validatedLoss := observation.validatedLoss
    rollback :=
      { loopId := observation.loopId
        actId := candidate.actId
        before := before
        after := after } }

def certifyLearning
    (p : LearningLoopPolicy)
    (cognitivePolicy : CognitivePolicy)
    (candidate : CognitiveCandidate)
    (hardwarePolicy : AdmissionPolicy)
    (hardwareEvidence : AdmissionEvidence)
    (before : LearningSnapshot)
    (observation : LearningObservation)
    (now : Nat) : Option CertifiedLearningTrace :=
  if CertifiedLearningAdmitted p cognitivePolicy candidate hardwarePolicy
      hardwareEvidence before observation now then
    some (traceOfLearning before candidate observation)
  else
    none

def learnActOrHold
    (p : LearningLoopPolicy)
    (cognitivePolicy : CognitivePolicy)
    (candidate : CognitiveCandidate)
    (hardwarePolicy : AdmissionPolicy)
    (hardwareEvidence : AdmissionEvidence)
    (before : LearningSnapshot)
    (observation : LearningObservation)
    (now : Nat) : LearningSnapshot :=
  if CertifiedLearningAdmitted p cognitivePolicy candidate hardwarePolicy
      hardwareEvidence before observation now then
    learnedSnapshot before candidate observation
  else
    before

def rollbackLearning (capsule : LearningRollbackCapsule) : LearningSnapshot :=
  capsule.before

theorem admitted_requires_certified_act
    (h : CertifiedLearningAdmitted p cognitivePolicy candidate hardwarePolicy
      hardwareEvidence before observation now) :
    CognitiveAdmitted cognitivePolicy candidate hardwarePolicy hardwareEvidence now :=
  h.2.2.2.2.2.2.1

theorem admitted_requires_bounded_learning
    (h : CertifiedLearningAdmitted p cognitivePolicy candidate hardwarePolicy
      hardwareEvidence before observation now) :
    LearningAdmissible before.learning observation.declaredDelta
      observation.validatedLoss
      (candidateState before.learning observation.declaredDelta observation.validatedLoss) :=
  h.2.2.2.2.2.2.2

theorem learned_runtime_identity
    (before : LearningSnapshot)
    (candidate : CognitiveCandidate)
    (observation : LearningObservation) :
    (learnedSnapshot before candidate observation).runtime.identity =
      before.runtime.identity := by
  rfl

theorem learned_model_identity
    (before : LearningSnapshot)
    (candidate : CognitiveCandidate)
    (observation : LearningObservation) :
    (learnedSnapshot before candidate observation).learning.modelIdentity =
      before.learning.modelIdentity := by
  rfl

theorem learned_generation_advances_once
    (before : LearningSnapshot)
    (candidate : CognitiveCandidate)
    (observation : LearningObservation) :
    (learnedSnapshot before candidate observation).generation = before.generation + 1 := by
  rfl

theorem learned_head_is_receipt
    (before : LearningSnapshot)
    (candidate : CognitiveCandidate)
    (observation : LearningObservation) :
    (learnedSnapshot before candidate observation).receiptHead = observation.receiptDigest := by
  rfl

theorem admitted_loss_does_not_increase
    (h : CertifiedLearningAdmitted p cognitivePolicy candidate hardwarePolicy
      hardwareEvidence before observation now) :
    (learnedSnapshot before candidate observation).learning.validationLoss ≤
      before.learning.validationLoss := by
  exact (admitted_requires_bounded_learning h).1

theorem rollback_is_exact (capsule : LearningRollbackCapsule) :
    rollbackLearning capsule = capsule.before := by
  rfl

theorem rejected_learning_holds
    (h : ¬ CertifiedLearningAdmitted p cognitivePolicy candidate hardwarePolicy
      hardwareEvidence before observation now) :
    learnActOrHold p cognitivePolicy candidate hardwarePolicy hardwareEvidence
      before observation now = before := by
  simp [learnActOrHold, h]

def CertifiedStep (before after : LearningSnapshot) : Prop :=
  ∃ p cognitivePolicy candidate hardwarePolicy hardwareEvidence observation now,
    CertifiedLearningAdmitted p cognitivePolicy candidate hardwarePolicy
      hardwareEvidence before observation now ∧
    after = learnedSnapshot before candidate observation

inductive CertifiedLearningChain : LearningSnapshot → LearningSnapshot → Prop where
  | refl (state : LearningSnapshot) : CertifiedLearningChain state state
  | tail {first middle last : LearningSnapshot} :
      CertifiedLearningChain first middle →
      CertifiedStep middle last →
      CertifiedLearningChain first last

theorem certified_step_preserves_identity
    (h : CertifiedStep before after) :
    after.runtime.identity = before.runtime.identity ∧
    after.learning.modelIdentity = before.learning.modelIdentity := by
  rcases h with ⟨_, _, candidate, _, _, observation, _, _, rfl⟩
  exact ⟨learned_runtime_identity before candidate observation,
    learned_model_identity before candidate observation⟩

theorem certified_chain_preserves_identity
    (h : CertifiedLearningChain first last) :
    last.runtime.identity = first.runtime.identity ∧
    last.learning.modelIdentity = first.learning.modelIdentity := by
  induction h with
  | refl => exact ⟨rfl, rfl⟩
  | tail chain step ih =>
      have hs := certified_step_preserves_identity step
      exact ⟨hs.1.trans ih.1, hs.2.trans ih.2⟩

def demoDigest0 : String :=
  "0000000000000000000000000000000000000000000000000000000000000000"

def demoDigest1 : String :=
  "1111111111111111111111111111111111111111111111111111111111111111"

def demoRuntime : DL04State :=
  { identity := 1, n := 0, x := 1, y := 0, z := 0, memory := 0,
    reflection := 0, input := 0, certificate := 0 }

def demoCognitivePolicy : CognitivePolicy :=
  { policyId := "i3-l17-policy"
    expectedModelDigest := demoDigest0
    expectedSelectorDigest := demoDigest1
    maxCandidateAge := 30 }

def demoCandidate : CognitiveCandidate :=
  { policyId := "i3-l17-policy"
    actId := "act-001"
    modelDigest := demoDigest0
    selectorDigest := demoDigest1
    observedAt := 100
    before := demoRuntime
    parameters := demoParameters
    declaredInput := proposeInput demoParameters demoRuntime }

def demoHardwarePolicy : AdmissionPolicy :=
  { policyId := "i3-l16-policy"
    expectedL15PolicyDigest := demoDigest0
    expectedL14ReceiptDigest := demoDigest0
    expectedPlatformProfileDigest := demoDigest0
    expectedTransportProfileDigest := demoDigest0
    expectedChallengeDomain := "challenge.example"
    expectedTlsPeerDigest := demoDigest0
    expectedMeasurementPolicyDigest := demoDigest0
    expectedWitnessPolicyDigest := demoDigest0
    minIndependentWitnesses := 2
    minFaultDomains := 2
    maxEvidenceAge := 30 }

def demoHardwareEvidence : AdmissionEvidence :=
  { policyId := "i3-l16-policy"
    l15PolicyDigest := demoDigest0
    l14ReceiptDigest := demoDigest0
    platformProfileDigest := demoDigest0
    transportProfileDigest := demoDigest0
    challengeDomain := "challenge.example"
    tlsPeerDigest := demoDigest0
    measurementPolicyDigest := demoDigest0
    witnessPolicyDigest := demoDigest0
    observedAt := 100
    witnessCount := 3
    faultDomainCount := 3
    l15EnrollmentReady := true
    localHardwarePass := true
    freshRemoteChallenge := true
    remoteResponseSignatureValid := true
    transportAttestationValid := true
    platformQuoteChainTrusted := true
    measurementsAccepted := true
    splitCustodyApproved := true
    witnessSignaturesValid := true
    faultDomainQuorumIndependent := true }

def demoBefore : LearningSnapshot :=
  { runtime := demoRuntime
    learning :=
      { modelIdentity := 1, version := 0, parameters := demoParameters,
        validationLoss := 10, receipt := 0 }
    generation := 0
    receiptHead := demoDigest0 }

def demoLoopPolicy : LearningLoopPolicy :=
  { policyId := "i3-l18-policy"
    expectedCognitivePolicyId := "i3-l17-policy"
    maxFeedbackAge := 30
    maxValidationLoss := 10 }

def demoObservation : LearningObservation :=
  { policyId := "i3-l18-policy"
    loopId := "loop-001"
    actId := "act-001"
    feedbackAt := 105
    baselineLoss := 10
    validatedLoss := 8
    error := 3
    declaredDelta := trainingProposal 3
    expectedGeneration := 0
    previousReceiptHead := demoDigest0
    receiptDigest := demoDigest1 }

theorem demo_learning_is_admitted :
    CertifiedLearningAdmitted demoLoopPolicy demoCognitivePolicy demoCandidate
      demoHardwarePolicy demoHardwareEvidence demoBefore demoObservation 110 := by
  decide

theorem demo_learning_certifies :
    certifyLearning demoLoopPolicy demoCognitivePolicy demoCandidate
      demoHardwarePolicy demoHardwareEvidence demoBefore demoObservation 110 =
      some (traceOfLearning demoBefore demoCandidate demoObservation) := by
  simp [certifyLearning, demo_learning_is_admitted]

end TMI.DigitalLifeCertifiedLearningLoop
