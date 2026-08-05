% Self-closed theorem of the paradoxical formula.
% Shared TFF mirror for Vampire and E.
%
% The conjecture is relative to the explicit premises below. It does not
% assert an absolute incompleteness theorem or the physical existence of U.

tff(formula_type, type, formula: $tType).
tff(object_type, type, object: $tType).

tff(phi_type, type, phi: formula > $o).
tff(full_type, type, full: (formula * object) > $o).
tff(free_type, type, free: object > $o).
tff(force_type, type, force: (formula * object) > $o).
tff(limit_object_type, type, u: object).

% U has free connectivity.
tff(free_limit_object, axiom,
  free(u)).

% A Phi-admissible formula that fully exhausts U forces U.
tff(fullness_implies_forcing, axiom,
  ! [F: formula] :
    ((phi(F) & full(F, u)) => force(F, u))).

% Forcing a Phi-admissible formula onto U excludes free connectivity.
tff(forcing_excludes_freedom, axiom,
  ! [F: formula] :
    ((phi(F) & force(F, u)) => ~ free(u))).

% Therefore no formula in Phi fully exhausts U.
tff(paradoxical_formula_self_closed, conjecture,
  ~ ? [F: formula] : (phi(F) & full(F, u))).

