# TLFL 0.2 Claim Passport Proof Status

Status: first formal slice added.

This document records the initial `TLFL 0.2` direction:

```text
Claim
-> TLFL admission / classification
-> Lean + external proof traces
-> proof-state self-model
-> allowed claim ceiling
-> forbidden jump map
-> claim passport
```

## What Is New

The module `TMI.ClaimPassport` introduces a proof-status passport for a claim.
The passport does not say that a claim is empirically true. It says what proof
path admitted it, which evidence bundle supports it, which status ceiling is
allowed, and which jumps are forbidden.

## Main Lean Surfaces

```text
ClaimCeiling
ClaimObject
ClaimEvidenceBundle
ForbiddenJumpMap
ClaimPassport
ClaimPassportCertified
```

## Main Theorem Surfaces

```text
tlfl_proof_self_model_gives_claim_passport
claim_passport_gives_allowed_claim_ceiling
claim_passport_gives_forbidden_jump_map
claim_passport_projects_to_proof_state_self_model
claim_passport_projects_to_claim_classification
claim_passport_certification_passes
```

## Non-Claim Guards

```text
claim object alone does not imply claim passport
evidence bundle alone does not imply claim passport
claim passport does not imply empirical truth
claim passport does not imply physical validation
claim passport does not imply consciousness
claim passport does not imply empirical closure
```

## External Mirror

The selected release-boundary behavior is mirrored by:

```text
external_proofs/tlfl_claim_passport_z3_0_1.smt2
external_proofs/tlfl_claim_passport_tptp_0_1.p
```

Expected Z3 shape:

```text
positive theorem checks: unsat
non-claim guards: sat
```

Expected Vampire/E shape:

```text
SZS status Theorem
```

## Claim Boundary

This layer is a proof-status certification layer. It is not empirical
validation, not a physics proof, not a consciousness proof, and not empirical
closure.
