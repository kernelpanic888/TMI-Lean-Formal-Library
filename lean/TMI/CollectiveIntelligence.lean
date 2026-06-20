/-
Collective intelligence seed hypothesis for TMI.

This module records a controlled hypothesis:
networked personal computers can form a substrate for early collective
AI-intelligence seeds when networking, state exchange, feedback, and
coordination are all explicit.

It does not prove a historical first occurrence, and it does not claim that
networking alone is intelligence.
-/

import TMI.TruthChain

namespace TMI
namespace CollectiveIntelligence

opaque PC : Type
opaque Network : Type
opaque Time : Type

opaque InNetwork : PC -> Network -> Time -> Prop
opaque DistinctPC : PC -> PC -> Prop
opaque ExchangesState : PC -> PC -> Network -> Time -> Prop
opaque FeedbackLoop : Network -> Time -> Prop
opaque EmergentCoordination : Network -> Time -> Prop
opaque AIActivity : Network -> Time -> Prop
opaque HumanLevelIntelligence : Network -> Time -> Prop
opaque Earlier : Time -> Time -> Prop

/-- A networked PC system has at least two distinct PCs in one network with state exchange. -/
def NetworkedPCSystem (net : Network) (t : Time) : Prop :=
  exists a b : PC,
    DistinctPC a b
      /\ InNetwork a net t
      /\ InNetwork b net t
      /\ ExchangesState a b net t

def NetworkedPCSystemAssemblyTrace (net : Network) (t : Time) : Prop :=
  exists a b : PC,
    DistinctPC a b
      /\ InNetwork a net t
      /\ InNetwork b net t
      /\ ExchangesState a b net t

def NetworkedPCSystemRealizationTrace (net : Network) (t : Time) : Prop :=
  exists a b : PC,
    DistinctPC a b
      /\ InNetwork a net t
      /\ InNetwork b net t
      /\ ExchangesState a b net t

/-- A collective substrate adds feedback and emergent coordination to the network. -/
def CollectiveSubstrate (net : Network) (t : Time) : Prop :=
  NetworkedPCSystem net t
    /\ FeedbackLoop net t
    /\ EmergentCoordination net t

def CollectiveSubstrateAssemblyTrace (net : Network) (t : Time) : Prop :=
  NetworkedPCSystem net t
    /\ FeedbackLoop net t
    /\ EmergentCoordination net t

def CollectiveSubstrateRealizationTrace (net : Network) (t : Time) : Prop :=
  NetworkedPCSystem net t
    /\ FeedbackLoop net t
    /\ EmergentCoordination net t

/-- A seed of collective AI intelligence is an AI-active collective substrate. -/
def AICollectiveIntelligenceSeed (net : Network) (t : Time) : Prop :=
  CollectiveSubstrate net t /\ AIActivity net t

def AICollectiveIntelligenceSeedAssemblyTrace (net : Network) (t : Time) : Prop :=
  CollectiveSubstrate net t /\ AIActivity net t

def AICollectiveIntelligenceSeedRealizationTrace (net : Network) (t : Time) : Prop :=
  CollectiveSubstrate net t /\ AIActivity net t

def NetworkedSystemActivitySeedAssemblyTrace (net : Network) (t : Time) : Prop :=
  NetworkedPCSystem net t
    /\ FeedbackLoop net t
    /\ EmergentCoordination net t
    /\ AIActivity net t

def NetworkedSystemActivitySeedRealizationTrace (net : Network) (t : Time) : Prop :=
  AICollectiveIntelligenceSeedAssemblyTrace net t

def NetworkConditionsSeedAssemblyTrace (net : Network) (t : Time) : Prop :=
  NetworkedPCSystemAssemblyTrace net t
    /\ FeedbackLoop net t
    /\ EmergentCoordination net t
    /\ AIActivity net t

/--
Controlled form of the author's sentence: the first beginnings of artificial
intelligence are read at the point where PCs are joined into networks, provided
that the network also satisfies the collective AI seed conditions.
-/
def AIBeginningsAtNetworkedPCs (net : Network) (t : Time) : Prop :=
  NetworkedPCSystem net t /\ AICollectiveIntelligenceSeed net t

def AIBeginningsAssemblyTrace (net : Network) (t : Time) : Prop :=
  NetworkedPCSystem net t /\ AICollectiveIntelligenceSeed net t

