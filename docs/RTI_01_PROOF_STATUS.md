# RTI-01 / RTI-02 proof status

**Date:** 2026-08-28
**Toolchain:** Lean 4.31.0-rc1, arm64-apple-darwin24.6.0, commit `fd009949156901e6cf15b6d9bf1122294b8e697a`
**RTI kernel commit:** `17058ba82066732733fec34ea5f305f380495482`
**Quantum-boundary commit:** `874e7b1`
**External provers:** Vampire 5.0.1; E 3.2.5

## Checked surface

| Item | Location | Result |
|---|---|---|
| RTI definitions | `lean/TMI/InterfaceFoundations/RelativeTemporalInterface.lean` | PASS |
| Finite witnesses and negative audit | `lean/TMI/InterfaceFoundations/RelativeTemporalInterfaceAudit.lean` | PASS |
| `future_reading_cannot_be_both` | RTI module | PASS · no axioms |
| `relatively_reversed_touch_has_two_axis_readings` | RTI module | PASS · no axioms |
| `reunion_exhibits_shared_endpoints_and_differential_aging` | RTI module | PASS · no axioms |
| `reversed_touch_reuses_existing_two_axis_time` | audit module | PASS · no axioms |
| `differential_aging_does_not_force_relative_reversal` | RTI audit module | PASS · no axioms |
| Quantum candidate definitions | `lean/TMI/InterfaceFoundations/QuantumComparisonBoundary.lean` | PASS |
| Quantum finite witnesses | `lean/TMI/InterfaceFoundations/QuantumComparisonBoundaryAudit.lean` | PASS |
| `all_active_branches_preserving_excludes_reversal` | quantum module | PASS · no axioms |
| `preserving_candidate_is_not_quantum_time_machine` | quantum module | PASS · no axioms |
| `preserving_candidate_has_no_reversing_branch` | quantum audit | PASS · no axioms |
| `mixed_candidate_reversal_is_explicit_branch_data` | quantum audit | PASS · no axioms |
| RTI first-order mirror | `external_proofs/rti_01_future_reading_cannot_be_both_tptp_0_1.p` | PASS |
| Quantum-boundary first-order mirror | `external_proofs/rti_02_quantum_reversal_requires_explicit_branch_tptp_0_1.p` | PASS |
| Vampire 5.0.1 | both first-order mirrors | `SZS status Theorem` · 2/2 |
| E 3.2.5 | both first-order mirrors | `SZS status Theorem` · 2/2 |
| Fail-closed audit | `scripts/audit_rti_01_relative_temporal_interface.sh` | PASS |

## Reproduction

From the repository root:

```bash
lake env lean -o .lake/build/lib/lean/TMI/InterfaceFoundations/RelativeTemporalInterface.olean \
  lean/TMI/InterfaceFoundations/RelativeTemporalInterface.lean

lake env lean -o .lake/build/lib/lean/TMI/InterfaceFoundations/RelativeTemporalInterfaceAudit.olean \
  lean/TMI/InterfaceFoundations/RelativeTemporalInterfaceAudit.lean

lake env lean lean/TMI/InterfaceFoundations/QuantumComparisonBoundaryAudit.lean

./scripts/audit_rti_01_relative_temporal_interface.sh
```

The two audit files print the axiom dependencies of nine named theorems; each result is `depends on axioms: []`. The fail-closed audit also rejects `sorry`, `admit`, declared `axiom`, a missing prover, timeout, or any ATP result other than the exact `SZS status Theorem` from both Vampire and E.

## Interpretation of the certificate

The certificate covers only the typed logical distinction among:

- a two-sided local temporal interface;
- one selected future-directed step;
- an explicit comparison between event-local direction types;
- a preserving versus reversing relative reading;
- path-dependent differential aging;
- the non-implication from differential aging to relative reversal;
- an abstract branch-indexed quantum candidate;
- the no-smuggling result that all-preserving active branches cannot yield a reversing branch.

It does not certify a Lorentzian model, Einstein field equation solution, black-hole orbit, physical time-orientation reversal, closed timelike curve, Hilbert-space quantum dynamics or measurement model, or experimental claim.

The two TPTP problems mirror only `future_reading_cannot_be_both` and `all_active_branches_preserving_excludes_reversal`. Vampire and E are independent first-order checks of those logical fragments, not replacements for Lean's dependent-type kernel, a physical quantum model, or evidence for relative reversal.

## Repository boundary

RTI-01 deliberately imports the compiled `TMI.ActivationRelicTwoAxisTime` surface. The older experimental files `TMI.InterfaceFoundations.TwoAxisTime` and `TMI.InterfaceFoundations.TwoSidedInterface` have a pre-existing direct-build gap and were not repaired or used as proof dependencies in this increment.

The certificate was reproduced in the clean repaired branch `codex/rti-01-relative-temporal-interface`. It claims the four targeted Lean module builds and two external ATP mirrors only; it does not claim a full-repository build.
