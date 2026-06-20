# TLFL 0.2 Claim Passport Release Gate

Status: formal release-candidate layer added.

This document records the promotion layer built on top of the claim-passport
review gate.

```text
ClaimPassportReviewGate
-> ClaimPassportReleaseGate
-> release-candidate surface
```

## Purpose

The release gate says that a review-ready claim-passport audit sheet has enough
public proof-status material to be treated as a TLFL 0.2 release-candidate
surface when it carries:

```text
review-ready gate
external mirror verification
synchronized public documentation
proof-state-certified status
TLFL proof-state-certified claim ceiling
forbidden-jump boundary
```

It does not change the claim into empirical validation.

## Lean Surfaces

```text
ClaimPassportReleaseGate
ClaimPassportReleaseReady
canonicalClaimPassportReleaseGate
```

## Theorem Surfaces

```text
review_gate_with_mirrors_gives_release_gate
claim_passport_release_gate_exists
release_gate_gives_review_gate
release_gate_is_review_ready
release_gate_records_external_mirror_verification
release_gate_records_public_docs_sync
release_gate_gives_certification_status
release_gate_gives_allowed_ceiling
release_gate_gives_forbidden_jump_map
release_gate_is_release_candidate_surface
canonical_release_gate_is_release_ready
```

## Non-Claim Guards

```text
release gate does not imply empirical truth
release gate does not imply physical validation
release gate does not imply consciousness
release gate does not imply empirical closure
```

## External Mirror

The release-gate boundary is mirrored in:

```text
external_proofs/tlfl_claim_passport_z3_0_1.smt2
external_proofs/tlfl_claim_passport_tptp_0_1.p
```

Expected Z3 shape for the full claim-passport mirror:

```text
positive theorem checks: 35 x unsat
non-claim guards: 22 x sat
```

Expected Vampire/E shape:

```text
SZS status Theorem
```

## Boundary

The release gate is a proof-status release-candidate surface. It is not
empirical truth, physical validation, consciousness, or empirical closure.
