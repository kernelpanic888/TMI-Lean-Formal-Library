; TLFL proof-chain self-model mirror.
; Chain: TLFL + Z3 + Vampire + E proof layer.
; Scope: proof-status self-modeling, not empirical validation.

(set-logic QF_UF)

(declare-fun vampire_pass () Bool)
(declare-fun z3_pass () Bool)
(declare-fun e_pass () Bool)
(declare-fun tlfl_classifies () Bool)

(declare-fun tlfl_proof_self_model () Bool)
(declare-fun verification_boundary_map () Bool)
(declare-fun prover_compatibility_map () Bool)
(declare-fun epistemic_status_map () Bool)
(declare-fun nonclaim_guard_map () Bool)
(declare-fun claim_classification () Bool)

(declare-fun empirical_truth () Bool)
(declare-fun physical_validation () Bool)
(declare-fun replaces_external_proof_search () Bool)

(assert
  (= tlfl_proof_self_model
     (and vampire_pass z3_pass e_pass tlfl_classifies)))

(assert (=> tlfl_proof_self_model verification_boundary_map))
(assert (=> tlfl_proof_self_model prover_compatibility_map))
(assert (=> tlfl_proof_self_model epistemic_status_map))
(assert (=> tlfl_proof_self_model nonclaim_guard_map))
(assert (=> tlfl_proof_self_model claim_classification))

; Theorem: TLFL + Z3 + Vampire + E proof layer builds a proof-chain self-model.
(push)
(assert vampire_pass)
(assert z3_pass)
(assert e_pass)
(assert tlfl_classifies)
(assert (not tlfl_proof_self_model))
(check-sat)
(pop)

; Theorem: proof self-model projects to claim classification.
(push)
(assert tlfl_proof_self_model)
(assert (not claim_classification))
(check-sat)
(pop)

; Theorem: proof self-model has all four maps.
(push)
(assert tlfl_proof_self_model)
(assert
  (not
    (and verification_boundary_map
         prover_compatibility_map
         epistemic_status_map
         nonclaim_guard_map)))
(check-sat)
(pop)

; Guard: proof self-model does not imply empirical truth.
(push)
(assert tlfl_proof_self_model)
(assert (not empirical_truth))
(check-sat)
(pop)

; Guard: proof self-model does not imply physical validation.
(push)
(assert tlfl_proof_self_model)
(assert (not physical_validation))
(check-sat)
(pop)

; Guard: TLFL proof self-model does not replace Z3/Vampire/E search.
(push)
(assert tlfl_proof_self_model)
(assert (not replaces_external_proof_search))
(check-sat)
(pop)

; Guard: external prover traces without TLFL classification do not form
; the full TLFL + Z3 + Vampire + E proof-layer self-model.
(push)
(assert vampire_pass)
(assert z3_pass)
(assert e_pass)
(assert (not tlfl_classifies))
(assert (not tlfl_proof_self_model))
(check-sat)
(pop)
