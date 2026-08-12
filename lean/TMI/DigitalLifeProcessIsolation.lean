import TMI.DigitalLifeAtomicTrustStore

/-!
# I3-L08: least-privilege process isolation

This layer separates proposal, validation, trust-head mutation, and external
witness advancement into distinct roles.  A proposal is explicitly bound to
the public projection of the current atomic trust snapshot.  The trust-store
role may bind that proposal into a stateful validation request, but it does not
originate the proposed parameter delta.

The model proves an authority-separation contract.  It does not prove the
security of an operating system sandbox, the honesty of an operator, key
secrecy, neural generalization, consciousness, digital life, or true AI.
-/

namespace TMI.DigitalLifeProcessIsolation

open TMI.DigitalLifeNeuralProposer
open TMI.DigitalLifeBoundedLearning
open TMI.DigitalLifePersistentTrust
open TMI.DigitalLifeAtomicTrustStore

def isolationProtocolVersion : Nat := 1

inductive ProcessRole where
  | trainerExecutor
  | validator
  | trustStore
  | externalWitness
  deriving DecidableEq, Repr

inductive Authority where
  | readTraining
  | proposeDelta
  | executeAdmittedState
  | readHoldout
  | mintValidationReceipt
  | rewriteTrustHead
  | readWitnessKey
  | advanceExternalWitness
  deriving DecidableEq, Repr

def roleAllows : ProcessRole → Authority → Bool
  | .trainerExecutor, .readTraining => true
  | .trainerExecutor, .proposeDelta => true
  | .trainerExecutor, .executeAdmittedState => true
  | .validator, .readHoldout => true
  | .validator, .mintValidationReceipt => true
  | .trustStore, .rewriteTrustHead => true
  | .externalWitness, .readWitnessKey => true
  | .externalWitness, .advanceExternalWitness => true
  | _, _ => false

def OwnsEndToEndAuthority (role : ProcessRole) : Prop :=
  roleAllows role .readHoldout = true ∧
  roleAllows role .mintValidationReceipt = true ∧
  roleAllows role .rewriteTrustHead = true ∧
  roleAllows role .advanceExternalWitness = true

instance (role : ProcessRole) : Decidable (OwnsEndToEndAuthority role) := by
  unfold OwnsEndToEndAuthority
  infer_instance

theorem no_single_role_owns_end_to_end_authority (role : ProcessRole) :
    ¬ OwnsEndToEndAuthority role := by
  cases role <;> native_decide

theorem only_validator_mints_receipts
    (role : ProcessRole)
    (h : roleAllows role .mintValidationReceipt = true) :
    role = .validator := by
  cases role <;> simp [roleAllows] at h ⊢

theorem only_trust_store_rewrites_head
    (role : ProcessRole)
    (h : roleAllows role .rewriteTrustHead = true) :
    role = .trustStore := by
  cases role <;> simp [roleAllows] at h ⊢

theorem only_external_witness_advances_witness
    (role : ProcessRole)
    (h : roleAllows role .advanceExternalWitness = true) :
    role = .externalWitness := by
  cases role <;> simp [roleAllows] at h ⊢

structure PublicModelSnapshot where
  protocolVersion : Nat
  generation : Nat
  validatorId : Nat
  trustEpoch : Nat
  keyId : Nat
  lastRequestId : Nat
  receiptHead : String
  manifestDigest : String
  learning : LearningState
  deriving DecidableEq, Repr

def publicSnapshotOf (snapshot : AtomicTrustSnapshot) : PublicModelSnapshot :=
  { protocolVersion := isolationProtocolVersion
    generation := snapshot.generation
    validatorId := snapshot.trust.validatorId
    trustEpoch := snapshot.trust.trustEpoch
    keyId := snapshot.trust.keyId
    lastRequestId := snapshot.trust.lastRequestId
    receiptHead := snapshot.trust.receiptHead
    manifestDigest := snapshot.trust.manifestDigest
    learning := snapshot.trust.learning }

structure IsolatedProposal where
  protocolVersion : Nat
  generation : Nat
  modelIdentity : Nat
  modelVersion : Nat
  receiptIndex : Nat
  previousReceiptHead : String
  trustEpoch : Nat
  keyId : Nat
  lastRequestId : Nat
  manifestDigest : String
  delta : ParameterDelta
  deriving DecidableEq, Repr

