/-
IESTA applied branch boundary.

IESTA is treated here as an applied runtime architecture under TMI-MARKET /
TMI-OPS. This module formalizes the branch boundary and safety guards; it does
not promote market/runtime claims into Core and it does not assert financial
advice, profit, or price prediction.
-/

import TMI.ImportBoundary

namespace TMI
namespace IESTA

inductive BranchLayer where
  | appliedMode
deriving DecidableEq, Repr

inductive ParentMode where
  | TMI_OPS
  | TMI_MARKET
deriving DecidableEq, Repr

inductive RuntimeMode where
  | dryRun
  | paperReviewOnly
  | live
deriving DecidableEq, Repr

inductive RuntimeState where
  | running
  | watchOnly
  | riskYellow
  | riskRed
  | recoveryFrozen
  | microProbeDry
  | paperReviewOnly
  | halted
deriving DecidableEq, Repr

inductive Gate where
  | data
  | signal
  | admissibility
  | risk
  | liquidity
  | execution
  | record
  | survival
deriving DecidableEq, Repr

inductive SellAuthority where
  | autoTrader
  | exitGate
  | ui
  | externalScript
deriving DecidableEq, Repr

opaque Event : Type

opaque GateOK : Gate -> Event -> Prop

def IESTABranchLayer : BranchLayer :=
  BranchLayer.appliedMode

def IESTAParents : ParentMode -> Prop
  | ParentMode.TMI_OPS => True
  | ParentMode.TMI_MARKET => True

def CoreMutationAllowed : Prop :=
  False

def FinancialAdviceClaim : Prop :=
  False

def ProfitGuaranteeClaim : Prop :=
  False

def BuySellRecommendationClaim : Prop :=
  False

def PricePredictionClaim : Prop :=
  False

def DefaultRuntimeMode : RuntimeMode :=
  RuntimeMode.dryRun

def LiveMoneyEnabledByDefault : Prop :=
  DefaultRuntimeMode = RuntimeMode.live

def LiveModeRequiresOperatorReview : RuntimeMode -> Prop
  | RuntimeMode.live => True
  | _ => True

def IESTAEventPass (event : Event) : Prop :=
  GateOK Gate.data event ∧
  GateOK Gate.signal event ∧
  GateOK Gate.admissibility event ∧
  GateOK Gate.risk event ∧
  GateOK Gate.liquidity event ∧
  GateOK Gate.execution event ∧
  GateOK Gate.record event ∧
  GateOK Gate.survival event

def ExecutionCandidateAllowed (event : Event) : Prop :=
  IESTAEventPass event

def BuyAllowed (event : Event) : Prop :=
  IESTAEventPass event

def SellAllowedBy (authority : SellAuthority) : Prop :=
  authority = SellAuthority.autoTrader

def CuriosityMayBypassLossGuard : RuntimeMode -> Prop
  | RuntimeMode.live => False
  | RuntimeMode.dryRun => True
  | RuntimeMode.paperReviewOnly => True

def StateUnknownFallsBackToWatchOrHalt (state : RuntimeState) : Prop :=
  state = RuntimeState.watchOnly ∨ state = RuntimeState.halted

theorem T_iesta_branch_is_applied_mode :
    IESTABranchLayer = BranchLayer.appliedMode := by
  rfl

theorem T_iesta_has_ops_parent :
    IESTAParents ParentMode.TMI_OPS := by
  trivial

theorem T_iesta_has_market_parent :
    IESTAParents ParentMode.TMI_MARKET := by
  trivial

theorem T_iesta_core_mutation_not_allowed :
    ¬ CoreMutationAllowed := by
  intro h
  exact h

theorem T_iesta_not_financial_advice :
    ¬ FinancialAdviceClaim := by
  intro h
  exact h

theorem T_iesta_no_profit_guarantee :
    ¬ ProfitGuaranteeClaim := by
  intro h
  exact h

theorem T_iesta_no_buy_sell_recommendation_claim :
    ¬ BuySellRecommendationClaim := by
  intro h
  exact h

theorem T_iesta_no_price_prediction_claim :
    ¬ PricePredictionClaim := by
  intro h
  exact h

theorem T_iesta_default_mode_is_dry_run :
    DefaultRuntimeMode = RuntimeMode.dryRun := by
  rfl

theorem T_iesta_live_money_not_enabled_by_default :
    ¬ LiveMoneyEnabledByDefault := by
  intro h
  cases h

theorem T_iesta_event_pass_requires_data
    {event : Event} :
    IESTAEventPass event -> GateOK Gate.data event := by
  intro h
  exact h.1

theorem T_iesta_event_pass_requires_risk
    {event : Event} :
    IESTAEventPass event -> GateOK Gate.risk event := by
  intro h
  exact h.2.2.2.1

theorem T_iesta_event_pass_requires_record
    {event : Event} :
    IESTAEventPass event -> GateOK Gate.record event := by
  intro h
  exact h.2.2.2.2.2.2.1

theorem T_iesta_event_pass_requires_survival
    {event : Event} :
    IESTAEventPass event -> GateOK Gate.survival event := by
  intro h
  exact h.2.2.2.2.2.2.2

theorem T_iesta_buy_requires_record
    {event : Event} :
    BuyAllowed event -> GateOK Gate.record event := by
  intro h
  exact T_iesta_event_pass_requires_record h

theorem T_iesta_buy_requires_survival
    {event : Event} :
    BuyAllowed event -> GateOK Gate.survival event := by
  intro h
  exact T_iesta_event_pass_requires_survival h

theorem T_iesta_only_autotrader_sell_authority
    {authority : SellAuthority} :
    SellAllowedBy authority -> authority = SellAuthority.autoTrader := by
  intro h
  exact h

theorem T_iesta_curiosity_cannot_bypass_lossguard_live :
    ¬ CuriosityMayBypassLossGuard RuntimeMode.live := by
  intro h
  exact h

end IESTA
end TMI
