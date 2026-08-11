import TMI.DigitalLifeValidationWire

/-!
# Persistent trust state for I3 learning

This layer makes the signed validation wire stateful.  A trainer request must
advance one monotone request identifier, start from the exact persisted model
state, continue the current receipt head, use the current validator key epoch,
and carry a nonce that has not been consumed before.  An admitted receipt
updates the model and the trust state together.

Key rotation is a separate signed transition.  The old key authorizes exactly
one successor trust epoch and a distinct key identifier.  Replaying the same
rotation against the advanced state is rejected.

Red boundary: persistence in an ordinary file survives a normal process
restart, but it is not rollback-proof storage, a transaction lock, an OS
sandbox, or a hardware trust anchor.  Cryptographic verification remains a
runtime premise supplied to this Lean refinement contract.
-/

namespace TMI.DigitalLifePersistentTrust

open TMI.DigitalLifeNeuralProposer
open TMI.DigitalLifeBoundedLearning
open TMI.DigitalLifeValidationCapability
open TMI.DigitalLifeValidationWire

def persistentProtocolVersion : Nat := 1

def genesisReceiptHead : String :=
  "0000000000000000000000000000000000000000000000000000000000000000"

structure PersistentTrustState where
  protocolVersion : Nat
  validatorId : Nat
  trustEpoch : Nat
  keyId : Nat
  lastRequestId : Nat
  receiptHead : String
  manifestDigest : String
  learning : LearningState
  consumedNonces : List String
  deriving DecidableEq, Repr

structure StatefulWireRequest where
  wire : WireRequest
  trustEpoch : Nat
  keyId : Nat
  previousReceiptHead : String
  nonce : String
  deriving DecidableEq, Repr

structure StatefulWireReceipt where
  wire : WireReceiptBody
  trustEpoch : Nat
  keyId : Nat
  previousReceiptHead : String
  nonce : String
  deriving DecidableEq, Repr

def wireRoot (state : PersistentTrustState) : WireTrustRoot :=
  { validatorId := state.validatorId
    manifestDigest := state.manifestDigest }

def RequestAtHead
    (state : PersistentTrustState)
    (request : StatefulWireRequest) : Prop :=
  request.wire.requestId = state.lastRequestId + 1 ∧
  requestState request.wire = state.learning ∧
  request.wire.manifestDigest = state.manifestDigest ∧
  request.trustEpoch = state.trustEpoch ∧
  request.keyId = state.keyId ∧
  request.previousReceiptHead = state.receiptHead

def ReceiptAtHead
    (state : PersistentTrustState)
    (request : StatefulWireRequest)
    (expectedRequestDigest : String)
    (receipt : StatefulWireReceipt) : Prop :=
  WireReceiptBound (wireRoot state) request.wire expectedRequestDigest receipt.wire ∧
  receipt.trustEpoch = state.trustEpoch ∧
  receipt.keyId = state.keyId ∧
  receipt.previousReceiptHead = state.receiptHead ∧
  receipt.nonce = request.nonce

def FreshNonce
    (state : PersistentTrustState)
    (request : StatefulWireRequest) : Prop :=
  request.nonce.length = 64 ∧ request.nonce ∉ state.consumedNonces

def PersistentReceiptBound
    (state : PersistentTrustState)
    (request : StatefulWireRequest)
    (expectedRequestDigest : String)
    (receipt : StatefulWireReceipt) : Prop :=
  RequestAtHead state request ∧
  ReceiptAtHead state request expectedRequestDigest receipt ∧
  FreshNonce state request

instance
    (state : PersistentTrustState)
    (request : StatefulWireRequest)
    (expectedRequestDigest : String)
    (receipt : StatefulWireReceipt) :
    Decidable (PersistentReceiptBound state request expectedRequestDigest receipt) := by
  unfold PersistentReceiptBound RequestAtHead ReceiptAtHead FreshNonce
  infer_instance

def PersistentAdmissible
    (state : PersistentTrustState)
    (request : StatefulWireRequest)
    (expectedRequestDigest : String)
    (receipt : StatefulWireReceipt)
    (signatureVerified : Bool) : Prop :=
  state.protocolVersion = persistentProtocolVersion ∧
  WireAdmissible (wireRoot state) request.wire expectedRequestDigest
    receipt.wire signatureVerified ∧
  PersistentReceiptBound state request expectedRequestDigest receipt

instance
    (state : PersistentTrustState)
    (request : StatefulWireRequest)
    (expectedRequestDigest : String)
    (receipt : StatefulWireReceipt)
    (signatureVerified : Bool) :
    Decidable
      (PersistentAdmissible state request expectedRequestDigest receipt signatureVerified) := by
  unfold PersistentAdmissible
  infer_instance

