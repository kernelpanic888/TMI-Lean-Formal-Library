/-
Interface Mathematics: classes of interfacehood.

This module introduces a typed hierarchy of interfacehood classes. The hierarchy
keeps weak interfacehood separate from stronger classes such as recording,
modeling, intelligence, thinker operation, and physical verification.
-/

import TMI.InterfaceMathematics.ThinkerVerification

namespace TMI
namespace InterfaceMathematics

structure InterfacehoodClassContext where
  Carrier : Type
  distinguishes : Carrier -> Prop
  admits_transition : Carrier -> Prop
  filters_transition : Carrier -> Prop
  translates_state : Carrier -> Prop
  records_trace : Carrier -> Prop
  builds_model : Carrier -> Prop
  tests_transition : Carrier -> Prop
  produces_conclusion : Carrier -> Prop
  predicts_record : Carrier -> Prop
  externally_measures : Carrier -> Prop
  externally_records : Carrier -> Prop
  reproducible_record : Carrier -> Prop

def MinimalInterfaceClass
    (ctx : InterfacehoodClassContext)
    (x : ctx.Carrier) : Prop :=
  ctx.distinguishes x /\ ctx.admits_transition x

def FilteringInterfaceClass
    (ctx : InterfacehoodClassContext)
    (x : ctx.Carrier) : Prop :=
  MinimalInterfaceClass ctx x /\
  ctx.filters_transition x /\
  ctx.translates_state x

def RecordingInterfaceClass
    (ctx : InterfacehoodClassContext)
    (x : ctx.Carrier) : Prop :=
  FilteringInterfaceClass ctx x /\
  ctx.records_trace x

def ModelingInterfaceClass
    (ctx : InterfacehoodClassContext)
    (x : ctx.Carrier) : Prop :=
  RecordingInterfaceClass ctx x /\
  ctx.builds_model x /\
  ctx.tests_transition x

def IntelligenceInterfaceClass
    (ctx : InterfacehoodClassContext)
    (x : ctx.Carrier) : Prop :=
  ModelingInterfaceClass ctx x /\
  ctx.produces_conclusion x /\
  ctx.predicts_record x

def ThinkerInterfaceClass
    (ctx : InterfacehoodClassContext)
    (x : ctx.Carrier) : Prop :=
  IntelligenceInterfaceClass ctx x /\
  ctx.records_trace x

def PhysicalVerificationInterfaceClass
    (ctx : InterfacehoodClassContext)
    (x : ctx.Carrier) : Prop :=
  IntelligenceInterfaceClass ctx x /\
  ctx.externally_measures x /\
  ctx.externally_records x /\
  ctx.reproducible_record x

theorem filtering_interface_class_gives_minimal_interface_class
    {ctx : InterfacehoodClassContext}
    {x : ctx.Carrier} :
    FilteringInterfaceClass ctx x -> MinimalInterfaceClass ctx x := by
  intro h
  exact h.1

theorem recording_interface_class_gives_filtering_interface_class
    {ctx : InterfacehoodClassContext}
    {x : ctx.Carrier} :
    RecordingInterfaceClass ctx x -> FilteringInterfaceClass ctx x := by
  intro h
  exact h.1

theorem modeling_interface_class_gives_recording_interface_class
    {ctx : InterfacehoodClassContext}
    {x : ctx.Carrier} :
    ModelingInterfaceClass ctx x -> RecordingInterfaceClass ctx x := by
  intro h
  exact h.1

theorem intelligence_interface_class_gives_modeling_interface_class
    {ctx : InterfacehoodClassContext}
    {x : ctx.Carrier} :
    IntelligenceInterfaceClass ctx x -> ModelingInterfaceClass ctx x := by
  intro h
  exact h.1

theorem thinker_interface_class_gives_intelligence_interface_class
    {ctx : InterfacehoodClassContext}
    {x : ctx.Carrier} :
    ThinkerInterfaceClass ctx x -> IntelligenceInterfaceClass ctx x := by
  intro h
  exact h.1