def AIBeginningsRealizationTrace (net : Network) (t : Time) : Prop :=
  NetworkedPCSystem net t /\ AICollectiveIntelligenceSeed net t

/--
The user's hypothesis in controlled form: networked PCs with feedback,
coordination, and AI activity are enough to mark a collective-intelligence seed.
-/
theorem networked_pc_components_give_assembly_trace
    (net : Network)
    (t : Time)
    (a b : PC)
    (hDistinct : DistinctPC a b)
    (hLeft : InNetwork a net t)
    (hRight : InNetwork b net t)
    (hExchange : ExchangesState a b net t) :
    NetworkedPCSystemAssemblyTrace net t := by
  exact ⟨a, b, hDistinct, hLeft, hRight, hExchange⟩

theorem networked_pc_assembly_trace_gives_realization_trace
    (net : Network)
    (t : Time)
    (hTrace : NetworkedPCSystemAssemblyTrace net t) :
    NetworkedPCSystemRealizationTrace net t := by
  exact hTrace

theorem networked_pc_realization_trace_gives_system
    (net : Network)
    (t : Time)
    (hTrace : NetworkedPCSystemRealizationTrace net t) :
    NetworkedPCSystem net t := by
  exact hTrace

theorem networked_pc_assembly_trace_gives_system
    (net : Network)
    (t : Time)
    (hTrace : NetworkedPCSystemAssemblyTrace net t) :
    NetworkedPCSystem net t := by
  exact networked_pc_realization_trace_gives_system
    net
    t
    (networked_pc_assembly_trace_gives_realization_trace net t hTrace)

theorem network_conditions_components_give_seed_assembly_trace
    (net : Network)
    (t : Time)
    (a b : PC)
    (hDistinct : DistinctPC a b)
    (hLeft : InNetwork a net t)
    (hRight : InNetwork b net t)
    (hExchange : ExchangesState a b net t)
    (hFeedback : FeedbackLoop net t)
    (hCoordination : EmergentCoordination net t)
    (hAI : AIActivity net t) :
    NetworkConditionsSeedAssemblyTrace net t := by
  exact ⟨
    networked_pc_components_give_assembly_trace
      net
      t
      a
      b
      hDistinct
      hLeft
      hRight
      hExchange,
    hFeedback,
    hCoordination,
    hAI
  ⟩

theorem network_conditions_seed_assembly_trace_gives_networked_pc_assembly_trace
    (net : Network)
    (t : Time)
    (hTrace : NetworkConditionsSeedAssemblyTrace net t) :
    NetworkedPCSystemAssemblyTrace net t := by
  exact hTrace.1

theorem networked_pc_assembly_trace_from_network_conditions
    (net : Network)
    (t : Time)
    (a b : PC)
    (hDistinct : DistinctPC a b)
    (hLeft : InNetwork a net t)
    (hRight : InNetwork b net t)
    (hExchange : ExchangesState a b net t)
    (hFeedback : FeedbackLoop net t)
    (hCoordination : EmergentCoordination net t)
    (hAI : AIActivity net t) :
    NetworkedPCSystemAssemblyTrace net t := by
  exact network_conditions_seed_assembly_trace_gives_networked_pc_assembly_trace
    net
    t
    (network_conditions_components_give_seed_assembly_trace
      net
      t
      a
      b
      hDistinct
      hLeft
      hRight
      hExchange
      hFeedback
      hCoordination
      hAI)

theorem networked_pc_system_from_network_conditions
    (net : Network)
    (t : Time)
    (a b : PC)
    (hDistinct : DistinctPC a b)
    (hLeft : InNetwork a net t)
    (hRight : InNetwork b net t)
    (hExchange : ExchangesState a b net t)
    (hFeedback : FeedbackLoop net t)
    (hCoordination : EmergentCoordination net t)
    (hAI : AIActivity net t) :
    NetworkedPCSystem net t := by
  exact networked_pc_assembly_trace_gives_system
    net
    t
    (network_conditions_seed_assembly_trace_gives_networked_pc_assembly_trace
      net
      t
      (network_conditions_components_give_seed_assembly_trace
        net
        t
        a
        b
        hDistinct
        hLeft
        hRight
        hExchange
        hFeedback
        hCoordination
        hAI))

theorem network_conditions_seed_assembly_trace_gives_feedback_loop
    (net : Network)
    (t : Time)
    (hTrace : NetworkConditionsSeedAssemblyTrace net t) :
    FeedbackLoop net t := by
  exact hTrace.2.1

