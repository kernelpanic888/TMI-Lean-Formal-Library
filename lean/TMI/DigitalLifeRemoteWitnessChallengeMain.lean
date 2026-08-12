import TMI.DigitalLifeRemoteWitnessChallengeRuntime

open TMI.DigitalLifeRemoteWitnessChallengeRuntime

private def usage : String :=
  "i3_remote_witness challenge <policy> <store> <witness-id> <round> <issued-at> <lifetime> <challenge-id> <verifier-private-key> <challenge> <challenge-sig>\n" ++
  "i3_remote_witness respond <policy> <challenge> <challenge-sig> <now> <witness-root> <witness-private-key> <response> <response-sig>\n" ++
  "i3_remote_witness verify <policy> <store> <challenge> <challenge-sig> <response> <response-sig> <ledger-dir> <receipt> <now>"

private def hold (reason : String) : IO UInt32 := do
  IO.println s!"HOLD | {reason}"
  pure 2

def main (args : List String) : IO UInt32 := do
  match args with
  | ["challenge", policy, store, witnessId, roundText, issuedText, lifetimeText,
      challengeId, verifierPrivateKey, challengePath, challengeSig] =>
      match roundText.toNat?, issuedText.toNat?, lifetimeText.toNat? with
      | some round, some issuedAt, some lifetime =>
          if (← issueSignedChallenge policy store witnessId round issuedAt lifetime
              challengeId verifierPrivateKey challengePath challengeSig) then
            IO.println s!"SIGNED CHALLENGE | witness={witnessId} | round={round} | id={challengeId}"
            pure 0
          else hold "challenge policy, target, time, identity or signature failed"
      | _, _, _ => hold "round, issued-at or lifetime is invalid"
  | ["respond", policy, challenge, challengeSig, nowText, witnessRoot,
      witnessPrivateKey, response, responseSig] =>
      match nowText.toNat? with
      | some now =>
          if (← writeSignedRemoteResponse policy challenge challengeSig now witnessRoot
              witnessPrivateKey response responseSig) then
            IO.println s!"SIGNED REMOTE RESPONSE | now={now} | {response}"
            pure 0
          else hold "challenge signature, freshness, endpoint, witness or response signature failed"
      | none => hold "response time is invalid"
  | ["verify", policy, store, challenge, challengeSig, response, responseSig,
      ledger, receipt, nowText] =>
      match nowText.toNat? with
      | some now =>
          match (← verifyAndConsumeRemoteResponse policy store challenge challengeSig
              response responseSig ledger receipt now) with
          | .verified accepted =>
              IO.println s!"FRESH REMOTE RESPONSE VERIFIED | witness={accepted.witnessId} | challenge={accepted.challengeId} | endpoint={accepted.endpointId} | generation={accepted.anchor.generation}"
              pure 0
          | .hold reason => hold reason
      | none => hold "verification time is invalid"
  | _ =>
      IO.eprintln usage
      pure 64
