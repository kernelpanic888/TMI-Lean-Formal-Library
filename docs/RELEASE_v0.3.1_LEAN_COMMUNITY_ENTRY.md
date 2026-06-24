# TLFL v0.3.1-lean-community-entry

Release type: technical documentation release for Lean package review.

Date: 2026-06-24

## Summary

`v0.3.1-lean-community-entry` prepares TLFL for a Lean community-facing review
path. This release does not submit anything automatically to Zulip, Reservoir,
or `leanprover-community.github.io`; it provides a clean technical entry point
for package/documentation review.

The intended audience is Lean users who want to answer:

```text
Can this repository be built as a Lean 4/Lake package?
What are the canonical imports?
What is the proof-status boundary?
What is explicitly not claimed?
```

## Main Additions

- `docs/LEAN_COMMUNITY_ENTRY.md` as the primary Lean-audience entry point.
- `docs/RESERVOIR_READINESS.md` as a short checklist for package-registry
  readiness.
- README, manifest, and citation metadata updated to point at the community
  entry layer.
- The Lake package name `tmi_lean_formal_library_0_1` is intentionally
  preserved as a historical package id for compatibility.

## Technical Entry Point

Community reviewers should start with:

```text
docs/LEAN_COMMUNITY_ENTRY.md
```

Strict Lean package review should focus on:

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

## Canonical Build

Run from the repository root:

```bash
lake build TMI
lake build OLean
lake env lean lean/TMI/Regression.lean
lake build TMI.SelfThinkingUniverse
```

Expected status for this release layer:

```text
Lean package builds through Lake.
OLean adapter builds through Lake.
Regression file checks through `lake env lean`.
SelfThinkingUniverse checks as a standalone module.
```

## Claim Boundary

Allowed:

- Lean/Lake package review;
- documentation review;
- canonical-import review;
- discussion of proof-status interfaces and bridge surfaces;
- later Reservoir/Zulip submission after explicit human approval.

Not allowed:

- automatic submission to external community channels;
- claims that TLFL is a new kernel;
- claims that TLFL replaces mathlib;
- claims of empirical physics validation, consciousness, biological identity,
  or legal identity;
- literal identity claims between time and memory, or between time and the
  speed-of-light constant.

## Community Route

Recommended route:

```text
GitHub release/tag
-> Lean package review
-> Reservoir readiness check
-> Zulip/GitHub discussion if desired
-> possible registry/community listing after explicit approval
```

This release intentionally keeps broader TMI-OS / И1 narrative material behind
claim-boundary documentation so the Lean community entry remains technical.