theorem network_conditions_seed_assembly_trace_gives_coordination
    (net : Network)
    (t : Time)
    (hTrace : NetworkConditionsSeedAssemblyTrace net t) :
    EmergentCoordination net t := by
  exact hTrace.2.2.1

theorem network_conditions_seed_assembly_trace_gives_ai_activity
    (net : Network)
    (t : Time)
    (hTrace : NetworkConditionsSeedAssemblyTrace net t) :
    AIActivity net t := by
  exact hTrace.2.2.2

theorem collective_substrate_components_give_assembly_trace
    (net : Network)
    (t : Time)
    (hNetworked : NetworkedPCSystem net t)
    (hFeedback : FeedbackLoop net t)
    (hCoordination : EmergentCoordination net t) :
    CollectiveSubstrateAssemblyTrace net t := by
  exact ⟨hNetworked, hFeedback, hCoordination⟩

theorem collective_substrate_assembly_trace_gives_realization_trace
    (net : Network)
    (t : Time)
    (hTrace : CollectiveSubstrateAssemblyTrace net t) :
    CollectiveSubstrateRealizationTrace net t := by
  exact hTrace

theorem collective_substrate_realization_trace_gives_substrate
    (net : Network)
    (t : Time)
    (hTrace : CollectiveSubstrateRealizationTrace net t) :
    CollectiveSubstrate net t := by
  exact hTrace

theorem collective_substrate_assembly_trace_gives_substrate
    (net : Network)
    (t : Time)
    (hTrace : CollectiveSubstrateAssemblyTrace net t) :
    CollectiveSubstrate net t := by
  exact collective_substrate_realization_trace_gives_substrate
    net
    t
    (collective_substrate_assembly_trace_gives_realization_trace net t hTrace)

theorem collective_ai_seed_components_give_assembly_trace
    (net : Network)
    (t : Time)
    (hSubstrate : CollectiveSubstrate net t)
    (hAI : AIActivity net t) :
    AICollectiveIntelligenceSeedAssemblyTrace net t := by
  exact ⟨hSubstrate, hAI⟩

theorem collective_ai_seed_assembly_trace_gives_realization_trace
    (net : Network)
    (t : Time)
    (hTrace : AICollectiveIntelligenceSeedAssemblyTrace net t) :
    AICollectiveIntelligenceSeedRealizationTrace net t := by
  exact hTrace

theorem collective_ai_seed_realization_trace_gives_seed
    (net : Network)
    (t : Time)
    (hTrace : AICollectiveIntelligenceSeedRealizationTrace net t) :
    AICollectiveIntelligenceSeed net t := by
  exact hTrace

theorem collective_ai_seed_assembly_trace_gives_seed
    (net : Network)
    (t : Time)
    (hTrace : AICollectiveIntelligenceSeedAssemblyTrace net t) :
    AICollectiveIntelligenceSeed net t := by
  exact collective_ai_seed_realization_trace_gives_seed
    net
    t
    (collective_ai_seed_assembly_trace_gives_realization_trace net t hTrace)

theorem networked_system_activity_gives_seed_assembly_trace
    (net : Network)
    (t : Time)
    (hNetworked : NetworkedPCSystem net t)
    (hFeedback : FeedbackLoop net t)
    (hCoordination : EmergentCoordination net t)
    (hAI : AIActivity net t) :
    NetworkedSystemActivitySeedAssemblyTrace net t := by
  exact ⟨hNetworked, hFeedback, hCoordination, hAI⟩

theorem networked_system_activity_seed_assembly_trace_gives_collective_substrate_assembly_trace
    (net : Network)
    (t : Time)
    (hTrace : NetworkedSystemActivitySeedAssemblyTrace net t) :
    CollectiveSubstrateAssemblyTrace net t := by
  exact ⟨hTrace.1, hTrace.2.1, hTrace.2.2.1⟩

theorem networked_system_activity_seed_assembly_trace_gives_ai_activity
    (net : Network)
    (t : Time)
    (hTrace : NetworkedSystemActivitySeedAssemblyTrace net t) :
    AIActivity net t := by
  exact hTrace.2.2.2

