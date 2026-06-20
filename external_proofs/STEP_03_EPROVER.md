# Step 03: E Prover

Date: 2026-06-20

## Role

E prover is the second ATP witness in the canonical chain.

Its role is:

```text
cross-check the positive theorem bundle independently
from Vampire.
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

This is an ATP cross-check witness. It supports theorem-bundle robustness
across ATP engines, but it is still not a Lean-kernel status and not an
empirical result.

## Current Observed Status

```text
olean_library_tptp_0_1.p: SZS status Theorem
olean_internal_frequency_tptp_0_1.p: SZS status Theorem
tlfl_proof_self_model_tptp_0_1.p: SZS status Theorem
tlfl_self_model_proof_tptp_0_1.p: SZS status Theorem
```

## Permitted Contribution To The Chain

E prover contributes:

```text
independent ATP theorem confirmation
```

E prover does not contribute:

- claim classification;
- empirical validation;
- replacement of the Lean kernel.
