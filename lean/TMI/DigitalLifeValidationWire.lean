import TMI.DigitalLifeValidationCapability

/-!
# Sample-free validation wire for I3 learning

The trainer sends model identity, version, parameters, a bounded parameter
delta, the current loss, a public holdout manifest digest, and a fresh request
identifier. No validation sample is present in the request.

The validator returns a receipt body bound to the exact request. Runtime code
must verify a real signature before setting `signatureVerified` to `true`.
Lean then admits the update only when the signature, trust root, request,
proposal, baseline, and non-increasing validation loss all agree.

Red boundary: this module proves the admission/refinement contract. It does not
prove Ed25519 security, operating-system isolation, dataset quality,
generalization, consciousness, digital life, or true AI.
-/

namespace TMI.DigitalLifeValidationWire

open TMI.DigitalLifeNeuralProposer
open TMI.DigitalLifeBoundedLearning
open TMI.DigitalLifeValidationAdapter
open TMI.DigitalLifeValidationCapability

def wireProtocolVersion : Nat := 1

structure WireRequest where
  protocolVersion : Nat
  requestId : Nat
  modelIdentity : Nat
  modelVersion : Nat
  receiptIndex : Nat
  parameters : NeuralParameters
  baselineLoss : Nat
  delta : ParameterDelta
  manifestDigest : String
  deriving DecidableEq, Repr

def requestState (request : WireRequest) : LearningState :=
  { modelIdentity := request.modelIdentity
    version := request.modelVersion
    parameters := request.parameters
    validationLoss := request.baselineLoss
    receipt := request.receiptIndex }

structure WireReceiptBody where
  protocolVersion : Nat
  requestId : Nat
  requestDigest : String
  validatorId : Nat
  manifestDigest : String
  modelIdentity : Nat
  modelVersion : Nat
  proposalDigest : Nat
  beforeLoss : Nat
  candidateLoss : Nat
  deriving DecidableEq, Repr

structure WireTrustRoot where
  validatorId : Nat
  manifestDigest : String
  deriving DecidableEq, Repr

def WireReceiptBound
    (root : WireTrustRoot)
    (request : WireRequest)
    (expectedRequestDigest : String)
    (receipt : WireReceiptBody) : Prop :=
  request.protocolVersion = wireProtocolVersion ∧
  receipt.protocolVersion = wireProtocolVersion ∧
  receipt.requestId = request.requestId ∧
  receipt.requestDigest = expectedRequestDigest ∧
  receipt.validatorId = root.validatorId ∧
  request.manifestDigest = root.manifestDigest ∧
  receipt.manifestDigest = root.manifestDigest ∧
  receipt.modelIdentity = request.modelIdentity ∧
  receipt.modelVersion = request.modelVersion ∧
  receipt.proposalDigest = deltaDigest request.delta ∧
  receipt.beforeLoss = request.baselineLoss

instance
    (root : WireTrustRoot)
    (request : WireRequest)
    (expectedRequestDigest : String)
    (receipt : WireReceiptBody) :
    Decidable (WireReceiptBound root request expectedRequestDigest receipt) := by
  unfold WireReceiptBound
  infer_instance

def WireAdmissible
    (root : WireTrustRoot)
    (request : WireRequest)
    (expectedRequestDigest : String)
    (receipt : WireReceiptBody)
    (signatureVerified : Bool) : Prop :=
  signatureVerified = true ∧
  BoundedDelta request.delta ∧
  WireReceiptBound root request expectedRequestDigest receipt ∧
  receipt.candidateLoss ≤ request.baselineLoss

instance
    (root : WireTrustRoot)
    (request : WireRequest)
    (expectedRequestDigest : String)
    (receipt : WireReceiptBody)
    (signatureVerified : Bool) :
    Decidable (WireAdmissible root request expectedRequestDigest receipt signatureVerified) := by
  unfold WireAdmissible
  infer_instance

def wireLearnOrHold
    (root : WireTrustRoot)
    (request : WireRequest)
    (expectedRequestDigest : String)
    (receipt : WireReceiptBody)
    (signatureVerified : Bool) : LearningState :=
  if WireAdmissible root request expectedRequestDigest receipt signatureVerified then
    candidateState (requestState request) request.delta receipt.candidateLoss
  else
    requestState request

theorem admissible_requires_signature
    (h : WireAdmissible root request expectedRequestDigest receipt signatureVerified) :
    signatureVerified = true :=
  h.1

theorem admissible_requires_request_binding
    (h : WireAdmissible root request expectedRequestDigest receipt signatureVerified) :
    WireReceiptBound root request expectedRequestDigest receipt :=
  h.2.2.1

theorem wire_accepts
    (hSignature : signatureVerified = true)
    (hDelta : BoundedDelta request.delta)
    (hBound : WireReceiptBound root request expectedRequestDigest receipt)
    (hLoss : receipt.candidateLoss ≤ request.baselineLoss) :
    wireLearnOrHold root request expectedRequestDigest receipt signatureVerified =
      candidateState (requestState request) request.delta receipt.candidateLoss := by
  simp [wireLearnOrHold, WireAdmissible, hSignature, hDelta, hBound, hLoss]

theorem wire_holds_without_signature :
    wireLearnOrHold root request expectedRequestDigest receipt false = requestState request := by
  simp [wireLearnOrHold, WireAdmissible]