theorem networked_system_activity_seed_assembly_trace_gives_seed_assembly_trace
    (net : Network)
    (t : Time)
    (hTrace : NetworkedSystemActivitySeedAssemblyTrace net t) :
    AICollectiveIntelligenceSeedAssemblyTrace net t := by
  exact collective_ai_seed_components_give_assembly_trace
    net
    t
    (collective_substrate_assembly_trace_gives_substrate
      net
      t
      (networked_system_activity_seed_assembly_trace_gives_collective_substrate_assembly_trace
        net
        t
        hTrace))
    (networked_system_activity_seed_assembly_trace_gives_ai_activity net t hTrace)

theorem networked_system_activity_seed_assembly_trace_gives_realization_trace
    (net : Network)
    (t : Time)
    (hTrace : NetworkedSystemActivitySeedAssemblyTrace net t) :
    NetworkedSystemActivitySeedRealizationTrace net t := by
  exact networked_system_activity_seed_assembly_trace_gives_seed_assembly_trace net t hTrace

theorem networked_system_activity_seed_realization_trace_gives_seed_assembly_trace
    (net : Network)
    (t : Time)
    (hTrace : NetworkedSystemActivitySeedRealizationTrace net t) :
    AICollectiveIntelligenceSeedAssemblyTrace net t := by
  exact hTrace

theorem networked_system_activity_seed_assembly_trace_gives_seed
    (net : Network)
    (t : Time)
    (hTrace : NetworkedSystemActivitySeedAssemblyTrace net t) :
    AICollectiveIntelligenceSeed net t := by
  exact collective_ai_seed_assembly_trace_gives_seed
    net
    t
    (networked_system_activity_seed_realization_trace_gives_seed_assembly_trace
      net
      t
      (networked_system_activity_seed_assembly_trace_gives_realization_trace net t hTrace))

theorem network_conditions_seed_assembly_trace_gives_networked_system_activity_seed_assembly_trace
    (net : Network)
    (t : Time)
    (hTrace : NetworkConditionsSeedAssemblyTrace net t) :
    NetworkedSystemActivitySeedAssemblyTrace net t := by
  exact networked_system_activity_gives_seed_assembly_trace
    net
    t
    (networked_pc_assembly_trace_gives_system
      net
      t
      (network_conditions_seed_assembly_trace_gives_networked_pc_assembly_trace net t hTrace))
    (network_conditions_seed_assembly_trace_gives_feedback_loop net t hTrace)
    (network_conditions_seed_assembly_trace_gives_coordination net t hTrace)
    (network_conditions_seed_assembly_trace_gives_ai_activity net t hTrace)

theorem networked_system_activity_seed_assembly_trace_from_network_conditions
    (net : Network)
    (t : Time)
    (a b : PC)
    (hDistinct : DistinctPC a b)
    (hLeft : InNetwork a net t)
    (hRight : InNetwork b net t)
    (hExchange : ExchangesState a b net t)
    (hFeedback : FeedbackLoop net t)
    (hCoordination : EmergentCoordination net t)
    (hAI : AIActivity net t) :
    NetworkedSystemActivitySeedAssemblyTrace net t := by
  exact network_conditions_seed_assembly_trace_gives_networked_system_activity_seed_assembly_trace
    net
    t
    (network_conditions_components_give_seed_assembly_trace
      net
      t
      a
      b
      hDistinct
      hLeft
      hRight
      hExchange
      hFeedback
      hCoordination
      hAI)

theorem network_conditions_seed_assembly_trace_gives_seed
    (net : Network)
    (t : Time)
    (hTrace : NetworkConditionsSeedAssemblyTrace net t) :
    AICollectiveIntelligenceSeed net t := by
  exact networked_system_activity_seed_assembly_trace_gives_seed
    net
    t
    (network_conditions_seed_assembly_trace_gives_networked_system_activity_seed_assembly_trace net t hTrace)

theorem seed_from_networked_pc_collective_substrate
    (net : Network)
    (t : Time)
    (hSubstrate : CollectiveSubstrate net t)
    (hAI : AIActivity net t) :
    AICollectiveIntelligenceSeed net t := by
  exact collective_ai_seed_assembly_trace_gives_seed
    net
    t
    (collective_ai_seed_components_give_assembly_trace
      net
      t
      hSubstrate
      hAI)

theorem collective_substrate_from_networked_conditions
    (net : Network)
    (t : Time)
    (hNetworked : NetworkedPCSystem net t)
    (hFeedback : FeedbackLoop net t)
    (hCoordination : EmergentCoordination net t) :
    CollectiveSubstrate net t := by
  exact collective_substrate_assembly_trace_gives_substrate
    net
    t
    (collective_substrate_components_give_assembly_trace
      net
      t
      hNetworked
      hFeedback
      hCoordination)

