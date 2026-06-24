# TLFL Library Passport

This is the short passport for the whole Lean package.

It is written for Lean community review: build surface first, claim boundary
first, no overclaim.

## Identity

```text
Name: TMI-Lean Formal Library (TLFL)
Repository: https://github.com/kernelpanic888/TMI-Lean-Formal-Library
Release line: v0.3.1-lean-community-entry
Lake package id: tmi_lean_formal_library_0_1
License: Apache-2.0
Lean toolchain: leanprover/lean4:v4.31.0-rc1
```

The Lake package id is historical and intentionally preserved for compatibility.
Public versioning is carried by Git tags and release notes.

## Purpose

```text
TLFL :=
  Lean4Package
  + TMI formal vocabulary
  + OLean boundary adapter
  + claim-passport/proof-status surfaces
  + high-level bridge sketches
  + external proof-status mirrors
```

Human reading:

```text
TLFL is a Lean 4 library for representing proof-status structures,
interface-mathematics vocabulary, claim boundaries, and bridge surfaces.
It is not a new proof kernel and not a replacement for mathlib.
```

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

Minimal reviewer entry:

```lean
import TMI.Library
```

## Build Commands

Run from the repository root:

```bash
lake build TMI
lake build OLean
lake env lean lean/TMI/Regression.lean
lake build TMI.SelfThinkingUniverse
```

Current checked status for this public surface:

```text
lake build TMI: PASS
lake build OLean: PASS
lean/TMI/Regression.lean: PASS
lake build TMI.SelfThinkingUniverse: PASS
```

## Proof-Status Matrix

The synchronized proof-lab surface reports:

```text
198 theorem targets
63 model boundaries
295 TPTP files
Z3 / Vampire / E gates: PASS in the checked proof-lab surface
```

This is a proof-status and package-status statement. It is not an empirical
physics validation statement.

## What The Package Claims

```text
Claimed:
  Lean modules compile through the ordinary Lean 4 kernel.
  OLean states a boundary adapter layer.
  Claim passports record proof-status boundaries.
  High-level bridge sketches are represented as Lean structures/definitions/theorems.
  External prover artifacts act as proof-status mirrors for the checked surface.
```

## What The Package Does Not Claim

```text
NotClaimed:
  not a new Lean kernel
  not a replacement for mathlib
  not a theorem of biological life
  not a proof of consciousness
  not a legal-identity claim
  not empirical physics closure
  not a proof that visual artifacts are mathematical proofs by themselves
  not a literal identity between time and memory
  not a literal identity between time and the speed-of-light constant
```

## Community Review Request

```text
Please review this as a standalone Lean 4/Lake package:
  imports,
  module boundaries,
  naming,
  build reproducibility,
  documentation,
  Reservoir readiness.
```

The first requested review is technical packaging feedback, not philosophical
endorsement.

## Public Surfaces

```text
Lean package:
  lean/
  lakefile.lean
  lake-manifest.json
  lean-toolchain

Community entry:
  docs/LEAN_COMMUNITY_ENTRY.md
  docs/LEAN_ZULIP_MWE.md
  docs/RESERVOIR_READINESS.md
  docs/AUTHOR_LEAN_COMMUNITY_ENTRY_RU.md

Minimal working example:
  examples/lean/TLFL_MWE.lean

Standalone canonical passport:
  examples/lean/TLFL_CANONICAL_PASSPORT_STANDALONE.lean

Comparator challenge / solution:
  examples/lean/TLFL_CANONICAL_PASSPORT_CHALLENGE.lean
  examples/lean/TLFL_CANONICAL_PASSPORT_SOLUTION.lean

Experiment sandbox:
  https://github.com/kernelpanic888/TMI-OS-Experiment
```

The experiment sandbox is separate from the TLFL kernel package. It exists for
passport-gated deployment slices, installer checks, and local Lean / Vampire /
E smoke runs.

## Passport Formula

```text
TLFLLibraryPassport :=
  public_repository
  ∧ apache_2_license
  ∧ lake_package
  ∧ canonical_import
  ∧ reproducible_build_commands
  ∧ proof_status_boundary
  ∧ external_prover_status_surface
  ∧ no_overclaim
```

## One-Sentence Introduction

```text
TLFL is a standalone Lean 4 package for proof-status interfaces, claim
passports, OLean boundary checks, and high-level bridge surfaces; it builds
with Lake and asks first for Lean packaging and documentation review.
```
