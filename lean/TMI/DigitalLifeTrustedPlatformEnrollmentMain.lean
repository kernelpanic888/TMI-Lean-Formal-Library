import TMI.DigitalLifeTrustedPlatformEnrollmentRuntime

open TMI.DigitalLifeTrustedPlatformEnrollmentRuntime

private def usage : String :=
  "i3_enrollment verify <policy> <observation> <now>"

def main (args : List String) : IO UInt32 := do
  match args with
  | ["verify", policy, observation, nowText] =>
      match nowText.toNat? with
      | none =>
          IO.println "HOLD | verification time is invalid"
          pure 2
      | some now =>
          match (← verifyEnrollment policy observation now) with
          | .ready =>
              IO.println "READY FOR HARDWARE PROBE | trusted platform enrollment exact"
              IO.println "LOCAL HARDWARE PASS=HOLD | physical challenge has not run"
              pure 0
          | .hold reason =>
              IO.println s!"HOLD | {reason}"
              pure 2
  | _ =>
      IO.eprintln usage
      pure 64
