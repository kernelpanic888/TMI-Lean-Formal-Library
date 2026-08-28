% RTI-01 external first-order mirror.
% Mirrors only the Lean theorem `future_reading_cannot_be_both`.
%
% The fixed function symbol `comparison` represents one explicit comparison
% map.  All four Lean hypotheses remain inside the conjecture antecedent; they
% are not asserted as global physical spacetime axioms.  The conclusion says
% that a nonempty future sector cannot be both wholly future-preserved and
% wholly past-read when the target future and past predicates are disjoint.

fof(rti_01_future_reading_cannot_be_both, conjecture,
  (((? [D] : future(D))
    & (! [D] : (future(D) => future(comparison(D))))
    & (! [D] : (future(D) => past(comparison(D))))
    & (! [D] : ~(future(D) & past(D))))
    => $false)).
