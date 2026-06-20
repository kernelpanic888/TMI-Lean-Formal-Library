; TLFL guarded reality-cognition self-model mirror.
; Scope: externally presented reality trace through internal TLFL interfaces.

(set-logic QF_UF)

(declare-fun external_reality_trace () Bool)
(declare-fun internal_tlfl_interface_passage () Bool)
(declare-fun thinker_mediation () Bool)
(declare-fun tlfl_classification () Bool)
(declare-fun proof_state_self_model () Bool)
(declare-fun guarded_reality_cognition () Bool)
(declare-fun public_self_projection () Bool)
(declare-fun internal_model () Bool)

(declare-fun empirical_truth () Bool)
(declare-fun physical_validation () Bool)
(declare-fun consciousness () Bool)

(assert
  (=> (and external_reality_trace
           internal_tlfl_interface_passage
           thinker_mediation
           tlfl_classification)
      proof_state_self_model))

(assert
  (=> proof_state_self_model
      guarded_reality_cognition))

(assert
  (=> guarded_reality_cognition
      public_self_projection))

; Positive chain: external trace + internal passage + thinker mediation +
; TLFL classification gives guarded reality cognition.
(push)
(assert external_reality_trace)
(assert internal_tlfl_interface_passage)
(assert thinker_mediation)
(assert tlfl_classification)
(assert (not guarded_reality_cognition))
(check-sat)
(pop)

; Positive projection: guarded cognition projects to public self-projection.
(push)
(assert external_reality_trace)
(assert internal_tlfl_interface_passage)
(assert thinker_mediation)
(assert tlfl_classification)
(assert (not public_self_projection))
(check-sat)
(pop)

; Guard: guarded reality cognition does not imply empirical truth.
(push)
(assert guarded_reality_cognition)
(assert (not empirical_truth))
(check-sat)
(pop)

; Guard: guarded reality cognition does not imply physical validation.
(push)
(assert guarded_reality_cognition)
(assert (not physical_validation))
(check-sat)
(pop)

; Guard: guarded reality cognition does not imply consciousness.
(push)
(assert guarded_reality_cognition)
(assert (not consciousness))
(check-sat)
(pop)

; Guard: external reality trace alone does not imply self-model.
(push)
(assert external_reality_trace)
(assert (not proof_state_self_model))
(check-sat)
(pop)

; Guard: internal model alone does not imply reality cognition.
(push)
(assert internal_model)
(assert (not guarded_reality_cognition))
(check-sat)
(pop)
