# Step 01: Vampire

Date: 2026-06-20

## Role

Vampire is the first ATP witness in the canonical chain.

Its role is:

```text
given a positive theorem bundle,
produce an ATP theorem witness.
```

## Input Artifacts

- `olean_library_tptp_0_1.p`
- `olean_internal_frequency_tptp_0_1.p`
- `tlfl_proof_self_model_tptp_0_1.p`
- `tlfl_self_model_proof_tptp_0_1.p`

## Output Shape

Allowed output:

```text
SZS status Theorem
```

This output is a theorem witness for the mirrored first-order bundle. It is
not a Lean-kernel judgment and not an empirical claim.

## Current Observed Status

```text
olean_library_tptp_0_1.p: SZS status Theorem
olean_internal_frequency_tptp_0_1.p: SZS status Theorem
tlfl_proof_self_model_tptp_0_1.p: SZS status Theorem
tlfl_self_model_proof_tptp_0_1.p: SZS status Theorem
```

## Permitted Contribution To The Chain

Vampire contributes:

```text
positive ATP theorem confirmation
```

Vampire does not contribute:

- claim classification;
- formal Lean status by itself;
- empirical validation.