theorem physical_verification_interface_class_gives_intelligence_interface_class
    {ctx : InterfacehoodClassContext}
    {x : ctx.Carrier} :
    PhysicalVerificationInterfaceClass ctx x ->
      IntelligenceInterfaceClass ctx x := by
  intro h
  exact h.1

theorem intelligence_interface_class_gives_minimal_interface_class
    {ctx : InterfacehoodClassContext}
    {x : ctx.Carrier} :
    IntelligenceInterfaceClass ctx x -> MinimalInterfaceClass ctx x := by
  intro h
  exact filtering_interface_class_gives_minimal_interface_class
    (recording_interface_class_gives_filtering_interface_class
      (modeling_interface_class_gives_recording_interface_class
        (intelligence_interface_class_gives_modeling_interface_class h)))

def ThinkerAsInterfacehoodClassContext
    (ctx : ThinkerVerificationContext) : InterfacehoodClassContext :=
  { Carrier := ctx.Thinker
    distinguishes := fun x => ctx.receives_distinctions x
    admits_transition := fun x =>
      exists t : ctx.Theory,
        exists m : ctx.Model,
          ctx.input_theory x t /\
          ctx.candidate t /\
          ctx.builds_internal_model x t m
    filters_transition := fun x =>
      exists t : ctx.Theory,
        exists m : ctx.Model,
          ctx.tests_admissible_transitions x t m
    translates_state := fun x =>
      exists t : ctx.Theory,
        exists m : ctx.Model,
          ctx.builds_internal_model x t m /\
          ctx.model_states m /\
          ctx.model_transitions m
    records_trace := fun x =>
      exists t : ctx.Theory,
        exists m : ctx.Model,
          ctx.records_result x t m /\
          ctx.model_expected_records m
    builds_model := fun x =>
      exists t : ctx.Theory,
        exists m : ctx.Model,
          ctx.builds_internal_model x t m /\
          InternalModelContent ctx m
    tests_transition := fun x =>
      exists t : ctx.Theory,
        exists m : ctx.Model,
          ctx.tests_admissible_transitions x t m
    produces_conclusion := fun x =>
      exists t : ctx.Theory,
        exists m : ctx.Model,
          ctx.produces_conclusion x t m
    predicts_record := fun _ =>
      exists _t : ctx.Theory,
        exists m : ctx.Model,
          ctx.model_predictions m /\
          ctx.model_expected_records m
    externally_measures := fun _ =>
      exists t : ctx.Theory,
        exists p : ctx.Prediction,
          ctx.prediction_of t p /\
          exists m : ctx.Measurement, ctx.measurement_of p m
    externally_records := fun _ =>
      exists t : ctx.Theory,
        exists p : ctx.Prediction,
          ctx.prediction_of t p /\
          exists m : ctx.Measurement,
            exists r : ctx.Record,
              ctx.measurement_of p m /\
              ctx.record_of m r
    reproducible_record := fun _ =>
      exists t : ctx.Theory,
        exists p : ctx.Prediction,
          ctx.prediction_of t p /\
          exists m : ctx.Measurement,
            exists r : ctx.Record,
              ctx.measurement_of p m /\
              ctx.record_of m r /\
              ctx.reproducible r }

theorem thinker_operates_intelligence_interface_gives_intelligence_interface_class
    {ctx : ThinkerVerificationContext}
    {x : ctx.Thinker}
    {t : ctx.Theory} :
    ThinkerOperatesIntelligenceInterface ctx x t ->
      IntelligenceInterfaceClass
        (ThinkerAsInterfacehoodClassContext ctx)
        x := by
  intro h
  rcases h with
    ⟨m, hThinker, hInput, hCandidate, hBuilds, hTests,
      hConclusion, hRecord, hContent⟩
  rcases hThinker with ⟨_hInterface, hDistinguishes⟩
  rcases hContent with
    ⟨hStates, hTransitions, hPredictions, hExpectedRecords⟩
  let classCtx := ThinkerAsInterfacehoodClassContext ctx
  have hMinimal : MinimalInterfaceClass classCtx x :=
    ⟨hDistinguishes, ⟨t, m, hInput, hCandidate, hBuilds⟩⟩
  have hFiltering : FilteringInterfaceClass classCtx x :=
    ⟨
      hMinimal,
      ⟨t, m, hTests⟩,
      ⟨t, m, hBuilds, hStates, hTransitions⟩
    ⟩
  have hRecording : RecordingInterfaceClass classCtx x :=
    ⟨hFiltering, ⟨t, m, hRecord, hExpectedRecords⟩⟩
  have hModeling : ModelingInterfaceClass classCtx x :=
    ⟨
      hRecording,
      ⟨t, m, hBuilds, hStates, hTransitions, hPredictions,
        hExpectedRecords⟩,
      ⟨t, m, hTests⟩
    ⟩
  exact ⟨
    hModeling,
    ⟨t, m, hConclusion⟩,
    ⟨t, m, hPredictions, hExpectedRecords⟩
  ⟩

