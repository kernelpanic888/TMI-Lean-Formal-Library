% OLean-admitted proof projection to TLFL self-model.
% Positive theorem bundle only.

fof(admitted_projection_axiom, axiom,
  ((external_projection
    & olean_admitted
    & tlfl_classified)
    => admitted_self_model)).

fof(admitted_self_model_axiom, axiom,
  (admitted_self_model
    => guarded_mathematical_intelligence)).

fof(admitted_projection_facts, axiom,
  (external_projection
   & olean_admitted
   & tlfl_classified)).

fof(admitted_projection_conjecture, conjecture,
  guarded_mathematical_intelligence).
