/-
Interface Mathematics: thinker verification.

This module formalizes the TMI-Thinker Verification Principle. A thinker is an
interface between a theory and reality: it can receive distinctions, build an
internal model, test admissible transitions, produce a conclusion, and record
the result. The main guard is that internal conviction is not physical validity.
-/

namespace TMI
namespace InterfaceMathematics

structure ThinkerVerificationContext where
  Thinker : Type
  Theory : Type
  Model : Type
  Prediction : Type
  Measurement : Type
  Record : Type
  interface : Thinker -> Prop
  receives_distinctions : Thinker -> Prop
  input_theory : Thinker -> Theory -> Prop
  theory : Theory -> Prop
  candidate : Theory -> Prop
  theory_gives_candidate : forall t : Theory, theory t -> candidate t
  builds_internal_model : Thinker -> Theory -> Model -> Prop
  tests_admissible_transitions : Thinker -> Theory -> Model -> Prop
  produces_conclusion : Thinker -> Theory -> Model -> Prop
  records_result : Thinker -> Theory -> Model -> Prop
  model_states : Model -> Prop
  model_transitions : Model -> Prop
  model_predictions : Model -> Prop
  model_expected_records : Model -> Prop
  prediction_of : Theory -> Prediction -> Prop
  measurement_of : Prediction -> Measurement -> Prop
  record_of : Measurement -> Record -> Prop
  reproducible : Record -> Prop

def ThinkerInterface
    (ctx : ThinkerVerificationContext)
    (x : ctx.Thinker) : Prop :=
  ctx.interface x /\ ctx.receives_distinctions x

def InternalModelContent
    (ctx : ThinkerVerificationContext)
    (m : ctx.Model) : Prop :=
  ctx.model_states m /\
  ctx.model_transitions m /\
  ctx.model_predictions m /\
  ctx.model_expected_records m

def IntelligenceInterface
    (ctx : ThinkerVerificationContext)
    (x : ctx.Thinker)
    (t : ctx.Theory)
    (m : ctx.Model) : Prop :=
  ThinkerInterface ctx x /\
  ctx.input_theory x t /\
  ctx.candidate t /\
  ctx.builds_internal_model x t m /\
  ctx.tests_admissible_transitions x t m /\
  ctx.produces_conclusion x t m /\
  ctx.records_result x t m /\
  InternalModelContent ctx m

def InternalModelWitness
    (ctx : ThinkerVerificationContext)
    (x : ctx.Thinker)
    (t : ctx.Theory) : Prop :=
  exists m : ctx.Model,
    ctx.builds_internal_model x t m /\
    ctx.tests_admissible_transitions x t m /\
    ctx.produces_conclusion x t m /\
    ctx.records_result x t m /\
    InternalModelContent ctx m

def ThinkerOperatesIntelligenceInterface
    (ctx : ThinkerVerificationContext)
    (x : ctx.Thinker)
    (t : ctx.Theory) : Prop :=
  exists m : ctx.Model, IntelligenceInterface ctx x t m

def ThinkerRun
    (ctx : ThinkerVerificationContext)
    (x : ctx.Thinker)
    (t : ctx.Theory) : Prop :=
  ThinkerInterface ctx x /\
  ctx.input_theory x t /\
  ctx.candidate t /\
  InternalModelWitness ctx x t

theorem intelligence_interface_gives_thinker_interface
    {ctx : ThinkerVerificationContext}
    {x : ctx.Thinker}
    {t : ctx.Theory}
    {m : ctx.Model} :
    IntelligenceInterface ctx x t m -> ThinkerInterface ctx x := by
  intro h
  exact h.1

theorem intelligence_interface_gives_internal_model_witness
    {ctx : ThinkerVerificationContext}
    {x : ctx.Thinker}
    {t : ctx.Theory}
    {m : ctx.Model} :
    IntelligenceInterface ctx x t m -> InternalModelWitness ctx x t := by
  intro h
  rcases h with
    ⟨_hThinker, _hInput, _hCandidate, hBuilds, hTests,
      hConclusion, hRecord, hContent⟩
  exact ⟨m, hBuilds, hTests, hConclusion, hRecord, hContent⟩

theorem intelligence_interface_gives_thinker_run
    {ctx : ThinkerVerificationContext}
    {x : ctx.Thinker}
    {t : ctx.Theory}
    {m : ctx.Model} :
    IntelligenceInterface ctx x t m -> ThinkerRun ctx x t := by
  intro h
  rcases h with
    ⟨hThinker, hInput, hCandidate, hBuilds, hTests,
      hConclusion, hRecord, hContent⟩
  exact ⟨
    hThinker,
    hInput,
    hCandidate,
    ⟨m, hBuilds, hTests, hConclusion, hRecord, hContent⟩
  ⟩

