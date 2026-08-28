# RTI-01 · Relative Temporal Interface and QTM-01 v0.1.0

[![RTI-01 publication map](https://raw.githubusercontent.com/kernelpanic888/TMI-Lean-Formal-Library/rti-01-relative-temporal-interface-v0.1.0/exports/chertogi_first_distinction_public/readers/activation-relic-shadow-boundary/relative-temporal-interface-en.png)](https://chertogi-razuma-research.kernelpanic888.chatgpt.site/readers/activation-relic-shadow-boundary/)

> **ВОПРОС СТАТЬИ:** «Мы живём внутри квантовой машины времени?»
> **ARTICLE QUESTION:** “Do we live inside a quantum time machine?”

## Открыть / Open

- **Живой двуязычный ридер / Live bilingual reader:**
  <https://chertogi-razuma-research.kernelpanic888.chatgpt.site/readers/activation-relic-shadow-boundary/>
- **Полная статья RU/EN / Complete RU/EN article:**
  <https://github.com/kernelpanic888/TMI-Lean-Formal-Library/blob/rti-01-relative-temporal-interface-v0.1.0/docs/RTI_01_QUANTUM_TIME_MACHINE_ARTICLE_RU_EN.md>
- **Выбранная публикационная карта / Selected publication map:**
  <https://github.com/kernelpanic888/TMI-Lean-Formal-Library/blob/rti-01-relative-temporal-interface-v0.1.0/exports/chertogi_first_distinction_public/readers/activation-relic-shadow-boundary/relative-temporal-interface-en.png>

## Что выпущено / What is released

- **Standard GR:** две future-directed мировые линии `γ_L, γ_E : A → B` могут накопить разное собственное время; контраст ридера — `τ[γ_L]=1 < 1000=τ[γ_E]`.
- **RTI-01:** локальные `future`/`past`-секторы, явная карта сравнения `Θ_{p←q}`, сохраняющее и разворачивающее чтения, `RelativeReversal` только как явный свидетель.
- **QTM-01:** ветвящийся кандидат `Q=(B,α,Active,Θ)` и критерий `∃b, Active(b) ∧ Θ_b(C_q^+)⊆C_p^-`.
- **Dynamic board:** Лина, Земля, black-hole world tube, собственные часы, наклонённые локальные интерфейсы и режимы `GR / RTI σ=+1 / QTM? σ=−1`.

## Проверенная граница / Checked boundary

Lean kernel проверяет девять RTI/QTM-теорем без проектных аксиом. Независимые first-order зеркала Vampire 5.0.1 и E 3.2.5 возвращают `SZS status Theorem` для обеих логических задач.

The Lean kernel checks nine RTI/QTM theorems without project axioms. Independent first-order mirrors in Vampire 5.0.1 and E 3.2.5 return `SZS status Theorem` for both logical obligations.

Ключевой отрицательный результат:

```text
τ[γ_L] < τ[γ_E]  does not imply  σ(p,q) = −1

[∀ b, Active(b) → Θ_b(C_q^+) ⊆ C_p^+]
→ ¬QTM(Q)
```

## Красная граница / Red boundary

Релиз не доказывает физический разворот времени, closed timelike curve, движение Земли в причинное прошлое Лины или существование квантовой машины времени. Reversing-ветвь представлена только явными формальными данными; геометрический, квантовый и экспериментальный мосты остаются открыты.

This release does not prove physical time reversal, a closed timelike curve, Earth entering Lina's causal past, or the existence of a quantum time machine. A reversing branch is represented only by explicit formal data; the geometric, quantum, and experimental bridges remain open.

## Проверяемые носители / Verifiable carriers

- `RelativeTemporalInterface.lean` and audit
- `QuantumComparisonBoundary.lean` and audit
- two TPTP mirrors
- fail-closed Lean + Vampire + E audit
- bilingual claim passport and proof-status ledger
- bilingual article, reader, dynamic board, and 1672×941 publication image

Publication image SHA-256:

```text
3b50c4bbe5af5b5456c33667dde5c376010f86d80e2a9782bc81e1206490e654
```
