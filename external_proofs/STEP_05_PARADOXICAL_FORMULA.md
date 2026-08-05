# PF-01 proof audit

Date: 2026-08-05

## Lean kernel

Command:

```text
leanprover/lean4:v4.32.1 lean ParadoxicalFormulaTheorem.lean
```

Observed result:

```text
'TMI.FormulaInterface.T_paradoxical_formula_self_closed'
does not depend on any axioms
```

Status: PASS.

## Vampire

Command:

```text
vampire --mode casc --time_limit 10 paradoxical_formula_self_closed_tptp.p
```

Observed result:

```text
Refutation found
SZS status Theorem
Termination reason: Refutation
Time elapsed: 0.002 s
```

Status: PASS.

## E prover

Command:

```text
eprover --auto --cpu-limit=10 paradoxical_formula_self_closed_tptp.p
```

Observed result:

```text
Proof found
SZS status Theorem
```

Status: PASS.

## Scope of the certificate

The three systems verify the logical consequence from the stated premises.
They do not verify the premises as physical facts and do not prove that the
physical Universe instantiates the theorem.