theorem thinker_run_gives_operates_intelligence_interface
    {ctx : ThinkerVerificationContext}
    {x : ctx.Thinker}
    {t : ctx.Theory} :
    ThinkerRun ctx x t -> ThinkerOperatesIntelligenceInterface ctx x t := by
  intro h
  rcases h with
    ⟨hThinker, hInput, hCandidate, m, hBuilds, hTests,
      hConclusion, hRecord, hContent⟩
  exact ⟨m, hThinker, hInput, hCandidate, hBuilds, hTests,
    hConclusion, hRecord, hContent⟩

theorem operates_intelligence_interface_gives_thinker_run
    {ctx : ThinkerVerificationContext}
    {x : ctx.Thinker}
    {t : ctx.Theory} :
    ThinkerOperatesIntelligenceInterface ctx x t -> ThinkerRun ctx x t := by
  intro h
  rcases h with ⟨m, hIntelligenceInterface⟩
  exact intelligence_interface_gives_thinker_run hIntelligenceInterface

theorem thinker_run_iff_operates_intelligence_interface
    {ctx : ThinkerVerificationContext}
    {x : ctx.Thinker}
    {t : ctx.Theory} :
    ThinkerRun ctx x t <->
      ThinkerOperatesIntelligenceInterface ctx x t := by
  constructor
  · exact thinker_run_gives_operates_intelligence_interface
  · exact operates_intelligence_interface_gives_thinker_run

def Thinker
    (ctx : ThinkerVerificationContext)
    (x : ctx.Thinker) : Prop :=
  ThinkerInterface ctx x /\ exists t : ctx.Theory, ThinkerRun ctx x t

def TheoryCandidate
    (ctx : ThinkerVerificationContext)
    (t : ctx.Theory) : Prop :=
  ctx.theory t /\ ctx.candidate t

def ConvincingToThinker
    (ctx : ThinkerVerificationContext)
    (x : ctx.Thinker)
    (t : ctx.Theory) : Prop :=
  ThinkerRun ctx x t

def TheoryPredictionWitness
    (ctx : ThinkerVerificationContext)
    (t : ctx.Theory) : Prop :=
  exists p : ctx.Prediction, ctx.prediction_of t p

def ExternalVerificationChain
    (ctx : ThinkerVerificationContext)
    (t : ctx.Theory)
    (p : ctx.Prediction) : Prop :=
  ctx.prediction_of t p /\
  exists m : ctx.Measurement,
    exists r : ctx.Record,
      ctx.measurement_of p m /\
      ctx.record_of m r /\
      ctx.reproducible r

def ValidPhysicalTheory
    (ctx : ThinkerVerificationContext)
    (t : ctx.Theory) : Prop :=
  ctx.candidate t /\
  TheoryPredictionWitness ctx t /\
  forall p : ctx.Prediction,
    ctx.prediction_of t p -> ExternalVerificationChain ctx t p

theorem theory_enters_as_candidate
    {ctx : ThinkerVerificationContext}
    {t : ctx.Theory} :
    ctx.theory t -> ctx.candidate t := by
  intro h
  exact ctx.theory_gives_candidate t h

theorem thinker_run_gives_internal_model
    {ctx : ThinkerVerificationContext}
    {x : ctx.Thinker}
    {t : ctx.Theory} :
    ThinkerRun ctx x t -> InternalModelWitness ctx x t := by
  intro h
  exact h.2.2.2

theorem convincing_to_thinker_gives_candidate
    {ctx : ThinkerVerificationContext}
    {x : ctx.Thinker}
    {t : ctx.Theory} :
    ConvincingToThinker ctx x t -> ctx.candidate t := by
  intro h
  exact h.2.2.1

theorem valid_physical_theory_gives_candidate
    {ctx : ThinkerVerificationContext}
    {t : ctx.Theory} :
    ValidPhysicalTheory ctx t -> ctx.candidate t := by
  intro h
  exact h.1

theorem valid_physical_theory_gives_prediction_measurement_record_reproducibility
    {ctx : ThinkerVerificationContext}
    {t : ctx.Theory} :
    ValidPhysicalTheory ctx t ->
      exists p : ctx.Prediction,
        exists m : ctx.Measurement,
          exists r : ctx.Record,
            ctx.prediction_of t p /\
            ctx.measurement_of p m /\
            ctx.record_of m r /\
            ctx.reproducible r := by
  intro h
  rcases h with ⟨_hCandidate, hPrediction, hPasses⟩
  rcases hPrediction with ⟨p, hPred⟩
  rcases hPasses p hPred with
    ⟨hPredAgain, m, r, hMeasurement, hRecord, hReproducible⟩
  exact ⟨p, m, r, hPredAgain, hMeasurement, hRecord, hReproducible⟩

