# Lean Community Entry

This document is the community-facing entry point for Lean users.

TLFL is a standalone Lean 4 package. It is not a fork of Lean, not a new proof
kernel, and not a proposal to merge this theory into mathlib as-is.

The right first audience is the Lean package community:

- build and import review;
- Lake packaging review;
- documentation review;
- possible Reservoir indexing after the public repository is ready;
- possible Zulip/GitHub discussion about module boundaries and style.

## Repository

```text
https://github.com/kernelpanic888/TMI-Lean-Formal-Library
```

Current release tag:

```text
v0.3.1-lean-community-entry
```

## What This Package Provides

TLFL encodes proof-status and bridge-surface vocabulary for TMI-style interface
mathematics.

Technically, the package provides:

- Lean modules under `lean/TMI/`;
- the `OLean` adapter layer under `lean/OLean/`;
- claim-passport and proof-status certification surfaces;
- a `SelfThinkingUniverse` high-level formal sketch layer;
- regression and build checks through Lake;
- external proof-status mirrors for selected proof-lab artifacts.

The public TMI-OS / И1 board is included as a guarded artifact surface, not as
part of the Lean kernel.

The Lake package id remains `tmi_lean_formal_library_0_1` for compatibility
with the existing package history. Public versioning is carried by release tags.

## Canonical Imports

```lean
import TMI.Library
import TMI.SelfThinkingUniverse
import TMI.ClaimPassport
import TMI.ProofChainSelfModel
import OLean
import OLean.SelfCheck
import OLean.SelfCheckAsThinker
```

## Build Commands

Run from the repository root:

```bash
lake build TMI
lake build OLean
lake env lean lean/TMI/Regression.lean
lake build TMI.SelfThinkingUniverse
```

Known checked release status:

```text
lake build TMI: PASS
lake build OLean: PASS
lean/TMI/Regression.lean: PASS
lake build TMI.SelfThinkingUniverse: PASS
```

The wider proof-lab gate for the synchronized proof package is:

```text
198 theorem targets
63 model boundaries
295 TPTP files
Z3 / Vampire / E: PASS in the checked proof-lab surface
```

## Claim Boundary

Allowed claims:

- Lean package builds through the ordinary Lean 4 kernel;
- the stated modules compile through Lake;
- proof-status surfaces are represented as Lean definitions/theorems;
- external prover gates are proof-status mirrors, not empirical validation.

Not claimed:

- TLFL is not a new Lean kernel;
- TLFL is not a replacement for mathlib;
- TMI-OS / И1 is not a theorem of consciousness, biology, legal identity, or
  empirical physics;
- visual board artifacts are not proofs by themselves;
- literal identities between time and memory, or between time and the
  speed-of-light constant, are not asserted.

## Community Path

Recommended path:

```text
1. Keep the GitHub repository public and reproducible.
2. Keep root Lake files visible: lakefile.lean, lake-manifest.json, lean-toolchain.
3. Keep Apache-2.0 license and CITATION.cff visible.
4. Ask for Lean package/documentation feedback first.
5. If packaging is accepted, submit/index through the Lean package registry path.
6. Keep broader philosophical material behind claim-boundary documentation.
```

## Suggested Short Introduction

```text
TLFL is a standalone Lean 4 package for experimenting with proof-status
interfaces, claim passports, OLean boundary checks, and high-level bridge
surfaces for interface mathematics. It builds with Lake and does not introduce a
new kernel. I am looking for Lean packaging and documentation feedback first.
```

## Notes For Reviewers

The package has an author-facing public surface (`programs/`,
`plugins/`, `exports/`) in addition to Lean source. For a strict Lean package
review, start with:

```text
lean/
lakefile.lean
lake-manifest.json
lean-toolchain
README.md
docs/CLAIM_BOUNDARY.md
docs/REPRODUCIBILITY.md
docs/LEAN_COMMUNITY_ENTRY.md
docs/RESERVOIR_READINESS.md
```
