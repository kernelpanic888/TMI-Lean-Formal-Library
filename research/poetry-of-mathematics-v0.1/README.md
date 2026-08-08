# PM-01 · Poetry of Mathematics / Поэзия математики

This directory is the complete internal Lean theory behind the public PM-01
reader. The reader is for people; this package is for deep verification.

Эта директория — цельная внутренняя Lean-теория публичного ридера PM-01. Сайт
предназначен для людей; этот пакет — для глубокого погружения и проверки.

## Formal chain / Формальная цепь

`E = ℝ³`
→ bounded segment `S → p`
→ hard-shadow membership
→ extended-source irradiance integral
→ normalized field `σ`
→ derived identity `E_U = E_0(1 − σ)`
→ `0 ≤ σ ≤ 1` under explicit radiometric hypotheses
→ projected-tangency boundary inclusion
→ boundary equality under an explicit two-sided regularity contract.

The package also encodes a hard status boundary: the metaphysical canon is an
author interpretation, not a kernel theorem; “other worlds” remain outside the
formal theory.

Пакет также кодирует жёсткую границу статусов: метафизический канон является
авторской интерпретацией, а не теоремой ядра; «иные миры» остаются за пределами
формальной теории.

## Reproduce / Воспроизведение

```bash
lake build
lake env lean PoetryOfMathematicsAudit.lean
```

Release gates:

- no `sorry`, `admit`, or project-defined `axiom`;
- the theory and the separate axiom audit must both compile;
- imported theorem dependencies are reported by `#print axioms`;
- physical and geometric hypotheses remain named inputs rather than being
  smuggled in as conclusions.

## Claim ceiling / Потолок утверждений

Lean verifies the definitions, algebra, order bounds, integral monotonicity,
set inclusion, and conditional equality. It does **not** empirically validate
geometric optics, infer smoothness/visibility assumptions for an arbitrary
scene, or prove the poetic/metaphysical reading.

Lean проверяет определения, алгебру, границы порядка, монотонность интеграла,
включение множеств и условное равенство. Он **не** выполняет эмпирическую
валидацию геометрической оптики, не выводит условия гладкости/видимости для
произвольной сцены и не доказывает поэтическое или метафизическое прочтение.
