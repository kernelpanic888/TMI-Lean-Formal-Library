# LayerBridge Publication Passport

**Repository:** `kernelpanic888/TMI-Lean-Formal-Library`
**Layer:** TLFL formal library + guarded experiment boundary
**Update type:** public proof-surface clarification
**Date:** 2026-07-08

---

## What Changed

This update adds a small Lean-checked boundary module:

```text
lean/LayerBridge.lean
```

It records two public bridge directions:

```text
ExperimentSpace --PromotionBridge--> TLFLModule
TLFLModule      --ProjectionBridge--> ExperimentSpace
```

## Why It Matters

The project needs a visible rule for moving work across layers:

- experiments may be tested quickly;
- production modules must stay proof-bounded;
- read-only projection is allowed;
- ownership transfer is not allowed;
- a promoted production module must not contain `sorry`.

The bridge makes that rule visible without publishing private operator notes,
local scratch state, build cache, or payment/business claims.

## Lean Surface

`LayerBridge.lean` introduces:

- `SystemLayer`
- `ExperimentSpace`
- `TLFLModule`
- `PromotionBridge`
- `ProjectionBridge`
- `LayerBoundary`
- `PromotionChecklist`

The module does not introduce new axioms. It imports the existing TLFL/TMI
foundation and records the bridge as data, propositions, and small theorems.

## How To Verify

```bash
lake build LayerBridge TMI OLean
```

Expected result:

```text
Build completed successfully
```

## Claim Boundary

This update claims only:

- the bridge API compiles locally;
- the promotion/projection boundary is documented;
- the README points readers to the bridge passport.

This update does not claim:

- autonomous execution;
- certified production operation;
- payment, sponsorship, or business approval;
- empirical closure;
- external theorem-prover certification for future promoted modules.

## Clean Public Set

```text
.gitignore
README.md
lakefile.lean
docs/LAYER_BRIDGE_PUBLICATION_PASSPORT.md
lean/LayerBridge.lean
```

Private/local surfaces must stay out of the commit:

```text
.claude/
.lake/
_local/
```

## Next Step

Run the Lean build, review the clean diff, then publish only after an explicit
human gate.
