# Manifest

Date: 2026-06-24

## Exported Library Snapshot

| Path | Role |
|---|---|
| `tmi_lean_formal_library_0_1/README.md` | Library overview |
| `tmi_lean_formal_library_0_1/LICENSE` | Apache-2.0 license text |
| `tmi_lean_formal_library_0_1/lakefile.lean` | Lake package definition |
| `tmi_lean_formal_library_0_1/lean-toolchain` | Lean toolchain pin |
| `tmi_lean_formal_library_0_1/lake-manifest.json` | Lake manifest |
| `tmi_lean_formal_library_0_1/CITATION.cff` | Citation metadata |
| `tmi_lean_formal_library_0_1/lean/TMI/Library.lean` | Canonical TMI library import |
| `tmi_lean_formal_library_0_1/lean/TMI/ProofStatusClassification.lean` | TLFL proof-status classification meta-interface |
| `tmi_lean_formal_library_0_1/lean/TMI/ProofChainSelfModel.lean` | `TLFL + External Proof Layer {Z3, Vampire, E}` proof-chain self-model |
| `tmi_lean_formal_library_0_1/lean/TMI/ClaimPassport.lean` | TLFL 0.2 claim passport, certificate, public surface, audit-sheet layer, review gate, and release gate |
| `tmi_lean_formal_library_0_1/lean/TMI/InterfaceMathematics/ProofProjectionSelfModel.lean` | Abstract external-projection, OLean-admission, and strict self-model layer |
| `tmi_lean_formal_library_0_1/lean/TMI/InterfaceMathematics/PublicSelfProjection.lean` | Outward public self-projection layer for proof-state material |
| `tmi_lean_formal_library_0_1/lean/OLean.lean` | OLean connection interface |
| `tmi_lean_formal_library_0_1/lean/OLean/Smoke.lean` | Minimal OLean smoke example |
| `tmi_lean_formal_library_0_1/lean/OLean/SelfCheck.lean` | Internal-frequency self-check for OLean + TMI.Library |
| `tmi_lean_formal_library_0_1/lean/OLean/SelfCheckAsThinker.lean` | Formal thinker-check for OLean.SelfCheck |
| `tmi_lean_formal_library_0_1/lean/OLean/AdmittedProofProjection.lean` | OLean-admitted proof projection into strict TLFL self-model |
| `tmi_lean_formal_library_0_1/lean/OLean/TLFLSelfModelProof.lean` | OLean-level proof that self-check builds its own proof/interface self-model |
| `tmi_lean_formal_library_0_1/docs/GETTING_STARTED.md` | Getting started guide |
| `tmi_lean_formal_library_0_1/docs/API_REFERENCE.md` | Public API reference |
| `tmi_lean_formal_library_0_1/docs/EXTERNAL_PROOFS.md` | External prover guide |
| `tmi_lean_formal_library_0_1/docs/CLAIM_BOUNDARY.md` | Public claim boundary |
| `tmi_lean_formal_library_0_1/docs/GLOSSARY.md` | Glossary of TLFL terms |
| `tmi_lean_formal_library_0_1/docs/REPOSITORY_PROFILE.md` | GitHub repository profile and topics |

## Library Modules

| Module | Role |
|---|---|
| `TMI.Core` | Core TMI formal surfaces |
| `TMI.PicT` | PicT entrypoint |
| `TMI.FormulaInterface` | Formula-as-interface surface |
| `TMI.BoundaryEvent` | Boundary-event vocabulary |
| `TMI.Bridge` | General bridge pattern |
| `TMI.BridgePhysics` | Physical bridge signatures/contracts |
| `TMI.SelfThinkingUniverse` | Self-thinking universe boundary |
| `TMI.InterfaceMathematics` | Thinker, measurement, interfacehood classes, AI fitting, self-modeling prover |
| `TMI.Branches` | Guarded branch aggregator |
| `OLean` | Connection interface to Lean |
| `OLean.SelfCheck` | Boundary self-check translated into internal interface frequency |
| `OLean.SelfCheckAsThinker` | Self-check verified as a TMI thinker interface |
| `OLean.AdmittedProofProjection` | Concrete OLean witness that admits external proof traces into strict TLFL self-modeling |
| `OLean.TLFLSelfModelProof` | Explicit theorem chain from self-check thinker run to guarded mathematical intelligence |
| `TMI.ProofStatusClassification` | TLFL claim classification by path, boundary, prover compatibility, and epistemic status |
| `TMI.ProofChainSelfModel` | Proof-state self-model for the `TLFL + External Proof Layer {Z3, Vampire, E}` chain |
| `TMI.ClaimPassport` | Claim passport, proof-state certification, public certificate surface, audit sheet, review gate, and release gate |
| `OLean.boundaryCheckVerdict` | Computable pass/fail boundary verdict |

## Public Documents

