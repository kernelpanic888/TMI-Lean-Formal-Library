# TLFL v0.5.3-alpha — Paradoxical Formula Theorem

## RU

Добавлена самозамкнутая теорема парадоксальной формулы: если свободная
связность дана, полнота влечёт принуждение, а принуждение исключает свободу, то
ни одна формула выбранного класса не исчерпывает объект полностью.

Lean 4.32.1 подтверждает доказательство без аксиом. Независимые TPTP-запуски:
Vampire — `SZS status Theorem`; E prover — `SZS status Theorem`.

Результат относителен к классу формул и явным предпосылкам. Применение к
Вселенной остаётся гипотезой.

## EN

This release adds the self-closed paradoxical-formula theorem: if free
connectivity holds, completeness implies forcing, and forcing excludes
freedom, then no formula in the selected class fully exhausts the object.

Lean 4.32.1 accepts the proof with no axioms. Independent TPTP runs return
`SZS status Theorem` in both Vampire and E prover.

The result is relative to the formula class and explicit premises. Its
application to the Universe remains a hypothesis.

## Artifacts

- `lean/TMI/FormulaInterface/ParadoxicalFormulaTheorem.lean`
- `external_proofs/paradoxical_formula_self_closed_tptp.p`
- `docs/RELEASE_v0.5.3_ALPHA_RU.md`
- `docs/RELEASE_v0.5.3_ALPHA_EN.md`

