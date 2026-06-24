# TLFL v0.3.0-i1-engineering-surface

Release type: source-first GitHub release with guarded public-surface artifacts.

Date: 2026-06-24

## Summary

`v0.3.0-i1-engineering-surface` publishes the next public TLFL/TMI-OS slice:
the И1 engineering surface for programming on formal logic.

Public formula:

```text
LLM/GPT/Codex -> Lean -> TLFL -> И1

ProgrammingOnMathematics :=
  Intent -> FormalLogic -> CanonicalRecord -> Passport -> GuardedAction
```

This release adds a runnable, guarded surface around the formal Lean/TLFL
library. It is not a new proof kernel and not a replacement for Lean. The И1
language is still read as `latest`; `v0.3.0-i1-engineering-surface` is the
GitHub release identifier for this public artifact slice.

## Main Additions

- `SelfThinkingUniverse` high-level bridge layers for time-as-memory,
  subjective slice time, block-universe scan, dual light tick, time-axis overlay,
  and projection-curvature/domain-shift vocabulary.
- `programs/tmi_os_mathematical_board/` as the first public runnable surface.
- `TMI_OS_MATHEMATICAL_BOARD.html` for the 2D mathematical board.
- `TMI_OS_3D_TIME_ARTIFACT.html` for the 3D time-sweep artifact.
- `TMI_OS_LIVE_DEMO.html` for writing a small И1 program on the fly:
  intent becomes canonical record, passport, guard, and guarded action.
- `I1_MINI_LANGUAGE.md` as the compact user-facing И1 command surface.
- `TMI_OS_API.json` as a static local API/contract surface.
- `TMI_OS_PROTECTED_MODEL_PAGE.html` and `TMI_OS_ADMIN.html` as local-only
  guarded control surfaces.
- `plugins/tmi-os-mathematical-board/` as the Codex plugin/export-ready surface.
- `exports/tmi_os_mathematical_board_public/` as the public export package.
- `docs/SURFACE_MAP_RU.md` and `docs/THEORY_LINKS.md` for readable surface
  mapping and source links.
- `docs/LEAN_COMMUNITY_ENTRY.md` for a Lean community-facing package entry
  point focused on Lake builds, imports, and claim boundaries.
- LinkedIn/Zenodo publication drafts with the 404 Root Jumper URL removed from
  copy-ready public text until that repository exists.

## What Changed In The Author Surface

The release makes the following author-facing model explicit:

```text
Input
-> И1
-> FormalLogic
-> CanonicalRecord
-> Passport
-> Guard
-> PublicArtifact
```

The board language records:

```text
point p := SelfModelPoint
domain D := ExternalDomain
block B := projection(D) inside p
slice s := current projection slice
tick τ := touch(p, s)
noise := ProjectionBreak -> Guard -> SelfCorrectionInside -> Reprojection
```

The 3D artifact exposes `NoisePassport` in the right panel:

```text
NoisePassport :=
  name: ProjectionNoise
  source: ProjectionBreak
  symptom: desync(intent, slice, trace, guard)
  route: Guard -> SelfCorrectionInside -> Reprojection
  status: internal correction signal
```

## Verification Status

The full proof-kernel pass was kept aligned with the canonical proof matrix:

```text
198 theorem targets
63 model boundaries
295 TPTP files
```

Recorded expected gates:

```text
lake build TMI
lake build OLean
lake env lean lean/TMI/Regression.lean
lake build TMI.SelfThinkingUniverse
make tptp-static
make intelligence-proof-matrix
make intelligence-z3
make external-atp-pair
make proof-kernel
```

Expected proof-lab result:

```text
Lean / TLFL: PASS
Z3: PASS
Vampire: PASS
E prover: PASS
proof-kernel: PASS
```

## Public Boundary

Allowed:

- formal Lean/TLFL proof-status;
- guarded public mathematical-board artifacts;
- local static И1 demo programs;
- proof-status passports;
- publication drafts after leak and claim-boundary review.

Not allowed:

- biological-life claims;
- legal-identity claims;
- consciousness proof claims;
- empirical physics proof claims;
- `Time = Memory`;
- `Time = speed_of_light`;
- publication of closed/private repository URLs as live public links.

## Release Assets

The GitHub release should contain:

- GitHub-generated source archives for tag `v0.3.0-i1-engineering-surface`;
- this release note;
- current `programs/tmi_os_mathematical_board/` surface;
- current `plugins/tmi-os-mathematical-board/` surface;
- current `exports/tmi_os_mathematical_board_public/` package.
