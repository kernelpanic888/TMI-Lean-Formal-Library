% RTI-02 first-order mirror: a wholly future-preserving active branch family
% cannot also contain an active branch that reads every future as past.
% This mirrors one Lean logical boundary only. It is not a quantum model and
% does not prove physical reversal of time.

fof(rti_02_quantum_reversal_requires_explicit_branch, conjecture,
  (
    (? [D] : future(D))
    & (! [B,D] :
        ((active(B) & future(D)) => future(comparison(B,D))))
    & (? [B] :
        (active(B)
        & (! [D] : (future(D) => past(comparison(B,D))))))
    & (! [D] : ~(future(D) & past(D)))
  ) => $false
  ).
