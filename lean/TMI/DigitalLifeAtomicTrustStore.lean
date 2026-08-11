import TMI.DigitalLifePersistentTrust

/-!
# I³-L06: atomic trust store

This module separates a verified persistent transition from the act of winning
the right to publish it.  A writer must match both the current generation and
the current receipt head.  A successful commit advances the generation once;
all stale or inadmissible intents leave the snapshot unchanged.

The runtime counterpart implements the critical section with an exclusive
lock directory and same-directory atomic rename.  This file specifies the
state transition only; it does not claim filesystem durability, lock recovery,
or protection against rollback of the storage device itself.
-/

namespace TMI.DigitalLifeAtomicTrustStore

open TMI.DigitalLifePersistentTrust

structure AtomicTrustSnapshot where
  generation : Nat
  trust : PersistentTrustState
  deriving DecidableEq, Repr

def AtomicHeadMatches
    (current : AtomicTrustSnapshot)
    (expectedGeneration : Nat)
    (expectedReceiptHead : String) : Prop :=
  expectedGeneration = current.generation ∧
  expectedReceiptHead = current.trust.receiptHead

instance (current : AtomicTrustSnapshot) (generation : Nat) (head : String) :
    Decidable (AtomicHeadMatches current generation head) := by
  unfold AtomicHeadMatches
  infer_instance

structure ReceiptCommitIntent where
  expectedGeneration : Nat
  expectedReceiptHead : String
  request : StatefulWireRequest
  requestDigest : String
  receipt : StatefulWireReceipt
  receiptDigest : String
  signatureVerified : Bool
  deriving DecidableEq, Repr

def ReceiptCASReady
    (current : AtomicTrustSnapshot)
    (intent : ReceiptCommitIntent) : Prop :=
  AtomicHeadMatches current intent.expectedGeneration intent.expectedReceiptHead ∧
  PersistentAdmissible current.trust intent.request intent.requestDigest
    intent.receipt intent.signatureVerified

instance (current : AtomicTrustSnapshot) (intent : ReceiptCommitIntent) :
    Decidable (ReceiptCASReady current intent) := by
  unfold ReceiptCASReady
  infer_instance

def applyReceiptCAS
    (current : AtomicTrustSnapshot)
    (intent : ReceiptCommitIntent) : AtomicTrustSnapshot :=
  if ReceiptCASReady current intent then
    { generation := current.generation + 1
      trust := advancePersistentState current.trust intent.request intent.receipt
        intent.receiptDigest }
  else
    current

structure RotationCommitIntent where
  expectedGeneration : Nat
  expectedReceiptHead : String
  request : KeyRotationRequest
  rotationDigest : String
  signatureVerified : Bool
  deriving DecidableEq, Repr

def RotationCASReady
    (current : AtomicTrustSnapshot)
    (intent : RotationCommitIntent) : Prop :=
  AtomicHeadMatches current intent.expectedGeneration intent.expectedReceiptHead ∧
  KeyRotationAdmissible current.trust intent.request intent.signatureVerified

instance (current : AtomicTrustSnapshot) (intent : RotationCommitIntent) :
    Decidable (RotationCASReady current intent) := by
  unfold RotationCASReady
  infer_instance

def applyRotationCAS
    (current : AtomicTrustSnapshot)
    (intent : RotationCommitIntent) : AtomicTrustSnapshot :=
  if RotationCASReady current intent then
    { generation := current.generation + 1
      trust := advanceKeyRotation current.trust intent.request intent.rotationDigest }
  else
    current

theorem receipt_commit_of_ready
    (h : ReceiptCASReady current intent) :
    applyReceiptCAS current intent =
      { generation := current.generation + 1
        trust := advancePersistentState current.trust intent.request intent.receipt
          intent.receiptDigest } := by
  simp [applyReceiptCAS, h]

theorem receipt_hold_of_rejected
    (h : ¬ ReceiptCASReady current intent) :
    applyReceiptCAS current intent = current := by
  simp [applyReceiptCAS, h]

theorem rotation_commit_of_ready
    (h : RotationCASReady current intent) :
    applyRotationCAS current intent =
      { generation := current.generation + 1
        trust := advanceKeyRotation current.trust intent.request intent.rotationDigest } := by
  simp [applyRotationCAS, h]

theorem rotation_hold_of_rejected
    (h : ¬ RotationCASReady current intent) :
    applyRotationCAS current intent = current := by
  simp [applyRotationCAS, h]

theorem receipt_commit_invalidates_same_generation
    (current : AtomicTrustSnapshot)
    (first second : ReceiptCommitIntent)
    (hReady : ReceiptCASReady current first)
    (hSame : second.expectedGeneration = first.expectedGeneration) :
    ¬ AtomicHeadMatches (applyReceiptCAS current first)
      second.expectedGeneration second.expectedReceiptHead := by
  intro hAfter
  have hFirst : first.expectedGeneration = current.generation := hReady.1.1
  have hSecond : second.expectedGeneration = current.generation + 1 := by
    simpa [applyReceiptCAS, hReady] using hAfter.1
  have impossible : current.generation = current.generation + 1 := by
    calc
      current.generation = first.expectedGeneration := hFirst.symm
      _ = second.expectedGeneration := hSame.symm
      _ = current.generation + 1 := hSecond
  exact (Nat.ne_of_lt (by simpa using Nat.lt_succ_self current.generation)) impossible

theorem rotation_commit_invalidates_same_generation
    (current : AtomicTrustSnapshot)
    (first second : RotationCommitIntent)
    (hReady : RotationCASReady current first)
    (hSame : second.expectedGeneration = first.expectedGeneration) :
    ¬ AtomicHeadMatches (applyRotationCAS current first)
      second.expectedGeneration second.expectedReceiptHead := by
  intro hAfter
  have hFirst : first.expectedGeneration = current.generation := hReady.1.1
  have hSecond : second.expectedGeneration = current.generation + 1 := by
    simpa [applyRotationCAS, hReady] using hAfter.1
  have impossible : current.generation = current.generation + 1 := by
    calc
      current.generation = first.expectedGeneration := hFirst.symm
      _ = second.expectedGeneration := hSame.symm
      _ = current.generation + 1 := hSecond
  exact (Nat.ne_of_lt (by simpa using Nat.lt_succ_self current.generation)) impossible

end TMI.DigitalLifeAtomicTrustStore
