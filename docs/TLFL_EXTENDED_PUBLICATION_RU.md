# TMI-Lean Formal Library (TLFL): что это и зачем нужно

## Короткая формула

TMI-Lean Formal Library (TLFL) — формальная библиотека для Lean 4, в которой
интерфейсно-событийная теория и классификация доказательного статуса
записываются как проверяемые модули. Это не форк Lean и не новое доказательное
ядро. Библиотека проверяется обычным ядром Lean, а выбранные release-boundary
утверждения зеркально проверяются через Z3, Vampire и E.

Каноническая публичная формула проверки:

```text
TLFL + External Proof Layer {Z3, Vampire, E}
```

## Зачем существует TLFL

Доказательный артефакт не всегда сам объясняет свой статус. Теорема, модель,
SMT-запрос или результат ATP могут быть корректны внутри своей технической
границы, но все равно оставлять вопрос: что именно теперь установлено?

TLFL формализует эту границу.

Он спрашивает:

- какое утверждение проверяется;
- какой evidence bundle допускает это утверждение;
- какой путь доказательства использован;
- какой проверяющий инструмент участвовал;
- какой максимальный статус разрешен для claim;
- какие выводы прямо запрещены;
- как показать это публично без overclaim.

В этом смысле TLFL — мета-интерфейс доказательного статуса. Он не заменяет
Lean, Z3, Vampire или E. Он классифицирует proof-state, который эти инструменты
помогают получить.

## Главная идея

TLFL рассматривает claim не как отдельную фразу, а как часть структурированного
процесса:

```text
claim
-> evidence bundle
-> admissible proof path
-> verification boundary
-> prover compatibility
-> allowed claim ceiling
-> forbidden jump map
-> proof-state self-model
-> public certificate / audit surface
```

Так proof package становится читаемым. Читатель видит не только, что нечто
прошло проверку, но и какой именно это pass, в какой границе он действует и
чего из него нельзя заключать.

## OLean

OLean — это интерфейс подключения и admission boundary внутри TLFL. Он
подключает TLFL-артефакты к проверке ядром Lean. OLean не вводит новое ядро.

OLean проверяет, представлена ли граница как полная:

```text
encoded in Lean
+ checked by Lean kernel
+ built by Lake
+ represented external proof layer where required
+ no new kernel introduced
```

Полная представленная проверка возвращает `pass`; неполная возвращает `fail`.

## Proof-State Self-Model

TLFL также формализует proof-state self-model. Это означает, что система
записывает структурированную модель собственного доказательного статуса:

```text
external proof traces
+ OLean admission boundary
+ TLFL classification
+ proof-state maps
+ non-claim guards
-> proof-state self-model
```

Это не сознание и не эмпирическая истина. Это структурированное знание о
доказательном статусе.

## Claim Passport

Слой claim passport превращает claim и его proof-state boundary в публичный
сертификат. Паспорт фиксирует:

- claim object;
- evidence bundle;
- Lean trace;
- Z3/Vampire/E traces там, где они применимы;
- TLFL classification;
- proof-state self-model;
- allowed claim ceiling;
- forbidden jumps.

Public certificate и audit sheet позволяют читателю проверить статус claim, не
поднимая этот claim выше допустимой границы.

## Что TLFL утверждает

TLFL утверждает:

- формальную библиотеку Lean 4 для interface-event theory;
- OLean admission boundary для Lean-kernel checking;
- слой классификации proof-status;
- слой proof-state self-model;
- claim passports, public certificates, audit sheets, review gates и release
  gates для proof-status reporting;
- внешние proof mirrors для выбранных release-boundary claims.

## Чего TLFL не утверждает

TLFL не утверждает:

- эмпирическое доказательство TMI как физики;
- физическую валидацию universe-level claims;
- сознание;
- empirical closure;
- новое ядро Lean;
- замену Z3, Vampire или E;
- что вывод внешнего доказателя сам по себе достаточен для полного формального
  статуса.

## Почему это важно

TLFL полезен там, где формальному проекту недостаточно просто набора файлов с
теоремами. Он дает словарь для proof status, claim ceilings, forbidden jumps,
public audit surfaces и воспроизводимых verification boundaries.

Цель TLFL практическая и эпистемическая: сделать proof packages более
понятными, проверяемыми и защищенными от неправильного чтения.

## Автор

Salkutsan Aleksey

ORCID:

```text
https://orcid.org/0009-0006-8717-0492
```

Репозиторий:

```text
https://github.com/kernelpanic888/TMI-Lean-Formal-Library
```
