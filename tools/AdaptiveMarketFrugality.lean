import CertifiedSystemSteward

/-!
# Adaptive Market Frugality

A minimal formal business layer over the existing proof-carrying selector.

The model separates five notions:

* resource dynamics `K(t)`;
* a risk-, horizon-, and adaptability-dependent target buffer `K*(t)`;
* a shock-scaled near-buffer band;
* a selector over five explicit actions;
* the distinction between pathological accumulation and adaptive frugality.

This is a policy model, not an empirical market law or financial advice.
Calibration, probabilities, prices, and real-world causal claims remain outside
this formal core.
-/

namespace AdaptiveMarketFrugality

open CertifiedSystemSteward

abbrev Time := Nat

/--
A discrete business state.

`resource`, `inflow`, `expense`, and `shock` are non-negative accounting
quantities. Natural-number subtraction therefore implements a fail-closed floor
at zero.
-/
structure State where
  resource : Nat
  inflow : Nat
  expense : Nat
  shock : Nat
  adaptability : Nat
  risk : Nat
  horizon : Nat
deriving DecidableEq, Repr

/-- The five actions exposed by the adaptive-frugality policy. -/
inductive Action where
  | accumulate
  | hold
  | investAdaptation
  | reduceRisk
  | spendQuality
deriving DecidableEq, Repr

/-- Resource coordinate K(t) of a state trajectory. -/
def K (trajectory : Time → State) (time : Time) : Nat :=
  (trajectory time).resource

/--
Target buffer K*(t).

Risk and adverse-regime horizon increase the numerator. Adaptability increases
the denominator. The successor offsets keep the expression defined at zero.
This exact formula is an author-model choice and requires empirical calibration
before operational use.
-/
def targetBuffer (state : State) : Nat :=
  ((state.risk + 1) * (state.horizon + 1)) / (state.adaptability + 1)

/-- Target-buffer coordinate K*(t) of a state trajectory. -/
def Kstar (trajectory : Time → State) (time : Time) : Nat :=
  targetBuffer (trajectory time)

/-- The current shock sets the width of the near-buffer uncertainty band. -/
def bufferTolerance (state : State) : Nat :=
  state.shock + 1

/-- K is materially below K*. -/
def BelowBuffer (state : State) : Prop :=
  state.resource + bufferTolerance state < targetBuffer state

/-- K is materially above K*. -/
def AboveBuffer (state : State) : Prop :=
  targetBuffer state + bufferTolerance state < state.resource

/-- K lies inside the band between the two strict zones. -/
def NearBuffer (state : State) : Prop :=
  ¬ BelowBuffer state ∧ ¬ AboveBuffer state

instance belowBufferDecidable (state : State) : Decidable (BelowBuffer state) := by
  unfold BelowBuffer
  infer_instance

instance aboveBufferDecidable (state : State) : Decidable (AboveBuffer state) := by
  unfold AboveBuffer
  infer_instance

/--
One unit of adaptive investment is charged only by the adaptation action.

The unit is deliberately abstract. A later calibrated layer may replace it
with a state-dependent amount without changing the selector interface.
-/
def adaptationInvestment (_state : State) : Action → Nat
  | .investAdaptation => 1
  | _ => 0

/--
Risk reduction and quality spending are charged through effective expense C.
-/
def actionExpense (_state : State) : Action → Nat
  | .reduceRisk => 1
  | .spendQuality => 1
  | _ => 0

/-- Effective C(t) after the selected action is accounted for. -/
def effectiveExpense (state : State) (action : Action) : Nat :=
  state.expense + actionExpense state action

/--
Resource dynamics:

K(t+1) = K(t) + R(t) - C_eff(t) - I_A(t) - epsilon(t).
-/
def nextResource (state : State) (action : Action) : Nat :=
  state.resource + state.inflow -
    (effectiveExpense state action +
      adaptationInvestment state action +
      state.shock)

/--
Concrete transition used by the existing `Adapter`.

