import TMI.DigitalLifePersistentTrustRuntime

open TMI.DigitalLifeBoundedLearning
open TMI.DigitalLifeValidationAdapter
open TMI.DigitalLifePersistentTrust
open TMI.DigitalLifePersistentTrustRuntime
open TMI.DigitalLifeValidationWire
open TMI.DigitalLifeValidationWireRuntime

private def usage : String :=
  "i3_trainer request <request-file> <request-id> <manifest-sha256>\n" ++
  "i3_trainer verify <public-key> <request-file> <receipt-file> <signature-file> <validator-id>\n" ++
  "i3_trainer state-request <trust-file> <request-file> <nonce>\n" ++
  "i3_trainer state-verify <public-key> <trust-file> <request-file> <receipt-file> <signature-file>"

private def emitHold (reason : String) : IO UInt32 := do
  IO.println s!"HOLD | {reason}"
  pure 2

def main (args : List String) : IO UInt32 := do
  match args with
  | ["state-request", trustPath, requestPath, nonce] =>
      match (← readPersistentState trustPath) with
      | none => emitHold "persistent trust state parse failed"
      | some state =>
          if nonce.length != 64 || nonce ∈ state.consumedNonces then
            emitHold "nonce is malformed or already consumed"
          else
            let delta := (runTrainer state.learning.parameters demoTraining).delta
            let request := makeStatefulRequest state nonce delta
            writeStatefulRequest requestPath request
            IO.println s!"STATE REQUEST | id={request.wire.requestId} | epoch={request.trustEpoch} | key={request.keyId} | head={request.previousReceiptHead}"
            pure 0
  | ["state-verify", publicKey, trustPath, requestPath, receiptPath, signaturePath] =>
      match (← readPersistentState trustPath), (← readStatefulRequest requestPath),
          (← readStatefulReceipt receiptPath), (← sha256File requestPath),
          (← sha256File receiptPath) with
      | some state, some request, some receipt, some requestDigest, some receiptDigest =>
          let signatureVerified ← verifyFile publicKey receiptPath signaturePath
          if PersistentAdmissible state request requestDigest receipt signatureVerified then
            let next := advancePersistentState state request receipt receiptDigest
            writePersistentState trustPath next
            IO.println s!"ADMIT | model={next.learning.modelIdentity} | version={next.learning.version} | loss={next.learning.validationLoss} | receipt={next.learning.receipt} | request={next.lastRequestId} | head={next.receiptHead}"
            pure 0
          else
            emitHold "signature, request head, nonce, chain, model, delta, or loss gate failed"
      | _, _, _, _, _ => emitHold "trust, request, receipt, or digest parse failed"
  | ["request", requestPath, requestIdText, manifestDigest] =>
      match requestIdText.toNat? with
      | none => emitHold "invalid request id"
      | some requestId =>
          if manifestDigest.length != 64 then
            emitHold "manifest must be a SHA-256 hex digest"
          else
            let request := demoWireRequest requestId manifestDigest
            writeRequest requestPath request
            IO.println s!"REQUEST | id={requestId} | sample-free | {requestPath}"
            pure 0
  | ["verify", publicKey, requestPath, receiptPath, signaturePath, validatorIdText] =>
      match validatorIdText.toNat? with
      | none => emitHold "invalid validator id"
      | some validatorId =>
          match (← readRequest requestPath), (← readReceipt receiptPath),
              (← sha256File requestPath) with
          | some request, some receipt, some requestDigest =>
              let signatureVerified ← verifyFile publicKey receiptPath signaturePath
              let root : WireTrustRoot :=
                { validatorId, manifestDigest := request.manifestDigest }
              if WireAdmissible root request requestDigest receipt signatureVerified then
                let after := TMI.DigitalLifeBoundedLearning.candidateState
                  (requestState request) request.delta receipt.candidateLoss
                IO.println s!"ADMIT | model={after.modelIdentity} | version={after.version} | loss={after.validationLoss} | receipt={after.receipt}"
                pure 0
              else
                emitHold "signature, binding, replay, delta, baseline, or loss gate failed"
          | _, _, _ => emitHold "request, receipt, or digest parse failed"
  | _ =>
      IO.eprintln usage
      pure 64