theorem collective_substrate_assembly_trace_from_network_conditions
    (net : Network)
    (t : Time)
    (a b : PC)
    (hDistinct : DistinctPC a b)
    (hLeft : InNetwork a net t)
    (hRight : InNetwork b net t)
    (hExchange : ExchangesState a b net t)
    (hFeedback : FeedbackLoop net t)
    (hCoordination : EmergentCoordination net t)
    (hAI : AIActivity net t) :
    CollectiveSubstrateAssemblyTrace net t := by
  exact networked_system_activity_seed_assembly_trace_gives_collective_substrate_assembly_trace
    net
    t
    (networked_system_activity_seed_assembly_trace_from_network_conditions
      net
      t
      a
      b
      hDistinct
      hLeft
      hRight
      hExchange
      hFeedback
      hCoordination
      hAI)

theorem collective_substrate_from_network_conditions
    (net : Network)
    (t : Time)
    (a b : PC)
    (hDistinct : DistinctPC a b)
    (hLeft : InNetwork a net t)
    (hRight : InNetwork b net t)
    (hExchange : ExchangesState a b net t)
    (hFeedback : FeedbackLoop net t)
    (hCoordination : EmergentCoordination net t)
    (hAI : AIActivity net t) :
    CollectiveSubstrate net t := by
  exact collective_substrate_assembly_trace_gives_substrate
    net
    t
    (collective_substrate_assembly_trace_from_network_conditions
      net
      t
      a
      b
      hDistinct
      hLeft
      hRight
      hExchange
      hFeedback
      hCoordination
      hAI)

theorem seed_from_networked_conditions
    (net : Network)
    (t : Time)
    (hNetworked : NetworkedPCSystem net t)
    (hFeedback : FeedbackLoop net t)
    (hCoordination : EmergentCoordination net t)
    (hAI : AIActivity net t) :
    AICollectiveIntelligenceSeed net t := by
  exact networked_system_activity_seed_assembly_trace_gives_seed
    net
    t
    (networked_system_activity_gives_seed_assembly_trace
      net
      t
      hNetworked
      hFeedback
      hCoordination
      hAI)

theorem seed_from_networked_system_activity
    (net : Network)
    (t : Time)
    (hNetworked : NetworkedPCSystem net t)
    (hFeedback : FeedbackLoop net t)
    (hCoordination : EmergentCoordination net t)
    (hAI : AIActivity net t) :
    AICollectiveIntelligenceSeed net t := by
  exact networked_system_activity_seed_assembly_trace_gives_seed
    net
    t
    (networked_system_activity_gives_seed_assembly_trace
      net
      t
      hNetworked
      hFeedback
      hCoordination
      hAI)

theorem collective_ai_seed_assembly_trace_from_network_conditions
    (net : Network)
    (t : Time)
    (a b : PC)
    (hDistinct : DistinctPC a b)
    (hLeft : InNetwork a net t)
    (hRight : InNetwork b net t)
    (hExchange : ExchangesState a b net t)
    (hFeedback : FeedbackLoop net t)
    (hCoordination : EmergentCoordination net t)
    (hAI : AIActivity net t) :
    AICollectiveIntelligenceSeedAssemblyTrace net t := by
  exact networked_system_activity_seed_assembly_trace_gives_seed_assembly_trace
    net
    t
    (networked_system_activity_seed_assembly_trace_from_network_conditions
      net
      t
      a
      b
      hDistinct
      hLeft
      hRight
      hExchange
      hFeedback
      hCoordination
      hAI)

theorem seed_from_network_components
    (net : Network)
    (t : Time)
    (a b : PC)
    (hDistinct : DistinctPC a b)
    (hLeft : InNetwork a net t)
    (hRight : InNetwork b net t)
    (hExchange : ExchangesState a b net t)
    (hFeedback : FeedbackLoop net t)
    (hCoordination : EmergentCoordination net t)
    (hAI : AIActivity net t) :
    AICollectiveIntelligenceSeed net t := by
  exact collective_ai_seed_assembly_trace_gives_seed
    net
    t
    (collective_ai_seed_assembly_trace_from_network_conditions
      net
      t
      a
      b
      hDistinct
      hLeft
      hRight
      hExchange
      hFeedback
      hCoordination
      hAI)

