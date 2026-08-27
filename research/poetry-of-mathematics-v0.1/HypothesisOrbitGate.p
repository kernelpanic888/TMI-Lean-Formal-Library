% PM-01 Hypothesis Orbit Geometry: external first-order mirror
% TPTP FOF syntax; intended for Vampire and E.
%
% Claim boundary:
% - this mirrors the propositional gate consequences of the Lean model;
% - it does not encode real arithmetic, Fisher--Rao geometry, or the Lean
%   elaborator/kernel;
% - success is an independent proof of this FOL bundle, not a proof that the
%   TPTP file is mechanically equivalent to PoetryOfMathematics.lean.

fof(rotation_is_interpretation, axiom,
  ! [Before, After, DeltaTheta] :
    ( rotation(Before, After, DeltaTheta)
   => interpretation_move(Before, After) )).

fof(interpretation_is_admissible, axiom,
  ! [Before, After] :
    ( interpretation_move(Before, After)
   => admissible_move(Before, After) )).

fof(interpretation_preserves_radius, axiom,
  ! [Before, After] :
    ( interpretation_move(Before, After)
   => same_radius(Before, After) )).

fof(interpretation_preserves_status, axiom,
  ! [Before, After] :
    ( interpretation_move(Before, After)
   => same_fact_status(Before, After) )).

fof(inward_requires_independent_verification, axiom,
  ! [Before, After] :
    ( ( admissible_move(Before, After)
      & inward_radial_move(Before, After) )
   => independently_verified(subject(Before)) )).

fof(promotion_requires_independent_verification, axiom,
  ! [Before, After] :
    ( ( admissible_move(Before, After)
      & promotes_hypothesis_to_fact(Before, After) )
   => independently_verified(subject(Before)) )).

fof(hypothesis_orbit_gate_bundle, conjecture,
    ( ! [Before, After, DeltaTheta] :
        ( rotation(Before, After, DeltaTheta)
       => ( admissible_move(Before, After)
          & same_radius(Before, After)
          & same_fact_status(Before, After) ) ) )
  & ( ! [Before, After] :
        ( ( admissible_move(Before, After)
          & inward_radial_move(Before, After) )
       => independently_verified(subject(Before)) ) )
  & ( ! [Before, After] :
        ( ( admissible_move(Before, After)
          & promotes_hypothesis_to_fact(Before, After) )
       => independently_verified(subject(Before)) ) )
  & ( ! [Before, After] :
        ( ( admissible_move(Before, After)
          & ~ independently_verified(subject(Before)) )
       => ( ~ inward_radial_move(Before, After)
          & ~ promotes_hypothesis_to_fact(Before, After) ) ) ) ).
