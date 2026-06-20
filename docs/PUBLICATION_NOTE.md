# Publication Note

## English

TMI-Lean Formal Library (TLFL) 0.1 is a Lean 4 formal library for interface-event
theory. It collects the current formal TMI surfaces into an exportable package
with a canonical import, `TMI.Library`, and a connection interface, `OLean`.

The role of OLean is deliberately modest. It does not replace Lean and does
not introduce a new proof kernel. It describes how a TMI artifact obtains
formal Lean status: the artifact is encoded as a Lean object and checked by
the Lean kernel.

This updated package adds `OLean.SelfCheck`, which passes the library through
its own boundary-verification interface and records the result as an internal
interface frequency. The reused light-gradient value `G4/749` means complete
Lean/Lake + Z3 + Vampire + E verification of the release boundary. It is not a
claim about physical light emission and not a claim of empirical closure.

The same module also provides `OLean.boundaryCheckVerdict`, a computable
pass/fail verdict: complete represented boundary verification returns `pass`,
and incomplete verification returns `fail`.

The publication package is also synchronized with `OLean.SelfCheckAsThinker`.
This module verifies the complete self-check as a TMI thinker interface:
boundary input, internal model, admissibility test, verdict, and recorded
result. It also lifts the checked self-model to a guarded mathematical
external prover interface. This is still a formal proof-interface result, not
empirical physical validation.

The package now also fixes `TLFL + External Proof Layer {Z3, Vampire, E}` as the canonical proof-chain
self-model. Z3, Vampire, and E provide external proof traces; TLFL classifies
those traces by proof path, verification boundary, prover compatibility, and
allowed epistemic status.

Canonical Zenodo DOI:

```text
https://doi.org/10.5281/zenodo.20773095
```

The Zenodo package is synchronized with the canonical GitHub source
repository:

```text
https://github.com/kernelpanic888/TMI-Lean-Formal-Library
```

Source snapshot:

```text
4be975e37df910f45c1d38e6ac1a4dfa6ee6b211
Salkutsan Aleksey <kernelpanic888@gmail.com>
```

License:

```text
Apache-2.0
```

## Russian

TMI-Lean Formal Library (TLFL) 0.1 -- формальная библиотека для Lean 4, в которой
TMI записывается как проверяемый набор модулей: интерфейс, событие, допустимый
переход, запись, граница, bridge, ветки и proof targets.

`OLean` -- рабочее название интерфейса подключения TMI к Lean. Это не форк
Lean и не новое ядро. Это слой подключения, через который TMI-артефакт
получает формальный статус только после кодирования в Lean и проверки ядром
Lean.

В обновленный пакет добавлен `OLean.SelfCheck`: библиотека проходит через
собственный интерфейс граничной проверки, а результат записывается как
внутренняя частота интерфейса. Значение `G4/749` означает полную проверку
границы Lean/Lake + Z3 + Vampire + E. Это не утверждение о физическом свете и
не утверждение об эмпирическом замыкании теории.

Этот же модуль предоставляет `OLean.boundaryCheckVerdict` - вычислимый
вердикт `pass/fail`: полная представленная граничная проверка возвращает
`pass`, а неполная проверка возвращает `fail`.

Публикационный пакет также синхронизирован с `OLean.SelfCheckAsThinker`.
Этот модуль проверяет полный self-check как TMI-интерфейс “думатель”:
граничный вход, внутренняя модель, проверка допустимости, вердикт и запись
результата. Он также поднимает проверенную самомодель до guarded-интерфейса
математического внешнего доказателя. Это остается формальным результатом
proof-interface, а не эмпирической физической валидацией.

Пакет теперь также фиксирует `TLFL + External Proof Layer {Z3, Vampire, E}` как каноническую самомодель
доказательного состояния. Z3, Vampire и E дают внешние доказательные следы;
TLFL классифицирует эти следы по proof path, verification boundary, prover
compatibility и allowed epistemic status.

Канонический DOI Zenodo:

```text
https://doi.org/10.5281/zenodo.20773095
```

Zenodo-пакет синхронизирован с каноническим GitHub-репозиторием:

```text
https://github.com/kernelpanic888/TMI-Lean-Formal-Library
```

Исходный снимок:

```text
4be975e37df910f45c1d38e6ac1a4dfa6ee6b211
Salkutsan Aleksey <kernelpanic888@gmail.com>
```

Лицензия:

```text
Apache-2.0
```
