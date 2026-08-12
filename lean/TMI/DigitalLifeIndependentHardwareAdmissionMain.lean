import TMI.DigitalLifeIndependentHardwareAdmissionRuntime

open TMI.DigitalLifeIndependentHardwareAdmissionRuntime

private def usage : String :=
  "usage: i3_remote_hardware verify <policy.txt> <evidence.txt> <now>"

def main (args : List String) : IO UInt32 := do
  match args with
  | ["verify", policyPath, evidencePath, nowText] =>
      let now ← match nowText.toNat? with
        | some value => pure value
        | none =>
            IO.eprintln "GLOBAL HARDWARE HOLD | invalid now value"
            return 2
      let policyText ← IO.FS.readFile policyPath
      let evidenceText ← IO.FS.readFile evidencePath
      match parsePolicy policyText, parseEvidence evidenceText with
      | .ok policy, .ok evidence =>
          match verify policy evidence now with
          | .admitted =>
              IO.println "GLOBAL HARDWARE ADMIT | independent remote hardware evidence exact"
              return 0
          | .hold reason =>
              IO.println s!"GLOBAL HARDWARE HOLD | {reason}"
              return 1
      | .error reason, _ =>
          IO.eprintln s!"GLOBAL HARDWARE HOLD | policy parse error: {reason}"
          return 2
      | _, .error reason =>
          IO.eprintln s!"GLOBAL HARDWARE HOLD | evidence parse error: {reason}"
          return 2
  | _ =>
      IO.eprintln usage
      return 2
