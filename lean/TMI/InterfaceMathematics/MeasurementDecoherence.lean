/-
Interface Mathematics: measurement as decoherence.

This module records the guarded TMI reading:

  measurement interface = decoherence interface

The equality is formalized as a layer boundary. Decoherence can realize the
measurement interface by producing branch separation, environmental imprint,
and a stable outcome record. A stronger iff reading is available only when a
context explicitly supplies the reverse direction.
-/

namespace TMI
namespace InterfaceMathematics

structure MeasurementDecoherenceContext where
  Prediction : Type
  SystemState : Type
  Environment : Type
  Record : Type
  prediction_candidate : Prediction -> Prop
  system_state_for : Prediction -> SystemState -> Prop
  environment_for : SystemState -> Environment -> Prop
  interaction_event : SystemState -> Environment -> Prop
  alternative_branching : SystemState -> Prop
  branch_separation : SystemState -> Environment -> Prop
  environmental_imprint : Environment -> Record -> Prop
  stable_outcome_record : Record -> Prop
  measurement_interface : Prediction -> Prop
  measurement_record : Prediction -> Record -> Prop
  decoherence_trace_gives_measurement_interface :
    forall p : Prediction,
      prediction_candidate p ->
      (exists s : SystemState,
        exists e : Environment,
          exists r : Record,
            system_state_for p s /\
            environment_for s e /\
            interaction_event s e /\
            alternative_branching s /\
            branch_separation s e /\
            environmental_imprint e r /\
            stable_outcome_record r) ->
        measurement_interface p
  decoherence_trace_gives_measurement_record :
    forall p : Prediction,
      forall r : Record,
        (exists s : SystemState,
          exists e : Environment,
            system_state_for p s /\
            environment_for s e /\
            interaction_event s e /\
            alternative_branching s /\
            branch_separation s e /\
            environmental_imprint e r /\
            stable_outcome_record r) ->
          measurement_record p r

def DecoherenceTrace
    (ctx : MeasurementDecoherenceContext)
    (p : ctx.Prediction)
    (r : ctx.Record) : Prop :=
  exists s : ctx.SystemState,
    exists e : ctx.Environment,
      ctx.system_state_for p s /\
      ctx.environment_for s e /\
      ctx.interaction_event s e /\
      ctx.alternative_branching s /\
      ctx.branch_separation s e /\
      ctx.environmental_imprint e r /\
      ctx.stable_outcome_record r

def StableDecoherenceRecord
    (ctx : MeasurementDecoherenceContext)
    (p : ctx.Prediction) : Prop :=
  exists r : ctx.Record, DecoherenceTrace ctx p r

def DecoherenceMeasurementInterface
    (ctx : MeasurementDecoherenceContext)
    (p : ctx.Prediction) : Prop :=
  ctx.prediction_candidate p /\ StableDecoherenceRecord ctx p

def MeasurementInterfaceAsDecoherence
    (ctx : MeasurementDecoherenceContext)
    (p : ctx.Prediction) : Prop :=
  DecoherenceMeasurementInterface ctx p

theorem decoherence_trace_gives_measurement_interface
    {ctx : MeasurementDecoherenceContext}
    {p : ctx.Prediction} :
    DecoherenceMeasurementInterface ctx p ->
      ctx.measurement_interface p := by
  intro h
  rcases h with ⟨hCandidate, r, hTrace⟩
  exact ctx.decoherence_trace_gives_measurement_interface
    p
    hCandidate
    ⟨
      hTrace.choose,
      hTrace.choose_spec.choose,
      r,
      hTrace.choose_spec.choose_spec
    ⟩

theorem stable_decoherence_record_gives_measurement_record
    {ctx : MeasurementDecoherenceContext}
    {p : ctx.Prediction}
    {r : ctx.Record} :
    DecoherenceTrace ctx p r -> ctx.measurement_record p r := by
  intro h
  exact ctx.decoherence_trace_gives_measurement_record p r h

theorem measurement_interface_as_decoherence_gives_measurement_interface
    {ctx : MeasurementDecoherenceContext}
    {p : ctx.Prediction} :
    MeasurementInterfaceAsDecoherence ctx p ->
      ctx.measurement_interface p := by
  exact decoherence_trace_gives_measurement_interface

structure MeasurementDecoherenceIdentificationContext where
  base : MeasurementDecoherenceContext
  measurement_interface_requires_decoherence :
    forall p : base.Prediction,
      base.measurement_interface p ->
        DecoherenceMeasurementInterface base p

