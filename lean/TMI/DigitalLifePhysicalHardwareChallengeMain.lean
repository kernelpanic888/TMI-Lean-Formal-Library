import TMI.DigitalLifePhysicalHardwareChallengeRuntime

open TMI.DigitalLifePhysicalHardwareChallengeRuntime

private def usage : String :=
  "i3_physical prepare <helper> <tag> <public-key>\n" ++
  "i3_physical issue <policy> <challenge-id> <issued-at> <lifetime> <challenge>\n" ++
  "i3_physical sign <helper> <tag> <challenge> <signature> <public-key>\n" ++
  "i3_physical verify-local <helper> <tag> <policy> <challenge> <signature> <public-key> <receipt> <now>"

private def hold (reason : String) : IO UInt32 := do
  IO.println s!"HOLD | {reason}"
  pure 2

def main (args : List String) : IO UInt32 := do
  match args with
  | ["prepare", helper, tag, publicKey] =>
      match (← prepareHardwareKey helper tag publicKey) with
      | some digest =>
          IO.println s!"HARDWARE KEY READY | public-digest={digest}"
          pure 0
      | none => hold "non-exportable hardware key preparation failed"
  | ["issue", policy, challengeId, issuedText, lifetimeText, challenge] =>
      match issuedText.toNat?, lifetimeText.toNat? with
      | some issuedAt, some lifetime =>
          if (← issuePhysicalChallenge policy challengeId issuedAt lifetime challenge) then
            IO.println s!"PHYSICAL CHALLENGE ISSUED | id={challengeId}"
            pure 0
          else hold "policy, challenge id or lifetime failed"
      | _, _ => hold "issued-at or lifetime is invalid"
  | ["sign", helper, tag, challenge, signature, publicKey] =>
      if (← signPhysicalChallenge helper tag challenge signature publicKey) then
        IO.println s!"SECURE HARDWARE SIGNATURE | {signature}"
        pure 0
      else hold "hardware signing operation failed"
  | ["verify-local", helper, tag, policy, challenge, signature, publicKey,
      receipt, nowText] =>
      match nowText.toNat? with
      | none => hold "verification time is invalid"
      | some now =>
          match (← verifyLocalHardwareChallenge helper tag policy challenge signature
              publicKey receipt now) with
          | .verified r digest =>
              IO.println s!"LOCAL HARDWARE PASS | provider={r.providerId} | receipt={digest}"
              IO.println "GLOBAL HARDWARE ADMISSION=HOLD | remote attestation and independent physical quorum absent"
              pure 0
          | .hold reason => hold reason
  | _ =>
      IO.eprintln usage
      pure 64