Adaptation and risk actions also update their corresponding state coordinates.
The quality action spends a unit through `effectiveExpense`; quality itself is
intentionally not promoted to a new primitive state variable in this minimal
core.
-/
def applyAction (state : State) : Action → State
  | .accumulate =>
      { state with resource := nextResource state .accumulate }
  | .hold =>
      { state with resource := nextResource state .hold }
  | .investAdaptation =>
      { state with
          resource := nextResource state .investAdaptation
          adaptability := state.adaptability + 1 }
  | .reduceRisk =>
      { state with
          resource := nextResource state .reduceRisk
          risk := state.risk - 1 }
  | .spendQuality =>
      { state with resource := nextResource state .spendQuality }

/--
Above the target band, surplus is routed by a deterministic priority:

1. adaptation while adaptability is shorter than the adverse horizon;
2. risk reduction while positive risk remains;
3. life and quality once those two pressures are discharged.
-/
def preferredAction (state : State) : Action :=
  if BelowBuffer state then
    .accumulate
  else if AboveBuffer state then
    if state.adaptability < state.horizon then
      .investAdaptation
    else if 0 < state.risk then
      .reduceRisk
    else
      .spendQuality
  else
    .hold

/-- The complete field made available to the business selector. -/
def fullActionField : ActionField Action :=
  [.accumulate, .hold, .investAdaptation, .reduceRisk, .spendQuality]

/--
Existing selector interface reused without modification.

If the preferred action is not exposed by the current field, the system returns
`none` rather than inventing a fallback action.
-/
def selector : Selector State Action :=
  fun state field =>
    if preferredAction state ∈ field then
      some (preferredAction state)
    else
      none

/--
One-step pathology: accumulation is selected although the resource is already
materially above its target buffer.
-/
def GreedAt (state : State) (action : Action) : Prop :=
  AboveBuffer state ∧ action = .accumulate

/--
Policy-level greed: the decision function accumulates in every above-buffer
state. This is the finite policy proxy for unbounded accumulation.
-/
def Greed (decision : State → Action) : Prop :=
  ∀ state, AboveBuffer state → decision state = .accumulate

/-- Zonal contract for one adaptive-frugality decision. -/
def AdaptiveFrugalityAt (state : State) (action : Action) : Prop :=
  (BelowBuffer state → action = .accumulate) ∧
  (NearBuffer state → action = .hold) ∧
  (AboveBuffer state →
    action = .investAdaptation ∨
    action = .reduceRisk ∨
    action = .spendQuality)

/-- A decision function is adaptively frugal when it satisfies every zone. -/
def AdaptiveFrugality (decision : State → Action) : Prop :=
  ∀ state, AdaptiveFrugalityAt state (decision state)

/-! ## Selector behavior -/

theorem preferred_mem_fullActionField (state : State) :
    preferredAction state ∈ fullActionField := by
  cases hAction : preferredAction state <;>
    simp [fullActionField, hAction]

theorem selector_sound : selector.Sound := by
  intro observation field action hSelected
  by_cases hIn : preferredAction observation ∈ field
  · have hEq : preferredAction observation = action := by
      simpa [selector, hIn] using hSelected
    simpa [← hEq] using hIn
  · have hFalse : False := by
      simpa [selector, hIn] using hSelected
    exact False.elim hFalse

theorem selector_on_full_field (state : State) :
    selector state fullActionField = some (preferredAction state) := by
  simp [selector, preferred_mem_fullActionField]

theorem below_prefers_accumulate
    {state : State}
    (hBelow : BelowBuffer state) :
    preferredAction state = .accumulate := by
  simp [preferredAction, hBelow]

theorem near_prefers_hold
    {state : State}
    (hNear : NearBuffer state) :
    preferredAction state = .hold := by
  simp [preferredAction, hNear.1, hNear.2]

theorem above_not_below
    {state : State}
    (hAbove : AboveBuffer state) :
    ¬ BelowBuffer state := by
  intro hBelow
  unfold AboveBuffer at hAbove
  unfold BelowBuffer at hBelow
  omega

theorem above_prefers_resilience
    {state : State}
    (hAbove : AboveBuffer state) :
    preferredAction state = .investAdaptation ∨
      preferredAction state = .reduceRisk ∨
      preferredAction state = .spendQuality := by
  by_cases hAdapt : state.adaptability < state.horizon
  · left
    simp [preferredAction, above_not_below hAbove, hAbove, hAdapt]
  · by_cases hRisk : 0 < state.risk
    · right
      left
      simp [preferredAction, above_not_below hAbove, hAbove, hAdapt, hRisk]
    · right
      right
      simp [preferredAction, above_not_below hAbove, hAbove, hAdapt, hRisk]