def makeIsolatedProposal
    (snapshot : PublicModelSnapshot)
    (delta : ParameterDelta) : IsolatedProposal :=
  { protocolVersion := isolationProtocolVersion
    generation := snapshot.generation
    modelIdentity := snapshot.learning.modelIdentity
    modelVersion := snapshot.learning.version
    receiptIndex := snapshot.learning.receipt
    previousReceiptHead := snapshot.receiptHead
    trustEpoch := snapshot.trustEpoch
    keyId := snapshot.keyId
    lastRequestId := snapshot.lastRequestId
    manifestDigest := snapshot.manifestDigest
    delta }

def ProposalAtSnapshot
    (snapshot : AtomicTrustSnapshot)
    (proposal : IsolatedProposal) : Prop :=
  proposal.protocolVersion = isolationProtocolVersion ∧
  proposal.generation = snapshot.generation ∧
  proposal.modelIdentity = snapshot.trust.learning.modelIdentity ∧
  proposal.modelVersion = snapshot.trust.learning.version ∧
  proposal.receiptIndex = snapshot.trust.learning.receipt ∧
  proposal.previousReceiptHead = snapshot.trust.receiptHead ∧
  proposal.trustEpoch = snapshot.trust.trustEpoch ∧
  proposal.keyId = snapshot.trust.keyId ∧
  proposal.lastRequestId = snapshot.trust.lastRequestId ∧
  proposal.manifestDigest = snapshot.trust.manifestDigest ∧
  BoundedDelta proposal.delta

instance (snapshot : AtomicTrustSnapshot) (proposal : IsolatedProposal) :
    Decidable (ProposalAtSnapshot snapshot proposal) := by
  unfold ProposalAtSnapshot
  infer_instance

def ProposalRequestReady
    (snapshot : AtomicTrustSnapshot)
    (proposal : IsolatedProposal)
    (nonce : String) : Prop :=
  ProposalAtSnapshot snapshot proposal ∧
  nonce.length = 64 ∧
  nonce ∉ snapshot.trust.consumedNonces

instance
    (snapshot : AtomicTrustSnapshot)
    (proposal : IsolatedProposal)
    (nonce : String) :
    Decidable (ProposalRequestReady snapshot proposal nonce) := by
  unfold ProposalRequestReady
  infer_instance

def bindProposalOrHold
    (snapshot : AtomicTrustSnapshot)
    (proposal : IsolatedProposal)
    (nonce : String) : Option StatefulWireRequest :=
  if ProposalRequestReady snapshot proposal nonce then
    some (makeStatefulRequest snapshot.trust nonce proposal.delta)
  else
    none

theorem bound_request_uses_only_proposed_delta
    (snapshot : AtomicTrustSnapshot)
    (proposal : IsolatedProposal)
    (nonce : String) :
    (makeStatefulRequest snapshot.trust nonce proposal.delta).wire.delta =
      proposal.delta :=
  rfl

theorem stale_generation_cannot_bind
    (snapshot : AtomicTrustSnapshot)
    (proposal : IsolatedProposal)
    (nonce : String)
    (hGeneration : proposal.generation ≠ snapshot.generation) :
    bindProposalOrHold snapshot proposal nonce = none := by
  simp [bindProposalOrHold, ProposalRequestReady, ProposalAtSnapshot, hGeneration]

theorem unbounded_proposal_cannot_bind
    (snapshot : AtomicTrustSnapshot)
    (proposal : IsolatedProposal)
    (nonce : String)
    (hUnbounded : ¬ BoundedDelta proposal.delta) :
    bindProposalOrHold snapshot proposal nonce = none := by
  simp [bindProposalOrHold, ProposalRequestReady, ProposalAtSnapshot, hUnbounded]

theorem ready_proposal_binds
    (snapshot : AtomicTrustSnapshot)
    (proposal : IsolatedProposal)
    (nonce : String)
    (hReady : ProposalRequestReady snapshot proposal nonce) :
    bindProposalOrHold snapshot proposal nonce =
      some (makeStatefulRequest snapshot.trust nonce proposal.delta) := by
  simp [bindProposalOrHold, hReady]

end TMI.DigitalLifeProcessIsolation
