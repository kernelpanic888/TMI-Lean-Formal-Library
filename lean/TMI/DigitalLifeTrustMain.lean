import TMI.DigitalLifePersistentTrustRuntime

open TMI.DigitalLifeBoundedLearning
open TMI.DigitalLifeValidationAdapter
open TMI.DigitalLifePersistentTrust
open TMI.DigitalLifePersistentTrustRuntime
open TMI.DigitalLifeValidationWireRuntime

private def usage : String :=
  "i3_trust init <trust-file> <manifest-sha256> <validator-id> <trust-epoch> <key-id>\n" ++
  "i3_trust nonce\n" ++
  "i3_trust rotation-request <trust-file> <rotation-file> <new-key-id> <nonce>\n" ++
  "i3_trust rotation-sign <old-private-key> <rotation-file> <signature-file>\n" ++
  "i3_trust rotation-apply <old-public-key> <trust-file> <rotation-file> <signature-file>\n" ++
  "i3_trust show <trust-file>"

private def emitHold (reason : String) : IO UInt32 := do
  IO.println s!"HOLD | {reason}"
  pure 2

private def randomNonce : IO (Option String) := do
  let openssl ← opensslCommand
  let result ← IO.Process.output { cmd := openssl, args := #["rand", "-hex", "32"] }
  if result.exitCode = 0 && result.stdout.trim.length = 64 then
    pure (some result.stdout.trim)
  else
    pure none

def main (args : List String) : IO UInt32 := do
  match args with
  | ["init", trustPath, manifestDigest, validatorIdText, epochText, keyIdText] =>
      match validatorIdText.toNat?, epochText.toNat?, keyIdText.toNat? with
      | some validatorId, some trustEpoch, some keyId =>
          if manifestDigest.length != 64 then
            emitHold "manifest must be a SHA-256 hex digest"
          else
            let state : PersistentTrustState :=
              { protocolVersion := persistentProtocolVersion
                validatorId, trustEpoch, keyId
                lastRequestId := 0
                receiptHead := genesisReceiptHead
                manifestDigest
                learning := demoState
                consumedNonces := [] }
            writePersistentState trustPath state
            IO.println s!"TRUST INIT | validator={validatorId} | epoch={trustEpoch} | key={keyId}"
            pure 0
      | _, _, _ => emitHold "invalid validator, epoch, or key id"
  | ["nonce"] =>
      match (← randomNonce) with
      | some nonce => IO.println nonce; pure 0
      | none => emitHold "nonce generation failed"
  | ["rotation-request", trustPath, rotationPath, newKeyIdText, nonce] =>
      match newKeyIdText.toNat?, (← readPersistentState trustPath) with
      | some newKeyId, some state =>
          if nonce.length != 64 || nonce ∈ state.consumedNonces then
            emitHold "nonce is malformed or already consumed"
          else if newKeyId = state.keyId then
            emitHold "new key id must differ from current key id"
          else
            let request := makeKeyRotationRequest state newKeyId nonce
            writeKeyRotation rotationPath request
            IO.println s!"ROTATION REQUEST | epoch={request.fromEpoch}->{request.toEpoch} | key={request.fromKeyId}->{request.toKeyId}"
            pure 0
      | _, _ => emitHold "trust state or new key id is invalid"
  | ["rotation-sign", privateKey, rotationPath, signaturePath] =>
      if (← signFile privateKey rotationPath signaturePath) then
        IO.println "ROTATION SIGNED"
        pure 0
      else
        emitHold "rotation signing failed"
  | ["rotation-apply", publicKey, trustPath, rotationPath, signaturePath] =>
      match (← readPersistentState trustPath), (← readKeyRotation rotationPath),
          (← sha256File rotationPath) with
      | some state, some request, some rotationDigest =>
          let signatureVerified ← verifyFile publicKey rotationPath signaturePath
          if KeyRotationAdmissible state request signatureVerified then
            let next := advanceKeyRotation state request rotationDigest
            writePersistentState trustPath next
            IO.println s!"ROTATION ADMIT | epoch={next.trustEpoch} | key={next.keyId} | head={next.receiptHead}"
            pure 0
          else
            emitHold "signature, epoch, key, head, or nonce gate failed"
      | _, _, _ => emitHold "trust state, rotation, or digest parse failed"
  | ["show", trustPath] =>
      match (← readPersistentState trustPath) with
      | some state =>
          IO.println s!"TRUST | validator={state.validatorId} | epoch={state.trustEpoch} | key={state.keyId} | request={state.lastRequestId} | receipt={state.learning.receipt} | head={state.receiptHead} | nonces={state.consumedNonces.length}"
          pure 0
      | none => emitHold "trust state parse failed"
  | _ =>
      IO.eprintln usage
      pure 64
