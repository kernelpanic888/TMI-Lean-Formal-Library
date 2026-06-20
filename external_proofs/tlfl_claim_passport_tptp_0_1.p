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

fof(complete_claim_facts, axiom,
  (claim_presented
    & lean_kernel_trace
    & z3_trace
    & vampire_trace
    & e_trace
    & tlfl_classification_trace
    & nonclaim_guard_trace
    & proof_self_model)).

fof(tlfl_claim_passport_bundle, conjecture,
  (claim_passport
    & allowed_claim_ceiling
    & forbidden_jump_map
    & proof_state_certification)).
