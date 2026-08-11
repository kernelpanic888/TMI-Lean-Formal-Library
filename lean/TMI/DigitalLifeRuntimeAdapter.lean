import TMI.DigitalLifeTwoAxisTick

/-!
# DL-04 concrete runtime adapter

This module connects the generic two-axis tick contract to a small, executable
virtual-domain state. The recurrence is a reproducible runtime specimen.

Red boundary: the receipt certifies an internal transition only. It is not a
cryptographic signature and does not establish consciousness, life, or a
physical second time dimension.
-/

namespace TMI.DigitalLifeRuntimeAdapter

open TMI.ActivationRelicTwoAxisTime
open TMI.DigitalLifeTwoAxisTick

structure DL04State where
  identity : Nat
  n : Nat
  x : Int
  y : Int
  z : Int
  memory : Int
  reflection : Int
  input : Int
  certificate : Nat
  deriving DecidableEq, Repr

inductive DL04Action where
  | advance (input : Int)
  deriving DecidableEq, Repr

def safe (state : DL04State) : Prop :=
  state.certificate = state.n

def applyAction (state : DL04State) : DL04Action → DL04State
  | .advance input =>
      { identity := state.identity
        n := state.n + 1
        x := state.y
        y := state.z
        z := state.x + state.y - state.z + input
        memory := state.memory + state.x
        reflection := state.reflection + (state.y - state.x)
        input := input
        certificate := state.certificate + 1 }

def policy (before : DL04State) (_action : DL04Action) (after : DL04State) : Prop :=
  safe before ∧ safe after

def postVerify (before : DL04State) (action : DL04Action) (after : DL04State) : Prop :=
  after = applyAction before action ∧ safe after

def twoAxisTime : TwoAxisTime Nat Nat where
  admissible laboratory relational := laboratory = relational

def contract : TickContract DL04State DL04Action Nat Nat Nat where
  time := twoAxisTime
  laboratoryForward previous next := next = previous + 1
  relationalForward previous next := next = previous + 1
  applyAction := applyAction
  identify := DL04State.identity
  policy := policy
  safe := safe
  postVerify := postVerify
  certificate := DL04State.certificate

def actionField (input : Int) : List DL04Action :=
  [.advance input]

def envelope (state : DL04State) (input : Int) : TickEnvelope DL04State DL04Action Nat Nat :=
  let action := DL04Action.advance input
  { before := state
    field := actionField input
    action := action
    after := applyAction state action
    previousTime := ⟨state.n, state.n⟩
    nextTime := ⟨state.n + 1, state.n + 1⟩ }

def RuntimeAdmissible (event : TickEnvelope DL04State DL04Action Nat Nat) : Prop :=
  event.nextTime.laboratory = event.nextTime.relational ∧
  event.nextTime.laboratory = event.previousTime.laboratory + 1 ∧
  event.nextTime.relational = event.previousTime.relational + 1 ∧
  event.action ∈ event.field ∧
  event.after = applyAction event.before event.action ∧
  policy event.before event.action event.after ∧
  event.after.identity = event.before.identity ∧
  safe event.after ∧
  postVerify event.before event.action event.after ∧
  event.after.certificate = event.before.certificate + 1

instance runtimeAdmissibleDecidable
    (event : TickEnvelope DL04State DL04Action Nat Nat) :
    Decidable (RuntimeAdmissible event) := by
  unfold RuntimeAdmissible policy postVerify safe
  infer_instance

def check (event : TickEnvelope DL04State DL04Action Nat Nat) : Bool :=
  decide (RuntimeAdmissible event)

theorem check_sound
    (event : TickEnvelope DL04State DL04Action Nat Nat)
    (hCheck : check event = true) :
    AdmittedTick contract event := by
  have h : RuntimeAdmissible event := of_decide_eq_true hCheck
  rcases h with ⟨hTime, hLab, hRel, hField, hApplied, hPolicy,
    hIdentity, hSafe, hPost, hCertificate⟩
  exact
    { timeAdmissible := hTime
      laboratoryAdvances := hLab
      relationalAdvances := hRel
      selectedFromField := hField
      applied := hApplied
      policyAdmits := hPolicy
      identityPreserved := hIdentity
      safeAfter := hSafe
      postVerified := hPost
      certificateExtended := hCertificate }

def validator : TickValidator contract where
  check := check
  sound := check_sound

theorem safe_after_apply
    (state : DL04State)
    (action : DL04Action)
    (hSafe : safe state) :
    safe (applyAction state action) := by
  cases action with
  | advance input =>
      change state.certificate + 1 = state.n + 1
      exact congrArg (fun value => value + 1) hSafe

theorem generated_event_admitted
    (state : DL04State)
    (input : Int)
    (hSafe : safe state) :
    AdmittedTick contract (envelope state input) := by
  have hSafeAfter : safe (applyAction state (.advance input)) :=
    safe_after_apply state (.advance input) hSafe
  exact
    { timeAdmissible := rfl
      laboratoryAdvances := rfl
      relationalAdvances := rfl
      selectedFromField := by simp [envelope, actionField]
      applied := rfl
      policyAdmits := ⟨hSafe, hSafeAfter⟩
      identityPreserved := rfl
      safeAfter := hSafeAfter
      postVerified := ⟨rfl, hSafeAfter⟩
      certificateExtended := rfl }

def execute (state : DL04State) (input : Int) : DL04State :=
  nextOrHold validator (envelope state input)

def seed : DL04State :=
  { identity := 1, n := 0, x := 1, y := 0, z := 0, memory := 0,
    reflection := 0, input := 0, certificate := 0 }

def specimenInputs : List Int := [2, -1, 3, 0]

def run : List Int → DL04State → DL04State
  | [], state => state
  | input :: rest, state => run rest (execute state input)

def specimen : DL04State := run specimenInputs seed

def badTimeEnvelope : TickEnvelope DL04State DL04Action Nat Nat :=
  { envelope seed 2 with nextTime := ⟨1, 0⟩ }

theorem seed_is_safe : safe seed := rfl

theorem generated_first_tick_is_admitted :
    AdmittedTick contract (envelope seed 2) :=
  generated_event_admitted seed 2 seed_is_safe

theorem bad_time_is_rejected : check badTimeEnvelope = false := by native_decide

theorem bad_time_holds_state :
    nextOrHold validator badTimeEnvelope = seed := by native_decide

theorem specimen_is_reproducible :
    specimen.n = 4 ∧ specimen.certificate = 4 ∧ specimen.identity = seed.identity := by
  native_decide

end TMI.DigitalLifeRuntimeAdapter
