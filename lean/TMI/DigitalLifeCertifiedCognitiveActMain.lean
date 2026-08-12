import TMI.DigitalLifeCertifiedCognitiveActRuntime

open TMI.DigitalLifeCertifiedCognitiveActRuntime

private def printHold (reason : String) : IO UInt32 := do
  IO.println s!"HOLD | {reason}"
  return 2

def main (args : List String) : IO UInt32 := do
  match args with
  | ["verify", cognitivePolicyPath, candidatePath, hardwarePolicyPath, hardwareEvidencePath, nowText] =>
    let now ←
      match nowText.toNat? with
      | some value => pure value
      | none => return ← printHold "NOW must be a natural number"
    let cognitivePolicyText ← IO.FS.readFile cognitivePolicyPath
    let candidateText ← IO.FS.readFile candidatePath
    let hardwarePolicyText ← IO.FS.readFile hardwarePolicyPath
    let hardwareEvidenceText ← IO.FS.readFile hardwareEvidencePath
    match parsePolicy cognitivePolicyText,
        parseCandidate candidateText,
        TMI.DigitalLifeIndependentHardwareAdmissionRuntime.parsePolicy hardwarePolicyText,
        TMI.DigitalLifeIndependentHardwareAdmissionRuntime.parseEvidence hardwareEvidenceText with
    | .ok policy, .ok candidate, .ok hardwarePolicy, .ok hardwareEvidence =>
      match verify policy candidate hardwarePolicy hardwareEvidence now with
      | .hold reason => printHold reason
      | .certified trace =>
        IO.println s!"CERTIFIED COGNITIVE ACT | act={trace.actId} | score={trace.score} | input={trace.proposedInput} | tick={trace.after.n} | return=available"
        return 0
    | .error reason, _, _, _ => printHold reason
    | _, .error reason, _, _ => printHold reason
    | _, _, .error reason, _ => printHold s!"L16 policy: {reason}"
    | _, _, _, .error reason => printHold s!"L16 evidence: {reason}"
  | _ =>
    IO.eprintln "usage: i3_cognitive_act verify <policy> <candidate> <l16-policy> <l16-evidence> <now>"
    return 64
