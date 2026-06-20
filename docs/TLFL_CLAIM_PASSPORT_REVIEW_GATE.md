# TLFL 0.2 Claim Passport Review Gate

Status: formal review-gate layer added.

This document records the review-entry layer built on top of the public
claim-passport audit sheet.

```text
ClaimPassportAuditSheet
-> ClaimPassportReviewGate
-> review-ready surface
```

## Purpose

The review gate says that a claim-passport audit sheet is ready to enter TLFL
review when it carries:

```text
public audit surface
represented external proof layer
proof-state-certified status
TLFL proof-state-certified claim ceiling
forbidden-jump boundary
```

It does not change the claim into empirical validation.

## Lean Surfaces

```text
ClaimPassportReviewGate
ClaimPassportReviewReady
canonicalClaimPassportReviewGate
```

## Theorem Surfaces

```text
audit_sheet_with_certified_status_gives_review_gate
claim_passport_review_gate_exists
review_gate_gives_audit_sheet
review_gate_gives_public_audit_surface
review_gate_records_external_proof_layer
review_gate_gives_certification_status
review_gate_gives_allowed_ceiling
review_gate_gives_forbidden_jump_map
review_gate_is_review_ready_surface
canonical_review_gate_is_review_ready
```

## Non-Claim Guards

```text
review gate does not imply empirical truth
review gate does not imply physical validation
review gate does not imply consciousness
review gate does not imply empirical closure
```

## External Mirror

The review-gate boundary is mirrored in:

```text
external_proofs/tlfl_claim_passport_z3_0_1.smt2
external_proofs/tlfl_claim_passport_tptp_0_1.p
```

Expected Z3 shape for the full claim-passport mirror:

```text
positive theorem checks: 27 x unsat
non-claim guards: 18 x sat
```

Expected Vampire/E shape:

```text
SZS status Theorem
```

## Boundary

The review gate is a proof-status review-entry surface. It is not empirical
truth, physical validation, consciousness, or empirical closure.
