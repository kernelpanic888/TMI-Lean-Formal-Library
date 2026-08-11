import TMI.ActivationRelicTwoAxisTime

/-!
# Digital-life two-axis tick

Public living model:
https://chertogi-razuma-research.kernelpanic888.chatgpt.site/readers/digital-life-living-model/

Two-axis-time research reader:
https://chertogi-razuma-research.kernelpanic888.chatgpt.site/readers/activation-relic-shadow-boundary/

This module is a formal adapter around an already computed virtual-domain
transition.  It does not introduce a second state dynamics.  A candidate tick
becomes admitted only when it has an admissible laboratory/relational stamp,
advances on both orders, belongs to the exposed action field, satisfies the
domain policy, preserves identity, passes the safety and post-verification
checks, and extends the certificate by one.

The executable boundary is `TickValidator.check`.  Its soundness field connects
the Boolean implementation to the proposition checked by Lean.  Rejection is
interpreted as `hold`: the next visible state remains the previous state.

## Claim boundary

Two-axis time is modeled here as a necessary condition for an admitted tick,
not as a sufficient condition and not as two independent physical times.  A
receipt proves only the explicit transition contract.  It does not establish
consciousness, biological life, autonomous purpose, cryptographic security, or
the empirical adequacy of a future neural proposal generator.
-/

namespace TMI
namespace DigitalLifeTwoAxisTick

open ActivationRelicTwoAxisTime

universe uState uAction uIdentity uLab uInternal

/-- One coordinate pair carried by a virtual-domain event. -/
structure TwoAxisStamp
    (TLab : Type uLab)
    (TInternal : Type uInternal) where
  laboratory : TLab
  relational : TInternal

/-- A candidate envelope around one transition already computed by the living
model.  The envelope does not compute the transition itself. -/
structure TickEnvelope
    (State : Type uState)
    (Action : Type uAction)
    (TLab : Type uLab)
    (TInternal : Type uInternal) where
  before : State
  field : List Action
  action : Action
  after : State
  previousTime : TwoAxisStamp TLab TInternal
  nextTime : TwoAxisStamp TLab TInternal

/-- The reusable contract against which a candidate living-model tick is
checked.  The future neural layer may propose an action, but it cannot replace
any of these guards. -/
structure TickContract
    (State : Type uState)
    (Action : Type uAction)
    (Identity : Type uIdentity)
    (TLab : Type uLab)
    (TInternal : Type uInternal) where
  time : TwoAxisTime TLab TInternal
  laboratoryForward : TLab -> TLab -> Prop
  relationalForward : TInternal -> TInternal -> Prop
  applyAction : State -> Action -> State
  identify : State -> Identity
  policy : State -> Action -> State -> Prop
  safe : State -> Prop
  postVerify : State -> Action -> State -> Prop
  certificate : State -> Nat

/-- The laboratory coordinate recorded by one envelope. -/
def envelopeLabRecorded
    {State : Type uState}
    {Action : Type uAction}
    {TLab : Type uLab}
    {TInternal : Type uInternal}
    (event : TickEnvelope State Action TLab TInternal)
    (laboratory : TLab) : Prop :=
  event.nextTime.laboratory = laboratory

/-- The relational coordinate carried by one envelope. -/
def envelopeRelicOrdered
    {State : Type uState}
    {Action : Type uAction}
    {TLab : Type uLab}
    {TInternal : Type uInternal}
    (event : TickEnvelope State Action TLab TInternal)
    (relational : TInternal) : Prop :=
  event.nextTime.relational = relational

/-- A candidate envelope touches two-axis time exactly through its recorded
laboratory and relational coordinates. -/
def EnvelopeTimeTouch
    {State : Type uState}
    {Action : Type uAction}
    {Identity : Type uIdentity}
    {TLab : Type uLab}
    {TInternal : Type uInternal}
    (contract : TickContract State Action Identity TLab TInternal)
    (event : TickEnvelope State Action TLab TInternal) : Prop :=
  TimeTouch contract.time envelopeLabRecorded envelopeRelicOrdered event

/-- Full admission contract for one already-computed virtual-domain tick. -/
structure AdmittedTick
    {State : Type uState}
    {Action : Type uAction}
    {Identity : Type uIdentity}
    {TLab : Type uLab}
    {TInternal : Type uInternal}
    (contract : TickContract State Action Identity TLab TInternal)
    (event : TickEnvelope State Action TLab TInternal) : Prop where
  timeAdmissible :
    contract.time.admissible
      event.nextTime.laboratory
      event.nextTime.relational
  laboratoryAdvances :
    contract.laboratoryForward
      event.previousTime.laboratory
      event.nextTime.laboratory
  relationalAdvances :
    contract.relationalForward
      event.previousTime.relational
      event.nextTime.relational
  selectedFromField : event.action ∈ event.field
  applied : event.after = contract.applyAction event.before event.action
  policyAdmits : contract.policy event.before event.action event.after
  identityPreserved :
    contract.identify event.after = contract.identify event.before
  safeAfter : contract.safe event.after
  postVerified : contract.postVerify event.before event.action event.after
  certificateExtended :
    contract.certificate event.after = contract.certificate event.before + 1

/-- A Boolean validator is executable.  `sound` is the proof boundary: every
accepted Boolean result must inhabit the full admission contract. -/
structure TickValidator
    {State : Type uState}
    {Action : Type uAction}
    {Identity : Type uIdentity}
    {TLab : Type uLab}
    {TInternal : Type uInternal}
    (contract : TickContract State Action Identity TLab TInternal) where
  check : TickEnvelope State Action TLab TInternal -> Bool
  sound : forall event, check event = true -> AdmittedTick contract event

