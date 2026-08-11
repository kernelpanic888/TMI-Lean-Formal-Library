# PM-01 formal claim passport / Формальный паспорт утверждений

Status: `KERNEL-CHECKED INTERNAL THEORY`

Canonical source carrier: `PoetryOfMathematics.lean`  
Independent audit carrier: `PoetryOfMathematicsAudit.lean`  
Lean: `4.31.0`  
Mathlib: tag `v4.31.0`, locked revision
`fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`

Source SHA-256:
`883c8d39fda00c3f06e38c082e319965d87013d01d3401d4dea6b869382fb105`  
Audit SHA-256:
`aed17625ec2137704cbb039b0034d03e5dbac7c242ed99ae25cb64fc96ed4540`

## Inputs / Входы

- ambient space is `Fin 3 → ℝ`, the formal carrier of `ℝ³`;
- hard shadow uses only `t ∈ (0, 1)` on the segment `S → p`;
- radiometric visibility satisfies `0 ≤ V ≤ 1`;
- the radiometric kernel is nonnegative and both integrands are integrable;
- the unoccluded irradiance is positive when `σ` is normalized;
- the boundary inclusion and equality use separately named tangency-generation
  and regular-projection contracts.

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
11. the metaphysical canon is not tagged as a kernel theorem;
12. the “other worlds” claim is tagged outside the theory.

## Axiom audit / Аудит аксиом

The first ten exports depend only on Mathlib's standard logical foundations:
`propext`, `Classical.choice`, and `Quot.sound`. The two status-boundary exports
depend on no axioms. No project-defined axiom is introduced.

Первые десять экспортов зависят только от стандартных логических оснований
Mathlib: `propext`, `Classical.choice` и `Quot.sound`. Два экспорта границы
статусов не зависят ни от каких аксиом. Авторские аксиомы не вводятся.

## Red boundary / Красная граница

This theory does not prove geometric optics empirically, does not derive the
regularity contract for every obstacle, and does not prove metaphysics, poetry,
consciousness, or other worlds. Those are not hidden assumptions; they are
outside the formal claim ceiling.

Теория не подтверждает геометрическую оптику эмпирически, не выводит контракт
регулярности для любого препятствия и не доказывает метафизику, поэзию,
сознание или иные миры. Это не скрытые предпосылки: они находятся за пределами
формального потолка утверждений.