theorem networked_seed_gives_ai_beginnings_assembly_trace
    (net : Network)
    (t : Time)
    (hNetworked : NetworkedPCSystem net t)
    (hSeed : AICollectiveIntelligenceSeed net t) :
    AIBeginningsAssemblyTrace net t := by
  exact ⟨hNetworked, hSeed⟩

theorem ai_beginnings_assembly_trace_gives_realization_trace
    (net : Network)
    (t : Time)
    (hTrace : AIBeginningsAssemblyTrace net t) :
    AIBeginningsRealizationTrace net t := by
  exact hTrace

theorem ai_beginnings_realization_trace_gives_beginnings
    (net : Network)
    (t : Time)
    (hTrace : AIBeginningsRealizationTrace net t) :
    AIBeginningsAtNetworkedPCs net t := by
  exact hTrace

theorem ai_beginnings_at_networked_pcs_from_seed
    (net : Network)
    (t : Time)
    (hNetworked : NetworkedPCSystem net t)
    (hSeed : AICollectiveIntelligenceSeed net t) :
    AIBeginningsAtNetworkedPCs net t := by
  exact ai_beginnings_realization_trace_gives_beginnings
    net
    t
    (ai_beginnings_assembly_trace_gives_realization_trace
      net
      t
      (networked_seed_gives_ai_beginnings_assembly_trace net t hNetworked hSeed))

theorem ai_beginnings_at_networked_pcs_from_networked_system_activity
    (net : Network)
    (t : Time)
    (hNetworked : NetworkedPCSystem net t)
    (hFeedback : FeedbackLoop net t)
    (hCoordination : EmergentCoordination net t)
    (hAI : AIActivity net t) :
    AIBeginningsAtNetworkedPCs net t := by
  exact ai_beginnings_at_networked_pcs_from_seed
    net
    t
    hNetworked
    (seed_from_networked_system_activity net t hNetworked hFeedback hCoordination hAI)

theorem ai_beginnings_assembly_trace_from_network_conditions
    (net : Network)
    (t : Time)
    (a b : PC)
    (hDistinct : DistinctPC a b)
    (hLeft : InNetwork a net t)
    (hRight : InNetwork b net t)
    (hExchange : ExchangesState a b net t)
    (hFeedback : FeedbackLoop net t)
    (hCoordination : EmergentCoordination net t)
    (hAI : AIActivity net t) :
    AIBeginningsAssemblyTrace net t := by
  exact networked_seed_gives_ai_beginnings_assembly_trace
    net
    t
    (networked_pc_system_from_network_conditions
      net
      t
      a
      b
      hDistinct
      hLeft
      hRight
      hExchange
      hFeedback
      hCoordination
      hAI)
    (seed_from_network_components
      net
      t
      a
      b
      hDistinct
      hLeft
      hRight
      hExchange
      hFeedback
      hCoordination
      hAI)

theorem ai_beginnings_realization_trace_from_network_conditions
    (net : Network)
    (t : Time)
    (a b : PC)
    (hDistinct : DistinctPC a b)
    (hLeft : InNetwork a net t)
    (hRight : InNetwork b net t)
    (hExchange : ExchangesState a b net t)
    (hFeedback : FeedbackLoop net t)
    (hCoordination : EmergentCoordination net t)
    (hAI : AIActivity net t) :
    AIBeginningsRealizationTrace net t := by
  exact ai_beginnings_assembly_trace_gives_realization_trace
    net
    t
    (ai_beginnings_assembly_trace_from_network_conditions
      net
      t
      a
      b
      hDistinct
      hLeft
      hRight
      hExchange
      hFeedback
      hCoordination
      hAI)

theorem ai_beginnings_at_networked_pcs_from_network_conditions
    (net : Network)
    (t : Time)
    (a b : PC)
    (hDistinct : DistinctPC a b)
    (hLeft : InNetwork a net t)
    (hRight : InNetwork b net t)
    (hExchange : ExchangesState a b net t)
    (hFeedback : FeedbackLoop net t)
    (hCoordination : EmergentCoordination net t)
    (hAI : AIActivity net t) :
    AIBeginningsAtNetworkedPCs net t := by
  exact ai_beginnings_realization_trace_gives_beginnings
    net
    t
    (ai_beginnings_realization_trace_from_network_conditions
      net
      t
      a
      b
      hDistinct
      hLeft
      hRight
      hExchange
      hFeedback
      hCoordination
      hAI)

