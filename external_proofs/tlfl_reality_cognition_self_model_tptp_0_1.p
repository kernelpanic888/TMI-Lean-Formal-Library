% TLFL guarded reality-cognition self-model mirror.
% Positive theorem bundle only.

fof(reality_cognition_self_model_axiom, axiom,
  ((external_reality_trace
    & internal_tlfl_interface_passage
    & thinker_mediation
    & tlfl_classification)
    => proof_state_self_model)).

fof(reality_cognition_guarded_axiom, axiom,
  (proof_state_self_model => guarded_reality_cognition)).

fof(reality_cognition_public_projection_axiom, axiom,
  (guarded_reality_cognition => public_self_projection)).

fof(reality_cognition_chain_facts, axiom,
  (external_reality_trace
   & internal_tlfl_interface_passage
   & thinker_mediation
   & tlfl_classification)).

fof(reality_cognition_chain_conjecture, conjecture,
  (guarded_reality_cognition & public_self_projection)).
