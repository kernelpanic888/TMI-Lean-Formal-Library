# TMI-Lean Formal Library (TLFL) 0.1

TMI-Lean Formal Library (TLFL) 0.1 is a Lean 4 formal library for encoding the core
definitions, axioms, transition rules, event structures, records,
admissibility conditions, and proof targets of TMI.

This is not a fork of Lean and not a new programming language. It is a Lean 4
library whose modules are compiled by the ordinary Lean kernel.

## Canonical Import

```lean
import TMI.Library
```

## OLean Adapter

`OLean` is the working name for the connection interface between TMI and Lean.
It is a small Lean module that imports the TMI library and states the boundary:
TMI artifacts receive formal status only when they are checked by the Lean
kernel.

```lean
import OLean
import OLean.SelfCheck
import OLean.SelfCheckAsThinker
```

## TLFL + External Proof Layer {Z3, Vampire, E} Self-Model

TLFL is fixed here as a meta-interface of proof self-modeling. The canonical
chain is:

```text
TLFL + External Proof Layer {Z3, Vampire, E}
```

Z3, Vampire, and E provide external proof traces. TLFL classifies those traces
by admissible proof path, verification boundary, prover compatibility, and
allowed epistemic status. This builds a proof-state self-model, not empirical
physical validation.

## TLFL 0.2 Direction: Claim Passport

The first TLFL 0.2 slice adds `TMI.ClaimPassport`: a proof-status certification
surface that turns a claim, evidence bundle, TLFL classification, proof-state
self-model, allowed claim ceiling, and forbidden jump map into a claim passport.
It also adds a computable `ClaimPassportVerdict`: complete inputs return `pass`;
inputs missing TLFL classification return `fail`.
The certification-status layer maps complete, non-overclaiming requests to
`proofStateCertified`, missing-boundary requests to `unadmitted`, and forbidden
jump requests to `overclaimBlocked`.
`ClaimPassportCertificate` packages the certified passport, proof-state
certification, verdict, status, ceiling, and forbidden-jump map into one public
proof-status object.
`ClaimPassportPublicCertificateSurface` exposes that certificate as an
outward-facing proof-status surface for inspection without raising the claim
ceiling.
`ClaimPassportAuditSheet` then packages the public surface into a reader-facing
audit report: verdict, status, ceiling, forbidden jumps, and represented
external proof layer.

The passport certifies proof status only. It does not imply empirical truth,
physical validation, consciousness, or empirical closure.

## Build

```bash
lake env lean lean/TMI/Library.lean
lake env lean lean/OLean.lean
lake env lean lean/OLean/SelfCheck.lean
lake env lean lean/OLean/SelfCheckAsThinker.lean
lake build TMI
lake build OLean
```

## Pass / Fail Boundary Verdict

`OLean.SelfCheck` provides a computable pass/fail verdict:

```lean
#eval OLean.boundaryCheckVerdict OLean.completeBoundaryCheckInput
#eval OLean.boundaryCheckVerdict OLean.leanOnlyBoundaryCheckInput
```

Complete boundary verification returns `pass`; incomplete verification returns
`fail`.

## Thinker Check

`OLean.SelfCheckAsThinker` proves that the complete OLean self-check passes the
TMI thinker criteria: it receives a boundary input, builds an internal model,
tests admissibility, produces a verdict, and records the result.

It also lifts the checked self-model to a guarded mathematical external prover
interface. This remains a formal proof-interface claim, not empirical physical
validation.

## GitHub Publication Text

A copy-ready bilingual repository/release announcement is available in
[`docs/GITHUB_PUBLICATION_TEXT.md`](docs/GITHUB_PUBLICATION_TEXT.md).

## Russian Note

TMI-Lean 0.1 -- formalnaya biblioteka interfeysno-sobytiynoy teorii dlya
Lean 4. `OLean` -- rabochee nazvanie interfeysa podklyucheniya TMI k Lean:
on ne zamenyaet Lean, a proveryaetsya i kompiliruyetsya cherez yadro Lean.

## Library Layout

```text
lean/TMI/Core.lean
lean/TMI/PicT.lean
lean/TMI/FormulaInterface.lean
lean/TMI/BoundaryEvent.lean
lean/TMI/Bridge.lean
lean/TMI/ProofStatusClassification.lean
lean/TMI/ProofChainSelfModel.lean
lean/TMI/ClaimPassport.lean
lean/TMI/Branches/MD.lean
lean/TMI/Branches/QC.lean
lean/TMI/Branches/QG.lean
lean/TMI/Branches/LIFE.lean
lean/TMI/Branches/OPS.lean
lean/TMI/Library.lean
lean/OLean.lean
lean/OLean/Smoke.lean
lean/OLean/SelfCheck.lean
lean/OLean/SelfCheckAsThinker.lean
docs/GETTING_STARTED.md
docs/API_REFERENCE.md
docs/EXTERNAL_PROOFS.md
docs/GLOSSARY.md
```
