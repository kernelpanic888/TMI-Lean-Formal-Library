/-!
# Activation relic, shadow boundary, and two-axis time

Public reader:
https://chertogi-razuma-research.kernelpanic888.chatgpt.site/readers/activation-relic-shadow-boundary/

This opt-in module formalizes a small TMI research interface:

* a domain distinguishes directly available conditions from its shadow;
* an inaccessible condition may leave an in-domain relic through an explicit
  channel;
* an observation can be required to factor through that relic;
* one event may carry a laboratory coordinate and a relational coordinate.

## Claim boundary

The declarations below are definitions and consequences of explicit fields.
They do not derive TMI from physics, identify a laboratory dark sector with an
extra-domain condition, prove that every inaccessible condition leaves a relic,
or assert two independent physical times.

The cold-atom experiment in Barontini, "Testing the Problem of Time with Cold
Atoms" (Physical Review Research 8, L022047, 2026), is used by the reader as a
controlled analogy only: https://doi.org/10.1103/1h9j-df4k
-/

namespace TMI
namespace ActivationRelicTwoAxisTime

universe uU uRelic uObservation uLab uInternal uEvent

/-- A domain is specified only by the predicate selecting what is directly
available inside it. -/
structure Domain (U : Type uU) where
  visible : U -> Prop

/-- The shadow of a domain consists of conditions not directly available in
that domain. -/
def Shadow {U : Type uU} (D : Domain U) (condition : U) : Prop :=
  Not (D.visible condition)

/-- Direct observation is deliberately no stronger than domain visibility. -/
def DirectlyObserved {U : Type uU} (D : Domain U) (condition : U) : Prop :=
  D.visible condition

theorem shadow_is_not_directly_observed
    {U : Type uU}
    {D : Domain U}
    {condition : U}
    (hShadow : Shadow D condition) :
    Not (DirectlyObserved D condition) :=
  hShadow

/-- A partial interface from conditions to relics.  The optional output keeps
the failure to leave a relic explicit. -/
structure RelicChannel
    (U : Type uU)
    (Relic : Type uRelic) where
  trace : U -> Option Relic

/-- `ActivationRelic channel condition relic` says only that this channel
records this relic for this condition. -/
def ActivationRelic
    {U : Type uU}
    {Relic : Type uRelic}
    (channel : RelicChannel U Relic)
    (condition : U)
    (relic : Relic) : Prop :=
  channel.trace condition = some relic

theorem activation_relic_is_a_channel_record
    {U : Type uU}
    {Relic : Type uRelic}
    {channel : RelicChannel U Relic}
    {condition : U}
    {relic : Relic}
    (hRelic : ActivationRelic channel condition relic) :
    channel.trace condition = some relic :=
  hRelic

/-- An observation scheme whose access to a condition is mediated by a relic.
This structure carries the factorization instead of postulating that every
observation in nature has it. -/
structure RelicObservation
    (Condition : Type uU)
    (Relic : Type uRelic)
    (Observation : Type uObservation) where
  relicOf : Condition -> Relic
  readRelic : Relic -> Observation

def RelicObservation.observe
    {Condition : Type uU}
    {Relic : Type uRelic}
    {Observation : Type uObservation}
    (scheme : RelicObservation Condition Relic Observation)
    (condition : Condition) : Observation :=
  scheme.readRelic (scheme.relicOf condition)

/-- The promised factorization lemma: a relic-mediated observation factors
through its in-domain relic map. -/
theorem observation_factors_through_relic
    {Condition : Type uU}
    {Relic : Type uRelic}
    {Observation : Type uObservation}
    (scheme : RelicObservation Condition Relic Observation) :
    exists read : Relic -> Observation,
      forall condition,
        scheme.observe condition = read (scheme.relicOf condition) := by
  exact ⟨scheme.readRelic, by intro condition; rfl⟩

/-- Two-axis time records which laboratory/internal coordinate pairs are
admissible.  It does not assert that both axes are independent physical times. -/
structure TwoAxisTime
    (TLab : Type uLab)
    (TInternal : Type uInternal) where
  admissible : TLab -> TInternal -> Prop

abbrev TimeCoordinate
    (TLab : Type uLab)
    (TInternal : Type uInternal) :=
  TLab × TInternal

/-- One event touches the two-axis record when it has a laboratory record and
a relic-derived internal order at an admissible coordinate pair. -/
def TimeTouch
    {TLab : Type uLab}
    {TInternal : Type uInternal}
    {Event : Type uEvent}
    (time : TwoAxisTime TLab TInternal)
    (labRecorded : Event -> TLab -> Prop)
    (relicOrdered : Event -> TInternal -> Prop)
    (event : Event) : Prop :=
  exists lab internal,
    time.admissible lab internal /\
      labRecorded event lab /\
      relicOrdered event internal

theorem timeTouch_has_two_coordinates
    {TLab : Type uLab}
    {TInternal : Type uInternal}
    {Event : Type uEvent}
    {time : TwoAxisTime TLab TInternal}
    {labRecorded : Event -> TLab -> Prop}
    {relicOrdered : Event -> TInternal -> Prop}
    {event : Event}
    (hTouch : TimeTouch time labRecorded relicOrdered event) :
    exists coordinate : TimeCoordinate TLab TInternal,
      time.admissible coordinate.1 coordinate.2 /\
        labRecorded event coordinate.1 /\
        relicOrdered event coordinate.2 := by
  rcases hTouch with ⟨lab, internal, hAdmissible, hLab, hInternal⟩
  exact ⟨(lab, internal), hAdmissible, hLab, hInternal⟩

end ActivationRelicTwoAxisTime
end TMI