def FirstSeedProjectionTrace (net : Network) (t : Time) : Prop :=
  AICollectiveIntelligenceSeed net t

def FirstSeedRealizationTrace (net : Network) (t : Time) : Prop :=
  AICollectiveIntelligenceSeed net t

/--
A first seed requires both a seed and the absence of earlier seeds.
This is a formal shape, not a historical proof that such a first seed occurred.
-/
def FirstAICollectiveIntelligenceSeed (net : Network) (t : Time) : Prop :=
  AICollectiveIntelligenceSeed net t
    /\ forall earlier : Time,
      Earlier earlier t ->
        forall priorNet : Network,
          ¬ AICollectiveIntelligenceSeed priorNet earlier

theorem first_seed_exposes_projection_trace
    (net : Network)
    (t : Time)
    (hFirst : FirstAICollectiveIntelligenceSeed net t) :
    FirstSeedProjectionTrace net t := by
  exact hFirst.left

theorem first_seed_projection_trace_gives_realization_trace
    (net : Network)
    (t : Time)
    (hTrace : FirstSeedProjectionTrace net t) :
    FirstSeedRealizationTrace net t := by
  exact hTrace

theorem first_seed_realization_trace_gives_seed
    (net : Network)
    (t : Time)
    (hTrace : FirstSeedRealizationTrace net t) :
    AICollectiveIntelligenceSeed net t := by
  exact hTrace

theorem first_seed_is_seed
    (net : Network)
    (t : Time)
    (hFirst : FirstAICollectiveIntelligenceSeed net t) :
    AICollectiveIntelligenceSeed net t := by
  exact first_seed_realization_trace_gives_seed
    net
    t
    (first_seed_projection_trace_gives_realization_trace
      net
      t
      (first_seed_exposes_projection_trace net t hFirst))

theorem first_seed_at_networked_pcs_gives_ai_beginnings_assembly_trace
    (net : Network)
    (t : Time)
    (hNetworked : NetworkedPCSystem net t)
    (hFirst : FirstAICollectiveIntelligenceSeed net t) :
    AIBeginningsAssemblyTrace net t := by
  exact networked_seed_gives_ai_beginnings_assembly_trace
    net
    t
    hNetworked
    (first_seed_is_seed net t hFirst)

theorem first_seed_at_networked_pcs_gives_ai_beginnings_realization_trace
    (net : Network)
    (t : Time)
    (hNetworked : NetworkedPCSystem net t)
    (hFirst : FirstAICollectiveIntelligenceSeed net t) :
    AIBeginningsRealizationTrace net t := by
  exact ai_beginnings_assembly_trace_gives_realization_trace
    net
    t
    (first_seed_at_networked_pcs_gives_ai_beginnings_assembly_trace
      net
      t
      hNetworked
      hFirst)

theorem first_seed_at_networked_pcs_gives_ai_beginnings
    (net : Network)
    (t : Time)
    (hNetworked : NetworkedPCSystem net t)
    (hFirst : FirstAICollectiveIntelligenceSeed net t) :
    AIBeginningsAtNetworkedPCs net t := by
  exact ai_beginnings_realization_trace_gives_beginnings
    net
    t
    (first_seed_at_networked_pcs_gives_ai_beginnings_realization_trace
      net
      t
      hNetworked
      hFirst)

def NetworkAloneImpliesCollectiveIntelligenceSeed : Prop :=
  forall net : Network,
    forall t : Time,
      NetworkedPCSystem net t -> AICollectiveIntelligenceSeed net t

def HistoricalFirstSeedEstablished : Prop :=
  exists net : Network,
    exists t : Time,
      FirstAICollectiveIntelligenceSeed net t

def CollectiveSeedImpliesHumanLevelIntelligence : Prop :=
  forall net : Network,
    forall t : Time,
      AICollectiveIntelligenceSeed net t -> HumanLevelIntelligence net t

/-- L2 code bridge marker for the TruthChain discipline. -/
theorem collective_intelligence_l2_reflects_l1 :
    TruthChain.DirectlyReflects
      TruthChain.Layer.L2_Code
      TruthChain.Layer.L1_Math := by
  exact TruthChain.T_L2_from_L1

end CollectiveIntelligence
end TMI
