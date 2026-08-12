import TMI.DigitalLifeAtomicTrustStore

/-!
# I³-L07: external monotonic rollback witness

An atomic local store prevents concurrent writers from publishing two local
heads, but it cannot detect replacement of the entire filesystem by an older
snapshot.  This module introduces an independently retained, monotonic witness
of `(generation, receiptHead)` pairs.

The witness accepts only a signed immediate successor of its current anchor.
An older local snapshot is therefore distinguishable after the witness has
advanced.  The model deliberately does not prove that a concrete witness is
physically independent, durable, or uncompromised.
-/

namespace TMI.DigitalLifeExternalRollbackWitness

open TMI.DigitalLifeAtomicTrustStore

structure LocalAnchor where
  generation : Nat
  receiptHead : String
  deriving DecidableEq, Repr

def anchorOfSnapshot (snapshot : AtomicTrustSnapshot) : LocalAnchor :=
  { generation := snapshot.generation
    receiptHead := snapshot.trust.receiptHead }

structure WitnessState where
  witnessId : String
  sequence : Nat
  anchoredGeneration : Nat
  anchoredReceiptHead : String
  witnessHead : String
  consumedNonces : List String
  deriving DecidableEq, Repr

def anchorOfWitness (state : WitnessState) : LocalAnchor :=
  { generation := state.anchoredGeneration
    receiptHead := state.anchoredReceiptHead }

structure WitnessAppendIntent where
  witnessId : String
  expectedSequence : Nat
  expectedWitnessHead : String
  priorGeneration : Nat
  priorReceiptHead : String
  nextGeneration : Nat
  nextReceiptHead : String
  nonce : String
  checkpointDigest : String
  certificateVerified : Bool
  deriving DecidableEq, Repr

def WitnessAppendReady
    (current : WitnessState)
    (intent : WitnessAppendIntent) : Prop :=
  intent.witnessId = current.witnessId ∧
  intent.expectedSequence = current.sequence ∧
  intent.expectedWitnessHead = current.witnessHead ∧
  intent.priorGeneration = current.anchoredGeneration ∧
  intent.priorReceiptHead = current.anchoredReceiptHead ∧
  intent.nextGeneration = intent.priorGeneration + 1 ∧
  intent.nextReceiptHead ≠ intent.priorReceiptHead ∧
  intent.nonce ∉ current.consumedNonces ∧
  intent.certificateVerified = true

instance (current : WitnessState) (intent : WitnessAppendIntent) :
    Decidable (WitnessAppendReady current intent) := by
  unfold WitnessAppendReady
  infer_instance

def advanceWitness
    (current : WitnessState)
    (intent : WitnessAppendIntent) : WitnessState :=
  { witnessId := current.witnessId
    sequence := current.sequence + 1
    anchoredGeneration := intent.nextGeneration
    anchoredReceiptHead := intent.nextReceiptHead
    witnessHead := intent.checkpointDigest
    consumedNonces := intent.nonce :: current.consumedNonces }

def applyWitnessAppend
    (current : WitnessState)
    (intent : WitnessAppendIntent) : WitnessState :=
  if WitnessAppendReady current intent then
    advanceWitness current intent
  else
    current

def ExactAnchor (anchor : LocalAnchor) (witness : WitnessState) : Prop :=
  anchor.generation = witness.anchoredGeneration ∧
  anchor.receiptHead = witness.anchoredReceiptHead

def PendingWitness (anchor : LocalAnchor) (witness : WitnessState) : Prop :=
  anchor.generation = witness.anchoredGeneration + 1

def IsRollback (anchor : LocalAnchor) (witness : WitnessState) : Prop :=
  anchor.generation < witness.anchoredGeneration ∨
  (anchor.generation = witness.anchoredGeneration ∧
    anchor.receiptHead ≠ witness.anchoredReceiptHead)

inductive RollbackVerdict where
  | exact
  | pendingWitness
  | rollback
  | fork
  | generationGap
  deriving DecidableEq, Repr

def classifyLocal
    (anchor : LocalAnchor)
    (witness : WitnessState) : RollbackVerdict :=
  if anchor.generation < witness.anchoredGeneration then
    .rollback
  else if anchor.generation = witness.anchoredGeneration then
    if anchor.receiptHead = witness.anchoredReceiptHead then .exact else .fork
  else if anchor.generation = witness.anchoredGeneration + 1 then
    .pendingWitness
  else
    .generationGap

theorem witness_append_of_ready
    (h : WitnessAppendReady current intent) :
    applyWitnessAppend current intent = advanceWitness current intent := by
  simp [applyWitnessAppend, h]

theorem witness_hold_of_rejected
    (h : ¬ WitnessAppendReady current intent) :
    applyWitnessAppend current intent = current := by
  simp [applyWitnessAppend, h]

theorem witness_sequence_advances_once
    (h : WitnessAppendReady current intent) :
    (applyWitnessAppend current intent).sequence = current.sequence + 1 := by
  simp [applyWitnessAppend, h, advanceWitness]

theorem next_anchor_is_exact_after_append
    (h : WitnessAppendReady current intent) :
    ExactAnchor
      { generation := intent.nextGeneration, receiptHead := intent.nextReceiptHead }
      (applyWitnessAppend current intent) := by
  simp [ExactAnchor, applyWitnessAppend, h, advanceWitness]

theorem previous_anchor_is_rollback_after_append
    (h : WitnessAppendReady current intent) :
    IsRollback (anchorOfWitness current) (applyWitnessAppend current intent) := by
  rw [witness_append_of_ready h]
  left
  simp only [anchorOfWitness, advanceWitness]
  rw [h.2.2.2.2.2.1, h.2.2.2.1]
  exact Nat.lt_succ_self current.anchoredGeneration

theorem same_generation_different_head_is_rollback
    (hGeneration : anchor.generation = witness.anchoredGeneration)
    (hHead : anchor.receiptHead ≠ witness.anchoredReceiptHead) :
    IsRollback anchor witness := by
  exact Or.inr ⟨hGeneration, hHead⟩

theorem exact_anchor_not_rollback
    (hExact : ExactAnchor anchor witness) :
    ¬ IsRollback anchor witness := by
  intro hRollback
  rcases hRollback with hOlder | hFork
  · rw [hExact.1] at hOlder
    exact (Nat.lt_irrefl witness.anchoredGeneration) hOlder
  · exact hFork.2 hExact.2

end TMI.DigitalLifeExternalRollbackWitness
