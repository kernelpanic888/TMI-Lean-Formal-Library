; OLean-admitted proof projection to TLFL self-model.
; Scope: strict admitted-projection chain only.

(set-logic QF_UF)

(declare-fun external_projection () Bool)
(declare-fun olean_admitted () Bool)
(declare-fun tlfl_classified () Bool)
(declare-fun admitted_self_model () Bool)
(declare-fun guarded_mathematical_intelligence () Bool)
(declare-fun empirical_closure () Bool)

(assert
  (=> (and external_projection
           olean_admitted
           tlfl_classified)
      admitted_self_model))

(assert
  (=> admitted_self_model
      guarded_mathematical_intelligence))

; Positive theorem: strict admitted chain gives admitted self-model.
(push)
(assert external_projection)
(assert olean_admitted)
(assert tlfl_classified)
(assert (not admitted_self_model))
(check-sat)
(pop)

; Positive theorem: admitted self-model gives guarded mathematical intelligence.
(push)
(assert admitted_self_model)
(assert (not guarded_mathematical_intelligence))
(check-sat)
(pop)

; Guard: external projection alone does not imply strict self-model.
(push)
(assert external_projection)
(assert (not admitted_self_model))
(check-sat)
(pop)

; Guard: OLean admission alone does not imply strict self-model.
(push)
(assert olean_admitted)
(assert (not admitted_self_model))
(check-sat)
(pop)

; Guard: TLFL classification alone does not imply strict admitted self-model.
(push)
(assert tlfl_classified)
(assert (not admitted_self_model))
(check-sat)
(pop)

; Guard: admitted self-model does not imply empirical closure.
(push)
(assert admitted_self_model)
(assert (not empirical_closure))
(check-sat)
(pop)
