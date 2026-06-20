# Getting Started

TMI-Lean Formal Library (TLFL) 0.1 is a Lean 4 library. It is not a fork of
Lean and not a new proof kernel.

TLFL is used as a proof-status meta-interface:

```text
Z3/Vampire/E produce proof traces.
TLFL classifies the proof state.
```

## Build

Run from the package root:

```bash
lake build TMI
lake build OLean
```

## Imports

Use the library through the canonical imports:

```lean
import TMI.Library
import OLean
import OLean.SelfCheck
import OLean.SelfCheckAsThinker
import TMI.ProofChainSelfModel
```

## Minimal Verdict Example

`OLean.SelfCheck` exposes a computable pass/fail boundary verdict:

```lean
#eval OLean.boundaryCheckVerdict OLean.completeBoundaryCheckInput
```

Expected result:

```text
OLean.CheckVerdict.pass
```

For a Lean-only incomplete check:

```lean
#eval OLean.boundaryCheckVerdict OLean.leanOnlyBoundaryCheckInput
```

Expected result:

```text
OLean.CheckVerdict.fail
```

`pass` means the release boundary is represented as complete:

```text
encoded in Lean
+ Lean-kernel checked
+ Lake build passed
+ Z3 passed
+ Vampire passed
+ E prover passed
+ no new kernel introduced
```

It does not mean empirical proof of TMI as a physical theory.

For the full public boundary, see:

```text
docs/CLAIM_BOUNDARY.md
```

## Thinker Check

The self-check can also be verified as a TMI thinker interface:

```lean
#check OLean.self_check_passes_thinker_test
#check OLean.self_check_is_mathematical_external_prover
```

This means the self-check has the formal thinker shape: input, internal model,
admissibility test, verdict, and recorded result. It does not turn the formal
check into empirical physical validation.

## Proof-Chain Self-Model

`TMI.ProofChainSelfModel` fixes the canonical `TLFL + Z3 + Vampire + E proof layer` chain as a
proof-state self-model. Z3, Vampire, and E provide external proof traces; TLFL
classifies those traces by proof path, verification boundary, prover
compatibility, and allowed epistemic status.

## Repository Profile

For GitHub description, topics, and short public taglines, see:

```text
docs/REPOSITORY_PROFILE.md
```
