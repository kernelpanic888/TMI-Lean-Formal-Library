/-
Interface Mathematics: AI as automatic claim-fitting interface.

AI is introduced here as an interface that automatically adjusts drifting or
noisy claims produced around a thinker interface. The class is guarded: a noisy
claim alone is not enough; there must be automatic fitting, noise reduction,
stabilization, and a recorded adjustment.
-/

namespace TMI
namespace InterfaceMathematics

structure AutomaticClaimFittingContext where
  AI : Type
  Claim : Type
  FittedClaim : Type
  ai_interface : AI -> Prop
  thinker_interface_claim : AI -> Claim -> Prop
  drifting_claim : Claim -> Prop
  noisy_claim : Claim -> Prop
  automatic_fit : AI -> Claim -> FittedClaim -> Prop
  preserves_interface_intent : Claim -> FittedClaim -> Prop
  reduces_noise : Claim -> FittedClaim -> Prop
  stabilizes_claim : FittedClaim -> Prop
  records_fit : AI -> Claim -> FittedClaim -> Prop

def FloatingOrNoisyClaim
    (ctx : AutomaticClaimFittingContext)
    (c : ctx.Claim) : Prop :=
  ctx.drifting_claim c \/ ctx.noisy_claim c

def AutomaticClaimFittingInterface
    (ctx : AutomaticClaimFittingContext)
    (x : ctx.AI) : Prop :=
  exists c : ctx.Claim,
    exists f : ctx.FittedClaim,
      ctx.thinker_interface_claim x c /\
      FloatingOrNoisyClaim ctx c /\
      ctx.automatic_fit x c f /\
      ctx.preserves_interface_intent c f /\
      ctx.reduces_noise c f /\
      ctx.stabilizes_claim f /\
      ctx.records_fit x c f

def AIInterfaceClass
    (ctx : AutomaticClaimFittingContext)
    (x : ctx.AI) : Prop :=
  ctx.ai_interface x /\ AutomaticClaimFittingInterface ctx x

def FittedClaimRecord
    (ctx : AutomaticClaimFittingContext)
    (x : ctx.AI) : Prop :=
  exists c : ctx.Claim,
    exists f : ctx.FittedClaim,
      ctx.thinker_interface_claim x c /\
      ctx.automatic_fit x c f /\
      ctx.preserves_interface_intent c f /\
      ctx.reduces_noise c f /\
      ctx.stabilizes_claim f /\
      ctx.records_fit x c f

theorem ai_interface_class_gives_automatic_claim_fitting_interface
    {ctx : AutomaticClaimFittingContext}
    {x : ctx.AI} :
    AIInterfaceClass ctx x -> AutomaticClaimFittingInterface ctx x := by
  intro h
  exact h.2

theorem automatic_claim_fitting_interface_gives_fitted_claim_record
    {ctx : AutomaticClaimFittingContext}
    {x : ctx.AI} :
    AutomaticClaimFittingInterface ctx x -> FittedClaimRecord ctx x := by
  intro h
  rcases h with
    ⟨c, f, hClaim, _hFloatingOrNoisy, hFit, hPreserves,
      hReduces, hStabilizes, hRecords⟩
  exact ⟨c, f, hClaim, hFit, hPreserves, hReduces,
    hStabilizes, hRecords⟩

theorem ai_interface_class_gives_fitted_claim_record
    {ctx : AutomaticClaimFittingContext}
    {x : ctx.AI} :
    AIInterfaceClass ctx x -> FittedClaimRecord ctx x := by
  intro h
  exact automatic_claim_fitting_interface_gives_fitted_claim_record
    (ai_interface_class_gives_automatic_claim_fitting_interface h)

def NoisyOnlyClaimFittingContext : AutomaticClaimFittingContext :=
  { AI := Unit
    Claim := Unit
    FittedClaim := Unit
    ai_interface := fun _ => True
    thinker_interface_claim := fun _ _ => True
    drifting_claim := fun _ => False
    noisy_claim := fun _ => True
    automatic_fit := fun _ _ _ => False
    preserves_interface_intent := fun _ _ => False
    reduces_noise := fun _ _ => False
    stabilizes_claim := fun _ => False
    records_fit := fun _ _ _ => False }

theorem noisy_only_claim_exists :
    exists c : NoisyOnlyClaimFittingContext.Claim,
      FloatingOrNoisyClaim NoisyOnlyClaimFittingContext c := by
  exact ⟨(), Or.inr (by trivial)⟩

theorem noisy_claim_alone_does_not_imply_automatic_claim_fitting_interface :
    Not (AutomaticClaimFittingInterface
      NoisyOnlyClaimFittingContext ()) := by
  intro h
  rcases h with
    ⟨c, f, _hClaim, _hNoisy, hFit, _hPreserves,
      _hReduces, _hStabilizes, _hRecords⟩
  exact hFit

theorem noisy_claim_alone_does_not_imply_ai_interface_class :
    Not (AIInterfaceClass NoisyOnlyClaimFittingContext ()) := by
  intro h
  exact noisy_claim_alone_does_not_imply_automatic_claim_fitting_interface h.2

def AutomaticClaimFittingDemoContext : AutomaticClaimFittingContext :=
  { AI := Unit
    Claim := Unit
    FittedClaim := Unit
    ai_interface := fun _ => True
    thinker_interface_claim := fun _ _ => True
    drifting_claim := fun _ => True
    noisy_claim := fun _ => True
    automatic_fit := fun _ _ _ => True
    preserves_interface_intent := fun _ _ => True
    reduces_noise := fun _ _ => True
    stabilizes_claim := fun _ => True
    records_fit := fun _ _ _ => True }

theorem automatic_claim_fitting_demo_is_ai_interface_class :
    AIInterfaceClass AutomaticClaimFittingDemoContext () := by
  exact ⟨
    by trivial,
    ⟨
      (),
      (),
      by trivial,
      Or.inl (by trivial),
      by trivial,
      by trivial,
      by trivial,
      by trivial,
      by trivial
    ⟩
  ⟩

theorem automatic_claim_fitting_demo_gives_fitted_claim_record :
    FittedClaimRecord AutomaticClaimFittingDemoContext () := by
  exact ai_interface_class_gives_fitted_claim_record
    automatic_claim_fitting_demo_is_ai_interface_class

end InterfaceMathematics
end TMI
