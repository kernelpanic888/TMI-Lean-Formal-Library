# PM-01 formal claim passport / Формальный паспорт утверждений

Status: `KERNEL-CHECKED INTERNAL THEORY`

Canonical source carrier: `PoetryOfMathematics.lean`  
Independent audit carrier: `PoetryOfMathematicsAudit.lean`  
Lean: `4.31.0`  
Mathlib: tag `v4.31.0`, locked revision
`fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`

Source SHA-256:
`d4aa862d13f1a4f99fc6b784283006924f9b576120740f9725d87afbb8e4d11c`
Audit SHA-256:
`d96581f9ce178b99eba3c7ed4afaa46b80617ddb7fda00100c178653dcc16a71`

## Inputs / Входы

- ambient space is `Fin 3 → ℝ`, the formal carrier of `ℝ³`;
- hard shadow uses only `t ∈ (0, 1)` on the segment `S → p`;
- radiometric visibility satisfies `0 ≤ V ≤ 1`;
- the radiometric kernel is nonnegative and both integrands are integrable;
- the unoccluded irradiance is positive when `σ` is normalized;
- the boundary inclusion and equality use separately named tangency-generation
  and regular-projection contracts.
- the confirmed center `C` carries a separately supplied confirmation witness;
- each `H_i` has an explicit nonnegative radius, angle and epistemic status;
- `IndependentlyVerified` is an input predicate, not a derived empirical fact;
- the orbit radius is an abstract epistemic coordinate, not a declared
  Fisher–Rao distance.

## Kernel-checked outputs / Проверенные результаты

1. membership in the hard shadow is equivalent to a bounded-segment witness;
2. every occlusion witness is strictly between source and receiver;
3. an obstacle reachable only at `t ≥ 1` cannot occlude the receiver;
4. visibility weighting lies between zero and the full kernel;
5. occluded irradiance lies in `[0, E₀]`;
6. `E_U = E₀(1 − σ)` follows from the definition of `σ` when `E₀ ≠ 0`;
7. `σ ∈ [0, 1]` follows from `0 ≤ E_U ≤ E₀` and `E₀ > 0`;
8. the radiometric hypotheses instantiate the `σ` bound;
9. tangency generation implies boundary inclusion in projected tangencies;
10. the two-sided regularity contract implies exact boundary equality;
11. `B = C + I + G + R` is encoded as an explicit structural conjunction;
12. a reality-trace candidate projects to a separate `Checked` witness;
13. a beauty candidate with a failed check is not a reality-trace candidate;
14. poetic reading projects to both magic and an explicit readability layer;
15. the metaphysical canon is not tagged as a kernel theorem;
16. the “other worlds” claim is tagged outside the theory.
17. arbitrary `dθ` rotation has `dr = 0` and preserves epistemic status;
18. every admissible `dr < 0` move exposes an independent-verification witness;
19. promotion from hypothesis to verified fact exposes the same witness;
20. absence of verification blocks inward motion and fact promotion;
21. physical identification of the orbit geometry is tagged as author
    interpretation rather than a kernel theorem.

## Axiom audit / Аудит аксиом

The geometric and radiometric exports depend only on Mathlib's standard
logical foundations: `propext`, `Classical.choice`, and `Quot.sound`. The
original structural projections and status-boundary exports depend on no
axioms. The new real-coordinate and gate theorems use the same standard
Mathlib logical foundation; the new physical-status boundary is axiom-free.
No project-defined axiom is introduced.

Геометрические и радиометрические экспорты зависят только от стандартных
логических оснований Mathlib: `propext`, `Classical.choice` и `Quot.sound`.
Исходные структурные проекции и экспорты границы статусов не зависят от аксиом.
Новые теоремы о вещественных координатах и шлюзе используют ту же стандартную
логическую основу Mathlib; новая граница физического статуса не зависит от
аксиом. Авторские аксиомы не вводятся.

## External prover cross-check / Внешняя перекрёстная проверка

`HypothesisOrbitGate.p` is a first-order mirror of the abstract gate
consequences. It was proved independently by both requested provers:

- Vampire 5.0.1: `SZS status Theorem`, 427-line TSTP proof;
- E 3.2.5: `SZS status Theorem`, 946-line CNF refutation.

| Artifact | SHA-256 |
| --- | --- |
| `HypothesisOrbitGate.p` | `b03c040c30141f912f8e00f6f4e3f0083021523ee9a2db67b3808daf5d1d15c9` |
| `HypothesisOrbitGate.vampire.tstp` | `3314ab347899ecefc2a92994fe423d508efe02c1b6fba0630ee4580090768338` |
| `HypothesisOrbitGate.eprover.tstp` | `f48f9b8a5cfa54bb4385e3fb139163b16335844cb0cf9381f880cf9491048134` |

This is not a mechanically generated equivalence proof between Lean and TPTP,
and the mirror deliberately does not encode real arithmetic.

## Red boundary / Красная граница

This theory does not prove geometric optics empirically, does not derive the
regularity contract for every obstacle, and does not prove metaphysics, poetry,
consciousness, beauty as evidence, magic as supernatural fact, or other worlds.
It also does not establish that a real-world verifier is independent, that
hypotheses occupy literal circular orbits, or that `radius` is a Fisher–Rao
distance. Those are not hidden assumptions; they are outside the formal claim
ceiling.

Теория не подтверждает геометрическую оптику эмпирически, не выводит контракт
регулярности для любого препятствия и не доказывает метафизику, поэзию,
сознание, красоту как свидетельство, магию как сверхъестественный факт или иные
миры. Она также не доказывает независимость реального проверяющего процесса,
буквальные круговые орбиты гипотез или равенство `radius` расстоянию
Fisher–Rao. Это не скрытые предпосылки: они находятся за пределами формального
потолка утверждений.
