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
| `tlfl_self_model_proof_z3_0_1.smt2` | SMT-LIB2 mirror of the OLean self-model proof chain |
| `tlfl_self_model_proof_tptp_0_1.p` | TPTP/TFF theorem bundle for the OLean self-model proof chain |
| `olean_admitted_projection_self_model_z3_0_1.smt2` | SMT-LIB2 mirror of the OLean-admitted strict self-model chain |
| `olean_admitted_projection_self_model_tptp_0_1.p` | TPTP/TFF theorem bundle for the OLean-admitted strict self-model chain |
| `tlfl_reality_cognition_self_model_z3_0_1.smt2` | SMT-LIB2 mirror of guarded reality-cognition self-model checks |
| `tlfl_reality_cognition_self_model_tptp_0_1.p` | TPTP/TFF theorem bundle for guarded reality-cognition self-model |
| `tlfl_consciousness_limit_z3_0_1.smt2` | SMT-LIB2 mirror of the guarded consciousness-limit language |
| `tlfl_consciousness_limit_tptp_0_1.p` | TPTP/TFF theorem bundle for the guarded consciousness-limit language |
| `tlfl_claim_passport_z3_0_1.smt2` | SMT-LIB2 mirror of TLFL 0.2 claim passport checks |
| `tlfl_claim_passport_tptp_0_1.p` | TPTP/TFF theorem bundle for TLFL 0.2 claim passport certification |
| `STEP_00_CHAIN_INDEX.md` | Row-level index of the `TLFL + External Proof Layer {Z3, Vampire, E}` step artifacts |
| `STEP_01_VAMPIRE.md` | Artifact for the Vampire step |
| `STEP_02_Z3.md` | Artifact for the Z3 step |
| `STEP_03_EPROVER.md` | Artifact for the E prover step |
| `STEP_04_TLFL.md` | Artifact for the TLFL classification step |
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
TLFL + External Proof Layer {Z3, Vampire, E}
-> proof-chain self-model.
```

The proof-chain self-model files mirror the TLFL role as a meta-interface of
proof self-modeling. Z3, Vampire, and E provide external proof traces; TLFL
classifies those traces by admissible proof path, verification boundary, prover
compatibility, and allowed epistemic status.

```text
OLean.SelfCheckAsThinker
-> own proof/interface model
-> proof-state self-model
-> guarded mathematical intelligence.
```

The self-model proof files mirror the publication-facing theorem chain closed in
`OLean.TLFLSelfModelProof`. They do not assert consciousness, empirical
physical validation, or empirical closure.

```text
Strict TLFL self-model:
externally produced prover traces become a self-model only after
OLean boundary admission and TLFL integration.
```

The admitted-projection files mirror that stricter chain directly.

```text
ExternalRealityTrace
-> internal TLFL interface passage
-> thinker-mediated projection model
-> proof-state self-model
-> guarded reality cognition.
```

The reality-cognition files mirror this guarded cognition chain. They do not
assert empirical truth, physical validation, or consciousness.

```text
proof-state self-model
+ bounded predictive power
-> consciousness-limit horizon
-> guarded consciousness approximation.
```

The consciousness-limit files mirror this guarded language layer. They do not
assert consciousness, empirical consciousness, reached absolute consciousness,
or achieved 100% predictive power.

```text
Claim
-> evidence bundle
-> TLFL classification
-> proof-state self-model
-> allowed claim ceiling
-> forbidden jump map
-> claim passport
-> claim passport certificate
-> public certificate surface
-> public certified-status / forbidden-boundary view
-> audit sheet / public audit surface
-> review gate / review-ready surface
```

The claim-passport files mirror the first TLFL 0.2 certification surface. They
do not assert empirical truth, physical validation, consciousness, or empirical
closure.

For a compact theorem-block view of the strict chain, see:

- `docs/TLFL_SELF_MODEL_THEOREM_SHEET_EN.md`
- `docs/TLFL_SELF_MODEL_THEOREM_SHEET_RU.md`

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
TLFL proof self-model does not replace Z3/Vampire/E proof search
external prover traces without TLFL classification do not form a full proof self-model
self-model does not imply consciousness
self-model does not imply empirical physical validation
self-model does not imply full empirical intelligence
proof-interface self-model does not imply universe-level closure
guarded mathematical intelligence does not imply empirical closure
formal guarded mathematical intelligence does not imply absolute ontological finality
guarded reality cognition does not imply empirical truth
guarded reality cognition does not imply physical validation
guarded reality cognition does not imply consciousness
external reality trace alone does not imply proof-state self-model
internal model alone does not imply guarded reality cognition
proof self-model does not imply consciousness
guarded mathematical intelligence does not imply absolute consciousness
consciousness approximation does not imply consciousness
consciousness-limit horizon does not imply reached consciousness
bounded predictive power does not imply perfect predictive power
perfect prediction is not established by TLFL
claim object alone does not imply claim passport
evidence bundle alone does not imply claim passport
claim passport does not imply empirical truth
claim passport does not imply physical validation
claim passport does not imply consciousness
claim passport does not imply empirical closure
public certificate surface does not imply empirical truth
public certificate surface does not imply physical validation
public certificate surface does not imply consciousness
public certificate surface does not imply empirical closure
claim-passport audit sheet does not imply empirical truth
claim-passport audit sheet does not imply physical validation
claim-passport audit sheet does not imply consciousness
claim-passport audit sheet does not imply empirical closure
claim-passport review gate does not imply empirical truth
claim-passport review gate does not imply physical validation
claim-passport review gate does not imply consciousness
claim-passport review gate does not imply empirical closure
claim-passport release gate does not imply empirical truth
claim-passport release gate does not imply physical validation
claim-passport release gate does not imply consciousness
claim-passport release gate does not imply empirical closure
```

The same mirror now includes the release-gate layer:

```text
claim-passport review gate + external mirror verification + synchronized docs
-> claim-passport release gate
-> release-candidate surface
```

## Step Artifacts

The package now includes an explicit artifact for each canonical chain step:

```text
TLFL    -> STEP_04_TLFL.md
Z3      -> STEP_02_Z3.md
Vampire -> STEP_01_VAMPIRE.md
E prover-> STEP_03_EPROVER.md
```
