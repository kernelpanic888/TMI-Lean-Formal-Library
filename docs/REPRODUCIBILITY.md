# Reproducibility

Date: 2026-06-20

## Environment

The package is pinned to the Lean toolchain recorded in:

```text
tmi_lean_formal_library_0_1/lean-toolchain
```

Current toolchain:

```text
leanprover/lean4:v4.31.0-rc1
```

## Build Commands

Run from:

```text
tmi_lean_formal_library_0_1/
```

Commands:

```bash
lake build TMI
lake build OLean
lake env lean lean/TMI/Library.lean
lake env lean lean/OLean.lean
lake env lean lean/OLean/Smoke.lean
lake env lean lean/OLean/SelfCheck.lean
lake env lean lean/OLean/SelfCheckAsThinker.lean
lake env lean lean/TMI/ProofStatusClassification.lean
lake env lean lean/TMI/ProofChainSelfModel.lean
lake env lean lean/TMI/ClaimPassport.lean
```

Optional verdict check:

```lean
import OLean.SelfCheck
#eval OLean.boundaryCheckVerdict OLean.completeBoundaryCheckInput
#eval OLean.boundaryCheckVerdict OLean.leanOnlyBoundaryCheckInput
```

Expected:

```text
OLean.CheckVerdict.pass
OLean.CheckVerdict.fail
```

## External Prover Commands

Run from the package root:

```text
publications/zenodo/tmi_lean_formal_library_0_1_2026-06-20/
```

Commands:

```bash
z3 external_proofs/olean_library_z3_0_1.smt2
vampire --mode casc --time_limit 10 external_proofs/olean_library_tptp_0_1.p
eprover --auto --cpu-limit=10 external_proofs/olean_library_tptp_0_1.p
z3 external_proofs/olean_internal_frequency_z3_0_1.smt2
vampire --mode casc --time_limit 10 external_proofs/olean_internal_frequency_tptp_0_1.p
eprover --auto --cpu-limit=10 external_proofs/olean_internal_frequency_tptp_0_1.p
z3 external_proofs/tlfl_proof_self_model_z3_0_1.smt2
vampire --mode casc --time_limit 10 external_proofs/tlfl_proof_self_model_tptp_0_1.p
eprover --auto --cpu-limit=10 external_proofs/tlfl_proof_self_model_tptp_0_1.p
z3 external_proofs/tlfl_claim_passport_z3_0_1.smt2
vampire --mode casc --time_limit 10 external_proofs/tlfl_claim_passport_tptp_0_1.p
eprover --auto --cpu-limit=10 external_proofs/tlfl_claim_passport_tptp_0_1.p
```

If these tools are not on `PATH`, use their local absolute binary paths. The
published package intentionally does not record local machine paths.

## Expected Result

All commands should complete successfully.

The important public imports are:

```lean
import TMI.Library
import OLean
import OLean.Smoke
import OLean.SelfCheck
import OLean.SelfCheckAsThinker
import TMI.ProofStatusClassification
import TMI.ProofChainSelfModel
import TMI.ClaimPassport
```

The `OLean.SelfCheck` import translates the existing G0..G4 light-gradient
values into an internal interface-frequency scale for verification. `G4/749`
means complete boundary verification, not physical light emission.

## Local Verification Result

The export package was locally checked on 2026-06-20:

```text
lake build TMI: pass
lake build OLean: pass
lake env lean lean/TMI/Library.lean: pass
lake env lean lean/OLean.lean: pass
lake env lean lean/OLean/Smoke.lean: pass
lake env lean lean/OLean/SelfCheck.lean: pass
lake env lean lean/OLean/SelfCheckAsThinker.lean: pass
OLean SelfCheck thinker test: pass
TMI.ProofStatusClassification: pass
TMI.ProofChainSelfModel: pass
TMI.ClaimPassport: pass
OLean boundaryCheckVerdict complete input: pass
OLean boundaryCheckVerdict Lean-only input: fail
Z3 external proof layer: pass
Vampire external proof layer: SZS status Theorem
E prover external proof layer: SZS status Theorem
TLFL claim-passport Z3 mirror: pass
TLFL claim-passport Vampire bundle: SZS status Theorem
TLFL claim-passport E prover bundle: SZS status Theorem
TLFL claim-passport verdict/status layer: pass
TLFL claim-passport certificate object: pass
TLFL claim-passport public certificate surface: pass
TLFL claim-passport audit sheet: pass
```

Sanity check:

```text
no open Lean proof holes or unfinished-marker strings in the exported library
snapshot
```
