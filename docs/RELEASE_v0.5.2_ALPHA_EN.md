# TLFL v0.5.2-alpha — selection field

This corrective alpha restores the selection layer present in the earlier
`TLFL_WANDERING_GOAL_FIELD.lean`.

## Formal chain

```text
memory -> admissible goal field -> separate selector -> selected goal
```

The release adds `FieldOfNearestGoalsFrame`, `FieldOfNearestGoals`,
`FieldOfNearestGoalsSelection`, `fieldOfNearestGoals_nonempty_of_selection`,
and `WanderingInsideGoalField`.

The field remains a set of possibilities. The function `choose` is additional
data and is not derived from field existence.

`PredictionBoundary` also replaces the Boolean-looking `!=` notation with
strict propositional inequality `≠`.

No Lean build or axiom audit was run in this step. Status remains
`authored / experimental`; the stable `TMI.Library` root does not import the
new experimental root.
