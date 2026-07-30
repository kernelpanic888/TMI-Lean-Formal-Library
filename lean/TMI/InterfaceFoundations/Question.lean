import Mathlib

/-!
# Question carrier

A raw question occurrence is deliberately independent from its interface
carrier.  The bridge from occurrence to a guarded carrier remains explicit.
This module does not infer an external questioner or an empirical domain.
-/

universe u v w

namespace TMI.InterfaceFoundations.Question

structure Language where
  Carrier : Type u
  Question : Type v
  Agent : Type w
  primitiveOccurs : Question -> Prop
  carries : Carrier -> Question -> Prop
  guarded : Carrier -> Prop
  gap : Carrier -> Nat
  noFullMerge : Carrier -> Prop
  asks : Agent -> Question -> Prop

variable (L : Language)

def Nothing : Prop :=
  Not (Nonempty L.Carrier)

def Something : Prop :=
  exists carrier : L.Carrier, L.guarded carrier /\ 0 < L.gap carrier

def Collapsed : Prop :=
  Nonempty L.Carrier /\ forall carrier : L.Carrier, L.gap carrier = 0

def Occurs (q : L.Question) : Prop :=
  exists carrier : L.Carrier,
    L.guarded carrier /\ 0 < L.gap carrier /\ L.carries carrier q

def RawOccurs (q : L.Question) : Prop :=
  L.primitiveOccurs q

def PlanckTouch (deltaMin : Nat) (carrier : L.Carrier) : Prop :=
  L.guarded carrier /\
    L.gap carrier = deltaMin /\
    0 < deltaMin /\
    L.noFullMerge carrier

structure PlanckTouchBridge : Prop where
  lift :
    forall {q : L.Question},
      L.RawOccurs q ->
        exists deltaMin : Nat, exists carrier : L.Carrier,
          L.PlanckTouch deltaMin carrier /\ L.carries carrier q

theorem planckTouch_noncollapsed
    {deltaMin : Nat} {carrier : L.Carrier}
    (h : L.PlanckTouch deltaMin carrier) :
    0 < L.gap carrier /\ L.noFullMerge carrier := by
  rcases h with ⟨hGuarded, hGap, hPositive, hNoMerge⟩
  exact ⟨by simpa [hGap] using hPositive, hNoMerge⟩

theorem rawOccurs_to_occurs
    (bridge : L.PlanckTouchBridge)
    {q : L.Question}
    (hRaw : L.RawOccurs q) :
    L.Occurs q := by
  rcases bridge.lift hRaw with ⟨deltaMin, carrier, hTouch, hCarries⟩
  exact ⟨carrier, hTouch.1, by simpa [hTouch.2.1] using hTouch.2.2.1, hCarries⟩

theorem rawQuestion_answer
    (bridge : L.PlanckTouchBridge)
    {q : L.Question}
    (hRaw : L.RawOccurs q) :
    L.Something /\ Not L.Nothing /\ Not L.Collapsed := by
  rcases bridge.lift hRaw with ⟨deltaMin, carrier, hTouch, hCarries⟩
  have hPositive : 0 < L.gap carrier := by
    simpa [hTouch.2.1] using hTouch.2.2.1
  refine ⟨⟨carrier, hTouch.1, hPositive⟩, ?_, ?_⟩
  · intro hNothing
    exact hNothing ⟨carrier⟩
  · intro hCollapsed
    exact (Nat.ne_of_gt hPositive) (hCollapsed.2 carrier)

def QuestionEvent (q : L.Question) : Prop :=
  exists agent : L.Agent, L.asks agent q

def ExternalQuestionerWith
    (isExternal : L.Agent -> Prop)
    (q : L.Question) : Prop :=
  exists agent : L.Agent, isExternal agent /\ L.asks agent q

theorem no_questioner_no_questionEvent
    {q : L.Question}
    (hNone : Not (exists agent : L.Agent, L.asks agent q)) :
    Not (L.QuestionEvent q) := by
  exact hNone

theorem questionEvent_does_not_force_external
    {q : L.Question}
    (hQuestion : L.QuestionEvent q) :
    L.QuestionEvent q /\
      Not (L.ExternalQuestionerWith (fun _ => False) q) := by
  refine ⟨hQuestion, ?_⟩
  rintro ⟨agent, hExternal, hAsks⟩
  exact hExternal

theorem no_questioner_compatible_with_nonempty_world
    {World : Type*}
    {q : L.Question}
    (world : World)
    (hNone : Not (exists agent : L.Agent, L.asks agent q)) :
    Nonempty World /\ Not (L.QuestionEvent q) :=
  ⟨⟨world⟩, L.no_questioner_no_questionEvent hNone⟩

end TMI.InterfaceFoundations.Question
