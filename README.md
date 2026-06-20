# TMI-Lean Formal Library (TLFL) 0.1

**Formal Library for Interface-Event Theory in Lean 4**

Author: **Salkutsan Aleksey**

ORCID: [0009-0006-8717-0492](https://orcid.org/0009-0006-8717-0492)

Zenodo DOI: [10.5281/zenodo.20773095](https://doi.org/10.5281/zenodo.20773095)

TLFL is a Lean 4 formal library for encoding the core vocabulary of TMI:
interfaces, events, admissible transitions, records, boundaries, guarded
branches, proof status, and proof-chain self-models.

It is not a fork of Lean. It is not a new proof kernel. It is a source-first
Lean library compiled by the ordinary Lean kernel.

## Core Idea

TLFL treats proof work as an interface process:

```text
claim
-> encoding boundary
-> Lean kernel check
-> external prover traces
-> TLFL classification
-> proof-state self-model
```

The canonical chain is:

```text
Vampire/Z3/E/TLFL
```

Vampire, Z3, and E provide external proof traces. TLFL stands last because it
classifies those traces by admissible proof path, verification boundary, prover
compatibility, non-claim guards, and allowed epistemic status.

In the strong meaning used here:

```text
TLFL = meta-interface of proof self-modeling
```

## What This Repository Contains

```text
lean/TMI/Core.lean
lean/TMI/PicT.lean
lean/TMI/FormulaInterface.lean
lean/TMI/BoundaryEvent.lean
lean/TMI/Bridge.lean
lean/TMI/ProofStatusClassification.lean
lean/TMI/ProofChainSelfModel.lean
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
external_proofs/
docs/
```

## Canonical Imports

```lean
import TMI.Library
import OLean
import OLean.SelfCheck
import OLean.SelfCheckAsThinker
import TMI.ProofStatusClassification
import TMI.ProofChainSelfModel
```

## OLean

`OLean` is the working name for the connection interface between TMI and Lean.
It states the boundary:

```text
TMI artifact
-> OLean encoding interface
-> Lean object
-> Lean kernel check
-> formal Lean status
```

`OLean` does not replace Lean. It is compiled through Lean.

## Pass / Fail Boundary Verdict

`OLean.SelfCheck` exposes a computable boundary verdict:

```lean
#eval OLean.boundaryCheckVerdict OLean.completeBoundaryCheckInput
#eval OLean.boundaryCheckVerdict OLean.leanOnlyBoundaryCheckInput
```

The complete boundary check returns:

```text
OLean.CheckVerdict.pass
```

An incomplete Lean-only boundary check returns:

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

It does not mean empirical validation of TMI as a physical theory.

## Internal Frequency Self-Check

TLFL includes an internal interface-frequency self-check. It reuses the
existing light-gradient numbers only as a normalized verification scale:

```text
G0 = 428
G1 = 480
G2 = 545
G3 = 631
G4 = 749
```

Complete `Lean + Z3 + Vampire + E` boundary verification reaches `G4 = 749`.
This is a formal verification-frequency score, not a physical optics claim.

## Thinker Check

`OLean.SelfCheckAsThinker` verifies that the complete OLean self-check has the
formal thinker shape:

```text
input
-> internal model
-> admissibility test
-> verdict
-> recorded result
```

This is why TLFL can act as a mathematical external proof-interface: it can
state what has passed, what has failed, which boundary was used, and which
claim status is allowed.

## Build

Run from the repository root:

```bash
lake build TMI
lake build OLean
lake env lean lean/TMI/Library.lean
lake env lean lean/OLean.lean
lake env lean lean/OLean/SelfCheck.lean
lake env lean lean/OLean/SelfCheckAsThinker.lean
lake env lean lean/TMI/ProofChainSelfModel.lean
```

## External Proof Checks

```bash
z3 external_proofs/olean_library_z3_0_1.smt2
z3 external_proofs/olean_internal_frequency_z3_0_1.smt2
z3 external_proofs/tlfl_proof_self_model_z3_0_1.smt2

vampire --mode casc --time_limit 10 external_proofs/olean_library_tptp_0_1.p
vampire --mode casc --time_limit 10 external_proofs/olean_internal_frequency_tptp_0_1.p
vampire --mode casc --time_limit 10 external_proofs/tlfl_proof_self_model_tptp_0_1.p

eprover --auto --cpu-limit=10 external_proofs/olean_library_tptp_0_1.p
eprover --auto --cpu-limit=10 external_proofs/olean_internal_frequency_tptp_0_1.p
eprover --auto --cpu-limit=10 external_proofs/tlfl_proof_self_model_tptp_0_1.p
```

Expected status:

```text
Z3 theorem checks: unsat
Z3 guard checks: sat
Vampire/E: SZS status Theorem
```

## Claim Boundary

This repository claims:

```text
Lean-compilable formal library.
OLean boundary interface.
Computable pass/fail release-boundary verdict.
External proof mirrors for selected boundary claims.
Proof-chain self-model for Vampire/Z3/E/TLFL.
```

This repository does not claim:

```text
full empirical proof of TMI as physics;
replacement of Lean, Z3, Vampire, or E;
that proof self-modeling is consciousness;
that internal frequency is physical light emission;
that guarded branches are already empirical physical laws.
```

See [docs/CLAIM_BOUNDARY.md](docs/CLAIM_BOUNDARY.md).

## License

Copyright 2026 Salkutsan Aleksey.

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE).

## Documentation

- [Getting Started](docs/GETTING_STARTED.md)
- [API Reference](docs/API_REFERENCE.md)
- [OLean Interface](docs/OLean_INTERFACE.md)
- [External Proofs](docs/EXTERNAL_PROOFS.md)
- [Claim Boundary](docs/CLAIM_BOUNDARY.md)
- [Glossary](docs/GLOSSARY.md)

## Russian Note

**TMI-Lean Formal Library (TLFL) 0.1** -- формальная библиотека для Lean 4.

TLFL не заменяет Lean и не является новым ядром доказательства. Это
мета-интерфейс доказательного состояния: он классифицирует утверждения по
допустимому пути доказательства, границе проверки, совместимости с
доказателями и разрешенному эпистемическому статусу.

Коротко:

```text
Vampire/Z3/E дают следы проверки.
TLFL строит самомодель доказательного состояния.
```

## Citation

Use the metadata in [CITATION.cff](CITATION.cff).
