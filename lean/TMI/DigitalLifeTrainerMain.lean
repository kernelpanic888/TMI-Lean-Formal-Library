import TMI.DigitalLifeValidationWireRuntime

open TMI.DigitalLifeValidationWire
open TMI.DigitalLifeValidationWireRuntime

private def usage : String :=
  "i3_trainer request <request-file> <request-id> <manifest-sha256>\n" ++
  "i3_trainer verify <public-key> <request-file> <receipt-file> <signature-file> <validator-id>"

private def emitHold (reason : String) : IO UInt32 := do
  IO.println s!"HOLD | {reason}"
  pure 2

def main (args : List String) : IO UInt32 := do
  match args with
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
