# TLFL v0.5.3-alpha — self-closed paradoxical-formula theorem

This focused alpha release adds one closed theorem to
`TMI.FormulaInterface` and one shared TPTP mirror for Vampire and E.

## Formal core

```text
Free(U)
∧ (∀ phi ∈ Phi, Full(phi,U) → Force(phi,U))
∧ (∀ phi ∈ Phi, Force(phi,U) → ¬Free(U))
→ ¬∃ phi ∈ Phi, Full(phi,U).
```

The theorem introduces no new model, structure, axiom or object-specific
definition. Every type, predicate, object and premise is bound by the theorem
declaration.

## Verification

- Lean 4.32.1: PASS.
- `#print axioms`: the proof depends on no axioms.
- Vampire: `SZS status Theorem`, refutation, `0.002 s`.
- E prover: `Proof found`, `SZS status Theorem`.

## Red boundary

The result is relative to the formula class `Phi` and three explicit premises.
It does not prove the existence of a limit object, physical free connectivity
of the Universe, or an absolute impossibility of every formalization.

The application to the Universe and the `trace → return` contract are
published as separate hypothesis and continuity layers, not as consequences
of the Lean theorem.