| Path | Role |
|---|---|
| `docs/REPRODUCIBILITY.md` | Build verification instructions |
| `docs/CLAIM_BOUNDARY.md` | Claims and non-claims |
| `docs/RELEASE_v0.2.0_CLAIM_PASSPORT.md` | GitHub release notes for `v0.2.0-claim-passport` |
| `docs/RELEASE_v0.3.0_I1_ENGINEERING_SURFACE.md` | GitHub release notes for `v0.3.0-i1-engineering-surface` |
| `docs/LEAN_COMMUNITY_ENTRY.md` | Lean community-facing package entry point |
| `docs/GITHUB_PUBLICATION_TEXT.md` | Copy-ready GitHub repository/release publication text |
| `docs/TLFL_EXTENDED_PUBLICATION_EN.md` | Extended English public explanation: what TLFL is and why it exists |
| `docs/TLFL_EXTENDED_PUBLICATION_RU.md` | Extended Russian public explanation: what TLFL is and why it exists |
| `docs/TLFL_SELF_MODEL_THEOREM_SHEET_EN.md` | English process matrix sheet for the strict self-model chain |
| `docs/TLFL_SELF_MODEL_THEOREM_SHEET_RU.md` | Russian process matrix sheet for the strict self-model chain |
| `docs/TLFL_SELF_MODEL_COMPANION_TABLE_EN.md` | English pass/fail companion table for the strict self-model chain |
| `docs/TLFL_SELF_MODEL_COMPANION_TABLE_RU.md` | Russian pass/fail companion table for the strict self-model chain |
| `docs/TLFL_PUBLIC_SELF_PROJECTION_NOTE_EN.md` | English note on outward self-projection through public proof materials |
| `docs/TLFL_PUBLIC_SELF_PROJECTION_NOTE_RU.md` | Russian note on outward self-projection through public proof materials |
| `docs/TLFL_CLAIM_PASSPORT_PROOF_STATUS.md` | Proof-status note for the first TLFL 0.2 claim passport slice |
| `docs/TLFL_CLAIM_PASSPORT_AUDIT_SHEET.md` | Audit-sheet note for the TLFL 0.2 public claim-passport surface |
| `docs/TLFL_CLAIM_PASSPORT_REVIEW_GATE.md` | Review-gate note for the TLFL 0.2 public claim-passport audit sheet |
| `docs/TLFL_CLAIM_PASSPORT_RELEASE_GATE.md` | Release-gate note for the TLFL 0.2 claim-passport release-candidate surface |
| `docs/TLFL_0_2_COMPLETION_AUDIT.md` | Completion audit for the TLFL 0.2 claim-passport and proof-state certification slice |
| `docs/SURFACE_MAP_RU.md` | Public map of the TMI-OS / И1 engineering surface |
| `docs/THEORY_LINKS.md` | Guarded source links and related theory references |
| `programs/tmi_os_mathematical_board/` | Runnable local mathematical-board program surface |
| `plugins/tmi-os-mathematical-board/` | Codex plugin/export-ready surface |
| `exports/tmi_os_mathematical_board_public/` | Exportable public board package |
| `external_proofs/` | Z3, Vampire, and E prover release-boundary checks |

## Source Repository

| Field | Value |
|---|---|
| GitHub repository | `https://github.com/kernelpanic888/TMI-Lean-Formal-Library` |
| Source commit | `4be975e37df910f45c1d38e6ac1a4dfa6ee6b211` |
| Source author | `Salkutsan Aleksey <kernelpanic888@gmail.com>` |
| License | `Apache-2.0` |

## External Proof Files

| Path | Role |
|---|---|
| `external_proofs/olean_library_z3_0_1.smt2` | Release-boundary SMT checks |
| `external_proofs/olean_library_tptp_0_1.p` | Release-boundary ATP theorem bundle |
| `external_proofs/olean_internal_frequency_z3_0_1.smt2` | Internal-frequency SMT checks |
| `external_proofs/olean_internal_frequency_tptp_0_1.p` | Internal-frequency ATP theorem bundle |
| `external_proofs/tlfl_proof_self_model_z3_0_1.smt2` | TLFL proof self-model SMT checks |
| `external_proofs/tlfl_proof_self_model_tptp_0_1.p` | TLFL proof self-model ATP theorem bundle |
| `external_proofs/tlfl_self_model_proof_z3_0_1.smt2` | OLean self-model proof SMT checks |
| `external_proofs/tlfl_self_model_proof_tptp_0_1.p` | OLean self-model proof ATP theorem bundle |
| `external_proofs/olean_admitted_projection_self_model_z3_0_1.smt2` | OLean-admitted strict self-model SMT checks |
| `external_proofs/olean_admitted_projection_self_model_tptp_0_1.p` | OLean-admitted strict self-model ATP theorem bundle |
| `external_proofs/tlfl_claim_passport_z3_0_1.smt2` | SMT-LIB2 mirror of TLFL 0.2 claim passport checks |
| `external_proofs/tlfl_claim_passport_tptp_0_1.p` | TPTP/TFF theorem bundle for TLFL 0.2 claim passport certification |
| `external_proofs/STEP_00_CHAIN_INDEX.md` | Index of row-level step artifacts for `TLFL + External Proof Layer {Z3, Vampire, E}` |
| `external_proofs/STEP_01_VAMPIRE.md` | Row-level artifact for Vampire |
| `external_proofs/STEP_02_Z3.md` | Row-level artifact for Z3 |
| `external_proofs/STEP_03_EPROVER.md` | Row-level artifact for E prover |
| `external_proofs/STEP_04_TLFL.md` | Row-level artifact for TLFL |
