; TLFL 0.2 claim passport mirror.
; Scope: claim passport and proof-state certification, not empirical truth.

(set-logic QF_UF)

(declare-fun claim_presented () Bool)
(declare-fun lean_kernel_trace () Bool)
(declare-fun z3_trace () Bool)
(declare-fun vampire_trace () Bool)
(declare-fun e_trace () Bool)
(declare-fun tlfl_classification_trace () Bool)
(declare-fun nonclaim_guard_trace () Bool)
(declare-fun proof_self_model () Bool)

(declare-fun claim_passport () Bool)
(declare-fun allowed_claim_ceiling () Bool)
(declare-fun forbidden_jump_map () Bool)
(declare-fun proof_state_certification () Bool)

(declare-fun empirical_truth () Bool)
(declare-fun physical_validation () Bool)
(declare-fun consciousness () Bool)
(declare-fun empirical_closure () Bool)

(assert
  (= claim_passport
     (and claim_presented
          lean_kernel_trace
          z3_trace
          vampire_trace
          e_trace
          tlfl_classification_trace
          nonclaim_guard_trace
          proof_self_model)))

(assert (=> claim_passport allowed_claim_ceiling))
(assert (=> claim_passport forbidden_jump_map))
(assert (=> claim_passport proof_state_certification))

; Theorem: complete claim evidence + proof self-model gives claim passport.
(push)
(assert claim_presented)
(assert lean_kernel_trace)
(assert z3_trace)
(assert vampire_trace)
(assert e_trace)
(assert tlfl_classification_trace)
(assert nonclaim_guard_trace)
(assert proof_self_model)
(assert (not claim_passport))
(check-sat)
(pop)

; Theorem: claim passport gives allowed claim ceiling.
(push)
(assert claim_passport)
(assert (not allowed_claim_ceiling))
(check-sat)
(pop)

; Theorem: claim passport gives forbidden jump map.
(push)
(assert claim_passport)
(assert (not forbidden_jump_map))
(check-sat)
(pop)

; Theorem: claim passport gives proof-state certification.
(push)
(assert claim_passport)
(assert (not proof_state_certification))
(check-sat)
(pop)

; Guard: claim object alone does not imply claim passport.
(push)
(assert claim_presented)
(assert (not claim_passport))
(check-sat)
(pop)

; Guard: evidence traces without TLFL classification do not imply claim passport.
(push)
(assert claim_presented)
(assert lean_kernel_trace)
(assert z3_trace)
(assert vampire_trace)
(assert e_trace)
(assert (not tlfl_classification_trace))
(assert (not claim_passport))
(check-sat)
(pop)

; Guard: claim passport does not imply empirical truth.
(push)
(assert claim_passport)
(assert (not empirical_truth))
(check-sat)
(pop)

; Guard: claim passport does not imply physical validation.
(push)
(assert claim_passport)
(assert (not physical_validation))
(check-sat)
(pop)

; Guard: claim passport does not imply consciousness.
(push)
(assert claim_passport)
(assert (not consciousness))
(check-sat)
(pop)

; Guard: claim passport does not imply empirical closure.
(push)
(assert claim_passport)
(assert (not empirical_closure))
(check-sat)
(pop)
