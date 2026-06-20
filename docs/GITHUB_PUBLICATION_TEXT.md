# GitHub Publication Text

This file is a copy-ready publication text for the GitHub repository page,
GitHub release notes, or a pinned project announcement. It does not change the
formal claim boundary.

## English

### Short Version

**TMI-Lean Formal Library (TLFL)** is a Lean 4 formal library for
interface-event theory. It encodes the core TMI vocabulary as Lean modules:
interfaces, events, admissible transitions, records, boundaries, guarded
branches, proof-status classification, and proof-state self-modeling.

The canonical verification wording is:

```text
TLFL + External Proof Layer {Z3, Vampire, E}
```

In this chain, TLFL is the meta-interface that classifies statements by
admissible proof path, verification boundary, prover compatibility, allowed
epistemic status, and non-claim guards. Z3, Vampire, and E provide external
proof traces for selected release-boundary claims.

TLFL is not a fork of Lean and not a new proof kernel. It is a Lean 4 library
compiled and checked through the ordinary Lean kernel.

### Extended Version

TLFL is a formal library for making the status of a claim inspectable. It is
not only a place where theorem names are stored. It is an attempt to encode the
path by which a statement becomes admitted, checked, classified, guarded, and
reported.

The project starts from a simple problem. A formal system can prove a theorem,
but a reader still needs to know what kind of claim has been proved. Is it a
Lean-kernel theorem? Is it a mirrored SMT implication? Is it a first-order ATP
theorem bundle? Is it an empirical statement? Is it a guarded interpretation?
TLFL gives this distinction a formal vocabulary.

In TLFL, a claim is not treated as an isolated sentence. A claim is placed in a
proof-status context:

```text
claim
-> evidence bundle
-> admissible proof path
-> verification boundary
-> prover compatibility
-> allowed claim ceiling
-> forbidden jump map
-> public certificate / audit surface
```

This is why the library contains both ordinary Lean modules and public
proof-status artifacts. Lean checks the formal objects. Z3, Vampire, and E
mirror selected release-boundary claims. TLFL then classifies the resulting
proof state so that the reader can see what is proved, by which path, and what
must not be concluded from it.

The current development line adds a claim-passport layer. A claim passport is a
small proof-status certificate: it records the claim object, the evidence
bundle, the proof-state self-model, the allowed ceiling, and the forbidden
jumps. This lets a public artifact say “this claim has a proof-state
certificate” without silently turning that into empirical truth, physical
validation, consciousness, or empirical closure.

OLean is the admission boundary inside TLFL. It connects TLFL artifacts to Lean
without replacing Lean. OLean asks whether the required boundary is represented
as complete: encoded in Lean, checked by the Lean kernel, built by Lake, and
mirrored by the selected external proof layer where applicable. Complete
represented boundary checks return `pass`; incomplete ones return `fail`.

The self-model language is also guarded. TLFL can model a proof process as a
“thinker” in the narrow formal sense: it receives an input, builds an internal
model, checks admissibility, produces a verdict, records the result, and
projects the result into a proof-state self-model. This is a formal
proof/interface process. It is not a claim of consciousness.

The purpose of TLFL is therefore practical and epistemic: to make formal proof
packages more readable, more auditable, and less likely to overclaim. It gives
authors and reviewers a vocabulary for separating what is formally proved from
what is only guarded, interpreted, empirical, or still pending.

### What This Repository Contains

- `TMI.Library`: the canonical import surface for the public TLFL library.
- `OLean`: the Lean-kernel connection and admission interface inside TLFL.
- `OLean.SelfCheck`: a computable pass/fail boundary verdict.
- `OLean.SelfCheckAsThinker`: a formal thinker-interface check.
- `TMI.ProofStatusClassification`: classification of claims by proof path,
  boundary, prover compatibility, and permitted epistemic status.
- `TMI.ProofChainSelfModel`: proof-state self-modeling for
  `TLFL + External Proof Layer {Z3, Vampire, E}`.
