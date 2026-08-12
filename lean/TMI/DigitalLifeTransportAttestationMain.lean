import TMI.DigitalLifeTransportAttestationRuntime

open TMI.DigitalLifeTransportAttestationRuntime

private def usage : String :=
  "i3_attestation attest <policy> <remote-receipt> <issued-at> <lifetime> <boot-digest> <runtime-digest> <attestation-private-key> <attestation> <sig>\n" ++
  "i3_attestation observe <policy> <remote-receipt> <observed-at> <observer-private-key> <observation> <sig>\n" ++
  "i3_attestation verify <policy> <remote-receipt> <attestation> <attestation-sig> <observation> <observation-sig> <verifier-private-key> <receipt> <receipt-sig> <now>\n" ++
  "i3_attestation quorum <policy> <receipt-dir> <threshold> <certificate>"

private def hold (reason : String) : IO UInt32 := do
  IO.println s!"HOLD | {reason}"
  pure 2

def main (args : List String) : IO UInt32 := do
  match args with
  | ["attest", policy, remote, issuedText, lifetimeText, boot, runtime,
      privateKey, output, sig] =>
      match issuedText.toNat?, lifetimeText.toNat? with
      | some issuedAt, some lifetime =>
          if (← writeNodeAttestation policy remote issuedAt lifetime boot runtime
              privateKey output sig) then
            IO.println s!"SIGNED NODE ATTESTATION | {output}"
            pure 0
          else hold "node profile, measurement, lifetime or signature failed"
      | _, _ => hold "issued-at or lifetime is invalid"
  | ["observe", policy, remote, observedText, privateKey, output, sig] =>
      match observedText.toNat? with
      | some observedAt =>
          if (← writeTransportObservation policy remote observedAt privateKey output sig) then
            IO.println s!"SIGNED TRANSPORT OBSERVATION | {output}"
            pure 0
          else hold "observer profile or signature failed"
      | none => hold "observed-at is invalid"
  | ["verify", policy, remote, attestation, attestationSig, observation,
      observationSig, verifierPrivateKey, receipt, receiptSig, nowText] =>
      match nowText.toNat? with
      | some now =>
          match (← verifyAttestedEvidence policy remote attestation attestationSig
              observation observationSig verifierPrivateKey receipt receiptSig now) with
          | .verified r =>
              IO.println s!"INDEPENDENT NODE EVIDENCE VERIFIED | witness={r.witnessId} | node={r.nodeId} | custody={r.custodyDomain} | observer={r.observerId}"
              pure 0
          | .hold reason => hold reason
      | none => hold "verification time is invalid"
  | ["quorum", policy, receiptDir, thresholdText, certificate] =>
      match thresholdText.toNat? with
      | some threshold =>
          match (← evaluateAttestedQuorum policy receiptDir certificate threshold) with
          | .admitted c =>
              IO.println s!"ATTESTED MULTI-HOST QUORUM | {c.witnessIds.length}/{threshold} | {certificate}"
              pure 0
          | .hold reason => hold reason
      | none => hold "threshold is invalid"
  | _ =>
      IO.eprintln usage
      pure 64
