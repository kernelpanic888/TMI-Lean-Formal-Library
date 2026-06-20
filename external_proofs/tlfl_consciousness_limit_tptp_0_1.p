% TLFL consciousness-limit theorem bundle.
% Positive theorem bundle only; non-claim guards are checked in Z3.

fof(ax_limit_horizon, axiom,
  ((proof_self_model & bounded_prediction) => consciousness_limit_horizon)).

fof(ax_guarded_approximation, axiom,
  (consciousness_limit_horizon => guarded_consciousness_approximation)).

fof(ax_witnesses, axiom,
  (proof_self_model & bounded_prediction)).

fof(conj_guarded_limit_language, conjecture,
  (consciousness_limit_horizon & guarded_consciousness_approximation)).
