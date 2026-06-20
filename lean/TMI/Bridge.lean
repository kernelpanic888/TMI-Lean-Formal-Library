/-
Bridge surface for TMI-Lean Formal Library 0.1.

The bridge module names the general pattern by which a source interface is
encoded into a target interface while preserving admissibility and record
conditions.
-/

import TMI.BridgePhysics

namespace TMI
namespace Bridge

structure BridgeContext where
  Source : Type
  Target : Type
  source_admissible : Source -> Prop
  target_admissible : Target -> Prop
  encodes : Source -> Target -> Prop
  preserves_record : Source -> Target -> Prop

def BridgeWitness (ctx : BridgeContext) (s : ctx.Source) : Prop :=
  ctx.source_admissible s /\
  exists t : ctx.Target,
    ctx.encodes s t /\
    ctx.target_admissible t /\
    ctx.preserves_record s t

def BridgeTarget (ctx : BridgeContext) (t : ctx.Target) : Prop :=
  ctx.target_admissible t

theorem bridge_witness_gives_target
    {ctx : BridgeContext}
    {s : ctx.Source} :
    BridgeWitness ctx s ->
      exists t : ctx.Target, BridgeTarget ctx t := by
  intro h
  rcases h with ⟨_, t, _, ht, _⟩
  exact ⟨t, ht⟩

end Bridge
end TMI
