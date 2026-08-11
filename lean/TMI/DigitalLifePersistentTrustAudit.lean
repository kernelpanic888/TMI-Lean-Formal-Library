import TMI.DigitalLifePersistentTrust

namespace TMI.DigitalLifePersistentTrustAudit

open TMI.DigitalLifeBoundedLearning
open TMI.DigitalLifeValidationAdapter
open TMI.DigitalLifeValidationCapability
open TMI.DigitalLifeValidationWire
open TMI.DigitalLifePersistentTrust

def manifest : String :=
  "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

def requestDigest : String :=
  "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"

def receiptDigest : String :=
  "cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc"

def nonce : String :=
  "dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd"

def state : PersistentTrustState :=
  { protocolVersion := persistentProtocolVersion
    validatorId := 17
    trustEpoch := 3
    keyId := 41
    lastRequestId := 9
    receiptHead := genesisReceiptHead
    manifestDigest := manifest
    learning := demoState
    consumedNonces := [] }

def request : StatefulWireRequest :=
  makeStatefulRequest state nonce (runTrainer state.learning.parameters demoTraining).delta

def receipt : StatefulWireReceipt :=
  { wire :=
      { protocolVersion := wireProtocolVersion
        requestId := request.wire.requestId
        requestDigest := requestDigest
        validatorId := state.validatorId
        manifestDigest := manifest
        modelIdentity := request.wire.modelIdentity
        modelVersion := request.wire.modelVersion
        proposalDigest := deltaDigest request.wire.delta
        beforeLoss := request.wire.baselineLoss
        candidateLoss := 0 }
    trustEpoch := state.trustEpoch
    keyId := state.keyId
    previousReceiptHead := state.receiptHead
    nonce := nonce }

example : PersistentAdmissible state request requestDigest receipt true := by
  native_decide

def advanced : PersistentTrustState :=
  advancePersistentState state request receipt receiptDigest

example : ¬ PersistentAdmissible advanced request requestDigest receipt true := by
  native_decide

example : request.nonce ∈ advanced.consumedNonces := by
  native_decide

def rotationNonce : String :=
  "eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"

def rotation : KeyRotationRequest :=
  makeKeyRotationRequest advanced 42 rotationNonce

example : KeyRotationAdmissible advanced rotation true := by
  native_decide

def rotated : PersistentTrustState :=
  advanceKeyRotation advanced rotation
    "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"

example : ¬ KeyRotationAdmissible rotated rotation true := by
  native_decide

def conflictingRotation : KeyRotationRequest :=
  { rotation with toKeyId := 43 }

example : KeyForkEvidence rotation conflictingRotation := by
  native_decide

#print axioms TMI.DigitalLifePersistentTrust.admissible_requires_fresh_nonce
#print axioms TMI.DigitalLifePersistentTrust.rotation_advances_epoch

end TMI.DigitalLifePersistentTrustAudit