/-- Proof-carrying result of one admitted living-model tick. -/
structure TickReceipt
    {State : Type uState}
    {Action : Type uAction}
    {Identity : Type uIdentity}
    {TLab : Type uLab}
    {TInternal : Type uInternal}
    (contract : TickContract State Action Identity TLab TInternal) where
  event : TickEnvelope State Action TLab TInternal
  certified : AdmittedTick contract event

/-- Execute the validator boundary.  Failure returns no transition receipt. -/
def admitTick
    {State : Type uState}
    {Action : Type uAction}
    {Identity : Type uIdentity}
    {TLab : Type uLab}
    {TInternal : Type uInternal}
    {contract : TickContract State Action Identity TLab TInternal}
    (validator : TickValidator contract)
    (event : TickEnvelope State Action TLab TInternal) :
    Option (TickReceipt contract) :=
  if hCheck : validator.check event = true then
    some { event := event, certified := validator.sound event hCheck }
  else
    none

/-- The operational red boundary: a rejected candidate is a hold, not an
unverified transition. -/
def nextOrHold
    {State : Type uState}
    {Action : Type uAction}
    {Identity : Type uIdentity}
    {TLab : Type uLab}
    {TInternal : Type uInternal}
    {contract : TickContract State Action Identity TLab TInternal}
    (validator : TickValidator contract)
    (event : TickEnvelope State Action TLab TInternal) : State :=
  match admitTick validator event with
  | some receipt => receipt.event.after
  | none => event.before

/-- Two-axis time is necessary for every admitted tick. -/
theorem admitted_has_timeTouch
    {State : Type uState}
    {Action : Type uAction}
    {Identity : Type uIdentity}
    {TLab : Type uLab}
    {TInternal : Type uInternal}
    {contract : TickContract State Action Identity TLab TInternal}
    {event : TickEnvelope State Action TLab TInternal}
    (hAdmitted : AdmittedTick contract event) :
    EnvelopeTimeTouch contract event := by
  exact
    ⟨event.nextTime.laboratory,
      event.nextTime.relational,
      hAdmitted.timeAdmissible,
      rfl,
      rfl⟩

/-- Admission preserves the declared identity projection. -/
theorem admitted_preserves_identity
    {State : Type uState}
    {Action : Type uAction}
    {Identity : Type uIdentity}
    {TLab : Type uLab}
    {TInternal : Type uInternal}
    {contract : TickContract State Action Identity TLab TInternal}
    {event : TickEnvelope State Action TLab TInternal}
    (hAdmitted : AdmittedTick contract event) :
    contract.identify event.after = contract.identify event.before :=
  hAdmitted.identityPreserved

/-- Admission extends the certificate by exactly one logical tick. -/
theorem admitted_extends_certificate
    {State : Type uState}
    {Action : Type uAction}
    {Identity : Type uIdentity}
    {TLab : Type uLab}
    {TInternal : Type uInternal}
    {contract : TickContract State Action Identity TLab TInternal}
    {event : TickEnvelope State Action TLab TInternal}
    (hAdmitted : AdmittedTick contract event) :
    contract.certificate event.after =
      contract.certificate event.before + 1 :=
  hAdmitted.certificateExtended

/-- Every receipt inherits the two-axis-time witness. -/
theorem receipt_has_timeTouch
    {State : Type uState}
    {Action : Type uAction}
    {Identity : Type uIdentity}
    {TLab : Type uLab}
    {TInternal : Type uInternal}
    {contract : TickContract State Action Identity TLab TInternal}
    (receipt : TickReceipt contract) :
    EnvelopeTimeTouch contract receipt.event :=
  admitted_has_timeTouch receipt.certified

/-- If no two-axis witness exists, a sound validator cannot issue a receipt. -/
theorem no_timeTouch_rejects
    {State : Type uState}
    {Action : Type uAction}
    {Identity : Type uIdentity}
    {TLab : Type uLab}
    {TInternal : Type uInternal}
    {contract : TickContract State Action Identity TLab TInternal}
    (validator : TickValidator contract)
    (event : TickEnvelope State Action TLab TInternal)
    (hNoTouch : Not (EnvelopeTimeTouch contract event)) :
    admitTick validator event = none := by
  by_cases hCheck : validator.check event = true
  · have hTouch := admitted_has_timeTouch (validator.sound event hCheck)
    exact False.elim (hNoTouch hTouch)
  · unfold admitTick
    rw [dif_neg hCheck]

/-- An explicit Boolean rejection leaves the visible state unchanged. -/
theorem rejected_preserves_state
    {State : Type uState}
    {Action : Type uAction}
    {Identity : Type uIdentity}
    {TLab : Type uLab}
    {TInternal : Type uInternal}
    {contract : TickContract State Action Identity TLab TInternal}
    (validator : TickValidator contract)
    (event : TickEnvelope State Action TLab TInternal)
    (hRejected : validator.check event = false) :
    nextOrHold validator event = event.before := by
  have hNotTrue : validator.check event ≠ true := by
    intro hTrue
    rw [hRejected] at hTrue
    cases hTrue
  have hNoReceipt : admitTick validator event = none := by
    unfold admitTick
    rw [dif_neg hNotTrue]
  unfold nextOrHold
  rw [hNoReceipt]

end DigitalLifeTwoAxisTick
end TMI
