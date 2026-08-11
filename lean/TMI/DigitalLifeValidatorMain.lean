import TMI.DigitalLifePersistentTrustRuntime

open TMI.DigitalLifeBoundedLearning
open TMI.DigitalLifePersistentTrust
open TMI.DigitalLifePersistentTrustRuntime
open TMI.DigitalLifeValidationAdapter
open TMI.DigitalLifeValidationCapability
open TMI.DigitalLifeValidationWire
open TMI.DigitalLifeValidationWireRuntime

private def usage : String :=
  "i3_validator <private-key> <holdout-file> <request-file> <receipt-file> <signature-file> <validator-id>\n" ++
  "i3_validator stateful <private-key> <holdout-file> <request-file> <receipt-file> <signature-file> <validator-id> <trust-epoch> <key-id>"

private def emitHold (reason : String) : IO UInt32 := do
  IO.println s!"HOLD | {reason}"
  pure 2

def main (args : List String) : IO UInt32 := do
  match args with
  | ["stateful", privateKey, holdoutPath, requestPath, receiptPath, signaturePath,
      validatorIdText, epochText, keyIdText] =>
      match validatorIdText.toNat?, epochText.toNat?, keyIdText.toNat? with
      | some validatorId, some trustEpoch, some keyId =>
          match (← readHoldout holdoutPath), (← readStatefulRequest requestPath),
              (← sha256File holdoutPath), (← sha256File requestPath) with
          | some holdout, some request, some manifestDigest, some requestDigest =>
              if manifestDigest != request.wire.manifestDigest then
                emitHold "holdout manifest mismatch"
              else if request.trustEpoch != trustEpoch || request.keyId != keyId then
                emitHold "validator trust epoch or key id mismatch"
              else if hDelta : BoundedDelta request.wire.delta then
                let before := requestState request.wire
                let proposal : TrainingProposal :=
                  { delta := request.wire.delta, bounded := hDelta }
                let report := runValidator before holdout.view proposal
                let wireReceipt : WireReceiptBody :=
                  { protocolVersion := wireProtocolVersion
                    requestId := request.wire.requestId
                    requestDigest := requestDigest
                    validatorId := validatorId
                    manifestDigest := manifestDigest
                    modelIdentity := request.wire.modelIdentity
                    modelVersion := request.wire.modelVersion
                    proposalDigest := deltaDigest request.wire.delta
                    beforeLoss := report.beforeLoss
                    candidateLoss := report.candidateLoss }
                let receipt : StatefulWireReceipt :=
                  { wire := wireReceipt
                    trustEpoch := trustEpoch
                    keyId := keyId
                    previousReceiptHead := request.previousReceiptHead
                    nonce := request.nonce }
                writeStatefulReceipt receiptPath receipt
                if (← signFile privateKey receiptPath signaturePath) then
                  IO.println s!"STATEFUL SIGNED | request={request.wire.requestId} | epoch={trustEpoch} | key={keyId} | loss={report.beforeLoss}->{report.candidateLoss}"
                  pure 0
                else
                  emitHold "Ed25519 signing failed"
              else
                emitHold "proposal delta is outside the formal field"
          | _, _, _, _ => emitHold "holdout, request, or SHA-256 parse failed"
      | _, _, _ => emitHold "invalid validator, epoch, or key id"
  | [privateKey, holdoutPath, requestPath, receiptPath, signaturePath, validatorIdText] =>
      match validatorIdText.toNat? with
      | none => emitHold "invalid validator id"
      | some validatorId =>
          match (← readHoldout holdoutPath), (← readRequest requestPath),
              (← sha256File holdoutPath), (← sha256File requestPath) with
          | some holdout, some request, some manifestDigest, some requestDigest =>
              if manifestDigest != request.manifestDigest then
                emitHold "holdout manifest mismatch"
              else if hDelta : BoundedDelta request.delta then
                let before := requestState request
                let proposal : TrainingProposal :=
                  { delta := request.delta, bounded := hDelta }
                let report := runValidator before holdout.view proposal
                let receipt : WireReceiptBody :=
                  { protocolVersion := wireProtocolVersion
                    requestId := request.requestId
                    requestDigest := requestDigest
                    validatorId := validatorId
                    manifestDigest := manifestDigest
                    modelIdentity := request.modelIdentity
                    modelVersion := request.modelVersion
                    proposalDigest := deltaDigest request.delta
                    beforeLoss := report.beforeLoss
                    candidateLoss := report.candidateLoss }
                writeReceipt receiptPath receipt
                if (← signFile privateKey receiptPath signaturePath) then
                  IO.println s!"SIGNED | request={request.requestId} | validator={validatorId} | loss={report.beforeLoss}->{report.candidateLoss}"
                  pure 0
                else
                  emitHold "Ed25519 signing failed"
              else
                emitHold "proposal delta is outside the formal field"
          | _, _, _, _ => emitHold "holdout, request, or SHA-256 parse failed"
  | _ =>
      IO.eprintln usage
      pure 64
