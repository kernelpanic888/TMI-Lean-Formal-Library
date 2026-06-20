% TLFL 0.2 claim passport mirror.
% Positive theorem bundle for Vampire and E.

fof(claim_passport_axiom, axiom,
  ((claim_presented
    & lean_kernel_trace
    & z3_trace
    & vampire_trace
    & e_trace
    & tlfl_classification_trace
    & nonclaim_guard_trace
    & proof_self_model)
    => claim_passport)).

fof(allowed_ceiling_axiom, axiom,
  (claim_passport => allowed_claim_ceiling)).

fof(forbidden_jump_map_axiom, axiom,
  (claim_passport => forbidden_jump_map)).

fof(proof_state_certification_axiom, axiom,
  (claim_passport => proof_state_certification)).

fof(complete_input_verdict_axiom, axiom,
  (complete_claim_passport_input => verdict_pass)).

fof(missing_classification_verdict_axiom, axiom,
  (missing_tlfl_classification_input => verdict_fail)).

fof(pass_ceiling_axiom, axiom,
  (verdict_pass => certified_ceiling)).

fof(fail_ceiling_axiom, axiom,
  (verdict_fail => unadmitted_ceiling)).

fof(complete_claim_facts, axiom,
  (claim_presented
    & lean_kernel_trace
    & z3_trace
    & vampire_trace
    & e_trace
    & tlfl_classification_trace
    & nonclaim_guard_trace
    & proof_self_model
    & complete_claim_passport_input
    & missing_tlfl_classification_input)).

fof(tlfl_claim_passport_bundle, conjecture,
  (claim_passport
    & allowed_claim_ceiling
    & forbidden_jump_map
    & proof_state_certification
    & verdict_pass
    & verdict_fail
    & certified_ceiling
    & unadmitted_ceiling)).