- `TMI.InterfaceMathematics`: thinker, self-model, public projection, reality
  cognition, and consciousness-limit vocabularies.
- `external_proofs/`: mirrored Z3, Vampire, and E prover checks for selected
  public release-boundary claims.

### Main Formal Reading

TLFL treats a proof system not only as a collection of checked theorems, but as
a classified proof-state. It records:

- what was checked;
- which proof path was used;
- which boundary admitted the claim;
- which prover surfaces were compatible with the claim;
- which epistemic status is allowed;
- which jumps are explicitly forbidden.

This is why the project uses the phrase **proof-state self-model**. The library
does not claim that a proof artifact is empirical truth. It formalizes how a
proof artifact may be classified, admitted, checked, recorded, and guarded.

### Verification Status

The selected public boundary is checked by:

```text
Lean / Lake
Z3
Vampire
E prover
```

The external layer mirrors only selected release-boundary claims. It does not
attempt to mirror the entire Lean library in first-order logic or SMT.

### Claim Boundary

TLFL does **not** claim:

- empirical proof of TMI as physics;
- physical validation of the universe-level theory;
- consciousness;
- empirical closure;
- a new Lean kernel;
- a replacement for Z3, Vampire, or E.

TLFL does claim:

- a Lean 4 formal library for interface-event theory;
- a proof-status classification layer;
- an OLean admission boundary to Lean-kernel checking;
- a proof-state self-model for
  `TLFL + External Proof Layer {Z3, Vampire, E}`;
- guarded interface-mathematics vocabularies for thinker, public projection,
  reality cognition, and consciousness as an unreachable limit horizon.

### Citation And Author

Author: **Salkutsan Aleksey**

ORCID:

```text
https://orcid.org/0009-0006-8717-0492
```

License:

```text
Apache-2.0
```

## Русская версия

### Короткая версия

**TMI-Lean Formal Library (TLFL)** — формальная библиотека для Lean 4,
в которой интерфейсно-событийная теория записывается как набор проверяемых
модулей: интерфейсы, события, допустимые переходы, записи, границы, guarded
ветки, классификация доказательного статуса и самомодель proof-state.

Каноническая проверочная формула:

```text
TLFL + External Proof Layer {Z3, Vampire, E}
```

В этой цепочке TLFL является мета-интерфейсом классификации: он определяет
допустимый путь доказательства, границу проверки, совместимость с доказателями,
разрешенный эпистемический статус и non-claim guards. Z3, Vampire и E дают
внешние доказательные следы для выбранных release-boundary утверждений.

TLFL — не форк Lean и не новое доказательное ядро. Это библиотека Lean 4,
которая компилируется и проверяется обычным ядром Lean.

### Расширенная версия

TLFL — это библиотека для того, чтобы статус утверждения был проверяемым и
читаемым. Это не просто папка с теоремами. Это способ формально записать путь,
по которому утверждение допускается, проверяется, классифицируется,
ограничивается guards и выносится наружу как публичный доказательный материал.

Главная проблема простая. Формальная система может доказать теорему, но
читателю все равно нужно понимать, что именно доказано. Это теорема Lean-ядра?
Это SMT-проверка в Z3? Это first-order theorem bundle для Vampire/E? Это
эмпирическое утверждение? Это guarded-интерпретация? TLFL дает для этих
различий формальный словарь.

В TLFL claim не рассматривается как отдельная фраза. Он помещается в контекст
доказательного статуса:

```text
claim
-> evidence bundle
-> admissible proof path
-> verification boundary
-> prover compatibility
-> allowed claim ceiling
-> forbidden jump map
-> public certificate / audit surface
```

Поэтому библиотека содержит и Lean-модули, и публичные proof-status
артефакты. Lean проверяет формальные объекты. Z3, Vampire и E зеркалят
выбранные release-boundary утверждения. TLFL затем классифицирует полученное
доказательное состояние: что проверено, каким путем, какими доказателями, в
какой границе и с каким разрешенным эпистемическим статусом.

