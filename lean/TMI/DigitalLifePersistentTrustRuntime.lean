import TMI.DigitalLifePersistentTrust
import TMI.DigitalLifeValidationWireRuntime

namespace TMI.DigitalLifePersistentTrustRuntime

open TMI.DigitalLifeNeuralProposer
open TMI.DigitalLifeBoundedLearning
open TMI.DigitalLifeValidationCapability
open TMI.DigitalLifeValidationWire
open TMI.DigitalLifePersistentTrust

def encodePersistentState (state : PersistentTrustState) : String :=
  String.intercalate "|"
    [ "I3TRUST1",
      toString state.protocolVersion,
      toString state.validatorId,
      toString state.trustEpoch,
      toString state.keyId,
      toString state.lastRequestId,
      state.receiptHead,
      state.manifestDigest,
      toString state.learning.modelIdentity,
      toString state.learning.version,
      toString (encodeInt state.learning.parameters.wx),
      toString (encodeInt state.learning.parameters.wy),
      toString (encodeInt state.learning.parameters.wz),
      toString (encodeInt state.learning.parameters.wm),
      toString (encodeInt state.learning.parameters.wr),
      toString (encodeInt state.learning.parameters.bias),
      toString state.learning.validationLoss,
      toString state.learning.receipt,
      String.intercalate "," state.consumedNonces ]

def parsePersistentState (text : String) : Option PersistentTrustState := do
  match text.trim.splitOn "|" with
  | [ "I3TRUST1", protocolVersion, validatorId, trustEpoch, keyId,
      lastRequestId, receiptHead, manifestDigest, modelIdentity, modelVersion,
      wx, wy, wz, wm, wr, bias, validationLoss, receiptIndex, consumed ] =>
      let protocolVersion ← protocolVersion.toNat?
      let validatorId ← validatorId.toNat?
      let trustEpoch ← trustEpoch.toNat?
      let keyId ← keyId.toNat?
      let lastRequestId ← lastRequestId.toNat?
      let modelIdentity ← modelIdentity.toNat?
      let modelVersion ← modelVersion.toNat?
      let wx ← wx.toNat?
      let wy ← wy.toNat?
      let wz ← wz.toNat?
      let wm ← wm.toNat?
      let wr ← wr.toNat?
      let bias ← bias.toNat?
      let validationLoss ← validationLoss.toNat?
      let receiptIndex ← receiptIndex.toNat?
      let consumedNonces := if consumed.isEmpty then [] else consumed.splitOn ","
      some
        { protocolVersion, validatorId, trustEpoch, keyId, lastRequestId,
          receiptHead, manifestDigest,
          learning :=
            { modelIdentity := modelIdentity
              version := modelVersion
              parameters :=
                { wx := decodeInt wx, wy := decodeInt wy, wz := decodeInt wz,
                  wm := decodeInt wm, wr := decodeInt wr, bias := decodeInt bias }
              validationLoss := validationLoss
              receipt := receiptIndex }
          consumedNonces }
  | _ => none

def readPersistentState (path : String) : IO (Option PersistentTrustState) := do
  pure (parsePersistentState (← IO.FS.readFile path))

def writePersistentState (path : String) (state : PersistentTrustState) : IO Unit :=
  IO.FS.writeFile path (encodePersistentState state ++ "\n")

def readStatefulRequest (path : String) : IO (Option StatefulWireRequest) := do
  pure (parseStatefulRequest (← IO.FS.readFile path))

def writeStatefulRequest (path : String) (request : StatefulWireRequest) : IO Unit :=
  IO.FS.writeFile path (encodeStatefulRequest request ++ "\n")

def readStatefulReceipt (path : String) : IO (Option StatefulWireReceipt) := do
  pure (parseStatefulReceipt (← IO.FS.readFile path))

def writeStatefulReceipt (path : String) (receipt : StatefulWireReceipt) : IO Unit :=
  IO.FS.writeFile path (encodeStatefulReceipt receipt ++ "\n")

def readKeyRotation (path : String) : IO (Option KeyRotationRequest) := do
  pure (parseKeyRotation (← IO.FS.readFile path))

def writeKeyRotation (path : String) (request : KeyRotationRequest) : IO Unit :=
  IO.FS.writeFile path (encodeKeyRotation request ++ "\n")

end TMI.DigitalLifePersistentTrustRuntime
