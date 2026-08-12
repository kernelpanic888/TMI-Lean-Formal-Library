import TMI.DigitalLifeHardwareAttestationRuntime

open TMI.DigitalLifeHardwareAttestationRuntime

private def usage : String :=
  "i3_hardware verify <policy> <l12-receipt> <l12-sig> <platform-receipt> <platform-sig> <now>\n" ++
  "i3_hardware approve <policy> <l12-receipt> <l12-sig> <platform-receipt> <platform-sig> <now> <verifier-id> <verifier-private-key> <approval> <approval-sig>\n" ++
  "i3_hardware quorum <policy> <l12-receipt> <l12-sig> <platform-receipt> <platform-sig> <now> <approval-dir> <certificate>"

private def hold (reason : String) : IO UInt32 := do
  IO.println s!"HOLD | {reason}"
  pure 2

def main (args : List String) : IO UInt32 := do
  match args with
  | ["verify", policy, base, baseSig, receipt, receiptSig, nowText] =>
      match nowText.toNat? with
      | none => hold "verification time is invalid"
      | some now =>
          match (← verifyHardwareReceipt policy base baseSig receipt receiptSig now) with
          | .verified b r digest =>
              IO.println s!"HARDWARE EVIDENCE VERIFIED | witness={b.witnessId} | node={b.nodeId} | platform={r.platformId} | digest={digest}"
              pure 0
          | .hold reason => hold reason
  | ["approve", policy, base, baseSig, receipt, receiptSig, nowText,
      verifierId, privateKey, approval, approvalSig] =>
      match nowText.toNat? with
      | none => hold "approval time is invalid"
      | some now =>
          if (← writeSplitApproval policy base baseSig receipt receiptSig now verifierId
              privateKey approval approvalSig) then
            IO.println s!"SPLIT APPROVAL SIGNED | verifier={verifierId} | {approval}"
            pure 0
          else hold "hardware evidence, verifier profile, private key or signature failed"
  | ["quorum", policy, base, baseSig, receipt, receiptSig, nowText,
      approvalDir, certificate] =>
      match nowText.toNat? with
      | none => hold "quorum time is invalid"
      | some now =>
          match (← evaluateHardwareQuorum policy base baseSig receipt receiptSig now
              approvalDir certificate) with
          | .admitted c =>
              IO.println s!"HARDWARE-BOUND SPLIT QUORUM | {c.verifierIds.length}/{c.threshold} | {certificate}"
              pure 0
          | .hold reason => hold reason
  | _ =>
      IO.eprintln usage
      pure 64
