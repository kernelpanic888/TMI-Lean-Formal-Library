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
-> claim passport certificate
-> public certificate surface
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
ClaimPassportVerdict
ClaimCertificationStatus
ClaimPassportInput
ClaimCertificationRequest
ProofStateCertification
ClaimPassport
ClaimPassportCertified
ClaimPassportCertificate
canonicalClaimPassportCertificate
```

## Main Theorem Surfaces

```text
tlfl_proof_self_model_gives_claim_passport
claim_passport_gives_allowed_claim_ceiling
claim_passport_gives_forbidden_jump_map
claim_passport_projects_to_proof_state_self_model
claim_passport_projects_to_claim_classification
claim_passport_certification_passes
complete_claim_passport_input_verdict_is_pass
complete_claim_passport_input_ceiling_is_certified
missing_tlfl_classification_claim_passport_input_verdict_is_fail
missing_tlfl_classification_claim_passport_input_ceiling_is_unadmitted
claim_passport_pass_gives_certified_ceiling
claim_passport_fail_gives_unadmitted_ceiling
certified_proof_state_request_status_is_proof_state_certified
missing_classification_request_status_is_unadmitted
empirical_closure_overclaim_request_status_is_blocked
forbidden_jump_request_gives_overclaim_blocked
pass_without_forbidden_jump_gives_proof_state_certified
fail_without_forbidden_jump_gives_unadmitted
tlfl_claim_passport_certificate_exists
claim_passport_certificate_gives_certified_passport
claim_passport_certificate_gives_verdict
claim_passport_certificate_gives_certification_status
claim_passport_certificate_gives_allowed_ceiling
claim_passport_certificate_gives_forbidden_jump_map
canonical_claim_passport_certificate_verdict_is_pass
canonical_claim_passport_certificate_status_is_proof_state_certified
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
positive theorem checks: 13 x unsat
non-claim guards: 6 x sat
```

Expected Vampire/E shape:

```text
SZS status Theorem
```

## Claim Boundary

This layer is a proof-status certification layer. It is not empirical
validation, not a physics proof, not a consciousness proof, and not empirical
closure.
