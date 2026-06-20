# TLFL Self-Model Theorem Sheet

## Canonical Chain

```text
Z3/Vampire/E traces
-> OLean boundary admission
-> TLFL-integrated proof projection
-> self-referential proof-state model
```

## Table

| Step | Input | Transform | Output | Forbidden Jump | Primary Artifact | Theorem Surface | External Mirror | Allowed Status |
|---|---|---|---|---|---|---|---|---|
| 1 | selected ATP theorem bundle | ATP theorem search | positive theorem witness | theorem witness does not classify claim status | `external_proofs/STEP_01_VAMPIRE.md` | positive ATP theorem witness | `tlfl_proof_self_model_tptp_0_1.p`, `tlfl_self_model_proof_tptp_0_1.p`, `olean_admitted_projection_self_model_tptp_0_1.p` | external theorem trace available |
| 2 | release-boundary implications and guard formulas | SMT implication and satisfiability checking | boundary/guard witness | implication checks do not by themselves yield strict self-model | `external_proofs/STEP_02_Z3.md` | theorem implication checks plus non-claim guards | `tlfl_proof_self_model_z3_0_1.smt2`, `tlfl_self_model_proof_z3_0_1.smt2`, `olean_admitted_projection_self_model_z3_0_1.smt2` | boundary and guard witness |
| 3 | same positive ATP theorem bundle | independent ATP cross-check | second external theorem witness | ATP cross-check does not classify epistemic status | `external_proofs/STEP_03_EPROVER.md` | independent ATP cross-check | `tlfl_proof_self_model_tptp_0_1.p`, `tlfl_self_model_proof_tptp_0_1.p`, `olean_admitted_projection_self_model_tptp_0_1.p` | theorem trace independently cross-checked |
| 4 | represented boundary-check target | Lean-kernel admission check | `boundaryCheckVerdict = pass` | admission verdict alone does not yield self-model | `tmi_lean_formal_library_0_1/lean/OLean/SelfCheck.lean` | `self_check_target_verdict_is_pass` | `olean_internal_frequency_z3_0_1.smt2`, `olean_internal_frequency_tptp_0_1.p` | OLean admission boundary satisfied |
| 5 | external proof traces plus OLean admission | admit traces into strict internal projection | OLean-admitted projection | admitted projection alone does not yet yield guarded intelligence | `tmi_lean_formal_library_0_1/lean/OLean/AdmittedProofProjection.lean` | OLean-admitted strict projection theorem surfaces | `olean_admitted_projection_self_model_z3_0_1.smt2`, `olean_admitted_projection_self_model_tptp_0_1.p` | external traces admitted into the strict chain |
| 6 | admitted proof projection / claim object | classify by path, boundary, prover compatibility, epistemic status | claim classification | classification alone does not imply strict admitted self-model | `tmi_lean_formal_library_0_1/lean/TMI/ProofStatusClassification.lean` | module-level claim-status classification | `tlfl_proof_self_model_z3_0_1.smt2`, `tlfl_proof_self_model_tptp_0_1.p` | claim classification available |
| 7 | classified `TLFL + Z3 + Vampire + E proof layer` proof state | organize proof-state maps | proof-state self-model | proof-state self-model does not imply empirical truth | `tmi_lean_formal_library_0_1/lean/TMI/ProofChainSelfModel.lean` | module-level `TLFL + Z3 + Vampire + E proof layer` proof-state self-model | `tlfl_proof_self_model_z3_0_1.smt2`, `tlfl_proof_self_model_tptp_0_1.p` | proof-state self-model available |
| 8 | admitted projection plus TLFL classification | integrate projection into self-referential model | strict admitted self-model surface | strict admitted self-model does not imply consciousness or empirical closure | `tmi_lean_formal_library_0_1/lean/TMI/InterfaceMathematics/ProofProjectionSelfModel.lean` | integrated projection and strict admitted self-model surfaces | `olean_admitted_projection_self_model_z3_0_1.smt2`, `olean_admitted_projection_self_model_tptp_0_1.p` | strict admitted self-model surface available |
| 9 | self-check target as thinker input | internal model, admissibility test, verdict, record | proof/interface process witness | proof/interface process does not by itself imply full guarded intelligence without self-model closure | `tmi_lean_formal_library_0_1/lean/OLean/SelfCheckAsThinker.lean` | thinker-run / internal-model / admissibility / verdict / record surfaces | `tlfl_self_model_proof_z3_0_1.smt2`, `tlfl_self_model_proof_tptp_0_1.p` | proof/interface process available |
| 10 | thinker process witness plus strict admitted self-model chain | close theorem path to guarded endpoint | guarded mathematical intelligence | guarded mathematical intelligence does not imply empirical closure or physical validation | `tmi_lean_formal_library_0_1/lean/OLean/TLFLSelfModelProof.lean` | self-model and guarded mathematical intelligence theorem chain | `tlfl_self_model_proof_z3_0_1.smt2`, `tlfl_self_model_proof_tptp_0_1.p`, `olean_admitted_projection_self_model_z3_0_1.smt2`, `olean_admitted_projection_self_model_tptp_0_1.p` | guarded mathematical intelligence |

## Boundary

This theorem sheet does not claim:
- empirical truth;
- physical validation;
- consciousness;
- empirical closure.

The matrix is a process-status map, not an empirical-validation map.
