/-
Interface Mathematics: self-modeling thinker as mathematical prover.

This layer formalizes a guarded idea: when a thinker enters the flow of
interface mathematics and builds a self-model of its own theory, it can become a
mathematical external prover for formal validity. The guarantee is internal to
the formal system: axioms, rules, proof object, and checker. It is not empirical
physical validation.
-/

namespace TMI
namespace InterfaceMathematics

structure SelfModelingProverContext where
  Thinker : Type
  Theory : Type
  Model : Type
  Statement : Type
  ProofObject : Type
  thinker_interface : Thinker -> Prop
  theory_candidate : Theory -> Prop
  self_model_of_theory : Thinker -> Theory -> Model -> Prop
  projectional_self_check : Thinker -> Theory -> Model -> Prop
  statement_of_theory : Theory -> Statement -> Prop
  proof_object_for : Theory -> Statement -> ProofObject -> Prop
  proof_rules_checked : ProofObject -> Prop
  proof_object_verified : ProofObject -> Prop
  formal_system_closed_for : Theory -> Prop
  guarantee_inside_formal_system : Theory -> Statement -> ProofObject -> Prop
  empirical_measurement_record : Theory -> Prop

def ThinkerThinksItselfMathematically
    (ctx : SelfModelingProverContext)
    (x : ctx.Thinker)
    (t : ctx.Theory) : Prop :=
  exists m : ctx.Model,
    ctx.thinker_interface x /\
    ctx.theory_candidate t /\
    ctx.self_model_of_theory x t m /\
    ctx.projectional_self_check x t m

def FormalSelfValidation
    (ctx : SelfModelingProverContext)
    (x : ctx.Thinker)
    (t : ctx.Theory)
    (s : ctx.Statement) : Prop :=
  ThinkerThinksItselfMathematically ctx x t /\
  ctx.statement_of_theory t s /\
  ctx.formal_system_closed_for t /\
  exists p : ctx.ProofObject,
    ctx.proof_object_for t s p /\
    ctx.proof_rules_checked p /\
    ctx.proof_object_verified p /\
    ctx.guarantee_inside_formal_system t s p

def MathematicalExternalProverInterface
    (ctx : SelfModelingProverContext)
    (x : ctx.Thinker)
    (t : ctx.Theory) : Prop :=
  exists s : ctx.Statement, FormalSelfValidation ctx x t s

def EmpiricalPhysicalValidation
    (ctx : SelfModelingProverContext)
    (t : ctx.Theory) : Prop :=
  ctx.empirical_measurement_record t

theorem formal_self_validation_gives_thinker_self_model
    {ctx : SelfModelingProverContext}
    {x : ctx.Thinker}
    {t : ctx.Theory}
    {s : ctx.Statement} :
    FormalSelfValidation ctx x t s ->
      ThinkerThinksItselfMathematically ctx x t := by
  intro h
  exact h.1

theorem formal_self_validation_gives_mathematical_external_prover
    {ctx : SelfModelingProverContext}
    {x : ctx.Thinker}
    {t : ctx.Theory}
    {s : ctx.Statement} :
    FormalSelfValidation ctx x t s ->
      MathematicalExternalProverInterface ctx x t := by
  intro h
  exact ⟨s, h⟩

theorem formal_self_validation_gives_verified_proof_object
    {ctx : SelfModelingProverContext}
    {x : ctx.Thinker}
    {t : ctx.Theory}
    {s : ctx.Statement} :
    FormalSelfValidation ctx x t s ->
      exists p : ctx.ProofObject,
        ctx.proof_object_for t s p /\
        ctx.proof_rules_checked p /\
        ctx.proof_object_verified p /\
        ctx.guarantee_inside_formal_system t s p := by
  intro h
  exact h.2.2.2

def FormalButNotEmpiricalDemoContext : SelfModelingProverContext :=
  { Thinker := Unit
    Theory := Unit
    Model := Unit
    Statement := Unit
    ProofObject := Unit
    thinker_interface := fun _ => True
    theory_candidate := fun _ => True
    self_model_of_theory := fun _ _ _ => True
    projectional_self_check := fun _ _ _ => True
    statement_of_theory := fun _ _ => True
    proof_object_for := fun _ _ _ => True
    proof_rules_checked := fun _ => True
    proof_object_verified := fun _ => True
    formal_system_closed_for := fun _ => True
    guarantee_inside_formal_system := fun _ _ _ => True
    empirical_measurement_record := fun _ => False }

theorem formal_but_not_empirical_demo_has_self_validation :
    FormalSelfValidation FormalButNotEmpiricalDemoContext () () () := by
  exact ⟨
    ⟨(), by trivial, by trivial, by trivial, by trivial⟩,
    by trivial,
    by trivial,
    ⟨(), by trivial, by trivial, by trivial, by trivial⟩
  ⟩

theorem formal_but_not_empirical_demo_is_mathematical_external_prover :
    MathematicalExternalProverInterface
      FormalButNotEmpiricalDemoContext () () := by
  exact formal_self_validation_gives_mathematical_external_prover
    formal_but_not_empirical_demo_has_self_validation

theorem formal_but_not_empirical_demo_not_empirical_physical_validation :
    Not (EmpiricalPhysicalValidation FormalButNotEmpiricalDemoContext ()) := by
  intro h
  exact h

theorem mathematical_external_prover_does_not_imply_empirical_physical_validation :
    Not (forall (ctx : SelfModelingProverContext)
      (x : ctx.Thinker)
      (t : ctx.Theory),
        MathematicalExternalProverInterface ctx x t ->
          EmpiricalPhysicalValidation ctx t) := by
  intro h
  exact formal_but_not_empirical_demo_not_empirical_physical_validation
    (h
      FormalButNotEmpiricalDemoContext
      ()
      ()
      formal_but_not_empirical_demo_is_mathematical_external_prover)

end InterfaceMathematics
end TMI
