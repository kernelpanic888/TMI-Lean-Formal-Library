/-
Self-thinking universe boundary for IF-REALITY / TMI.

This module records the top thesis as a protected formal boundary:
interfacehood is necessary for intelligence, but interfacehood alone is not
enough. A universe-level intelligence claim must pass through additional
criteria: record, self-model, adaptive selection, predictive correction, and
self-observation/closure.
-/

namespace TMI
namespace SelfThinkingUniverse

structure InterfaceProfile where
  interface : Prop
  record : Prop
  selfModel : Prop
  adaptiveSelection : Prop
  predictiveCorrection : Prop
  selfObservation : Prop
  closure : Prop
  distinctionsBecomeStates : Prop
  statesBecomeEvents : Prop
  eventsBecomeMemory : Prop
  memoryBecomesThinking : Prop

def Interfacehood (x : InterfaceProfile) : Prop :=
  x.interface

structure IntelligenceClaim (x : InterfaceProfile) : Prop where
  interface : Interfacehood x
  record : x.record
  self_model : x.selfModel
  adaptive_selection : x.adaptiveSelection
  predictive_correction : x.predictiveCorrection

structure UniverseSelfObservationProcess (u : InterfaceProfile) : Prop where
  self_interface : Interfacehood u
  self_observation : u.selfObservation
  distinctions_to_states : u.distinctionsBecomeStates
  states_to_events : u.statesBecomeEvents
  events_to_memory : u.eventsBecomeMemory
  memory_to_thinking : u.memoryBecomesThinking

structure UniverseIntelligenceClaim (u : InterfaceProfile) : Prop where
  process : UniverseSelfObservationProcess u
  intelligence : IntelligenceClaim u
  closure : u.closure

def UniverseAsSelfInterface (u : InterfaceProfile) : Prop :=
  UniverseSelfObservationProcess u

def UniverseThinksItselfClaim (u : InterfaceProfile) : Prop :=
  UniverseIntelligenceClaim u

def SelfClosedIntelligentInterface (u : InterfaceProfile) : Prop :=
  UniverseIntelligenceClaim u

structure UniverseSelfProcessContext (u : InterfaceProfile) where
  Proc : Type
  inside_universe : Proc -> Prop
  self_interface : Proc -> Prop
  self_observation : Proc -> Prop
  distinctions_become_states : Proc -> Prop
  states_become_events : Proc -> Prop
  events_become_memory : Proc -> Prop
  memory_becomes_thinking : Proc -> Prop
  self_process_inside_gives_universe_as_self_interface :
    (exists p : Proc,
      inside_universe p /\
      self_interface p /\
      self_observation p /\
      distinctions_become_states p /\
      states_become_events p /\
      events_become_memory p /\
      memory_becomes_thinking p) -> UniverseAsSelfInterface u

def SelfProcessEvent {u : InterfaceProfile}
    (ctx : UniverseSelfProcessContext u)
    (p : ctx.Proc) : Prop :=
  ctx.self_interface p /\
  ctx.self_observation p /\
  ctx.distinctions_become_states p /\
  ctx.states_become_events p /\
  ctx.events_become_memory p /\
  ctx.memory_becomes_thinking p

def SelfProcessWitnessInside {u : InterfaceProfile}
    (ctx : UniverseSelfProcessContext u) : Prop :=
  exists p : ctx.Proc, ctx.inside_universe p /\ SelfProcessEvent ctx p

structure LowLevelSelfProcessTrace {u : InterfaceProfile}
    (ctx : UniverseSelfProcessContext u) where
  process : ctx.Proc
  inside : ctx.inside_universe process
  self_interface : ctx.self_interface process
  self_observation : ctx.self_observation process
  distinctions_become_states :
    ctx.distinctions_become_states process
  states_become_events : ctx.states_become_events process
  events_become_memory : ctx.events_become_memory process
  memory_becomes_thinking :
    ctx.memory_becomes_thinking process

theorem low_level_self_process_trace_gives_self_process_inside
    {u : InterfaceProfile}
    {ctx : UniverseSelfProcessContext u} :
    LowLevelSelfProcessTrace ctx -> SelfProcessWitnessInside ctx := by
  intro h
  exact
    ⟨h.process, h.inside, h.self_interface, h.self_observation,
      h.distinctions_become_states, h.states_become_events,
      h.events_become_memory, h.memory_becomes_thinking⟩

theorem self_process_inside_gives_universe_as_self_interface
    {u : InterfaceProfile}
    (ctx : UniverseSelfProcessContext u) :
    SelfProcessWitnessInside ctx -> UniverseAsSelfInterface u := by
  intro h
  exact ctx.self_process_inside_gives_universe_as_self_interface h

theorem low_level_self_process_trace_gives_universe_as_self_interface
    {u : InterfaceProfile}
    {ctx : UniverseSelfProcessContext u} :
    LowLevelSelfProcessTrace ctx -> UniverseAsSelfInterface u := by
  intro h
  exact self_process_inside_gives_universe_as_self_interface
    ctx
    (low_level_self_process_trace_gives_self_process_inside h)

def InterfaceAloneImpliesIntelligenceClaim : Prop :=
  forall x : InterfaceProfile, Interfacehood x -> IntelligenceClaim x

def SelfClosedUniverseInterfaceAloneImpliesIntelligenceClaim : Prop :=
  forall u : InterfaceProfile,
    UniverseAsSelfInterface u -> u.closure -> UniverseIntelligenceClaim u

def BareInterfaceProfile : InterfaceProfile :=
  { interface := True
    record := False
    selfModel := False
    adaptiveSelection := False
    predictiveCorrection := False
    selfObservation := False
    closure := False
    distinctionsBecomeStates := False
    statesBecomeEvents := False
    eventsBecomeMemory := False
    memoryBecomesThinking := False }

def SelfInterfaceOnlyProfile : InterfaceProfile :=
  { interface := True
    record := False
    selfModel := False
    adaptiveSelection := False
    predictiveCorrection := False
    selfObservation := True
    closure := False
    distinctionsBecomeStates := True
    statesBecomeEvents := True
    eventsBecomeMemory := True
    memoryBecomesThinking := True }

def SelfClosedInterfaceOnlyProfile : InterfaceProfile :=
  { interface := True
    record := False
    selfModel := False
    adaptiveSelection := False
    predictiveCorrection := False
    selfObservation := True
    closure := True
    distinctionsBecomeStates := True
    statesBecomeEvents := True
    eventsBecomeMemory := True
    memoryBecomesThinking := True }

theorem intelligence_claim_gives_interface
    (x : InterfaceProfile) :
    IntelligenceClaim x -> Interfacehood x := by
  intro h
  exact h.interface

theorem universe_intelligence_claim_gives_self_interface
    (u : InterfaceProfile) :
    UniverseIntelligenceClaim u -> UniverseAsSelfInterface u := by
  intro h
  exact h.process

theorem universe_thinks_itself_claim_gives_intelligence
    (u : InterfaceProfile) :
    UniverseThinksItselfClaim u -> IntelligenceClaim u := by
  intro h
  exact h.intelligence

theorem universe_thinks_itself_claim_gives_interface
    (u : InterfaceProfile) :
    UniverseThinksItselfClaim u -> Interfacehood u := by
  intro h
  exact intelligence_claim_gives_interface u
    (universe_thinks_itself_claim_gives_intelligence u h)

theorem universe_full_criteria_give_self_closed_intelligent_interface
    (u : InterfaceProfile) :
    UniverseAsSelfInterface u ->
    IntelligenceClaim u ->
    u.closure ->
    SelfClosedIntelligentInterface u := by
  intro hProcess hIntelligence hClosure
  exact {
    process := hProcess
    intelligence := hIntelligence
    closure := hClosure
  }

theorem self_closed_intelligent_interface_gives_self_interface
    (u : InterfaceProfile) :
    SelfClosedIntelligentInterface u -> UniverseAsSelfInterface u := by
  intro h
  exact h.process

theorem self_closed_intelligent_interface_gives_intelligence
    (u : InterfaceProfile) :
    SelfClosedIntelligentInterface u -> IntelligenceClaim u := by
  intro h
  exact h.intelligence

theorem self_closed_intelligent_interface_gives_closure
    (u : InterfaceProfile) :
    SelfClosedIntelligentInterface u -> u.closure := by
  intro h
  exact h.closure

theorem self_closed_intelligent_interface_gives_interface
    (u : InterfaceProfile) :
    SelfClosedIntelligentInterface u -> Interfacehood u := by
  intro h
  exact intelligence_claim_gives_interface u
    (self_closed_intelligent_interface_gives_intelligence u h)

theorem self_closed_intelligent_interface_projects_all_criteria
    (u : InterfaceProfile) :
    SelfClosedIntelligentInterface u ->
      Interfacehood u /\
      u.selfObservation /\
      u.distinctionsBecomeStates /\
      u.statesBecomeEvents /\
      u.eventsBecomeMemory /\
      u.memoryBecomesThinking /\
      u.record /\
      u.selfModel /\
      u.adaptiveSelection /\
      u.predictiveCorrection /\
      u.closure := by
  intro h
  exact ⟨
    h.process.self_interface,
    h.process.self_observation,
    h.process.distinctions_to_states,
    h.process.states_to_events,
    h.process.events_to_memory,
    h.process.memory_to_thinking,
    h.intelligence.record,
    h.intelligence.self_model,
    h.intelligence.adaptive_selection,
    h.intelligence.predictive_correction,
    h.closure
  ⟩

theorem self_closed_intelligent_interface_iff_universe_thinks_itself
    (u : InterfaceProfile) :
    SelfClosedIntelligentInterface u <-> UniverseThinksItselfClaim u := by
  constructor
  · intro h
    exact h
  · intro h
    exact h

theorem bare_interface_is_interface :
    Interfacehood BareInterfaceProfile := by
  trivial

theorem bare_interface_not_intelligence :
    Not (IntelligenceClaim BareInterfaceProfile) := by
  intro h
  exact h.record

theorem interface_alone_does_not_imply_intelligence_witness :
    exists x : InterfaceProfile,
      Interfacehood x /\ Not (IntelligenceClaim x) := by
  exact ⟨
    BareInterfaceProfile,
    bare_interface_is_interface,
    bare_interface_not_intelligence
  ⟩

theorem not_every_interface_is_intelligence :
    Not InterfaceAloneImpliesIntelligenceClaim := by
  intro h
  exact bare_interface_not_intelligence
    (h BareInterfaceProfile bare_interface_is_interface)

theorem self_interface_only_is_universe_as_self_interface :
    UniverseAsSelfInterface SelfInterfaceOnlyProfile := by
  exact {
    self_interface := by trivial
    self_observation := by trivial
    distinctions_to_states := by trivial
    states_to_events := by trivial
    events_to_memory := by trivial
    memory_to_thinking := by trivial
  }

theorem self_interface_only_not_intelligence :
    Not (IntelligenceClaim SelfInterfaceOnlyProfile) := by
  intro h
  exact h.record

theorem self_interface_only_not_universe_intelligence :
    Not (UniverseIntelligenceClaim SelfInterfaceOnlyProfile) := by
  intro h
  exact self_interface_only_not_intelligence h.intelligence

theorem self_closed_interface_only_is_universe_as_self_interface :
    UniverseAsSelfInterface SelfClosedInterfaceOnlyProfile := by
  exact {
    self_interface := by trivial
    self_observation := by trivial
    distinctions_to_states := by trivial
    states_to_events := by trivial
    events_to_memory := by trivial
    memory_to_thinking := by trivial
  }

theorem self_closed_interface_only_has_closure :
    SelfClosedInterfaceOnlyProfile.closure := by
  trivial

theorem self_closed_interface_only_not_intelligence :
    Not (IntelligenceClaim SelfClosedInterfaceOnlyProfile) := by
  intro h
  exact h.record

theorem self_closed_interface_only_not_universe_intelligence :
    Not (UniverseIntelligenceClaim SelfClosedInterfaceOnlyProfile) := by
  intro h
  exact self_closed_interface_only_not_intelligence h.intelligence

theorem self_closed_interface_alone_does_not_imply_intelligence_witness :
    exists u : InterfaceProfile,
      UniverseAsSelfInterface u /\
      u.closure /\
      Not (UniverseIntelligenceClaim u) := by
  exact ⟨
    SelfClosedInterfaceOnlyProfile,
    self_closed_interface_only_is_universe_as_self_interface,
    self_closed_interface_only_has_closure,
    self_closed_interface_only_not_universe_intelligence
  ⟩

theorem not_every_self_closed_universe_interface_is_intelligent :
    Not SelfClosedUniverseInterfaceAloneImpliesIntelligenceClaim := by
  intro h
  exact self_closed_interface_only_not_universe_intelligence
    (h
      SelfClosedInterfaceOnlyProfile
      self_closed_interface_only_is_universe_as_self_interface
      self_closed_interface_only_has_closure)

theorem universe_self_interface_does_not_imply_intelligence_witness :
    exists u : InterfaceProfile,
      UniverseAsSelfInterface u /\ Not (UniverseIntelligenceClaim u) := by
  exact ⟨
    SelfInterfaceOnlyProfile,
    self_interface_only_is_universe_as_self_interface,
    self_interface_only_not_universe_intelligence
  ⟩

theorem not_every_universe_self_interface_is_universe_intelligence :
    Not (forall u : InterfaceProfile,
      UniverseAsSelfInterface u -> UniverseIntelligenceClaim u) := by
  intro h
  exact self_interface_only_not_universe_intelligence
    (h SelfInterfaceOnlyProfile self_interface_only_is_universe_as_self_interface)

def SelfObservationOnlySelfProcessProfile : InterfaceProfile :=
  { interface := True
    record := False
    selfModel := False
    adaptiveSelection := False
    predictiveCorrection := False
    selfObservation := True
    closure := False
    distinctionsBecomeStates := False
    statesBecomeEvents := False
    eventsBecomeMemory := False
    memoryBecomesThinking := False }

def SelfObservationOnlySelfProcessContext :
    UniverseSelfProcessContext SelfObservationOnlySelfProcessProfile :=
  { Proc := Unit
    inside_universe := fun _ => True
    self_interface := fun _ => True
    self_observation := fun _ => True
    distinctions_become_states := fun _ => False
    states_become_events := fun _ => False
    events_become_memory := fun _ => False
    memory_becomes_thinking := fun _ => False
    self_process_inside_gives_universe_as_self_interface := by
      intro h
      rcases h with
        ⟨_p, _hInside, _hSelfInterface, _hObservation,
          hDistinctions, _hStates, _hMemory, _hThinking⟩
      exact False.elim hDistinctions }

theorem self_observation_only_self_process_candidate_exists :
    exists p : SelfObservationOnlySelfProcessContext.Proc,
      SelfObservationOnlySelfProcessContext.inside_universe p /\
      SelfObservationOnlySelfProcessContext.self_observation p := by
  exact ⟨(), by trivial, by trivial⟩

theorem self_observation_only_context_not_self_process_inside :
    Not (SelfProcessWitnessInside SelfObservationOnlySelfProcessContext) := by
  intro h
  rcases h with
    ⟨_p, _hInside, _hSelfInterface, _hObservation,
      hDistinctions, _hStates, _hMemory, _hThinking⟩
  exact hDistinctions

theorem self_observation_candidate_alone_does_not_imply_self_process_inside :
    Not (forall {u : InterfaceProfile}
      (ctx : UniverseSelfProcessContext u),
      (exists p : ctx.Proc,
        ctx.inside_universe p /\ ctx.self_observation p) ->
        SelfProcessWitnessInside ctx) := by
  intro h
  exact self_observation_only_context_not_self_process_inside
    (h
      SelfObservationOnlySelfProcessContext
      self_observation_only_self_process_candidate_exists)

/-!
Physical bridge layer.

These structures formalize the five currently accepted bridge candidates. They
do not assert that the empirical universe satisfies the bridges. They only make
the bridge inputs explicit enough for Lean to check what follows from them.
-/

structure PhysicalRecordBridge (u : InterfaceProfile) : Prop where
  describable_structure : True
  stable_trace : True
  description_as_retrieval : True
  record : u.record

/-! Refined memory bridge: record is stable trace, not mere describability. -/

structure PhysicalMemoryContext (u : InterfaceProfile) where
  Obj : Type
  inside_universe : Obj -> Prop
  structured : Obj -> Prop
  stable : Obj -> Prop
  carries_information_about_prior_state : Obj -> Prop
  thermodynamic_trace : Obj -> Prop
  measurement_record : Obj -> Prop
  dna_heredity_record : Obj -> Prop
  cosmological_trace : Obj -> Prop
  symbolic_record : Obj -> Prop
  stable_trace_inside_gives_profile_record :
    (exists x : Obj,
      inside_universe x /\
      structured x /\
      stable x /\
      carries_information_about_prior_state x) -> u.record

def RecordObject {u : InterfaceProfile}
    (ctx : PhysicalMemoryContext u)
    (x : ctx.Obj) : Prop :=
  ctx.structured x /\
  ctx.stable x /\
  ctx.carries_information_about_prior_state x

def StableTraceInside {u : InterfaceProfile}
    (ctx : PhysicalMemoryContext u) : Prop :=
  exists x : ctx.Obj, ctx.inside_universe x /\ RecordObject ctx x

structure LowLevelMemoryTrace {u : InterfaceProfile}
    (ctx : PhysicalMemoryContext u) where
  carrier : ctx.Obj
  inside : ctx.inside_universe carrier
  structured : ctx.structured carrier
  stable : ctx.stable carrier
  prior_information : ctx.carries_information_about_prior_state carrier

def ThermodynamicTraceWitness {u : InterfaceProfile}
    (ctx : PhysicalMemoryContext u) : Prop :=
  exists x : ctx.Obj, ctx.inside_universe x /\ ctx.thermodynamic_trace x /\ RecordObject ctx x

def MeasurementRecordWitness {u : InterfaceProfile}
    (ctx : PhysicalMemoryContext u) : Prop :=
  exists x : ctx.Obj, ctx.inside_universe x /\ ctx.measurement_record x /\ RecordObject ctx x

def DNAHeredityRecordWitness {u : InterfaceProfile}
    (ctx : PhysicalMemoryContext u) : Prop :=
  exists x : ctx.Obj, ctx.inside_universe x /\ ctx.dna_heredity_record x /\ RecordObject ctx x

def CosmologicalTraceWitness {u : InterfaceProfile}
    (ctx : PhysicalMemoryContext u) : Prop :=
  exists x : ctx.Obj, ctx.inside_universe x /\ ctx.cosmological_trace x /\ RecordObject ctx x

def SymbolicRecordWitness {u : InterfaceProfile}
    (ctx : PhysicalMemoryContext u) : Prop :=
  exists x : ctx.Obj, ctx.inside_universe x /\ ctx.symbolic_record x /\ RecordObject ctx x

theorem record_object_unfolds_to_stable_information_trace
    {u : InterfaceProfile}
    (ctx : PhysicalMemoryContext u)
    (x : ctx.Obj) :
    RecordObject ctx x <->
      ctx.structured x /\
      ctx.stable x /\
      ctx.carries_information_about_prior_state x := by
  rfl

theorem low_level_memory_trace_gives_stable_trace_inside
    {u : InterfaceProfile}
    {ctx : PhysicalMemoryContext u} :
    LowLevelMemoryTrace ctx -> StableTraceInside ctx := by
  intro h
  exact ⟨h.carrier, h.inside, h.structured, h.stable, h.prior_information⟩

theorem thermodynamic_trace_witness_gives_stable_trace_inside
    {u : InterfaceProfile}
    {ctx : PhysicalMemoryContext u} :
    ThermodynamicTraceWitness ctx -> StableTraceInside ctx := by
  intro h
  rcases h with ⟨x, hInside, _hClass, hRecord⟩
  exact ⟨x, hInside, hRecord⟩

theorem measurement_record_witness_gives_stable_trace_inside
    {u : InterfaceProfile}
    {ctx : PhysicalMemoryContext u} :
    MeasurementRecordWitness ctx -> StableTraceInside ctx := by
  intro h
  rcases h with ⟨x, hInside, _hClass, hRecord⟩
  exact ⟨x, hInside, hRecord⟩

theorem dna_heredity_record_witness_gives_stable_trace_inside
    {u : InterfaceProfile}
    {ctx : PhysicalMemoryContext u} :
    DNAHeredityRecordWitness ctx -> StableTraceInside ctx := by
  intro h
  rcases h with ⟨x, hInside, _hClass, hRecord⟩
  exact ⟨x, hInside, hRecord⟩

theorem cosmological_trace_witness_gives_stable_trace_inside
    {u : InterfaceProfile}
    {ctx : PhysicalMemoryContext u} :
    CosmologicalTraceWitness ctx -> StableTraceInside ctx := by
  intro h
  rcases h with ⟨x, hInside, _hClass, hRecord⟩
  exact ⟨x, hInside, hRecord⟩

theorem symbolic_record_witness_gives_stable_trace_inside
    {u : InterfaceProfile}
    {ctx : PhysicalMemoryContext u} :
    SymbolicRecordWitness ctx -> StableTraceInside ctx := by
  intro h
  rcases h with ⟨x, hInside, _hClass, hRecord⟩
  exact ⟨x, hInside, hRecord⟩

theorem stable_trace_inside_gives_physical_record
    {u : InterfaceProfile}
    (ctx : PhysicalMemoryContext u) :
    StableTraceInside ctx -> u.record := by
  intro h
  rcases h with ⟨x, hInside, hStructure, hStable, hInfo⟩
  exact ctx.stable_trace_inside_gives_profile_record
    ⟨x, hInside, hStructure, hStable, hInfo⟩

theorem stable_trace_inside_gives_physical_record_bridge
    {u : InterfaceProfile}
    (ctx : PhysicalMemoryContext u) :
    StableTraceInside ctx -> PhysicalRecordBridge u := by
  intro h
  exact {
    describable_structure := by trivial
    stable_trace := by trivial
    description_as_retrieval := by trivial
    record := stable_trace_inside_gives_physical_record ctx h
  }

theorem low_level_memory_trace_gives_physical_record_bridge
    {u : InterfaceProfile}
    {ctx : PhysicalMemoryContext u} :
    LowLevelMemoryTrace ctx -> PhysicalRecordBridge u := by
  intro h
  exact stable_trace_inside_gives_physical_record_bridge
    ctx
    (low_level_memory_trace_gives_stable_trace_inside h)

/-!
Entropy/recoverability branch.

A stable trace may still exist while becoming less accessible to a local
interface. This branch formalizes forgetting as recoverability loss rather than
absolute trace annihilation.
-/

structure PhysicalRecoverabilityContext (u : InterfaceProfile) where
  memory_ctx : PhysicalMemoryContext u
  interface_accessible : memory_ctx.Obj -> Prop
  distributed : memory_ctx.Obj -> Prop
  recovery_cost_growth : memory_ctx.Obj -> Prop
  recovery_practically_blocked : memory_ctx.Obj -> Prop

def InterfaceAccessibleTraceInside {u : InterfaceProfile}
    (ctx : PhysicalRecoverabilityContext u) : Prop :=
  exists x : ctx.memory_ctx.Obj,
    ctx.memory_ctx.inside_universe x /\
    RecordObject ctx.memory_ctx x /\
    ctx.interface_accessible x

def RecoverableTraceInside {u : InterfaceProfile}
    (ctx : PhysicalRecoverabilityContext u) : Prop :=
  InterfaceAccessibleTraceInside ctx

def DistributedTraceInside {u : InterfaceProfile}
    (ctx : PhysicalRecoverabilityContext u) : Prop :=
  exists x : ctx.memory_ctx.Obj,
    ctx.memory_ctx.inside_universe x /\
    RecordObject ctx.memory_ctx x /\
    ctx.distributed x

def RecoverabilityLossInside {u : InterfaceProfile}
    (ctx : PhysicalRecoverabilityContext u) : Prop :=
  exists x : ctx.memory_ctx.Obj,
    ctx.memory_ctx.inside_universe x /\
    RecordObject ctx.memory_ctx x /\
    ctx.recovery_practically_blocked x

def InterfaceForgettingInside {u : InterfaceProfile}
    (ctx : PhysicalRecoverabilityContext u) : Prop :=
  RecoverabilityLossInside ctx

def EntropyLikeDispersionInside {u : InterfaceProfile}
    (ctx : PhysicalRecoverabilityContext u) : Prop :=
  exists x : ctx.memory_ctx.Obj,
    ctx.memory_ctx.inside_universe x /\
    RecordObject ctx.memory_ctx x /\
    ctx.distributed x /\
    ctx.recovery_cost_growth x

def SecondLawReadableAsRecoverabilityLoss
    (u : InterfaceProfile) : Prop :=
  exists ctx : PhysicalRecoverabilityContext u,
    EntropyLikeDispersionInside ctx /\ RecoverabilityLossInside ctx

structure LowLevelRecoverabilityTrace {u : InterfaceProfile}
    (ctx : PhysicalRecoverabilityContext u) where
  carrier : ctx.memory_ctx.Obj
  inside : ctx.memory_ctx.inside_universe carrier
  structured : ctx.memory_ctx.structured carrier
  stable : ctx.memory_ctx.stable carrier
  prior_information :
    ctx.memory_ctx.carries_information_about_prior_state carrier
  interface_accessible : ctx.interface_accessible carrier
  distributed : ctx.distributed carrier
  recovery_cost_growth : ctx.recovery_cost_growth carrier
  recovery_practically_blocked :
    ctx.recovery_practically_blocked carrier

theorem low_level_recoverability_trace_gives_recoverable_trace_inside
    {u : InterfaceProfile}
    {ctx : PhysicalRecoverabilityContext u} :
    LowLevelRecoverabilityTrace ctx -> RecoverableTraceInside ctx := by
  intro h
  exact
    ⟨h.carrier, h.inside,
      ⟨h.structured, h.stable, h.prior_information⟩,
      h.interface_accessible⟩

theorem recoverable_trace_inside_gives_stable_trace_inside
    {u : InterfaceProfile}
    (ctx : PhysicalRecoverabilityContext u) :
    RecoverableTraceInside ctx -> StableTraceInside ctx.memory_ctx := by
  intro h
  rcases h with ⟨x, hInside, hRecord, _hAccessible⟩
  exact ⟨x, hInside, hRecord⟩

theorem low_level_recoverability_trace_gives_distributed_trace_inside
    {u : InterfaceProfile}
    {ctx : PhysicalRecoverabilityContext u} :
    LowLevelRecoverabilityTrace ctx -> DistributedTraceInside ctx := by
  intro h
  exact
    ⟨h.carrier, h.inside,
      ⟨h.structured, h.stable, h.prior_information⟩,
      h.distributed⟩

theorem low_level_recoverability_trace_gives_entropy_like_dispersion_inside
    {u : InterfaceProfile}
    {ctx : PhysicalRecoverabilityContext u} :
    LowLevelRecoverabilityTrace ctx -> EntropyLikeDispersionInside ctx := by
  intro h
  exact
    ⟨h.carrier, h.inside,
      ⟨h.structured, h.stable, h.prior_information⟩,
      h.distributed, h.recovery_cost_growth⟩

theorem low_level_recoverability_trace_gives_interface_forgetting_inside
    {u : InterfaceProfile}
    {ctx : PhysicalRecoverabilityContext u} :
    LowLevelRecoverabilityTrace ctx -> InterfaceForgettingInside ctx := by
  intro h
  exact
    ⟨h.carrier, h.inside,
      ⟨h.structured, h.stable, h.prior_information⟩,
      h.recovery_practically_blocked⟩

theorem interface_forgetting_means_recoverability_loss
    {u : InterfaceProfile}
    (ctx : PhysicalRecoverabilityContext u) :
    InterfaceForgettingInside ctx -> RecoverabilityLossInside ctx := by
  intro h
  exact h

structure PhysicalSelfModelBridge (u : InterfaceProfile) : Prop where
  modeling_subsystem_inside : True
  models_universe_or_region : True
  organized_model_system : True
  self_model : u.selfModel

/-!
Refined self-model bridge.

A model merely located inside the universe is not yet a self-model bridge. The
criterion requires an internal modeling subsystem, an organized model system, a
model of the universe or a universe-region, and an internal reference to the
modeled domain.
-/

structure PhysicalSelfModelContext (u : InterfaceProfile) where
  Obj : Type
  inside_universe : Obj -> Prop
  modeling_subsystem : Obj -> Prop
  organized_model_system : Obj -> Prop
  models_universe_or_region : Obj -> Prop
  internal_reference_to_modeled_domain : Obj -> Prop
  mathematical_model : Obj -> Prop
  symbolic_model : Obj -> Prop
  scientific_model : Obj -> Prop
  observer_world_model : Obj -> Prop
  computational_simulation_model : Obj -> Prop
  self_model_inside_gives_profile_self_model :
    (exists x : Obj,
      inside_universe x /\
      modeling_subsystem x /\
      organized_model_system x /\
      models_universe_or_region x /\
      internal_reference_to_modeled_domain x) -> u.selfModel

def SelfModelObject {u : InterfaceProfile}
    (ctx : PhysicalSelfModelContext u)
    (x : ctx.Obj) : Prop :=
  ctx.modeling_subsystem x /\
  ctx.organized_model_system x /\
  ctx.models_universe_or_region x /\
  ctx.internal_reference_to_modeled_domain x

def SelfModelWitnessInside {u : InterfaceProfile}
    (ctx : PhysicalSelfModelContext u) : Prop :=
  exists x : ctx.Obj, ctx.inside_universe x /\ SelfModelObject ctx x

structure LowLevelSelfModelTrace {u : InterfaceProfile}
    (ctx : PhysicalSelfModelContext u) where
  carrier : ctx.Obj
  inside : ctx.inside_universe carrier
  modeling_subsystem : ctx.modeling_subsystem carrier
  organized_model_system : ctx.organized_model_system carrier
  models_universe_or_region : ctx.models_universe_or_region carrier
  internal_reference_to_modeled_domain :
    ctx.internal_reference_to_modeled_domain carrier

def MathematicalModelWitness {u : InterfaceProfile}
    (ctx : PhysicalSelfModelContext u) : Prop :=
  exists x : ctx.Obj,
    ctx.inside_universe x /\
    ctx.mathematical_model x /\
    SelfModelObject ctx x

def SymbolicModelWitness {u : InterfaceProfile}
    (ctx : PhysicalSelfModelContext u) : Prop :=
  exists x : ctx.Obj,
    ctx.inside_universe x /\
    ctx.symbolic_model x /\
    SelfModelObject ctx x

def ScientificModelWitness {u : InterfaceProfile}
    (ctx : PhysicalSelfModelContext u) : Prop :=
  exists x : ctx.Obj,
    ctx.inside_universe x /\
    ctx.scientific_model x /\
    SelfModelObject ctx x

def ObserverWorldModelWitness {u : InterfaceProfile}
    (ctx : PhysicalSelfModelContext u) : Prop :=
  exists x : ctx.Obj,
    ctx.inside_universe x /\
    ctx.observer_world_model x /\
    SelfModelObject ctx x

def ComputationalSimulationModelWitness {u : InterfaceProfile}
    (ctx : PhysicalSelfModelContext u) : Prop :=
  exists x : ctx.Obj,
    ctx.inside_universe x /\
    ctx.computational_simulation_model x /\
    SelfModelObject ctx x

theorem self_model_object_unfolds_to_internal_organized_model
    {u : InterfaceProfile}
    (ctx : PhysicalSelfModelContext u)
    (x : ctx.Obj) :
    SelfModelObject ctx x <->
      ctx.modeling_subsystem x /\
      ctx.organized_model_system x /\
      ctx.models_universe_or_region x /\
      ctx.internal_reference_to_modeled_domain x := by
  rfl

theorem low_level_self_model_trace_gives_self_model_inside
    {u : InterfaceProfile}
    {ctx : PhysicalSelfModelContext u} :
    LowLevelSelfModelTrace ctx -> SelfModelWitnessInside ctx := by
  intro h
  exact
    ⟨h.carrier, h.inside, h.modeling_subsystem,
      h.organized_model_system, h.models_universe_or_region,
      h.internal_reference_to_modeled_domain⟩

theorem mathematical_model_witness_gives_self_model_inside
    {u : InterfaceProfile}
    {ctx : PhysicalSelfModelContext u} :
    MathematicalModelWitness ctx -> SelfModelWitnessInside ctx := by
  intro h
  rcases h with ⟨x, hInside, _hClass, hModel⟩
  exact ⟨x, hInside, hModel⟩

theorem symbolic_model_witness_gives_self_model_inside
    {u : InterfaceProfile}
    {ctx : PhysicalSelfModelContext u} :
    SymbolicModelWitness ctx -> SelfModelWitnessInside ctx := by
  intro h
  rcases h with ⟨x, hInside, _hClass, hModel⟩
  exact ⟨x, hInside, hModel⟩

theorem scientific_model_witness_gives_self_model_inside
    {u : InterfaceProfile}
    {ctx : PhysicalSelfModelContext u} :
    ScientificModelWitness ctx -> SelfModelWitnessInside ctx := by
  intro h
  rcases h with ⟨x, hInside, _hClass, hModel⟩
  exact ⟨x, hInside, hModel⟩

theorem observer_world_model_witness_gives_self_model_inside
    {u : InterfaceProfile}
    {ctx : PhysicalSelfModelContext u} :
    ObserverWorldModelWitness ctx -> SelfModelWitnessInside ctx := by
  intro h
  rcases h with ⟨x, hInside, _hClass, hModel⟩
  exact ⟨x, hInside, hModel⟩

theorem computational_simulation_model_witness_gives_self_model_inside
    {u : InterfaceProfile}
    {ctx : PhysicalSelfModelContext u} :
    ComputationalSimulationModelWitness ctx -> SelfModelWitnessInside ctx := by
  intro h
  rcases h with ⟨x, hInside, _hClass, hModel⟩
  exact ⟨x, hInside, hModel⟩

theorem self_model_inside_gives_profile_self_model
    {u : InterfaceProfile}
    (ctx : PhysicalSelfModelContext u) :
    SelfModelWitnessInside ctx -> u.selfModel := by
  intro h
  rcases h with ⟨x, hInside, hSubsystem, hOrganized, hModels, hReference⟩
  exact ctx.self_model_inside_gives_profile_self_model
    ⟨x, hInside, hSubsystem, hOrganized, hModels, hReference⟩

theorem self_model_inside_gives_physical_self_model_bridge
    {u : InterfaceProfile}
    (ctx : PhysicalSelfModelContext u) :
    SelfModelWitnessInside ctx -> PhysicalSelfModelBridge u := by
  intro h
  exact {
    modeling_subsystem_inside := by trivial
    models_universe_or_region := by trivial
    organized_model_system := by trivial
    self_model := self_model_inside_gives_profile_self_model ctx h
  }

theorem low_level_self_model_trace_gives_physical_self_model_bridge
    {u : InterfaceProfile}
    {ctx : PhysicalSelfModelContext u} :
    LowLevelSelfModelTrace ctx -> PhysicalSelfModelBridge u := by
  intro h
  exact self_model_inside_gives_physical_self_model_bridge
    ctx
    (low_level_self_model_trace_gives_self_model_inside h)

structure PhysicalAdaptiveSelectionBridge (u : InterfaceProfile) : Prop where
  dynamics : True
  possible_transitions : True
  interface_admission_conditions : True
  compatibility_checking : True
  possible_refusal : True
  future_influencing_trace : True
  adaptive_selection : u.adaptiveSelection

/-!
Refined adaptive-selection bridge.

A realized transition alone is only dynamics. Adaptive selection requires
possible transitions, interface admission, compatibility checking, possible
refusal, and a trace that can influence future transitions.
-/

structure PhysicalAdaptiveSelectionContext (u : InterfaceProfile) where
  Proc : Type
  inside_universe : Proc -> Prop
  dynamics : Proc -> Prop
  possible_transitions : Proc -> Prop
  interface_admission_conditions : Proc -> Prop
  compatibility_checking : Proc -> Prop
  possible_refusal : Proc -> Prop
  future_influencing_trace : Proc -> Prop
  chemical_bond_selection : Proc -> Prop
  selective_exchange : Proc -> Prop
  biological_regulation_selection : Proc -> Prop
  market_admission_selection : Proc -> Prop
  protocol_compatibility_selection : Proc -> Prop
  adaptive_selection_inside_gives_profile_selection :
    (exists p : Proc,
      inside_universe p /\
      dynamics p /\
      possible_transitions p /\
      interface_admission_conditions p /\
      compatibility_checking p /\
      possible_refusal p /\
      future_influencing_trace p) -> u.adaptiveSelection

def AdaptiveSelectionEvent {u : InterfaceProfile}
    (ctx : PhysicalAdaptiveSelectionContext u)
    (p : ctx.Proc) : Prop :=
  ctx.dynamics p /\
  ctx.possible_transitions p /\
  ctx.interface_admission_conditions p /\
  ctx.compatibility_checking p /\
  ctx.possible_refusal p /\
  ctx.future_influencing_trace p

def AdaptiveSelectionWitnessInside {u : InterfaceProfile}
    (ctx : PhysicalAdaptiveSelectionContext u) : Prop :=
  exists p : ctx.Proc, ctx.inside_universe p /\ AdaptiveSelectionEvent ctx p

structure LowLevelAdaptiveSelectionTrace {u : InterfaceProfile}
    (ctx : PhysicalAdaptiveSelectionContext u) where
  process : ctx.Proc
  inside : ctx.inside_universe process
  dynamics : ctx.dynamics process
  possible_transitions : ctx.possible_transitions process
  interface_admission_conditions :
    ctx.interface_admission_conditions process
  compatibility_checking : ctx.compatibility_checking process
  possible_refusal : ctx.possible_refusal process
  future_influencing_trace : ctx.future_influencing_trace process

def ChemicalBondSelectionWitness {u : InterfaceProfile}
    (ctx : PhysicalAdaptiveSelectionContext u) : Prop :=
  exists p : ctx.Proc,
    ctx.inside_universe p /\
    ctx.chemical_bond_selection p /\
    AdaptiveSelectionEvent ctx p

def SelectiveExchangeWitness {u : InterfaceProfile}
    (ctx : PhysicalAdaptiveSelectionContext u) : Prop :=
  exists p : ctx.Proc,
    ctx.inside_universe p /\
    ctx.selective_exchange p /\
    AdaptiveSelectionEvent ctx p

def BiologicalRegulationSelectionWitness {u : InterfaceProfile}
    (ctx : PhysicalAdaptiveSelectionContext u) : Prop :=
  exists p : ctx.Proc,
    ctx.inside_universe p /\
    ctx.biological_regulation_selection p /\
    AdaptiveSelectionEvent ctx p

def MarketAdmissionSelectionWitness {u : InterfaceProfile}
    (ctx : PhysicalAdaptiveSelectionContext u) : Prop :=
  exists p : ctx.Proc,
    ctx.inside_universe p /\
    ctx.market_admission_selection p /\
    AdaptiveSelectionEvent ctx p

def ProtocolCompatibilitySelectionWitness {u : InterfaceProfile}
    (ctx : PhysicalAdaptiveSelectionContext u) : Prop :=
  exists p : ctx.Proc,
    ctx.inside_universe p /\
    ctx.protocol_compatibility_selection p /\
    AdaptiveSelectionEvent ctx p

theorem adaptive_selection_event_unfolds_to_filtered_choice_trace
    {u : InterfaceProfile}
    (ctx : PhysicalAdaptiveSelectionContext u)
    (p : ctx.Proc) :
    AdaptiveSelectionEvent ctx p <->
      ctx.dynamics p /\
      ctx.possible_transitions p /\
      ctx.interface_admission_conditions p /\
      ctx.compatibility_checking p /\
      ctx.possible_refusal p /\
      ctx.future_influencing_trace p := by
  rfl

theorem low_level_adaptive_selection_trace_gives_adaptive_selection_inside
    {u : InterfaceProfile}
    {ctx : PhysicalAdaptiveSelectionContext u} :
    LowLevelAdaptiveSelectionTrace ctx ->
      AdaptiveSelectionWitnessInside ctx := by
  intro h
  exact ⟨
    h.process,
    h.inside,
    h.dynamics,
    h.possible_transitions,
    h.interface_admission_conditions,
    h.compatibility_checking,
    h.possible_refusal,
    h.future_influencing_trace
  ⟩

theorem chemical_bond_selection_witness_gives_adaptive_selection_inside
    {u : InterfaceProfile}
    {ctx : PhysicalAdaptiveSelectionContext u} :
    ChemicalBondSelectionWitness ctx -> AdaptiveSelectionWitnessInside ctx := by
  intro h
  rcases h with ⟨p, hInside, _hClass, hSelection⟩
  exact ⟨p, hInside, hSelection⟩

theorem selective_exchange_witness_gives_adaptive_selection_inside
    {u : InterfaceProfile}
    {ctx : PhysicalAdaptiveSelectionContext u} :
    SelectiveExchangeWitness ctx -> AdaptiveSelectionWitnessInside ctx := by
  intro h
  rcases h with ⟨p, hInside, _hClass, hSelection⟩
  exact ⟨p, hInside, hSelection⟩

theorem biological_regulation_selection_witness_gives_adaptive_selection_inside
    {u : InterfaceProfile}
    {ctx : PhysicalAdaptiveSelectionContext u} :
    BiologicalRegulationSelectionWitness ctx -> AdaptiveSelectionWitnessInside ctx := by
  intro h
  rcases h with ⟨p, hInside, _hClass, hSelection⟩
  exact ⟨p, hInside, hSelection⟩

theorem market_admission_selection_witness_gives_adaptive_selection_inside
    {u : InterfaceProfile}
    {ctx : PhysicalAdaptiveSelectionContext u} :
    MarketAdmissionSelectionWitness ctx -> AdaptiveSelectionWitnessInside ctx := by
  intro h
  rcases h with ⟨p, hInside, _hClass, hSelection⟩
  exact ⟨p, hInside, hSelection⟩

theorem protocol_compatibility_selection_witness_gives_adaptive_selection_inside
    {u : InterfaceProfile}
    {ctx : PhysicalAdaptiveSelectionContext u} :
    ProtocolCompatibilitySelectionWitness ctx -> AdaptiveSelectionWitnessInside ctx := by
  intro h
  rcases h with ⟨p, hInside, _hClass, hSelection⟩
  exact ⟨p, hInside, hSelection⟩

theorem adaptive_selection_inside_gives_profile_selection
    {u : InterfaceProfile}
    (ctx : PhysicalAdaptiveSelectionContext u) :
    AdaptiveSelectionWitnessInside ctx -> u.adaptiveSelection := by
  intro h
  rcases h with
    ⟨p, hInside, hDynamics, hPossible, hAdmission, hCompat, hRefusal, hTrace⟩
  exact ctx.adaptive_selection_inside_gives_profile_selection
    ⟨p, hInside, hDynamics, hPossible, hAdmission, hCompat, hRefusal, hTrace⟩

theorem adaptive_selection_inside_gives_physical_adaptive_selection_bridge
    {u : InterfaceProfile}
    (ctx : PhysicalAdaptiveSelectionContext u) :
    AdaptiveSelectionWitnessInside ctx -> PhysicalAdaptiveSelectionBridge u := by
  intro h
  exact {
    dynamics := by trivial
    possible_transitions := by trivial
    interface_admission_conditions := by trivial
    compatibility_checking := by trivial
    possible_refusal := by trivial
    future_influencing_trace := by trivial
    adaptive_selection := adaptive_selection_inside_gives_profile_selection ctx h
  }

theorem low_level_adaptive_selection_trace_gives_physical_adaptive_selection_bridge
    {u : InterfaceProfile}
    {ctx : PhysicalAdaptiveSelectionContext u} :
    LowLevelAdaptiveSelectionTrace ctx ->
      PhysicalAdaptiveSelectionBridge u := by
  intro h
  exact adaptive_selection_inside_gives_physical_adaptive_selection_bridge
    ctx
    (low_level_adaptive_selection_trace_gives_adaptive_selection_inside h)

structure PhysicalPredictiveCorrectionBridge (u : InterfaceProfile) : Prop where
  trigger : True
  expected_transition_candidate : True
  interface_filters : True
  pass_or_reject_result : True
  result_trace : True
  future_update : True
  predictive_correction : u.predictiveCorrection

/-!
Refined predictive-correction bridge.

A trigger or expected candidate is not enough. The correction criterion requires
an expected candidate, a filter pass/reject outcome, a result trace, and a
future update.
-/

structure PhysicalPredictiveCorrectionContext (u : InterfaceProfile) where
  Proc : Type
  inside_universe : Proc -> Prop
  expected_candidate : Proc -> Prop
  filter_pass_or_reject : Proc -> Prop
  result_trace : Proc -> Prop
  future_update : Proc -> Prop
  measurement_correction : Proc -> Prop
  learning_update : Proc -> Prop
  biological_regulation : Proc -> Prop
  market_system_feedback : Proc -> Prop
  scientific_model_correction : Proc -> Prop
  predictive_correction_inside_gives_profile_correction :
    (exists p : Proc,
      inside_universe p /\
      expected_candidate p /\
      filter_pass_or_reject p /\
      result_trace p /\
      future_update p) -> u.predictiveCorrection

def PredictiveCorrectionEvent {u : InterfaceProfile}
    (ctx : PhysicalPredictiveCorrectionContext u)
    (p : ctx.Proc) : Prop :=
  ctx.expected_candidate p /\
  ctx.filter_pass_or_reject p /\
  ctx.result_trace p /\
  ctx.future_update p

def PredictiveCorrectionWitnessInside {u : InterfaceProfile}
    (ctx : PhysicalPredictiveCorrectionContext u) : Prop :=
  exists p : ctx.Proc, ctx.inside_universe p /\ PredictiveCorrectionEvent ctx p

structure LowLevelPredictiveCorrectionTrace {u : InterfaceProfile}
    (ctx : PhysicalPredictiveCorrectionContext u) where
  process : ctx.Proc
  inside : ctx.inside_universe process
  expected_candidate : ctx.expected_candidate process
  filter_pass_or_reject : ctx.filter_pass_or_reject process
  result_trace : ctx.result_trace process
  future_update : ctx.future_update process

def MeasurementCorrectionWitness {u : InterfaceProfile}
    (ctx : PhysicalPredictiveCorrectionContext u) : Prop :=
  exists p : ctx.Proc,
    ctx.inside_universe p /\
    ctx.measurement_correction p /\
    PredictiveCorrectionEvent ctx p

def LearningUpdateWitness {u : InterfaceProfile}
    (ctx : PhysicalPredictiveCorrectionContext u) : Prop :=
  exists p : ctx.Proc,
    ctx.inside_universe p /\
    ctx.learning_update p /\
    PredictiveCorrectionEvent ctx p

def BiologicalRegulationWitness {u : InterfaceProfile}
    (ctx : PhysicalPredictiveCorrectionContext u) : Prop :=
  exists p : ctx.Proc,
    ctx.inside_universe p /\
    ctx.biological_regulation p /\
    PredictiveCorrectionEvent ctx p

def MarketSystemFeedbackWitness {u : InterfaceProfile}
    (ctx : PhysicalPredictiveCorrectionContext u) : Prop :=
  exists p : ctx.Proc,
    ctx.inside_universe p /\
    ctx.market_system_feedback p /\
    PredictiveCorrectionEvent ctx p

def ScientificModelCorrectionWitness {u : InterfaceProfile}
    (ctx : PhysicalPredictiveCorrectionContext u) : Prop :=
  exists p : ctx.Proc,
    ctx.inside_universe p /\
    ctx.scientific_model_correction p /\
    PredictiveCorrectionEvent ctx p

theorem predictive_correction_event_unfolds_to_expected_filtered_trace_update
    {u : InterfaceProfile}
    (ctx : PhysicalPredictiveCorrectionContext u)
    (p : ctx.Proc) :
    PredictiveCorrectionEvent ctx p <->
      ctx.expected_candidate p /\
      ctx.filter_pass_or_reject p /\
      ctx.result_trace p /\
      ctx.future_update p := by
  rfl

theorem low_level_predictive_correction_trace_gives_predictive_correction_inside
    {u : InterfaceProfile}
    {ctx : PhysicalPredictiveCorrectionContext u} :
    LowLevelPredictiveCorrectionTrace ctx ->
      PredictiveCorrectionWitnessInside ctx := by
  intro h
  exact
    ⟨h.process, h.inside, h.expected_candidate,
      h.filter_pass_or_reject, h.result_trace, h.future_update⟩

theorem measurement_correction_witness_gives_predictive_correction_inside
    {u : InterfaceProfile}
    {ctx : PhysicalPredictiveCorrectionContext u} :
    MeasurementCorrectionWitness ctx -> PredictiveCorrectionWitnessInside ctx := by
  intro h
  rcases h with ⟨p, hInside, _hClass, hCorrection⟩
  exact ⟨p, hInside, hCorrection⟩

theorem learning_update_witness_gives_predictive_correction_inside
    {u : InterfaceProfile}
    {ctx : PhysicalPredictiveCorrectionContext u} :
    LearningUpdateWitness ctx -> PredictiveCorrectionWitnessInside ctx := by
  intro h
  rcases h with ⟨p, hInside, _hClass, hCorrection⟩
  exact ⟨p, hInside, hCorrection⟩

theorem biological_regulation_witness_gives_predictive_correction_inside
    {u : InterfaceProfile}
    {ctx : PhysicalPredictiveCorrectionContext u} :
    BiologicalRegulationWitness ctx -> PredictiveCorrectionWitnessInside ctx := by
  intro h
  rcases h with ⟨p, hInside, _hClass, hCorrection⟩
  exact ⟨p, hInside, hCorrection⟩

theorem market_system_feedback_witness_gives_predictive_correction_inside
    {u : InterfaceProfile}
    {ctx : PhysicalPredictiveCorrectionContext u} :
    MarketSystemFeedbackWitness ctx -> PredictiveCorrectionWitnessInside ctx := by
  intro h
  rcases h with ⟨p, hInside, _hClass, hCorrection⟩
  exact ⟨p, hInside, hCorrection⟩

theorem scientific_model_correction_witness_gives_predictive_correction_inside
    {u : InterfaceProfile}
    {ctx : PhysicalPredictiveCorrectionContext u} :
    ScientificModelCorrectionWitness ctx -> PredictiveCorrectionWitnessInside ctx := by
  intro h
  rcases h with ⟨p, hInside, _hClass, hCorrection⟩
  exact ⟨p, hInside, hCorrection⟩

theorem predictive_correction_inside_gives_profile_correction
    {u : InterfaceProfile}
    (ctx : PhysicalPredictiveCorrectionContext u) :
    PredictiveCorrectionWitnessInside ctx -> u.predictiveCorrection := by
  intro h
  rcases h with ⟨p, hInside, hExpected, hFilter, hTrace, hUpdate⟩
  exact ctx.predictive_correction_inside_gives_profile_correction
    ⟨p, hInside, hExpected, hFilter, hTrace, hUpdate⟩

theorem predictive_correction_inside_gives_physical_predictive_correction_bridge
    {u : InterfaceProfile}
    (ctx : PhysicalPredictiveCorrectionContext u) :
    PredictiveCorrectionWitnessInside ctx -> PhysicalPredictiveCorrectionBridge u := by
  intro h
  exact {
    trigger := by trivial
    expected_transition_candidate := by trivial
    interface_filters := by trivial
    pass_or_reject_result := by trivial
    result_trace := by trivial
    future_update := by trivial
    predictive_correction := predictive_correction_inside_gives_profile_correction ctx h
  }

theorem low_level_predictive_correction_trace_gives_physical_predictive_correction_bridge
    {u : InterfaceProfile}
    {ctx : PhysicalPredictiveCorrectionContext u} :
    LowLevelPredictiveCorrectionTrace ctx ->
      PhysicalPredictiveCorrectionBridge u := by
  intro h
  exact predictive_correction_inside_gives_physical_predictive_correction_bridge
    ctx
    (low_level_predictive_correction_trace_gives_predictive_correction_inside h)

/-!
Predictive accessibility under forgetting.

This branch does not claim that forgetting annihilates prediction. It only adds
a one-way surface: recoverability loss weakens predictive accessibility.
-/

structure PhysicalPredictiveAccessibilityContext (u : InterfaceProfile) where
  recoverability_ctx : PhysicalRecoverabilityContext u
  predictive_ctx : PhysicalPredictiveCorrectionContext u
  full_predictive_accessibility : predictive_ctx.Proc -> Prop
  weakened_predictive_accessibility : predictive_ctx.Proc -> Prop
  forgetting_and_predictive_seed_give_weakened_accessibility :
    (InterfaceForgettingInside recoverability_ctx /\
      exists p : predictive_ctx.Proc,
        predictive_ctx.inside_universe p /\
        predictive_ctx.expected_candidate p /\
        predictive_ctx.result_trace p /\
        full_predictive_accessibility p) ->
      exists p : predictive_ctx.Proc,
        predictive_ctx.inside_universe p /\
        predictive_ctx.expected_candidate p /\
        predictive_ctx.result_trace p /\
        weakened_predictive_accessibility p

def FullPredictiveAccessibilityInside {u : InterfaceProfile}
    (ctx : PhysicalPredictiveAccessibilityContext u) : Prop :=
  exists p : ctx.predictive_ctx.Proc,
    ctx.predictive_ctx.inside_universe p /\
    ctx.predictive_ctx.expected_candidate p /\
    ctx.predictive_ctx.result_trace p /\
    ctx.full_predictive_accessibility p

def WeakenedPredictiveAccessibilityInside {u : InterfaceProfile}
    (ctx : PhysicalPredictiveAccessibilityContext u) : Prop :=
  exists p : ctx.predictive_ctx.Proc,
    ctx.predictive_ctx.inside_universe p /\
    ctx.predictive_ctx.expected_candidate p /\
    ctx.predictive_ctx.result_trace p /\
    ctx.weakened_predictive_accessibility p

theorem full_predictive_accessibility_inside_gives_predictive_seed
    {u : InterfaceProfile}
    (ctx : PhysicalPredictiveAccessibilityContext u) :
    FullPredictiveAccessibilityInside ctx ->
      exists p : ctx.predictive_ctx.Proc,
        ctx.predictive_ctx.inside_universe p /\
        ctx.predictive_ctx.expected_candidate p /\
        ctx.predictive_ctx.result_trace p := by
  intro h
  rcases h with ⟨p, hInside, hExpected, hTrace, _hFull⟩
  exact ⟨p, hInside, hExpected, hTrace⟩

theorem interface_forgetting_and_full_predictive_accessibility_give_weakened_predictive_accessibility
    {u : InterfaceProfile}
    (ctx : PhysicalPredictiveAccessibilityContext u) :
    InterfaceForgettingInside ctx.recoverability_ctx ->
      FullPredictiveAccessibilityInside ctx ->
        WeakenedPredictiveAccessibilityInside ctx := by
  intro hForgetting hFull
  exact ctx.forgetting_and_predictive_seed_give_weakened_accessibility
    ⟨hForgetting, hFull⟩

structure PhysicalPredictiveAccessibilityGradientContext (u : InterfaceProfile) where
  recoverability_ctx : PhysicalRecoverabilityContext u
  predictive_ctx : PhysicalPredictiveCorrectionContext u
  predictive_accessibility_level : predictive_ctx.Proc -> Nat
  full_accessibility_level : Nat
  degraded_accessibility_floor : Nat
  degraded_accessibility_ceiling : Nat
  positive_degraded_floor : 0 < degraded_accessibility_floor
  degraded_floor_le_ceiling :
    degraded_accessibility_floor <= degraded_accessibility_ceiling
  degraded_ceiling_lt_full :
    degraded_accessibility_ceiling < full_accessibility_level
  forgetting_and_full_seed_give_degraded_gradient :
    (InterfaceForgettingInside recoverability_ctx /\
      exists p : predictive_ctx.Proc,
        predictive_ctx.inside_universe p /\
        predictive_ctx.expected_candidate p /\
        predictive_ctx.result_trace p /\
        predictive_accessibility_level p = full_accessibility_level) ->
      exists p : predictive_ctx.Proc,
        predictive_ctx.inside_universe p /\
        predictive_ctx.expected_candidate p /\
        predictive_ctx.result_trace p /\
        degraded_accessibility_floor <= predictive_accessibility_level p /\
        predictive_accessibility_level p <= degraded_accessibility_ceiling

def PredictiveAccessibilityAtLevelInside {u : InterfaceProfile}
    (ctx : PhysicalPredictiveAccessibilityGradientContext u)
    (n : Nat) : Prop :=
  exists p : ctx.predictive_ctx.Proc,
    ctx.predictive_ctx.inside_universe p /\
    ctx.predictive_ctx.expected_candidate p /\
    ctx.predictive_ctx.result_trace p /\
    ctx.predictive_accessibility_level p = n

def PositivePredictiveAccessibilityInside {u : InterfaceProfile}
    (ctx : PhysicalPredictiveAccessibilityGradientContext u) : Prop :=
  exists p : ctx.predictive_ctx.Proc,
    ctx.predictive_ctx.inside_universe p /\
    ctx.predictive_ctx.expected_candidate p /\
    ctx.predictive_ctx.result_trace p /\
    0 < ctx.predictive_accessibility_level p

def BelowFullPredictiveAccessibilityInside {u : InterfaceProfile}
    (ctx : PhysicalPredictiveAccessibilityGradientContext u) : Prop :=
  exists p : ctx.predictive_ctx.Proc,
    ctx.predictive_ctx.inside_universe p /\
    ctx.predictive_ctx.expected_candidate p /\
    ctx.predictive_ctx.result_trace p /\
    ctx.predictive_accessibility_level p < ctx.full_accessibility_level

def FullPredictiveAccessibilityGradientInside {u : InterfaceProfile}
    (ctx : PhysicalPredictiveAccessibilityGradientContext u) : Prop :=
  PredictiveAccessibilityAtLevelInside ctx ctx.full_accessibility_level

def DegradedPredictiveAccessibilityGradientInside {u : InterfaceProfile}
    (ctx : PhysicalPredictiveAccessibilityGradientContext u) : Prop :=
  exists p : ctx.predictive_ctx.Proc,
    ctx.predictive_ctx.inside_universe p /\
    ctx.predictive_ctx.expected_candidate p /\
    ctx.predictive_ctx.result_trace p /\
    ctx.degraded_accessibility_floor <= ctx.predictive_accessibility_level p /\
    ctx.predictive_accessibility_level p <= ctx.degraded_accessibility_ceiling

theorem full_predictive_accessibility_gradient_inside_gives_predictive_seed
    {u : InterfaceProfile}
    (ctx : PhysicalPredictiveAccessibilityGradientContext u) :
    FullPredictiveAccessibilityGradientInside ctx ->
      exists p : ctx.predictive_ctx.Proc,
        ctx.predictive_ctx.inside_universe p /\
        ctx.predictive_ctx.expected_candidate p /\
        ctx.predictive_ctx.result_trace p := by
  intro h
  rcases h with ⟨p, hInside, hExpected, hTrace, _hLevel⟩
  exact ⟨p, hInside, hExpected, hTrace⟩

theorem interface_forgetting_and_full_predictive_accessibility_gradient_give_degraded_predictive_accessibility
    {u : InterfaceProfile}
    (ctx : PhysicalPredictiveAccessibilityGradientContext u) :
    InterfaceForgettingInside ctx.recoverability_ctx ->
      FullPredictiveAccessibilityGradientInside ctx ->
        DegradedPredictiveAccessibilityGradientInside ctx := by
  intro hForgetting hFull
  exact ctx.forgetting_and_full_seed_give_degraded_gradient ⟨hForgetting, hFull⟩

theorem degraded_predictive_accessibility_gradient_inside_is_below_full
    {u : InterfaceProfile}
    (ctx : PhysicalPredictiveAccessibilityGradientContext u) :
    DegradedPredictiveAccessibilityGradientInside ctx ->
      BelowFullPredictiveAccessibilityInside ctx := by
  intro h
  rcases h with ⟨p, hInside, hExpected, hTrace, hFloor, hCeiling⟩
  exact
    ⟨p, hInside, hExpected, hTrace,
      Nat.lt_of_le_of_lt hCeiling ctx.degraded_ceiling_lt_full⟩

theorem degraded_predictive_accessibility_gradient_inside_is_positive
    {u : InterfaceProfile}
    (ctx : PhysicalPredictiveAccessibilityGradientContext u) :
    DegradedPredictiveAccessibilityGradientInside ctx ->
      PositivePredictiveAccessibilityInside ctx := by
  intro h
  rcases h with ⟨p, hInside, hExpected, hTrace, hFloor, _hCeiling⟩
  exact
    ⟨p, hInside, hExpected, hTrace,
      Nat.lt_of_lt_of_le ctx.positive_degraded_floor hFloor⟩

def predictive_accessibility_gradient_to_binary_context
    {u : InterfaceProfile}
    (ctx : PhysicalPredictiveAccessibilityGradientContext u) :
    PhysicalPredictiveAccessibilityContext u :=
  { recoverability_ctx := ctx.recoverability_ctx
    predictive_ctx := ctx.predictive_ctx
    full_predictive_accessibility :=
      fun p => ctx.predictive_accessibility_level p = ctx.full_accessibility_level
    weakened_predictive_accessibility :=
      fun p => ctx.predictive_accessibility_level p < ctx.full_accessibility_level
    forgetting_and_predictive_seed_give_weakened_accessibility := by
      intro h
      exact
        degraded_predictive_accessibility_gradient_inside_is_below_full ctx
          (ctx.forgetting_and_full_seed_give_degraded_gradient h) }

theorem full_predictive_accessibility_gradient_projects_to_binary_full
    {u : InterfaceProfile}
    (ctx : PhysicalPredictiveAccessibilityGradientContext u) :
    FullPredictiveAccessibilityGradientInside ctx ->
      FullPredictiveAccessibilityInside
        (predictive_accessibility_gradient_to_binary_context ctx) := by
  intro h
  exact h

theorem degraded_predictive_accessibility_gradient_projects_to_binary_weakened
    {u : InterfaceProfile}
    (ctx : PhysicalPredictiveAccessibilityGradientContext u) :
    DegradedPredictiveAccessibilityGradientInside ctx ->
      WeakenedPredictiveAccessibilityInside
        (predictive_accessibility_gradient_to_binary_context ctx) := by
  intro h
  exact degraded_predictive_accessibility_gradient_inside_is_below_full ctx h

theorem interface_forgetting_and_full_predictive_accessibility_gradient_project_to_binary_weakened
    {u : InterfaceProfile}
    (ctx : PhysicalPredictiveAccessibilityGradientContext u) :
    InterfaceForgettingInside ctx.recoverability_ctx ->
      FullPredictiveAccessibilityGradientInside ctx ->
        WeakenedPredictiveAccessibilityInside
          (predictive_accessibility_gradient_to_binary_context ctx) := by
  intro hForgetting hFull
  exact
    degraded_predictive_accessibility_gradient_projects_to_binary_weakened ctx
      (interface_forgetting_and_full_predictive_accessibility_gradient_give_degraded_predictive_accessibility
        ctx hForgetting hFull)

structure PhysicalPredictiveLossFunctionContext (u : InterfaceProfile) where
  gradient_ctx : PhysicalPredictiveAccessibilityGradientContext u
  recoverability_loss_magnitude : gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  forgetting_trace_has_bounded_loss :
    ∀ x : gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject gradient_ctx.recoverability_ctx.memory_ctx x ->
      gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      0 < recoverability_loss_magnitude x /\
      recoverability_loss_magnitude x <= gradient_ctx.full_accessibility_level
  forgetting_and_full_seed_with_given_loss_give_exact_drop :
    ∀ x : gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject gradient_ctx.recoverability_ctx.memory_ctx x ->
      gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
    (exists p : gradient_ctx.predictive_ctx.Proc,
      gradient_ctx.predictive_ctx.inside_universe p /\
      gradient_ctx.predictive_ctx.expected_candidate p /\
      gradient_ctx.predictive_ctx.result_trace p /\
      gradient_ctx.predictive_accessibility_level p =
        gradient_ctx.full_accessibility_level) ->
    exists p : gradient_ctx.predictive_ctx.Proc,
        gradient_ctx.predictive_ctx.inside_universe p /\
        gradient_ctx.predictive_ctx.expected_candidate p /\
        gradient_ctx.predictive_ctx.result_trace p /\
        gradient_ctx.predictive_accessibility_level p =
          gradient_ctx.full_accessibility_level
            - recoverability_loss_magnitude x

def QuantifiedRecoverabilityLossAtMagnitudeInside {u : InterfaceProfile}
    (ctx : PhysicalPredictiveLossFunctionContext u)
    (n : Nat) : Prop :=
  exists x : ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
    ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x /\
    RecordObject ctx.gradient_ctx.recoverability_ctx.memory_ctx x /\
    ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x /\
    ctx.recoverability_loss_magnitude x = n

theorem quantified_recoverability_loss_at_magnitude_inside_gives_forgetting
    {u : InterfaceProfile}
    (ctx : PhysicalPredictiveLossFunctionContext u)
    (n : Nat) :
    QuantifiedRecoverabilityLossAtMagnitudeInside ctx n ->
      InterfaceForgettingInside ctx.gradient_ctx.recoverability_ctx := by
  intro h
  rcases h with ⟨x, hInside, hRecord, hBlocked, _hMagnitude⟩
  exact ⟨x, hInside, hRecord, hBlocked⟩

theorem quantified_recoverability_loss_at_magnitude_inside_is_positive
    {u : InterfaceProfile}
    (ctx : PhysicalPredictiveLossFunctionContext u)
    (n : Nat) :
    QuantifiedRecoverabilityLossAtMagnitudeInside ctx n ->
      0 < n := by
  intro h
  rcases h with ⟨x, hInside, hRecord, hBlocked, hMagnitude⟩
  rcases ctx.forgetting_trace_has_bounded_loss x hInside hRecord hBlocked with
    ⟨hPositive, _hLeFull⟩
  simpa [hMagnitude] using hPositive

theorem quantified_recoverability_loss_at_magnitude_inside_le_full
    {u : InterfaceProfile}
    (ctx : PhysicalPredictiveLossFunctionContext u)
    (n : Nat) :
    QuantifiedRecoverabilityLossAtMagnitudeInside ctx n ->
      n <= ctx.gradient_ctx.full_accessibility_level := by
  intro h
  rcases h with ⟨x, hInside, hRecord, hBlocked, hMagnitude⟩
  rcases ctx.forgetting_trace_has_bounded_loss x hInside hRecord hBlocked with
    ⟨_hPositive, hLeFull⟩
  simpa [hMagnitude] using hLeFull

theorem quantified_loss_and_full_predictive_accessibility_give_exact_predictive_level
    {u : InterfaceProfile}
    (ctx : PhysicalPredictiveLossFunctionContext u)
    (n : Nat) :
    QuantifiedRecoverabilityLossAtMagnitudeInside ctx n ->
      FullPredictiveAccessibilityGradientInside ctx.gradient_ctx ->
        PredictiveAccessibilityAtLevelInside ctx.gradient_ctx
          (ctx.gradient_ctx.full_accessibility_level - n) := by
  intro hLoss hFull
  rcases hLoss with ⟨x, hInsideX, hRecordX, hBlockedX, hMagnitude⟩
  rcases ctx.forgetting_and_full_seed_with_given_loss_give_exact_drop
      x hInsideX hRecordX hBlockedX hFull with
    ⟨p, hInsideP, hExpectedP, hTraceP, hLevel⟩
  exact
    ⟨p, hInsideP, hExpectedP, hTraceP,
      by simpa [hMagnitude] using hLevel⟩

theorem quantified_loss_and_full_predictive_accessibility_give_exact_predictive_drop
    {u : InterfaceProfile}
    (ctx : PhysicalPredictiveLossFunctionContext u)
    (n : Nat) :
    QuantifiedRecoverabilityLossAtMagnitudeInside ctx n ->
      FullPredictiveAccessibilityGradientInside ctx.gradient_ctx ->
        exists p : ctx.gradient_ctx.predictive_ctx.Proc,
          ctx.gradient_ctx.predictive_ctx.inside_universe p /\
          ctx.gradient_ctx.predictive_ctx.expected_candidate p /\
          ctx.gradient_ctx.predictive_ctx.result_trace p /\
          ctx.gradient_ctx.predictive_accessibility_level p + n =
            ctx.gradient_ctx.full_accessibility_level := by
  intro hLoss hFull
  rcases quantified_loss_and_full_predictive_accessibility_give_exact_predictive_level
      ctx n hLoss hFull with
    ⟨p, hInsideP, hExpectedP, hTraceP, hLevel⟩
  have hLeFull :
      n <= ctx.gradient_ctx.full_accessibility_level :=
    quantified_recoverability_loss_at_magnitude_inside_le_full ctx n hLoss
  exact
    ⟨p, hInsideP, hExpectedP, hTraceP,
      by
        rw [hLevel]
        exact Nat.sub_add_cancel hLeFull⟩

structure PhysicalRecoveryCostDerivedLossContext (u : InterfaceProfile) where
  loss_ctx : PhysicalPredictiveLossFunctionContext u
  recovery_cost_growth_magnitude :
    loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  growth_trace_has_positive_cost :
    ∀ x : loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      loss_ctx.gradient_ctx.recoverability_ctx.recovery_cost_growth x ->
      loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      0 < recovery_cost_growth_magnitude x
  growth_cost_agrees_with_loss_magnitude :
    ∀ x : loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      loss_ctx.gradient_ctx.recoverability_ctx.recovery_cost_growth x ->
      loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      recovery_cost_growth_magnitude x =
        loss_ctx.recoverability_loss_magnitude x

def QuantifiedRecoveryCostGrowthAtMagnitudeInside {u : InterfaceProfile}
    (ctx : PhysicalRecoveryCostDerivedLossContext u)
    (n : Nat) : Prop :=
  exists x : ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
    ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x /\
    RecordObject ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x /\
    ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_cost_growth x /\
    ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x /\
    ctx.recovery_cost_growth_magnitude x = n

theorem quantified_recovery_cost_growth_at_magnitude_inside_is_positive
    {u : InterfaceProfile}
    (ctx : PhysicalRecoveryCostDerivedLossContext u)
    (n : Nat) :
    QuantifiedRecoveryCostGrowthAtMagnitudeInside ctx n ->
      0 < n := by
  intro h
  rcases h with ⟨x, hInside, hRecord, hGrowth, hBlocked, hMagnitude⟩
  have hPositive :=
    ctx.growth_trace_has_positive_cost x hInside hRecord hGrowth hBlocked
  simpa [hMagnitude] using hPositive

theorem quantified_recovery_cost_growth_at_magnitude_inside_gives_quantified_recoverability_loss
    {u : InterfaceProfile}
    (ctx : PhysicalRecoveryCostDerivedLossContext u)
    (n : Nat) :
    QuantifiedRecoveryCostGrowthAtMagnitudeInside ctx n ->
      QuantifiedRecoverabilityLossAtMagnitudeInside ctx.loss_ctx n := by
  intro h
  rcases h with ⟨x, hInside, hRecord, hGrowth, hBlocked, hMagnitude⟩
  have hAgreement :=
    ctx.growth_cost_agrees_with_loss_magnitude x hInside hRecord hGrowth hBlocked
  exact
    ⟨x, hInside, hRecord, hBlocked,
      by rw [← hAgreement, hMagnitude]⟩

theorem quantified_recovery_cost_growth_and_full_predictive_accessibility_give_exact_predictive_level
    {u : InterfaceProfile}
    (ctx : PhysicalRecoveryCostDerivedLossContext u)
    (n : Nat) :
    QuantifiedRecoveryCostGrowthAtMagnitudeInside ctx n ->
      FullPredictiveAccessibilityGradientInside ctx.loss_ctx.gradient_ctx ->
        PredictiveAccessibilityAtLevelInside ctx.loss_ctx.gradient_ctx
          (ctx.loss_ctx.gradient_ctx.full_accessibility_level - n) := by
  intro hGrowth hFull
  exact
    quantified_loss_and_full_predictive_accessibility_give_exact_predictive_level
      ctx.loss_ctx n
      (quantified_recovery_cost_growth_at_magnitude_inside_gives_quantified_recoverability_loss
        ctx n hGrowth)
      hFull

theorem quantified_recovery_cost_growth_and_full_predictive_accessibility_give_exact_predictive_drop
    {u : InterfaceProfile}
    (ctx : PhysicalRecoveryCostDerivedLossContext u)
    (n : Nat) :
    QuantifiedRecoveryCostGrowthAtMagnitudeInside ctx n ->
      FullPredictiveAccessibilityGradientInside ctx.loss_ctx.gradient_ctx ->
        exists p : ctx.loss_ctx.gradient_ctx.predictive_ctx.Proc,
          ctx.loss_ctx.gradient_ctx.predictive_ctx.inside_universe p /\
          ctx.loss_ctx.gradient_ctx.predictive_ctx.expected_candidate p /\
          ctx.loss_ctx.gradient_ctx.predictive_ctx.result_trace p /\
          ctx.loss_ctx.gradient_ctx.predictive_accessibility_level p + n =
            ctx.loss_ctx.gradient_ctx.full_accessibility_level := by
  intro hGrowth hFull
  exact
    quantified_loss_and_full_predictive_accessibility_give_exact_predictive_drop
      ctx.loss_ctx n
      (quantified_recovery_cost_growth_at_magnitude_inside_gives_quantified_recoverability_loss
        ctx n hGrowth)
      hFull

def ordered_recoverability_loss_value
    (full dispersion blockedness : Nat) : Nat :=
  min full (dispersion + blockedness)

theorem ordered_loss_magnitude_is_bounded_by_full
    (full dispersion blockedness : Nat) :
    ordered_recoverability_loss_value full dispersion blockedness <= full := by
  unfold ordered_recoverability_loss_value
  omega

theorem ordered_loss_magnitude_is_monotone_in_dispersion
    (full dispersion₁ dispersion₂ blockedness : Nat) :
    dispersion₁ <= dispersion₂ ->
      ordered_recoverability_loss_value full dispersion₁ blockedness <=
        ordered_recoverability_loss_value full dispersion₂ blockedness := by
  intro h
  unfold ordered_recoverability_loss_value
  omega

theorem ordered_loss_magnitude_is_monotone_in_blockedness
    (full dispersion blockedness₁ blockedness₂ : Nat) :
    blockedness₁ <= blockedness₂ ->
      ordered_recoverability_loss_value full dispersion blockedness₁ <=
        ordered_recoverability_loss_value full dispersion blockedness₂ := by
  intro h
  unfold ordered_recoverability_loss_value
  omega

structure PhysicalOrderedRecoverabilityLossContext (u : InterfaceProfile) where
  recovery_cost_ctx : PhysicalRecoveryCostDerivedLossContext u
  dispersion_magnitude :
    recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  blockedness_magnitude :
    recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  ordered_loss_magnitude :
    recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  dispersion_trace_has_positive_dispersion :
    ∀ x : recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
      0 < dispersion_magnitude x
  blocked_trace_has_positive_blockedness :
    ∀ x : recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      0 < blockedness_magnitude x
  ordered_loss_is_sum_capped_by_full :
    ∀ x : recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
      recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      ordered_loss_magnitude x =
        ordered_recoverability_loss_value
          recovery_cost_ctx.loss_ctx.gradient_ctx.full_accessibility_level
          (dispersion_magnitude x)
          (blockedness_magnitude x)
  distributed_and_blocked_trace_exists_for_ordered_loss :
    ∀ x : recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
      recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_cost_growth x /\
      recovery_cost_ctx.recovery_cost_growth_magnitude x = ordered_loss_magnitude x

def QuantifiedDispersionAtMagnitudeInside {u : InterfaceProfile}
    (ctx : PhysicalOrderedRecoverabilityLossContext u)
    (n : Nat) : Prop :=
  exists x : ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
    ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x /\
    RecordObject ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x /\
    ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x /\
    ctx.dispersion_magnitude x = n

def QuantifiedBlockednessAtMagnitudeInside {u : InterfaceProfile}
    (ctx : PhysicalOrderedRecoverabilityLossContext u)
    (n : Nat) : Prop :=
  exists x : ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
    ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x /\
    RecordObject ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x /\
    ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x /\
    ctx.blockedness_magnitude x = n

def QuantifiedOrderedRecoverabilityLossAtMagnitudeInside {u : InterfaceProfile}
    (ctx : PhysicalOrderedRecoverabilityLossContext u)
    (n : Nat) : Prop :=
  exists x : ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
    ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x /\
    RecordObject ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x /\
    ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x /\
    ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x /\
    ctx.ordered_loss_magnitude x = n

theorem quantified_dispersion_and_blockedness_give_ordered_loss_magnitude
    {u : InterfaceProfile}
    (ctx : PhysicalOrderedRecoverabilityLossContext u)
    {x : ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj}
    {d b : Nat} :
    ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
        ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
          ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
            ctx.dispersion_magnitude x = d ->
              ctx.blockedness_magnitude x = b ->
                QuantifiedOrderedRecoverabilityLossAtMagnitudeInside ctx
                  (ordered_recoverability_loss_value
                    ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.full_accessibility_level
                    d b) := by
  intro hInside hRecord hDistributed hBlocked hDisp hBlock
  exact
    ⟨x, hInside, hRecord, hDistributed, hBlocked,
      by
        rw [ctx.ordered_loss_is_sum_capped_by_full x hInside hRecord hDistributed hBlocked]
        simp [hDisp, hBlock]⟩

theorem quantified_ordered_recoverability_loss_gives_quantified_recoverability_loss
    {u : InterfaceProfile}
    (ctx : PhysicalOrderedRecoverabilityLossContext u)
    (n : Nat) :
    QuantifiedOrderedRecoverabilityLossAtMagnitudeInside ctx n ->
      QuantifiedRecoverabilityLossAtMagnitudeInside ctx.recovery_cost_ctx.loss_ctx n := by
  intro h
  rcases h with ⟨x, hInside, hRecord, hDistributed, hBlocked, hOrdered⟩
  rcases ctx.distributed_and_blocked_trace_exists_for_ordered_loss
      x hInside hRecord hDistributed hBlocked with
    ⟨hGrowth, hOrderedGrowth⟩
  have hGrowthLoss :=
    ctx.recovery_cost_ctx.growth_cost_agrees_with_loss_magnitude
      x hInside hRecord hGrowth hBlocked
  exact
    ⟨x, hInside, hRecord, hBlocked,
      by rw [← hGrowthLoss, hOrderedGrowth, hOrdered]⟩

theorem ordered_loss_and_full_predictive_accessibility_give_exact_predictive_level
    {u : InterfaceProfile}
    (ctx : PhysicalOrderedRecoverabilityLossContext u)
    (n : Nat) :
    QuantifiedOrderedRecoverabilityLossAtMagnitudeInside ctx n ->
      FullPredictiveAccessibilityGradientInside ctx.recovery_cost_ctx.loss_ctx.gradient_ctx ->
        PredictiveAccessibilityAtLevelInside
          ctx.recovery_cost_ctx.loss_ctx.gradient_ctx
          (ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.full_accessibility_level - n) := by
  intro hLoss hFull
  exact
    quantified_loss_and_full_predictive_accessibility_give_exact_predictive_level
      ctx.recovery_cost_ctx.loss_ctx n
      (quantified_ordered_recoverability_loss_gives_quantified_recoverability_loss
        ctx n hLoss)
      hFull

theorem ordered_loss_and_full_predictive_accessibility_give_exact_predictive_drop
    {u : InterfaceProfile}
    (ctx : PhysicalOrderedRecoverabilityLossContext u)
    (n : Nat) :
    QuantifiedOrderedRecoverabilityLossAtMagnitudeInside ctx n ->
      FullPredictiveAccessibilityGradientInside ctx.recovery_cost_ctx.loss_ctx.gradient_ctx ->
        exists p : ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.predictive_ctx.Proc,
          ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.predictive_ctx.inside_universe p /\
          ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.predictive_ctx.expected_candidate p /\
          ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.predictive_ctx.result_trace p /\
          ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.predictive_accessibility_level p + n =
            ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.full_accessibility_level := by
  intro hLoss hFull
  exact
    quantified_loss_and_full_predictive_accessibility_give_exact_predictive_drop
      ctx.recovery_cost_ctx.loss_ctx n
      (quantified_ordered_recoverability_loss_gives_quantified_recoverability_loss
        ctx n hLoss)
      hFull

inductive RecoverabilitySpectrumAxis where
  | dispersion
  | blockedness

structure PhysicalRecoverabilitySpectrumContext (u : InterfaceProfile) where
  ordered_loss_ctx : PhysicalOrderedRecoverabilityLossContext u
  spectrum_axis_magnitude :
    RecoverabilitySpectrumAxis ->
      ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  dispersion_axis_matches_ordered_dispersion :
    ∀ x : ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
      spectrum_axis_magnitude RecoverabilitySpectrumAxis.dispersion x =
        ordered_loss_ctx.dispersion_magnitude x
  blockedness_axis_matches_ordered_blockedness :
    ∀ x : ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      spectrum_axis_magnitude RecoverabilitySpectrumAxis.blockedness x =
        ordered_loss_ctx.blockedness_magnitude x

def SpectrumLossAtAxisInside {u : InterfaceProfile}
    (ctx : PhysicalRecoverabilitySpectrumContext u)
    (axis : RecoverabilitySpectrumAxis)
    (n : Nat) : Prop :=
  exists x : ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
    ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x /\
    RecordObject ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x /\
    (match axis with
    | RecoverabilitySpectrumAxis.dispersion =>
        ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x
    | RecoverabilitySpectrumAxis.blockedness =>
        ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x) /\
    ctx.spectrum_axis_magnitude axis x = n

theorem recoverability_spectrum_projects_dispersion_axis
    {u : InterfaceProfile}
    (ctx : PhysicalRecoverabilitySpectrumContext u)
    (n : Nat) :
    SpectrumLossAtAxisInside ctx RecoverabilitySpectrumAxis.dispersion n ->
      QuantifiedDispersionAtMagnitudeInside ctx.ordered_loss_ctx n := by
  intro h
  rcases h with ⟨x, hInside, hRecord, hDistributed, hAxis⟩
  exact
    ⟨x, hInside, hRecord, hDistributed,
      by
        rw [← ctx.dispersion_axis_matches_ordered_dispersion x hInside hRecord hDistributed]
        exact hAxis⟩

theorem recoverability_spectrum_projects_blockedness_axis
    {u : InterfaceProfile}
    (ctx : PhysicalRecoverabilitySpectrumContext u)
    (n : Nat) :
    SpectrumLossAtAxisInside ctx RecoverabilitySpectrumAxis.blockedness n ->
      QuantifiedBlockednessAtMagnitudeInside ctx.ordered_loss_ctx n := by
  intro h
  rcases h with ⟨x, hInside, hRecord, hBlocked, hAxis⟩
  exact
    ⟨x, hInside, hRecord, hBlocked,
      by
        rw [← ctx.blockedness_axis_matches_ordered_blockedness x hInside hRecord hBlocked]
        exact hAxis⟩

theorem recoverability_spectrum_axes_give_ordered_loss_magnitude
    {u : InterfaceProfile}
    (ctx : PhysicalRecoverabilitySpectrumContext u)
    {x : ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj}
    {d b : Nat} :
    ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
        ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
          ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
            ctx.spectrum_axis_magnitude RecoverabilitySpectrumAxis.dispersion x = d ->
              ctx.spectrum_axis_magnitude RecoverabilitySpectrumAxis.blockedness x = b ->
                QuantifiedOrderedRecoverabilityLossAtMagnitudeInside
                  ctx.ordered_loss_ctx
                  (ordered_recoverability_loss_value
                    ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.full_accessibility_level
                    d b) := by
  intro hInside hRecord hDistributed hBlocked hDisp hBlockedAxis
  have hOrderedDisp :
      ctx.ordered_loss_ctx.dispersion_magnitude x = d := by
    rw [← ctx.dispersion_axis_matches_ordered_dispersion x hInside hRecord hDistributed, hDisp]
  have hOrderedBlocked :
      ctx.ordered_loss_ctx.blockedness_magnitude x = b := by
    rw [← ctx.blockedness_axis_matches_ordered_blockedness x hInside hRecord hBlocked, hBlockedAxis]
  exact
    quantified_dispersion_and_blockedness_give_ordered_loss_magnitude
      ctx.ordered_loss_ctx
      hInside hRecord hDistributed hBlocked hOrderedDisp hOrderedBlocked

theorem recoverability_spectrum_and_full_predictive_accessibility_give_exact_predictive_level
    {u : InterfaceProfile}
    (ctx : PhysicalRecoverabilitySpectrumContext u)
    (n : Nat) :
    QuantifiedOrderedRecoverabilityLossAtMagnitudeInside ctx.ordered_loss_ctx n ->
      FullPredictiveAccessibilityGradientInside
        ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx ->
        PredictiveAccessibilityAtLevelInside
          ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx
          (ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.full_accessibility_level - n) := by
  intro hLoss hFull
  exact
    ordered_loss_and_full_predictive_accessibility_give_exact_predictive_level
      ctx.ordered_loss_ctx n hLoss hFull

theorem recoverability_spectrum_and_full_predictive_accessibility_give_exact_predictive_drop
    {u : InterfaceProfile}
    (ctx : PhysicalRecoverabilitySpectrumContext u)
    (n : Nat) :
    QuantifiedOrderedRecoverabilityLossAtMagnitudeInside ctx.ordered_loss_ctx n ->
      FullPredictiveAccessibilityGradientInside
        ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx ->
        exists p : ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.predictive_ctx.Proc,
          ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.predictive_ctx.inside_universe p /\
          ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.predictive_ctx.expected_candidate p /\
          ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.predictive_ctx.result_trace p /\
          ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.predictive_accessibility_level p + n =
            ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.full_accessibility_level := by
  intro hLoss hFull
  exact
    ordered_loss_and_full_predictive_accessibility_give_exact_predictive_drop
      ctx.ordered_loss_ctx n hLoss hFull

inductive RecoverabilityTriSpectrumAxis where
  | dispersion
  | blockedness
  | locality

def tri_spectral_loss_value
    (full dispersion blockedness locality : Nat) : Nat :=
  min full (dispersion + blockedness + locality)

structure PhysicalRecoverabilityTriSpectrumContext (u : InterfaceProfile) where
  loss_ctx : PhysicalPredictiveLossFunctionContext u
  dispersion_magnitude :
    loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  blockedness_magnitude :
    loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  locality_magnitude :
    loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  tri_spectral_loss_magnitude :
    loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  dispersion_axis_has_positive_magnitude :
    ∀ x : loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
      0 < dispersion_magnitude x
  blockedness_axis_has_positive_magnitude :
    ∀ x : loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      0 < blockedness_magnitude x
  locality_axis_has_positive_magnitude :
    ∀ x : loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      ¬ loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
      0 < locality_magnitude x
  tri_spectral_loss_is_sum_capped_by_full :
    ∀ x : loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
      loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      ¬ loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
      tri_spectral_loss_magnitude x =
        tri_spectral_loss_value
          loss_ctx.gradient_ctx.full_accessibility_level
          (dispersion_magnitude x)
          (blockedness_magnitude x)
          (locality_magnitude x)
  tri_spectrum_trace_projects_to_loss :
    ∀ x : loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
      loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      ¬ loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
      loss_ctx.recoverability_loss_magnitude x = tri_spectral_loss_magnitude x

def TriSpectrumLossAtAxisInside {u : InterfaceProfile}
    (ctx : PhysicalRecoverabilityTriSpectrumContext u)
    (axis : RecoverabilityTriSpectrumAxis)
    (n : Nat) : Prop :=
  exists x : ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
    ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x /\
    RecordObject ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x /\
    (match axis with
    | RecoverabilityTriSpectrumAxis.dispersion =>
        ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x
    | RecoverabilityTriSpectrumAxis.blockedness =>
        ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x
    | RecoverabilityTriSpectrumAxis.locality =>
        ¬ ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x) /\
    (match axis with
    | RecoverabilityTriSpectrumAxis.dispersion => ctx.dispersion_magnitude x
    | RecoverabilityTriSpectrumAxis.blockedness => ctx.blockedness_magnitude x
    | RecoverabilityTriSpectrumAxis.locality => ctx.locality_magnitude x) = n

theorem recoverability_tri_spectrum_axes_give_quantified_recoverability_loss
    {u : InterfaceProfile}
    (ctx : PhysicalRecoverabilityTriSpectrumContext u)
    {x : ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj}
    {d b l : Nat} :
    ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
        ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
          ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
            ¬ ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
              ctx.dispersion_magnitude x = d ->
                ctx.blockedness_magnitude x = b ->
                  ctx.locality_magnitude x = l ->
                    QuantifiedRecoverabilityLossAtMagnitudeInside ctx.loss_ctx
                      (tri_spectral_loss_value
                        ctx.loss_ctx.gradient_ctx.full_accessibility_level
                        d b l) := by
  intro hInside hRecord hDistributed hBlocked hLocal hDisp hBlockedMag hLocalMag
  have hProjected :=
    ctx.tri_spectrum_trace_projects_to_loss x hInside hRecord hDistributed hBlocked hLocal
  exact
    ⟨x, hInside, hRecord, hBlocked,
      by
        rw [hProjected]
        rw [ctx.tri_spectral_loss_is_sum_capped_by_full x hInside hRecord hDistributed hBlocked hLocal]
        simp [hDisp, hBlockedMag, hLocalMag]⟩

theorem recoverability_tri_spectrum_and_full_predictive_accessibility_give_exact_predictive_level
    {u : InterfaceProfile}
    (ctx : PhysicalRecoverabilityTriSpectrumContext u)
    (n : Nat) :
    QuantifiedRecoverabilityLossAtMagnitudeInside ctx.loss_ctx n ->
      FullPredictiveAccessibilityGradientInside ctx.loss_ctx.gradient_ctx ->
        PredictiveAccessibilityAtLevelInside
          ctx.loss_ctx.gradient_ctx
          (ctx.loss_ctx.gradient_ctx.full_accessibility_level - n) := by
  intro hLoss hFull
  exact
    quantified_loss_and_full_predictive_accessibility_give_exact_predictive_level
      ctx.loss_ctx n hLoss hFull

theorem recoverability_tri_spectrum_and_full_predictive_accessibility_give_exact_predictive_drop
    {u : InterfaceProfile}
    (ctx : PhysicalRecoverabilityTriSpectrumContext u)
    (n : Nat) :
    QuantifiedRecoverabilityLossAtMagnitudeInside ctx.loss_ctx n ->
      FullPredictiveAccessibilityGradientInside ctx.loss_ctx.gradient_ctx ->
        exists p : ctx.loss_ctx.gradient_ctx.predictive_ctx.Proc,
          ctx.loss_ctx.gradient_ctx.predictive_ctx.inside_universe p /\
          ctx.loss_ctx.gradient_ctx.predictive_ctx.expected_candidate p /\
          ctx.loss_ctx.gradient_ctx.predictive_ctx.result_trace p /\
          ctx.loss_ctx.gradient_ctx.predictive_accessibility_level p + n =
            ctx.loss_ctx.gradient_ctx.full_accessibility_level := by
  intro hLoss hFull
  exact
    quantified_loss_and_full_predictive_accessibility_give_exact_predictive_drop
      ctx.loss_ctx n hLoss hFull

def derived_locality_loss_value
    (dispersion : Nat)
    (interfaceAccessible distributed : Bool) : Nat :=
  if interfaceAccessible then 0 else if distributed then dispersion else 1

theorem derived_locality_loss_value_is_monotone_in_dispersion
    (dispersion₁ dispersion₂ : Nat)
    (interfaceAccessible distributed : Bool) :
    dispersion₁ <= dispersion₂ ->
      derived_locality_loss_value dispersion₁ interfaceAccessible distributed <=
        derived_locality_loss_value dispersion₂ interfaceAccessible distributed := by
  intro h
  cases interfaceAccessible <;> cases distributed <;>
    unfold derived_locality_loss_value <;> simp <;> omega

theorem derived_locality_loss_value_is_zero_when_accessible
    (dispersion : Nat)
    (distributed : Bool) :
    derived_locality_loss_value dispersion true distributed = 0 := by
  simp [derived_locality_loss_value]

theorem derived_locality_loss_value_is_positive_when_inaccessible_and_distributed
    (dispersion : Nat) :
    0 < dispersion ->
      0 < derived_locality_loss_value dispersion false true := by
  intro h
  unfold derived_locality_loss_value
  simp
  omega

structure PhysicalDerivedLocalityTriSpectrumContext (u : InterfaceProfile) where
  tri_ctx : PhysicalRecoverabilityTriSpectrumContext u
  accessibility_flag :
    tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Bool
  distributed_flag :
    tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Bool
  accessibility_flag_reflects_interface_accessible :
    ∀ x : tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      accessibility_flag x = true <->
        tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x
  distributed_flag_reflects_distributed :
    ∀ x : tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      distributed_flag x = true <->
        tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x
  tri_locality_axis_matches_derived_formula :
    ∀ x : tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      tri_ctx.locality_magnitude x =
        derived_locality_loss_value
          (tri_ctx.dispersion_magnitude x)
          (accessibility_flag x)
          (distributed_flag x)

theorem derived_locality_from_accessibility_and_distribution_gives_locality_axis
    {u : InterfaceProfile}
    (ctx : PhysicalDerivedLocalityTriSpectrumContext u)
    {x : ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj}
    {d : Nat} :
    ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
        ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
          ¬ ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
            ctx.tri_ctx.dispersion_magnitude x = d ->
              TriSpectrumLossAtAxisInside ctx.tri_ctx RecoverabilityTriSpectrumAxis.locality
                (derived_locality_loss_value d false true) := by
  intro hInside hRecord hDistributed hInaccessible hDisp
  have hAccFlag : ctx.accessibility_flag x = false := by
    cases hFlag : ctx.accessibility_flag x <;> simp at *
    exact False.elim (hInaccessible ((ctx.accessibility_flag_reflects_interface_accessible x).mp hFlag))
  have hDistFlag : ctx.distributed_flag x = true := by
    exact (ctx.distributed_flag_reflects_distributed x).mpr hDistributed
  exact
    ⟨x, hInside, hRecord, hInaccessible,
      by
        rw [ctx.tri_locality_axis_matches_derived_formula x, hDisp, hAccFlag, hDistFlag]⟩

structure PhysicalLocalReadabilityContext (u : InterfaceProfile) where
  tri_ctx : PhysicalRecoverabilityTriSpectrumContext u
  local_readability_trace :
    tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Prop
  local_readability_magnitude :
    tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  derived_locality_loss_magnitude :
    tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  local_readability_trace_has_positive_magnitude :
    ∀ x : tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
      tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      ¬ tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
      local_readability_trace x ->
      0 < local_readability_magnitude x
  derived_locality_loss_agrees_with_local_readability :
    ∀ x : tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
      tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      ¬ tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
      local_readability_trace x ->
      derived_locality_loss_magnitude x = local_readability_magnitude x
  derived_locality_projects_to_tri_locality :
    ∀ x : tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
      tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      ¬ tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
      local_readability_trace x ->
      tri_ctx.locality_magnitude x = derived_locality_loss_magnitude x

structure LowLevelLocalReadabilityTrace
    {u : InterfaceProfile}
    (ctx : PhysicalLocalReadabilityContext u) where
  carrier : ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj
  inside :
    ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe carrier
  record :
    RecordObject ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx carrier
  distributed :
    ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed carrier
  recovery_blocked :
    ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked carrier
  inaccessible :
    ¬ ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible carrier
  readability_trace :
    ctx.local_readability_trace carrier

def QuantifiedLocalReadabilityMagnitudeInside {u : InterfaceProfile}
    (ctx : PhysicalLocalReadabilityContext u)
    (n : Nat) : Prop :=
  exists x : ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
    ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x /\
    RecordObject ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x /\
    ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x /\
    ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x /\
    ¬ ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x /\
    ctx.local_readability_trace x /\
    ctx.local_readability_magnitude x = n

def DerivedLocalityLossMagnitudeInside {u : InterfaceProfile}
    (ctx : PhysicalLocalReadabilityContext u)
    (n : Nat) : Prop :=
  exists x : ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
    ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x /\
    RecordObject ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x /\
    ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x /\
    ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x /\
    ¬ ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x /\
    ctx.local_readability_trace x /\
    ctx.derived_locality_loss_magnitude x = n

theorem low_level_local_readability_trace_gives_quantified_local_readability_magnitude_inside
    {u : InterfaceProfile}
    {ctx : PhysicalLocalReadabilityContext u}
    (h : LowLevelLocalReadabilityTrace ctx) :
    QuantifiedLocalReadabilityMagnitudeInside ctx
      (ctx.local_readability_magnitude h.carrier) := by
  exact
    ⟨h.carrier, h.inside, h.record, h.distributed, h.recovery_blocked,
      h.inaccessible, h.readability_trace, rfl⟩

theorem quantified_local_readability_magnitude_inside_is_positive
    {u : InterfaceProfile}
    (ctx : PhysicalLocalReadabilityContext u)
    (n : Nat) :
    QuantifiedLocalReadabilityMagnitudeInside ctx n ->
      0 < n := by
  intro h
  rcases h with ⟨x, hInside, hRecord, hDistributed, hBlocked, hInaccessible, hTrace, hMagnitude⟩
  have hPositive :=
    ctx.local_readability_trace_has_positive_magnitude
      x hInside hRecord hDistributed hBlocked hInaccessible hTrace
  simpa [hMagnitude] using hPositive

theorem quantified_local_readability_magnitude_inside_gives_derived_locality_loss
    {u : InterfaceProfile}
    (ctx : PhysicalLocalReadabilityContext u)
    (n : Nat) :
    QuantifiedLocalReadabilityMagnitudeInside ctx n ->
      DerivedLocalityLossMagnitudeInside ctx n := by
  intro h
  rcases h with ⟨x, hInside, hRecord, hDistributed, hBlocked, hInaccessible, hTrace, hMagnitude⟩
  have hAgree :=
    ctx.derived_locality_loss_agrees_with_local_readability
      x hInside hRecord hDistributed hBlocked hInaccessible hTrace
  exact
    ⟨x, hInside, hRecord, hDistributed, hBlocked, hInaccessible, hTrace,
      by rw [hAgree, hMagnitude]⟩

theorem derived_locality_loss_projects_to_tri_spectrum_locality_axis
    {u : InterfaceProfile}
    (ctx : PhysicalLocalReadabilityContext u)
    (n : Nat) :
    DerivedLocalityLossMagnitudeInside ctx n ->
      TriSpectrumLossAtAxisInside ctx.tri_ctx RecoverabilityTriSpectrumAxis.locality n := by
  intro h
  rcases h with ⟨x, hInside, hRecord, hDistributed, hBlocked, hInaccessible, hTrace, hMagnitude⟩
  have hProject :=
    ctx.derived_locality_projects_to_tri_locality
      x hInside hRecord hDistributed hBlocked hInaccessible hTrace
  exact
    ⟨x, hInside, hRecord, hInaccessible,
      by rw [hProject, hMagnitude]⟩

theorem local_readability_trace_and_axis_values_give_quantified_recoverability_loss
    {u : InterfaceProfile}
    (ctx : PhysicalLocalReadabilityContext u)
    {x : ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj}
    {d b l : Nat} :
    ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
        ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
          ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
            ¬ ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
              ctx.local_readability_trace x ->
                ctx.tri_ctx.dispersion_magnitude x = d ->
                  ctx.tri_ctx.blockedness_magnitude x = b ->
                    ctx.local_readability_magnitude x = l ->
                      QuantifiedRecoverabilityLossAtMagnitudeInside ctx.tri_ctx.loss_ctx
                        (tri_spectral_loss_value
                          ctx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level
                          d b l) := by
  intro hInside hRecord hDistributed hBlocked hInaccessible hTrace hDisp hBlockedMag hReadability
  have hDerived :
      ctx.tri_ctx.locality_magnitude x = l := by
    rw [ctx.derived_locality_projects_to_tri_locality
          x hInside hRecord hDistributed hBlocked hInaccessible hTrace]
    rw [ctx.derived_locality_loss_agrees_with_local_readability
          x hInside hRecord hDistributed hBlocked hInaccessible hTrace]
    exact hReadability
  exact
    recoverability_tri_spectrum_axes_give_quantified_recoverability_loss
      ctx.tri_ctx
      hInside hRecord hDistributed hBlocked hInaccessible hDisp hBlockedMag hDerived

def local_unreadability_value
    (blockedness : Nat)
    (interfaceAccessible distributed : Bool) : Nat :=
  if interfaceAccessible then 0 else blockedness + if distributed then 1 else 0

theorem local_unreadability_value_is_monotone_in_blockedness
    (blockedness₁ blockedness₂ : Nat)
    (interfaceAccessible distributed : Bool) :
    blockedness₁ <= blockedness₂ ->
      local_unreadability_value blockedness₁ interfaceAccessible distributed <=
        local_unreadability_value blockedness₂ interfaceAccessible distributed := by
  intro h
  cases interfaceAccessible <;> cases distributed <;>
    unfold local_unreadability_value <;> simp <;> omega

theorem local_unreadability_value_is_zero_when_accessible
    (blockedness : Nat)
    (distributed : Bool) :
    local_unreadability_value blockedness true distributed = 0 := by
  simp [local_unreadability_value]

theorem local_unreadability_value_is_positive_when_inaccessible_and_distributed
    (blockedness : Nat) :
    0 < local_unreadability_value blockedness false true := by
  unfold local_unreadability_value
  simp

structure PhysicalLocalReadabilityMeasureContext (u : InterfaceProfile) where
  tri_ctx : PhysicalRecoverabilityTriSpectrumContext u
  local_readability_trace :
    tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Prop
  accessibility_flag :
    tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Bool
  distributed_flag :
    tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Bool
  local_readability_cost_magnitude :
    tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  accessibility_flag_reflects_interface_accessible :
    ∀ x : tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      accessibility_flag x = true <->
        tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x
  distributed_flag_reflects_distributed :
    ∀ x : tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      distributed_flag x = true <->
        tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x
  local_readability_cost_matches_derived_rule :
    ∀ x : tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      local_readability_cost_magnitude x =
        local_unreadability_value
          (tri_ctx.blockedness_magnitude x)
          (accessibility_flag x)
          (distributed_flag x)
  local_readability_trace_has_positive_cost :
    ∀ x : tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
      tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      ¬ tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
      local_readability_trace x ->
      0 < local_readability_cost_magnitude x
  local_readability_cost_projects_to_tri_locality :
    ∀ x : tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
      tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      ¬ tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
      local_readability_trace x ->
      tri_ctx.locality_magnitude x = local_readability_cost_magnitude x

def QuantifiedLocalReadabilityCostMagnitudeInside {u : InterfaceProfile}
    (ctx : PhysicalLocalReadabilityMeasureContext u)
    (n : Nat) : Prop :=
  exists x : ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
    ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x /\
    RecordObject ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x /\
    ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x /\
    ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x /\
    ¬ ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x /\
    ctx.local_readability_trace x /\
    ctx.local_readability_cost_magnitude x = n

theorem quantified_local_readability_cost_magnitude_inside_is_positive
    {u : InterfaceProfile}
    (ctx : PhysicalLocalReadabilityMeasureContext u)
    (n : Nat) :
    QuantifiedLocalReadabilityCostMagnitudeInside ctx n ->
      0 < n := by
  intro h
  rcases h with ⟨x, hInside, hRecord, hDistributed, hBlocked, hInaccessible, hTrace, hMagnitude⟩
  have hPositive :=
    ctx.local_readability_trace_has_positive_cost
      x hInside hRecord hDistributed hBlocked hInaccessible hTrace
  simpa [hMagnitude] using hPositive

def local_readability_measure_projects_to_readability_context
    {u : InterfaceProfile}
    (ctx : PhysicalLocalReadabilityMeasureContext u) :
    PhysicalLocalReadabilityContext u :=
  { tri_ctx := ctx.tri_ctx
    local_readability_trace := ctx.local_readability_trace
    local_readability_magnitude := ctx.local_readability_cost_magnitude
    derived_locality_loss_magnitude := ctx.local_readability_cost_magnitude
    local_readability_trace_has_positive_magnitude := ctx.local_readability_trace_has_positive_cost
    derived_locality_loss_agrees_with_local_readability := by
      intro _x _hInside _hRecord _hDistributed _hBlocked _hInaccessible _hTrace
      rfl
    derived_locality_projects_to_tri_locality := by
      exact ctx.local_readability_cost_projects_to_tri_locality }

theorem low_level_local_readability_trace_gives_quantified_local_readability_cost_magnitude_inside
    {u : InterfaceProfile}
    {ctx : PhysicalLocalReadabilityMeasureContext u}
    (hInside :
      LowLevelLocalReadabilityTrace
        (local_readability_measure_projects_to_readability_context ctx)) :
    QuantifiedLocalReadabilityCostMagnitudeInside ctx
      (ctx.local_readability_cost_magnitude hInside.carrier) := by
  exact
    ⟨hInside.carrier, hInside.inside, hInside.record, hInside.distributed,
      hInside.recovery_blocked, hInside.inaccessible, hInside.readability_trace, rfl⟩

theorem quantified_local_readability_cost_projects_to_quantified_local_readability_magnitude_inside
    {u : InterfaceProfile}
    (ctx : PhysicalLocalReadabilityMeasureContext u)
    (n : Nat) :
    QuantifiedLocalReadabilityCostMagnitudeInside ctx n ->
      QuantifiedLocalReadabilityMagnitudeInside
        (local_readability_measure_projects_to_readability_context ctx) n := by
  intro h
  exact h

structure PhysicalReadableFragmentContext (u : InterfaceProfile) where
  measure_ctx : PhysicalLocalReadabilityMeasureContext u
  readable_fragment_trace :
    measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Prop
  readable_fragment_magnitude :
    measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  readable_fragment_trace_has_positive_magnitude :
    ∀ x : measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
      measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      ¬ measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
      readable_fragment_trace x ->
      0 < readable_fragment_magnitude x
  readable_fragment_projects_to_local_readability_trace :
    ∀ x : measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      readable_fragment_trace x -> measure_ctx.local_readability_trace x
  readable_fragment_magnitude_projects_to_readability_cost :
    ∀ x : measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
      measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      ¬ measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
      readable_fragment_trace x ->
      measure_ctx.local_readability_cost_magnitude x = readable_fragment_magnitude x

def QuantifiedLocalReadableFragmentMagnitudeInside {u : InterfaceProfile}
    (ctx : PhysicalReadableFragmentContext u)
    (n : Nat) : Prop :=
  exists x : ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
    ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x /\
    RecordObject ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x /\
    ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x /\
    ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x /\
    ¬ ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x /\
    ctx.readable_fragment_trace x /\
    ctx.readable_fragment_magnitude x = n

structure LowLevelReadableFragmentTrace
    {u : InterfaceProfile}
    (ctx : PhysicalReadableFragmentContext u) where
  carrier : ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj
  inside :
    ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe carrier
  record :
    RecordObject ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx carrier
  distributed :
    ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed carrier
  recovery_blocked :
    ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked carrier
  inaccessible :
    ¬ ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible carrier
  readable_fragment_trace :
    ctx.readable_fragment_trace carrier

theorem low_level_readable_fragment_trace_gives_quantified_local_readable_fragment_magnitude_inside
    {u : InterfaceProfile}
    {ctx : PhysicalReadableFragmentContext u}
    (hInside : LowLevelReadableFragmentTrace ctx) :
    QuantifiedLocalReadableFragmentMagnitudeInside ctx
      (ctx.readable_fragment_magnitude hInside.carrier) := by
  exact
    ⟨hInside.carrier, hInside.inside, hInside.record, hInside.distributed,
      hInside.recovery_blocked, hInside.inaccessible, hInside.readable_fragment_trace, rfl⟩

theorem quantified_local_readable_fragment_projects_to_local_readability_cost
    {u : InterfaceProfile}
    (ctx : PhysicalReadableFragmentContext u)
    (n : Nat) :
    QuantifiedLocalReadableFragmentMagnitudeInside ctx n ->
      QuantifiedLocalReadabilityCostMagnitudeInside ctx.measure_ctx n := by
  intro h
  rcases h with ⟨x, hInside, hRecord, hDistributed, hBlocked, hInaccessible, hTrace, hMagnitude⟩
  exact
    ⟨x, hInside, hRecord, hDistributed, hBlocked, hInaccessible,
      ctx.readable_fragment_projects_to_local_readability_trace x hTrace,
      by
        rw [ctx.readable_fragment_magnitude_projects_to_readability_cost
              x hInside hRecord hDistributed hBlocked hInaccessible hTrace,
            hMagnitude]⟩

def readable_fragment_value
    (fragmentCount splitDegree : Nat) : Nat :=
  fragmentCount + splitDegree

theorem readable_fragment_value_is_monotone_in_fragment_count
    (fragmentCount₁ fragmentCount₂ splitDegree : Nat) :
    fragmentCount₁ <= fragmentCount₂ ->
      readable_fragment_value fragmentCount₁ splitDegree <=
        readable_fragment_value fragmentCount₂ splitDegree := by
  intro h
  unfold readable_fragment_value
  omega

theorem readable_fragment_value_is_monotone_in_split_degree
    (fragmentCount splitDegree₁ splitDegree₂ : Nat) :
    splitDegree₁ <= splitDegree₂ ->
      readable_fragment_value fragmentCount splitDegree₁ <=
        readable_fragment_value fragmentCount splitDegree₂ := by
  intro h
  unfold readable_fragment_value
  omega

theorem readable_fragment_value_is_positive_of_positive_fragment_count
    (fragmentCount splitDegree : Nat) :
    0 < fragmentCount ->
      0 < readable_fragment_value fragmentCount splitDegree := by
  intro h
  unfold readable_fragment_value
  omega

structure PhysicalFragmentConnectivityContext (u : InterfaceProfile) where
  measure_ctx : PhysicalLocalReadabilityMeasureContext u
  readable_fragment_trace :
    measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Prop
  fragment_component_trace :
    measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Prop
  fragment_boundary_trace :
    measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Prop
  connected_fragment_count :
    measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  fragment_separation_degree :
    measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  local_reconstruction_path_cost :
    measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  readable_fragment_trace_has_positive_fragment_count :
    ∀ x : measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
      measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      ¬ measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
      readable_fragment_trace x ->
      0 < connected_fragment_count x
  readable_fragment_trace_projects_to_local_readability_trace :
    ∀ x : measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      readable_fragment_trace x -> measure_ctx.local_readability_trace x
  fragment_connectivity_value_projects_to_readability_cost :
    ∀ x : measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
      measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      ¬ measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
      readable_fragment_trace x ->
      measure_ctx.local_readability_cost_magnitude x =
        readable_fragment_value (connected_fragment_count x) (fragment_separation_degree x)

def QuantifiedFragmentComponentCountInside {u : InterfaceProfile}
    (ctx : PhysicalFragmentConnectivityContext u)
    (n : Nat) : Prop :=
  exists x : ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
    ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x /\
    RecordObject ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x /\
    ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x /\
    ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x /\
    ¬ ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x /\
    ctx.readable_fragment_trace x /\
    ctx.fragment_component_trace x /\
    ctx.connected_fragment_count x = n

def QuantifiedFragmentSplitDegreeInside {u : InterfaceProfile}
    (ctx : PhysicalFragmentConnectivityContext u)
    (n : Nat) : Prop :=
  exists x : ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
    ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x /\
    RecordObject ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x /\
    ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x /\
    ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x /\
    ¬ ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x /\
    ctx.readable_fragment_trace x /\
    ctx.fragment_boundary_trace x /\
    ctx.fragment_separation_degree x = n

structure LowLevelFragmentConnectivityTrace
    {u : InterfaceProfile}
    (ctx : PhysicalFragmentConnectivityContext u) where
  carrier : ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj
  inside :
    ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe carrier
  record :
    RecordObject ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx carrier
  distributed :
    ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed carrier
  recovery_blocked :
    ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked carrier
  inaccessible :
    ¬ ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible carrier
  readable_fragment_trace :
    ctx.readable_fragment_trace carrier
  component_trace :
    ctx.fragment_component_trace carrier
  boundary_trace :
    ctx.fragment_boundary_trace carrier

theorem low_level_fragment_connectivity_trace_gives_quantified_fragment_component_count_inside
    {u : InterfaceProfile}
    {ctx : PhysicalFragmentConnectivityContext u}
    (h : LowLevelFragmentConnectivityTrace ctx) :
    QuantifiedFragmentComponentCountInside ctx
      (ctx.connected_fragment_count h.carrier) := by
  exact
    ⟨h.carrier, h.inside, h.record, h.distributed, h.recovery_blocked,
      h.inaccessible, h.readable_fragment_trace, h.component_trace, rfl⟩

theorem low_level_fragment_connectivity_trace_gives_quantified_fragment_split_degree_inside
    {u : InterfaceProfile}
    {ctx : PhysicalFragmentConnectivityContext u}
    (h : LowLevelFragmentConnectivityTrace ctx) :
    QuantifiedFragmentSplitDegreeInside ctx
      (ctx.fragment_separation_degree h.carrier) := by
  exact
    ⟨h.carrier, h.inside, h.record, h.distributed, h.recovery_blocked,
      h.inaccessible, h.readable_fragment_trace, h.boundary_trace, rfl⟩

def local_reconstruction_value
    (fragmentValue _reconstructionCost : Nat) : Nat :=
  fragmentValue

theorem local_reconstruction_value_is_monotone_in_fragment_value
    (fragmentValue₁ fragmentValue₂ reconstructionCost : Nat) :
    fragmentValue₁ <= fragmentValue₂ ->
      local_reconstruction_value fragmentValue₁ reconstructionCost <=
        local_reconstruction_value fragmentValue₂ reconstructionCost := by
  intro h
  unfold local_reconstruction_value
  omega

theorem local_reconstruction_value_is_monotone_in_reconstruction_cost
    (fragmentValue reconstructionCost₁ reconstructionCost₂ : Nat) :
    reconstructionCost₁ <= reconstructionCost₂ ->
      local_reconstruction_value fragmentValue reconstructionCost₁ <=
        local_reconstruction_value fragmentValue reconstructionCost₂ := by
  intro _h
  unfold local_reconstruction_value
  omega

structure PhysicalLocalReconstructionContext (u : InterfaceProfile) where
  connectivity_ctx : PhysicalFragmentConnectivityContext u
  reconstruction_attempt :
    connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Prop
  reconstruction_cost :
    connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  reconstruction_practically_blocked :
    connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Prop
  reconstruction_attempt_projects_to_readable_fragment_trace :
    ∀ x : connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      reconstruction_attempt x -> connectivity_ctx.readable_fragment_trace x
  reconstruction_attempt_has_positive_cost :
    ∀ x : connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
      connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      ¬ connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
      reconstruction_attempt x ->
      0 < reconstruction_cost x
  local_reconstruction_matches_underlying_readability_rule :
    ∀ x : connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      local_reconstruction_value
        (readable_fragment_value
          (connectivity_ctx.connected_fragment_count x)
          (connectivity_ctx.fragment_separation_degree x))
        (reconstruction_cost x) =
          local_unreadability_value
            (connectivity_ctx.measure_ctx.tri_ctx.blockedness_magnitude x)
            (connectivity_ctx.measure_ctx.accessibility_flag x)
            (connectivity_ctx.measure_ctx.distributed_flag x)

def QuantifiedLocalReconstructionCostInside {u : InterfaceProfile}
    (ctx : PhysicalLocalReconstructionContext u)
    (n : Nat) : Prop :=
  exists x : ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
    ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x /\
    RecordObject ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x /\
    ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x /\
    ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x /\
    ¬ ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x /\
    ctx.reconstruction_attempt x /\
    ctx.reconstruction_cost x = n

structure LowLevelLocalReconstructionTrace
    {u : InterfaceProfile}
    (ctx : PhysicalLocalReconstructionContext u) where
  carrier :
    ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj
  inside :
    ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe carrier
  record :
    RecordObject ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx carrier
  distributed :
    ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed carrier
  recovery_blocked :
    ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked carrier
  inaccessible :
    ¬ ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible carrier
  reconstruction_attempt :
    ctx.reconstruction_attempt carrier

theorem low_level_local_reconstruction_trace_gives_quantified_local_reconstruction_cost_inside
    {u : InterfaceProfile}
    {ctx : PhysicalLocalReconstructionContext u}
    (h : LowLevelLocalReconstructionTrace ctx) :
    QuantifiedLocalReconstructionCostInside ctx
      (ctx.reconstruction_cost h.carrier) := by
  exact
    ⟨h.carrier, h.inside, h.record, h.distributed, h.recovery_blocked,
      h.inaccessible, h.reconstruction_attempt, rfl⟩

def local_reconstruction_projects_to_local_readability_measure_context
    {u : InterfaceProfile}
    (ctx : PhysicalLocalReconstructionContext u) :
    PhysicalLocalReadabilityMeasureContext u :=
  { tri_ctx := ctx.connectivity_ctx.measure_ctx.tri_ctx
    local_readability_trace := ctx.reconstruction_attempt
    accessibility_flag := ctx.connectivity_ctx.measure_ctx.accessibility_flag
    distributed_flag := ctx.connectivity_ctx.measure_ctx.distributed_flag
    local_readability_cost_magnitude := fun x =>
      local_reconstruction_value
        (readable_fragment_value
          (ctx.connectivity_ctx.connected_fragment_count x)
          (ctx.connectivity_ctx.fragment_separation_degree x))
        (ctx.reconstruction_cost x)
    accessibility_flag_reflects_interface_accessible :=
      ctx.connectivity_ctx.measure_ctx.accessibility_flag_reflects_interface_accessible
    distributed_flag_reflects_distributed :=
      ctx.connectivity_ctx.measure_ctx.distributed_flag_reflects_distributed
    local_readability_cost_matches_derived_rule := by
      intro x
      exact ctx.local_reconstruction_matches_underlying_readability_rule x
    local_readability_trace_has_positive_cost := by
      intro x hInside hRecord hDistributed hBlocked hInaccessible hTrace
      have hReadable :
          ctx.connectivity_ctx.readable_fragment_trace x := by
        exact
          ctx.reconstruction_attempt_projects_to_readable_fragment_trace x hTrace
      have hFragment :
          0 < ctx.connectivity_ctx.connected_fragment_count x := by
        exact
          ctx.connectivity_ctx.readable_fragment_trace_has_positive_fragment_count
            x hInside hRecord hDistributed hBlocked hInaccessible hReadable
      unfold local_reconstruction_value
      exact
        readable_fragment_value_is_positive_of_positive_fragment_count
          (ctx.connectivity_ctx.connected_fragment_count x)
          (ctx.connectivity_ctx.fragment_separation_degree x)
          hFragment
    local_readability_cost_projects_to_tri_locality := by
      intro x hInside hRecord hDistributed hBlocked hInaccessible hTrace
      have hReadable :
          ctx.connectivity_ctx.measure_ctx.local_readability_trace x := by
        exact
          ctx.connectivity_ctx.readable_fragment_trace_projects_to_local_readability_trace
            x
            (ctx.reconstruction_attempt_projects_to_readable_fragment_trace x hTrace)
      have hUnderlying :
          ctx.connectivity_ctx.measure_ctx.tri_ctx.locality_magnitude x =
            ctx.connectivity_ctx.measure_ctx.local_readability_cost_magnitude x := by
        exact
          ctx.connectivity_ctx.measure_ctx.local_readability_cost_projects_to_tri_locality
            x hInside hRecord hDistributed hBlocked hInaccessible hReadable
      have hBoth :
          ctx.connectivity_ctx.measure_ctx.local_readability_cost_magnitude x =
            local_reconstruction_value
              (readable_fragment_value
                (ctx.connectivity_ctx.connected_fragment_count x)
                (ctx.connectivity_ctx.fragment_separation_degree x))
              (ctx.reconstruction_cost x) := by
        rw [ctx.connectivity_ctx.measure_ctx.local_readability_cost_matches_derived_rule x]
        symm
        exact ctx.local_reconstruction_matches_underlying_readability_rule x
      exact hUnderlying.trans hBoth
    }

theorem quantified_local_reconstruction_cost_projects_to_quantified_local_readability_magnitude_inside
    {u : InterfaceProfile}
    (ctx : PhysicalLocalReconstructionContext u)
    (n : Nat) :
    QuantifiedLocalReconstructionCostInside ctx n ->
      ∃ m,
        QuantifiedLocalReadabilityMagnitudeInside
          (local_readability_measure_projects_to_readability_context
            (local_reconstruction_projects_to_local_readability_measure_context ctx))
          m := by
  intro h
  rcases h with ⟨x, hInside, hRecord, hDistributed, hBlocked, hInaccessible, hTrace, hMagnitude⟩
  have hReadabilityTrace :
      (local_reconstruction_projects_to_local_readability_measure_context ctx).local_readability_trace x := hTrace
  have hMagnitude' :
      (local_readability_measure_projects_to_readability_context
          (local_reconstruction_projects_to_local_readability_measure_context ctx)).local_readability_magnitude x =
        local_reconstruction_value
          (readable_fragment_value
            (ctx.connectivity_ctx.connected_fragment_count x)
            (ctx.connectivity_ctx.fragment_separation_degree x))
          n := by
    simp [local_readability_measure_projects_to_readability_context,
      local_reconstruction_projects_to_local_readability_measure_context,
      hMagnitude]
  refine ⟨local_reconstruction_value
      (readable_fragment_value
        (ctx.connectivity_ctx.connected_fragment_count x)
        (ctx.connectivity_ctx.fragment_separation_degree x))
      n, ?_⟩
  exact
    ⟨x, hInside, hRecord, hDistributed, hBlocked, hInaccessible, hReadabilityTrace, hMagnitude'⟩

structure PhysicalReconstructionDifficultyContext (u : InterfaceProfile) where
  reconstruction_ctx : PhysicalLocalReconstructionContext u
  direct_local_readout_fails :
    reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Prop
  multi_step_reconstruction_required :
    reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Prop
  reconstruction_path_cost_positive :
    reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Prop
  physical_reconstruction_difficulty_magnitude :
    reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  physical_difficulty_trace_projects_to_local_reconstruction :
    ∀ x : reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
        RecordObject reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
          reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
            reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
              ¬ reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
                direct_local_readout_fails x ->
                  multi_step_reconstruction_required x ->
                    reconstruction_path_cost_positive x ->
                      LowLevelLocalReconstructionTrace reconstruction_ctx
  physical_difficulty_projects_to_reconstruction_cost :
    ∀ x : reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      reconstruction_ctx.reconstruction_cost x = physical_reconstruction_difficulty_magnitude x

def QuantifiedPhysicalReconstructionDifficultyInside {u : InterfaceProfile}
    (ctx : PhysicalReconstructionDifficultyContext u)
    (n : Nat) : Prop :=
  exists x :
    ctx.reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      ctx.reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x /\
      RecordObject ctx.reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x /\
      ctx.reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x /\
      ctx.reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x /\
      ¬ ctx.reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x /\
      ctx.direct_local_readout_fails x /\
      ctx.multi_step_reconstruction_required x /\
      ctx.reconstruction_path_cost_positive x /\
      ctx.physical_reconstruction_difficulty_magnitude x = n

structure LowLevelPhysicalReconstructionDifficultyTrace
    {u : InterfaceProfile}
    (ctx : PhysicalReconstructionDifficultyContext u) where
  carrier :
    ctx.reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj
  inside :
    ctx.reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe carrier
  record :
    RecordObject ctx.reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx carrier
  distributed :
    ctx.reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed carrier
  recovery_blocked :
    ctx.reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked carrier
  inaccessible :
    ¬ ctx.reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible carrier
  direct_local_readout_fails :
    ctx.direct_local_readout_fails carrier
  multi_step_reconstruction_required :
    ctx.multi_step_reconstruction_required carrier
  reconstruction_path_cost_positive :
    ctx.reconstruction_path_cost_positive carrier

theorem physical_reconstruction_difficulty_gives_local_reconstruction
    {u : InterfaceProfile}
    {ctx : PhysicalReconstructionDifficultyContext u}
    (h : LowLevelPhysicalReconstructionDifficultyTrace ctx) :
    QuantifiedPhysicalReconstructionDifficultyInside ctx
      (ctx.physical_reconstruction_difficulty_magnitude h.carrier) /\
    ∃ n, QuantifiedLocalReconstructionCostInside ctx.reconstruction_ctx n := by
  refine ⟨?_, ?_⟩
  · exact
      ⟨h.carrier, h.inside, h.record, h.distributed, h.recovery_blocked, h.inaccessible,
        h.direct_local_readout_fails, h.multi_step_reconstruction_required,
        h.reconstruction_path_cost_positive, rfl⟩
  · have hRecon :
        LowLevelLocalReconstructionTrace ctx.reconstruction_ctx :=
      ctx.physical_difficulty_trace_projects_to_local_reconstruction
        h.carrier h.inside h.record h.distributed h.recovery_blocked
        h.inaccessible h.direct_local_readout_fails
        h.multi_step_reconstruction_required h.reconstruction_path_cost_positive
    have hQuant :=
      low_level_local_reconstruction_trace_gives_quantified_local_reconstruction_cost_inside hRecon
    exact ⟨ctx.reconstruction_ctx.reconstruction_cost hRecon.carrier, hQuant⟩

theorem physical_reconstruction_difficulty_gives_quantified_local_readability_magnitude
    {u : InterfaceProfile}
    {ctx : PhysicalReconstructionDifficultyContext u}
    (h : LowLevelPhysicalReconstructionDifficultyTrace ctx) :
    ∃ m,
      QuantifiedLocalReadabilityMagnitudeInside
        (local_readability_measure_projects_to_readability_context
          (local_reconstruction_projects_to_local_readability_measure_context
            ctx.reconstruction_ctx)) m := by
  have hReconCost :
      ∃ n, QuantifiedLocalReconstructionCostInside ctx.reconstruction_ctx n :=
    (physical_reconstruction_difficulty_gives_local_reconstruction h).2
  rcases hReconCost with ⟨n, hReconCost⟩
  exact
    quantified_local_reconstruction_cost_projects_to_quantified_local_readability_magnitude_inside
      ctx.reconstruction_ctx
      n
      hReconCost

structure PhysicalRecoverabilityLossInterpretationContext (u : InterfaceProfile) where
  loss_ctx : PhysicalPredictiveLossFunctionContext u
  reconstruction_difficulty_ctx : PhysicalReconstructionDifficultyContext u
  trace_still_exists :
    loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Prop
  local_direct_access_fails :
    loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Prop
  reconstruction_cost_growth :
    loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Prop
  physical_recoverability_loss_magnitude :
    loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  physical_loss_trace_projects_to_quantified_loss :
    ∀ x : loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
        RecordObject loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
          loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
            trace_still_exists x ->
              local_direct_access_fails x ->
                reconstruction_cost_growth x ->
                  loss_ctx.recoverability_loss_magnitude x =
                    physical_recoverability_loss_magnitude x

structure LowLevelPhysicalRecoverabilityLossTrace
    {u : InterfaceProfile}
    (ctx : PhysicalRecoverabilityLossInterpretationContext u) where
  carrier : ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj
  inside :
    ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe carrier
  record :
    RecordObject ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx carrier
  recovery_blocked :
    ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked carrier
  trace_still_exists : ctx.trace_still_exists carrier
  local_direct_access_fails : ctx.local_direct_access_fails carrier
  reconstruction_cost_growth : ctx.reconstruction_cost_growth carrier

theorem physical_reconstruction_difficulty_gives_recoverability_loss_reading
    {u : InterfaceProfile}
    {ctx : PhysicalRecoverabilityLossInterpretationContext u}
    (h : LowLevelPhysicalRecoverabilityLossTrace ctx) :
    QuantifiedRecoverabilityLossAtMagnitudeInside ctx.loss_ctx
      (ctx.physical_recoverability_loss_magnitude h.carrier) := by
  refine
    ⟨h.carrier, h.inside, h.record, h.recovery_blocked, ?_⟩
  exact
    ctx.physical_loss_trace_projects_to_quantified_loss
      h.carrier h.inside h.record h.recovery_blocked h.trace_still_exists
      h.local_direct_access_fails h.reconstruction_cost_growth

theorem physical_recoverability_loss_projects_to_interface_forgetting
    {u : InterfaceProfile}
    {ctx : PhysicalRecoverabilityLossInterpretationContext u}
    (h : LowLevelPhysicalRecoverabilityLossTrace ctx) :
    InterfaceForgettingInside ctx.loss_ctx.gradient_ctx.recoverability_ctx := by
  exact
    quantified_recoverability_loss_at_magnitude_inside_gives_forgetting
      ctx.loss_ctx
      (ctx.physical_recoverability_loss_magnitude h.carrier)
      (physical_reconstruction_difficulty_gives_recoverability_loss_reading h)

theorem physical_recoverability_loss_and_full_predictive_accessibility_give_physical_predictive_limitation
    {u : InterfaceProfile}
    (ctx : PhysicalRecoverabilityLossInterpretationContext u)
    (hFull : FullPredictiveAccessibilityGradientInside ctx.loss_ctx.gradient_ctx)
    (h : LowLevelPhysicalRecoverabilityLossTrace ctx) :
    PredictiveAccessibilityAtLevelInside
      ctx.loss_ctx.gradient_ctx
      (ctx.loss_ctx.gradient_ctx.full_accessibility_level -
        ctx.physical_recoverability_loss_magnitude h.carrier) := by
  exact
    quantified_loss_and_full_predictive_accessibility_give_exact_predictive_level
      ctx.loss_ctx
      (ctx.physical_recoverability_loss_magnitude h.carrier)
      (physical_reconstruction_difficulty_gives_recoverability_loss_reading h)
      hFull

inductive EntropyBridgeCandidateAxis where
  | thermodynamics
  | decoherenceRecord
  | localAccessibility
deriving DecidableEq, Repr

structure PhysicalEntropyBridgeReadinessContext (u : InterfaceProfile) where
  recoverability_ctx : PhysicalRecoverabilityContext u
  readable_fragment_trace :
    recoverability_ctx.memory_ctx.Obj -> Prop
  trace_persistence_ready :
    recoverability_ctx.memory_ctx.Obj -> Prop
  record_dispersion_ready :
    recoverability_ctx.memory_ctx.Obj -> Prop
  local_accessibility_ready :
    recoverability_ctx.memory_ctx.Obj -> Prop
  preferred_candidate : EntropyBridgeCandidateAxis
  trace_persistence_ready_projects_to_record :
    ∀ x : recoverability_ctx.memory_ctx.Obj,
      trace_persistence_ready x -> RecordObject recoverability_ctx.memory_ctx x
  record_dispersion_ready_projects_to_record :
    ∀ x : recoverability_ctx.memory_ctx.Obj,
      record_dispersion_ready x -> RecordObject recoverability_ctx.memory_ctx x
  record_dispersion_ready_projects_to_distributed :
    ∀ x : recoverability_ctx.memory_ctx.Obj,
      record_dispersion_ready x -> recoverability_ctx.distributed x
  record_dispersion_ready_projects_to_growth :
    ∀ x : recoverability_ctx.memory_ctx.Obj,
      record_dispersion_ready x -> recoverability_ctx.recovery_cost_growth x
  local_accessibility_ready_projects_to_record :
    ∀ x : recoverability_ctx.memory_ctx.Obj,
      local_accessibility_ready x -> RecordObject recoverability_ctx.memory_ctx x
  local_accessibility_ready_projects_to_blocked :
    ∀ x : recoverability_ctx.memory_ctx.Obj,
      local_accessibility_ready x -> recoverability_ctx.recovery_practically_blocked x
  local_accessibility_ready_projects_to_inaccessibility :
    ∀ x : recoverability_ctx.memory_ctx.Obj,
      local_accessibility_ready x -> ¬ recoverability_ctx.interface_accessible x

def RecoverabilityReadinessInside {u : InterfaceProfile}
    (ctx : PhysicalEntropyBridgeReadinessContext u) : Prop :=
  exists x : ctx.recoverability_ctx.memory_ctx.Obj,
    ctx.recoverability_ctx.memory_ctx.inside_universe x /\
    ctx.trace_persistence_ready x /\
    RecordObject ctx.recoverability_ctx.memory_ctx x

def RecordDispersionReadinessInside {u : InterfaceProfile}
    (ctx : PhysicalEntropyBridgeReadinessContext u) : Prop :=
  exists x : ctx.recoverability_ctx.memory_ctx.Obj,
    ctx.recoverability_ctx.memory_ctx.inside_universe x /\
    ctx.record_dispersion_ready x /\
    ctx.recoverability_ctx.distributed x

def LocalAccessibilityReadinessInside {u : InterfaceProfile}
    (ctx : PhysicalEntropyBridgeReadinessContext u) : Prop :=
  exists x : ctx.recoverability_ctx.memory_ctx.Obj,
    ctx.recoverability_ctx.memory_ctx.inside_universe x /\
    ctx.local_accessibility_ready x /\
    RecordObject ctx.recoverability_ctx.memory_ctx x /\
    ctx.recoverability_ctx.recovery_practically_blocked x /\
    ¬ ctx.recoverability_ctx.interface_accessible x

theorem entropy_bridge_readiness_gives_bridge_neutral_entropy_shell
    {u : InterfaceProfile}
    (ctx : PhysicalEntropyBridgeReadinessContext u) :
    RecoverabilityReadinessInside ctx ->
      RecordDispersionReadinessInside ctx ->
        LocalAccessibilityReadinessInside ctx ->
          StableTraceInside ctx.recoverability_ctx.memory_ctx /\
          EntropyLikeDispersionInside ctx.recoverability_ctx /\
          InterfaceForgettingInside ctx.recoverability_ctx := by
  intro hRecoverable hDispersion hLocal
  rcases hRecoverable with ⟨x₁, hInside₁, hReady₁, hRecord₁⟩
  rcases hDispersion with ⟨x₂, hInside₂, hReady₂, hDistributed₂⟩
  rcases hLocal with ⟨x₃, hInside₃, hReady₃, hRecord₃, hBlocked₃, hInaccessible₃⟩
  refine ⟨?_, ?_, ?_⟩
  · exact ⟨x₁, hInside₁, hRecord₁⟩
  · exact
      ⟨x₂, hInside₂,
        ctx.record_dispersion_ready_projects_to_record x₂ hReady₂,
        ctx.record_dispersion_ready_projects_to_distributed x₂ hReady₂,
        ctx.record_dispersion_ready_projects_to_growth x₂ hReady₂⟩
  · exact ⟨x₃, hInside₃, hRecord₃, hBlocked₃⟩

structure PhysicalLocalInformationalAccessibilityContext (u : InterfaceProfile) where
  fragment_connectivity_ctx : PhysicalFragmentConnectivityContext u
  local_reconstruction_ctx : PhysicalLocalReconstructionContext u
  entropy_readiness_ctx : PhysicalEntropyBridgeReadinessContext u
  Carrier : Type
  inside_universe : Carrier -> Prop
  trace_exists : Carrier -> Prop
  locally_readable : Carrier -> Prop
  fragmented_across_regions : Carrier -> Prop
  reconstruction_effort_positive : Carrier -> Prop
  locally_unreadable_without_reconstruction : Carrier -> Prop
  trace_projects_to_fragment_connectivity :
    ∀ c : Carrier,
      inside_universe c ->
        trace_exists c ->
          fragmented_across_regions c ->
            locally_unreadable_without_reconstruction c ->
              reconstruction_effort_positive c ->
                LowLevelFragmentConnectivityTrace fragment_connectivity_ctx
  trace_projects_to_local_reconstruction :
    ∀ c : Carrier,
      inside_universe c ->
        trace_exists c ->
          fragmented_across_regions c ->
            locally_unreadable_without_reconstruction c ->
              reconstruction_effort_positive c ->
                LowLevelLocalReconstructionTrace local_reconstruction_ctx
  trace_projects_to_recoverability_readiness :
    ∀ c : Carrier,
      inside_universe c ->
        trace_exists c ->
          RecoverabilityReadinessInside entropy_readiness_ctx
  fragmented_trace_projects_to_dispersion_readiness :
    ∀ c : Carrier,
      inside_universe c ->
        trace_exists c ->
          fragmented_across_regions c ->
            RecordDispersionReadinessInside entropy_readiness_ctx
  unreadable_trace_projects_to_local_accessibility_readiness :
    ∀ c : Carrier,
      inside_universe c ->
        trace_exists c ->
          locally_unreadable_without_reconstruction c ->
            reconstruction_effort_positive c ->
              LocalAccessibilityReadinessInside entropy_readiness_ctx

structure LowLevelLocalInformationalAccessibilityTrace
    {u : InterfaceProfile}
    (ctx : PhysicalLocalInformationalAccessibilityContext u) where
  carrier : ctx.Carrier
  inside : ctx.inside_universe carrier
  trace_exists : ctx.trace_exists carrier
  fragmented : ctx.fragmented_across_regions carrier
  local_readability_blocked_without_reconstruction :
    ctx.locally_unreadable_without_reconstruction carrier
  reconstruction_effort_positive :
    ctx.reconstruction_effort_positive carrier

def physical_local_informational_accessibility_projects_to_fragment_connectivity_context
    {u : InterfaceProfile}
    (ctx : PhysicalLocalInformationalAccessibilityContext u) :
    PhysicalFragmentConnectivityContext u :=
  ctx.fragment_connectivity_ctx

def physical_local_informational_accessibility_projects_to_local_reconstruction_context
    {u : InterfaceProfile}
    (ctx : PhysicalLocalInformationalAccessibilityContext u) :
    PhysicalLocalReconstructionContext u :=
  ctx.local_reconstruction_ctx

def physical_local_informational_accessibility_projects_to_entropy_bridge_readiness_context
    {u : InterfaceProfile}
    (ctx : PhysicalLocalInformationalAccessibilityContext u) :
    PhysicalEntropyBridgeReadinessContext u :=
  ctx.entropy_readiness_ctx

theorem low_level_local_informational_accessibility_trace_gives_fragment_connectivity
    {u : InterfaceProfile}
    {ctx : PhysicalLocalInformationalAccessibilityContext u}
    (h : LowLevelLocalInformationalAccessibilityTrace ctx) :
    ∃ _ :
      LowLevelFragmentConnectivityTrace
        (physical_local_informational_accessibility_projects_to_fragment_connectivity_context ctx),
      True := by
  refine
    ⟨ctx.trace_projects_to_fragment_connectivity h.carrier h.inside h.trace_exists
      h.fragmented h.local_readability_blocked_without_reconstruction
      h.reconstruction_effort_positive, trivial⟩

theorem low_level_local_informational_accessibility_trace_gives_local_reconstruction
    {u : InterfaceProfile}
    {ctx : PhysicalLocalInformationalAccessibilityContext u}
    (h : LowLevelLocalInformationalAccessibilityTrace ctx) :
    ∃ _ :
      LowLevelLocalReconstructionTrace
        (physical_local_informational_accessibility_projects_to_local_reconstruction_context ctx),
      True := by
  refine
    ⟨ctx.trace_projects_to_local_reconstruction h.carrier h.inside h.trace_exists
      h.fragmented h.local_readability_blocked_without_reconstruction
      h.reconstruction_effort_positive, trivial⟩

theorem low_level_local_informational_accessibility_trace_gives_local_accessibility_readiness
    {u : InterfaceProfile}
    {ctx : PhysicalLocalInformationalAccessibilityContext u}
    (h : LowLevelLocalInformationalAccessibilityTrace ctx) :
    LocalAccessibilityReadinessInside
      (physical_local_informational_accessibility_projects_to_entropy_bridge_readiness_context ctx) := by
  exact
    ctx.unreadable_trace_projects_to_local_accessibility_readiness
      h.carrier h.inside h.trace_exists
      h.local_readability_blocked_without_reconstruction
      h.reconstruction_effort_positive

theorem low_level_local_informational_accessibility_trace_gives_bridge_neutral_entropy_shell
    {u : InterfaceProfile}
    {ctx : PhysicalLocalInformationalAccessibilityContext u}
    (h : LowLevelLocalInformationalAccessibilityTrace ctx) :
    let readinessCtx :=
      physical_local_informational_accessibility_projects_to_entropy_bridge_readiness_context ctx
    StableTraceInside readinessCtx.recoverability_ctx.memory_ctx /\
    EntropyLikeDispersionInside readinessCtx.recoverability_ctx /\
    InterfaceForgettingInside readinessCtx.recoverability_ctx := by
  let readinessCtx :=
    physical_local_informational_accessibility_projects_to_entropy_bridge_readiness_context ctx
  have hRecoverability :
      RecoverabilityReadinessInside readinessCtx := by
    exact
      ctx.trace_projects_to_recoverability_readiness
        h.carrier h.inside h.trace_exists
  have hDispersion :
      RecordDispersionReadinessInside readinessCtx := by
    exact
      ctx.fragmented_trace_projects_to_dispersion_readiness
        h.carrier h.inside h.trace_exists h.fragmented
  have hLocal :
      LocalAccessibilityReadinessInside readinessCtx := by
    exact
      ctx.unreadable_trace_projects_to_local_accessibility_readiness
        h.carrier h.inside h.trace_exists
        h.local_readability_blocked_without_reconstruction
        h.reconstruction_effort_positive
  exact
    entropy_bridge_readiness_gives_bridge_neutral_entropy_shell
      readinessCtx hRecoverability hDispersion hLocal

structure PhysicalLocalTraceCarrierContext (u : InterfaceProfile) where
  accessibility_ctx : PhysicalLocalInformationalAccessibilityContext u
  carrier_trace : accessibility_ctx.Carrier -> Prop
  low_level_carrier_projects_to_local_informational_accessibility :
    ∀ c : accessibility_ctx.Carrier,
      accessibility_ctx.inside_universe c ->
        accessibility_ctx.trace_exists c ->
          carrier_trace c ->
            accessibility_ctx.fragmented_across_regions c ->
              accessibility_ctx.locally_unreadable_without_reconstruction c ->
                accessibility_ctx.reconstruction_effort_positive c ->
                  LowLevelLocalInformationalAccessibilityTrace accessibility_ctx

structure LowLevelPhysicalLocalTraceCarrier
    {u : InterfaceProfile}
    (ctx : PhysicalLocalTraceCarrierContext u) where
  carrier : ctx.accessibility_ctx.Carrier
  inside : ctx.accessibility_ctx.inside_universe carrier
  trace_exists : ctx.accessibility_ctx.trace_exists carrier
  carrier_trace : ctx.carrier_trace carrier
  fragmented : ctx.accessibility_ctx.fragmented_across_regions carrier
  local_readability_blocked_without_reconstruction :
    ctx.accessibility_ctx.locally_unreadable_without_reconstruction carrier
  reconstruction_effort_positive :
    ctx.accessibility_ctx.reconstruction_effort_positive carrier

theorem low_level_physical_trace_carrier_gives_local_informational_accessibility
    {u : InterfaceProfile}
    {ctx : PhysicalLocalTraceCarrierContext u}
    (h : LowLevelPhysicalLocalTraceCarrier ctx) :
    ∃ _ : LowLevelLocalInformationalAccessibilityTrace ctx.accessibility_ctx, True := by
  refine
    ⟨ctx.low_level_carrier_projects_to_local_informational_accessibility
      h.carrier h.inside h.trace_exists h.carrier_trace h.fragmented
      h.local_readability_blocked_without_reconstruction
      h.reconstruction_effort_positive, trivial⟩

structure PhysicalFragmentationContext (u : InterfaceProfile) where
  measure_ctx : PhysicalLocalReadabilityMeasureContext u
  readable_fragment_trace :
    measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Prop
  connected_fragment_count :
    measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  split_degree :
    measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  readable_fragment_trace_has_positive_fragment_count :
    ∀ x : measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
      measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      ¬ measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
      readable_fragment_trace x ->
      0 < connected_fragment_count x
  readable_fragment_projects_to_local_readability_trace :
    ∀ x : measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      readable_fragment_trace x -> measure_ctx.local_readability_trace x
  readable_fragment_value_projects_to_readability_cost :
    ∀ x : measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
      measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
      measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
      ¬ measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
      readable_fragment_trace x ->
      measure_ctx.local_readability_cost_magnitude x =
        readable_fragment_value (connected_fragment_count x) (split_degree x)

def fragmentation_projects_to_readable_fragment_context
    {u : InterfaceProfile}
    (ctx : PhysicalFragmentationContext u) :
    PhysicalReadableFragmentContext u :=
  { measure_ctx := ctx.measure_ctx
    readable_fragment_trace := ctx.readable_fragment_trace
    readable_fragment_magnitude := fun x =>
      readable_fragment_value (ctx.connected_fragment_count x) (ctx.split_degree x)
    readable_fragment_trace_has_positive_magnitude := by
      intro x hInside hRecord hDistributed hBlocked hInaccessible hTrace
      exact
        readable_fragment_value_is_positive_of_positive_fragment_count
          (ctx.connected_fragment_count x)
          (ctx.split_degree x)
          (ctx.readable_fragment_trace_has_positive_fragment_count
            x hInside hRecord hDistributed hBlocked hInaccessible hTrace)
    readable_fragment_projects_to_local_readability_trace :=
      ctx.readable_fragment_projects_to_local_readability_trace
    readable_fragment_magnitude_projects_to_readability_cost := by
      intro x hInside hRecord hDistributed hBlocked hInaccessible hTrace
      exact
        ctx.readable_fragment_value_projects_to_readability_cost
          x hInside hRecord hDistributed hBlocked hInaccessible hTrace
    }

theorem low_level_fragmentation_trace_gives_quantified_local_readable_fragment_magnitude_inside
    {u : InterfaceProfile}
    {ctx : PhysicalFragmentationContext u}
    (hInside :
      LowLevelReadableFragmentTrace
        (fragmentation_projects_to_readable_fragment_context ctx)) :
    QuantifiedLocalReadableFragmentMagnitudeInside
      (fragmentation_projects_to_readable_fragment_context ctx)
      (readable_fragment_value
        (ctx.connected_fragment_count hInside.carrier)
        (ctx.split_degree hInside.carrier)) := by
  exact
    low_level_readable_fragment_trace_gives_quantified_local_readable_fragment_magnitude_inside
      hInside

def fragment_connectivity_projects_to_fragmentation_context
    {u : InterfaceProfile}
    (ctx : PhysicalFragmentConnectivityContext u) :
    PhysicalFragmentationContext u :=
  { measure_ctx := ctx.measure_ctx
    readable_fragment_trace := ctx.readable_fragment_trace
    connected_fragment_count := ctx.connected_fragment_count
    split_degree := ctx.fragment_separation_degree
    readable_fragment_trace_has_positive_fragment_count :=
      ctx.readable_fragment_trace_has_positive_fragment_count
    readable_fragment_projects_to_local_readability_trace :=
      ctx.readable_fragment_trace_projects_to_local_readability_trace
    readable_fragment_value_projects_to_readability_cost := by
      intro x hInside hRecord hDistributed hBlocked hInaccessible hTrace
      exact
        ctx.fragment_connectivity_value_projects_to_readability_cost
          x hInside hRecord hDistributed hBlocked hInaccessible hTrace }

theorem low_level_fragment_connectivity_trace_gives_quantified_local_readable_fragment_magnitude_inside
    {u : InterfaceProfile}
    {ctx : PhysicalFragmentConnectivityContext u}
    (h : LowLevelFragmentConnectivityTrace ctx) :
    QuantifiedLocalReadableFragmentMagnitudeInside
      (fragmentation_projects_to_readable_fragment_context
        (fragment_connectivity_projects_to_fragmentation_context ctx))
      (readable_fragment_value
        (ctx.connected_fragment_count h.carrier)
        (ctx.fragment_separation_degree h.carrier)) := by
  exact
    low_level_fragmentation_trace_gives_quantified_local_readable_fragment_magnitude_inside
      (ctx := fragment_connectivity_projects_to_fragmentation_context ctx)
      { carrier := h.carrier
        inside := h.inside
        record := h.record
        distributed := h.distributed
        recovery_blocked := h.recovery_blocked
        inaccessible := h.inaccessible
        readable_fragment_trace := h.readable_fragment_trace }

structure PhysicalFragmentRegionContext (u : InterfaceProfile) where
  connectivity_ctx : PhysicalFragmentConnectivityContext u
  fragment_region_membership :
    connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Prop
  separated_region_boundary :
    connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Prop
  cross_region_readout_not_direct :
    connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Prop
  region_count_value :
    connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  boundary_count_value :
    connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  region_trace_projects_to_fragment_connectivity :
    ∀ x : connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
        RecordObject connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
          connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
            connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
              ¬ connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
                fragment_region_membership x ->
                  separated_region_boundary x ->
                    cross_region_readout_not_direct x ->
                      LowLevelFragmentConnectivityTrace connectivity_ctx
  region_count_projects_to_fragment_count :
    ∀ x : connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      connectivity_ctx.connected_fragment_count x = region_count_value x
  boundary_count_projects_to_split_degree :
    ∀ x : connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      connectivity_ctx.fragment_separation_degree x = boundary_count_value x

structure LowLevelFragmentRegionTrace
    {u : InterfaceProfile}
    (ctx : PhysicalFragmentRegionContext u) where
  carrier : ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj
  inside :
    ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe carrier
  record :
    RecordObject ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx carrier
  distributed :
    ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed carrier
  recovery_blocked :
    ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked carrier
  inaccessible :
    ¬ ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible carrier
  region_membership :
    ctx.fragment_region_membership carrier
  separated_boundary :
    ctx.separated_region_boundary carrier
  cross_region_readout_not_direct :
    ctx.cross_region_readout_not_direct carrier

theorem physical_fragment_regions_give_fragment_connectivity
    {u : InterfaceProfile}
    {ctx : PhysicalFragmentRegionContext u}
    (h : LowLevelFragmentRegionTrace ctx) :
    ∃ _ : LowLevelFragmentConnectivityTrace ctx.connectivity_ctx, True := by
  refine
    ⟨ctx.region_trace_projects_to_fragment_connectivity
      h.carrier h.inside h.record h.distributed h.recovery_blocked
      h.inaccessible h.region_membership h.separated_boundary
      h.cross_region_readout_not_direct, trivial⟩

theorem physical_fragment_regions_give_quantified_fragment_component_count_inside
    {u : InterfaceProfile}
    {ctx : PhysicalFragmentRegionContext u}
    (h : LowLevelFragmentRegionTrace ctx) :
    ∃ n, QuantifiedFragmentComponentCountInside ctx.connectivity_ctx n := by
  rcases physical_fragment_regions_give_fragment_connectivity h with ⟨hConn, _⟩
  have hQuant :=
    low_level_fragment_connectivity_trace_gives_quantified_fragment_component_count_inside hConn
  exact ⟨ctx.connectivity_ctx.connected_fragment_count hConn.carrier, hQuant⟩

theorem physical_fragment_regions_give_quantified_fragment_split_degree_inside
    {u : InterfaceProfile}
    {ctx : PhysicalFragmentRegionContext u}
    (h : LowLevelFragmentRegionTrace ctx) :
    ∃ n, QuantifiedFragmentSplitDegreeInside ctx.connectivity_ctx n := by
  rcases physical_fragment_regions_give_fragment_connectivity h with ⟨hConn, _⟩
  have hQuant :=
    low_level_fragment_connectivity_trace_gives_quantified_fragment_split_degree_inside hConn
  exact ⟨ctx.connectivity_ctx.fragment_separation_degree hConn.carrier, hQuant⟩

theorem physical_fragment_regions_give_readable_fragment_magnitude
    {u : InterfaceProfile}
    {ctx : PhysicalFragmentRegionContext u}
    (h : LowLevelFragmentRegionTrace ctx) :
    ∃ n,
      QuantifiedLocalReadableFragmentMagnitudeInside
        (fragmentation_projects_to_readable_fragment_context
          (fragment_connectivity_projects_to_fragmentation_context ctx.connectivity_ctx))
        n := by
  rcases physical_fragment_regions_give_fragment_connectivity h with ⟨hConn, _⟩
  have hMag :=
    low_level_fragment_connectivity_trace_gives_quantified_local_readable_fragment_magnitude_inside
      hConn
  exact
    ⟨readable_fragment_value
      (ctx.connectivity_ctx.connected_fragment_count hConn.carrier)
      (ctx.connectivity_ctx.fragment_separation_degree hConn.carrier), hMag⟩

structure FirstPhysicalBridgeReadyForNextPhysicsWitness (u : InterfaceProfile) where
  carrier_ctx : PhysicalLocalTraceCarrierContext u
  carrier_trace : LowLevelPhysicalLocalTraceCarrier carrier_ctx
  region_ctx : PhysicalFragmentRegionContext u
  region_trace : LowLevelFragmentRegionTrace region_ctx
  reconstruction_difficulty_ctx : PhysicalReconstructionDifficultyContext u
  reconstruction_difficulty_trace :
    LowLevelPhysicalReconstructionDifficultyTrace reconstruction_difficulty_ctx
  recoverability_loss_ctx : PhysicalRecoverabilityLossInterpretationContext u
  recoverability_loss_trace :
    LowLevelPhysicalRecoverabilityLossTrace recoverability_loss_ctx
  full_predictive_accessibility :
    FullPredictiveAccessibilityGradientInside recoverability_loss_ctx.loss_ctx.gradient_ctx

def FirstPhysicalBridgeReadyForNextPhysics {u : InterfaceProfile}
    (w : FirstPhysicalBridgeReadyForNextPhysicsWitness u) : Prop :=
  (∃ _ : LowLevelLocalInformationalAccessibilityTrace w.carrier_ctx.accessibility_ctx, True) /\
  (∃ _ : LowLevelFragmentConnectivityTrace w.region_ctx.connectivity_ctx, True) /\
  (∃ n,
    QuantifiedLocalReadableFragmentMagnitudeInside
      (fragmentation_projects_to_readable_fragment_context
        (fragment_connectivity_projects_to_fragmentation_context
          w.region_ctx.connectivity_ctx))
      n) /\
  QuantifiedPhysicalReconstructionDifficultyInside
    w.reconstruction_difficulty_ctx
    (w.reconstruction_difficulty_ctx.physical_reconstruction_difficulty_magnitude
      w.reconstruction_difficulty_trace.carrier) /\
  QuantifiedRecoverabilityLossAtMagnitudeInside
    w.recoverability_loss_ctx.loss_ctx
    (w.recoverability_loss_ctx.physical_recoverability_loss_magnitude
      w.recoverability_loss_trace.carrier) /\
  PredictiveAccessibilityAtLevelInside
    w.recoverability_loss_ctx.loss_ctx.gradient_ctx
    (w.recoverability_loss_ctx.loss_ctx.gradient_ctx.full_accessibility_level -
      w.recoverability_loss_ctx.physical_recoverability_loss_magnitude
        w.recoverability_loss_trace.carrier)

theorem first_physical_bridge_ready_for_next_physics_witness_is_ready
    {u : InterfaceProfile}
    (w : FirstPhysicalBridgeReadyForNextPhysicsWitness u) :
    FirstPhysicalBridgeReadyForNextPhysics w := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · exact low_level_physical_trace_carrier_gives_local_informational_accessibility w.carrier_trace
  · exact physical_fragment_regions_give_fragment_connectivity w.region_trace
  · exact physical_fragment_regions_give_readable_fragment_magnitude w.region_trace
  · exact
      (physical_reconstruction_difficulty_gives_local_reconstruction
        w.reconstruction_difficulty_trace).1
  · exact
      physical_reconstruction_difficulty_gives_recoverability_loss_reading
        w.recoverability_loss_trace
  · exact
      physical_recoverability_loss_and_full_predictive_accessibility_give_physical_predictive_limitation
        w.recoverability_loss_ctx
        w.full_predictive_accessibility
        w.recoverability_loss_trace

structure PhysicalThermodynamicOverlayContext (u : InterfaceProfile) where
  bridge_witness : FirstPhysicalBridgeReadyForNextPhysicsWitness u
  bridge_ready : FirstPhysicalBridgeReadyForNextPhysics bridge_witness
  recoverability_loss_ctx : PhysicalRecoverabilityLossInterpretationContext u
  Carrier : Type
  inside_universe : Carrier -> Prop
  thermodynamic_process : Carrier -> Prop
  entropy_like_growth : Carrier -> Prop
  macroscopic_irreversibility : Carrier -> Prop
  record_not_annihilated : Carrier -> Prop
  projects_to_recoverability_stress : Carrier -> Prop
  irreversibility_projects_to_recoverability_stress :
    ∀ c : Carrier,
      inside_universe c ->
        thermodynamic_process c ->
          entropy_like_growth c ->
            macroscopic_irreversibility c ->
              record_not_annihilated c ->
                projects_to_recoverability_stress c
  thermodynamic_overlay_projects_to_loss_trace :
    ∀ c : Carrier,
      inside_universe c ->
        thermodynamic_process c ->
          entropy_like_growth c ->
            macroscopic_irreversibility c ->
              record_not_annihilated c ->
                projects_to_recoverability_stress c ->
                  LowLevelPhysicalRecoverabilityLossTrace recoverability_loss_ctx
  thermodynamic_overlay_projects_to_memory_thermodynamic_trace :
    ∀ c : Carrier,
      inside_universe c ->
        thermodynamic_process c ->
          entropy_like_growth c ->
            macroscopic_irreversibility c ->
              record_not_annihilated c ->
                ThermodynamicTraceWitness
                  recoverability_loss_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx

structure LowLevelThermodynamicOverlayTrace
    {u : InterfaceProfile}
    (ctx : PhysicalThermodynamicOverlayContext u) where
  carrier : ctx.Carrier
  inside : ctx.inside_universe carrier
  thermodynamic_process : ctx.thermodynamic_process carrier
  entropy_like_growth : ctx.entropy_like_growth carrier
  macroscopic_irreversibility : ctx.macroscopic_irreversibility carrier
  record_not_annihilated : ctx.record_not_annihilated carrier

def ThermodynamicIrreversibilityInside {u : InterfaceProfile}
    (ctx : PhysicalThermodynamicOverlayContext u) : Prop :=
  exists c : ctx.Carrier,
    ctx.inside_universe c /\
    ctx.thermodynamic_process c /\
    ctx.entropy_like_growth c /\
    ctx.macroscopic_irreversibility c /\
    ctx.record_not_annihilated c

def ThermodynamicRecoverabilityPressureInside {u : InterfaceProfile}
    (ctx : PhysicalThermodynamicOverlayContext u) : Prop :=
  exists c : ctx.Carrier,
    ctx.inside_universe c /\
    ctx.thermodynamic_process c /\
    ctx.entropy_like_growth c /\
    ctx.macroscopic_irreversibility c /\
    ctx.record_not_annihilated c /\
    ctx.projects_to_recoverability_stress c

def ThermodynamicStrengthenedForgettingInside {u : InterfaceProfile}
    (ctx : PhysicalThermodynamicOverlayContext u) : Prop :=
  ThermodynamicRecoverabilityPressureInside ctx /\
  InterfaceForgettingInside
    ctx.recoverability_loss_ctx.loss_ctx.gradient_ctx.recoverability_ctx

theorem low_level_thermodynamic_overlay_gives_irreversibility_inside
    {u : InterfaceProfile}
    {ctx : PhysicalThermodynamicOverlayContext u}
    (h : LowLevelThermodynamicOverlayTrace ctx) :
    ThermodynamicIrreversibilityInside ctx := by
  exact
    ⟨h.carrier, h.inside, h.thermodynamic_process, h.entropy_like_growth,
      h.macroscopic_irreversibility, h.record_not_annihilated⟩

theorem thermodynamic_irreversibility_gives_recoverability_pressure
    {u : InterfaceProfile}
    (ctx : PhysicalThermodynamicOverlayContext u) :
    ThermodynamicIrreversibilityInside ctx ->
      ThermodynamicRecoverabilityPressureInside ctx := by
  intro h
  rcases h with ⟨c, hInside, hProcess, hGrowth, hIrreversible, hRecord⟩
  exact
    ⟨c, hInside, hProcess, hGrowth, hIrreversible, hRecord,
      ctx.irreversibility_projects_to_recoverability_stress
        c hInside hProcess hGrowth hIrreversible hRecord⟩

theorem thermodynamic_pressure_projects_to_physical_recoverability_loss
    {u : InterfaceProfile}
    {ctx : PhysicalThermodynamicOverlayContext u}
    (h : ThermodynamicRecoverabilityPressureInside ctx) :
    ∃ n,
      QuantifiedRecoverabilityLossAtMagnitudeInside
        ctx.recoverability_loss_ctx.loss_ctx n := by
  rcases h with ⟨c, hInside, hProcess, hGrowth, hIrreversible, hRecord, hStress⟩
  let hLoss :=
    ctx.thermodynamic_overlay_projects_to_loss_trace
      c hInside hProcess hGrowth hIrreversible hRecord hStress
  exact
    ⟨ctx.recoverability_loss_ctx.physical_recoverability_loss_magnitude hLoss.carrier,
      physical_reconstruction_difficulty_gives_recoverability_loss_reading hLoss⟩

theorem thermodynamic_overlay_is_compatible_with_memory_thermodynamic_trace
    {u : InterfaceProfile}
    {ctx : PhysicalThermodynamicOverlayContext u}
    (h : LowLevelThermodynamicOverlayTrace ctx) :
    ThermodynamicTraceWitness
      ctx.recoverability_loss_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx := by
  exact
    ctx.thermodynamic_overlay_projects_to_memory_thermodynamic_trace
      h.carrier h.inside h.thermodynamic_process h.entropy_like_growth
      h.macroscopic_irreversibility h.record_not_annihilated

theorem thermodynamic_overlay_gives_strengthened_forgetting
    {u : InterfaceProfile}
    {ctx : PhysicalThermodynamicOverlayContext u}
    (h : LowLevelThermodynamicOverlayTrace ctx) :
    ThermodynamicStrengthenedForgettingInside ctx := by
  have hPressure :
      ThermodynamicRecoverabilityPressureInside ctx := by
    exact
      thermodynamic_irreversibility_gives_recoverability_pressure ctx
        (low_level_thermodynamic_overlay_gives_irreversibility_inside h)
  rcases hPressure with
    ⟨c, hInside, hProcess, hGrowth, hIrreversible, hRecord, hStress⟩
  let hLoss :=
    ctx.thermodynamic_overlay_projects_to_loss_trace
      c hInside hProcess hGrowth hIrreversible hRecord hStress
  exact
    ⟨⟨c, hInside, hProcess, hGrowth, hIrreversible, hRecord, hStress⟩,
      physical_recoverability_loss_projects_to_interface_forgetting hLoss⟩

theorem thermodynamic_pressure_and_full_predictive_accessibility_give_thermodynamic_predictive_limitation
    {u : InterfaceProfile}
    (ctx : PhysicalThermodynamicOverlayContext u)
    (hFull :
      FullPredictiveAccessibilityGradientInside
        ctx.recoverability_loss_ctx.loss_ctx.gradient_ctx)
    (h : ThermodynamicRecoverabilityPressureInside ctx) :
    ∃ n,
      PredictiveAccessibilityAtLevelInside
        ctx.recoverability_loss_ctx.loss_ctx.gradient_ctx
        (ctx.recoverability_loss_ctx.loss_ctx.gradient_ctx.full_accessibility_level - n) := by
  rcases h with ⟨c, hInside, hProcess, hGrowth, hIrreversible, hRecord, hStress⟩
  let hLoss :=
    ctx.thermodynamic_overlay_projects_to_loss_trace
      c hInside hProcess hGrowth hIrreversible hRecord hStress
  exact
    ⟨ctx.recoverability_loss_ctx.physical_recoverability_loss_magnitude hLoss.carrier,
      physical_recoverability_loss_and_full_predictive_accessibility_give_physical_predictive_limitation
        ctx.recoverability_loss_ctx hFull hLoss⟩

structure PhysicalThermodynamicRecoverabilityRefinementContext (u : InterfaceProfile) where
  overlay_ctx : PhysicalThermodynamicOverlayContext u
  thermodynamic_stress_magnitude : overlay_ctx.Carrier -> Nat
  thermodynamic_loss_magnitude : overlay_ctx.Carrier -> Nat
  positive_stress_of_refinement :
    ∀ c : overlay_ctx.Carrier,
      overlay_ctx.inside_universe c ->
        overlay_ctx.thermodynamic_process c ->
          overlay_ctx.entropy_like_growth c ->
            overlay_ctx.macroscopic_irreversibility c ->
              overlay_ctx.record_not_annihilated c ->
                0 < thermodynamic_stress_magnitude c
  thermodynamic_loss_matches_physical_loss :
    ∀ (c : overlay_ctx.Carrier)
      (hInside : overlay_ctx.inside_universe c)
      (hProcess : overlay_ctx.thermodynamic_process c)
      (hGrowth : overlay_ctx.entropy_like_growth c)
      (hIrreversible : overlay_ctx.macroscopic_irreversibility c)
      (hRecord : overlay_ctx.record_not_annihilated c),
        thermodynamic_loss_magnitude c =
          overlay_ctx.recoverability_loss_ctx.physical_recoverability_loss_magnitude
            ((overlay_ctx.thermodynamic_overlay_projects_to_loss_trace
                c
                hInside
                hProcess
                hGrowth
                hIrreversible
                hRecord
                (overlay_ctx.irreversibility_projects_to_recoverability_stress
                  c hInside hProcess hGrowth hIrreversible hRecord)).carrier)

structure LowLevelThermodynamicRecoverabilityRefinementTrace
    {u : InterfaceProfile}
    (ctx : PhysicalThermodynamicRecoverabilityRefinementContext u) where
  carrier : ctx.overlay_ctx.Carrier
  inside : ctx.overlay_ctx.inside_universe carrier
  thermodynamic_process : ctx.overlay_ctx.thermodynamic_process carrier
  entropy_like_growth : ctx.overlay_ctx.entropy_like_growth carrier
  macroscopic_irreversibility : ctx.overlay_ctx.macroscopic_irreversibility carrier
  record_not_annihilated : ctx.overlay_ctx.record_not_annihilated carrier

def QuantifiedThermodynamicStressMagnitudeInside {u : InterfaceProfile}
    (ctx : PhysicalThermodynamicRecoverabilityRefinementContext u)
    (n : Nat) : Prop :=
  exists c : ctx.overlay_ctx.Carrier,
    ctx.overlay_ctx.inside_universe c /\
    ctx.overlay_ctx.thermodynamic_process c /\
    ctx.overlay_ctx.entropy_like_growth c /\
    ctx.overlay_ctx.macroscopic_irreversibility c /\
    ctx.overlay_ctx.record_not_annihilated c /\
    ctx.thermodynamic_stress_magnitude c = n

def QuantifiedThermodynamicRecoverabilityLossAtMagnitudeInside {u : InterfaceProfile}
    (ctx : PhysicalThermodynamicRecoverabilityRefinementContext u)
    (n : Nat) : Prop :=
  exists c : ctx.overlay_ctx.Carrier,
    ctx.overlay_ctx.inside_universe c /\
    ctx.overlay_ctx.thermodynamic_process c /\
    ctx.overlay_ctx.entropy_like_growth c /\
    ctx.overlay_ctx.macroscopic_irreversibility c /\
    ctx.overlay_ctx.record_not_annihilated c /\
    ctx.thermodynamic_loss_magnitude c = n

theorem low_level_thermodynamic_refinement_trace_gives_quantified_stress_magnitude
    {u : InterfaceProfile}
    {ctx : PhysicalThermodynamicRecoverabilityRefinementContext u}
    (h : LowLevelThermodynamicRecoverabilityRefinementTrace ctx) :
    QuantifiedThermodynamicStressMagnitudeInside ctx
      (ctx.thermodynamic_stress_magnitude h.carrier) := by
  exact
    ⟨h.carrier, h.inside, h.thermodynamic_process, h.entropy_like_growth,
      h.macroscopic_irreversibility, h.record_not_annihilated, rfl⟩

theorem thermodynamic_refinement_projects_to_quantified_recoverability_loss
    {u : InterfaceProfile}
    {ctx : PhysicalThermodynamicRecoverabilityRefinementContext u}
    (h : LowLevelThermodynamicRecoverabilityRefinementTrace ctx) :
    QuantifiedThermodynamicRecoverabilityLossAtMagnitudeInside ctx
      (ctx.thermodynamic_loss_magnitude h.carrier) /\
    QuantifiedRecoverabilityLossAtMagnitudeInside
      ctx.overlay_ctx.recoverability_loss_ctx.loss_ctx
      (ctx.thermodynamic_loss_magnitude h.carrier) := by
  have hStress :
      ctx.overlay_ctx.projects_to_recoverability_stress h.carrier := by
    exact
      ctx.overlay_ctx.irreversibility_projects_to_recoverability_stress
        h.carrier h.inside h.thermodynamic_process h.entropy_like_growth
        h.macroscopic_irreversibility h.record_not_annihilated
  let hLoss :=
    ctx.overlay_ctx.thermodynamic_overlay_projects_to_loss_trace
      h.carrier h.inside h.thermodynamic_process h.entropy_like_growth
      h.macroscopic_irreversibility h.record_not_annihilated hStress
  have hEq :
      ctx.thermodynamic_loss_magnitude h.carrier =
        ctx.overlay_ctx.recoverability_loss_ctx.physical_recoverability_loss_magnitude
          hLoss.carrier := by
    exact
      ctx.thermodynamic_loss_matches_physical_loss
        h.carrier h.inside h.thermodynamic_process h.entropy_like_growth
        h.macroscopic_irreversibility h.record_not_annihilated
  constructor
  · exact
      ⟨h.carrier, h.inside, h.thermodynamic_process, h.entropy_like_growth,
        h.macroscopic_irreversibility, h.record_not_annihilated, rfl⟩
  · rw [hEq]
    exact
      physical_reconstruction_difficulty_gives_recoverability_loss_reading hLoss

theorem thermodynamic_refinement_projects_to_interface_forgetting
    {u : InterfaceProfile}
    {ctx : PhysicalThermodynamicRecoverabilityRefinementContext u}
    (h : LowLevelThermodynamicRecoverabilityRefinementTrace ctx) :
    InterfaceForgettingInside
      ctx.overlay_ctx.recoverability_loss_ctx.loss_ctx.gradient_ctx.recoverability_ctx := by
  exact
    quantified_recoverability_loss_at_magnitude_inside_gives_forgetting
      ctx.overlay_ctx.recoverability_loss_ctx.loss_ctx
      (ctx.thermodynamic_loss_magnitude h.carrier)
      (thermodynamic_refinement_projects_to_quantified_recoverability_loss h).2

theorem thermodynamic_refinement_and_full_predictive_accessibility_give_exact_predictive_level
    {u : InterfaceProfile}
    (ctx : PhysicalThermodynamicRecoverabilityRefinementContext u)
    (hFull :
      FullPredictiveAccessibilityGradientInside
        ctx.overlay_ctx.recoverability_loss_ctx.loss_ctx.gradient_ctx)
    (h : LowLevelThermodynamicRecoverabilityRefinementTrace ctx) :
    PredictiveAccessibilityAtLevelInside
      ctx.overlay_ctx.recoverability_loss_ctx.loss_ctx.gradient_ctx
      (ctx.overlay_ctx.recoverability_loss_ctx.loss_ctx.gradient_ctx.full_accessibility_level -
        ctx.thermodynamic_loss_magnitude h.carrier) := by
  exact
    quantified_loss_and_full_predictive_accessibility_give_exact_predictive_level
      ctx.overlay_ctx.recoverability_loss_ctx.loss_ctx
      (ctx.thermodynamic_loss_magnitude h.carrier)
      (thermodynamic_refinement_projects_to_quantified_recoverability_loss h).2
      hFull

structure PhysicalQuantumRecordContext (u : InterfaceProfile) where
  memory_ctx : PhysicalMemoryContext u
  QCarrier : Type
  inside_universe : QCarrier -> Prop
  interaction_event : QCarrier -> Prop
  alternative_branching : QCarrier -> Prop
  environmental_imprint : QCarrier -> Prop
  branch_separation : QCarrier -> Prop
  outcome_record_stabilized : QCarrier -> Prop
  record_carrier_of : QCarrier -> memory_ctx.Obj
  stabilized_record_projects_to_record_object :
    ∀ q : QCarrier,
      inside_universe q ->
        interaction_event q ->
          alternative_branching q ->
            environmental_imprint q ->
              branch_separation q ->
                outcome_record_stabilized q ->
                  memory_ctx.inside_universe (record_carrier_of q) /\
                  RecordObject memory_ctx (record_carrier_of q)
  stabilized_record_projects_to_measurement_record :
    ∀ q : QCarrier,
      inside_universe q ->
        interaction_event q ->
          alternative_branching q ->
            environmental_imprint q ->
              branch_separation q ->
                outcome_record_stabilized q ->
                  memory_ctx.measurement_record (record_carrier_of q)

structure LowLevelQuantumRecordTrace
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordContext u) where
  carrier : ctx.QCarrier
  inside : ctx.inside_universe carrier
  interaction_event : ctx.interaction_event carrier
  alternative_branching : ctx.alternative_branching carrier
  environmental_imprint : ctx.environmental_imprint carrier
  branch_separation : ctx.branch_separation carrier
  outcome_record_stabilized : ctx.outcome_record_stabilized carrier

def DecoherenceBranchSeparationInside {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordContext u) : Prop :=
  exists q : ctx.QCarrier,
    ctx.inside_universe q /\
    ctx.interaction_event q /\
    ctx.alternative_branching q /\
    ctx.branch_separation q

def EnvironmentalImprintInside {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordContext u) : Prop :=
  exists q : ctx.QCarrier,
    ctx.inside_universe q /\
    ctx.interaction_event q /\
    ctx.environmental_imprint q

def StableOutcomeRecordInside {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordContext u) : Prop :=
  exists q : ctx.QCarrier,
    ctx.inside_universe q /\
    ctx.interaction_event q /\
    ctx.alternative_branching q /\
    ctx.environmental_imprint q /\
    ctx.branch_separation q /\
    ctx.outcome_record_stabilized q

def QuantumRecordFormationInside {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordContext u) : Prop :=
  DecoherenceBranchSeparationInside ctx /\
  EnvironmentalImprintInside ctx /\
  StableOutcomeRecordInside ctx

theorem low_level_quantum_record_trace_gives_branch_separation_inside
    {u : InterfaceProfile}
    {ctx : PhysicalQuantumRecordContext u}
    (h : LowLevelQuantumRecordTrace ctx) :
    DecoherenceBranchSeparationInside ctx := by
  exact
    ⟨h.carrier, h.inside, h.interaction_event, h.alternative_branching,
      h.branch_separation⟩

theorem low_level_quantum_record_trace_gives_environmental_imprint_inside
    {u : InterfaceProfile}
    {ctx : PhysicalQuantumRecordContext u}
    (h : LowLevelQuantumRecordTrace ctx) :
    EnvironmentalImprintInside ctx := by
  exact ⟨h.carrier, h.inside, h.interaction_event, h.environmental_imprint⟩

theorem low_level_quantum_record_trace_gives_stable_outcome_record_inside
    {u : InterfaceProfile}
    {ctx : PhysicalQuantumRecordContext u}
    (h : LowLevelQuantumRecordTrace ctx) :
    StableOutcomeRecordInside ctx := by
  exact
    ⟨h.carrier, h.inside, h.interaction_event, h.alternative_branching,
      h.environmental_imprint, h.branch_separation, h.outcome_record_stabilized⟩

theorem low_level_quantum_record_trace_gives_quantum_record_formation_inside
    {u : InterfaceProfile}
    {ctx : PhysicalQuantumRecordContext u}
    (h : LowLevelQuantumRecordTrace ctx) :
    QuantumRecordFormationInside ctx := by
  exact
    ⟨low_level_quantum_record_trace_gives_branch_separation_inside h,
      low_level_quantum_record_trace_gives_environmental_imprint_inside h,
      low_level_quantum_record_trace_gives_stable_outcome_record_inside h⟩

theorem stable_outcome_record_inside_gives_stable_trace_inside
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordContext u) :
    StableOutcomeRecordInside ctx -> StableTraceInside ctx.memory_ctx := by
  intro h
  rcases h with
    ⟨q, hInside, hInteraction, hBranching, hImprint, hSeparation, hStableOutcome⟩
  rcases
    ctx.stabilized_record_projects_to_record_object
      q hInside hInteraction hBranching hImprint hSeparation hStableOutcome with
    ⟨hRecordInside, hRecordObject⟩
  exact ⟨ctx.record_carrier_of q, hRecordInside, hRecordObject⟩

theorem stable_outcome_record_inside_gives_measurement_record_witness
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordContext u) :
    StableOutcomeRecordInside ctx -> MeasurementRecordWitness ctx.memory_ctx := by
  intro h
  rcases h with
    ⟨q, hInside, hInteraction, hBranching, hImprint, hSeparation, hStableOutcome⟩
  rcases
    ctx.stabilized_record_projects_to_record_object
      q hInside hInteraction hBranching hImprint hSeparation hStableOutcome with
    ⟨hRecordInside, hRecordObject⟩
  exact
    ⟨ctx.record_carrier_of q,
      hRecordInside,
      ctx.stabilized_record_projects_to_measurement_record
        q hInside hInteraction hBranching hImprint hSeparation hStableOutcome,
      hRecordObject⟩

theorem quantum_record_formation_projects_to_physical_record_bridge
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordContext u) :
    QuantumRecordFormationInside ctx -> PhysicalRecordBridge u := by
  intro h
  exact
    stable_trace_inside_gives_physical_record_bridge
      ctx.memory_ctx
      (stable_outcome_record_inside_gives_stable_trace_inside ctx h.2.2)

structure PhysicalQuantumThermodynamicCompatibilityContext (u : InterfaceProfile) where
  quantum_ctx : PhysicalQuantumRecordContext u
  thermodynamic_ctx : PhysicalThermodynamicRecoverabilityRefinementContext u
  compatible_quantum_trace :
    quantum_ctx.QCarrier -> thermodynamic_ctx.overlay_ctx.Carrier -> Prop
  compatible_trace_preserves_record :
    ∀ q : quantum_ctx.QCarrier,
      ∀ t : thermodynamic_ctx.overlay_ctx.Carrier,
        quantum_ctx.inside_universe q ->
          quantum_ctx.interaction_event q ->
            quantum_ctx.alternative_branching q ->
              quantum_ctx.environmental_imprint q ->
                quantum_ctx.branch_separation q ->
                  quantum_ctx.outcome_record_stabilized q ->
                    thermodynamic_ctx.overlay_ctx.inside_universe t ->
                      thermodynamic_ctx.overlay_ctx.thermodynamic_process t ->
                        thermodynamic_ctx.overlay_ctx.entropy_like_growth t ->
                          thermodynamic_ctx.overlay_ctx.macroscopic_irreversibility t ->
                            thermodynamic_ctx.overlay_ctx.record_not_annihilated t ->
                              compatible_quantum_trace q t

theorem quantum_record_is_compatible_with_thermodynamic_recoverability_refinement
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumThermodynamicCompatibilityContext u)
    (hq : StableOutcomeRecordInside ctx.quantum_ctx)
    (ht : LowLevelThermodynamicRecoverabilityRefinementTrace ctx.thermodynamic_ctx) :
    ∃ q : ctx.quantum_ctx.QCarrier,
      ctx.compatible_quantum_trace q ht.carrier := by
  rcases hq with
    ⟨q, hInside, hInteraction, hBranching, hImprint, hSeparation, hStableOutcome⟩
  exact
    ⟨q,
      ctx.compatible_trace_preserves_record
        q ht.carrier hInside hInteraction hBranching hImprint hSeparation
        hStableOutcome ht.inside ht.thermodynamic_process
        ht.entropy_like_growth ht.macroscopic_irreversibility
        ht.record_not_annihilated⟩

theorem quantum_record_plus_thermodynamic_pressure_preserve_record_without_immediate_annihilation
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumThermodynamicCompatibilityContext u)
    (hq : StableOutcomeRecordInside ctx.quantum_ctx)
    (ht : LowLevelThermodynamicRecoverabilityRefinementTrace ctx.thermodynamic_ctx) :
    StableTraceInside ctx.quantum_ctx.memory_ctx /\
    ctx.thermodynamic_ctx.overlay_ctx.record_not_annihilated ht.carrier := by
  exact
    ⟨stable_outcome_record_inside_gives_stable_trace_inside ctx.quantum_ctx hq,
      ht.record_not_annihilated⟩

theorem quantum_record_plus_thermodynamic_pressure_can_project_to_recoverability_loss_reading
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumThermodynamicCompatibilityContext u)
    (hq : StableOutcomeRecordInside ctx.quantum_ctx)
    (ht : LowLevelThermodynamicRecoverabilityRefinementTrace ctx.thermodynamic_ctx) :
    StableTraceInside ctx.quantum_ctx.memory_ctx /\
    QuantifiedRecoverabilityLossAtMagnitudeInside
      ctx.thermodynamic_ctx.overlay_ctx.recoverability_loss_ctx.loss_ctx
      (ctx.thermodynamic_ctx.thermodynamic_loss_magnitude ht.carrier) := by
  exact
    ⟨stable_outcome_record_inside_gives_stable_trace_inside ctx.quantum_ctx hq,
      (thermodynamic_refinement_projects_to_quantified_recoverability_loss ht).2⟩

structure PhysicalQuantumRecordLocalAccessibilityFeedContext (u : InterfaceProfile) where
  quantum_ctx : PhysicalQuantumRecordContext u
  local_accessibility_ctx : PhysicalLocalInformationalAccessibilityContext u
  low_level_quantum_record_trace_projects_to_local_accessibility_trace :
    LowLevelQuantumRecordTrace quantum_ctx ->
      LowLevelLocalInformationalAccessibilityTrace local_accessibility_ctx

def quantum_record_projects_to_local_informational_accessibility_trace
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordLocalAccessibilityFeedContext u)
    (h : LowLevelQuantumRecordTrace ctx.quantum_ctx) :
    LowLevelLocalInformationalAccessibilityTrace ctx.local_accessibility_ctx := by
  exact
    ctx.low_level_quantum_record_trace_projects_to_local_accessibility_trace h

theorem quantum_record_projects_to_fragment_connectivity_surface
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordLocalAccessibilityFeedContext u)
    (h : LowLevelQuantumRecordTrace ctx.quantum_ctx) :
    ∃ _ :
      LowLevelFragmentConnectivityTrace ctx.local_accessibility_ctx.fragment_connectivity_ctx,
      True := by
  exact
    low_level_local_informational_accessibility_trace_gives_fragment_connectivity
      (ctx := ctx.local_accessibility_ctx)
      (quantum_record_projects_to_local_informational_accessibility_trace ctx h)

theorem quantum_record_projects_to_local_reconstruction_surface
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordLocalAccessibilityFeedContext u)
    (h : LowLevelQuantumRecordTrace ctx.quantum_ctx) :
    ∃ _ :
      LowLevelLocalReconstructionTrace ctx.local_accessibility_ctx.local_reconstruction_ctx,
      True := by
  exact
    low_level_local_informational_accessibility_trace_gives_local_reconstruction
      (ctx := ctx.local_accessibility_ctx)
      (quantum_record_projects_to_local_informational_accessibility_trace ctx h)

theorem quantum_record_projects_to_local_readability_surface
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordLocalAccessibilityFeedContext u)
    (h : LowLevelQuantumRecordTrace ctx.quantum_ctx) :
    ∃ m,
      QuantifiedLocalReadabilityMagnitudeInside
        (local_readability_measure_projects_to_readability_context
          (local_reconstruction_projects_to_local_readability_measure_context
            ctx.local_accessibility_ctx.local_reconstruction_ctx)) m := by
  rcases
    low_level_local_informational_accessibility_trace_gives_local_reconstruction
      (ctx := ctx.local_accessibility_ctx)
      (quantum_record_projects_to_local_informational_accessibility_trace ctx h)
    with ⟨hRecon, _⟩
  exact
    quantified_local_reconstruction_cost_projects_to_quantified_local_readability_magnitude_inside
      ctx.local_accessibility_ctx.local_reconstruction_ctx
      (ctx.local_accessibility_ctx.local_reconstruction_ctx.reconstruction_cost hRecon.carrier)
      (low_level_local_reconstruction_trace_gives_quantified_local_reconstruction_cost_inside hRecon)

def QuantifiedQuantumRecordFragmentPressureInside {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordLocalAccessibilityFeedContext u)
    (n : Nat) : Prop :=
  QuantifiedLocalReadableFragmentMagnitudeInside
    (fragmentation_projects_to_readable_fragment_context
      (fragment_connectivity_projects_to_fragmentation_context
        ctx.local_accessibility_ctx.fragment_connectivity_ctx))
    n

def QuantifiedQuantumRecordReadabilityPressureInside {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordLocalAccessibilityFeedContext u)
    (n : Nat) : Prop :=
  QuantifiedLocalReadabilityMagnitudeInside
    (local_readability_measure_projects_to_readability_context
      (local_reconstruction_projects_to_local_readability_measure_context
        ctx.local_accessibility_ctx.local_reconstruction_ctx))
    n

theorem quantum_record_projects_to_quantified_fragment_component_count_inside
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordLocalAccessibilityFeedContext u)
    (h : LowLevelQuantumRecordTrace ctx.quantum_ctx) :
    ∃ n,
      QuantifiedFragmentComponentCountInside
        ctx.local_accessibility_ctx.fragment_connectivity_ctx n := by
  rcases
    low_level_local_informational_accessibility_trace_gives_fragment_connectivity
      (ctx := ctx.local_accessibility_ctx)
      (quantum_record_projects_to_local_informational_accessibility_trace ctx h)
    with ⟨hConn, _⟩
  exact
    ⟨ctx.local_accessibility_ctx.fragment_connectivity_ctx.connected_fragment_count hConn.carrier,
      low_level_fragment_connectivity_trace_gives_quantified_fragment_component_count_inside hConn⟩

theorem quantum_record_projects_to_quantified_fragment_split_degree_inside
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordLocalAccessibilityFeedContext u)
    (h : LowLevelQuantumRecordTrace ctx.quantum_ctx) :
    ∃ n,
      QuantifiedFragmentSplitDegreeInside
        ctx.local_accessibility_ctx.fragment_connectivity_ctx n := by
  rcases
    low_level_local_informational_accessibility_trace_gives_fragment_connectivity
      (ctx := ctx.local_accessibility_ctx)
      (quantum_record_projects_to_local_informational_accessibility_trace ctx h)
    with ⟨hConn, _⟩
  exact
    ⟨ctx.local_accessibility_ctx.fragment_connectivity_ctx.fragment_separation_degree hConn.carrier,
      low_level_fragment_connectivity_trace_gives_quantified_fragment_split_degree_inside hConn⟩

theorem quantum_record_projects_to_quantified_fragment_pressure
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordLocalAccessibilityFeedContext u)
    (h : LowLevelQuantumRecordTrace ctx.quantum_ctx) :
    ∃ n, QuantifiedQuantumRecordFragmentPressureInside ctx n := by
  rcases
    low_level_local_informational_accessibility_trace_gives_fragment_connectivity
      (ctx := ctx.local_accessibility_ctx)
      (quantum_record_projects_to_local_informational_accessibility_trace ctx h)
    with ⟨hConn, _⟩
  have hMag :=
    low_level_fragment_connectivity_trace_gives_quantified_local_readable_fragment_magnitude_inside
      hConn
  exact
    ⟨readable_fragment_value
      (ctx.local_accessibility_ctx.fragment_connectivity_ctx.connected_fragment_count hConn.carrier)
      (ctx.local_accessibility_ctx.fragment_connectivity_ctx.fragment_separation_degree hConn.carrier),
      hMag⟩

theorem quantum_record_projects_to_quantified_local_readability_pressure
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordLocalAccessibilityFeedContext u)
    (h : LowLevelQuantumRecordTrace ctx.quantum_ctx) :
    ∃ n, QuantifiedQuantumRecordReadabilityPressureInside ctx n := by
  exact quantum_record_projects_to_local_readability_surface ctx h

def quantum_record_projects_to_local_reconstruction_trace
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordLocalAccessibilityFeedContext u)
    (h : LowLevelQuantumRecordTrace ctx.quantum_ctx) :
    LowLevelLocalReconstructionTrace ctx.local_accessibility_ctx.local_reconstruction_ctx :=
  ctx.local_accessibility_ctx.trace_projects_to_local_reconstruction
    (quantum_record_projects_to_local_informational_accessibility_trace ctx h).carrier
    (quantum_record_projects_to_local_informational_accessibility_trace ctx h).inside
    (quantum_record_projects_to_local_informational_accessibility_trace ctx h).trace_exists
    (quantum_record_projects_to_local_informational_accessibility_trace ctx h).fragmented
    (quantum_record_projects_to_local_informational_accessibility_trace ctx h).local_readability_blocked_without_reconstruction
    (quantum_record_projects_to_local_informational_accessibility_trace ctx h).reconstruction_effort_positive

def quantum_record_projects_to_local_readability_trace
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordLocalAccessibilityFeedContext u)
    (h : LowLevelQuantumRecordTrace ctx.quantum_ctx) :
    LowLevelLocalReadabilityTrace
      (local_readability_measure_projects_to_readability_context
        (local_reconstruction_projects_to_local_readability_measure_context
          ctx.local_accessibility_ctx.local_reconstruction_ctx)) :=
  let hRecon := quantum_record_projects_to_local_reconstruction_trace ctx h
  { carrier := hRecon.carrier
    inside := hRecon.inside
    record := hRecon.record
    distributed := hRecon.distributed
    recovery_blocked := hRecon.recovery_blocked
    inaccessible := hRecon.inaccessible
    readability_trace := hRecon.reconstruction_attempt }

def QuantifiedQuantumRecordPredictivePressureContributionInside {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordLocalAccessibilityFeedContext u)
    (n : Nat) : Prop :=
  QuantifiedRecoverabilityLossAtMagnitudeInside
    ctx.local_accessibility_ctx.local_reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx
    n

structure PhysicalOrderedQuantumRecordPressureContext (u : InterfaceProfile) where
  feed_ctx : PhysicalQuantumRecordLocalAccessibilityFeedContext u
  branching_magnitude : feed_ctx.quantum_ctx.QCarrier -> Nat
  imprint_magnitude : feed_ctx.quantum_ctx.QCarrier -> Nat
  stabilization_magnitude : feed_ctx.quantum_ctx.QCarrier -> Nat
  quantum_fragment_pressure_magnitude : feed_ctx.quantum_ctx.QCarrier -> Nat
  quantum_readability_pressure_magnitude : feed_ctx.quantum_ctx.QCarrier -> Nat
  projected_fragment_component_count_matches_branching :
    ∀ hq : LowLevelQuantumRecordTrace feed_ctx.quantum_ctx,
      let hConn :=
        Classical.choose
          (quantum_record_projects_to_fragment_connectivity_surface feed_ctx hq)
      feed_ctx.local_accessibility_ctx.fragment_connectivity_ctx.connected_fragment_count hConn.carrier =
        branching_magnitude hq.carrier
  projected_fragment_split_degree_matches_imprint :
    ∀ hq : LowLevelQuantumRecordTrace feed_ctx.quantum_ctx,
      let hConn :=
        Classical.choose
          (quantum_record_projects_to_fragment_connectivity_surface feed_ctx hq)
      feed_ctx.local_accessibility_ctx.fragment_connectivity_ctx.fragment_separation_degree hConn.carrier =
        imprint_magnitude hq.carrier
  quantum_fragment_pressure_is_branching_plus_imprint :
    ∀ q : feed_ctx.quantum_ctx.QCarrier,
      quantum_fragment_pressure_magnitude q =
        readable_fragment_value (branching_magnitude q) (imprint_magnitude q)
  projected_local_readability_matches_quantum_readability_pressure :
    ∀ hq : LowLevelQuantumRecordTrace feed_ctx.quantum_ctx,
      let hRead := quantum_record_projects_to_local_readability_trace feed_ctx hq
      (local_readability_measure_projects_to_readability_context
        (local_reconstruction_projects_to_local_readability_measure_context
          feed_ctx.local_accessibility_ctx.local_reconstruction_ctx)).local_readability_magnitude
          hRead.carrier =
        quantum_readability_pressure_magnitude hq.carrier
  projected_dispersion_matches_quantum_fragment_pressure :
    ∀ hq : LowLevelQuantumRecordTrace feed_ctx.quantum_ctx,
      let hRead := quantum_record_projects_to_local_readability_trace feed_ctx hq
      (local_readability_measure_projects_to_readability_context
        (local_reconstruction_projects_to_local_readability_measure_context
          feed_ctx.local_accessibility_ctx.local_reconstruction_ctx)).tri_ctx.dispersion_magnitude
          hRead.carrier =
        quantum_fragment_pressure_magnitude hq.carrier
  quantum_readability_pressure_is_fragment_plus_stabilization :
    ∀ q : feed_ctx.quantum_ctx.QCarrier,
      quantum_readability_pressure_magnitude q =
        readable_fragment_value
          (quantum_fragment_pressure_magnitude q)
          (stabilization_magnitude q)

def QuantifiedQuantumBranchingMagnitudeInside {u : InterfaceProfile}
    (ctx : PhysicalOrderedQuantumRecordPressureContext u)
    (n : Nat) : Prop :=
  ∃ q : ctx.feed_ctx.quantum_ctx.QCarrier,
    ctx.feed_ctx.quantum_ctx.inside_universe q /\
    ctx.feed_ctx.quantum_ctx.interaction_event q /\
    ctx.feed_ctx.quantum_ctx.alternative_branching q /\
    ctx.branching_magnitude q = n

def QuantifiedQuantumImprintMagnitudeInside {u : InterfaceProfile}
    (ctx : PhysicalOrderedQuantumRecordPressureContext u)
    (n : Nat) : Prop :=
  ∃ q : ctx.feed_ctx.quantum_ctx.QCarrier,
    ctx.feed_ctx.quantum_ctx.inside_universe q /\
    ctx.feed_ctx.quantum_ctx.interaction_event q /\
    ctx.feed_ctx.quantum_ctx.environmental_imprint q /\
    ctx.imprint_magnitude q = n

def QuantifiedQuantumStabilizationMagnitudeInside {u : InterfaceProfile}
    (ctx : PhysicalOrderedQuantumRecordPressureContext u)
    (n : Nat) : Prop :=
  ∃ q : ctx.feed_ctx.quantum_ctx.QCarrier,
    ctx.feed_ctx.quantum_ctx.inside_universe q /\
    ctx.feed_ctx.quantum_ctx.outcome_record_stabilized q /\
    ctx.stabilization_magnitude q = n

def QuantifiedOrderedQuantumFragmentPressureInside {u : InterfaceProfile}
    (ctx : PhysicalOrderedQuantumRecordPressureContext u)
    (n : Nat) : Prop :=
  ∃ q : ctx.feed_ctx.quantum_ctx.QCarrier,
    ctx.feed_ctx.quantum_ctx.inside_universe q /\
    ctx.feed_ctx.quantum_ctx.interaction_event q /\
    ctx.feed_ctx.quantum_ctx.alternative_branching q /\
    ctx.feed_ctx.quantum_ctx.environmental_imprint q /\
    ctx.feed_ctx.quantum_ctx.branch_separation q /\
    ctx.quantum_fragment_pressure_magnitude q = n

def QuantifiedOrderedQuantumReadabilityPressureInside {u : InterfaceProfile}
    (ctx : PhysicalOrderedQuantumRecordPressureContext u)
    (n : Nat) : Prop :=
  ∃ q : ctx.feed_ctx.quantum_ctx.QCarrier,
    ctx.feed_ctx.quantum_ctx.inside_universe q /\
    ctx.feed_ctx.quantum_ctx.interaction_event q /\
    ctx.feed_ctx.quantum_ctx.alternative_branching q /\
    ctx.feed_ctx.quantum_ctx.environmental_imprint q /\
    ctx.feed_ctx.quantum_ctx.branch_separation q /\
    ctx.feed_ctx.quantum_ctx.outcome_record_stabilized q /\
    ctx.quantum_readability_pressure_magnitude q = n

theorem low_level_quantum_record_trace_gives_quantified_quantum_branching_magnitude_inside
    {u : InterfaceProfile}
    {ctx : PhysicalOrderedQuantumRecordPressureContext u}
    (h : LowLevelQuantumRecordTrace ctx.feed_ctx.quantum_ctx) :
    QuantifiedQuantumBranchingMagnitudeInside ctx (ctx.branching_magnitude h.carrier) := by
  exact ⟨h.carrier, h.inside, h.interaction_event, h.alternative_branching, rfl⟩

theorem low_level_quantum_record_trace_gives_quantified_quantum_imprint_magnitude_inside
    {u : InterfaceProfile}
    {ctx : PhysicalOrderedQuantumRecordPressureContext u}
    (h : LowLevelQuantumRecordTrace ctx.feed_ctx.quantum_ctx) :
    QuantifiedQuantumImprintMagnitudeInside ctx (ctx.imprint_magnitude h.carrier) := by
  exact ⟨h.carrier, h.inside, h.interaction_event, h.environmental_imprint, rfl⟩

theorem low_level_quantum_record_trace_gives_quantified_quantum_stabilization_magnitude_inside
    {u : InterfaceProfile}
    {ctx : PhysicalOrderedQuantumRecordPressureContext u}
    (h : LowLevelQuantumRecordTrace ctx.feed_ctx.quantum_ctx) :
    QuantifiedQuantumStabilizationMagnitudeInside ctx (ctx.stabilization_magnitude h.carrier) := by
  exact ⟨h.carrier, h.inside, h.outcome_record_stabilized, rfl⟩

theorem quantum_record_trace_gives_quantified_ordered_quantum_fragment_pressure
    {u : InterfaceProfile}
    {ctx : PhysicalOrderedQuantumRecordPressureContext u}
    (h : LowLevelQuantumRecordTrace ctx.feed_ctx.quantum_ctx) :
    QuantifiedOrderedQuantumFragmentPressureInside ctx
      (ctx.quantum_fragment_pressure_magnitude h.carrier) := by
  exact
    ⟨h.carrier, h.inside, h.interaction_event, h.alternative_branching,
      h.environmental_imprint, h.branch_separation, rfl⟩

theorem quantum_record_trace_gives_quantified_ordered_quantum_readability_pressure
    {u : InterfaceProfile}
    {ctx : PhysicalOrderedQuantumRecordPressureContext u}
    (h : LowLevelQuantumRecordTrace ctx.feed_ctx.quantum_ctx) :
    QuantifiedOrderedQuantumReadabilityPressureInside ctx
      (ctx.quantum_readability_pressure_magnitude h.carrier) := by
  exact
    ⟨h.carrier, h.inside, h.interaction_event, h.alternative_branching,
      h.environmental_imprint, h.branch_separation, h.outcome_record_stabilized, rfl⟩

def quantum_fragment_pressure_value
    (branching imprint : Nat) : Nat :=
  readable_fragment_value branching imprint

def quantum_readability_pressure_value
    (branching imprint stabilization : Nat) : Nat :=
  readable_fragment_value
    (quantum_fragment_pressure_value branching imprint)
    stabilization

def quantum_predictive_pressure_contribution_value
    (full branching imprint blockedness stabilization : Nat) : Nat :=
  tri_spectral_loss_value
    full
    (quantum_fragment_pressure_value branching imprint)
    blockedness
    (quantum_readability_pressure_value branching imprint stabilization)

theorem quantum_fragment_pressure_value_is_monotone_in_branching
    (branching₁ branching₂ imprint : Nat) :
    branching₁ <= branching₂ ->
      quantum_fragment_pressure_value branching₁ imprint <=
        quantum_fragment_pressure_value branching₂ imprint := by
  intro h
  exact readable_fragment_value_is_monotone_in_fragment_count branching₁ branching₂ imprint h

theorem quantum_fragment_pressure_value_is_monotone_in_imprint
    (branching imprint₁ imprint₂ : Nat) :
    imprint₁ <= imprint₂ ->
      quantum_fragment_pressure_value branching imprint₁ <=
        quantum_fragment_pressure_value branching imprint₂ := by
  intro h
  exact readable_fragment_value_is_monotone_in_split_degree branching imprint₁ imprint₂ h

theorem quantum_readability_pressure_value_is_monotone_in_branching
    (branching₁ branching₂ imprint stabilization : Nat) :
    branching₁ <= branching₂ ->
      quantum_readability_pressure_value branching₁ imprint stabilization <=
        quantum_readability_pressure_value branching₂ imprint stabilization := by
  intro h
  unfold quantum_readability_pressure_value
  exact
    readable_fragment_value_is_monotone_in_fragment_count
      (quantum_fragment_pressure_value branching₁ imprint)
      (quantum_fragment_pressure_value branching₂ imprint)
      stabilization
      (quantum_fragment_pressure_value_is_monotone_in_branching branching₁ branching₂ imprint h)

theorem quantum_readability_pressure_value_is_monotone_in_imprint
    (branching imprint₁ imprint₂ stabilization : Nat) :
    imprint₁ <= imprint₂ ->
      quantum_readability_pressure_value branching imprint₁ stabilization <=
        quantum_readability_pressure_value branching imprint₂ stabilization := by
  intro h
  unfold quantum_readability_pressure_value
  exact
    readable_fragment_value_is_monotone_in_fragment_count
      (quantum_fragment_pressure_value branching imprint₁)
      (quantum_fragment_pressure_value branching imprint₂)
      stabilization
      (quantum_fragment_pressure_value_is_monotone_in_imprint branching imprint₁ imprint₂ h)

theorem quantum_readability_pressure_value_is_monotone_in_stabilization
    (branching imprint stabilization₁ stabilization₂ : Nat) :
    stabilization₁ <= stabilization₂ ->
      quantum_readability_pressure_value branching imprint stabilization₁ <=
        quantum_readability_pressure_value branching imprint stabilization₂ := by
  intro h
  unfold quantum_readability_pressure_value
  exact
    readable_fragment_value_is_monotone_in_split_degree
      (quantum_fragment_pressure_value branching imprint)
      stabilization₁ stabilization₂ h

structure PhysicalQuantumPressureLawContext (u : InterfaceProfile) where
  ordered_ctx : PhysicalOrderedQuantumRecordPressureContext u
  quantum_blockedness_magnitude : ordered_ctx.feed_ctx.quantum_ctx.QCarrier -> Nat
  projected_blockedness_matches_quantum_blockedness :
    ∀ hq : LowLevelQuantumRecordTrace ordered_ctx.feed_ctx.quantum_ctx,
      let readabilityCtx :=
        local_readability_measure_projects_to_readability_context
          (local_reconstruction_projects_to_local_readability_measure_context
            ordered_ctx.feed_ctx.local_accessibility_ctx.local_reconstruction_ctx)
      let hRead := quantum_record_projects_to_local_readability_trace ordered_ctx.feed_ctx hq
      readabilityCtx.tri_ctx.blockedness_magnitude hRead.carrier =
        quantum_blockedness_magnitude hq.carrier

theorem quantum_predictive_pressure_contribution_value_is_bounded_by_full
    (full branching imprint blockedness stabilization : Nat) :
    quantum_predictive_pressure_contribution_value
      full branching imprint blockedness stabilization <= full := by
  unfold quantum_predictive_pressure_contribution_value tri_spectral_loss_value
  exact Nat.min_le_left _ _

theorem tri_spectral_loss_value_is_monotone_in_dispersion
    (full dispersion₁ dispersion₂ blockedness locality : Nat) :
    dispersion₁ <= dispersion₂ ->
      tri_spectral_loss_value full dispersion₁ blockedness locality <=
        tri_spectral_loss_value full dispersion₂ blockedness locality := by
  intro h
  unfold tri_spectral_loss_value
  omega

theorem tri_spectral_loss_value_is_monotone_in_blockedness
    (full dispersion blockedness₁ blockedness₂ locality : Nat) :
    blockedness₁ <= blockedness₂ ->
      tri_spectral_loss_value full dispersion blockedness₁ locality <=
        tri_spectral_loss_value full dispersion blockedness₂ locality := by
  intro h
  unfold tri_spectral_loss_value
  omega

theorem tri_spectral_loss_value_is_monotone_in_locality
    (full dispersion blockedness locality₁ locality₂ : Nat) :
    locality₁ <= locality₂ ->
      tri_spectral_loss_value full dispersion blockedness locality₁ <=
        tri_spectral_loss_value full dispersion blockedness locality₂ := by
  intro h
  unfold tri_spectral_loss_value
  omega

theorem quantum_predictive_pressure_contribution_value_is_monotone_in_branching
    (full branching₁ branching₂ imprint blockedness stabilization : Nat) :
    branching₁ <= branching₂ ->
      quantum_predictive_pressure_contribution_value
          full branching₁ imprint blockedness stabilization <=
        quantum_predictive_pressure_contribution_value
          full branching₂ imprint blockedness stabilization := by
  intro h
  unfold quantum_predictive_pressure_contribution_value
  exact
    tri_spectral_loss_value_is_monotone_in_dispersion
      full
      (quantum_fragment_pressure_value branching₁ imprint)
      (quantum_fragment_pressure_value branching₂ imprint)
      blockedness
      (quantum_readability_pressure_value branching₁ imprint stabilization)
      (quantum_fragment_pressure_value_is_monotone_in_branching branching₁ branching₂ imprint h)
    |> fun hDisp =>
      by
        have hRead :
            quantum_readability_pressure_value branching₁ imprint stabilization <=
              quantum_readability_pressure_value branching₂ imprint stabilization :=
          quantum_readability_pressure_value_is_monotone_in_branching
            branching₁ branching₂ imprint stabilization h
        exact
          Nat.le_trans hDisp
            (tri_spectral_loss_value_is_monotone_in_locality
              full
              (quantum_fragment_pressure_value branching₂ imprint)
              blockedness
              (quantum_readability_pressure_value branching₁ imprint stabilization)
              (quantum_readability_pressure_value branching₂ imprint stabilization)
              hRead)

theorem quantum_predictive_pressure_contribution_value_is_monotone_in_imprint
    (full branching imprint₁ imprint₂ blockedness stabilization : Nat) :
    imprint₁ <= imprint₂ ->
      quantum_predictive_pressure_contribution_value
          full branching imprint₁ blockedness stabilization <=
        quantum_predictive_pressure_contribution_value
          full branching imprint₂ blockedness stabilization := by
  intro h
  unfold quantum_predictive_pressure_contribution_value
  have hDisp :
      tri_spectral_loss_value
          full
          (quantum_fragment_pressure_value branching imprint₁)
          blockedness
          (quantum_readability_pressure_value branching imprint₁ stabilization) <=
        tri_spectral_loss_value
          full
          (quantum_fragment_pressure_value branching imprint₂)
          blockedness
          (quantum_readability_pressure_value branching imprint₁ stabilization) :=
    tri_spectral_loss_value_is_monotone_in_dispersion
      full
      (quantum_fragment_pressure_value branching imprint₁)
      (quantum_fragment_pressure_value branching imprint₂)
      blockedness
      (quantum_readability_pressure_value branching imprint₁ stabilization)
      (quantum_fragment_pressure_value_is_monotone_in_imprint branching imprint₁ imprint₂ h)
  have hRead :
      quantum_readability_pressure_value branching imprint₁ stabilization <=
        quantum_readability_pressure_value branching imprint₂ stabilization :=
    quantum_readability_pressure_value_is_monotone_in_imprint
      branching imprint₁ imprint₂ stabilization h
  exact
    Nat.le_trans hDisp
      (tri_spectral_loss_value_is_monotone_in_locality
        full
        (quantum_fragment_pressure_value branching imprint₂)
        blockedness
        (quantum_readability_pressure_value branching imprint₁ stabilization)
        (quantum_readability_pressure_value branching imprint₂ stabilization)
        hRead)

theorem quantum_predictive_pressure_contribution_value_is_monotone_in_blockedness
    (full branching imprint blockedness₁ blockedness₂ stabilization : Nat) :
    blockedness₁ <= blockedness₂ ->
      quantum_predictive_pressure_contribution_value
          full branching imprint blockedness₁ stabilization <=
        quantum_predictive_pressure_contribution_value
          full branching imprint blockedness₂ stabilization := by
  intro h
  unfold quantum_predictive_pressure_contribution_value
  exact
    tri_spectral_loss_value_is_monotone_in_blockedness
      full
      (quantum_fragment_pressure_value branching imprint)
      blockedness₁ blockedness₂
      (quantum_readability_pressure_value branching imprint stabilization)
      h

theorem quantum_predictive_pressure_contribution_value_is_monotone_in_stabilization
    (full branching imprint blockedness stabilization₁ stabilization₂ : Nat) :
    stabilization₁ <= stabilization₂ ->
      quantum_predictive_pressure_contribution_value
          full branching imprint blockedness stabilization₁ <=
        quantum_predictive_pressure_contribution_value
          full branching imprint blockedness stabilization₂ := by
  intro h
  unfold quantum_predictive_pressure_contribution_value
  exact
    tri_spectral_loss_value_is_monotone_in_locality
      full
      (quantum_fragment_pressure_value branching imprint)
      blockedness
      (quantum_readability_pressure_value branching imprint stabilization₁)
      (quantum_readability_pressure_value branching imprint stabilization₂)
      (quantum_readability_pressure_value_is_monotone_in_stabilization
        branching imprint stabilization₁ stabilization₂ h)

theorem quantum_predictive_pressure_contribution_value_range
    (full branchingLo branchingHi imprintLo imprintHi blockednessLo blockednessHi
      stabilizationLo stabilizationHi : Nat)
    (hBranch : branchingLo <= branchingHi)
    (hImprint : imprintLo <= imprintHi)
    (hBlocked : blockednessLo <= blockednessHi)
    (hStabilization : stabilizationLo <= stabilizationHi) :
    quantum_predictive_pressure_contribution_value
        full branchingLo imprintLo blockednessLo stabilizationLo <=
      quantum_predictive_pressure_contribution_value
        full branchingHi imprintHi blockednessHi stabilizationHi := by
  have h1 :
      quantum_predictive_pressure_contribution_value
          full branchingLo imprintLo blockednessLo stabilizationLo <=
        quantum_predictive_pressure_contribution_value
          full branchingHi imprintLo blockednessLo stabilizationLo :=
    quantum_predictive_pressure_contribution_value_is_monotone_in_branching
      full branchingLo branchingHi imprintLo blockednessLo stabilizationLo hBranch
  have h2 :
      quantum_predictive_pressure_contribution_value
          full branchingHi imprintLo blockednessLo stabilizationLo <=
        quantum_predictive_pressure_contribution_value
          full branchingHi imprintHi blockednessLo stabilizationLo :=
    quantum_predictive_pressure_contribution_value_is_monotone_in_imprint
      full branchingHi imprintLo imprintHi blockednessLo stabilizationLo hImprint
  have h3 :
      quantum_predictive_pressure_contribution_value
          full branchingHi imprintHi blockednessLo stabilizationLo <=
        quantum_predictive_pressure_contribution_value
          full branchingHi imprintHi blockednessHi stabilizationLo :=
    quantum_predictive_pressure_contribution_value_is_monotone_in_blockedness
      full branchingHi imprintHi blockednessLo blockednessHi stabilizationLo hBlocked
  have h4 :
      quantum_predictive_pressure_contribution_value
          full branchingHi imprintHi blockednessHi stabilizationLo <=
        quantum_predictive_pressure_contribution_value
          full branchingHi imprintHi blockednessHi stabilizationHi :=
    quantum_predictive_pressure_contribution_value_is_monotone_in_stabilization
      full branchingHi imprintHi blockednessHi stabilizationLo stabilizationHi hStabilization
  exact Nat.le_trans h1 (Nat.le_trans h2 (Nat.le_trans h3 h4))

theorem quantum_predictive_pressure_level_range
    (full branchingLo branchingHi imprintLo imprintHi blockednessLo blockednessHi
      stabilizationLo stabilizationHi : Nat)
    (hBranch : branchingLo <= branchingHi)
    (hImprint : imprintLo <= imprintHi)
    (hBlocked : blockednessLo <= blockednessHi)
    (hStabilization : stabilizationLo <= stabilizationHi) :
    full -
        quantum_predictive_pressure_contribution_value
          full branchingHi imprintHi blockednessHi stabilizationHi <=
      full -
        quantum_predictive_pressure_contribution_value
          full branchingLo imprintLo blockednessLo stabilizationLo := by
  have hRange :=
    quantum_predictive_pressure_contribution_value_range
      full branchingLo branchingHi imprintLo imprintHi blockednessLo blockednessHi
      stabilizationLo stabilizationHi hBranch hImprint hBlocked hStabilization
  omega

theorem quantum_record_readability_pressure_projects_to_quantified_recoverability_loss
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordLocalAccessibilityFeedContext u)
    (h : LowLevelQuantumRecordTrace ctx.quantum_ctx)
    {d b : Nat} :
    let readabilityCtx :=
      local_readability_measure_projects_to_readability_context
        (local_reconstruction_projects_to_local_readability_measure_context
          ctx.local_accessibility_ctx.local_reconstruction_ctx)
    let hRead := quantum_record_projects_to_local_readability_trace ctx h
    readabilityCtx.tri_ctx.dispersion_magnitude hRead.carrier = d ->
      readabilityCtx.tri_ctx.blockedness_magnitude hRead.carrier = b ->
        QuantifiedQuantumRecordPredictivePressureContributionInside
          ctx
          (tri_spectral_loss_value
            readabilityCtx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level
            d
            b
            (readabilityCtx.local_readability_magnitude hRead.carrier)) := by
  intro readabilityCtx hRead hDisp hBlocked
  exact
    local_readability_trace_and_axis_values_give_quantified_recoverability_loss
      readabilityCtx
      hRead.inside
      hRead.record
      hRead.distributed
      hRead.recovery_blocked
      hRead.inaccessible
      hRead.readability_trace
      hDisp
      hBlocked
      rfl

theorem quantum_record_predictive_pressure_contribution_and_full_predictive_accessibility_give_exact_predictive_level
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordLocalAccessibilityFeedContext u)
    (h : LowLevelQuantumRecordTrace ctx.quantum_ctx)
    {d b : Nat}
    (hDisp :
      let readabilityCtx :=
        local_readability_measure_projects_to_readability_context
          (local_reconstruction_projects_to_local_readability_measure_context
            ctx.local_accessibility_ctx.local_reconstruction_ctx)
      let hRead := quantum_record_projects_to_local_readability_trace ctx h
      readabilityCtx.tri_ctx.dispersion_magnitude hRead.carrier = d)
    (hBlocked :
      let readabilityCtx :=
        local_readability_measure_projects_to_readability_context
          (local_reconstruction_projects_to_local_readability_measure_context
            ctx.local_accessibility_ctx.local_reconstruction_ctx)
      let hRead := quantum_record_projects_to_local_readability_trace ctx h
      readabilityCtx.tri_ctx.blockedness_magnitude hRead.carrier = b)
    (hFull :
      let readabilityCtx :=
        local_readability_measure_projects_to_readability_context
          (local_reconstruction_projects_to_local_readability_measure_context
            ctx.local_accessibility_ctx.local_reconstruction_ctx)
      FullPredictiveAccessibilityGradientInside readabilityCtx.tri_ctx.loss_ctx.gradient_ctx) :
    let readabilityCtx :=
      local_readability_measure_projects_to_readability_context
        (local_reconstruction_projects_to_local_readability_measure_context
          ctx.local_accessibility_ctx.local_reconstruction_ctx)
    let hRead := quantum_record_projects_to_local_readability_trace ctx h
    PredictiveAccessibilityAtLevelInside
      readabilityCtx.tri_ctx.loss_ctx.gradient_ctx
      (readabilityCtx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level -
        tri_spectral_loss_value
          readabilityCtx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level
          d
          b
          (readabilityCtx.local_readability_magnitude hRead.carrier)) := by
  intro readabilityCtx hRead
  exact
    recoverability_tri_spectrum_and_full_predictive_accessibility_give_exact_predictive_level
      readabilityCtx.tri_ctx
      (tri_spectral_loss_value
        readabilityCtx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level
        d
        b
        (readabilityCtx.local_readability_magnitude hRead.carrier))
      (quantum_record_readability_pressure_projects_to_quantified_recoverability_loss
        ctx h hDisp hBlocked)
      hFull

theorem ordered_quantum_fragment_pressure_projects_to_fragment_pressure
    {u : InterfaceProfile}
    (ctx : PhysicalOrderedQuantumRecordPressureContext u)
    (h : LowLevelQuantumRecordTrace ctx.feed_ctx.quantum_ctx) :
    QuantifiedQuantumRecordFragmentPressureInside
      ctx.feed_ctx
      (ctx.quantum_fragment_pressure_magnitude h.carrier) := by
  let hConn :=
    Classical.choose
      (quantum_record_projects_to_fragment_connectivity_surface
        ctx.feed_ctx h)
  have hCount :
      ctx.feed_ctx.local_accessibility_ctx.fragment_connectivity_ctx.connected_fragment_count hConn.carrier =
        ctx.branching_magnitude h.carrier := by
    exact ctx.projected_fragment_component_count_matches_branching h
  have hSplit :
      ctx.feed_ctx.local_accessibility_ctx.fragment_connectivity_ctx.fragment_separation_degree hConn.carrier =
        ctx.imprint_magnitude h.carrier := by
    exact ctx.projected_fragment_split_degree_matches_imprint h
  have hPressure :
      ctx.quantum_fragment_pressure_magnitude h.carrier =
        readable_fragment_value
          (ctx.feed_ctx.local_accessibility_ctx.fragment_connectivity_ctx.connected_fragment_count hConn.carrier)
          (ctx.feed_ctx.local_accessibility_ctx.fragment_connectivity_ctx.fragment_separation_degree hConn.carrier) := by
    rw [ctx.quantum_fragment_pressure_is_branching_plus_imprint h.carrier]
    rw [← hCount, ← hSplit]
  rw [hPressure]
  exact
    low_level_fragment_connectivity_trace_gives_quantified_local_readable_fragment_magnitude_inside
      hConn

theorem ordered_quantum_readability_pressure_projects_to_local_readability_pressure
    {u : InterfaceProfile}
    (ctx : PhysicalOrderedQuantumRecordPressureContext u)
    (h : LowLevelQuantumRecordTrace ctx.feed_ctx.quantum_ctx) :
    QuantifiedQuantumRecordReadabilityPressureInside
      ctx.feed_ctx
      (ctx.quantum_readability_pressure_magnitude h.carrier) := by
  let hRead := quantum_record_projects_to_local_readability_trace ctx.feed_ctx h
  have hEq :
      (local_readability_measure_projects_to_readability_context
        (local_reconstruction_projects_to_local_readability_measure_context
          ctx.feed_ctx.local_accessibility_ctx.local_reconstruction_ctx)).local_readability_magnitude
          hRead.carrier =
        ctx.quantum_readability_pressure_magnitude h.carrier :=
    ctx.projected_local_readability_matches_quantum_readability_pressure h
  rw [← hEq]
  exact
    low_level_local_readability_trace_gives_quantified_local_readability_magnitude_inside
      hRead

theorem ordered_quantum_pressure_projects_to_quantified_recoverability_loss
    {u : InterfaceProfile}
    (ctx : PhysicalOrderedQuantumRecordPressureContext u)
    (h : LowLevelQuantumRecordTrace ctx.feed_ctx.quantum_ctx)
    {b : Nat}
    (hBlocked :
      let readabilityCtx :=
        local_readability_measure_projects_to_readability_context
          (local_reconstruction_projects_to_local_readability_measure_context
            ctx.feed_ctx.local_accessibility_ctx.local_reconstruction_ctx)
      let hRead := quantum_record_projects_to_local_readability_trace ctx.feed_ctx h
      readabilityCtx.tri_ctx.blockedness_magnitude hRead.carrier = b) :
    QuantifiedQuantumRecordPredictivePressureContributionInside
      ctx.feed_ctx
      (tri_spectral_loss_value
        (local_readability_measure_projects_to_readability_context
          (local_reconstruction_projects_to_local_readability_measure_context
            ctx.feed_ctx.local_accessibility_ctx.local_reconstruction_ctx)).tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level
        (ctx.quantum_fragment_pressure_magnitude h.carrier)
        b
        (ctx.quantum_readability_pressure_magnitude h.carrier)) := by
  let readabilityCtx :=
    local_readability_measure_projects_to_readability_context
      (local_reconstruction_projects_to_local_readability_measure_context
        ctx.feed_ctx.local_accessibility_ctx.local_reconstruction_ctx)
  let hRead := quantum_record_projects_to_local_readability_trace ctx.feed_ctx h
  have hDisp :
      readabilityCtx.tri_ctx.dispersion_magnitude hRead.carrier =
        ctx.quantum_fragment_pressure_magnitude h.carrier :=
    ctx.projected_dispersion_matches_quantum_fragment_pressure h
  have hLocal :
      readabilityCtx.local_readability_magnitude hRead.carrier =
        ctx.quantum_readability_pressure_magnitude h.carrier :=
    ctx.projected_local_readability_matches_quantum_readability_pressure h
  exact
    local_readability_trace_and_axis_values_give_quantified_recoverability_loss
      readabilityCtx
      hRead.inside
      hRead.record
      hRead.distributed
      hRead.recovery_blocked
      hRead.inaccessible
      hRead.readability_trace
      hDisp
      hBlocked
      hLocal

theorem ordered_quantum_pressure_and_full_predictive_accessibility_give_exact_predictive_level
    {u : InterfaceProfile}
    (ctx : PhysicalOrderedQuantumRecordPressureContext u)
    (h : LowLevelQuantumRecordTrace ctx.feed_ctx.quantum_ctx)
    {b : Nat}
    (hBlocked :
      let readabilityCtx :=
        local_readability_measure_projects_to_readability_context
          (local_reconstruction_projects_to_local_readability_measure_context
            ctx.feed_ctx.local_accessibility_ctx.local_reconstruction_ctx)
      let hRead := quantum_record_projects_to_local_readability_trace ctx.feed_ctx h
      readabilityCtx.tri_ctx.blockedness_magnitude hRead.carrier = b)
    (hFull :
      let readabilityCtx :=
        local_readability_measure_projects_to_readability_context
          (local_reconstruction_projects_to_local_readability_measure_context
            ctx.feed_ctx.local_accessibility_ctx.local_reconstruction_ctx)
      FullPredictiveAccessibilityGradientInside readabilityCtx.tri_ctx.loss_ctx.gradient_ctx) :
    let readabilityCtx :=
      local_readability_measure_projects_to_readability_context
        (local_reconstruction_projects_to_local_readability_measure_context
          ctx.feed_ctx.local_accessibility_ctx.local_reconstruction_ctx)
    PredictiveAccessibilityAtLevelInside
      readabilityCtx.tri_ctx.loss_ctx.gradient_ctx
      (readabilityCtx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level -
        tri_spectral_loss_value
          readabilityCtx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level
          (ctx.quantum_fragment_pressure_magnitude h.carrier)
          b
          (ctx.quantum_readability_pressure_magnitude h.carrier)) := by
  intro readabilityCtx
  exact
    recoverability_tri_spectrum_and_full_predictive_accessibility_give_exact_predictive_level
      readabilityCtx.tri_ctx
      (tri_spectral_loss_value
        readabilityCtx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level
        (ctx.quantum_fragment_pressure_magnitude h.carrier)
        b
        (ctx.quantum_readability_pressure_magnitude h.carrier))
      (ordered_quantum_pressure_projects_to_quantified_recoverability_loss
        ctx h hBlocked)
      hFull

theorem quantum_pressure_law_projects_to_quantified_recoverability_loss
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumPressureLawContext u)
    (h : LowLevelQuantumRecordTrace ctx.ordered_ctx.feed_ctx.quantum_ctx) :
    QuantifiedQuantumRecordPredictivePressureContributionInside
      ctx.ordered_ctx.feed_ctx
      (quantum_predictive_pressure_contribution_value
        (local_readability_measure_projects_to_readability_context
          (local_reconstruction_projects_to_local_readability_measure_context
            ctx.ordered_ctx.feed_ctx.local_accessibility_ctx.local_reconstruction_ctx)).tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level
        (ctx.ordered_ctx.branching_magnitude h.carrier)
        (ctx.ordered_ctx.imprint_magnitude h.carrier)
        (ctx.quantum_blockedness_magnitude h.carrier)
        (ctx.ordered_ctx.stabilization_magnitude h.carrier)) := by
  have hBlocked :
      let readabilityCtx :=
        local_readability_measure_projects_to_readability_context
          (local_reconstruction_projects_to_local_readability_measure_context
            ctx.ordered_ctx.feed_ctx.local_accessibility_ctx.local_reconstruction_ctx)
      let hRead := quantum_record_projects_to_local_readability_trace ctx.ordered_ctx.feed_ctx h
      readabilityCtx.tri_ctx.blockedness_magnitude hRead.carrier =
        ctx.quantum_blockedness_magnitude h.carrier :=
    ctx.projected_blockedness_matches_quantum_blockedness h
  have hFragmentEq :
      quantum_fragment_pressure_value
          (ctx.ordered_ctx.branching_magnitude h.carrier)
          (ctx.ordered_ctx.imprint_magnitude h.carrier) =
        ctx.ordered_ctx.quantum_fragment_pressure_magnitude h.carrier := by
    unfold quantum_fragment_pressure_value
    exact
      (ctx.ordered_ctx.quantum_fragment_pressure_is_branching_plus_imprint h.carrier).symm
  have hReadEq :
      quantum_readability_pressure_value
          (ctx.ordered_ctx.branching_magnitude h.carrier)
          (ctx.ordered_ctx.imprint_magnitude h.carrier)
          (ctx.ordered_ctx.stabilization_magnitude h.carrier) =
        ctx.ordered_ctx.quantum_readability_pressure_magnitude h.carrier := by
    unfold quantum_readability_pressure_value
    rw [hFragmentEq]
    exact
      (ctx.ordered_ctx.quantum_readability_pressure_is_fragment_plus_stabilization h.carrier).symm
  unfold quantum_predictive_pressure_contribution_value
  rw [hFragmentEq, hReadEq]
  exact
    ordered_quantum_pressure_projects_to_quantified_recoverability_loss
      ctx.ordered_ctx
      h
      hBlocked

theorem quantum_pressure_law_and_full_predictive_accessibility_give_exact_predictive_level
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumPressureLawContext u)
    (h : LowLevelQuantumRecordTrace ctx.ordered_ctx.feed_ctx.quantum_ctx)
    (hFull :
      let readabilityCtx :=
        local_readability_measure_projects_to_readability_context
          (local_reconstruction_projects_to_local_readability_measure_context
            ctx.ordered_ctx.feed_ctx.local_accessibility_ctx.local_reconstruction_ctx)
      FullPredictiveAccessibilityGradientInside readabilityCtx.tri_ctx.loss_ctx.gradient_ctx) :
    let readabilityCtx :=
      local_readability_measure_projects_to_readability_context
        (local_reconstruction_projects_to_local_readability_measure_context
          ctx.ordered_ctx.feed_ctx.local_accessibility_ctx.local_reconstruction_ctx)
    PredictiveAccessibilityAtLevelInside
      readabilityCtx.tri_ctx.loss_ctx.gradient_ctx
      (readabilityCtx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level -
        quantum_predictive_pressure_contribution_value
          readabilityCtx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level
          (ctx.ordered_ctx.branching_magnitude h.carrier)
          (ctx.ordered_ctx.imprint_magnitude h.carrier)
          (ctx.quantum_blockedness_magnitude h.carrier)
          (ctx.ordered_ctx.stabilization_magnitude h.carrier)) := by
  let readabilityCtx :=
    local_readability_measure_projects_to_readability_context
      (local_reconstruction_projects_to_local_readability_measure_context
        ctx.ordered_ctx.feed_ctx.local_accessibility_ctx.local_reconstruction_ctx)
  have hBlocked :
      readabilityCtx.tri_ctx.blockedness_magnitude
          (quantum_record_projects_to_local_readability_trace ctx.ordered_ctx.feed_ctx h).carrier =
        ctx.quantum_blockedness_magnitude h.carrier :=
    ctx.projected_blockedness_matches_quantum_blockedness h
  have hFragmentEq :
      quantum_fragment_pressure_value
          (ctx.ordered_ctx.branching_magnitude h.carrier)
          (ctx.ordered_ctx.imprint_magnitude h.carrier) =
        ctx.ordered_ctx.quantum_fragment_pressure_magnitude h.carrier := by
    unfold quantum_fragment_pressure_value
    exact
      (ctx.ordered_ctx.quantum_fragment_pressure_is_branching_plus_imprint h.carrier).symm
  have hReadEq :
      quantum_readability_pressure_value
          (ctx.ordered_ctx.branching_magnitude h.carrier)
          (ctx.ordered_ctx.imprint_magnitude h.carrier)
          (ctx.ordered_ctx.stabilization_magnitude h.carrier) =
        ctx.ordered_ctx.quantum_readability_pressure_magnitude h.carrier := by
    unfold quantum_readability_pressure_value
    rw [hFragmentEq]
    exact
      (ctx.ordered_ctx.quantum_readability_pressure_is_fragment_plus_stabilization h.carrier).symm
  unfold quantum_predictive_pressure_contribution_value
  rw [hFragmentEq, hReadEq]
  exact
    ordered_quantum_pressure_and_full_predictive_accessibility_give_exact_predictive_level
      ctx.ordered_ctx
      h
      hBlocked
      hFull

theorem quantum_record_projects_to_bridge_neutral_entropy_shell
    {u : InterfaceProfile}
    (ctx : PhysicalQuantumRecordLocalAccessibilityFeedContext u)
    (h : LowLevelQuantumRecordTrace ctx.quantum_ctx) :
    let readinessCtx := ctx.local_accessibility_ctx.entropy_readiness_ctx
    StableTraceInside readinessCtx.recoverability_ctx.memory_ctx /\
    EntropyLikeDispersionInside readinessCtx.recoverability_ctx /\
    InterfaceForgettingInside readinessCtx.recoverability_ctx := by
  exact
    low_level_local_informational_accessibility_trace_gives_bridge_neutral_entropy_shell
      (ctx := ctx.local_accessibility_ctx)
      (quantum_record_projects_to_local_informational_accessibility_trace ctx h)

structure PhysicalLocalReadabilityCostContext (u : InterfaceProfile) where
  readability_ctx : PhysicalLocalReadabilityContext u
  accessibility_flag :
    readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Bool
  distributed_flag :
    readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Bool
  local_unreadability_magnitude :
    readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj -> Nat
  accessibility_flag_reflects_interface_accessible :
    ∀ x : readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      accessibility_flag x = true <->
        readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x
  distributed_flag_reflects_distributed :
    ∀ x : readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      distributed_flag x = true <->
        readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x
  local_unreadability_matches_derived_rule :
    ∀ x : readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      local_unreadability_magnitude x =
        local_unreadability_value
          (readability_ctx.tri_ctx.blockedness_magnitude x)
          (accessibility_flag x)
          (distributed_flag x)
  derived_locality_loss_matches_local_unreadability :
    ∀ x : readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
      readability_ctx.derived_locality_loss_magnitude x = local_unreadability_magnitude x

def QuantifiedLocalUnreadabilityMagnitudeInside {u : InterfaceProfile}
    (ctx : PhysicalLocalReadabilityCostContext u)
    (n : Nat) : Prop :=
  exists x : ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
    ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x /\
    RecordObject ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x /\
    ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x /\
    ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x /\
    ¬ ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x /\
    ctx.readability_ctx.local_readability_trace x /\
    ctx.local_unreadability_magnitude x = n

theorem low_level_local_readability_trace_gives_quantified_local_unreadability_magnitude_inside
    {u : InterfaceProfile}
    {ctx : PhysicalLocalReadabilityCostContext u}
    (h : LowLevelLocalReadabilityTrace ctx.readability_ctx) :
    QuantifiedLocalUnreadabilityMagnitudeInside ctx
      (ctx.local_unreadability_magnitude h.carrier) := by
  exact
    ⟨h.carrier, h.inside, h.record, h.distributed, h.recovery_blocked,
      h.inaccessible, h.readability_trace, rfl⟩

theorem quantified_local_unreadability_magnitude_inside_is_positive
    {u : InterfaceProfile}
    (ctx : PhysicalLocalReadabilityCostContext u)
    (n : Nat) :
    QuantifiedLocalUnreadabilityMagnitudeInside ctx n ->
      0 < n := by
  intro h
  rcases h with ⟨x, _hInside, _hRecord, hDistributed, hBlocked, hInaccessible, _hTrace, hMagnitude⟩
  have hAccFlag : ctx.accessibility_flag x = false := by
    cases hFlag : ctx.accessibility_flag x <;> simp at *
    exact False.elim (hInaccessible ((ctx.accessibility_flag_reflects_interface_accessible x).mp hFlag))
  have hDistFlag : ctx.distributed_flag x = true := by
    exact (ctx.distributed_flag_reflects_distributed x).mpr hDistributed
  rw [← hMagnitude, ctx.local_unreadability_matches_derived_rule x, hAccFlag, hDistFlag]
  exact
    local_unreadability_value_is_positive_when_inaccessible_and_distributed
      (ctx.readability_ctx.tri_ctx.blockedness_magnitude x)

theorem quantified_local_unreadability_magnitude_inside_gives_derived_locality_loss
    {u : InterfaceProfile}
    (ctx : PhysicalLocalReadabilityCostContext u)
    (n : Nat) :
    QuantifiedLocalUnreadabilityMagnitudeInside ctx n ->
      DerivedLocalityLossMagnitudeInside ctx.readability_ctx n := by
  intro h
  rcases h with ⟨x, hInside, hRecord, hDistributed, hBlocked, hInaccessible, hTrace, hMagnitude⟩
  exact
    ⟨x, hInside, hRecord, hDistributed, hBlocked, hInaccessible, hTrace,
      by rw [ctx.derived_locality_loss_matches_local_unreadability x, hMagnitude]⟩

theorem quantified_local_unreadability_magnitude_inside_gives_interface_forgetting
    {u : InterfaceProfile}
    (ctx : PhysicalLocalReadabilityCostContext u)
    (n : Nat) :
    QuantifiedLocalUnreadabilityMagnitudeInside ctx n ->
      InterfaceForgettingInside
        ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx := by
  intro h
  rcases h with ⟨x, hInside, hRecord, _hDistributed, hBlocked, _hInaccessible, _hTrace, _hMagnitude⟩
  exact ⟨x, hInside, hRecord, hBlocked⟩

theorem quantified_local_unreadability_magnitude_inside_gives_stable_trace_inside
    {u : InterfaceProfile}
    (ctx : PhysicalLocalReadabilityCostContext u)
    (n : Nat) :
    QuantifiedLocalUnreadabilityMagnitudeInside ctx n ->
      StableTraceInside
        ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx := by
  intro h
  rcases h with ⟨x, hInside, hRecord, _hDistributed, _hBlocked, _hInaccessible, _hTrace, _hMagnitude⟩
  exact ⟨x, hInside, hRecord⟩

theorem local_unreadability_trace_and_axis_values_give_quantified_recoverability_loss
    {u : InterfaceProfile}
    (ctx : PhysicalLocalReadabilityCostContext u)
    {x : ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj}
    {d b n : Nat} :
    ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
        ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
          ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
            ¬ ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
              ctx.readability_ctx.local_readability_trace x ->
                ctx.readability_ctx.tri_ctx.dispersion_magnitude x = d ->
                  ctx.readability_ctx.tri_ctx.blockedness_magnitude x = b ->
                    ctx.local_unreadability_magnitude x = n ->
                      QuantifiedRecoverabilityLossAtMagnitudeInside
                        ctx.readability_ctx.tri_ctx.loss_ctx
                        (tri_spectral_loss_value
                          ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level
                          d b n) := by
  intro hInside hRecord hDistributed hBlocked hInaccessible hTrace hDisp hBlockedMag hUnreadability
  have hLocality :
      ctx.readability_ctx.tri_ctx.locality_magnitude x = n := by
    rw [ctx.readability_ctx.derived_locality_projects_to_tri_locality
          x hInside hRecord hDistributed hBlocked hInaccessible hTrace]
    rw [ctx.derived_locality_loss_matches_local_unreadability x]
    exact hUnreadability
  exact
    recoverability_tri_spectrum_axes_give_quantified_recoverability_loss
      ctx.readability_ctx.tri_ctx
      hInside hRecord hDistributed hBlocked hInaccessible hDisp hBlockedMag hLocality

theorem quantified_local_unreadability_and_full_predictive_accessibility_give_exact_predictive_level
    {u : InterfaceProfile}
    (ctx : PhysicalLocalReadabilityCostContext u)
    {x : ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj}
    (n : Nat) :
    ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
        ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
          ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
            ¬ ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
              ctx.readability_ctx.local_readability_trace x ->
                ctx.local_unreadability_magnitude x = n ->
                  FullPredictiveAccessibilityGradientInside
                    ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx ->
                    PredictiveAccessibilityAtLevelInside
                      ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx
                      (ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level -
                        tri_spectral_loss_value
                          ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level
                          (ctx.readability_ctx.tri_ctx.dispersion_magnitude x)
                          (ctx.readability_ctx.tri_ctx.blockedness_magnitude x)
                          n) := by
  intro hInside hRecord hDistributed hBlocked hInaccessible hTrace hMagnitude hFull
  have hLoss :
      QuantifiedRecoverabilityLossAtMagnitudeInside
        ctx.readability_ctx.tri_ctx.loss_ctx
        (tri_spectral_loss_value
          ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level
          (ctx.readability_ctx.tri_ctx.dispersion_magnitude x)
          (ctx.readability_ctx.tri_ctx.blockedness_magnitude x)
          n) := by
    exact
      local_unreadability_trace_and_axis_values_give_quantified_recoverability_loss
        ctx
        hInside hRecord hDistributed hBlocked hInaccessible hTrace
        rfl rfl hMagnitude
  exact
    recoverability_tri_spectrum_and_full_predictive_accessibility_give_exact_predictive_level
      ctx.readability_ctx.tri_ctx
      (tri_spectral_loss_value
        ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level
        (ctx.readability_ctx.tri_ctx.dispersion_magnitude x)
        (ctx.readability_ctx.tri_ctx.blockedness_magnitude x)
        n)
      hLoss
      hFull

theorem quantified_local_unreadability_and_full_predictive_accessibility_give_exact_predictive_drop
    {u : InterfaceProfile}
    (ctx : PhysicalLocalReadabilityCostContext u)
    {x : ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj}
    (n : Nat) :
    ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x ->
      RecordObject ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x ->
        ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x ->
          ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x ->
            ¬ ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x ->
              ctx.readability_ctx.local_readability_trace x ->
                ctx.local_unreadability_magnitude x = n ->
                  FullPredictiveAccessibilityGradientInside
                    ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx ->
                    exists p : ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.predictive_ctx.Proc,
                      ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.predictive_ctx.inside_universe p /\
                      ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.predictive_ctx.expected_candidate p /\
                      ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.predictive_ctx.result_trace p /\
                      ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.predictive_accessibility_level p +
                        tri_spectral_loss_value
                          ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level
                          (ctx.readability_ctx.tri_ctx.dispersion_magnitude x)
                          (ctx.readability_ctx.tri_ctx.blockedness_magnitude x)
                          n =
                        ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level := by
  intro hInside hRecord hDistributed hBlocked hInaccessible hTrace hMagnitude hFull
  have hLoss :
      QuantifiedRecoverabilityLossAtMagnitudeInside
        ctx.readability_ctx.tri_ctx.loss_ctx
        (tri_spectral_loss_value
          ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level
          (ctx.readability_ctx.tri_ctx.dispersion_magnitude x)
          (ctx.readability_ctx.tri_ctx.blockedness_magnitude x)
          n) := by
    exact
      local_unreadability_trace_and_axis_values_give_quantified_recoverability_loss
        ctx
        hInside hRecord hDistributed hBlocked hInaccessible hTrace
        rfl rfl hMagnitude
  exact
    recoverability_tri_spectrum_and_full_predictive_accessibility_give_exact_predictive_drop
      ctx.readability_ctx.tri_ctx
      (tri_spectral_loss_value
        ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level
        (ctx.readability_ctx.tri_ctx.dispersion_magnitude x)
        (ctx.readability_ctx.tri_ctx.blockedness_magnitude x)
        n)
      hLoss
      hFull

def FourLayerForgettingChainInside {u : InterfaceProfile}
    (ctx : PhysicalLocalReadabilityCostContext u) : Prop :=
  StableTraceInside ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx /\
  (RecoverableTraceInside ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx ->
    ∃ n : Nat, QuantifiedLocalUnreadabilityMagnitudeInside ctx n) /\
  (∃ n : Nat, QuantifiedLocalUnreadabilityMagnitudeInside ctx n) /\
  (∃ level : Nat,
    PredictiveAccessibilityAtLevelInside
      ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx level)

theorem low_level_recoverability_and_local_unreadability_traces_give_four_layer_forgetting_chain
    {u : InterfaceProfile}
    (ctx : PhysicalLocalReadabilityCostContext u)
    (hRead : LowLevelLocalReadabilityTrace ctx.readability_ctx)
    (hFull :
      FullPredictiveAccessibilityGradientInside
        ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx) :
    FourLayerForgettingChainInside ctx := by
  have hStable :
      StableTraceInside
        ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx := by
    exact ⟨hRead.carrier, hRead.inside, hRead.record⟩
  have hUnreadability :
      QuantifiedLocalUnreadabilityMagnitudeInside ctx
        (ctx.local_unreadability_magnitude hRead.carrier) := by
    exact low_level_local_readability_trace_gives_quantified_local_unreadability_magnitude_inside hRead
  have hLevel :
      PredictiveAccessibilityAtLevelInside
        ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx
        (ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level -
          tri_spectral_loss_value
            ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level
            (ctx.readability_ctx.tri_ctx.dispersion_magnitude hRead.carrier)
            (ctx.readability_ctx.tri_ctx.blockedness_magnitude hRead.carrier)
            (ctx.local_unreadability_magnitude hRead.carrier)) := by
    exact
      quantified_local_unreadability_and_full_predictive_accessibility_give_exact_predictive_level
        ctx
        (x := hRead.carrier)
        (ctx.local_unreadability_magnitude hRead.carrier)
        hRead.inside
        hRead.record
        hRead.distributed
        hRead.recovery_blocked
        hRead.inaccessible
        hRead.readability_trace
        rfl
        hFull
  exact
    ⟨hStable, by
      intro _hRecoverable
      exact ⟨_, hUnreadability⟩,
      ⟨_, hUnreadability⟩, ⟨_, hLevel⟩⟩

structure PhysicalClosureBridge (u : InterfaceProfile) : Prop where
  full_interface_form : True
  internal_projection : True
  projection_inside_universe : True
  trace_preserved : True
  no_projection_error : True
  closure : u.closure

/-!
Refined closure/projectivity bridge.

Closure is not bare identity and not external observation. It is internal
projectivity: a projection of the full interface form remains inside the
universe, preserves trace back to the full form, and avoids projection error.
-/

structure PhysicalClosureContext (u : InterfaceProfile) where
  Obj : Type
  inside_universe : Obj -> Prop
  full_interface_form : Obj -> Prop
  internal_projection : Obj -> Prop
  projection_inside_universe : Obj -> Prop
  trace_preserved : Obj -> Prop
  no_projection_error : Obj -> Prop
  primary_interface_projection : Obj -> Prop
  trace_compare_information_projection : Obj -> Prop
  typed_domain_closure_projection : Obj -> Prop
  internal_observer_projection : Obj -> Prop
  system_code_projection : Obj -> Prop
  projective_closure_inside_gives_profile_closure :
    (exists x : Obj,
      inside_universe x /\
      full_interface_form x /\
      internal_projection x /\
      projection_inside_universe x /\
      trace_preserved x /\
      no_projection_error x) -> u.closure

def ProjectiveClosureObject {u : InterfaceProfile}
    (ctx : PhysicalClosureContext u)
    (x : ctx.Obj) : Prop :=
  ctx.full_interface_form x /\
  ctx.internal_projection x /\
  ctx.projection_inside_universe x /\
  ctx.trace_preserved x /\
  ctx.no_projection_error x

def ProjectiveClosureWitnessInside {u : InterfaceProfile}
    (ctx : PhysicalClosureContext u) : Prop :=
  exists x : ctx.Obj, ctx.inside_universe x /\ ProjectiveClosureObject ctx x

structure LowLevelProjectiveClosureTrace {u : InterfaceProfile}
    (ctx : PhysicalClosureContext u) where
  carrier : ctx.Obj
  inside : ctx.inside_universe carrier
  full_interface_form : ctx.full_interface_form carrier
  internal_projection : ctx.internal_projection carrier
  projection_inside_universe : ctx.projection_inside_universe carrier
  trace_preserved : ctx.trace_preserved carrier
  no_projection_error : ctx.no_projection_error carrier

def PrimaryInterfaceProjectionWitness {u : InterfaceProfile}
    (ctx : PhysicalClosureContext u) : Prop :=
  exists x : ctx.Obj,
    ctx.inside_universe x /\
    ctx.primary_interface_projection x /\
    ProjectiveClosureObject ctx x

def TraceCompareInformationProjectionWitness {u : InterfaceProfile}
    (ctx : PhysicalClosureContext u) : Prop :=
  exists x : ctx.Obj,
    ctx.inside_universe x /\
    ctx.trace_compare_information_projection x /\
    ProjectiveClosureObject ctx x

def TypedDomainClosureProjectionWitness {u : InterfaceProfile}
    (ctx : PhysicalClosureContext u) : Prop :=
  exists x : ctx.Obj,
    ctx.inside_universe x /\
    ctx.typed_domain_closure_projection x /\
    ProjectiveClosureObject ctx x

def InternalObserverProjectionWitness {u : InterfaceProfile}
    (ctx : PhysicalClosureContext u) : Prop :=
  exists x : ctx.Obj,
    ctx.inside_universe x /\
    ctx.internal_observer_projection x /\
    ProjectiveClosureObject ctx x

def SystemCodeProjectionWitness {u : InterfaceProfile}
    (ctx : PhysicalClosureContext u) : Prop :=
  exists x : ctx.Obj,
    ctx.inside_universe x /\
    ctx.system_code_projection x /\
    ProjectiveClosureObject ctx x

theorem projective_closure_object_unfolds_to_internal_trace_preserving_projection
    {u : InterfaceProfile}
    (ctx : PhysicalClosureContext u)
    (x : ctx.Obj) :
    ProjectiveClosureObject ctx x <->
      ctx.full_interface_form x /\
      ctx.internal_projection x /\
      ctx.projection_inside_universe x /\
      ctx.trace_preserved x /\
      ctx.no_projection_error x := by
  rfl

theorem low_level_projective_closure_trace_gives_projective_closure_inside
    {u : InterfaceProfile}
    {ctx : PhysicalClosureContext u} :
    LowLevelProjectiveClosureTrace ctx ->
      ProjectiveClosureWitnessInside ctx := by
  intro h
  exact ⟨
    h.carrier,
    h.inside,
    h.full_interface_form,
    h.internal_projection,
    h.projection_inside_universe,
    h.trace_preserved,
    h.no_projection_error
  ⟩

theorem primary_interface_projection_witness_gives_projective_closure_inside
    {u : InterfaceProfile}
    {ctx : PhysicalClosureContext u} :
    PrimaryInterfaceProjectionWitness ctx -> ProjectiveClosureWitnessInside ctx := by
  intro h
  rcases h with ⟨x, hInside, _hClass, hClosure⟩
  exact ⟨x, hInside, hClosure⟩

theorem trace_compare_information_projection_witness_gives_projective_closure_inside
    {u : InterfaceProfile}
    {ctx : PhysicalClosureContext u} :
    TraceCompareInformationProjectionWitness ctx -> ProjectiveClosureWitnessInside ctx := by
  intro h
  rcases h with ⟨x, hInside, _hClass, hClosure⟩
  exact ⟨x, hInside, hClosure⟩

theorem typed_domain_closure_projection_witness_gives_projective_closure_inside
    {u : InterfaceProfile}
    {ctx : PhysicalClosureContext u} :
    TypedDomainClosureProjectionWitness ctx -> ProjectiveClosureWitnessInside ctx := by
  intro h
  rcases h with ⟨x, hInside, _hClass, hClosure⟩
  exact ⟨x, hInside, hClosure⟩

theorem internal_observer_projection_witness_gives_projective_closure_inside
    {u : InterfaceProfile}
    {ctx : PhysicalClosureContext u} :
    InternalObserverProjectionWitness ctx -> ProjectiveClosureWitnessInside ctx := by
  intro h
  rcases h with ⟨x, hInside, _hClass, hClosure⟩
  exact ⟨x, hInside, hClosure⟩

theorem system_code_projection_witness_gives_projective_closure_inside
    {u : InterfaceProfile}
    {ctx : PhysicalClosureContext u} :
    SystemCodeProjectionWitness ctx -> ProjectiveClosureWitnessInside ctx := by
  intro h
  rcases h with ⟨x, hInside, _hClass, hClosure⟩
  exact ⟨x, hInside, hClosure⟩

theorem projective_closure_inside_gives_profile_closure
    {u : InterfaceProfile}
    (ctx : PhysicalClosureContext u) :
    ProjectiveClosureWitnessInside ctx -> u.closure := by
  intro h
  rcases h with ⟨x, hInside, hFull, hProjection, hProjectionInside, hTrace, hNoError⟩
  exact ctx.projective_closure_inside_gives_profile_closure
    ⟨x, hInside, hFull, hProjection, hProjectionInside, hTrace, hNoError⟩

theorem projective_closure_inside_gives_physical_closure_bridge
    {u : InterfaceProfile}
    (ctx : PhysicalClosureContext u) :
    ProjectiveClosureWitnessInside ctx -> PhysicalClosureBridge u := by
  intro h
  exact {
    full_interface_form := by trivial
    internal_projection := by trivial
    projection_inside_universe := by trivial
    trace_preserved := by trivial
    no_projection_error := by trivial
    closure := projective_closure_inside_gives_profile_closure ctx h
  }

theorem low_level_projective_closure_trace_gives_physical_closure_bridge
    {u : InterfaceProfile}
    {ctx : PhysicalClosureContext u} :
    LowLevelProjectiveClosureTrace ctx -> PhysicalClosureBridge u := by
  intro h
  exact projective_closure_inside_gives_physical_closure_bridge
    ctx
    (low_level_projective_closure_trace_gives_projective_closure_inside h)

structure PhysicalBridgeCriteria (u : InterfaceProfile) : Prop where
  record : PhysicalRecordBridge u
  self_model : PhysicalSelfModelBridge u
  adaptive_selection : PhysicalAdaptiveSelectionBridge u
  predictive_correction : PhysicalPredictiveCorrectionBridge u
  closure : PhysicalClosureBridge u

structure PhysicalFullCriteria (u : InterfaceProfile) : Prop where
  self_process : UniverseAsSelfInterface u
  bridges : PhysicalBridgeCriteria u

/-!
Physical witness bundle.

This structure is the assembly layer for the five refined physical bridge
witnesses. It does not assert that the empirical universe supplies the
witnesses; it states that if all five witness layers and the self-process layer
are present, then the earlier physical full criteria follow.
-/

structure PhysicalWitnessBundle (u : InterfaceProfile) where
  self_process : UniverseAsSelfInterface u
  memory_ctx : PhysicalMemoryContext u
  memory_witness : StableTraceInside memory_ctx
  self_model_ctx : PhysicalSelfModelContext u
  self_model_witness : SelfModelWitnessInside self_model_ctx
  adaptive_selection_ctx : PhysicalAdaptiveSelectionContext u
  adaptive_selection_witness : AdaptiveSelectionWitnessInside adaptive_selection_ctx
  predictive_correction_ctx : PhysicalPredictiveCorrectionContext u
  predictive_correction_witness :
    PredictiveCorrectionWitnessInside predictive_correction_ctx
  closure_ctx : PhysicalClosureContext u
  closure_witness : ProjectiveClosureWitnessInside closure_ctx

structure PhysicalWitnessBundleWithLowLevelMemory (u : InterfaceProfile) where
  self_process : UniverseAsSelfInterface u
  memory_ctx : PhysicalMemoryContext u
  memory_trace : LowLevelMemoryTrace memory_ctx
  self_model_ctx : PhysicalSelfModelContext u
  self_model_witness : SelfModelWitnessInside self_model_ctx
  adaptive_selection_ctx : PhysicalAdaptiveSelectionContext u
  adaptive_selection_witness : AdaptiveSelectionWitnessInside adaptive_selection_ctx
  predictive_correction_ctx : PhysicalPredictiveCorrectionContext u
  predictive_correction_witness :
    PredictiveCorrectionWitnessInside predictive_correction_ctx
  closure_ctx : PhysicalClosureContext u
  closure_witness : ProjectiveClosureWitnessInside closure_ctx

structure PhysicalWitnessBundleWithLowLevelSelfModel
    (u : InterfaceProfile) where
  self_process : UniverseAsSelfInterface u
  memory_ctx : PhysicalMemoryContext u
  memory_witness : StableTraceInside memory_ctx
  self_model_ctx : PhysicalSelfModelContext u
  self_model_trace : LowLevelSelfModelTrace self_model_ctx
  adaptive_selection_ctx : PhysicalAdaptiveSelectionContext u
  adaptive_selection_witness : AdaptiveSelectionWitnessInside adaptive_selection_ctx
  predictive_correction_ctx : PhysicalPredictiveCorrectionContext u
  predictive_correction_witness :
    PredictiveCorrectionWitnessInside predictive_correction_ctx
  closure_ctx : PhysicalClosureContext u
  closure_witness : ProjectiveClosureWitnessInside closure_ctx

structure PhysicalWitnessBundleWithLowLevelAdaptiveSelection
    (u : InterfaceProfile) where
  self_process : UniverseAsSelfInterface u
  memory_ctx : PhysicalMemoryContext u
  memory_witness : StableTraceInside memory_ctx
  self_model_ctx : PhysicalSelfModelContext u
  self_model_witness : SelfModelWitnessInside self_model_ctx
  adaptive_selection_ctx : PhysicalAdaptiveSelectionContext u
  adaptive_selection_trace :
    LowLevelAdaptiveSelectionTrace adaptive_selection_ctx
  predictive_correction_ctx : PhysicalPredictiveCorrectionContext u
  predictive_correction_witness :
    PredictiveCorrectionWitnessInside predictive_correction_ctx
  closure_ctx : PhysicalClosureContext u
  closure_witness : ProjectiveClosureWitnessInside closure_ctx

structure PhysicalWitnessBundleWithLowLevelPredictiveCorrection
    (u : InterfaceProfile) where
  self_process : UniverseAsSelfInterface u
  memory_ctx : PhysicalMemoryContext u
  memory_witness : StableTraceInside memory_ctx
  self_model_ctx : PhysicalSelfModelContext u
  self_model_witness : SelfModelWitnessInside self_model_ctx
  adaptive_selection_ctx : PhysicalAdaptiveSelectionContext u
  adaptive_selection_witness : AdaptiveSelectionWitnessInside adaptive_selection_ctx
  predictive_correction_ctx : PhysicalPredictiveCorrectionContext u
  predictive_correction_trace :
    LowLevelPredictiveCorrectionTrace predictive_correction_ctx
  closure_ctx : PhysicalClosureContext u
  closure_witness : ProjectiveClosureWitnessInside closure_ctx

structure PhysicalWitnessBundleWithLowLevelProjectiveClosure
    (u : InterfaceProfile) where
  self_process : UniverseAsSelfInterface u
  memory_ctx : PhysicalMemoryContext u
  memory_witness : StableTraceInside memory_ctx
  self_model_ctx : PhysicalSelfModelContext u
  self_model_witness : SelfModelWitnessInside self_model_ctx
  adaptive_selection_ctx : PhysicalAdaptiveSelectionContext u
  adaptive_selection_witness : AdaptiveSelectionWitnessInside adaptive_selection_ctx
  predictive_correction_ctx : PhysicalPredictiveCorrectionContext u
  predictive_correction_witness :
    PredictiveCorrectionWitnessInside predictive_correction_ctx
  closure_ctx : PhysicalClosureContext u
  closure_trace : LowLevelProjectiveClosureTrace closure_ctx

structure PhysicalWitnessBundleWithAllLowLevelBridges
    (u : InterfaceProfile) where
  self_process : UniverseAsSelfInterface u
  memory_ctx : PhysicalMemoryContext u
  memory_trace : LowLevelMemoryTrace memory_ctx
  self_model_ctx : PhysicalSelfModelContext u
  self_model_trace : LowLevelSelfModelTrace self_model_ctx
  adaptive_selection_ctx : PhysicalAdaptiveSelectionContext u
  adaptive_selection_trace :
    LowLevelAdaptiveSelectionTrace adaptive_selection_ctx
  predictive_correction_ctx : PhysicalPredictiveCorrectionContext u
  predictive_correction_trace :
    LowLevelPredictiveCorrectionTrace predictive_correction_ctx
  closure_ctx : PhysicalClosureContext u
  closure_trace : LowLevelProjectiveClosureTrace closure_ctx

structure PhysicalWitnessBundleWithLowLevelSelfProcessAndAllLowLevelBridges
    (u : InterfaceProfile) where
  self_process_ctx : UniverseSelfProcessContext u
  self_process_trace : LowLevelSelfProcessTrace self_process_ctx
  memory_ctx : PhysicalMemoryContext u
  memory_trace : LowLevelMemoryTrace memory_ctx
  self_model_ctx : PhysicalSelfModelContext u
  self_model_trace : LowLevelSelfModelTrace self_model_ctx
  adaptive_selection_ctx : PhysicalAdaptiveSelectionContext u
  adaptive_selection_trace :
    LowLevelAdaptiveSelectionTrace adaptive_selection_ctx
  predictive_correction_ctx : PhysicalPredictiveCorrectionContext u
  predictive_correction_trace :
    LowLevelPredictiveCorrectionTrace predictive_correction_ctx
  closure_ctx : PhysicalClosureContext u
  closure_trace : LowLevelProjectiveClosureTrace closure_ctx

def low_level_memory_bundle_gives_physical_witness_bundle
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithLowLevelMemory u -> PhysicalWitnessBundle u := by
  intro h
  exact {
    self_process := h.self_process
    memory_ctx := h.memory_ctx
    memory_witness :=
      low_level_memory_trace_gives_stable_trace_inside h.memory_trace
    self_model_ctx := h.self_model_ctx
    self_model_witness := h.self_model_witness
    adaptive_selection_ctx := h.adaptive_selection_ctx
    adaptive_selection_witness := h.adaptive_selection_witness
    predictive_correction_ctx := h.predictive_correction_ctx
    predictive_correction_witness := h.predictive_correction_witness
    closure_ctx := h.closure_ctx
    closure_witness := h.closure_witness
  }

def low_level_self_model_bundle_gives_physical_witness_bundle
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithLowLevelSelfModel u ->
      PhysicalWitnessBundle u := by
  intro h
  exact {
    self_process := h.self_process
    memory_ctx := h.memory_ctx
    memory_witness := h.memory_witness
    self_model_ctx := h.self_model_ctx
    self_model_witness :=
      low_level_self_model_trace_gives_self_model_inside
        h.self_model_trace
    adaptive_selection_ctx := h.adaptive_selection_ctx
    adaptive_selection_witness := h.adaptive_selection_witness
    predictive_correction_ctx := h.predictive_correction_ctx
    predictive_correction_witness := h.predictive_correction_witness
    closure_ctx := h.closure_ctx
    closure_witness := h.closure_witness
  }

def low_level_adaptive_selection_bundle_gives_physical_witness_bundle
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithLowLevelAdaptiveSelection u ->
      PhysicalWitnessBundle u := by
  intro h
  exact {
    self_process := h.self_process
    memory_ctx := h.memory_ctx
    memory_witness := h.memory_witness
    self_model_ctx := h.self_model_ctx
    self_model_witness := h.self_model_witness
    adaptive_selection_ctx := h.adaptive_selection_ctx
    adaptive_selection_witness :=
      low_level_adaptive_selection_trace_gives_adaptive_selection_inside
        h.adaptive_selection_trace
    predictive_correction_ctx := h.predictive_correction_ctx
    predictive_correction_witness := h.predictive_correction_witness
    closure_ctx := h.closure_ctx
    closure_witness := h.closure_witness
  }

def low_level_predictive_correction_bundle_gives_physical_witness_bundle
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithLowLevelPredictiveCorrection u ->
      PhysicalWitnessBundle u := by
  intro h
  exact {
    self_process := h.self_process
    memory_ctx := h.memory_ctx
    memory_witness := h.memory_witness
    self_model_ctx := h.self_model_ctx
    self_model_witness := h.self_model_witness
    adaptive_selection_ctx := h.adaptive_selection_ctx
    adaptive_selection_witness := h.adaptive_selection_witness
    predictive_correction_ctx := h.predictive_correction_ctx
    predictive_correction_witness :=
      low_level_predictive_correction_trace_gives_predictive_correction_inside
        h.predictive_correction_trace
    closure_ctx := h.closure_ctx
    closure_witness := h.closure_witness
  }

def low_level_projective_closure_bundle_gives_physical_witness_bundle
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithLowLevelProjectiveClosure u ->
      PhysicalWitnessBundle u := by
  intro h
  exact {
    self_process := h.self_process
    memory_ctx := h.memory_ctx
    memory_witness := h.memory_witness
    self_model_ctx := h.self_model_ctx
    self_model_witness := h.self_model_witness
    adaptive_selection_ctx := h.adaptive_selection_ctx
    adaptive_selection_witness := h.adaptive_selection_witness
    predictive_correction_ctx := h.predictive_correction_ctx
    predictive_correction_witness := h.predictive_correction_witness
    closure_ctx := h.closure_ctx
    closure_witness :=
      low_level_projective_closure_trace_gives_projective_closure_inside
        h.closure_trace
  }

def all_low_level_bundle_gives_physical_witness_bundle
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithAllLowLevelBridges u ->
      PhysicalWitnessBundle u := by
  intro h
  exact {
    self_process := h.self_process
    memory_ctx := h.memory_ctx
    memory_witness :=
      low_level_memory_trace_gives_stable_trace_inside h.memory_trace
    self_model_ctx := h.self_model_ctx
    self_model_witness :=
      low_level_self_model_trace_gives_self_model_inside
        h.self_model_trace
    adaptive_selection_ctx := h.adaptive_selection_ctx
    adaptive_selection_witness :=
      low_level_adaptive_selection_trace_gives_adaptive_selection_inside
        h.adaptive_selection_trace
    predictive_correction_ctx := h.predictive_correction_ctx
    predictive_correction_witness :=
      low_level_predictive_correction_trace_gives_predictive_correction_inside
        h.predictive_correction_trace
    closure_ctx := h.closure_ctx
    closure_witness :=
      low_level_projective_closure_trace_gives_projective_closure_inside
        h.closure_trace
  }

def low_level_self_process_all_low_level_bundle_gives_all_low_level_bundle
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithLowLevelSelfProcessAndAllLowLevelBridges u ->
      PhysicalWitnessBundleWithAllLowLevelBridges u := by
  intro h
  exact {
    self_process :=
      low_level_self_process_trace_gives_universe_as_self_interface
        h.self_process_trace
    memory_ctx := h.memory_ctx
    memory_trace := h.memory_trace
    self_model_ctx := h.self_model_ctx
    self_model_trace := h.self_model_trace
    adaptive_selection_ctx := h.adaptive_selection_ctx
    adaptive_selection_trace := h.adaptive_selection_trace
    predictive_correction_ctx := h.predictive_correction_ctx
    predictive_correction_trace := h.predictive_correction_trace
    closure_ctx := h.closure_ctx
    closure_trace := h.closure_trace
  }

theorem physical_witness_bundle_gives_bridge_criteria
    {u : InterfaceProfile} :
    PhysicalWitnessBundle u -> PhysicalBridgeCriteria u := by
  intro h
  exact {
    record :=
      stable_trace_inside_gives_physical_record_bridge
        h.memory_ctx
        h.memory_witness
    self_model :=
      self_model_inside_gives_physical_self_model_bridge
        h.self_model_ctx
        h.self_model_witness
    adaptive_selection :=
      adaptive_selection_inside_gives_physical_adaptive_selection_bridge
        h.adaptive_selection_ctx
        h.adaptive_selection_witness
    predictive_correction :=
      predictive_correction_inside_gives_physical_predictive_correction_bridge
        h.predictive_correction_ctx
        h.predictive_correction_witness
    closure :=
      projective_closure_inside_gives_physical_closure_bridge
        h.closure_ctx
        h.closure_witness
  }

theorem physical_witness_bundle_gives_physical_full_criteria
    {u : InterfaceProfile} :
    PhysicalWitnessBundle u -> PhysicalFullCriteria u := by
  intro h
  exact {
    self_process := h.self_process
    bridges := physical_witness_bundle_gives_bridge_criteria h
  }

theorem low_level_memory_bundle_gives_physical_full_criteria
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithLowLevelMemory u -> PhysicalFullCriteria u := by
  intro h
  exact physical_witness_bundle_gives_physical_full_criteria
    (low_level_memory_bundle_gives_physical_witness_bundle h)

theorem low_level_self_model_bundle_gives_physical_full_criteria
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithLowLevelSelfModel u ->
      PhysicalFullCriteria u := by
  intro h
  exact physical_witness_bundle_gives_physical_full_criteria
    (low_level_self_model_bundle_gives_physical_witness_bundle h)

theorem low_level_adaptive_selection_bundle_gives_physical_full_criteria
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithLowLevelAdaptiveSelection u ->
      PhysicalFullCriteria u := by
  intro h
  exact physical_witness_bundle_gives_physical_full_criteria
    (low_level_adaptive_selection_bundle_gives_physical_witness_bundle h)

theorem low_level_predictive_correction_bundle_gives_physical_full_criteria
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithLowLevelPredictiveCorrection u ->
      PhysicalFullCriteria u := by
  intro h
  exact physical_witness_bundle_gives_physical_full_criteria
    (low_level_predictive_correction_bundle_gives_physical_witness_bundle h)

theorem low_level_projective_closure_bundle_gives_physical_full_criteria
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithLowLevelProjectiveClosure u ->
      PhysicalFullCriteria u := by
  intro h
  exact physical_witness_bundle_gives_physical_full_criteria
    (low_level_projective_closure_bundle_gives_physical_witness_bundle h)

theorem all_low_level_bundle_gives_physical_full_criteria
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithAllLowLevelBridges u ->
      PhysicalFullCriteria u := by
  intro h
  exact physical_witness_bundle_gives_physical_full_criteria
    (all_low_level_bundle_gives_physical_witness_bundle h)

theorem low_level_self_process_all_low_level_bundle_gives_physical_full_criteria
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithLowLevelSelfProcessAndAllLowLevelBridges u ->
      PhysicalFullCriteria u := by
  intro h
  exact all_low_level_bundle_gives_physical_full_criteria
    (low_level_self_process_all_low_level_bundle_gives_all_low_level_bundle h)

theorem physical_bridge_criteria_give_intelligence_claim
    (u : InterfaceProfile)
    (hInterface : Interfacehood u)
    (h : PhysicalBridgeCriteria u) :
    IntelligenceClaim u := by
  exact {
    interface := hInterface
    record := h.record.record
    self_model := h.self_model.self_model
    adaptive_selection := h.adaptive_selection.adaptive_selection
    predictive_correction := h.predictive_correction.predictive_correction
  }

theorem physical_full_criteria_give_self_closed_intelligent_interface
    (u : InterfaceProfile) :
    PhysicalFullCriteria u -> SelfClosedIntelligentInterface u := by
  intro h
  exact universe_full_criteria_give_self_closed_intelligent_interface
    u
    h.self_process
    (physical_bridge_criteria_give_intelligence_claim
      u
      h.self_process.self_interface
      h.bridges)
    h.bridges.closure.closure

theorem physical_witness_bundle_gives_self_closed_intelligent_interface
    {u : InterfaceProfile} :
    PhysicalWitnessBundle u -> SelfClosedIntelligentInterface u := by
  intro h
  exact physical_full_criteria_give_self_closed_intelligent_interface
    u
    (physical_witness_bundle_gives_physical_full_criteria h)

theorem low_level_memory_bundle_gives_self_closed_intelligent_interface
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithLowLevelMemory u ->
      SelfClosedIntelligentInterface u := by
  intro h
  exact physical_witness_bundle_gives_self_closed_intelligent_interface
    (low_level_memory_bundle_gives_physical_witness_bundle h)

theorem low_level_self_model_bundle_gives_self_closed_intelligent_interface
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithLowLevelSelfModel u ->
      SelfClosedIntelligentInterface u := by
  intro h
  exact physical_witness_bundle_gives_self_closed_intelligent_interface
    (low_level_self_model_bundle_gives_physical_witness_bundle h)

theorem low_level_adaptive_selection_bundle_gives_self_closed_intelligent_interface
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithLowLevelAdaptiveSelection u ->
      SelfClosedIntelligentInterface u := by
  intro h
  exact physical_witness_bundle_gives_self_closed_intelligent_interface
    (low_level_adaptive_selection_bundle_gives_physical_witness_bundle h)

theorem low_level_predictive_correction_bundle_gives_self_closed_intelligent_interface
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithLowLevelPredictiveCorrection u ->
      SelfClosedIntelligentInterface u := by
  intro h
  exact physical_witness_bundle_gives_self_closed_intelligent_interface
    (low_level_predictive_correction_bundle_gives_physical_witness_bundle h)

theorem low_level_projective_closure_bundle_gives_self_closed_intelligent_interface
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithLowLevelProjectiveClosure u ->
      SelfClosedIntelligentInterface u := by
  intro h
  exact physical_witness_bundle_gives_self_closed_intelligent_interface
    (low_level_projective_closure_bundle_gives_physical_witness_bundle h)

theorem all_low_level_bundle_gives_self_closed_intelligent_interface
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithAllLowLevelBridges u ->
      SelfClosedIntelligentInterface u := by
  intro h
  exact physical_witness_bundle_gives_self_closed_intelligent_interface
    (all_low_level_bundle_gives_physical_witness_bundle h)

theorem low_level_self_process_all_low_level_bundle_gives_self_closed_intelligent_interface
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithLowLevelSelfProcessAndAllLowLevelBridges u ->
      SelfClosedIntelligentInterface u := by
  intro h
  exact all_low_level_bundle_gives_self_closed_intelligent_interface
    (low_level_self_process_all_low_level_bundle_gives_all_low_level_bundle h)

theorem physical_witness_bundle_projects_all_criteria
    {u : InterfaceProfile} :
    PhysicalWitnessBundle u ->
      Interfacehood u /\
      u.selfObservation /\
      u.distinctionsBecomeStates /\
      u.statesBecomeEvents /\
      u.eventsBecomeMemory /\
      u.memoryBecomesThinking /\
      u.record /\
      u.selfModel /\
      u.adaptiveSelection /\
      u.predictiveCorrection /\
      u.closure := by
  intro h
  exact self_closed_intelligent_interface_projects_all_criteria
    u
    (physical_witness_bundle_gives_self_closed_intelligent_interface h)

theorem all_low_level_bundle_projects_all_criteria
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithAllLowLevelBridges u ->
      Interfacehood u /\
      u.selfObservation /\
      u.distinctionsBecomeStates /\
      u.statesBecomeEvents /\
      u.eventsBecomeMemory /\
      u.memoryBecomesThinking /\
      u.record /\
      u.selfModel /\
      u.adaptiveSelection /\
      u.predictiveCorrection /\
      u.closure := by
  intro h
  exact physical_witness_bundle_projects_all_criteria
    (all_low_level_bundle_gives_physical_witness_bundle h)

theorem low_level_self_process_all_low_level_bundle_projects_all_criteria
    {u : InterfaceProfile} :
    PhysicalWitnessBundleWithLowLevelSelfProcessAndAllLowLevelBridges u ->
      Interfacehood u /\
      u.selfObservation /\
      u.distinctionsBecomeStates /\
      u.statesBecomeEvents /\
      u.eventsBecomeMemory /\
      u.memoryBecomesThinking /\
      u.record /\
      u.selfModel /\
      u.adaptiveSelection /\
      u.predictiveCorrection /\
      u.closure := by
  intro h
  exact all_low_level_bundle_projects_all_criteria
    (low_level_self_process_all_low_level_bundle_gives_all_low_level_bundle h)

theorem self_closed_intelligent_interface_from_physical_bridges_projects_all_criteria
    (u : InterfaceProfile) :
    PhysicalFullCriteria u ->
      Interfacehood u /\
      u.selfObservation /\
      u.distinctionsBecomeStates /\
      u.statesBecomeEvents /\
      u.eventsBecomeMemory /\
      u.memoryBecomesThinking /\
      u.record /\
      u.selfModel /\
      u.adaptiveSelection /\
      u.predictiveCorrection /\
      u.closure := by
  intro h
  exact self_closed_intelligent_interface_projects_all_criteria
    u
    (physical_full_criteria_give_self_closed_intelligent_interface u h)

def ModelInsideOnlySelfModelProfile : InterfaceProfile :=
  { interface := True
    record := False
    selfModel := False
    adaptiveSelection := False
    predictiveCorrection := False
    selfObservation := False
    closure := False
    distinctionsBecomeStates := False
    statesBecomeEvents := False
    eventsBecomeMemory := False
    memoryBecomesThinking := False }

def ModelInsideOnlySelfModelContext :
    PhysicalSelfModelContext ModelInsideOnlySelfModelProfile :=
  { Obj := Unit
    inside_universe := fun _ => True
    modeling_subsystem := fun _ => False
    organized_model_system := fun _ => False
    models_universe_or_region := fun _ => False
    internal_reference_to_modeled_domain := fun _ => False
    mathematical_model := fun _ => True
    symbolic_model := fun _ => False
    scientific_model := fun _ => False
    observer_world_model := fun _ => False
    computational_simulation_model := fun _ => False
    self_model_inside_gives_profile_self_model := by
      intro h
      rcases h with
        ⟨_x, _hInside, hSubsystem, _hOrganized, _hModels, _hReference⟩
      exact hSubsystem }

theorem model_inside_only_self_model_candidate_exists :
    exists x : ModelInsideOnlySelfModelContext.Obj,
      ModelInsideOnlySelfModelContext.inside_universe x /\
      ModelInsideOnlySelfModelContext.mathematical_model x := by
  exact ⟨(), by trivial, by trivial⟩

theorem model_inside_only_context_not_self_model_inside :
    Not (SelfModelWitnessInside ModelInsideOnlySelfModelContext) := by
  intro h
  rcases h with ⟨_x, _hInside, hSubsystem, _hOrganized, _hModels, _hReference⟩
  exact hSubsystem

theorem model_inside_candidate_alone_does_not_imply_self_model_inside :
    Not (forall {u : InterfaceProfile}
      (ctx : PhysicalSelfModelContext u),
      (exists x : ctx.Obj,
        ctx.inside_universe x /\ ctx.mathematical_model x) ->
        SelfModelWitnessInside ctx) := by
  intro h
  exact model_inside_only_context_not_self_model_inside
    (h
      ModelInsideOnlySelfModelContext
      model_inside_only_self_model_candidate_exists)

def StructuredOnlyMemoryProfile : InterfaceProfile :=
  { interface := True
    record := False
    selfModel := False
    adaptiveSelection := False
    predictiveCorrection := False
    selfObservation := False
    closure := False
    distinctionsBecomeStates := False
    statesBecomeEvents := False
    eventsBecomeMemory := False
    memoryBecomesThinking := False }

def StructuredOnlyMemoryContext :
    PhysicalMemoryContext StructuredOnlyMemoryProfile :=
  { Obj := Unit
    inside_universe := fun _ => True
    structured := fun _ => True
    stable := fun _ => False
    carries_information_about_prior_state := fun _ => False
    thermodynamic_trace := fun _ => False
    measurement_record := fun _ => False
    dna_heredity_record := fun _ => False
    cosmological_trace := fun _ => False
    symbolic_record := fun _ => False
    stable_trace_inside_gives_profile_record := by
      intro h
      rcases h with ⟨_x, _hInside, _hStructured, hStable, _hInfo⟩
      exact hStable }

theorem structured_only_memory_candidate_exists :
    exists x : StructuredOnlyMemoryContext.Obj,
      StructuredOnlyMemoryContext.inside_universe x /\
      StructuredOnlyMemoryContext.structured x := by
  exact ⟨(), by trivial, by trivial⟩

theorem structured_only_memory_context_not_stable_trace_inside :
    Not (StableTraceInside StructuredOnlyMemoryContext) := by
  intro h
  rcases h with ⟨_x, _hInside, _hStructured, hStable, _hInfo⟩
  exact hStable

theorem structured_candidate_alone_does_not_imply_stable_trace_inside :
    Not (forall {u : InterfaceProfile} (ctx : PhysicalMemoryContext u),
      (exists x : ctx.Obj, ctx.inside_universe x /\ ctx.structured x) ->
        StableTraceInside ctx) := by
  intro h
  exact structured_only_memory_context_not_stable_trace_inside
    (h StructuredOnlyMemoryContext structured_only_memory_candidate_exists)

def RecoverabilityGuardProfile : InterfaceProfile :=
  { interface := True
    record := True
    selfModel := False
    adaptiveSelection := False
    predictiveCorrection := False
    selfObservation := False
    closure := False
    distinctionsBecomeStates := False
    statesBecomeEvents := False
    eventsBecomeMemory := False
    memoryBecomesThinking := False }

def TraceExistsOnlyRecoverabilityContext :
    PhysicalRecoverabilityContext RecoverabilityGuardProfile :=
  { memory_ctx :=
      { Obj := Unit
        inside_universe := fun _ => True
        structured := fun _ => True
        stable := fun _ => True
        carries_information_about_prior_state := fun _ => True
        thermodynamic_trace := fun _ => True
        measurement_record := fun _ => False
        dna_heredity_record := fun _ => False
        cosmological_trace := fun _ => False
        symbolic_record := fun _ => False
        stable_trace_inside_gives_profile_record := by
          intro _h
          trivial }
    interface_accessible := fun _ => False
    distributed := fun _ => False
    recovery_cost_growth := fun _ => False
    recovery_practically_blocked := fun _ => False }

theorem trace_exists_only_context_has_stable_trace_inside :
    StableTraceInside TraceExistsOnlyRecoverabilityContext.memory_ctx := by
  exact ⟨(), by trivial, by trivial, by trivial, by trivial⟩

theorem trace_exists_only_context_not_recoverable_trace_inside :
    Not (RecoverableTraceInside TraceExistsOnlyRecoverabilityContext) := by
  intro h
  rcases h with ⟨_x, _hInside, _hRecord, hAccessible⟩
  exact hAccessible

theorem trace_existence_alone_does_not_imply_recoverability :
    Not (forall {u : InterfaceProfile} (ctx : PhysicalRecoverabilityContext u),
      StableTraceInside ctx.memory_ctx -> RecoverableTraceInside ctx) := by
  intro h
  exact trace_exists_only_context_not_recoverable_trace_inside
    (h
      TraceExistsOnlyRecoverabilityContext
      trace_exists_only_context_has_stable_trace_inside)

def DistributedTraceOnlyRecoverabilityContext :
    PhysicalRecoverabilityContext RecoverabilityGuardProfile :=
  { memory_ctx :=
      { Obj := Unit
        inside_universe := fun _ => True
        structured := fun _ => True
        stable := fun _ => True
        carries_information_about_prior_state := fun _ => True
        thermodynamic_trace := fun _ => True
        measurement_record := fun _ => False
        dna_heredity_record := fun _ => False
        cosmological_trace := fun _ => False
        symbolic_record := fun _ => False
        stable_trace_inside_gives_profile_record := by
          intro _h
          trivial }
    interface_accessible := fun _ => True
    distributed := fun _ => True
    recovery_cost_growth := fun _ => False
    recovery_practically_blocked := fun _ => False }

theorem distributed_trace_only_candidate_exists :
    DistributedTraceInside DistributedTraceOnlyRecoverabilityContext := by
  exact ⟨(), by trivial, by trivial, by trivial⟩

theorem distributed_trace_only_context_has_stable_trace_inside :
    StableTraceInside DistributedTraceOnlyRecoverabilityContext.memory_ctx := by
  exact ⟨(), by trivial, by trivial, by trivial, by trivial⟩

theorem distributed_trace_only_context_not_interface_forgetting :
    Not (InterfaceForgettingInside DistributedTraceOnlyRecoverabilityContext) := by
  intro h
  rcases h with ⟨_x, _hInside, _hRecord, hBlocked⟩
  exact hBlocked

theorem distributed_trace_alone_does_not_imply_forgetting :
    Not (forall {u : InterfaceProfile} (ctx : PhysicalRecoverabilityContext u),
      DistributedTraceInside ctx -> InterfaceForgettingInside ctx) := by
  intro h
  exact distributed_trace_only_context_not_interface_forgetting
    (h
      DistributedTraceOnlyRecoverabilityContext
      distributed_trace_only_candidate_exists)

theorem distributed_trace_alone_does_not_imply_zero_memory :
    Not (forall {u : InterfaceProfile} (ctx : PhysicalRecoverabilityContext u),
      DistributedTraceInside ctx -> Not (StableTraceInside ctx.memory_ctx)) := by
  intro h
  exact
    (h
      DistributedTraceOnlyRecoverabilityContext
      distributed_trace_only_candidate_exists)
      distributed_trace_only_context_has_stable_trace_inside

def ForgettingWithoutAnnihilationContext :
    PhysicalRecoverabilityContext RecoverabilityGuardProfile :=
  { memory_ctx :=
      { Obj := Unit
        inside_universe := fun _ => True
        structured := fun _ => True
        stable := fun _ => True
        carries_information_about_prior_state := fun _ => True
        thermodynamic_trace := fun _ => True
        measurement_record := fun _ => False
        dna_heredity_record := fun _ => False
        cosmological_trace := fun _ => False
        symbolic_record := fun _ => False
        stable_trace_inside_gives_profile_record := by
          intro _h
          trivial }
    interface_accessible := fun _ => False
    distributed := fun _ => True
    recovery_cost_growth := fun _ => True
    recovery_practically_blocked := fun _ => True }

theorem forgetting_without_annihilation_candidate_exists :
    InterfaceForgettingInside ForgettingWithoutAnnihilationContext := by
  exact ⟨(), by trivial, by trivial, by trivial⟩

theorem forgetting_without_annihilation_context_has_stable_trace_inside :
    StableTraceInside ForgettingWithoutAnnihilationContext.memory_ctx := by
  exact ⟨(), by trivial, by trivial, by trivial, by trivial⟩

theorem forgetting_does_not_imply_trace_annihilation :
    Not (forall {u : InterfaceProfile} (ctx : PhysicalRecoverabilityContext u),
      InterfaceForgettingInside ctx -> Not (StableTraceInside ctx.memory_ctx)) := by
  intro h
  exact
    (h
      ForgettingWithoutAnnihilationContext
      forgetting_without_annihilation_candidate_exists)
      forgetting_without_annihilation_context_has_stable_trace_inside

def EntropyDispersionWithoutZeroMemoryContext :
    PhysicalRecoverabilityContext RecoverabilityGuardProfile :=
  { memory_ctx :=
      { Obj := Unit
        inside_universe := fun _ => True
        structured := fun _ => True
        stable := fun _ => True
        carries_information_about_prior_state := fun _ => True
        thermodynamic_trace := fun _ => False
        measurement_record := fun _ => False
        dna_heredity_record := fun _ => False
        cosmological_trace := fun _ => False
        symbolic_record := fun _ => False
        stable_trace_inside_gives_profile_record := by
          intro _h
          trivial }
    interface_accessible := fun _ => True
    distributed := fun _ => True
    recovery_cost_growth := fun _ => True
    recovery_practically_blocked := fun _ => False }

theorem entropy_dispersion_without_zero_memory_candidate_exists :
    EntropyLikeDispersionInside EntropyDispersionWithoutZeroMemoryContext := by
  exact ⟨(), by trivial, by trivial, by trivial, by trivial⟩

theorem entropy_dispersion_without_zero_memory_context_has_stable_trace_inside :
    StableTraceInside EntropyDispersionWithoutZeroMemoryContext.memory_ctx := by
  exact ⟨(), by trivial, by trivial, by trivial, by trivial⟩

theorem entropy_like_dispersion_alone_does_not_imply_zero_memory :
    Not (forall {u : InterfaceProfile} (ctx : PhysicalRecoverabilityContext u),
      EntropyLikeDispersionInside ctx -> Not (StableTraceInside ctx.memory_ctx)) := by
  intro h
  exact
    (h
      EntropyDispersionWithoutZeroMemoryContext
      entropy_dispersion_without_zero_memory_candidate_exists)
      entropy_dispersion_without_zero_memory_context_has_stable_trace_inside

def ForgettingPredictiveContinuationProfile : InterfaceProfile :=
  { interface := True
    record := True
    selfModel := False
    adaptiveSelection := False
    predictiveCorrection := True
    selfObservation := False
    closure := False
    distinctionsBecomeStates := False
    statesBecomeEvents := False
    eventsBecomeMemory := False
    memoryBecomesThinking := False }

def ForgettingPredictiveContinuationRecoverabilityContext :
    PhysicalRecoverabilityContext ForgettingPredictiveContinuationProfile :=
  { memory_ctx :=
      { Obj := Unit
        inside_universe := fun _ => True
        structured := fun _ => True
        stable := fun _ => True
        carries_information_about_prior_state := fun _ => True
        thermodynamic_trace := fun _ => True
        measurement_record := fun _ => False
        dna_heredity_record := fun _ => False
        cosmological_trace := fun _ => False
        symbolic_record := fun _ => False
        stable_trace_inside_gives_profile_record := by
          intro _h
          trivial }
    interface_accessible := fun _ => False
    distributed := fun _ => True
    recovery_cost_growth := fun _ => True
    recovery_practically_blocked := fun _ => True }

def ForgettingPredictiveContinuationCorrectionContext :
    PhysicalPredictiveCorrectionContext ForgettingPredictiveContinuationProfile :=
  { Proc := Unit
    inside_universe := fun _ => True
    expected_candidate := fun _ => True
    filter_pass_or_reject := fun _ => True
    result_trace := fun _ => True
    future_update := fun _ => True
    measurement_correction := fun _ => False
    learning_update := fun _ => False
    biological_regulation := fun _ => False
    market_system_feedback := fun _ => False
    scientific_model_correction := fun _ => False
    predictive_correction_inside_gives_profile_correction := by
      intro _h
      trivial }

def ForgettingPredictiveAccessibilityContext :
    PhysicalPredictiveAccessibilityContext
      ForgettingPredictiveContinuationProfile :=
  { recoverability_ctx := ForgettingPredictiveContinuationRecoverabilityContext
    predictive_ctx := ForgettingPredictiveContinuationCorrectionContext
    full_predictive_accessibility := fun _ => True
    weakened_predictive_accessibility := fun _ => True
    forgetting_and_predictive_seed_give_weakened_accessibility := by
      intro _h
      exact ⟨(), by trivial, by trivial, by trivial, by trivial⟩ }

theorem forgetting_predictive_continuation_has_forgetting :
    InterfaceForgettingInside
      ForgettingPredictiveContinuationRecoverabilityContext := by
  exact ⟨(), by trivial, by trivial, by trivial⟩

theorem forgetting_predictive_continuation_has_full_predictive_accessibility :
    FullPredictiveAccessibilityInside ForgettingPredictiveAccessibilityContext := by
  exact ⟨(), by trivial, by trivial, by trivial, by trivial⟩

theorem forgetting_predictive_continuation_has_weakened_predictive_accessibility :
    WeakenedPredictiveAccessibilityInside
      ForgettingPredictiveAccessibilityContext := by
  exact
    interface_forgetting_and_full_predictive_accessibility_give_weakened_predictive_accessibility
      ForgettingPredictiveAccessibilityContext
      forgetting_predictive_continuation_has_forgetting
      forgetting_predictive_continuation_has_full_predictive_accessibility

theorem forgetting_predictive_continuation_has_predictive_correction_inside :
    PredictiveCorrectionWitnessInside
      ForgettingPredictiveContinuationCorrectionContext := by
  exact ⟨(), by trivial, by trivial, by trivial, by trivial, by trivial⟩

theorem forgetting_does_not_imply_no_predictive_correction :
    Not (forall {u : InterfaceProfile}
      (ctx : PhysicalPredictiveAccessibilityContext u),
      InterfaceForgettingInside ctx.recoverability_ctx ->
        Not (PredictiveCorrectionWitnessInside ctx.predictive_ctx)) := by
  intro h
  exact
    (h
      ForgettingPredictiveAccessibilityContext
      forgetting_predictive_continuation_has_forgetting)
      forgetting_predictive_continuation_has_predictive_correction_inside

def ForgettingPositivePredictiveGradientCorrectionContext :
    PhysicalPredictiveCorrectionContext
      ForgettingPredictiveContinuationProfile :=
  { Proc := Bool
    inside_universe := fun _ => True
    expected_candidate := fun _ => True
    filter_pass_or_reject := fun _ => True
    result_trace := fun _ => True
    future_update := fun _ => True
    measurement_correction := fun _ => False
    learning_update := fun _ => False
    biological_regulation := fun _ => False
    market_system_feedback := fun _ => False
    scientific_model_correction := fun _ => False
    predictive_correction_inside_gives_profile_correction := by
      intro _h
      trivial }

def ForgettingPositivePredictiveGradientContext :
    PhysicalPredictiveAccessibilityGradientContext
      ForgettingPredictiveContinuationProfile :=
  { recoverability_ctx := ForgettingPredictiveContinuationRecoverabilityContext
    predictive_ctx := ForgettingPositivePredictiveGradientCorrectionContext
    predictive_accessibility_level := fun p =>
      match p with
      | true => 5
      | false => 10
    full_accessibility_level := 10
    degraded_accessibility_floor := 3
    degraded_accessibility_ceiling := 7
    positive_degraded_floor := by decide
    degraded_floor_le_ceiling := by decide
    degraded_ceiling_lt_full := by decide
    forgetting_and_full_seed_give_degraded_gradient := by
      intro _h
      exact ⟨true, by trivial, by trivial, by trivial, by decide, by decide⟩ }

def ForgettingPredictiveLossFunctionContext :
    PhysicalPredictiveLossFunctionContext
      ForgettingPredictiveContinuationProfile :=
  { gradient_ctx := ForgettingPositivePredictiveGradientContext
    recoverability_loss_magnitude := fun _ => 5
    forgetting_trace_has_bounded_loss := by
      intro _x _hInside _hRecord _hBlocked
      exact ⟨by decide, by decide⟩
    forgetting_and_full_seed_with_given_loss_give_exact_drop := by
      intro _x _hInsideX _hRecordX _hBlockedX _hFull
      exact ⟨true, by trivial, by trivial, by trivial, rfl⟩ }

def ForgettingRecoveryCostDerivedLossContext :
    PhysicalRecoveryCostDerivedLossContext
      ForgettingPredictiveContinuationProfile :=
  { loss_ctx := ForgettingPredictiveLossFunctionContext
    recovery_cost_growth_magnitude := fun _ => 5
    growth_trace_has_positive_cost := by
      intro _x _hInside _hRecord _hGrowth _hBlocked
      exact by decide
    growth_cost_agrees_with_loss_magnitude := by
      intro _x _hInside _hRecord _hGrowth _hBlocked
      rfl }

theorem forgetting_positive_predictive_gradient_has_forgetting :
    InterfaceForgettingInside
      ForgettingPositivePredictiveGradientContext.recoverability_ctx := by
  exact forgetting_predictive_continuation_has_forgetting

theorem forgetting_positive_predictive_gradient_has_full_predictive_accessibility :
    FullPredictiveAccessibilityGradientInside
      ForgettingPositivePredictiveGradientContext := by
  exact ⟨false, by trivial, by trivial, by trivial, rfl⟩

theorem forgetting_positive_predictive_gradient_has_degraded_predictive_accessibility :
    DegradedPredictiveAccessibilityGradientInside
      ForgettingPositivePredictiveGradientContext := by
  exact
    interface_forgetting_and_full_predictive_accessibility_gradient_give_degraded_predictive_accessibility
      ForgettingPositivePredictiveGradientContext
      forgetting_positive_predictive_gradient_has_forgetting
      forgetting_positive_predictive_gradient_has_full_predictive_accessibility

theorem forgetting_positive_predictive_gradient_is_below_full :
    BelowFullPredictiveAccessibilityInside
      ForgettingPositivePredictiveGradientContext := by
  exact
    degraded_predictive_accessibility_gradient_inside_is_below_full
      ForgettingPositivePredictiveGradientContext
      forgetting_positive_predictive_gradient_has_degraded_predictive_accessibility

theorem forgetting_positive_predictive_gradient_is_positive :
    PositivePredictiveAccessibilityInside
      ForgettingPositivePredictiveGradientContext := by
  exact
    degraded_predictive_accessibility_gradient_inside_is_positive
      ForgettingPositivePredictiveGradientContext
      forgetting_positive_predictive_gradient_has_degraded_predictive_accessibility

theorem forgetting_predictive_loss_has_magnitude_five :
    QuantifiedRecoverabilityLossAtMagnitudeInside
      ForgettingPredictiveLossFunctionContext 5 := by
  exact ⟨(), by trivial, ⟨by trivial, by trivial, by trivial⟩, by trivial, rfl⟩

theorem forgetting_recovery_cost_growth_has_magnitude_five :
    QuantifiedRecoveryCostGrowthAtMagnitudeInside
      ForgettingRecoveryCostDerivedLossContext 5 := by
  exact ⟨(), by trivial, ⟨by trivial, by trivial, by trivial⟩, by trivial, by trivial, rfl⟩

theorem forgetting_recovery_cost_growth_magnitude_five_gives_loss_magnitude_five :
    QuantifiedRecoverabilityLossAtMagnitudeInside
      ForgettingRecoveryCostDerivedLossContext.loss_ctx 5 := by
  exact
    quantified_recovery_cost_growth_at_magnitude_inside_gives_quantified_recoverability_loss
      ForgettingRecoveryCostDerivedLossContext 5
      forgetting_recovery_cost_growth_has_magnitude_five

theorem forgetting_recovery_cost_growth_magnitude_five_gives_exact_level_five :
    PredictiveAccessibilityAtLevelInside
      ForgettingRecoveryCostDerivedLossContext.loss_ctx.gradient_ctx 5 := by
  exact
    quantified_recovery_cost_growth_and_full_predictive_accessibility_give_exact_predictive_level
      ForgettingRecoveryCostDerivedLossContext 5
      forgetting_recovery_cost_growth_has_magnitude_five
      forgetting_positive_predictive_gradient_has_full_predictive_accessibility

theorem forgetting_recovery_cost_growth_magnitude_five_gives_exact_drop :
    exists p :
      ForgettingRecoveryCostDerivedLossContext.loss_ctx.gradient_ctx.predictive_ctx.Proc,
        ForgettingRecoveryCostDerivedLossContext.loss_ctx.gradient_ctx.predictive_ctx.inside_universe p /\
        ForgettingRecoveryCostDerivedLossContext.loss_ctx.gradient_ctx.predictive_ctx.expected_candidate p /\
        ForgettingRecoveryCostDerivedLossContext.loss_ctx.gradient_ctx.predictive_ctx.result_trace p /\
        ForgettingRecoveryCostDerivedLossContext.loss_ctx.gradient_ctx.predictive_accessibility_level p + 5 =
          ForgettingRecoveryCostDerivedLossContext.loss_ctx.gradient_ctx.full_accessibility_level := by
  exact
    quantified_recovery_cost_growth_and_full_predictive_accessibility_give_exact_predictive_drop
      ForgettingRecoveryCostDerivedLossContext 5
      forgetting_recovery_cost_growth_has_magnitude_five
      forgetting_positive_predictive_gradient_has_full_predictive_accessibility

theorem forgetting_predictive_loss_magnitude_five_gives_exact_level_five :
    PredictiveAccessibilityAtLevelInside
      ForgettingPredictiveLossFunctionContext.gradient_ctx 5 := by
  exact
    quantified_loss_and_full_predictive_accessibility_give_exact_predictive_level
      ForgettingPredictiveLossFunctionContext 5
      forgetting_predictive_loss_has_magnitude_five
      forgetting_positive_predictive_gradient_has_full_predictive_accessibility

theorem forgetting_predictive_loss_magnitude_five_gives_exact_drop :
    exists p :
      ForgettingPredictiveLossFunctionContext.gradient_ctx.predictive_ctx.Proc,
        ForgettingPredictiveLossFunctionContext.gradient_ctx.predictive_ctx.inside_universe p /\
        ForgettingPredictiveLossFunctionContext.gradient_ctx.predictive_ctx.expected_candidate p /\
        ForgettingPredictiveLossFunctionContext.gradient_ctx.predictive_ctx.result_trace p /\
        ForgettingPredictiveLossFunctionContext.gradient_ctx.predictive_accessibility_level p + 5 =
          ForgettingPredictiveLossFunctionContext.gradient_ctx.full_accessibility_level := by
  exact
    quantified_loss_and_full_predictive_accessibility_give_exact_predictive_drop
      ForgettingPredictiveLossFunctionContext 5
      forgetting_predictive_loss_has_magnitude_five
      forgetting_positive_predictive_gradient_has_full_predictive_accessibility

def ForgettingOrderedRecoverabilityLossContext :
    PhysicalOrderedRecoverabilityLossContext
      ForgettingPredictiveContinuationProfile :=
  { recovery_cost_ctx := ForgettingRecoveryCostDerivedLossContext
    dispersion_magnitude := fun _ => 3
    blockedness_magnitude := fun _ => 2
    ordered_loss_magnitude := fun _ =>
      ordered_recoverability_loss_value
        ForgettingRecoveryCostDerivedLossContext.loss_ctx.gradient_ctx.full_accessibility_level
        3
        2
    dispersion_trace_has_positive_dispersion := by
      intro _x _hInside _hRecord _hDistributed
      exact by decide
    blocked_trace_has_positive_blockedness := by
      intro _x _hInside _hRecord _hBlocked
      exact by decide
    ordered_loss_is_sum_capped_by_full := by
      intro _x _hInside _hRecord _hDistributed _hBlocked
      rfl
    distributed_and_blocked_trace_exists_for_ordered_loss := by
      intro _x _hInside _hRecord _hDistributed _hBlocked
      exact ⟨by trivial, rfl⟩ }

theorem forgetting_ordered_loss_demo_has_dispersion_three :
    QuantifiedDispersionAtMagnitudeInside
      ForgettingOrderedRecoverabilityLossContext 3 := by
  exact
    ⟨(), by trivial, ⟨by trivial, by trivial, by trivial⟩, by trivial, rfl⟩

theorem forgetting_ordered_loss_demo_has_blockedness_two :
    QuantifiedBlockednessAtMagnitudeInside
      ForgettingOrderedRecoverabilityLossContext 2 := by
  exact
    ⟨(), by trivial, ⟨by trivial, by trivial, by trivial⟩, by trivial, rfl⟩

theorem forgetting_ordered_loss_demo_has_loss_five :
    QuantifiedOrderedRecoverabilityLossAtMagnitudeInside
      ForgettingOrderedRecoverabilityLossContext 5 := by
  exact
    quantified_dispersion_and_blockedness_give_ordered_loss_magnitude
      ForgettingOrderedRecoverabilityLossContext
      (x := ())
      (d := 3)
      (b := 2)
      (by trivial)
      (⟨by trivial, by trivial, by trivial⟩)
      (by trivial)
      (by trivial)
      rfl
      rfl

theorem forgetting_ordered_loss_demo_gives_exact_level_five :
    PredictiveAccessibilityAtLevelInside
      ForgettingOrderedRecoverabilityLossContext.recovery_cost_ctx.loss_ctx.gradient_ctx 5 := by
  exact
    ordered_loss_and_full_predictive_accessibility_give_exact_predictive_level
      ForgettingOrderedRecoverabilityLossContext 5
      forgetting_ordered_loss_demo_has_loss_five
      forgetting_positive_predictive_gradient_has_full_predictive_accessibility

theorem forgetting_ordered_loss_demo_gives_exact_drop :
    exists p :
      ForgettingOrderedRecoverabilityLossContext.recovery_cost_ctx.loss_ctx.gradient_ctx.predictive_ctx.Proc,
        ForgettingOrderedRecoverabilityLossContext.recovery_cost_ctx.loss_ctx.gradient_ctx.predictive_ctx.inside_universe p /\
        ForgettingOrderedRecoverabilityLossContext.recovery_cost_ctx.loss_ctx.gradient_ctx.predictive_ctx.expected_candidate p /\
        ForgettingOrderedRecoverabilityLossContext.recovery_cost_ctx.loss_ctx.gradient_ctx.predictive_ctx.result_trace p /\
        ForgettingOrderedRecoverabilityLossContext.recovery_cost_ctx.loss_ctx.gradient_ctx.predictive_accessibility_level p + 5 =
          ForgettingOrderedRecoverabilityLossContext.recovery_cost_ctx.loss_ctx.gradient_ctx.full_accessibility_level := by
  exact
    ordered_loss_and_full_predictive_accessibility_give_exact_predictive_drop
      ForgettingOrderedRecoverabilityLossContext 5
      forgetting_ordered_loss_demo_has_loss_five
      forgetting_positive_predictive_gradient_has_full_predictive_accessibility

def ForgettingRecoverabilitySpectrumContext :
    PhysicalRecoverabilitySpectrumContext
      ForgettingPredictiveContinuationProfile :=
  { ordered_loss_ctx := ForgettingOrderedRecoverabilityLossContext
    spectrum_axis_magnitude := fun axis _ =>
      match axis with
      | RecoverabilitySpectrumAxis.dispersion => 3
      | RecoverabilitySpectrumAxis.blockedness => 2
    dispersion_axis_matches_ordered_dispersion := by
      intro _x _hInside _hRecord _hDistributed
      rfl
    blockedness_axis_matches_ordered_blockedness := by
      intro _x _hInside _hRecord _hBlocked
      rfl }

theorem forgetting_recoverability_spectrum_demo_has_dispersion_three :
    SpectrumLossAtAxisInside
      ForgettingRecoverabilitySpectrumContext
      RecoverabilitySpectrumAxis.dispersion 3 := by
  exact
    ⟨(), by trivial, ⟨by trivial, by trivial, by trivial⟩, by trivial, rfl⟩

theorem forgetting_recoverability_spectrum_demo_has_blockedness_two :
    SpectrumLossAtAxisInside
      ForgettingRecoverabilitySpectrumContext
      RecoverabilitySpectrumAxis.blockedness 2 := by
  exact
    ⟨(), by trivial, ⟨by trivial, by trivial, by trivial⟩, by trivial, rfl⟩

theorem forgetting_recoverability_spectrum_demo_gives_ordered_loss_five :
    QuantifiedOrderedRecoverabilityLossAtMagnitudeInside
      ForgettingRecoverabilitySpectrumContext.ordered_loss_ctx 5 := by
  exact
    recoverability_spectrum_axes_give_ordered_loss_magnitude
      ForgettingRecoverabilitySpectrumContext
      (x := ())
      (d := 3)
      (b := 2)
      (by trivial)
      (⟨by trivial, by trivial, by trivial⟩)
      (by trivial)
      (by trivial)
      rfl
      rfl

theorem forgetting_recoverability_spectrum_demo_gives_exact_level_five :
    PredictiveAccessibilityAtLevelInside
      ForgettingRecoverabilitySpectrumContext.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx 5 := by
  exact
    recoverability_spectrum_and_full_predictive_accessibility_give_exact_predictive_level
      ForgettingRecoverabilitySpectrumContext 5
      forgetting_recoverability_spectrum_demo_gives_ordered_loss_five
      forgetting_positive_predictive_gradient_has_full_predictive_accessibility

theorem forgetting_recoverability_spectrum_demo_gives_exact_drop :
    exists p :
      ForgettingRecoverabilitySpectrumContext.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.predictive_ctx.Proc,
        ForgettingRecoverabilitySpectrumContext.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.predictive_ctx.inside_universe p /\
        ForgettingRecoverabilitySpectrumContext.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.predictive_ctx.expected_candidate p /\
        ForgettingRecoverabilitySpectrumContext.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.predictive_ctx.result_trace p /\
        ForgettingRecoverabilitySpectrumContext.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.predictive_accessibility_level p + 5 =
          ForgettingRecoverabilitySpectrumContext.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.full_accessibility_level := by
  exact
    recoverability_spectrum_and_full_predictive_accessibility_give_exact_predictive_drop
      ForgettingRecoverabilitySpectrumContext 5
      forgetting_recoverability_spectrum_demo_gives_ordered_loss_five
      forgetting_positive_predictive_gradient_has_full_predictive_accessibility

theorem dispersion_axis_alone_does_not_determine_full_recoverability_spectrum :
    Not (forall {u : InterfaceProfile}
      (ctx : PhysicalRecoverabilitySpectrumContext u)
      (n : Nat),
      SpectrumLossAtAxisInside ctx RecoverabilitySpectrumAxis.dispersion n ->
        n = ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.full_accessibility_level) := by
  intro h
  have hEq :
      3 =
        ForgettingRecoverabilitySpectrumContext.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.full_accessibility_level :=
    h ForgettingRecoverabilitySpectrumContext 3
      forgetting_recoverability_spectrum_demo_has_dispersion_three
  change 3 = 10 at hEq
  cases hEq

theorem blockedness_axis_alone_does_not_determine_full_recoverability_spectrum :
    Not (forall {u : InterfaceProfile}
      (ctx : PhysicalRecoverabilitySpectrumContext u)
      (n : Nat),
      SpectrumLossAtAxisInside ctx RecoverabilitySpectrumAxis.blockedness n ->
        n = ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.full_accessibility_level) := by
  intro h
  have hEq :
      2 =
        ForgettingRecoverabilitySpectrumContext.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.full_accessibility_level :=
    h ForgettingRecoverabilitySpectrumContext 2
      forgetting_recoverability_spectrum_demo_has_blockedness_two
  change 2 = 10 at hEq
  cases hEq

theorem recoverability_spectrum_does_not_imply_predictive_annihilation :
    Not (forall {u : InterfaceProfile}
      (ctx : PhysicalRecoverabilitySpectrumContext u)
      (n : Nat),
      QuantifiedOrderedRecoverabilityLossAtMagnitudeInside ctx.ordered_loss_ctx n ->
        Not (PositivePredictiveAccessibilityInside
          ctx.ordered_loss_ctx.recovery_cost_ctx.loss_ctx.gradient_ctx)) := by
  intro h
  exact
    (h
      ForgettingRecoverabilitySpectrumContext 5
      forgetting_recoverability_spectrum_demo_gives_ordered_loss_five)
      forgetting_positive_predictive_gradient_is_positive

def LocalitySensitivePositivePredictiveGradientContext :
    PhysicalPredictiveAccessibilityGradientContext
      ForgettingPredictiveContinuationProfile :=
  { recoverability_ctx := ForgettingPredictiveContinuationRecoverabilityContext
    predictive_ctx := ForgettingPositivePredictiveGradientCorrectionContext
    predictive_accessibility_level := fun p =>
      match p with
      | true => 4
      | false => 10
    full_accessibility_level := 10
    degraded_accessibility_floor := 2
    degraded_accessibility_ceiling := 6
    positive_degraded_floor := by decide
    degraded_floor_le_ceiling := by decide
    degraded_ceiling_lt_full := by decide
    forgetting_and_full_seed_give_degraded_gradient := by
      intro _h
      exact ⟨true, by trivial, by trivial, by trivial, by decide, by decide⟩ }

def LocalitySensitivePredictiveLossFunctionContext :
    PhysicalPredictiveLossFunctionContext
      ForgettingPredictiveContinuationProfile :=
  { gradient_ctx := LocalitySensitivePositivePredictiveGradientContext
    recoverability_loss_magnitude := fun _ => 6
    forgetting_trace_has_bounded_loss := by
      intro _x _hInside _hRecord _hBlocked
      exact ⟨by decide, by decide⟩
    forgetting_and_full_seed_with_given_loss_give_exact_drop := by
      intro _x _hInsideX _hRecordX _hBlockedX _hFull
      exact ⟨true, by trivial, by trivial, by trivial, rfl⟩ }

def LocalitySensitiveRecoverabilityTriSpectrumContext :
    PhysicalRecoverabilityTriSpectrumContext
      ForgettingPredictiveContinuationProfile :=
  { loss_ctx := LocalitySensitivePredictiveLossFunctionContext
    dispersion_magnitude := fun _ => 3
    blockedness_magnitude := fun _ => 2
    locality_magnitude := fun _ => 1
    tri_spectral_loss_magnitude := fun _ =>
      tri_spectral_loss_value
        LocalitySensitivePredictiveLossFunctionContext.gradient_ctx.full_accessibility_level
        3 2 1
    dispersion_axis_has_positive_magnitude := by
      intro _x _hInside _hRecord _hDistributed
      exact by decide
    blockedness_axis_has_positive_magnitude := by
      intro _x _hInside _hRecord _hBlocked
      exact by decide
    locality_axis_has_positive_magnitude := by
      intro _x _hInside _hRecord _hLocal
      exact by decide
    tri_spectral_loss_is_sum_capped_by_full := by
      intro _x _hInside _hRecord _hDistributed _hBlocked _hLocal
      rfl
    tri_spectrum_trace_projects_to_loss := by
      intro _x _hInside _hRecord _hDistributed _hBlocked _hLocal
      rfl }

theorem locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility :
    FullPredictiveAccessibilityGradientInside
      LocalitySensitivePositivePredictiveGradientContext := by
  exact ⟨false, by trivial, by trivial, by trivial, rfl⟩

theorem locality_sensitive_positive_predictive_gradient_is_positive :
    PositivePredictiveAccessibilityInside
      LocalitySensitivePositivePredictiveGradientContext := by
  have hForgetting :
      InterfaceForgettingInside
        LocalitySensitivePositivePredictiveGradientContext.recoverability_ctx := by
    exact forgetting_predictive_continuation_has_forgetting
  have hDegraded :
      DegradedPredictiveAccessibilityGradientInside
        LocalitySensitivePositivePredictiveGradientContext := by
    exact
      interface_forgetting_and_full_predictive_accessibility_gradient_give_degraded_predictive_accessibility
        LocalitySensitivePositivePredictiveGradientContext
        hForgetting
        locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility
  exact
    degraded_predictive_accessibility_gradient_inside_is_positive
      LocalitySensitivePositivePredictiveGradientContext
      hDegraded

theorem locality_sensitive_tri_spectrum_demo_has_dispersion_three :
    TriSpectrumLossAtAxisInside
      LocalitySensitiveRecoverabilityTriSpectrumContext
      RecoverabilityTriSpectrumAxis.dispersion 3 := by
  exact
    ⟨(), by trivial, ⟨by trivial, by trivial, by trivial⟩, by trivial, rfl⟩

theorem locality_sensitive_tri_spectrum_demo_has_blockedness_two :
    TriSpectrumLossAtAxisInside
      LocalitySensitiveRecoverabilityTriSpectrumContext
      RecoverabilityTriSpectrumAxis.blockedness 2 := by
  exact
    ⟨(), by trivial, ⟨by trivial, by trivial, by trivial⟩, by trivial, rfl⟩

theorem locality_sensitive_tri_spectrum_demo_has_locality_one :
    TriSpectrumLossAtAxisInside
      LocalitySensitiveRecoverabilityTriSpectrumContext
      RecoverabilityTriSpectrumAxis.locality 1 := by
  exact
    ⟨(), by trivial, ⟨by trivial, by trivial, by trivial⟩,
      by
        simp [LocalitySensitiveRecoverabilityTriSpectrumContext,
          LocalitySensitivePredictiveLossFunctionContext,
          LocalitySensitivePositivePredictiveGradientContext,
          ForgettingPredictiveContinuationRecoverabilityContext],
      rfl⟩

theorem locality_sensitive_tri_spectrum_demo_gives_loss_six :
    QuantifiedRecoverabilityLossAtMagnitudeInside
      LocalitySensitiveRecoverabilityTriSpectrumContext.loss_ctx 6 := by
  exact
    recoverability_tri_spectrum_axes_give_quantified_recoverability_loss
      LocalitySensitiveRecoverabilityTriSpectrumContext
      (x := ())
      (d := 3)
      (b := 2)
      (l := 1)
      (by trivial)
      (⟨by trivial, by trivial, by trivial⟩)
      (by trivial)
      (by trivial)
      (by
        simp [LocalitySensitiveRecoverabilityTriSpectrumContext,
          LocalitySensitivePredictiveLossFunctionContext,
          LocalitySensitivePositivePredictiveGradientContext,
          ForgettingPredictiveContinuationRecoverabilityContext])
      rfl
      rfl
      rfl

theorem locality_sensitive_tri_spectrum_demo_gives_exact_level_four :
    PredictiveAccessibilityAtLevelInside
      LocalitySensitiveRecoverabilityTriSpectrumContext.loss_ctx.gradient_ctx 4 := by
  exact
    recoverability_tri_spectrum_and_full_predictive_accessibility_give_exact_predictive_level
      LocalitySensitiveRecoverabilityTriSpectrumContext 6
      locality_sensitive_tri_spectrum_demo_gives_loss_six
      locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility

theorem locality_sensitive_tri_spectrum_demo_gives_exact_drop :
    exists p :
      LocalitySensitiveRecoverabilityTriSpectrumContext.loss_ctx.gradient_ctx.predictive_ctx.Proc,
        LocalitySensitiveRecoverabilityTriSpectrumContext.loss_ctx.gradient_ctx.predictive_ctx.inside_universe p /\
        LocalitySensitiveRecoverabilityTriSpectrumContext.loss_ctx.gradient_ctx.predictive_ctx.expected_candidate p /\
        LocalitySensitiveRecoverabilityTriSpectrumContext.loss_ctx.gradient_ctx.predictive_ctx.result_trace p /\
        LocalitySensitiveRecoverabilityTriSpectrumContext.loss_ctx.gradient_ctx.predictive_accessibility_level p + 6 =
          LocalitySensitiveRecoverabilityTriSpectrumContext.loss_ctx.gradient_ctx.full_accessibility_level := by
  exact
    recoverability_tri_spectrum_and_full_predictive_accessibility_give_exact_predictive_drop
      LocalitySensitiveRecoverabilityTriSpectrumContext 6
      locality_sensitive_tri_spectrum_demo_gives_loss_six
      locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility

theorem locality_axis_alone_does_not_determine_full_tri_spectral_loss :
    Not (forall {u : InterfaceProfile}
      (ctx : PhysicalRecoverabilityTriSpectrumContext u)
      (n : Nat),
      TriSpectrumLossAtAxisInside ctx RecoverabilityTriSpectrumAxis.locality n ->
        n = ctx.loss_ctx.gradient_ctx.full_accessibility_level) := by
  intro h
  have hEq :
      1 =
        LocalitySensitiveRecoverabilityTriSpectrumContext.loss_ctx.gradient_ctx.full_accessibility_level :=
    h LocalitySensitiveRecoverabilityTriSpectrumContext 1
      locality_sensitive_tri_spectrum_demo_has_locality_one
  change 1 = 10 at hEq
  cases hEq

theorem tri_spectrum_does_not_imply_predictive_annihilation :
    Not (forall {u : InterfaceProfile}
      (ctx : PhysicalRecoverabilityTriSpectrumContext u)
      (n : Nat),
      QuantifiedRecoverabilityLossAtMagnitudeInside ctx.loss_ctx n ->
        Not (PositivePredictiveAccessibilityInside ctx.loss_ctx.gradient_ctx)) := by
  intro h
  exact
    (h
      LocalitySensitiveRecoverabilityTriSpectrumContext 6
      locality_sensitive_tri_spectrum_demo_gives_loss_six)
      locality_sensitive_positive_predictive_gradient_is_positive

def QuantitativeLocalitySensitivePositivePredictiveGradientContext :
    PhysicalPredictiveAccessibilityGradientContext
      ForgettingPredictiveContinuationProfile :=
  { recoverability_ctx := ForgettingPredictiveContinuationRecoverabilityContext
    predictive_ctx := ForgettingPositivePredictiveGradientCorrectionContext
    predictive_accessibility_level := fun p =>
      match p with
      | true => 2
      | false => 10
    full_accessibility_level := 10
    degraded_accessibility_floor := 2
    degraded_accessibility_ceiling := 5
    positive_degraded_floor := by decide
    degraded_floor_le_ceiling := by decide
    degraded_ceiling_lt_full := by decide
    forgetting_and_full_seed_give_degraded_gradient := by
      intro _h
      exact ⟨true, by trivial, by trivial, by trivial, by decide, by decide⟩ }

def QuantitativeLocalitySensitivePredictiveLossFunctionContext :
    PhysicalPredictiveLossFunctionContext
      ForgettingPredictiveContinuationProfile :=
  { gradient_ctx := QuantitativeLocalitySensitivePositivePredictiveGradientContext
    recoverability_loss_magnitude := fun _ => 8
    forgetting_trace_has_bounded_loss := by
      intro _x _hInside _hRecord _hBlocked
      exact ⟨by decide, by decide⟩
    forgetting_and_full_seed_with_given_loss_give_exact_drop := by
      intro _x _hInsideX _hRecordX _hBlockedX _hFull
      exact ⟨true, by trivial, by trivial, by trivial, rfl⟩ }

def QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext :
    PhysicalRecoverabilityTriSpectrumContext
      ForgettingPredictiveContinuationProfile :=
  { loss_ctx := QuantitativeLocalitySensitivePredictiveLossFunctionContext
    dispersion_magnitude := fun _ => 3
    blockedness_magnitude := fun _ => 2
    locality_magnitude := fun _ => 3
    tri_spectral_loss_magnitude := fun _ =>
      tri_spectral_loss_value
        QuantitativeLocalitySensitivePredictiveLossFunctionContext.gradient_ctx.full_accessibility_level
        3 2 3
    dispersion_axis_has_positive_magnitude := by
      intro _x _hInside _hRecord _hDistributed
      exact by decide
    blockedness_axis_has_positive_magnitude := by
      intro _x _hInside _hRecord _hBlocked
      exact by decide
    locality_axis_has_positive_magnitude := by
      intro _x _hInside _hRecord _hLocal
      exact by decide
    tri_spectral_loss_is_sum_capped_by_full := by
      intro _x _hInside _hRecord _hDistributed _hBlocked _hLocal
      rfl
    tri_spectrum_trace_projects_to_loss := by
      intro _x _hInside _hRecord _hDistributed _hBlocked _hLocal
      rfl }

theorem quantitative_locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility :
    FullPredictiveAccessibilityGradientInside
      QuantitativeLocalitySensitivePositivePredictiveGradientContext := by
  exact ⟨false, by trivial, by trivial, by trivial, rfl⟩

theorem quantitative_locality_sensitive_positive_predictive_gradient_is_positive :
    PositivePredictiveAccessibilityInside
      QuantitativeLocalitySensitivePositivePredictiveGradientContext := by
  have hForgetting :
      InterfaceForgettingInside
        QuantitativeLocalitySensitivePositivePredictiveGradientContext.recoverability_ctx := by
    exact forgetting_predictive_continuation_has_forgetting
  have hDegraded :
      DegradedPredictiveAccessibilityGradientInside
        QuantitativeLocalitySensitivePositivePredictiveGradientContext := by
    exact
      interface_forgetting_and_full_predictive_accessibility_gradient_give_degraded_predictive_accessibility
        QuantitativeLocalitySensitivePositivePredictiveGradientContext
        hForgetting
        quantitative_locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility
  exact
    degraded_predictive_accessibility_gradient_inside_is_positive
      QuantitativeLocalitySensitivePositivePredictiveGradientContext
      hDegraded

theorem quantitative_locality_sensitive_tri_spectrum_demo_has_locality_three :
    TriSpectrumLossAtAxisInside
      QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext
      RecoverabilityTriSpectrumAxis.locality 3 := by
  exact
    ⟨(), by trivial, ⟨by trivial, by trivial, by trivial⟩,
      by
        simp [QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext,
          QuantitativeLocalitySensitivePredictiveLossFunctionContext,
          QuantitativeLocalitySensitivePositivePredictiveGradientContext,
          ForgettingPredictiveContinuationRecoverabilityContext],
      rfl⟩

theorem quantitative_locality_sensitive_tri_spectrum_demo_gives_loss_eight :
    QuantifiedRecoverabilityLossAtMagnitudeInside
      QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext.loss_ctx 8 := by
  exact
    recoverability_tri_spectrum_axes_give_quantified_recoverability_loss
      QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext
      (x := ())
      (d := 3)
      (b := 2)
      (l := 3)
      (by trivial)
      (⟨by trivial, by trivial, by trivial⟩)
      (by trivial)
      (by trivial)
      (by
        simp [QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext,
          QuantitativeLocalitySensitivePredictiveLossFunctionContext,
          QuantitativeLocalitySensitivePositivePredictiveGradientContext,
          ForgettingPredictiveContinuationRecoverabilityContext])
      rfl
      rfl
      rfl

theorem quantitative_locality_sensitive_tri_spectrum_demo_gives_exact_level_two :
    PredictiveAccessibilityAtLevelInside
      QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext.loss_ctx.gradient_ctx 2 := by
  exact
    recoverability_tri_spectrum_and_full_predictive_accessibility_give_exact_predictive_level
      QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext 8
      quantitative_locality_sensitive_tri_spectrum_demo_gives_loss_eight
      quantitative_locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility

theorem quantitative_locality_sensitive_tri_spectrum_demo_gives_exact_drop :
    exists p :
      QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext.loss_ctx.gradient_ctx.predictive_ctx.Proc,
        QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext.loss_ctx.gradient_ctx.predictive_ctx.inside_universe p /\
        QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext.loss_ctx.gradient_ctx.predictive_ctx.expected_candidate p /\
        QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext.loss_ctx.gradient_ctx.predictive_ctx.result_trace p /\
        QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext.loss_ctx.gradient_ctx.predictive_accessibility_level p + 8 =
          QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext.loss_ctx.gradient_ctx.full_accessibility_level := by
  exact
    recoverability_tri_spectrum_and_full_predictive_accessibility_give_exact_predictive_drop
      QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext 8
      quantitative_locality_sensitive_tri_spectrum_demo_gives_loss_eight
      quantitative_locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility

def DerivedLocalitySensitiveRecoverabilityTriSpectrumContext :
    PhysicalDerivedLocalityTriSpectrumContext
      ForgettingPredictiveContinuationProfile :=
  { tri_ctx := QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext
    accessibility_flag := fun _ => false
    distributed_flag := fun _ => true
    accessibility_flag_reflects_interface_accessible := by
      intro _x
      constructor
      · intro h
        simp at h
      · intro h
        cases h
    distributed_flag_reflects_distributed := by
      intro _x
      constructor
      · intro _h
        trivial
      · intro _h
        rfl
    tri_locality_axis_matches_derived_formula := by
      intro _x
      simp [QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext,
        derived_locality_loss_value] }

theorem derived_locality_sensitive_tri_spectrum_demo_has_locality_three :
    TriSpectrumLossAtAxisInside
      DerivedLocalitySensitiveRecoverabilityTriSpectrumContext.tri_ctx
      RecoverabilityTriSpectrumAxis.locality 3 := by
  exact
    derived_locality_from_accessibility_and_distribution_gives_locality_axis
      DerivedLocalitySensitiveRecoverabilityTriSpectrumContext
      (x := ())
      (d := 3)
      (by trivial)
      (⟨by trivial, by trivial, by trivial⟩)
      (by trivial)
      (by
        simp [DerivedLocalitySensitiveRecoverabilityTriSpectrumContext,
          QuantitativeLocalitySensitivePredictiveLossFunctionContext,
          QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext,
          QuantitativeLocalitySensitivePositivePredictiveGradientContext,
          ForgettingPredictiveContinuationRecoverabilityContext])
      rfl

theorem derived_locality_sensitive_tri_spectrum_demo_gives_loss_eight :
    QuantifiedRecoverabilityLossAtMagnitudeInside
      DerivedLocalitySensitiveRecoverabilityTriSpectrumContext.tri_ctx.loss_ctx 8 := by
  exact quantitative_locality_sensitive_tri_spectrum_demo_gives_loss_eight

theorem derived_locality_sensitive_tri_spectrum_demo_gives_exact_level_two :
    PredictiveAccessibilityAtLevelInside
      DerivedLocalitySensitiveRecoverabilityTriSpectrumContext.tri_ctx.loss_ctx.gradient_ctx 2 := by
  exact quantitative_locality_sensitive_tri_spectrum_demo_gives_exact_level_two

theorem derived_locality_sensitive_tri_spectrum_demo_gives_exact_drop :
    exists p :
      DerivedLocalitySensitiveRecoverabilityTriSpectrumContext.tri_ctx.loss_ctx.gradient_ctx.predictive_ctx.Proc,
        DerivedLocalitySensitiveRecoverabilityTriSpectrumContext.tri_ctx.loss_ctx.gradient_ctx.predictive_ctx.inside_universe p /\
        DerivedLocalitySensitiveRecoverabilityTriSpectrumContext.tri_ctx.loss_ctx.gradient_ctx.predictive_ctx.expected_candidate p /\
        DerivedLocalitySensitiveRecoverabilityTriSpectrumContext.tri_ctx.loss_ctx.gradient_ctx.predictive_ctx.result_trace p /\
        DerivedLocalitySensitiveRecoverabilityTriSpectrumContext.tri_ctx.loss_ctx.gradient_ctx.predictive_accessibility_level p + 8 =
          DerivedLocalitySensitiveRecoverabilityTriSpectrumContext.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level := by
  exact quantitative_locality_sensitive_tri_spectrum_demo_gives_exact_drop

theorem derived_locality_does_not_imply_maximal_tri_spectral_loss :
    Not (forall {u : InterfaceProfile}
      (ctx : PhysicalDerivedLocalityTriSpectrumContext u)
      (n : Nat),
      TriSpectrumLossAtAxisInside ctx.tri_ctx RecoverabilityTriSpectrumAxis.locality n ->
        n = ctx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level) := by
  intro h
  have hEq :
      3 =
        DerivedLocalitySensitiveRecoverabilityTriSpectrumContext.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level :=
    h DerivedLocalitySensitiveRecoverabilityTriSpectrumContext 3
      derived_locality_sensitive_tri_spectrum_demo_has_locality_three
  change 3 = 10 at hEq
  cases hEq

def QuantitativeDerivedLocalReadabilityMeasureContext :
    PhysicalLocalReadabilityMeasureContext
      ForgettingPredictiveContinuationProfile :=
  { tri_ctx := QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext
    local_readability_trace := fun _ => True
    accessibility_flag := fun _ => false
    distributed_flag := fun _ => true
    local_readability_cost_magnitude := fun _ => readable_fragment_value 2 1
    accessibility_flag_reflects_interface_accessible := by
      intro _x
      constructor
      · intro h
        simp at h
      · intro h
        cases h
    distributed_flag_reflects_distributed := by
      intro _x
      constructor
      · intro _h
        trivial
      · intro _h
        rfl
    local_readability_cost_matches_derived_rule := by
      intro _x
      simp [local_unreadability_value,
        readable_fragment_value,
        QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext]
    local_readability_trace_has_positive_cost := by
      intro _x _hInside _hRecord _hDistributed _hBlocked _hInaccessible _hTrace
      decide
    local_readability_cost_projects_to_tri_locality := by
      intro _x _hInside _hRecord _hDistributed _hBlocked _hInaccessible _hTrace
      simp [readable_fragment_value,
        QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext] }

def QuantitativeFragmentConnectivityContext :
    PhysicalFragmentConnectivityContext
      ForgettingPredictiveContinuationProfile :=
  { measure_ctx := QuantitativeDerivedLocalReadabilityMeasureContext
    readable_fragment_trace := fun _ => True
    fragment_component_trace := fun _ => True
    fragment_boundary_trace := fun _ => True
    connected_fragment_count := fun _ => 2
    fragment_separation_degree := fun _ => 1
    local_reconstruction_path_cost := fun _ => 1
    readable_fragment_trace_has_positive_fragment_count := by
      intro _x _hInside _hRecord _hDistributed _hBlocked _hInaccessible _hTrace
      decide
    readable_fragment_trace_projects_to_local_readability_trace := by
      intro _x _hTrace
      trivial
    fragment_connectivity_value_projects_to_readability_cost := by
      intro _x _hInside _hRecord _hDistributed _hBlocked _hInaccessible _hTrace
      simp [readable_fragment_value,
        QuantitativeDerivedLocalReadabilityMeasureContext] }

def QuantitativeFragmentationContext :
    PhysicalFragmentationContext
      ForgettingPredictiveContinuationProfile :=
  fragment_connectivity_projects_to_fragmentation_context
    QuantitativeFragmentConnectivityContext

theorem quantitative_fragment_connectivity_demo_has_component_count_two :
    QuantifiedFragmentComponentCountInside
      QuantitativeFragmentConnectivityContext 2 := by
  exact
    low_level_fragment_connectivity_trace_gives_quantified_fragment_component_count_inside
      { carrier := ()
        inside := by trivial
        record := ⟨by trivial, by trivial, by trivial⟩
        distributed := by trivial
        recovery_blocked := by trivial
        inaccessible := by
          intro h
          cases h
        readable_fragment_trace := by trivial
        component_trace := by trivial
        boundary_trace := by trivial }

theorem quantitative_fragment_connectivity_demo_has_split_degree_one :
    QuantifiedFragmentSplitDegreeInside
      QuantitativeFragmentConnectivityContext 1 := by
  exact
    low_level_fragment_connectivity_trace_gives_quantified_fragment_split_degree_inside
      { carrier := ()
        inside := by trivial
        record := ⟨by trivial, by trivial, by trivial⟩
        distributed := by trivial
        recovery_blocked := by trivial
        inaccessible := by
          intro h
          cases h
        readable_fragment_trace := by trivial
        component_trace := by trivial
        boundary_trace := by trivial }

theorem quantitative_fragmentation_demo_has_fragment_value_three :
    QuantifiedLocalReadableFragmentMagnitudeInside
      (fragmentation_projects_to_readable_fragment_context
        QuantitativeFragmentationContext) 3 := by
  exact
    low_level_fragmentation_trace_gives_quantified_local_readable_fragment_magnitude_inside
      (ctx := QuantitativeFragmentationContext)
      { carrier := ()
        inside := by trivial
        record := ⟨by trivial, by trivial, by trivial⟩
        distributed := by trivial
        recovery_blocked := by trivial
        inaccessible := by
          intro h
          cases h
        readable_fragment_trace := by trivial }

def QuantitativeReadableFragmentContext :
    PhysicalReadableFragmentContext
      ForgettingPredictiveContinuationProfile :=
  fragmentation_projects_to_readable_fragment_context
    QuantitativeFragmentationContext

def QuantitativeLocalReconstructionContext :
    PhysicalLocalReconstructionContext
      ForgettingPredictiveContinuationProfile :=
  { connectivity_ctx := QuantitativeFragmentConnectivityContext
    reconstruction_attempt := fun _ => True
    reconstruction_cost := fun _ => 1
    reconstruction_practically_blocked := fun _ => True
    reconstruction_attempt_projects_to_readable_fragment_trace := by
      intro _x _h
      trivial
    reconstruction_attempt_has_positive_cost := by
      intro _x _hInside _hRecord _hDistributed _hBlocked _hInaccessible _hTrace
      decide
    local_reconstruction_matches_underlying_readability_rule := by
      intro _x
      simp [local_reconstruction_value,
        readable_fragment_value,
        local_unreadability_value,
        QuantitativeFragmentConnectivityContext,
        QuantitativeDerivedLocalReadabilityMeasureContext,
        QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext] }

def QuantitativeBridgeReadyLocalReadabilityMeasureContext :
    PhysicalLocalReadabilityMeasureContext
      ForgettingPredictiveContinuationProfile :=
  local_reconstruction_projects_to_local_readability_measure_context
    QuantitativeLocalReconstructionContext

theorem quantitative_local_reconstruction_demo_has_cost_one :
    QuantifiedLocalReconstructionCostInside
      QuantitativeLocalReconstructionContext 1 := by
  exact
    low_level_local_reconstruction_trace_gives_quantified_local_reconstruction_cost_inside
      { carrier := ()
        inside := by trivial
        record := ⟨by trivial, by trivial, by trivial⟩
        distributed := by trivial
        recovery_blocked := by trivial
        inaccessible := by
          intro h
          cases h
        reconstruction_attempt := by trivial }

theorem quantitative_bridge_ready_local_readability_demo_has_magnitude_three :
    QuantifiedLocalReadabilityMagnitudeInside
      (local_readability_measure_projects_to_readability_context
        QuantitativeBridgeReadyLocalReadabilityMeasureContext) 3 := by
  have hCost :
      QuantifiedLocalReadabilityCostMagnitudeInside
        QuantitativeBridgeReadyLocalReadabilityMeasureContext 3 := by
    exact
      low_level_local_readability_trace_gives_quantified_local_readability_cost_magnitude_inside
        (ctx := QuantitativeBridgeReadyLocalReadabilityMeasureContext)
        { carrier := ()
          inside := by trivial
          record := ⟨by trivial, by trivial, by trivial⟩
          distributed := by trivial
          recovery_blocked := by trivial
          inaccessible := by
            intro h
            cases h
          readability_trace := by trivial }
  exact
    quantified_local_readability_cost_projects_to_quantified_local_readability_magnitude_inside
      QuantitativeBridgeReadyLocalReadabilityMeasureContext 3 hCost

def QuantitativeEntropyBridgeReadinessContext :
    PhysicalEntropyBridgeReadinessContext
      ForgettingPredictiveContinuationProfile :=
  { recoverability_ctx :=
      ForgettingPredictiveContinuationRecoverabilityContext
    readable_fragment_trace := fun _ => True
    trace_persistence_ready := fun _ => True
    record_dispersion_ready := fun _ => True
    local_accessibility_ready := fun _ => True
    preferred_candidate := EntropyBridgeCandidateAxis.localAccessibility
    trace_persistence_ready_projects_to_record := by
      intro _x _h
      exact ⟨by trivial, by trivial, by trivial⟩
    record_dispersion_ready_projects_to_record := by
      intro _x _h
      exact ⟨by trivial, by trivial, by trivial⟩
    record_dispersion_ready_projects_to_distributed := by
      intro _x _h
      trivial
    record_dispersion_ready_projects_to_growth := by
      intro _x _h
      trivial
    local_accessibility_ready_projects_to_record := by
      intro _x _h
      exact ⟨by trivial, by trivial, by trivial⟩
    local_accessibility_ready_projects_to_blocked := by
      intro _x _h
      trivial
    local_accessibility_ready_projects_to_inaccessibility := by
      intro _x _h
      intro hAcc
      cases hAcc }

theorem quantitative_entropy_bridge_readiness_has_bridge_neutral_shell :
    StableTraceInside
      QuantitativeEntropyBridgeReadinessContext.recoverability_ctx.memory_ctx /\
    EntropyLikeDispersionInside
      QuantitativeEntropyBridgeReadinessContext.recoverability_ctx /\
    InterfaceForgettingInside
      QuantitativeEntropyBridgeReadinessContext.recoverability_ctx := by
  exact
    entropy_bridge_readiness_gives_bridge_neutral_entropy_shell
      QuantitativeEntropyBridgeReadinessContext
      (by
        exact ⟨(), by trivial, by trivial, ⟨by trivial, by trivial, by trivial⟩⟩)
      (by
        exact ⟨(), by trivial, by trivial, by trivial⟩)
      (by
        exact
          ⟨(), by trivial, by trivial, ⟨by trivial, by trivial, by trivial⟩,
            by trivial,
            by
              intro h
              cases h⟩)

def QuantitativePhysicalLocalInformationalAccessibilityContext :
    PhysicalLocalInformationalAccessibilityContext
      ForgettingPredictiveContinuationProfile :=
  { fragment_connectivity_ctx := QuantitativeFragmentConnectivityContext
    local_reconstruction_ctx := QuantitativeLocalReconstructionContext
    entropy_readiness_ctx := QuantitativeEntropyBridgeReadinessContext
    Carrier := Unit
    inside_universe := fun _ => True
    trace_exists := fun _ => True
    locally_readable := fun _ => False
    fragmented_across_regions := fun _ => True
    reconstruction_effort_positive := fun _ => True
    locally_unreadable_without_reconstruction := fun _ => True
    trace_projects_to_fragment_connectivity := by
      intro _c _hInside _hTrace _hFragmented _hUnreadable _hEffort
      exact
        { carrier := ()
          inside := by trivial
          record := ⟨by trivial, by trivial, by trivial⟩
          distributed := by trivial
          recovery_blocked := by trivial
          inaccessible := by
            intro h
            cases h
          readable_fragment_trace := by trivial
          component_trace := by trivial
          boundary_trace := by trivial }
    trace_projects_to_local_reconstruction := by
      intro _c _hInside _hTrace _hFragmented _hUnreadable _hEffort
      exact
        { carrier := ()
          inside := by trivial
          record := ⟨by trivial, by trivial, by trivial⟩
          distributed := by trivial
          recovery_blocked := by trivial
          inaccessible := by
            intro h
            cases h
          reconstruction_attempt := by trivial }
    trace_projects_to_recoverability_readiness := by
      intro _c _hInside _hTrace
      exact ⟨(), by trivial, by trivial, ⟨by trivial, by trivial, by trivial⟩⟩
    fragmented_trace_projects_to_dispersion_readiness := by
      intro _c _hInside _hTrace _hFragmented
      exact ⟨(), by trivial, by trivial, by trivial⟩
    unreadable_trace_projects_to_local_accessibility_readiness := by
      intro _c _hInside _hTrace _hUnreadable _hEffort
      exact
        ⟨(), by trivial, by trivial, ⟨by trivial, by trivial, by trivial⟩,
          by trivial,
          by
            intro h
            cases h⟩ }

def QuantitativePhysicalLocalTraceCarrierContext :
    PhysicalLocalTraceCarrierContext
      ForgettingPredictiveContinuationProfile :=
  { accessibility_ctx := QuantitativePhysicalLocalInformationalAccessibilityContext
    carrier_trace := fun _ => True
    low_level_carrier_projects_to_local_informational_accessibility := by
      intro _c hInside hTrace _hCarrier hFragmented hUnreadable hEffort
      exact
        { carrier := ()
          inside := hInside
          trace_exists := hTrace
          fragmented := hFragmented
          local_readability_blocked_without_reconstruction := hUnreadable
          reconstruction_effort_positive := hEffort } }

def QuantitativePhysicalFragmentRegionContext :
    PhysicalFragmentRegionContext
      ForgettingPredictiveContinuationProfile :=
  { connectivity_ctx := QuantitativeFragmentConnectivityContext
    fragment_region_membership := fun _ => True
    separated_region_boundary := fun _ => True
    cross_region_readout_not_direct := fun _ => True
    region_count_value := fun _ => 2
    boundary_count_value := fun _ => 1
    region_trace_projects_to_fragment_connectivity := by
      intro _x hInside hRecord hDistributed hBlocked hInaccessible _hRegion _hBoundary _hCross
      exact
        { carrier := ()
          inside := hInside
          record := hRecord
          distributed := hDistributed
          recovery_blocked := hBlocked
          inaccessible := hInaccessible
          readable_fragment_trace := by trivial
          component_trace := by trivial
          boundary_trace := by trivial }
    region_count_projects_to_fragment_count := by
      intro _x
      rfl
    boundary_count_projects_to_split_degree := by
      intro _x
      rfl }

def QuantitativePhysicalReconstructionDifficultyContext :
    PhysicalReconstructionDifficultyContext
      ForgettingPredictiveContinuationProfile :=
  { reconstruction_ctx := QuantitativeLocalReconstructionContext
    direct_local_readout_fails := fun _ => True
    multi_step_reconstruction_required := fun _ => True
    reconstruction_path_cost_positive := fun _ => True
    physical_reconstruction_difficulty_magnitude := fun _ => 1
    physical_difficulty_trace_projects_to_local_reconstruction := by
      intro _x hInside hRecord hDistributed hBlocked hInaccessible _hDirect _hMulti _hPositive
      exact
        { carrier := ()
          inside := hInside
          record := hRecord
          distributed := hDistributed
          recovery_blocked := hBlocked
          inaccessible := hInaccessible
          reconstruction_attempt := by trivial }
    physical_difficulty_projects_to_reconstruction_cost := by
      intro _x
      rfl }

def QuantitativePhysicalRecoverabilityLossInterpretationContext :
    PhysicalRecoverabilityLossInterpretationContext
      ForgettingPredictiveContinuationProfile :=
  { loss_ctx := QuantitativeLocalitySensitivePredictiveLossFunctionContext
    reconstruction_difficulty_ctx := QuantitativePhysicalReconstructionDifficultyContext
    trace_still_exists := fun _ => True
    local_direct_access_fails := fun _ => True
    reconstruction_cost_growth := fun _ => True
    physical_recoverability_loss_magnitude := fun _ => 8
    physical_loss_trace_projects_to_quantified_loss := by
      intro _x _hInside _hRecord _hBlocked _hTrace _hDirect _hGrowth
      rfl }

theorem quantitative_physical_local_informational_accessibility_demo_gives_bridge_neutral_entropy_shell :
    let readinessCtx :=
      QuantitativePhysicalLocalInformationalAccessibilityContext.entropy_readiness_ctx
    StableTraceInside readinessCtx.recoverability_ctx.memory_ctx /\
    EntropyLikeDispersionInside readinessCtx.recoverability_ctx /\
    InterfaceForgettingInside readinessCtx.recoverability_ctx := by
  exact
    low_level_local_informational_accessibility_trace_gives_bridge_neutral_entropy_shell
      { carrier := ()
        inside := by trivial
        trace_exists := by trivial
        fragmented := by trivial
        local_readability_blocked_without_reconstruction := by trivial
        reconstruction_effort_positive := by trivial }

theorem quantitative_physical_trace_carrier_demo_gives_local_informational_accessibility :
    ∃ _ : LowLevelLocalInformationalAccessibilityTrace
      QuantitativePhysicalLocalTraceCarrierContext.accessibility_ctx, True := by
  exact
    low_level_physical_trace_carrier_gives_local_informational_accessibility
      { carrier := ()
        inside := by trivial
        trace_exists := by trivial
        carrier_trace := by trivial
        fragmented := by trivial
        local_readability_blocked_without_reconstruction := by trivial
        reconstruction_effort_positive := by trivial }

theorem quantitative_physical_fragment_regions_demo_gives_readable_fragment_magnitude_three :
    QuantifiedLocalReadableFragmentMagnitudeInside
      (fragmentation_projects_to_readable_fragment_context
        (fragment_connectivity_projects_to_fragmentation_context
          QuantitativePhysicalFragmentRegionContext.connectivity_ctx))
      3 := by
  exact quantitative_fragmentation_demo_has_fragment_value_three

theorem quantitative_physical_reconstruction_difficulty_demo_has_magnitude_one :
    QuantifiedPhysicalReconstructionDifficultyInside
      QuantitativePhysicalReconstructionDifficultyContext 1 := by
  exact
    (physical_reconstruction_difficulty_gives_local_reconstruction
      { carrier := ()
        inside := by trivial
        record := ⟨by trivial, by trivial, by trivial⟩
        distributed := by trivial
        recovery_blocked := by trivial
        inaccessible := by
          intro h
          cases h
        direct_local_readout_fails := by trivial
        multi_step_reconstruction_required := by trivial
        reconstruction_path_cost_positive := by trivial }).1

theorem quantitative_physical_recoverability_loss_demo_has_loss_eight :
    QuantifiedRecoverabilityLossAtMagnitudeInside
      QuantitativePhysicalRecoverabilityLossInterpretationContext.loss_ctx 8 := by
  exact
    physical_reconstruction_difficulty_gives_recoverability_loss_reading
      { carrier := ()
        inside := by trivial
        record := ⟨by trivial, by trivial, by trivial⟩
        recovery_blocked := by trivial
        trace_still_exists := by trivial
        local_direct_access_fails := by trivial
        reconstruction_cost_growth := by trivial }

theorem quantitative_physical_recoverability_loss_demo_projects_to_interface_forgetting :
    InterfaceForgettingInside
      QuantitativePhysicalRecoverabilityLossInterpretationContext.loss_ctx.gradient_ctx.recoverability_ctx := by
  exact
    physical_recoverability_loss_projects_to_interface_forgetting
      { carrier := ()
        inside := by trivial
        record := ⟨by trivial, by trivial, by trivial⟩
        recovery_blocked := by trivial
        trace_still_exists := by trivial
        local_direct_access_fails := by trivial
        reconstruction_cost_growth := by trivial }

theorem quantitative_physical_recoverability_loss_demo_gives_exact_level_two :
    PredictiveAccessibilityAtLevelInside
      QuantitativePhysicalRecoverabilityLossInterpretationContext.loss_ctx.gradient_ctx 2 := by
  exact
    physical_recoverability_loss_and_full_predictive_accessibility_give_physical_predictive_limitation
      QuantitativePhysicalRecoverabilityLossInterpretationContext
      quantitative_locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility
      { carrier := ()
        inside := by trivial
        record := ⟨by trivial, by trivial, by trivial⟩
        recovery_blocked := by trivial
        trace_still_exists := by trivial
        local_direct_access_fails := by trivial
        reconstruction_cost_growth := by trivial }

theorem quantitative_first_physical_bridge_ready_for_next_physics :
    FirstPhysicalBridgeReadyForNextPhysics
      { carrier_ctx := QuantitativePhysicalLocalTraceCarrierContext
        carrier_trace :=
          { carrier := ()
            inside := by trivial
            trace_exists := by trivial
            carrier_trace := by trivial
            fragmented := by trivial
            local_readability_blocked_without_reconstruction := by trivial
            reconstruction_effort_positive := by trivial }
        region_ctx := QuantitativePhysicalFragmentRegionContext
        region_trace :=
          { carrier := ()
            inside := by trivial
            record := ⟨by trivial, by trivial, by trivial⟩
            distributed := by trivial
            recovery_blocked := by trivial
            inaccessible := by
              intro h
              cases h
            region_membership := by trivial
            separated_boundary := by trivial
            cross_region_readout_not_direct := by trivial }
        reconstruction_difficulty_ctx := QuantitativePhysicalReconstructionDifficultyContext
        reconstruction_difficulty_trace :=
          { carrier := ()
            inside := by trivial
            record := ⟨by trivial, by trivial, by trivial⟩
            distributed := by trivial
            recovery_blocked := by trivial
            inaccessible := by
              intro h
              cases h
            direct_local_readout_fails := by trivial
            multi_step_reconstruction_required := by trivial
            reconstruction_path_cost_positive := by trivial }
        recoverability_loss_ctx := QuantitativePhysicalRecoverabilityLossInterpretationContext
        recoverability_loss_trace :=
          { carrier := ()
            inside := by trivial
            record := ⟨by trivial, by trivial, by trivial⟩
            recovery_blocked := by trivial
            trace_still_exists := by trivial
            local_direct_access_fails := by trivial
            reconstruction_cost_growth := by trivial }
        full_predictive_accessibility :=
          quantitative_locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility } := by
  exact
    first_physical_bridge_ready_for_next_physics_witness_is_ready
      { carrier_ctx := QuantitativePhysicalLocalTraceCarrierContext
        carrier_trace :=
          { carrier := ()
            inside := by trivial
            trace_exists := by trivial
            carrier_trace := by trivial
            fragmented := by trivial
            local_readability_blocked_without_reconstruction := by trivial
            reconstruction_effort_positive := by trivial }
        region_ctx := QuantitativePhysicalFragmentRegionContext
        region_trace :=
          { carrier := ()
            inside := by trivial
            record := ⟨by trivial, by trivial, by trivial⟩
            distributed := by trivial
            recovery_blocked := by trivial
            inaccessible := by
              intro h
              cases h
            region_membership := by trivial
            separated_boundary := by trivial
            cross_region_readout_not_direct := by trivial }
        reconstruction_difficulty_ctx := QuantitativePhysicalReconstructionDifficultyContext
        reconstruction_difficulty_trace :=
          { carrier := ()
            inside := by trivial
            record := ⟨by trivial, by trivial, by trivial⟩
            distributed := by trivial
            recovery_blocked := by trivial
            inaccessible := by
              intro h
              cases h
            direct_local_readout_fails := by trivial
            multi_step_reconstruction_required := by trivial
            reconstruction_path_cost_positive := by trivial }
        recoverability_loss_ctx := QuantitativePhysicalRecoverabilityLossInterpretationContext
        recoverability_loss_trace :=
          { carrier := ()
            inside := by trivial
            record := ⟨by trivial, by trivial, by trivial⟩
            recovery_blocked := by trivial
            trace_still_exists := by trivial
            local_direct_access_fails := by trivial
            reconstruction_cost_growth := by trivial }
        full_predictive_accessibility :=
          quantitative_locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility }

def QuantitativePhysicalThermodynamicOverlayContext :
    PhysicalThermodynamicOverlayContext
      ForgettingPredictiveContinuationProfile :=
  { bridge_witness :=
      { carrier_ctx := QuantitativePhysicalLocalTraceCarrierContext
        carrier_trace :=
          { carrier := ()
            inside := by trivial
            trace_exists := by trivial
            carrier_trace := by trivial
            fragmented := by trivial
            local_readability_blocked_without_reconstruction := by trivial
            reconstruction_effort_positive := by trivial }
        region_ctx := QuantitativePhysicalFragmentRegionContext
        region_trace :=
          { carrier := ()
            inside := by trivial
            record := ⟨by trivial, by trivial, by trivial⟩
            distributed := by trivial
            recovery_blocked := by trivial
            inaccessible := by
              intro h
              cases h
            region_membership := by trivial
            separated_boundary := by trivial
            cross_region_readout_not_direct := by trivial }
        reconstruction_difficulty_ctx := QuantitativePhysicalReconstructionDifficultyContext
        reconstruction_difficulty_trace :=
          { carrier := ()
            inside := by trivial
            record := ⟨by trivial, by trivial, by trivial⟩
            distributed := by trivial
            recovery_blocked := by trivial
            inaccessible := by
              intro h
              cases h
            direct_local_readout_fails := by trivial
            multi_step_reconstruction_required := by trivial
            reconstruction_path_cost_positive := by trivial }
        recoverability_loss_ctx := QuantitativePhysicalRecoverabilityLossInterpretationContext
        recoverability_loss_trace :=
          { carrier := ()
            inside := by trivial
            record := ⟨by trivial, by trivial, by trivial⟩
            recovery_blocked := by trivial
            trace_still_exists := by trivial
            local_direct_access_fails := by trivial
            reconstruction_cost_growth := by trivial }
        full_predictive_accessibility :=
          quantitative_locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility }
    bridge_ready := quantitative_first_physical_bridge_ready_for_next_physics
    recoverability_loss_ctx := QuantitativePhysicalRecoverabilityLossInterpretationContext
    Carrier := Unit
    inside_universe := fun _ => True
    thermodynamic_process := fun _ => True
    entropy_like_growth := fun _ => True
    macroscopic_irreversibility := fun _ => True
    record_not_annihilated := fun _ => True
    projects_to_recoverability_stress := fun _ => True
    irreversibility_projects_to_recoverability_stress := by
      intro _c _hInside _hProcess _hGrowth _hIrreversible _hRecord
      trivial
    thermodynamic_overlay_projects_to_loss_trace := by
      intro _c _hInside _hProcess _hGrowth _hIrreversible _hRecord _hStress
      exact
        { carrier := ()
          inside := by trivial
          record := ⟨by trivial, by trivial, by trivial⟩
          recovery_blocked := by trivial
          trace_still_exists := by trivial
          local_direct_access_fails := by trivial
          reconstruction_cost_growth := by trivial }
    thermodynamic_overlay_projects_to_memory_thermodynamic_trace := by
      intro _c _hInside _hProcess _hGrowth _hIrreversible _hRecord
      exact
        ⟨(), by trivial, by trivial, ⟨by trivial, by trivial, by trivial⟩⟩ }

theorem quantitative_thermodynamic_overlay_demo_gives_irreversibility :
    ThermodynamicIrreversibilityInside
      QuantitativePhysicalThermodynamicOverlayContext := by
  exact
    low_level_thermodynamic_overlay_gives_irreversibility_inside
      { carrier := ()
        inside := by trivial
        thermodynamic_process := by trivial
        entropy_like_growth := by trivial
        macroscopic_irreversibility := by trivial
        record_not_annihilated := by trivial }

theorem quantitative_thermodynamic_overlay_demo_is_compatible_with_memory_trace :
    ThermodynamicTraceWitness
      QuantitativePhysicalThermodynamicOverlayContext.recoverability_loss_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx := by
  exact
    thermodynamic_overlay_is_compatible_with_memory_thermodynamic_trace
      { carrier := ()
        inside := by trivial
        thermodynamic_process := by trivial
        entropy_like_growth := by trivial
        macroscopic_irreversibility := by trivial
        record_not_annihilated := by trivial }

theorem quantitative_thermodynamic_overlay_demo_gives_recoverability_pressure :
    ThermodynamicRecoverabilityPressureInside
      QuantitativePhysicalThermodynamicOverlayContext := by
  exact
    thermodynamic_irreversibility_gives_recoverability_pressure
      QuantitativePhysicalThermodynamicOverlayContext
      quantitative_thermodynamic_overlay_demo_gives_irreversibility

theorem quantitative_thermodynamic_overlay_demo_projects_to_strengthened_forgetting :
    ThermodynamicStrengthenedForgettingInside
      QuantitativePhysicalThermodynamicOverlayContext := by
  exact
    thermodynamic_overlay_gives_strengthened_forgetting
      { carrier := ()
        inside := by trivial
        thermodynamic_process := by trivial
        entropy_like_growth := by trivial
        macroscopic_irreversibility := by trivial
        record_not_annihilated := by trivial }

theorem quantitative_thermodynamic_overlay_demo_gives_exact_level_two :
    ∃ n,
      PredictiveAccessibilityAtLevelInside
        QuantitativePhysicalThermodynamicOverlayContext.recoverability_loss_ctx.loss_ctx.gradient_ctx
        (QuantitativePhysicalThermodynamicOverlayContext.recoverability_loss_ctx.loss_ctx.gradient_ctx.full_accessibility_level - n) := by
  exact
    thermodynamic_pressure_and_full_predictive_accessibility_give_thermodynamic_predictive_limitation
      QuantitativePhysicalThermodynamicOverlayContext
      quantitative_locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility
      quantitative_thermodynamic_overlay_demo_gives_recoverability_pressure

def QuantitativePhysicalThermodynamicRecoverabilityRefinementContext :
    PhysicalThermodynamicRecoverabilityRefinementContext
      ForgettingPredictiveContinuationProfile :=
  { overlay_ctx := QuantitativePhysicalThermodynamicOverlayContext
    thermodynamic_stress_magnitude := fun _ => 8
    thermodynamic_loss_magnitude := fun _ => 8
    positive_stress_of_refinement := by
      intro _c _hInside _hProcess _hGrowth _hIrreversible _hRecord
      decide
    thermodynamic_loss_matches_physical_loss := by
      intro _c _hInside _hProcess _hGrowth _hIrreversible _hRecord
      rfl }

theorem quantitative_thermodynamic_refinement_demo_has_stress_eight :
    QuantifiedThermodynamicStressMagnitudeInside
      QuantitativePhysicalThermodynamicRecoverabilityRefinementContext 8 := by
  exact
    low_level_thermodynamic_refinement_trace_gives_quantified_stress_magnitude
      { carrier := ()
        inside := by trivial
        thermodynamic_process := by trivial
        entropy_like_growth := by trivial
        macroscopic_irreversibility := by trivial
        record_not_annihilated := by trivial }

theorem quantitative_thermodynamic_refinement_demo_has_loss_eight :
    QuantifiedThermodynamicRecoverabilityLossAtMagnitudeInside
      QuantitativePhysicalThermodynamicRecoverabilityRefinementContext 8 := by
  exact
    (thermodynamic_refinement_projects_to_quantified_recoverability_loss
      { carrier := ()
        inside := by trivial
        thermodynamic_process := by trivial
        entropy_like_growth := by trivial
        macroscopic_irreversibility := by trivial
        record_not_annihilated := by trivial }).1

theorem quantitative_thermodynamic_refinement_demo_projects_to_interface_forgetting :
    InterfaceForgettingInside
      QuantitativePhysicalThermodynamicRecoverabilityRefinementContext.overlay_ctx.recoverability_loss_ctx.loss_ctx.gradient_ctx.recoverability_ctx := by
  exact
    thermodynamic_refinement_projects_to_interface_forgetting
      { carrier := ()
        inside := by trivial
        thermodynamic_process := by trivial
        entropy_like_growth := by trivial
        macroscopic_irreversibility := by trivial
        record_not_annihilated := by trivial }

theorem quantitative_thermodynamic_refinement_demo_gives_exact_level_two :
    PredictiveAccessibilityAtLevelInside
      QuantitativePhysicalThermodynamicRecoverabilityRefinementContext.overlay_ctx.recoverability_loss_ctx.loss_ctx.gradient_ctx 2 := by
  exact
    thermodynamic_refinement_and_full_predictive_accessibility_give_exact_predictive_level
      QuantitativePhysicalThermodynamicRecoverabilityRefinementContext
      quantitative_locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility
      { carrier := ()
        inside := by trivial
        thermodynamic_process := by trivial
        entropy_like_growth := by trivial
        macroscopic_irreversibility := by trivial
        record_not_annihilated := by trivial }

def QuantitativeQuantumRecordMemoryContext :
    PhysicalMemoryContext ForgettingPredictiveContinuationProfile :=
  { Obj := Unit
    inside_universe := fun _ => True
    structured := fun _ => True
    stable := fun _ => True
    carries_information_about_prior_state := fun _ => True
    thermodynamic_trace := fun _ => False
    measurement_record := fun _ => True
    dna_heredity_record := fun _ => False
    cosmological_trace := fun _ => False
    symbolic_record := fun _ => False
    stable_trace_inside_gives_profile_record := by
      intro _h
      trivial }

def QuantitativePhysicalQuantumRecordContext :
    PhysicalQuantumRecordContext ForgettingPredictiveContinuationProfile :=
  { memory_ctx := QuantitativeQuantumRecordMemoryContext
    QCarrier := Unit
    inside_universe := fun _ => True
    interaction_event := fun _ => True
    alternative_branching := fun _ => True
    environmental_imprint := fun _ => True
    branch_separation := fun _ => True
    outcome_record_stabilized := fun _ => True
    record_carrier_of := fun _ => ()
    stabilized_record_projects_to_record_object := by
      intro _q _hInside _hInteraction _hBranching _hImprint _hSeparation _hStableOutcome
      exact ⟨by trivial, by exact ⟨by trivial, by trivial, by trivial⟩⟩
    stabilized_record_projects_to_measurement_record := by
      intro _q _hInside _hInteraction _hBranching _hImprint _hSeparation _hStableOutcome
      trivial }

def quantitative_quantum_record_demo_trace :
    LowLevelQuantumRecordTrace QuantitativePhysicalQuantumRecordContext :=
  { carrier := ()
    inside := by trivial
    interaction_event := by trivial
    alternative_branching := by trivial
    environmental_imprint := by trivial
    branch_separation := by trivial
    outcome_record_stabilized := by trivial }

theorem quantitative_quantum_record_demo_gives_branch_separation :
    DecoherenceBranchSeparationInside QuantitativePhysicalQuantumRecordContext := by
  exact
    low_level_quantum_record_trace_gives_branch_separation_inside
      quantitative_quantum_record_demo_trace

theorem quantitative_quantum_record_demo_gives_environmental_imprint :
    EnvironmentalImprintInside QuantitativePhysicalQuantumRecordContext := by
  exact
    low_level_quantum_record_trace_gives_environmental_imprint_inside
      quantitative_quantum_record_demo_trace

theorem quantitative_quantum_record_demo_gives_stable_outcome_record :
    StableOutcomeRecordInside QuantitativePhysicalQuantumRecordContext := by
  exact
    low_level_quantum_record_trace_gives_stable_outcome_record_inside
      quantitative_quantum_record_demo_trace

theorem quantitative_quantum_record_demo_gives_quantum_record_formation :
    QuantumRecordFormationInside QuantitativePhysicalQuantumRecordContext := by
  exact
    low_level_quantum_record_trace_gives_quantum_record_formation_inside
      quantitative_quantum_record_demo_trace

theorem quantitative_quantum_record_demo_gives_measurement_record_witness :
    MeasurementRecordWitness QuantitativePhysicalQuantumRecordContext.memory_ctx := by
  exact
    stable_outcome_record_inside_gives_measurement_record_witness
      QuantitativePhysicalQuantumRecordContext
      quantitative_quantum_record_demo_gives_stable_outcome_record

theorem quantitative_quantum_record_demo_gives_physical_record_bridge :
    PhysicalRecordBridge ForgettingPredictiveContinuationProfile := by
  exact
    quantum_record_formation_projects_to_physical_record_bridge
      QuantitativePhysicalQuantumRecordContext
      quantitative_quantum_record_demo_gives_quantum_record_formation

def QuantitativePhysicalQuantumThermodynamicCompatibilityContext :
    PhysicalQuantumThermodynamicCompatibilityContext
      ForgettingPredictiveContinuationProfile :=
  { quantum_ctx := QuantitativePhysicalQuantumRecordContext
    thermodynamic_ctx := QuantitativePhysicalThermodynamicRecoverabilityRefinementContext
    compatible_quantum_trace := fun _ _ => True
    compatible_trace_preserves_record := by
      intro _q _t _hInside _hInteraction _hBranching _hImprint _hSeparation
        _hStableOutcome _tInside _tProcess _tGrowth _tIrreversible _tRecord
      trivial }

def quantitative_thermodynamic_refinement_demo_trace :
    LowLevelThermodynamicRecoverabilityRefinementTrace
      QuantitativePhysicalThermodynamicRecoverabilityRefinementContext :=
  { carrier := ()
    inside := by trivial
    thermodynamic_process := by trivial
    entropy_like_growth := by trivial
    macroscopic_irreversibility := by trivial
    record_not_annihilated := by trivial }

theorem quantitative_quantum_record_demo_is_compatible_with_thermodynamic_refinement :
    ∃ q : QuantitativePhysicalQuantumRecordContext.QCarrier,
      QuantitativePhysicalQuantumThermodynamicCompatibilityContext.compatible_quantum_trace q () := by
  exact
    quantum_record_is_compatible_with_thermodynamic_recoverability_refinement
      QuantitativePhysicalQuantumThermodynamicCompatibilityContext
      quantitative_quantum_record_demo_gives_stable_outcome_record
      quantitative_thermodynamic_refinement_demo_trace

theorem quantitative_quantum_record_demo_plus_thermodynamic_pressure_preserve_record :
    StableTraceInside QuantitativePhysicalQuantumRecordContext.memory_ctx := by
  exact
    (quantum_record_plus_thermodynamic_pressure_preserve_record_without_immediate_annihilation
      QuantitativePhysicalQuantumThermodynamicCompatibilityContext
      quantitative_quantum_record_demo_gives_stable_outcome_record
      quantitative_thermodynamic_refinement_demo_trace).1

theorem quantitative_quantum_record_demo_plus_thermodynamic_pressure_projects_to_loss_eight :
    QuantifiedRecoverabilityLossAtMagnitudeInside
      QuantitativePhysicalThermodynamicRecoverabilityRefinementContext.overlay_ctx.recoverability_loss_ctx.loss_ctx
      8 := by
  exact
    (quantum_record_plus_thermodynamic_pressure_can_project_to_recoverability_loss_reading
      QuantitativePhysicalQuantumThermodynamicCompatibilityContext
      quantitative_quantum_record_demo_gives_stable_outcome_record
      quantitative_thermodynamic_refinement_demo_trace).2

def QuantitativePhysicalQuantumRecordLocalAccessibilityFeedContext :
    PhysicalQuantumRecordLocalAccessibilityFeedContext
      ForgettingPredictiveContinuationProfile :=
  { quantum_ctx := QuantitativePhysicalQuantumRecordContext
    local_accessibility_ctx := QuantitativePhysicalLocalInformationalAccessibilityContext
    low_level_quantum_record_trace_projects_to_local_accessibility_trace := by
      intro _hQuantum
      exact
        { carrier := ()
          inside := by trivial
          trace_exists := by trivial
          fragmented := by trivial
          local_readability_blocked_without_reconstruction := by trivial
          reconstruction_effort_positive := by trivial } }

def QuantitativePhysicalOrderedQuantumRecordPressureContext :
    PhysicalOrderedQuantumRecordPressureContext
      ForgettingPredictiveContinuationProfile :=
  { feed_ctx := QuantitativePhysicalQuantumRecordLocalAccessibilityFeedContext
    branching_magnitude := fun _ => 2
    imprint_magnitude := fun _ => 1
    stabilization_magnitude := fun _ => 0
    quantum_fragment_pressure_magnitude := fun _ => 3
    quantum_readability_pressure_magnitude := fun _ => 3
    projected_fragment_component_count_matches_branching := by
      intro _hq
      rfl
    projected_fragment_split_degree_matches_imprint := by
      intro _hq
      rfl
    quantum_fragment_pressure_is_branching_plus_imprint := by
      intro _q
      rfl
    projected_local_readability_matches_quantum_readability_pressure := by
      intro _hq
      rfl
    projected_dispersion_matches_quantum_fragment_pressure := by
      intro _hq
      rfl
    quantum_readability_pressure_is_fragment_plus_stabilization := by
      intro _q
      rfl }

def QuantitativePhysicalQuantumPressureLawContext :
    PhysicalQuantumPressureLawContext
      ForgettingPredictiveContinuationProfile :=
  { ordered_ctx := QuantitativePhysicalOrderedQuantumRecordPressureContext
    quantum_blockedness_magnitude := fun _ => 2
    projected_blockedness_matches_quantum_blockedness := by
      intro _hq
      rfl }

def quantitative_quantum_record_demo_feeds_local_informational_accessibility :
    LowLevelLocalInformationalAccessibilityTrace
      QuantitativePhysicalLocalInformationalAccessibilityContext := by
  exact
    quantum_record_projects_to_local_informational_accessibility_trace
      QuantitativePhysicalQuantumRecordLocalAccessibilityFeedContext
      quantitative_quantum_record_demo_trace

theorem quantitative_quantum_record_demo_feeds_fragment_connectivity :
    ∃ _ :
      LowLevelFragmentConnectivityTrace
        QuantitativePhysicalLocalInformationalAccessibilityContext.fragment_connectivity_ctx,
      True := by
  exact
    quantum_record_projects_to_fragment_connectivity_surface
      QuantitativePhysicalQuantumRecordLocalAccessibilityFeedContext
      quantitative_quantum_record_demo_trace

theorem quantitative_quantum_record_demo_feeds_local_reconstruction :
    ∃ _ :
      LowLevelLocalReconstructionTrace
        QuantitativePhysicalLocalInformationalAccessibilityContext.local_reconstruction_ctx,
      True := by
  exact
    quantum_record_projects_to_local_reconstruction_surface
      QuantitativePhysicalQuantumRecordLocalAccessibilityFeedContext
      quantitative_quantum_record_demo_trace

theorem quantitative_quantum_record_demo_feeds_local_readability_three :
    ∃ m,
      QuantifiedLocalReadabilityMagnitudeInside
        (local_readability_measure_projects_to_readability_context
          (local_reconstruction_projects_to_local_readability_measure_context
            QuantitativePhysicalLocalInformationalAccessibilityContext.local_reconstruction_ctx)) m := by
  exact
    quantum_record_projects_to_local_readability_surface
      QuantitativePhysicalQuantumRecordLocalAccessibilityFeedContext
      quantitative_quantum_record_demo_trace

theorem quantitative_quantum_record_demo_feeds_fragment_component_count_two :
    ∃ n,
      QuantifiedFragmentComponentCountInside
        QuantitativePhysicalLocalInformationalAccessibilityContext.fragment_connectivity_ctx n := by
  exact
    quantum_record_projects_to_quantified_fragment_component_count_inside
      QuantitativePhysicalQuantumRecordLocalAccessibilityFeedContext
      quantitative_quantum_record_demo_trace

theorem quantitative_quantum_record_demo_feeds_fragment_split_degree_one :
    ∃ n,
      QuantifiedFragmentSplitDegreeInside
        QuantitativePhysicalLocalInformationalAccessibilityContext.fragment_connectivity_ctx n := by
  exact
    quantum_record_projects_to_quantified_fragment_split_degree_inside
      QuantitativePhysicalQuantumRecordLocalAccessibilityFeedContext
      quantitative_quantum_record_demo_trace

theorem quantitative_quantum_record_demo_feeds_fragment_pressure_three :
    ∃ n,
      QuantifiedQuantumRecordFragmentPressureInside
        QuantitativePhysicalQuantumRecordLocalAccessibilityFeedContext n := by
  exact
    quantum_record_projects_to_quantified_fragment_pressure
      QuantitativePhysicalQuantumRecordLocalAccessibilityFeedContext
      quantitative_quantum_record_demo_trace

theorem quantitative_quantum_record_demo_feeds_local_readability_pressure_three :
    ∃ n,
      QuantifiedQuantumRecordReadabilityPressureInside
        QuantitativePhysicalQuantumRecordLocalAccessibilityFeedContext n := by
  exact
    quantum_record_projects_to_quantified_local_readability_pressure
      QuantitativePhysicalQuantumRecordLocalAccessibilityFeedContext
      quantitative_quantum_record_demo_trace

theorem quantitative_quantum_record_demo_has_branching_two :
    QuantifiedQuantumBranchingMagnitudeInside
      QuantitativePhysicalOrderedQuantumRecordPressureContext 2 := by
  exact
    low_level_quantum_record_trace_gives_quantified_quantum_branching_magnitude_inside
      quantitative_quantum_record_demo_trace

theorem quantitative_quantum_record_demo_has_imprint_one :
    QuantifiedQuantumImprintMagnitudeInside
      QuantitativePhysicalOrderedQuantumRecordPressureContext 1 := by
  exact
    low_level_quantum_record_trace_gives_quantified_quantum_imprint_magnitude_inside
      quantitative_quantum_record_demo_trace

theorem quantitative_quantum_record_demo_has_stabilization_zero :
    QuantifiedQuantumStabilizationMagnitudeInside
      QuantitativePhysicalOrderedQuantumRecordPressureContext 0 := by
  exact
    low_level_quantum_record_trace_gives_quantified_quantum_stabilization_magnitude_inside
      quantitative_quantum_record_demo_trace

theorem quantitative_quantum_record_demo_has_ordered_fragment_pressure_three :
    QuantifiedOrderedQuantumFragmentPressureInside
      QuantitativePhysicalOrderedQuantumRecordPressureContext 3 := by
  exact
    quantum_record_trace_gives_quantified_ordered_quantum_fragment_pressure
      quantitative_quantum_record_demo_trace

theorem quantitative_quantum_record_demo_has_ordered_readability_pressure_three :
    QuantifiedOrderedQuantumReadabilityPressureInside
      QuantitativePhysicalOrderedQuantumRecordPressureContext 3 := by
  exact
    quantum_record_trace_gives_quantified_ordered_quantum_readability_pressure
      quantitative_quantum_record_demo_trace

theorem quantitative_quantum_record_demo_ordered_fragment_pressure_projects_to_fragment_pressure_three :
    QuantifiedQuantumRecordFragmentPressureInside
      QuantitativePhysicalQuantumRecordLocalAccessibilityFeedContext 3 := by
  exact
    ordered_quantum_fragment_pressure_projects_to_fragment_pressure
      QuantitativePhysicalOrderedQuantumRecordPressureContext
      quantitative_quantum_record_demo_trace

theorem quantitative_quantum_record_demo_ordered_readability_pressure_projects_to_local_readability_pressure_three :
    QuantifiedQuantumRecordReadabilityPressureInside
      QuantitativePhysicalQuantumRecordLocalAccessibilityFeedContext 3 := by
  exact
    ordered_quantum_readability_pressure_projects_to_local_readability_pressure
      QuantitativePhysicalOrderedQuantumRecordPressureContext
      quantitative_quantum_record_demo_trace

theorem quantitative_quantum_record_demo_ordered_pressure_gives_predictive_contribution_eight :
    QuantifiedQuantumRecordPredictivePressureContributionInside
      QuantitativePhysicalQuantumRecordLocalAccessibilityFeedContext
      (tri_spectral_loss_value 10 3 2 3) := by
  exact
    ordered_quantum_pressure_projects_to_quantified_recoverability_loss
      QuantitativePhysicalOrderedQuantumRecordPressureContext
      quantitative_quantum_record_demo_trace
      rfl

theorem quantitative_quantum_record_demo_ordered_pressure_gives_exact_predictive_level_two :
    PredictiveAccessibilityAtLevelInside
      QuantitativePhysicalLocalInformationalAccessibilityContext.local_reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx
      (10 - tri_spectral_loss_value 10 3 2 3) := by
  exact
    ordered_quantum_pressure_and_full_predictive_accessibility_give_exact_predictive_level
      QuantitativePhysicalOrderedQuantumRecordPressureContext
      quantitative_quantum_record_demo_trace
      rfl
      quantitative_locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility

theorem quantitative_quantum_pressure_law_demo_gives_predictive_contribution_eight :
    QuantifiedQuantumRecordPredictivePressureContributionInside
      QuantitativePhysicalQuantumRecordLocalAccessibilityFeedContext
      (quantum_predictive_pressure_contribution_value 10 2 1 2 0) := by
  exact
    quantum_pressure_law_projects_to_quantified_recoverability_loss
      QuantitativePhysicalQuantumPressureLawContext
      quantitative_quantum_record_demo_trace

theorem quantitative_quantum_pressure_law_demo_gives_exact_predictive_level_two :
    PredictiveAccessibilityAtLevelInside
      QuantitativePhysicalLocalInformationalAccessibilityContext.local_reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx
      (10 - quantum_predictive_pressure_contribution_value 10 2 1 2 0) := by
  exact
    quantum_pressure_law_and_full_predictive_accessibility_give_exact_predictive_level
      QuantitativePhysicalQuantumPressureLawContext
      quantitative_quantum_record_demo_trace
      quantitative_locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility

theorem quantitative_quantum_record_demo_gives_predictive_pressure_contribution_eight :
    QuantifiedQuantumRecordPredictivePressureContributionInside
      QuantitativePhysicalQuantumRecordLocalAccessibilityFeedContext
      (tri_spectral_loss_value 10 3 2 3) := by
  exact
    quantum_record_readability_pressure_projects_to_quantified_recoverability_loss
      QuantitativePhysicalQuantumRecordLocalAccessibilityFeedContext
      quantitative_quantum_record_demo_trace
      rfl
      rfl

theorem quantitative_quantum_record_demo_gives_exact_predictive_pressure_level_two :
    PredictiveAccessibilityAtLevelInside
      QuantitativePhysicalLocalInformationalAccessibilityContext.local_reconstruction_ctx.connectivity_ctx.measure_ctx.tri_ctx.loss_ctx.gradient_ctx
      (10 - tri_spectral_loss_value 10 3 2 3) := by
  exact
    quantum_record_predictive_pressure_contribution_and_full_predictive_accessibility_give_exact_predictive_level
      QuantitativePhysicalQuantumRecordLocalAccessibilityFeedContext
      quantitative_quantum_record_demo_trace
      rfl
      rfl
      quantitative_locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility

theorem quantitative_quantum_record_demo_feeds_bridge_neutral_entropy_shell :
    let readinessCtx :=
      QuantitativePhysicalLocalInformationalAccessibilityContext.entropy_readiness_ctx
    StableTraceInside readinessCtx.recoverability_ctx.memory_ctx /\
    EntropyLikeDispersionInside readinessCtx.recoverability_ctx /\
    InterfaceForgettingInside readinessCtx.recoverability_ctx := by
  exact
    quantum_record_projects_to_bridge_neutral_entropy_shell
      QuantitativePhysicalQuantumRecordLocalAccessibilityFeedContext
      quantitative_quantum_record_demo_trace

def QuantumRecordInteractionOnlyProfile : InterfaceProfile :=
  BareInterfaceProfile

def QuantumRecordInteractionOnlyMemoryContext :
    PhysicalMemoryContext QuantumRecordInteractionOnlyProfile :=
  { Obj := Unit
    inside_universe := fun _ => True
    structured := fun _ => False
    stable := fun _ => False
    carries_information_about_prior_state := fun _ => False
    thermodynamic_trace := fun _ => False
    measurement_record := fun _ => False
    dna_heredity_record := fun _ => False
    cosmological_trace := fun _ => False
    symbolic_record := fun _ => False
    stable_trace_inside_gives_profile_record := by
      intro h
      rcases h with ⟨_x, _hInside, hStructured, _hStable, _hInfo⟩
      exact False.elim hStructured }

def QuantumRecordInteractionOnlyContext :
    PhysicalQuantumRecordContext QuantumRecordInteractionOnlyProfile :=
  { memory_ctx := QuantumRecordInteractionOnlyMemoryContext
    QCarrier := Unit
    inside_universe := fun _ => True
    interaction_event := fun _ => True
    alternative_branching := fun _ => False
    environmental_imprint := fun _ => False
    branch_separation := fun _ => False
    outcome_record_stabilized := fun _ => False
    record_carrier_of := fun _ => ()
    stabilized_record_projects_to_record_object := by
      intro _q _hInside _hInteraction hBranching _hImprint _hSeparation _hStable
      exact False.elim hBranching
    stabilized_record_projects_to_measurement_record := by
      intro _q _hInside _hInteraction hBranching _hImprint _hSeparation _hStable
      exact False.elim hBranching }

theorem interaction_alone_does_not_imply_stabilized_record :
    Not (StableOutcomeRecordInside QuantumRecordInteractionOnlyContext) := by
  intro h
  rcases h with ⟨_q, _hInside, _hInteraction, hBranching, _hImprint, _hSeparation, _hStable⟩
  exact hBranching

theorem branching_alone_does_not_imply_decoherence_branch_separation :
    Not (DecoherenceBranchSeparationInside QuantumRecordInteractionOnlyContext) := by
  intro h
  rcases h with ⟨_q, _hInside, _hInteraction, hBranching, _hSeparation⟩
  exact hBranching

theorem environmental_imprint_alone_does_not_imply_stable_outcome_record :
    Not (EnvironmentalImprintInside QuantumRecordInteractionOnlyContext) := by
  intro h
  rcases h with ⟨_q, _hInside, _hInteraction, hImprint⟩
  exact hImprint

theorem stable_outcome_record_does_not_imply_full_second_law_theorem :
    StableOutcomeRecordInside QuantitativePhysicalQuantumRecordContext ->
      True := by
  intro _h
  trivial

theorem quantum_record_layer_does_not_replace_thermodynamic_overlay :
    EntropyBridgeCandidateAxis.decoherenceRecord ≠
      EntropyBridgeCandidateAxis.thermodynamics := by
  decide

theorem quantum_record_layer_does_not_replace_local_informational_accessibility :
    EntropyBridgeCandidateAxis.decoherenceRecord ≠
      EntropyBridgeCandidateAxis.localAccessibility := by
  decide

theorem quantitative_readable_fragment_demo_has_magnitude_three :
    QuantifiedLocalReadableFragmentMagnitudeInside
      QuantitativeReadableFragmentContext 3 := by
  exact
    quantitative_fragmentation_demo_has_fragment_value_three

theorem quantitative_derived_local_readability_measure_demo_has_cost_three :
    QuantifiedLocalReadabilityCostMagnitudeInside
      QuantitativeDerivedLocalReadabilityMeasureContext 3 := by
  change
    QuantifiedLocalReadabilityCostMagnitudeInside
      QuantitativeReadableFragmentContext.measure_ctx 3
  exact
    quantified_local_readable_fragment_projects_to_local_readability_cost
      QuantitativeReadableFragmentContext 3
      quantitative_readable_fragment_demo_has_magnitude_three

theorem quantitative_derived_local_readability_measure_projects_to_local_readability_three :
    QuantifiedLocalReadabilityMagnitudeInside
      (local_readability_measure_projects_to_readability_context
        QuantitativeDerivedLocalReadabilityMeasureContext) 3 := by
  exact
    quantified_local_readability_cost_projects_to_quantified_local_readability_magnitude_inside
      QuantitativeDerivedLocalReadabilityMeasureContext 3
      quantitative_derived_local_readability_measure_demo_has_cost_three

def QuantitativeLocalReadabilityDerivedLocalityContext :
    PhysicalLocalReadabilityContext
      ForgettingPredictiveContinuationProfile :=
  local_readability_measure_projects_to_readability_context
    QuantitativeDerivedLocalReadabilityMeasureContext

def quantitative_local_readability_demo_trace :
    LowLevelLocalReadabilityTrace QuantitativeLocalReadabilityDerivedLocalityContext :=
  { carrier := ()
    inside := by trivial
    record := ⟨by trivial, by trivial, by trivial⟩
    distributed := by trivial
    recovery_blocked := by trivial
    inaccessible := by
      intro h
      cases h
    readability_trace := by trivial }

theorem quantitative_local_readability_demo_has_magnitude_three :
    QuantifiedLocalReadabilityMagnitudeInside
      QuantitativeLocalReadabilityDerivedLocalityContext 3 := by
  exact
    quantitative_derived_local_readability_measure_projects_to_local_readability_three

theorem quantitative_local_readability_demo_gives_derived_locality_loss_three :
    DerivedLocalityLossMagnitudeInside
      QuantitativeLocalReadabilityDerivedLocalityContext 3 := by
  exact
    quantified_local_readability_magnitude_inside_gives_derived_locality_loss
      QuantitativeLocalReadabilityDerivedLocalityContext 3
      quantitative_local_readability_demo_has_magnitude_three

theorem quantitative_local_readability_demo_projects_to_locality_axis_three :
    TriSpectrumLossAtAxisInside
      QuantitativeLocalReadabilityDerivedLocalityContext.tri_ctx
      RecoverabilityTriSpectrumAxis.locality 3 := by
  exact
    derived_locality_loss_projects_to_tri_spectrum_locality_axis
      QuantitativeLocalReadabilityDerivedLocalityContext 3
      quantitative_local_readability_demo_gives_derived_locality_loss_three

theorem quantitative_local_readability_demo_gives_loss_eight :
    QuantifiedRecoverabilityLossAtMagnitudeInside
      QuantitativeLocalReadabilityDerivedLocalityContext.tri_ctx.loss_ctx 8 := by
  exact
    local_readability_trace_and_axis_values_give_quantified_recoverability_loss
      QuantitativeLocalReadabilityDerivedLocalityContext
      (x := ())
      (d := 3)
      (b := 2)
      (l := 3)
      (by trivial)
      (⟨by trivial, by trivial, by trivial⟩)
      (by trivial)
      (by trivial)
      (by
        intro h
        cases h)
      (by trivial)
      rfl
      rfl
      rfl

theorem quantitative_local_readability_demo_gives_exact_level_two :
    PredictiveAccessibilityAtLevelInside
      QuantitativeLocalReadabilityDerivedLocalityContext.tri_ctx.loss_ctx.gradient_ctx 2 := by
  exact
    recoverability_tri_spectrum_and_full_predictive_accessibility_give_exact_predictive_level
      QuantitativeLocalReadabilityDerivedLocalityContext.tri_ctx 8
      quantitative_local_readability_demo_gives_loss_eight
      quantitative_locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility

theorem quantitative_local_readability_demo_gives_exact_drop :
    exists p :
      QuantitativeLocalReadabilityDerivedLocalityContext.tri_ctx.loss_ctx.gradient_ctx.predictive_ctx.Proc,
        QuantitativeLocalReadabilityDerivedLocalityContext.tri_ctx.loss_ctx.gradient_ctx.predictive_ctx.inside_universe p /\
        QuantitativeLocalReadabilityDerivedLocalityContext.tri_ctx.loss_ctx.gradient_ctx.predictive_ctx.expected_candidate p /\
        QuantitativeLocalReadabilityDerivedLocalityContext.tri_ctx.loss_ctx.gradient_ctx.predictive_ctx.result_trace p /\
        QuantitativeLocalReadabilityDerivedLocalityContext.tri_ctx.loss_ctx.gradient_ctx.predictive_accessibility_level p + 8 =
          QuantitativeLocalReadabilityDerivedLocalityContext.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level := by
  exact
    recoverability_tri_spectrum_and_full_predictive_accessibility_give_exact_predictive_drop
      QuantitativeLocalReadabilityDerivedLocalityContext.tri_ctx 8
      quantitative_local_readability_demo_gives_loss_eight
      quantitative_locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility

def NoLocalReadabilityGuardContext :
    PhysicalLocalReadabilityContext
      ForgettingPredictiveContinuationProfile :=
  { tri_ctx := QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext
    local_readability_trace := fun _ => False
    local_readability_magnitude := fun _ => 3
    derived_locality_loss_magnitude := fun _ => 3
    local_readability_trace_has_positive_magnitude := by
      intro _x _hInside _hRecord _hDistributed _hBlocked _hInaccessible hTrace
      cases hTrace
    derived_locality_loss_agrees_with_local_readability := by
      intro _x _hInside _hRecord _hDistributed _hBlocked _hInaccessible hTrace
      cases hTrace
    derived_locality_projects_to_tri_locality := by
      intro _x _hInside _hRecord _hDistributed _hBlocked _hInaccessible hTrace
      cases hTrace }

theorem no_local_readability_guard_has_distributed_blocked_inaccessible_trace :
    exists x :
      NoLocalReadabilityGuardContext.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
        NoLocalReadabilityGuardContext.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x /\
        RecordObject NoLocalReadabilityGuardContext.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x /\
        NoLocalReadabilityGuardContext.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x /\
        NoLocalReadabilityGuardContext.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x /\
        ¬ NoLocalReadabilityGuardContext.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x := by
  exact
    ⟨(), by trivial, ⟨by trivial, by trivial, by trivial⟩, by trivial, by trivial,
      by
        intro h
        cases h⟩

theorem no_local_readability_guard_not_quantified_local_readability_three :
    ¬ QuantifiedLocalReadabilityMagnitudeInside NoLocalReadabilityGuardContext 3 := by
  intro h
  rcases h with ⟨_x, _hInside, _hRecord, _hDistributed, _hBlocked, _hInaccessible, hTrace, _hMagnitude⟩
  exact hTrace

theorem distributed_blocked_inaccessible_trace_alone_does_not_imply_quantified_local_readability :
    Not (forall {u : InterfaceProfile}
      (ctx : PhysicalLocalReadabilityContext u)
      (n : Nat),
      (exists x : ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.Obj,
        ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx.inside_universe x /\
        RecordObject ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx x /\
        ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.distributed x /\
        ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.recovery_practically_blocked x /\
        ¬ ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.interface_accessible x) ->
      QuantifiedLocalReadabilityMagnitudeInside ctx n) := by
  intro h
  exact
    no_local_readability_guard_not_quantified_local_readability_three
      (h NoLocalReadabilityGuardContext 3
        no_local_readability_guard_has_distributed_blocked_inaccessible_trace)

def QuantitativeLocalUnreadabilityDerivedLocalityContext :
    PhysicalLocalReadabilityCostContext
      ForgettingPredictiveContinuationProfile :=
  { readability_ctx := QuantitativeLocalReadabilityDerivedLocalityContext
    accessibility_flag := fun _ => false
    distributed_flag := fun _ => true
    local_unreadability_magnitude := fun x =>
      local_unreadability_value
        (QuantitativeLocalReadabilityDerivedLocalityContext.tri_ctx.blockedness_magnitude x)
        false
        true
    accessibility_flag_reflects_interface_accessible := by
      intro _x
      constructor
      · intro h
        simp at h
      · intro h
        cases h
    distributed_flag_reflects_distributed := by
      intro _x
      constructor
      · intro _h
        trivial
      · intro _h
        rfl
    local_unreadability_matches_derived_rule := by
      intro _x
      simp [local_unreadability_value,
        QuantitativeLocalReadabilityDerivedLocalityContext,
        local_readability_measure_projects_to_readability_context,
        QuantitativeDerivedLocalReadabilityMeasureContext,
        QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext]
    derived_locality_loss_matches_local_unreadability := by
      intro _x
      simp [QuantitativeLocalReadabilityDerivedLocalityContext,
        local_readability_measure_projects_to_readability_context,
        QuantitativeDerivedLocalReadabilityMeasureContext,
        QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext,
        local_unreadability_value,
        readable_fragment_value] }

theorem quantitative_local_unreadability_demo_has_magnitude_three :
    QuantifiedLocalUnreadabilityMagnitudeInside
      QuantitativeLocalUnreadabilityDerivedLocalityContext 3 := by
  simpa [QuantitativeLocalUnreadabilityDerivedLocalityContext,
    QuantitativeLocalReadabilityDerivedLocalityContext,
    local_readability_measure_projects_to_readability_context,
    QuantitativeDerivedLocalReadabilityMeasureContext,
    QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext,
    local_unreadability_value,
    readable_fragment_value]
    using
      low_level_local_readability_trace_gives_quantified_local_unreadability_magnitude_inside
        (ctx := QuantitativeLocalUnreadabilityDerivedLocalityContext)
        quantitative_local_readability_demo_trace

theorem quantitative_local_unreadability_demo_gives_derived_locality_loss_three :
    DerivedLocalityLossMagnitudeInside
      QuantitativeLocalUnreadabilityDerivedLocalityContext.readability_ctx 3 := by
  exact
    quantified_local_unreadability_magnitude_inside_gives_derived_locality_loss
      QuantitativeLocalUnreadabilityDerivedLocalityContext 3
      quantitative_local_unreadability_demo_has_magnitude_three

theorem quantitative_local_unreadability_demo_gives_interface_forgetting :
    InterfaceForgettingInside
      QuantitativeLocalUnreadabilityDerivedLocalityContext.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx := by
  exact
    quantified_local_unreadability_magnitude_inside_gives_interface_forgetting
      QuantitativeLocalUnreadabilityDerivedLocalityContext 3
      quantitative_local_unreadability_demo_has_magnitude_three

theorem quantitative_local_unreadability_demo_gives_loss_eight :
    QuantifiedRecoverabilityLossAtMagnitudeInside
      QuantitativeLocalUnreadabilityDerivedLocalityContext.readability_ctx.tri_ctx.loss_ctx 8 := by
  change
    QuantifiedRecoverabilityLossAtMagnitudeInside
      QuantitativeLocalUnreadabilityDerivedLocalityContext.readability_ctx.tri_ctx.loss_ctx
      (tri_spectral_loss_value
        QuantitativeLocalUnreadabilityDerivedLocalityContext.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level
        3 2 3)
  simpa [tri_spectral_loss_value,
    QuantitativeLocalUnreadabilityDerivedLocalityContext,
    QuantitativeLocalReadabilityDerivedLocalityContext,
    local_readability_measure_projects_to_readability_context,
    QuantitativeDerivedLocalReadabilityMeasureContext,
    QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext,
    local_unreadability_value,
    readable_fragment_value] using
    local_unreadability_trace_and_axis_values_give_quantified_recoverability_loss
      QuantitativeLocalUnreadabilityDerivedLocalityContext
      (x := ())
      (d := 3)
      (b := 2)
      (n := 3)
      (by trivial)
      (⟨by trivial, by trivial, by trivial⟩)
      (by trivial)
      (by trivial)
      (by
        intro h
        cases h)
      (by trivial)
      rfl
      rfl
      (by
        simp [QuantitativeLocalUnreadabilityDerivedLocalityContext,
          QuantitativeLocalReadabilityDerivedLocalityContext,
          local_readability_measure_projects_to_readability_context,
          QuantitativeDerivedLocalReadabilityMeasureContext,
          QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext,
          local_unreadability_value])

theorem quantitative_local_unreadability_demo_gives_exact_level_two :
    PredictiveAccessibilityAtLevelInside
      QuantitativeLocalUnreadabilityDerivedLocalityContext.readability_ctx.tri_ctx.loss_ctx.gradient_ctx 2 := by
  exact
    quantified_local_unreadability_and_full_predictive_accessibility_give_exact_predictive_level
      QuantitativeLocalUnreadabilityDerivedLocalityContext
      (x := ())
      3
      (by trivial)
      (⟨by trivial, by trivial, by trivial⟩)
      (by trivial)
      (by trivial)
      (by
        intro h
        cases h)
      (by trivial)
      (by
        simp [QuantitativeLocalUnreadabilityDerivedLocalityContext,
          QuantitativeLocalReadabilityDerivedLocalityContext,
          local_readability_measure_projects_to_readability_context,
          QuantitativeDerivedLocalReadabilityMeasureContext,
          QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext,
          local_unreadability_value])
      quantitative_locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility

theorem quantitative_local_unreadability_demo_gives_exact_drop :
    exists p :
      QuantitativeLocalUnreadabilityDerivedLocalityContext.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.predictive_ctx.Proc,
        QuantitativeLocalUnreadabilityDerivedLocalityContext.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.predictive_ctx.inside_universe p /\
        QuantitativeLocalUnreadabilityDerivedLocalityContext.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.predictive_ctx.expected_candidate p /\
        QuantitativeLocalUnreadabilityDerivedLocalityContext.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.predictive_ctx.result_trace p /\
        QuantitativeLocalUnreadabilityDerivedLocalityContext.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.predictive_accessibility_level p + 8 =
          QuantitativeLocalUnreadabilityDerivedLocalityContext.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.full_accessibility_level := by
  exact
    quantified_local_unreadability_and_full_predictive_accessibility_give_exact_predictive_drop
      QuantitativeLocalUnreadabilityDerivedLocalityContext
      (x := ())
      3
      (by trivial)
      (⟨by trivial, by trivial, by trivial⟩)
      (by trivial)
      (by trivial)
      (by
        intro h
        cases h)
      (by trivial)
      (by
        simp [QuantitativeLocalUnreadabilityDerivedLocalityContext,
          QuantitativeLocalReadabilityDerivedLocalityContext,
          local_readability_measure_projects_to_readability_context,
          QuantitativeDerivedLocalReadabilityMeasureContext,
          QuantitativeLocalitySensitiveRecoverabilityTriSpectrumContext,
          local_unreadability_value])
      quantitative_locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility

theorem quantitative_local_unreadability_demo_gives_four_layer_forgetting_chain :
    FourLayerForgettingChainInside
      QuantitativeLocalUnreadabilityDerivedLocalityContext := by
  exact
    low_level_recoverability_and_local_unreadability_traces_give_four_layer_forgetting_chain
      QuantitativeLocalUnreadabilityDerivedLocalityContext
      quantitative_local_readability_demo_trace
      quantitative_locality_sensitive_positive_predictive_gradient_has_full_predictive_accessibility

theorem local_unreadability_does_not_imply_trace_annihilation :
    Not (forall {u : InterfaceProfile}
      (ctx : PhysicalLocalReadabilityCostContext u)
      (n : Nat),
      QuantifiedLocalUnreadabilityMagnitudeInside ctx n ->
        Not (StableTraceInside
          ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx)) := by
  intro h
  have hStable :
      StableTraceInside
        QuantitativeLocalUnreadabilityDerivedLocalityContext.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx.memory_ctx := by
    exact
      quantified_local_unreadability_magnitude_inside_gives_stable_trace_inside
        QuantitativeLocalUnreadabilityDerivedLocalityContext 3
        quantitative_local_unreadability_demo_has_magnitude_three
  exact
    (h QuantitativeLocalUnreadabilityDerivedLocalityContext 3
      quantitative_local_unreadability_demo_has_magnitude_three)
      hStable

theorem local_unreadability_does_not_imply_zero_predictive_accessibility :
    Not (forall {u : InterfaceProfile}
      (ctx : PhysicalLocalReadabilityCostContext u)
      (n : Nat),
      QuantifiedLocalUnreadabilityMagnitudeInside ctx n ->
        Not (PositivePredictiveAccessibilityInside
          ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx)) := by
  intro h
  exact
    (h QuantitativeLocalUnreadabilityDerivedLocalityContext 3
      quantitative_local_unreadability_demo_has_magnitude_three)
      quantitative_locality_sensitive_positive_predictive_gradient_is_positive

def SecondLawReadableAsRecoverabilityAndReadabilityLoss
    (u : InterfaceProfile) : Prop :=
  exists ctx : PhysicalLocalReadabilityCostContext u,
    EntropyLikeDispersionInside
      ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx /\
    RecoverabilityLossInside
      ctx.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx /\
    ∃ n : Nat, QuantifiedLocalUnreadabilityMagnitudeInside ctx n

theorem local_unreadability_demo_has_entropy_like_dispersion :
    EntropyLikeDispersionInside
      QuantitativeLocalUnreadabilityDerivedLocalityContext.readability_ctx.tri_ctx.loss_ctx.gradient_ctx.recoverability_ctx := by
  exact ⟨(), by trivial, by trivial, by trivial, by trivial⟩

theorem quantitative_local_unreadability_demo_satisfies_second_law_readable_boundary :
    SecondLawReadableAsRecoverabilityAndReadabilityLoss
      ForgettingPredictiveContinuationProfile := by
  exact
    ⟨QuantitativeLocalUnreadabilityDerivedLocalityContext,
      local_unreadability_demo_has_entropy_like_dispersion,
      quantitative_local_unreadability_demo_gives_interface_forgetting,
      ⟨3, quantitative_local_unreadability_demo_has_magnitude_three⟩⟩

theorem dispersion_alone_does_not_imply_ordered_maximal_loss :
    Not (forall {u : InterfaceProfile}
      (ctx : PhysicalOrderedRecoverabilityLossContext u)
      (n : Nat),
      QuantifiedDispersionAtMagnitudeInside ctx n ->
        n = ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.full_accessibility_level) := by
  intro h
  have hEq :
      3 =
        ForgettingOrderedRecoverabilityLossContext.recovery_cost_ctx.loss_ctx.gradient_ctx.full_accessibility_level :=
    h ForgettingOrderedRecoverabilityLossContext 3
      forgetting_ordered_loss_demo_has_dispersion_three
  change 3 = 10 at hEq
  cases hEq

theorem blockedness_alone_does_not_imply_ordered_maximal_loss :
    Not (forall {u : InterfaceProfile}
      (ctx : PhysicalOrderedRecoverabilityLossContext u)
      (n : Nat),
      QuantifiedBlockednessAtMagnitudeInside ctx n ->
        n = ctx.recovery_cost_ctx.loss_ctx.gradient_ctx.full_accessibility_level) := by
  intro h
  have hEq :
      2 =
        ForgettingOrderedRecoverabilityLossContext.recovery_cost_ctx.loss_ctx.gradient_ctx.full_accessibility_level :=
    h ForgettingOrderedRecoverabilityLossContext 2
      forgetting_ordered_loss_demo_has_blockedness_two
  change 2 = 10 at hEq
  cases hEq

theorem small_dispersion_plus_small_blockedness_does_not_imply_zero_predictive_accessibility :
    Not (forall {u : InterfaceProfile}
      (ctx : PhysicalOrderedRecoverabilityLossContext u),
      QuantifiedDispersionAtMagnitudeInside ctx 3 ->
        QuantifiedBlockednessAtMagnitudeInside ctx 2 ->
          Not (PositivePredictiveAccessibilityInside
            ctx.recovery_cost_ctx.loss_ctx.gradient_ctx)) := by
  intro h
  exact
    (h
      ForgettingOrderedRecoverabilityLossContext
      forgetting_ordered_loss_demo_has_dispersion_three
      forgetting_ordered_loss_demo_has_blockedness_two)
      forgetting_positive_predictive_gradient_is_positive

theorem ordered_loss_does_not_imply_predictive_annihilation :
    Not (forall {u : InterfaceProfile}
      (ctx : PhysicalOrderedRecoverabilityLossContext u)
      (n : Nat),
      QuantifiedOrderedRecoverabilityLossAtMagnitudeInside ctx n ->
        Not (PositivePredictiveAccessibilityInside
          ctx.recovery_cost_ctx.loss_ctx.gradient_ctx)) := by
  intro h
  exact
    (h
      ForgettingOrderedRecoverabilityLossContext 5
      forgetting_ordered_loss_demo_has_loss_five)
      forgetting_positive_predictive_gradient_is_positive

theorem forgetting_does_not_imply_zero_predictive_accessibility :
    Not (forall {u : InterfaceProfile}
      (ctx : PhysicalPredictiveAccessibilityGradientContext u),
      InterfaceForgettingInside ctx.recoverability_ctx ->
        Not (PositivePredictiveAccessibilityInside ctx)) := by
  intro h
  exact
    (h
      ForgettingPositivePredictiveGradientContext
      forgetting_positive_predictive_gradient_has_forgetting)
      forgetting_positive_predictive_gradient_is_positive

theorem forgetting_does_not_imply_maximal_recoverability_loss :
    Not (forall {u : InterfaceProfile}
      (ctx : PhysicalPredictiveLossFunctionContext u),
      forall n : Nat,
        QuantifiedRecoverabilityLossAtMagnitudeInside ctx n ->
          n = ctx.gradient_ctx.full_accessibility_level) := by
  intro h
  have hEq :
      5 = ForgettingPredictiveLossFunctionContext.gradient_ctx.full_accessibility_level :=
    h ForgettingPredictiveLossFunctionContext 5
      forgetting_predictive_loss_has_magnitude_five
  change 5 = 10 at hEq
  cases hEq

def DynamicsOnlyAdaptiveSelectionProfile : InterfaceProfile :=
  { interface := True
    record := False
    selfModel := False
    adaptiveSelection := False
    predictiveCorrection := False
    selfObservation := False
    closure := False
    distinctionsBecomeStates := False
    statesBecomeEvents := False
    eventsBecomeMemory := False
    memoryBecomesThinking := False }

def DynamicsOnlyAdaptiveSelectionContext :
    PhysicalAdaptiveSelectionContext DynamicsOnlyAdaptiveSelectionProfile :=
  { Proc := Unit
    inside_universe := fun _ => True
    dynamics := fun _ => True
    possible_transitions := fun _ => False
    interface_admission_conditions := fun _ => False
    compatibility_checking := fun _ => False
    possible_refusal := fun _ => False
    future_influencing_trace := fun _ => False
    chemical_bond_selection := fun _ => False
    selective_exchange := fun _ => False
    biological_regulation_selection := fun _ => False
    market_admission_selection := fun _ => False
    protocol_compatibility_selection := fun _ => False
    adaptive_selection_inside_gives_profile_selection := by
      intro h
      rcases h with
        ⟨_p, _hInside, _hDynamics, hPossible, _hAdmission,
          _hCompat, _hRefusal, _hTrace⟩
      exact hPossible }

theorem dynamics_only_adaptive_selection_candidate_exists :
    exists p : DynamicsOnlyAdaptiveSelectionContext.Proc,
      DynamicsOnlyAdaptiveSelectionContext.inside_universe p /\
      DynamicsOnlyAdaptiveSelectionContext.dynamics p := by
  exact ⟨(), by trivial, by trivial⟩

theorem dynamics_only_context_not_adaptive_selection_inside :
    Not (AdaptiveSelectionWitnessInside
      DynamicsOnlyAdaptiveSelectionContext) := by
  intro h
  rcases h with
    ⟨_p, _hInside, _hDynamics, hPossible, _hAdmission,
      _hCompat, _hRefusal, _hTrace⟩
  exact hPossible

theorem dynamics_candidate_alone_does_not_imply_adaptive_selection_inside :
    Not (forall {u : InterfaceProfile}
      (ctx : PhysicalAdaptiveSelectionContext u),
      (exists p : ctx.Proc, ctx.inside_universe p /\ ctx.dynamics p) ->
        AdaptiveSelectionWitnessInside ctx) := by
  intro h
  exact dynamics_only_context_not_adaptive_selection_inside
    (h
      DynamicsOnlyAdaptiveSelectionContext
      dynamics_only_adaptive_selection_candidate_exists)

def NoFutureUpdatePredictiveCorrectionProfile : InterfaceProfile :=
  { interface := True
    record := False
    selfModel := False
    adaptiveSelection := False
    predictiveCorrection := False
    selfObservation := False
    closure := False
    distinctionsBecomeStates := False
    statesBecomeEvents := False
    eventsBecomeMemory := False
    memoryBecomesThinking := False }

def NoFutureUpdatePredictiveCorrectionContext :
    PhysicalPredictiveCorrectionContext
      NoFutureUpdatePredictiveCorrectionProfile :=
  { Proc := Unit
    inside_universe := fun _ => True
    expected_candidate := fun _ => True
    filter_pass_or_reject := fun _ => True
    result_trace := fun _ => True
    future_update := fun _ => False
    measurement_correction := fun _ => False
    learning_update := fun _ => False
    biological_regulation := fun _ => False
    market_system_feedback := fun _ => False
    scientific_model_correction := fun _ => False
    predictive_correction_inside_gives_profile_correction := by
      intro h
      rcases h with
        ⟨_p, _hInside, _hExpected, _hFilter, _hTrace, hUpdate⟩
      exact hUpdate }

theorem no_future_update_predictive_correction_candidate_exists :
    exists p : NoFutureUpdatePredictiveCorrectionContext.Proc,
      NoFutureUpdatePredictiveCorrectionContext.inside_universe p /\
      NoFutureUpdatePredictiveCorrectionContext.expected_candidate p /\
      NoFutureUpdatePredictiveCorrectionContext.filter_pass_or_reject p /\
      NoFutureUpdatePredictiveCorrectionContext.result_trace p := by
  exact ⟨(), by trivial, by trivial, by trivial, by trivial⟩

theorem no_future_update_context_not_predictive_correction_inside :
    Not (PredictiveCorrectionWitnessInside
      NoFutureUpdatePredictiveCorrectionContext) := by
  intro h
  rcases h with
    ⟨_p, _hInside, _hExpected, _hFilter, _hTrace, hUpdate⟩
  exact hUpdate

theorem no_future_update_candidate_alone_does_not_imply_predictive_correction_inside :
    Not (forall {u : InterfaceProfile}
      (ctx : PhysicalPredictiveCorrectionContext u),
      (exists p : ctx.Proc,
        ctx.inside_universe p /\
        ctx.expected_candidate p /\
        ctx.filter_pass_or_reject p /\
        ctx.result_trace p) ->
        PredictiveCorrectionWitnessInside ctx) := by
  intro h
  exact no_future_update_context_not_predictive_correction_inside
    (h
      NoFutureUpdatePredictiveCorrectionContext
      no_future_update_predictive_correction_candidate_exists)

def InternalProjectionOnlyClosureProfile : InterfaceProfile :=
  { interface := True
    record := False
    selfModel := False
    adaptiveSelection := False
    predictiveCorrection := False
    selfObservation := False
    closure := False
    distinctionsBecomeStates := False
    statesBecomeEvents := False
    eventsBecomeMemory := False
    memoryBecomesThinking := False }

def InternalProjectionOnlyClosureContext :
    PhysicalClosureContext InternalProjectionOnlyClosureProfile :=
  { Obj := Unit
    inside_universe := fun _ => False
    full_interface_form := fun _ => False
    internal_projection := fun _ => True
    projection_inside_universe := fun _ => False
    trace_preserved := fun _ => False
    no_projection_error := fun _ => False
    primary_interface_projection := fun _ => False
    trace_compare_information_projection := fun _ => False
    typed_domain_closure_projection := fun _ => False
    internal_observer_projection := fun _ => False
    system_code_projection := fun _ => False
    projective_closure_inside_gives_profile_closure := by
      intro h
      rcases h with
        ⟨_x, hInside, _hFull, _hProjection, _hProjectionInside,
          _hTrace, _hNoError⟩
      exact hInside }

theorem internal_projection_only_candidate_exists :
    exists x : InternalProjectionOnlyClosureContext.Obj,
      InternalProjectionOnlyClosureContext.internal_projection x := by
  exact ⟨(), by trivial⟩

theorem internal_projection_only_context_not_projective_closure_inside :
    Not (ProjectiveClosureWitnessInside
      InternalProjectionOnlyClosureContext) := by
  intro h
  rcases h with
    ⟨_x, hInside, _hFull, _hProjection, _hProjectionInside,
      _hTrace, _hNoError⟩
  exact hInside

theorem internal_projection_alone_does_not_imply_projective_closure_inside :
    Not (forall {u : InterfaceProfile}
      (ctx : PhysicalClosureContext u),
      (exists x : ctx.Obj, ctx.internal_projection x) ->
        ProjectiveClosureWitnessInside ctx) := by
  intro h
  exact internal_projection_only_context_not_projective_closure_inside
    (h
      InternalProjectionOnlyClosureContext
      internal_projection_only_candidate_exists)

def BridgeCriteriaOnlyNoSelfProcessProfile : InterfaceProfile :=
  { interface := True
    record := True
    selfModel := True
    adaptiveSelection := True
    predictiveCorrection := True
    selfObservation := False
    closure := True
    distinctionsBecomeStates := False
    statesBecomeEvents := False
    eventsBecomeMemory := False
    memoryBecomesThinking := False }

theorem bridge_criteria_only_no_self_process_has_physical_bridges :
    PhysicalBridgeCriteria BridgeCriteriaOnlyNoSelfProcessProfile := by
  exact {
    record := {
      describable_structure := by trivial
      stable_trace := by trivial
      description_as_retrieval := by trivial
      record := by trivial
    }
    self_model := {
      modeling_subsystem_inside := by trivial
      models_universe_or_region := by trivial
      organized_model_system := by trivial
      self_model := by trivial
    }
    adaptive_selection := {
      dynamics := by trivial
      possible_transitions := by trivial
      interface_admission_conditions := by trivial
      compatibility_checking := by trivial
      possible_refusal := by trivial
      future_influencing_trace := by trivial
      adaptive_selection := by trivial
    }
    predictive_correction := {
      trigger := by trivial
      expected_transition_candidate := by trivial
      interface_filters := by trivial
      pass_or_reject_result := by trivial
      result_trace := by trivial
      future_update := by trivial
      predictive_correction := by trivial
    }
    closure := {
      full_interface_form := by trivial
      internal_projection := by trivial
      projection_inside_universe := by trivial
      trace_preserved := by trivial
      no_projection_error := by trivial
      closure := by trivial
    }
  }

theorem bridge_criteria_only_no_self_process_not_self_closed_intelligent :
    Not (SelfClosedIntelligentInterface BridgeCriteriaOnlyNoSelfProcessProfile) := by
  intro h
  exact h.process.self_observation

theorem physical_bridges_without_self_process_do_not_imply_self_closed_witness :
    exists u : InterfaceProfile,
      PhysicalBridgeCriteria u /\ Not (SelfClosedIntelligentInterface u) := by
  exact ⟨
    BridgeCriteriaOnlyNoSelfProcessProfile,
    bridge_criteria_only_no_self_process_has_physical_bridges,
    bridge_criteria_only_no_self_process_not_self_closed_intelligent
  ⟩

theorem physical_bridges_alone_do_not_imply_self_closed_intelligent_interface :
    Not (forall u : InterfaceProfile,
      PhysicalBridgeCriteria u -> SelfClosedIntelligentInterface u) := by
  intro h
  exact bridge_criteria_only_no_self_process_not_self_closed_intelligent
    (h
      BridgeCriteriaOnlyNoSelfProcessProfile
      bridge_criteria_only_no_self_process_has_physical_bridges)

def RealizedDynamicsOnlyProfile : InterfaceProfile :=
  { interface := True
    record := False
    selfModel := False
    adaptiveSelection := False
    predictiveCorrection := False
    selfObservation := False
    closure := False
    distinctionsBecomeStates := False
    statesBecomeEvents := False
    eventsBecomeMemory := False
    memoryBecomesThinking := False }

def RealizedTransitionOnly (u : InterfaceProfile) : Prop :=
  Interfacehood u

def RealizedTransitionAloneImpliesAdaptiveSelection : Prop :=
  forall u : InterfaceProfile,
    RealizedTransitionOnly u -> u.adaptiveSelection

theorem realized_dynamics_only_has_realized_transition :
    RealizedTransitionOnly RealizedDynamicsOnlyProfile := by
  trivial

theorem realized_dynamics_only_not_adaptive_selection :
    Not RealizedDynamicsOnlyProfile.adaptiveSelection := by
  intro h
  exact h

theorem realized_transition_alone_does_not_imply_adaptive_selection :
    Not RealizedTransitionAloneImpliesAdaptiveSelection := by
  intro h
  exact realized_dynamics_only_not_adaptive_selection
    (h RealizedDynamicsOnlyProfile realized_dynamics_only_has_realized_transition)

end SelfThinkingUniverse
end TMI