theorem physical_theory_must_pass_external_verification
    {ctx : ThinkerVerificationContext}
    {t : ctx.Theory} :
    ValidPhysicalTheory ctx t ->
      forall p : ctx.Prediction,
        ctx.prediction_of t p -> ExternalVerificationChain ctx t p := by
  intro h
  exact h.2.2

theorem no_measurement_record_reproducibility_implies_no_physical_validity
    {ctx : ThinkerVerificationContext}
    {t : ctx.Theory}
    (hPrediction : TheoryPredictionWitness ctx t)
    (hNoExternalPass :
      forall p : ctx.Prediction,
        ctx.prediction_of t p ->
          forall m : ctx.Measurement,
            forall r : ctx.Record,
              Not
                (ctx.measurement_of p m /\
                 ctx.record_of m r /\
                 ctx.reproducible r)) :
    Not (ValidPhysicalTheory ctx t) := by
  intro hValid
  rcases hValid with ⟨_hCandidate, _hPredWitness, hPasses⟩
  rcases hPrediction with ⟨p, hPred⟩
  rcases hPasses p hPred with
    ⟨_hPredAgain, m, r, hMeasurement, hRecord, hReproducible⟩
  exact hNoExternalPass p hPred m r
    ⟨hMeasurement, hRecord, hReproducible⟩

def ThinkerOnlyDemoContext : ThinkerVerificationContext :=
  { Thinker := Unit
    Theory := Unit
    Model := Unit
    Prediction := Unit
    Measurement := Unit
    Record := Unit
    interface := fun _ => True
    receives_distinctions := fun _ => True
    input_theory := fun _ _ => True
    theory := fun _ => True
    candidate := fun _ => True
    theory_gives_candidate := by
      intro _t _hTheory
      trivial
    builds_internal_model := fun _ _ _ => True
    tests_admissible_transitions := fun _ _ _ => True
    produces_conclusion := fun _ _ _ => True
    records_result := fun _ _ _ => True
    model_states := fun _ => True
    model_transitions := fun _ => True
    model_predictions := fun _ => True
    model_expected_records := fun _ => True
    prediction_of := fun _ _ => True
    measurement_of := fun _ _ => False
    record_of := fun _ _ => False
    reproducible := fun _ => False }

theorem thinker_only_demo_is_theory_candidate :
    TheoryCandidate ThinkerOnlyDemoContext () := by
  exact ⟨by trivial, by trivial⟩

theorem thinker_only_demo_is_convincing_to_thinker :
    ConvincingToThinker ThinkerOnlyDemoContext () () := by
  exact ⟨
    ⟨by trivial, by trivial⟩,
    by trivial,
    by trivial,
    ⟨
      (),
      by trivial,
      by trivial,
      by trivial,
      by trivial,
      by trivial,
      by trivial,
      by trivial,
      by trivial
    ⟩
  ⟩

theorem thinker_only_demo_operates_intelligence_interface :
    ThinkerOperatesIntelligenceInterface
      ThinkerOnlyDemoContext () () := by
  exact thinker_run_gives_operates_intelligence_interface
    thinker_only_demo_is_convincing_to_thinker

theorem thinker_only_demo_has_prediction :
    TheoryPredictionWitness ThinkerOnlyDemoContext () := by
  exact ⟨(), by trivial⟩

theorem thinker_only_demo_has_no_physical_validity :
    Not (ValidPhysicalTheory ThinkerOnlyDemoContext ()) := by
  apply no_measurement_record_reproducibility_implies_no_physical_validity
  · exact thinker_only_demo_has_prediction
  · intro p hPred m r
    intro h
    exact h.1

theorem internal_conviction_of_thinker_not_equal_physical_validity :
    ConvincingToThinker ThinkerOnlyDemoContext () () /\
      Not (ValidPhysicalTheory ThinkerOnlyDemoContext ()) := by
  exact ⟨
    thinker_only_demo_is_convincing_to_thinker,
    thinker_only_demo_has_no_physical_validity
  ⟩

theorem convincing_to_thinker_does_not_imply_valid_physical_theory :
    Not (forall (ctx : ThinkerVerificationContext)
      (x : ctx.Thinker)
      (t : ctx.Theory),
        ConvincingToThinker ctx x t -> ValidPhysicalTheory ctx t) := by
  intro h
  exact thinker_only_demo_has_no_physical_validity
    (h
      ThinkerOnlyDemoContext
      ()
      ()
      thinker_only_demo_is_convincing_to_thinker)

theorem thought_is_not_physical_fact_guard :
    exists ctx : ThinkerVerificationContext,
      exists x : ctx.Thinker,
        exists t : ctx.Theory,
          ConvincingToThinker ctx x t /\
          Not (ValidPhysicalTheory ctx t) := by
  exact ⟨
    ThinkerOnlyDemoContext,
    (),
    (),
    internal_conviction_of_thinker_not_equal_physical_validity
  ⟩

end InterfaceMathematics
end TMI