theorem thinker_run_gives_intelligence_interface_class
    {ctx : ThinkerVerificationContext}
    {x : ctx.Thinker}
    {t : ctx.Theory} :
    ThinkerRun ctx x t ->
      IntelligenceInterfaceClass
        (ThinkerAsInterfacehoodClassContext ctx)
        x := by
  intro h
  exact thinker_operates_intelligence_interface_gives_intelligence_interface_class
    (thinker_run_gives_operates_intelligence_interface h)

def BareClassDemoContext : InterfacehoodClassContext :=
  { Carrier := Unit
    distinguishes := fun _ => True
    admits_transition := fun _ => True
    filters_transition := fun _ => False
    translates_state := fun _ => False
    records_trace := fun _ => False
    builds_model := fun _ => False
    tests_transition := fun _ => False
    produces_conclusion := fun _ => False
    predicts_record := fun _ => False
    externally_measures := fun _ => False
    externally_records := fun _ => False
    reproducible_record := fun _ => False }

theorem bare_class_demo_is_minimal_interface_class :
    MinimalInterfaceClass BareClassDemoContext () := by
  exact ⟨by trivial, by trivial⟩

theorem bare_class_demo_not_filtering_interface_class :
    Not (FilteringInterfaceClass BareClassDemoContext ()) := by
  intro h
  exact h.2.1

theorem minimal_interface_class_does_not_imply_filtering_interface_class :
    Not (forall (ctx : InterfacehoodClassContext)
      (x : ctx.Carrier),
        MinimalInterfaceClass ctx x -> FilteringInterfaceClass ctx x) := by
  intro h
  exact bare_class_demo_not_filtering_interface_class
    (h BareClassDemoContext () bare_class_demo_is_minimal_interface_class)

def FilteringOnlyClassDemoContext : InterfacehoodClassContext :=
  { Carrier := Unit
    distinguishes := fun _ => True
    admits_transition := fun _ => True
    filters_transition := fun _ => True
    translates_state := fun _ => True
    records_trace := fun _ => False
    builds_model := fun _ => False
    tests_transition := fun _ => False
    produces_conclusion := fun _ => False
    predicts_record := fun _ => False
    externally_measures := fun _ => False
    externally_records := fun _ => False
    reproducible_record := fun _ => False }

theorem filtering_only_demo_is_filtering_interface_class :
    FilteringInterfaceClass FilteringOnlyClassDemoContext () := by
  exact ⟨⟨by trivial, by trivial⟩, by trivial, by trivial⟩

theorem filtering_only_demo_not_recording_interface_class :
    Not (RecordingInterfaceClass FilteringOnlyClassDemoContext ()) := by
  intro h
  exact h.2

theorem filtering_interface_class_does_not_imply_recording_interface_class :
    Not (forall (ctx : InterfacehoodClassContext)
      (x : ctx.Carrier),
        FilteringInterfaceClass ctx x -> RecordingInterfaceClass ctx x) := by
  intro h
  exact filtering_only_demo_not_recording_interface_class
    (h FilteringOnlyClassDemoContext ()
      filtering_only_demo_is_filtering_interface_class)

end InterfaceMathematics
end TMI
