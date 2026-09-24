# PIM-01 build and axiom audit

**Checked:** 2026-09-20<br>
**Lean toolchain:** `leanprover/lean4:v4.31.0-rc1`<br>
**Base:** TLFL `origin/main` at `4e43e97f8dc659dd1485e0d3739ca51c33058e16`

## Targeted build

```text
/Users/panic/.elan/bin/lake build TMI.InterfaceMathematics.PiInterfaceModelAudit
```

Result: `PASS` — 54 jobs completed, no errors or warnings.

## Source-hole audit

The model and audit sources contain no `sorry`, `admit`, or `sorryAx`.

## Named axiom audit

Ten public results were checked with `#print axioms`. Every result printed:

```text
does not depend on any axioms
```

The checked results are:

1. `meaning_preserved_of_relations`;
2. `meaning_preserved_of_common_factorization`;
3. `semantic_commutation_of_relevant_structure`;
4. `invariant_under_composition`;
5. `semantic_preservation_requires_constant_on_fibers`;
6. `same_observation_can_hide_world_difference`;
7. `StatefulInterface.step_carrier`;
8. `StatefulInterface.step_memory`;
9. `ToySignChange.translate_preserves_relations`;
10. `ToySignChange.any_relational_meaning_preserved`.

## SHA-256 before commit

```text
7398502e73f072c6ff021e3d89314a66fa9bad30ab8f666d44c47da970da029a  PiInterfaceModel.lean
717048a9b43ded4c39610e48dc3678b1811c2df1e96f09bf3175944338315753  PiInterfaceModelAudit.lean
145d68b9887c8262ecc10c2e1a9ab8f34f6c1b83a24b9c5ba4cc833831923aa6  README.md
```

## Claim boundary

This is a kernel-checked conditional formalization. The audit does not prove a
scientific theory extracted from the film, the objectivity of a selected
relation structure, or the semantic adequacy of a concrete encoding.
