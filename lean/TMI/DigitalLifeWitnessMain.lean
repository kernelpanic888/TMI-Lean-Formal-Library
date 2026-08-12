import TMI.DigitalLifeExternalRollbackWitnessRuntime

open TMI.DigitalLifeExternalRollbackWitness
open TMI.DigitalLifeExternalRollbackWitnessRuntime

private def usage : String :=
  "i3_witness init <witness-dir> <atomic-store> <witness-id>\n" ++
  "i3_witness request <witness-dir> <atomic-store> <request-file> <nonce> <key-id>\n" ++
  "i3_witness append <trusted-public-key> <trusted-key-id> <witness-dir> <request-file> <signature-file>\n" ++
  "i3_witness check <witness-dir> <atomic-store>\n" ++
  "i3_witness show <witness-dir>"

private def emitHold (reason : String) : IO UInt32 := do
  IO.println s!"HOLD | {reason}"
  pure 2

private def emitOutcome : WitnessAppendOutcome → IO UInt32
  | .appended state => do
      IO.println s!"WITNESS ADMIT | id={state.witnessId} | sequence={state.sequence} | generation={state.anchoredGeneration} | local-head={state.anchoredReceiptHead} | witness-head={state.witnessHead}"
      pure 0
  | .stale state =>
      emitHold s!"stale witness compare-and-swap | sequence={state.sequence} | witness-head={state.witnessHead}"
  | .rejected reason => emitHold reason
  | .lockBusy => emitHold "external witness lock is busy"

private def emitVerdict : RollbackVerdict → IO UInt32
  | .exact => do
      IO.println "WITNESS EXACT | local generation and HEAD match the external anchor"
      pure 0
  | .pendingWitness => do
      IO.println "PENDING WITNESS | local state is one generation ahead; no further local transition is admissible"
      pure 3
  | .rollback => emitHold "ROLLBACK DETECTED | local generation is older than the external anchor"
  | .fork => emitHold "FORK DETECTED | generation matches but local HEAD differs"
  | .generationGap => emitHold "GENERATION GAP | local state is more than one generation ahead"

def main (args : List String) : IO UInt32 := do
  match args with
  | ["init", root, storePath, witnessId] =>
      if (← initializeWitness root storePath witnessId) then
        IO.println "WITNESS INIT | immutable checkpoint 0"
        pure 0
      else
        emitHold "witness directory is not empty, store is invalid, or lock is busy"
  | ["request", root, storePath, requestPath, nonce, keyId] =>
      match (← makeWitnessRequest root storePath requestPath nonce keyId) with
      | none => emitHold "local state is not the next unwitnessed generation or request fields are invalid"
      | some request => do
          IO.println s!"WITNESS REQUEST | id={request.witnessId} | expected-sequence={request.expectedSequence} | generation={request.priorGeneration}→{request.nextGeneration} | key={request.keyId}"
          pure 0
  | ["append", publicKey, keyId, root, requestPath, signaturePath] =>
      emitOutcome (← appendWitness publicKey keyId root requestPath signaturePath)
  | ["check", root, storePath] =>
      match (← checkLocal root storePath) with
      | none => emitHold "witness log or atomic store is invalid"
      | some verdict => emitVerdict verdict
  | ["show", root] =>
      match (← readWitnessState root) with
      | none => emitHold "witness log is invalid"
      | some state => do
          IO.println s!"EXTERNAL WITNESS | id={state.witnessId} | sequence={state.sequence} | generation={state.anchoredGeneration} | local-head={state.anchoredReceiptHead} | witness-head={state.witnessHead} | nonces={state.consumedNonces.length}"
          pure 0
  | _ =>
      IO.eprintln usage
      pure 64
