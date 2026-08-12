import TMI.DigitalLifeFaultDomainQuorumRuntime

open TMI.DigitalLifeFaultDomainQuorumRuntime

private def usage : String :=
  "i3_domain_quorum vote <policy-file> <round> <witness-dir> <key-id> <private-key> <vote-file> <signature-file>\n" ++
  "i3_domain_quorum admit <policy-file> <atomic-store> <round> <vote-dir> <certificate-file>\n" ++
  "i3_domain_quorum verify <policy-file> <atomic-store> <round> <vote-dir> <certificate-file>"

private def emitHold (reason : String) : IO UInt32 := do
  IO.println s!"HOLD | {reason}"
  pure 2

private def emitOutcome : FaultDomainQuorumOutcome → IO UInt32
  | .admitted certificate => do
      IO.println s!"INDEPENDENT QUORUM ADMIT | policy={certificate.policyId} | round={certificate.round} | generation={certificate.anchor.generation} | head={certificate.anchor.receiptHead} | votes={certificate.witnessIds.length}/{certificate.threshold} | admin={certificate.adminDomains.length} | network={certificate.networkDomains.length} | host={certificate.hostDomains.length}"
      pure 0
  | .hold reason => emitHold reason

def main (args : List String) : IO UInt32 := do
  match args with
  | ["vote", policyPath, roundText, witnessDir, keyId, privateKey, votePath,
      signaturePath] =>
      match roundText.toNat? with
      | none => emitHold "round is invalid"
      | some round =>
          if (← writeSignedFaultDomainVote policyPath round witnessDir keyId
              privateKey votePath signaturePath) then
            IO.println s!"DOMAIN-BOUND WITNESS VOTE | round={round} | {votePath}"
            pure 0
          else emitHold "policy, witness state, key, round, or signature failed"
  | ["admit", policyPath, storePath, roundText, voteDir, certificatePath] =>
      match roundText.toNat? with
      | none => emitHold "round is invalid"
      | some round =>
          emitOutcome (← issueFaultDomainCertificate policyPath storePath round voteDir
            certificatePath)
  | ["verify", policyPath, storePath, roundText, voteDir, certificatePath] =>
      match roundText.toNat? with
      | none => emitHold "round is invalid"
      | some round =>
          if (← verifyFaultDomainCertificate policyPath storePath round voteDir
              certificatePath) then
            IO.println "INDEPENDENT QUORUM CERTIFICATE VERIFIED"
            pure 0
          else emitHold "certificate does not reproduce from domains, policy, target, and signed votes"
  | _ =>
      IO.eprintln usage
      pure 64