theorem above_never_prefers_accumulation
    {state : State}
    (hAbove : AboveBuffer state) :
    preferredAction state ≠ .accumulate := by
  intro hAccumulation
  rcases above_prefers_resilience hAbove with hAdapt | hRisk | hQuality
  · simp [hAccumulation] at hAdapt
  · simp [hAccumulation] at hRisk
  · simp [hAccumulation] at hQuality

/-- Theorem surface: below the band, the selector accumulates. -/
theorem selector_below_buffer
    {state : State}
    (hBelow : BelowBuffer state) :
    selector state fullActionField = some .accumulate := by
  simpa [below_prefers_accumulate hBelow] using selector_on_full_field state

/-- Theorem surface: inside the band, the selector holds. -/
theorem selector_near_buffer
    {state : State}
    (hNear : NearBuffer state) :
    selector state fullActionField = some .hold := by
  simpa [near_prefers_hold hNear] using selector_on_full_field state

/--
Theorem surface: above the band, the selector routes surplus to resilience or
quality, never to further accumulation.
-/
theorem selector_above_buffer
    {state : State}
    (hAbove : AboveBuffer state) :
    ∃ action,
      selector state fullActionField = some action ∧
      (action = .investAdaptation ∨
        action = .reduceRisk ∨
        action = .spendQuality) := by
  refine ⟨preferredAction state, selector_on_full_field state, ?_⟩
  exact above_prefers_resilience hAbove

theorem selector_above_buffer_not_accumulate
    {state : State}
    (hAbove : AboveBuffer state) :
    selector state fullActionField ≠ some .accumulate := by
  intro hSelected
  have hSome :
      some (preferredAction state) = some .accumulate :=
    (selector_on_full_field state).symm.trans hSelected
  exact above_never_prefers_accumulation hAbove (Option.some.inj hSome)

theorem preferredAction_is_adaptively_frugal :
    AdaptiveFrugality preferredAction := by
  intro state
  refine ⟨?_, ?_, ?_⟩
  · exact fun hBelow => below_prefers_accumulate hBelow
  · exact fun hNear => near_prefers_hold hNear
  · exact fun hAbove => above_prefers_resilience hAbove

theorem preferredAction_is_not_greedy_at
    (state : State) :
    ¬ GreedAt state (preferredAction state) := by
  intro hGreed
  exact above_never_prefers_accumulation hGreed.1 hGreed.2

/-! ## Transition and passport integration -/

theorem resource_dynamics
    (state : State)
    (action : Action) :
    (applyAction state action).resource = nextResource state action := by
  cases action <;> rfl

theorem transition_preserves_horizon
    (state : State)
    (action : Action) :
    (applyAction state action).horizon = state.horizon := by
  cases action <;> rfl

def marketAdapter : Adapter State Action State Nat where
  observe := id
  applyAction := applyAction
  protectedView := State.horizon

def marketPolicy : Policy State Action where
  admit before action after :=
    after = applyAction before action ∧ AdaptiveFrugalityAt before action

def marketPassport : Passport State Action State Nat where
  adapter := marketAdapter
  policy := marketPolicy
  selector := selector
  selectorSound := selector_sound

theorem preferred_candidate_is_policy_admitted
    (state : State) :
    marketPolicy.admit
      state
      (preferredAction state)
      (applyAction state (preferredAction state)) := by
  exact ⟨rfl, preferredAction_is_adaptively_frugal state⟩

/--
The chosen full-field transition is a genuine existing
`CertifiedSystemSteward.AdmittedTransition`.
-/
theorem selected_transition_is_admitted
    (state : State) :
    AdmittedTransition
      marketPassport
      state
      fullActionField
      (preferredAction state)
      (applyAction state (preferredAction state)) := by
  refine ⟨preferred_mem_fullActionField state, rfl, ?_, ?_⟩
  · simpa [marketPassport] using preferred_candidate_is_policy_admitted state
  · simpa [marketPassport, marketAdapter] using
      transition_preserves_horizon state (preferredAction state)

end AdaptiveMarketFrugality