def advancePersistentState
    (state : PersistentTrustState)
    (request : StatefulWireRequest)
    (receipt : StatefulWireReceipt)
    (receiptDigest : String) : PersistentTrustState :=
  { state with
    lastRequestId := request.wire.requestId
    receiptHead := receiptDigest
    learning := candidateState state.learning request.wire.delta receipt.wire.candidateLoss
    consumedNonces := request.nonce :: state.consumedNonces }

def persistentLearnOrHold
    (state : PersistentTrustState)
    (request : StatefulWireRequest)
    (expectedRequestDigest : String)
    (receipt : StatefulWireReceipt)
    (receiptDigest : String)
    (signatureVerified : Bool) : PersistentTrustState :=
  if PersistentAdmissible state request expectedRequestDigest receipt signatureVerified then
    advancePersistentState state request receipt receiptDigest
  else
    state

def makeStatefulRequest
    (state : PersistentTrustState)
    (nonce : String)
    (delta : ParameterDelta) : StatefulWireRequest :=
  { wire :=
      { protocolVersion := wireProtocolVersion
        requestId := state.lastRequestId + 1
        modelIdentity := state.learning.modelIdentity
        modelVersion := state.learning.version
        receiptIndex := state.learning.receipt
        parameters := state.learning.parameters
        baselineLoss := state.learning.validationLoss
        delta := delta
        manifestDigest := state.manifestDigest }
    trustEpoch := state.trustEpoch
    keyId := state.keyId
    previousReceiptHead := state.receiptHead
    nonce := nonce }

theorem admissible_requires_next_request
    (h : PersistentAdmissible state request expectedRequestDigest receipt signatureVerified) :
    request.wire.requestId = state.lastRequestId + 1 :=
  h.2.2.1.1

theorem admissible_requires_current_model
    (h : PersistentAdmissible state request expectedRequestDigest receipt signatureVerified) :
    requestState request.wire = state.learning :=
  h.2.2.1.2.1

theorem admissible_requires_fresh_nonce
    (h : PersistentAdmissible state request expectedRequestDigest receipt signatureVerified) :
    request.nonce ∉ state.consumedNonces :=
  h.2.2.2.2.2

theorem accepted_consumes_nonce (receiptDigest : String) :
    request.nonce ∈
      (advancePersistentState state request receipt receiptDigest).consumedNonces := by
  simp [advancePersistentState]

theorem accepted_chains_receipt_head (receiptDigest : String) :
    (advancePersistentState state request receipt receiptDigest).receiptHead = receiptDigest :=
  rfl

theorem rejected_holds_state
    (receiptDigest : String)
    (h : ¬ PersistentAdmissible state request expectedRequestDigest receipt signatureVerified) :
    persistentLearnOrHold state request expectedRequestDigest receipt receiptDigest
      signatureVerified = state := by
  simp [persistentLearnOrHold, h]

structure KeyRotationRequest where
  protocolVersion : Nat
  validatorId : Nat
  fromEpoch : Nat
  fromKeyId : Nat
  toEpoch : Nat
  toKeyId : Nat
  previousReceiptHead : String
  nonce : String
  deriving DecidableEq, Repr

def KeyRotationBound
    (state : PersistentTrustState)
    (request : KeyRotationRequest) : Prop :=
  state.protocolVersion = persistentProtocolVersion ∧
  request.protocolVersion = persistentProtocolVersion ∧
  request.validatorId = state.validatorId ∧
  request.fromEpoch = state.trustEpoch ∧
  request.fromKeyId = state.keyId ∧
  request.toEpoch = state.trustEpoch + 1 ∧
  request.toKeyId ≠ state.keyId ∧
  request.previousReceiptHead = state.receiptHead ∧
  request.nonce.length = 64 ∧
  request.nonce ∉ state.consumedNonces

instance (state : PersistentTrustState) (request : KeyRotationRequest) :
    Decidable (KeyRotationBound state request) := by
  unfold KeyRotationBound
  infer_instance

def KeyRotationAdmissible
    (state : PersistentTrustState)
    (request : KeyRotationRequest)
    (signatureVerified : Bool) : Prop :=
  signatureVerified = true ∧ KeyRotationBound state request

instance
    (state : PersistentTrustState)
    (request : KeyRotationRequest)
    (signatureVerified : Bool) :
    Decidable (KeyRotationAdmissible state request signatureVerified) := by
  unfold KeyRotationAdmissible
  infer_instance

def advanceKeyRotation
    (state : PersistentTrustState)
    (request : KeyRotationRequest)
    (rotationDigest : String) : PersistentTrustState :=
  { state with
    trustEpoch := request.toEpoch
    keyId := request.toKeyId
    receiptHead := rotationDigest
    consumedNonces := request.nonce :: state.consumedNonces }