theorem wire_holds_on_unbound_receipt
    (hUnbound : ¬ WireReceiptBound root request expectedRequestDigest receipt) :
    wireLearnOrHold root request expectedRequestDigest receipt signatureVerified =
      requestState request := by
  simp [wireLearnOrHold, WireAdmissible, hUnbound]

theorem wire_holds_on_worse_loss
    (hWorse : request.baselineLoss < receipt.candidateLoss) :
    wireLearnOrHold root request expectedRequestDigest receipt signatureVerified =
      requestState request := by
  simp [wireLearnOrHold, WireAdmissible, Nat.not_le_of_lt hWorse]

def encodeRequest (request : WireRequest) : String :=
  String.intercalate "|"
    [ "I3REQ1",
      toString request.protocolVersion,
      toString request.requestId,
      toString request.modelIdentity,
      toString request.modelVersion,
      toString request.receiptIndex,
      toString (encodeInt request.parameters.wx),
      toString (encodeInt request.parameters.wy),
      toString (encodeInt request.parameters.wz),
      toString (encodeInt request.parameters.wm),
      toString (encodeInt request.parameters.wr),
      toString (encodeInt request.parameters.bias),
      toString request.baselineLoss,
      toString (encodeInt request.delta.wx),
      toString (encodeInt request.delta.wy),
      toString (encodeInt request.delta.wz),
      toString (encodeInt request.delta.wm),
      toString (encodeInt request.delta.wr),
      toString (encodeInt request.delta.bias),
      request.manifestDigest ]

def decodeInt (value : Nat) : Int :=
  if value % 2 = 0 then Int.ofNat (value / 2) else Int.negSucc (value / 2)

def parseRequest (text : String) : Option WireRequest := do
  match text.trim.splitOn "|" with
  | [ "I3REQ1", protocol, requestId, modelIdentity, modelVersion, receiptIndex,
      wx, wy, wz, wm, wr, bias, baselineLoss,
      dx, dy, dz, dm, dr, db, manifestDigest ] =>
      let protocolVersion ← protocol.toNat?
      let requestId ← requestId.toNat?
      let modelIdentity ← modelIdentity.toNat?
      let modelVersion ← modelVersion.toNat?
      let receiptIndex ← receiptIndex.toNat?
      let wx ← wx.toNat?
      let wy ← wy.toNat?
      let wz ← wz.toNat?
      let wm ← wm.toNat?
      let wr ← wr.toNat?
      let bias ← bias.toNat?
      let baselineLoss ← baselineLoss.toNat?
      let dx ← dx.toNat?
      let dy ← dy.toNat?
      let dz ← dz.toNat?
      let dm ← dm.toNat?
      let dr ← dr.toNat?
      let db ← db.toNat?
      some
        { protocolVersion := protocolVersion
          requestId := requestId
          modelIdentity := modelIdentity
          modelVersion := modelVersion
          receiptIndex := receiptIndex
          parameters :=
            { wx := decodeInt wx, wy := decodeInt wy, wz := decodeInt wz
              wm := decodeInt wm, wr := decodeInt wr, bias := decodeInt bias }
          baselineLoss := baselineLoss
          delta :=
            { wx := decodeInt dx, wy := decodeInt dy, wz := decodeInt dz
              wm := decodeInt dm, wr := decodeInt dr, bias := decodeInt db }
          manifestDigest := manifestDigest }
  | _ => none

def encodeReceipt (receipt : WireReceiptBody) : String :=
  String.intercalate "|"
    [ "I3REC1",
      toString receipt.protocolVersion,
      toString receipt.requestId,
      receipt.requestDigest,
      toString receipt.validatorId,
      receipt.manifestDigest,
      toString receipt.modelIdentity,
      toString receipt.modelVersion,
      toString receipt.proposalDigest,
      toString receipt.beforeLoss,
      toString receipt.candidateLoss ]

def parseReceipt (text : String) : Option WireReceiptBody := do
  match text.trim.splitOn "|" with
  | [ "I3REC1", protocol, requestId, requestDigest, validatorId, manifestDigest,
      modelIdentity, modelVersion, proposalDigest, beforeLoss, candidateLoss ] =>
      let protocolVersion ← protocol.toNat?
      let requestId ← requestId.toNat?
      let validatorId ← validatorId.toNat?
      let modelIdentity ← modelIdentity.toNat?
      let modelVersion ← modelVersion.toNat?
      let proposalDigest ← proposalDigest.toNat?
      let beforeLoss ← beforeLoss.toNat?
      let candidateLoss ← candidateLoss.toNat?
      some
        { protocolVersion := protocolVersion
          requestId := requestId
          requestDigest := requestDigest
          validatorId := validatorId
          manifestDigest := manifestDigest
          modelIdentity := modelIdentity
          modelVersion := modelVersion
          proposalDigest := proposalDigest
          beforeLoss := beforeLoss
          candidateLoss := candidateLoss }
  | _ => none

def demoWireRequest (requestId : Nat) (manifestDigest : String) : WireRequest :=
  { protocolVersion := wireProtocolVersion
    requestId := requestId
    modelIdentity := demoState.modelIdentity
    modelVersion := demoState.version
    receiptIndex := demoState.receipt
    parameters := demoState.parameters
    baselineLoss := demoState.validationLoss
    delta := (runTrainer demoState.parameters demoTraining).delta
    manifestDigest := manifestDigest }

end TMI.DigitalLifeValidationWire
