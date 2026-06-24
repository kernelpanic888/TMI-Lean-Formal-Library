# Reservoir Readiness

This checklist records the intended package-registry path for TLFL. It is not
an automatic submission.

## Package Identity

```text
Repository: https://github.com/kernelpanic888/TMI-Lean-Formal-Library
Release: v0.3.1-lean-community-entry
Lake package id: tmi_lean_formal_library_0_1
License: Apache-2.0
Lean toolchain: leanprover/lean4:v4.31.0-rc1
```

The Lake package id is intentionally preserved as
`tmi_lean_formal_library_0_1` for compatibility with the existing package
history. Release tags carry the public version surface.

## Root Files

Required root files are present:

```text
lakefile.lean
lake-manifest.json
lean-toolchain
README.md
LICENSE
CITATION.cff
```

## Canonical Commands

```bash
lake build TMI
lake build OLean
lake env lean lean/TMI/Regression.lean
lake build TMI.SelfThinkingUniverse
```

## Community Review Boundary

The first request should be package/documentation feedback, not philosophical
endorsement:

```text
Please review this as a standalone Lean 4/Lake package:
imports, module boundaries, naming, build reproducibility, documentation.
```

Do not ask the community to accept:

```text
TMI as empirical physics
TMI-OS / И1 as a Lean theorem
visual artifacts as proofs
new-kernel claims
mathlib inclusion as-is
```

## Suggested Reservoir/Zulip Intro

```text
TLFL is a standalone Lean 4 package for proof-status interfaces, claim
passports, OLean boundary checks, and high-level bridge surfaces. It builds with
Lake and does not introduce a new kernel. I am looking for packaging and
documentation feedback before any broader submission.
```