def rotateKeyOrHold
    (state : PersistentTrustState)
    (request : KeyRotationRequest)
    (rotationDigest : String)
    (signatureVerified : Bool) : PersistentTrustState :=
  if KeyRotationAdmissible state request signatureVerified then
    advanceKeyRotation state request rotationDigest
  else
    state

def makeKeyRotationRequest
    (state : PersistentTrustState)
    (toKeyId : Nat)
    (nonce : String) : KeyRotationRequest :=
  { protocolVersion := persistentProtocolVersion
    validatorId := state.validatorId
    fromEpoch := state.trustEpoch
    fromKeyId := state.keyId
    toEpoch := state.trustEpoch + 1
    toKeyId := toKeyId
    previousReceiptHead := state.receiptHead
    nonce := nonce }

def KeyForkEvidence (left right : KeyRotationRequest) : Prop :=
  left.validatorId = right.validatorId ∧
  left.fromEpoch = right.fromEpoch ∧
  left.fromKeyId = right.fromKeyId ∧
  left.previousReceiptHead = right.previousReceiptHead ∧
  (left.toEpoch ≠ right.toEpoch ∨ left.toKeyId ≠ right.toKeyId)

instance (left right : KeyRotationRequest) : Decidable (KeyForkEvidence left right) := by
  unfold KeyForkEvidence
  infer_instance

theorem rotation_requires_old_signature
    (h : KeyRotationAdmissible state request signatureVerified) :
    signatureVerified = true :=
  h.1

theorem rotation_advances_epoch
    (h : KeyRotationAdmissible state request signatureVerified) :
    request.toEpoch = state.trustEpoch + 1 :=
  h.2.2.2.2.2.2.1

theorem rotation_consumes_nonce (rotationDigest : String) :
    request.nonce ∈ (advanceKeyRotation state request rotationDigest).consumedNonces := by
  simp [advanceKeyRotation]

def encodeStatefulRequest (request : StatefulWireRequest) : String :=
  String.intercalate "|"
    [ "I3SREQ1",
      toString request.trustEpoch,
      toString request.keyId,
      request.previousReceiptHead,
      request.nonce,
      encodeRequest request.wire ]

def parseStatefulRequest (text : String) : Option StatefulWireRequest := do
  match text.trim.splitOn "|" with
  | "I3SREQ1" :: trustEpoch :: keyId :: previousReceiptHead :: nonce :: wireParts =>
      let trustEpoch ← trustEpoch.toNat?
      let keyId ← keyId.toNat?
      let wire ← parseRequest (String.intercalate "|" wireParts)
      some { wire, trustEpoch, keyId, previousReceiptHead, nonce }
  | _ => none

def encodeStatefulReceipt (receipt : StatefulWireReceipt) : String :=
  String.intercalate "|"
    [ "I3SREC1",
      toString receipt.trustEpoch,
      toString receipt.keyId,
      receipt.previousReceiptHead,
      receipt.nonce,
      encodeReceipt receipt.wire ]

def parseStatefulReceipt (text : String) : Option StatefulWireReceipt := do
  match text.trim.splitOn "|" with
  | "I3SREC1" :: trustEpoch :: keyId :: previousReceiptHead :: nonce :: wireParts =>
      let trustEpoch ← trustEpoch.toNat?
      let keyId ← keyId.toNat?
      let wire ← parseReceipt (String.intercalate "|" wireParts)
      some { wire, trustEpoch, keyId, previousReceiptHead, nonce }
  | _ => none

def encodeKeyRotation (request : KeyRotationRequest) : String :=
  String.intercalate "|"
    [ "I3ROT1",
      toString request.protocolVersion,
      toString request.validatorId,
      toString request.fromEpoch,
      toString request.fromKeyId,
      toString request.toEpoch,
      toString request.toKeyId,
      request.previousReceiptHead,
      request.nonce ]

def parseKeyRotation (text : String) : Option KeyRotationRequest := do
  match text.trim.splitOn "|" with
  | [ "I3ROT1", protocolVersion, validatorId, fromEpoch, fromKeyId,
      toEpoch, toKeyId, previousReceiptHead, nonce ] =>
      let protocolVersion ← protocolVersion.toNat?
      let validatorId ← validatorId.toNat?
      let fromEpoch ← fromEpoch.toNat?
      let fromKeyId ← fromKeyId.toNat?
      let toEpoch ← toEpoch.toNat?
      let toKeyId ← toKeyId.toNat?
      some
        { protocolVersion, validatorId, fromEpoch, fromKeyId, toEpoch, toKeyId,
          previousReceiptHead, nonce }
  | _ => none

end TMI.DigitalLifePersistentTrust
