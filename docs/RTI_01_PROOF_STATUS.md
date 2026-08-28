# RTI-01 proof status

**Date:** 2026-08-28
**Toolchain:** Lean 4.31.0-rc1, arm64-apple-darwin24.6.0, commit `fd009949156901e6cf15b6d9bf1122294b8e697a`
**RTI kernel commit:** `17058ba82066732733fec34ea5f305f380495482`
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
| `differential_aging_does_not_force_relative_reversal` | audit module | PASS · no axioms |
| First-order mirror | `external_proofs/rti_01_future_reading_cannot_be_both_tptp_0_1.p` | PASS |
| Vampire 5.0.1 | first-order mirror | `SZS status Theorem` |
| E 3.2.5 | first-order mirror | `SZS status Theorem` |
| Fail-closed audit | `scripts/audit_rti_01_relative_temporal_interface.sh` | PASS |

## Reproduction

From the repository root:

```bash
lake env lean -o .lake/build/lib/lean/TMI/InterfaceFoundations/RelativeTemporalInterface.olean \
  lean/TMI/InterfaceFoundations/RelativeTemporalInterface.lean

lake env lean -o .lake/build/lib/lean/TMI/InterfaceFoundations/RelativeTemporalInterfaceAudit.olean \
  lean/TMI/InterfaceFoundations/RelativeTemporalInterfaceAudit.lean

./scripts/audit_rti_01_relative_temporal_interface.sh
```

The audit file prints the axiom dependencies of the five named theorems; each result is `depends on axioms: []`. The fail-closed audit also rejects `sorry`, `admit`, declared `axiom`, a missing prover, timeout, or any ATP result other than the exact `SZS status Theorem` from both Vampire and E.

## Interpretation of the certificate

The certificate covers only the typed logical distinction among:

- a two-sided local temporal interface;
- one selected future-directed step;
- an explicit comparison between event-local direction types;
- a preserving versus reversing relative reading;
- path-dependent differential aging;
- the non-implication from differential aging to relative reversal.

It does not certify a Lorentzian model, Einstein field equation solution, black-hole orbit, physical time-orientation reversal, closed timelike curve, quantum construction, or experimental claim.

The TPTP problem mirrors only `future_reading_cannot_be_both`. Vampire and E are independent first-order checks of that logical fragment, not replacements for Lean's dependent-type kernel and not evidence for a physical relative reversal.

## Repository boundary

RTI-01 deliberately imports the compiled `TMI.ActivationRelicTwoAxisTime` surface. The older experimental files `TMI.InterfaceFoundations.TwoAxisTime` and `TMI.InterfaceFoundations.TwoSidedInterface` have a pre-existing direct-build gap and were not repaired or used as proof dependencies in this increment.

The certificate was reproduced in the clean repaired branch `codex/rti-01-relative-temporal-interface`. It claims the two targeted Lean module builds and the external ATP mirror only; it does not claim a full-repository build.
