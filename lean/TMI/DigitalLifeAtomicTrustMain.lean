import TMI.DigitalLifeAtomicTrustStoreRuntime

open TMI.DigitalLifeAtomicTrustStore
open TMI.DigitalLifeAtomicTrustStoreRuntime

private def usage : String :=
  "i3_trust_tx init <store-file> <persistent-trust-file>\n" ++
  "i3_trust_tx request <store-file> <request-file> <nonce>\n" ++
  "i3_trust_tx commit-receipt <public-key> <store-file> <request-file> <receipt-file> <signature-file> <expected-generation> <expected-head>\n" ++
  "i3_trust_tx commit-rotation <old-public-key> <store-file> <rotation-file> <signature-file> <expected-generation> <expected-head>\n" ++
  "i3_trust_tx show <store-file>"

private def emitHold (reason : String) : IO UInt32 := do
  IO.println s!"HOLD | {reason}"
  pure 2

private def emitOutcome : AtomicCommitOutcome → IO UInt32
  | .committed snapshot => do
      IO.println s!"ATOMIC ADMIT | generation={snapshot.generation} | epoch={snapshot.trust.trustEpoch} | key={snapshot.trust.keyId} | request={snapshot.trust.lastRequestId} | receipt={snapshot.trust.learning.receipt} | head={snapshot.trust.receiptHead}"
      pure 0
  | .stale snapshot =>
      emitHold s!"stale compare-and-swap | generation={snapshot.generation} | head={snapshot.trust.receiptHead}"
  | .rejected reason => emitHold reason
  | .lockBusy => emitHold "atomic trust store lock is busy"

def main (args : List String) : IO UInt32 := do
  match args with
  | ["init", storePath, trustPath] =>
      if (← initializeAtomicStore storePath trustPath) then
        IO.println "ATOMIC STORE INIT | generation=0"
        pure 0
      else
        emitHold "persistent trust state is invalid or store lock is busy"
  | ["request", storePath, requestPath, nonce] =>
      match (← makeAtomicRequest storePath requestPath nonce) with
      | none => emitHold "store, nonce, or request generation failed"
      | some (snapshot, request) =>
          IO.println s!"ATOMIC REQUEST | generation={snapshot.generation} | head={snapshot.trust.receiptHead} | request={request.wire.requestId} | epoch={request.trustEpoch} | key={request.keyId}"
          pure 0
  | ["commit-receipt", publicKey, storePath, requestPath, receiptPath,
      signaturePath, generationText, expectedHead] =>
      match generationText.toNat? with
      | none => emitHold "expected generation is invalid"
      | some generation =>
          emitOutcome (← commitReceiptCAS publicKey storePath requestPath receiptPath
            signaturePath generation expectedHead)
  | ["commit-rotation", publicKey, storePath, rotationPath, signaturePath,
      generationText, expectedHead] =>
      match generationText.toNat? with
      | none => emitHold "expected generation is invalid"
      | some generation =>
          emitOutcome (← commitRotationCAS publicKey storePath rotationPath signaturePath
            generation expectedHead)
  | ["show", storePath] =>
      match (← readAtomicSnapshot storePath) with
      | none => emitHold "atomic trust store parse failed"
      | some snapshot =>
          IO.println s!"ATOMIC TRUST | generation={snapshot.generation} | validator={snapshot.trust.validatorId} | epoch={snapshot.trust.trustEpoch} | key={snapshot.trust.keyId} | request={snapshot.trust.lastRequestId} | receipt={snapshot.trust.learning.receipt} | head={snapshot.trust.receiptHead} | nonces={snapshot.trust.consumedNonces.length}"
          pure 0
  | _ =>
      IO.eprintln usage
      pure 64
