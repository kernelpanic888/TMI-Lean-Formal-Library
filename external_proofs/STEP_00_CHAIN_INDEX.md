# TLFL + Z3 + Vampire + E proof layer Step Artifacts

Date: 2026-06-20

This index splits the canonical chain

```text
TLFL + Z3 + Vampire + E proof layer
```

into explicit step artifacts.

## Canonical Display Order

1. `STEP_04_TLFL.md`
2. `STEP_02_Z3.md`
3. `STEP_01_VAMPIRE.md`
4. `STEP_03_EPROVER.md`

## Purpose

The chain-level theorem bundle is useful, but it compresses several different
roles into one surface. These step artifacts make the chain inspectable at
row level:

- what each prover receives;
- what each prover returns;
- what status that return is allowed to support;
- where the non-claim boundary remains in force.

## Canonical Reading

```text
TLFL -> proof-status self-model and claim classification
Z3 -> SMT boundary/guard witness
Vampire -> ATP theorem witness
E prover -> ATP cross-check witness
```

## Boundary

These artifacts document proof-state structure only. They do not claim:

- empirical truth;
- physical validation;
- consciousness;
- empirical closure.