def MeasurementInterfaceEqualsDecoherence
    (ctx : MeasurementDecoherenceIdentificationContext) : Prop :=
  forall p : ctx.base.Prediction,
    ctx.base.measurement_interface p <->
      DecoherenceMeasurementInterface ctx.base p

theorem measurement_interface_equals_decoherence_under_identification
    (ctx : MeasurementDecoherenceIdentificationContext) :
    MeasurementInterfaceEqualsDecoherence ctx := by
  intro p
  constructor
  · intro h
    exact ctx.measurement_interface_requires_decoherence p h
  · intro h
    exact decoherence_trace_gives_measurement_interface h

def InteractionOnlyMeasurementContext : MeasurementDecoherenceContext :=
  { Prediction := Unit
    SystemState := Unit
    Environment := Unit
    Record := Unit
    prediction_candidate := fun _ => True
    system_state_for := fun _ _ => True
    environment_for := fun _ _ => True
    interaction_event := fun _ _ => True
    alternative_branching := fun _ => False
    branch_separation := fun _ _ => False
    environmental_imprint := fun _ _ => False
    stable_outcome_record := fun _ => False
    measurement_interface := fun _ => False
    measurement_record := fun _ _ => False
    decoherence_trace_gives_measurement_interface := by
      intro p hCandidate h
      rcases h with
        ⟨s, e, r, _hSystem, _hEnv, _hInteraction,
          hBranching, _hSeparation, _hImprint, _hStable⟩
      exact False.elim hBranching
    decoherence_trace_gives_measurement_record := by
      intro p r h
      rcases h with
        ⟨s, e, _hSystem, _hEnv, _hInteraction,
          hBranching, _hSeparation, _hImprint, _hStable⟩
      exact False.elim hBranching }

theorem interaction_only_candidate_exists :
    exists s : InteractionOnlyMeasurementContext.SystemState,
      exists e : InteractionOnlyMeasurementContext.Environment,
        InteractionOnlyMeasurementContext.interaction_event s e := by
  exact ⟨(), (), by trivial⟩

theorem interaction_alone_does_not_imply_decoherence_measurement_interface :
    Not (DecoherenceMeasurementInterface
      InteractionOnlyMeasurementContext ()) := by
  intro h
  rcases h with ⟨_hCandidate, r, hTrace⟩
  rcases hTrace with
    ⟨s, e, _hSystem, _hEnv, _hInteraction,
      hBranching, _hSeparation, _hImprint, _hStable⟩
  exact hBranching

theorem interaction_alone_does_not_imply_measurement_interface :
    Not (InteractionOnlyMeasurementContext.measurement_interface ()) := by
  intro h
  exact h

def BranchingOnlyMeasurementContext : MeasurementDecoherenceContext :=
  { Prediction := Unit
    SystemState := Unit
    Environment := Unit
    Record := Unit
    prediction_candidate := fun _ => True
    system_state_for := fun _ _ => True
    environment_for := fun _ _ => True
    interaction_event := fun _ _ => True
    alternative_branching := fun _ => True
    branch_separation := fun _ _ => False
    environmental_imprint := fun _ _ => False
    stable_outcome_record := fun _ => False
    measurement_interface := fun _ => False
    measurement_record := fun _ _ => False
    decoherence_trace_gives_measurement_interface := by
      intro p hCandidate h
      rcases h with
        ⟨s, e, r, _hSystem, _hEnv, _hInteraction,
          _hBranching, hSeparation, _hImprint, _hStable⟩
      exact False.elim hSeparation
    decoherence_trace_gives_measurement_record := by
      intro p r h
      rcases h with
        ⟨s, e, _hSystem, _hEnv, _hInteraction,
          _hBranching, hSeparation, _hImprint, _hStable⟩
      exact False.elim hSeparation }

theorem branching_alone_does_not_imply_decoherence_measurement_interface :
    Not (DecoherenceMeasurementInterface
      BranchingOnlyMeasurementContext ()) := by
  intro h
  rcases h with ⟨_hCandidate, r, hTrace⟩
  rcases hTrace with
    ⟨s, e, _hSystem, _hEnv, _hInteraction,
      _hBranching, hSeparation, _hImprint, _hStable⟩
  exact hSeparation

end InterfaceMathematics
end TMI