Текущая линия разработки добавляет claim-passport слой. Claim passport — это
небольшой сертификат доказательного статуса: он фиксирует claim object,
evidence bundle, proof-state self-model, allowed ceiling и forbidden jumps. Это
позволяет публичному артефакту сказать “у этого claim есть proof-state
certificate”, не превращая это незаметно в эмпирическую истину, физическую
валидацию, сознание или empirical closure.

OLean — это admission boundary внутри TLFL. Он подключает TLFL-артефакты к Lean,
не заменяя Lean. OLean проверяет, представлена ли граница как полная: объект
закодирован в Lean, проверен Lean-ядром, собран Lake и, где нужно, зеркально
проверен внешним proof layer. Полная представленная проверка дает `pass`,
неполная дает `fail`.

Язык самомодели также остается guarded. TLFL может моделировать доказательный
процесс как “думатель” в узком формальном смысле: он принимает вход, строит
внутреннюю модель, проверяет допустимость, выдает вердикт, записывает результат
и проецирует его в proof-state self-model. Это формальный
proof/interface-процесс. Это не утверждение о сознании.

Зачем это нужно? Чтобы формальные пакеты были понятнее, проверяемее и честнее
по границам утверждений. TLFL дает автору и рецензенту язык, который отделяет
формально доказанное от guarded-интерпретации, эмпирического claim, физической
валидации и того, что еще остается pending.

### Что содержит репозиторий

- `TMI.Library`: каноническая точка импорта публичной TLFL-библиотеки.
- `OLean`: интерфейс подключения и admission boundary к Lean-kernel checking
  внутри TLFL.
- `OLean.SelfCheck`: вычислимый вердикт `pass/fail` для граничной проверки.
- `OLean.SelfCheckAsThinker`: формальная проверка self-check как интерфейса
  “думатель”.
- `TMI.ProofStatusClassification`: классификация claim-ов по proof path,
  boundary, prover compatibility и permitted epistemic status.
- `TMI.ProofChainSelfModel`: самомодель доказательного состояния для
  `TLFL + External Proof Layer {Z3, Vampire, E}`.
- `TMI.InterfaceMathematics`: словарь для думателя, самомодели, публичной
  проекции, cognition of reality и предельного языка сознания.
- `external_proofs/`: зеркальные проверки Z3, Vampire и E prover для выбранных
  публичных release-boundary claims.

### Главный формальный смысл

TLFL рассматривает доказательную систему не только как набор проверенных
теорем, а как классифицированное доказательное состояние. Он фиксирует:

- что было проверено;
- каким proof path это прошло;
- какая граница допустила claim;
- какие prover surfaces совместимы с claim;
- какой эпистемический статус разрешен;
- какие переходы запрещены.

Поэтому в проекте используется выражение **proof-state self-model**. Библиотека
не утверждает, что доказательный артефакт уже является эмпирической истиной.
Она формализует, как proof artifact классифицируется, допускается, проверяется,
записывается и ограничивается guards.

### Статус проверки

Выбранная публичная граница проверяется через:

```text
Lean / Lake
Z3
Vampire
E prover
```

Внешний слой зеркалит только выбранные release-boundary claims. Он не пытается
переписать всю Lean-библиотеку в SMT или first-order logic.

### Граница утверждений

TLFL **не утверждает**:

- эмпирическое доказательство TMI как физики;
- физическую валидацию universe-level theory;
- сознание;
- empirical closure;
- новое ядро Lean;
- замену Z3, Vampire или E.

TLFL утверждает:

- формальную библиотеку Lean 4 для interface-event theory;
- слой классификации доказательного статуса;
- OLean admission boundary для Lean-kernel checking;
- proof-state self-model для
  `TLFL + External Proof Layer {Z3, Vampire, E}`;
- guarded vocabulary интерфейсной математики для думателя, публичной проекции,
  cognition of reality и сознания как недостижимого предельного горизонта.

### Автор и цитирование

Автор: **Salkutsan Aleksey**

ORCID:

```text
https://orcid.org/0009-0006-8717-0492
```

Лицензия:

```text
Apache-2.0
```
