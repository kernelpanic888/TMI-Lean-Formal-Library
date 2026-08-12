import TMI.DigitalLifeCertifiedLearningLoop

open TMI.DigitalLifeCertifiedLearningLoop
open TMI.DigitalLifeBoundedLearning
open TMI.DigitalLifeNeuralProposer

private def hold (reason : String) : IO UInt32 := do
  IO.println s!"HOLD | {reason}"
  return 2

private def verifyCase
    (candidate := demoCandidate)
    (before := demoBefore)
    (observation := demoObservation)
    (now := 110) : IO UInt32 := do
  match certifyLearning demoLoopPolicy demoCognitivePolicy candidate
      demoHardwarePolicy demoHardwareEvidence before observation now with
  | none => hold "certified act, feedback, bounded delta, validation, or commit gate failed"
  | some trace =>
      IO.println s!"CERTIFIED LEARNING LOOP | loop={trace.loopId} | act={trace.actId} | loss={trace.baselineLoss}->{trace.validatedLoss} | generation={trace.before.generation}->{trace.after.generation} | rollback=available"
      return 0

def main (args : List String) : IO UInt32 := do
  match args with
  | ["admit"] => verifyCase
  | ["rollback"] =>
      let trace := traceOfLearning demoBefore demoCandidate demoObservation
      if rollbackLearning trace.rollback = demoBefore then
        IO.println "ROLLBACK EXACT | identity=1 | generation=0 | parameters=restored"
        return 0
      else
        hold "rollback mismatch"
  | ["worse"] =>
      verifyCase (observation := { demoObservation with validatedLoss := 12 })
  | ["unbounded"] =>
      verifyCase (observation := { demoObservation with declaredDelta := outOfFieldDelta })
  | ["tampered-act"] =>
      verifyCase (candidate := { demoCandidate with declaredInput := -1 })
  | ["stale-feedback"] =>
      verifyCase (observation := { demoObservation with feedbackAt := 70 })
  | ["wrong-head"] =>
      verifyCase (observation := { demoObservation with previousReceiptHead := demoDigest1 })
  | ["parameter-drift"] =>
      let changed := { demoParameters with wx := demoParameters.wx + 1 }
      verifyCase (before := { demoBefore with learning := { demoBefore.learning with parameters := changed } })
  | _ =>
      IO.eprintln "usage: i3_learning_loop <admit|rollback|worse|unbounded|tampered-act|stale-feedback|wrong-head|parameter-drift>"
      return 64
