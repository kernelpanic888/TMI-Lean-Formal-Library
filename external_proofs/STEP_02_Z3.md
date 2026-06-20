# Step 02: Z3

Date: 2026-06-20

## Role

Z3 is the SMT witness in the canonical chain.

Its role is:

```text
check theorem mirrors and guard boundaries
at the release-boundary and self-model surfaces.
```

## Input Artifacts

- `olean_library_z3_0_1.smt2`
- `olean_internal_frequency_z3_0_1.smt2`
- `tlfl_proof_self_model_z3_0_1.smt2`
- `tlfl_self_model_proof_z3_0_1.smt2`

## Output Shape

Allowed output:

```text
unsat  = positive theorem mirror closed
sat    = guard/non-claim mirror remains open
```

## Current Observed Status

```text
release-boundary checks: pass
internal-frequency checks: pass
proof self-model checks: pass
self-model proof checks: pass
```

For the strict self-model proof file:

```text
unsat
sat
sat
sat
sat
sat
sat
```

## Permitted Contribution To The Chain

Z3 contributes:

```text
boundary and guard discipline
```

Z3 does not contribute:

- Lean-kernel formal status by itself;
- empirical truth;
- ontology.
