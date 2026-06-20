% TLFL proof-chain self-model mirror.
% Chain: Vampire/Z3/E/TLFL.
% Positive theorem bundle for Vampire and E.

fof(chain_axiom, axiom,
  ((vampire_pass & z3_pass & e_pass & tlfl_classifies)
    => tlfl_proof_self_model)).

fof(boundary_map_axiom, axiom,
  (tlfl_proof_self_model => verification_boundary_map)).

fof(prover_compatibility_map_axiom, axiom,
  (tlfl_proof_self_model => prover_compatibility_map)).

fof(epistemic_status_map_axiom, axiom,
  (tlfl_proof_self_model => epistemic_status_map)).

fof(nonclaim_guard_map_axiom, axiom,
  (tlfl_proof_self_model => nonclaim_guard_map)).

fof(claim_classification_axiom, axiom,
  (tlfl_proof_self_model => claim_classification)).

fof(chain_facts, axiom,
  (vampire_pass & z3_pass & e_pass & tlfl_classifies)).

fof(tlfl_proof_self_model_bundle, conjecture,
  (tlfl_proof_self_model
    & verification_boundary_map
    & prover_compatibility_map
    & epistemic_status_map
    & nonclaim_guard_map
    & claim_classification)).
