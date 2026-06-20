# External Proof Layer

Date: 2026-06-20

Scope:

```text
OLean + TMI.Library release boundary
```

This external proof layer mirrors only the public release-boundary claims of
TMI-Lean Formal Library (TLFL) 0.1. It does not mirror the full Lean library.

## Files

| File | Role |
|---|---|
| `olean_library_z3_0_1.smt2` | SMT-LIB2 theorem and guard checks |
| `olean_library_tptp_0_1.p` | TPTP/TFF theorem bundle for Vampire and E |
| `olean_internal_frequency_z3_0_1.smt2` | SMT-LIB2 internal-frequency self-check |
| `olean_internal_frequency_tptp_0_1.p` | TPTP/TFF internal-frequency theorem bundle |
| `tlfl_proof_self_model_z3_0_1.smt2` | SMT-LIB2 proof-chain self-model checks |
| `tlfl_proof_self_model_tptp_0_1.p` | TPTP/TFF proof-chain self-model theorem bundle |
| `CHECK_RESULTS.md` | Recorded local prover results |

## Checked Claims

```text
EncodedInLean(x, y) and CheckedByLeanKernel(y)
-> FormalLeanStatus(x)
```

```text
OLean imports TMI.Library.
OLean uses the Lean kernel.
OLean does not introduce a new kernel.
TMI-Lean Formal Library (TLFL) is not a Lean fork.
MD/QC/QG/LIFE/OPS are guarded public branches.
```

```text
Complete OLean + TMI.Library boundary verification
-> internal interface frequency G4/749.
```

Internal interface frequency translates the existing light-gradient scale into
a verification-frequency scale for `OLean + TMI.Library`. `G4/749` means
complete boundary verification, not physical light emission or empirical
closure.

The internal-frequency files also mirror the `OLean.boundaryCheckVerdict`
surface: complete represented boundary verification gives `pass`; incomplete
Lean/Lake-only verification gives `fail`.

```text
Vampire/Z3/E/TLFL
-> proof-chain self-model.
```

The proof-chain self-model files mirror the TLFL role as a meta-interface of
proof self-modeling. Vampire, Z3, and E provide external proof traces; TLFL
classifies those traces by admissible proof path, verification boundary, prover
compatibility, and allowed epistemic status.

## Non-Claim Guards

```text
artifact alone does not imply formal status
encoded alone does not imply formal status
guarded branch does not imply empirical physical law
library release does not imply empirical proof of TMI as physics
Lean/Lake only does not imply full external-frequency G4
external prover results without Lean-kernel checking do not imply formal Lean status
internal frequency does not imply empirical physical proof
proof-chain self-model does not imply empirical truth
proof-chain self-model does not imply physical validation
TLFL proof self-model does not replace Vampire/Z3/E proof search
external prover traces without TLFL classification do not form a full proof self-model
```
