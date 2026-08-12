import TMI.DigitalLifeWitnessQuorumRuntime

open TMI.DigitalLifeWitnessQuorumRuntime

private def usage : String :=
  "i3_quorum vote <policy-id> <round> <witness-dir> <key-id> <private-key> <vote-file> <signature-file>\n" ++
  "i3_quorum admit <policy-file> <atomic-store> <round> <vote-dir> <certificate-file>\n" ++
  "i3_quorum verify <policy-file> <atomic-store> <round> <vote-dir> <certificate-file>"

private def emitHold (reason : String) : IO UInt32 := do
  IO.println s!"HOLD | {reason}"
  pure 2

private def emitOutcome : QuorumOutcome → IO UInt32
  | .admitted certificate => do
      IO.println s!"QUORUM ADMIT | policy={certificate.policyId} | round={certificate.round} | generation={certificate.anchor.generation} | head={certificate.anchor.receiptHead} | votes={certificate.witnessIds.length}/{certificate.threshold}"
      pure 0
  | .hold reason => emitHold reason

def main (args : List String) : IO UInt32 := do
  match args with
  | ["vote", policyId, roundText, witnessDir, keyId, privateKey, votePath,
      signaturePath] =>
      match roundText.toNat? with
      | none => emitHold "round is invalid"
      | some round =>
          if (← writeSignedVote policyId round witnessDir keyId privateKey votePath signaturePath) then
            IO.println s!"WITNESS VOTE | policy={policyId} | round={round} | {votePath}"
            pure 0
          else emitHold "witness state, key, round, or signature failed"
  | ["admit", policyPath, storePath, roundText, voteDir, certificatePath] =>
      match roundText.toNat? with
      | none => emitHold "round is invalid"
      | some round => emitOutcome (← issueCertificate policyPath storePath round voteDir certificatePath)
  | ["verify", policyPath, storePath, roundText, voteDir, certificatePath] =>
      match roundText.toNat? with
      | none => emitHold "round is invalid"
      | some round =>
          if (← verifyCertificate policyPath storePath round voteDir certificatePath) then
            IO.println "QUORUM CERTIFICATE VERIFIED"
            pure 0
          else emitHold "certificate does not reproduce from policy, target, and signed votes"
  | _ =>
      IO.eprintln usage
      pure 64
