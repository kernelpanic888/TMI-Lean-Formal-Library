import TMI.DigitalLifeCertifiedCognitiveAct
import TMI.DigitalLifeIndependentHardwareAdmissionRuntime

namespace TMI.DigitalLifeCertifiedCognitiveActRuntime

open TMI.DigitalLifeCertifiedCognitiveAct
open TMI.DigitalLifeIndependentHardwareAdmission
open TMI.DigitalLifeNeuralProposer
open TMI.DigitalLifeRuntimeAdapter

inductive VerificationOutcome where
  | certified (trace : CognitiveTrace)
  | hold (reason : String)
  deriving Repr

private def field? (fields : List String) (index : Nat) : Except String String :=
  match fields[index]? with
  | some value => .ok value
  | none => .error s!"missing field {index + 1}"

private def parseNatField (name value : String) : Except String Nat :=
  match value.toNat? with
  | some parsed => .ok parsed
  | none => .error s!"invalid natural number in {name}"

private def parseIntField (name value : String) : Except String Int :=
  match value.toInt? with
  | some parsed => .ok parsed
  | none => .error s!"invalid integer in {name}"

def parsePolicy (text : String) : Except String CognitivePolicy := do
  let fields := text.trimAscii.toString.splitOn "|"
  if fields.length != 6 then
    throw s!"cognitive policy must contain 6 fields, found {fields.length}"
  return {
    protocol := ← field? fields 0
    version := ← parseNatField "version" (← field? fields 1)
    policyId := ← field? fields 2
    expectedModelDigest := ← field? fields 3
    expectedSelectorDigest := ← field? fields 4
    maxCandidateAge := ← parseNatField "maxCandidateAge" (← field? fields 5)
  }

def parseCandidate (text : String) : Except String CognitiveCandidate := do
  let fields := text.trimAscii.toString.splitOn "|"
  if fields.length != 23 then
    throw s!"cognitive candidate must contain 23 fields, found {fields.length}"
  return {
    protocol := ← field? fields 0
    version := ← parseNatField "version" (← field? fields 1)
    policyId := ← field? fields 2
    actId := ← field? fields 3
    modelDigest := ← field? fields 4
    selectorDigest := ← field? fields 5
    observedAt := ← parseNatField "observedAt" (← field? fields 6)
    before := {
      identity := ← parseNatField "identity" (← field? fields 7)
      n := ← parseNatField "n" (← field? fields 8)
      x := ← parseIntField "x" (← field? fields 9)
      y := ← parseIntField "y" (← field? fields 10)
      z := ← parseIntField "z" (← field? fields 11)
      memory := ← parseIntField "memory" (← field? fields 12)
      reflection := ← parseIntField "reflection" (← field? fields 13)
      input := ← parseIntField "input" (← field? fields 14)
      certificate := ← parseNatField "certificate" (← field? fields 15)
    }
    parameters := {
      wx := ← parseIntField "wx" (← field? fields 16)
      wy := ← parseIntField "wy" (← field? fields 17)
      wz := ← parseIntField "wz" (← field? fields 18)
      wm := ← parseIntField "wm" (← field? fields 19)
      wr := ← parseIntField "wr" (← field? fields 20)
      bias := ← parseIntField "bias" (← field? fields 21)
    }
    declaredInput := ← parseIntField "declaredInput" (← field? fields 22)
  }

def verify
    (p : CognitivePolicy)
    (c : CognitiveCandidate)
    (hardwarePolicy : AdmissionPolicy)
    (hardwareEvidence : AdmissionEvidence)
    (now : Nat) : VerificationOutcome :=
  match TMI.DigitalLifeIndependentHardwareAdmissionRuntime.verify
      hardwarePolicy hardwareEvidence now with
  | .hold reason => .hold s!"L16 hold: {reason}"
  | .admitted =>
    if p.protocol != "I3CAP1" ∨ p.version != 1 then .hold "unsupported cognitive policy"
    else if p.policyId.isEmpty then .hold "empty cognitive policy identity"
    else if p.expectedModelDigest.length != 64 then .hold "invalid model digest"
    else if p.expectedSelectorDigest.length != 64 then .hold "invalid selector digest"
    else if p.maxCandidateAge = 0 then .hold "zero candidate lifetime"
    else if c.protocol != "I3CAE1" ∨ c.version != 1 then .hold "unsupported candidate protocol"
    else if c.policyId != p.policyId then .hold "cognitive policy identity mismatch"
    else if c.modelDigest != p.expectedModelDigest then .hold "model digest mismatch"
    else if c.selectorDigest != p.expectedSelectorDigest then .hold "selector digest mismatch"
    else if now < c.observedAt then .hold "candidate timestamp is in the future"
    else if p.maxCandidateAge < now - c.observedAt then .hold "candidate expired"
    else if c.before.certificate != c.before.n then .hold "unsafe state prefix"
    else if c.declaredInput != proposeInput c.parameters c.before then .hold "proposal trace mismatch"
    else if canonicalSelector c != true then .hold "selector rejected proposal"
    else if TMI.DigitalLifeRuntimeAdapter.check (candidateEvent c) != true then
      .hold "two-axis tick rejected"
    else
      match certify p c hardwarePolicy hardwareEvidence now with
      | some trace => .certified trace
      | none => .hold "formal cognitive admission predicate rejected the act"

end TMI.DigitalLifeCertifiedCognitiveActRuntime
