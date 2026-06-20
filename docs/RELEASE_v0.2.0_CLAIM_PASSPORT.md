# TLFL v0.2.0-claim-passport

Release type: source-first GitHub release with proof package assets.

Date: 2026-06-20

## Summary

`v0.2.0-claim-passport` publishes the first TLFL 0.2 proof-status slice:
claim passports and proof-state certification.

The release adds a formal path from a claim object and evidence bundle to a
public proof-status surface:

```text
claim object
+ evidence bundle
+ TLFL classification
+ proof-state self-model
+ non-claim guard trace
-> claim passport
-> proof-state certification
-> claim-passport certificate
-> public certificate surface
-> audit sheet
-> review gate
-> release gate
-> release-candidate surface
```

This is a formal proof-status release. It does not claim empirical truth,
physical validation, consciousness, or empirical closure.

## Main Additions

- `TMI.ClaimPassport`
- `ClaimPassportVerdict`
- `ProofStateCertification`
- `ClaimPassportCertificate`
- `ClaimPassportPublicCertificateSurface`
- `ClaimPassportAuditSheet`
- `ClaimPassportReviewGate`
- `ClaimPassportReleaseGate`
- external Z3 mirror for claim-passport theorem and guard checks
- external Vampire/E theorem bundle for the positive claim-passport chain

## Canonical Public Boundary

The release uses the public TLFL proof-layer wording:

```text
TLFL + External Proof Layer {Z3, Vampire, E}
```

TLFL classifies proof status. Z3, Vampire, and E provide external proof traces
for selected release-boundary claims.

## Verification Commands

```bash
lake env lean lean/TMI/ClaimPassport.lean
lake env lean lean/TMI/Regression.lean
lake build TMI
lake build OLean
z3 external_proofs/tlfl_claim_passport_z3_0_1.smt2
vampire --mode casc --time_limit 10 external_proofs/tlfl_claim_passport_tptp_0_1.p
eprover --auto --cpu-limit=10 external_proofs/tlfl_claim_passport_tptp_0_1.p
```

Expected proof status:

```text
Lean ClaimPassport: pass
Lean Regression: pass
lake build TMI: pass
lake build OLean: pass
Z3 claim-passport mirror: theorem checks unsat, guard checks sat
Vampire claim-passport bundle: SZS status Theorem
E prover claim-passport bundle: SZS status Theorem
```

## Release Assets

The GitHub release should contain:

- GitHub-generated source archives for tag `v0.2.0-claim-passport`;
- `tlfl-v0.2.0-claim-passport-source-proof-package.zip`;
- `tlfl-v0.2.0-claim-passport-release-summary.pdf`;
- `tlfl-v0.2.0-claim-passport-checksums.sha256`.

## Claim Boundary

Allowed:

- formal proof-status certification;
- claim passport and public certificate surfaces;
- audit, review, and release gates;
- mirrored external proof checks for selected release-boundary claims.

Not allowed:

- empirical truth;
- physical validation;
- consciousness;
- empirical closure.

