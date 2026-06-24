# Авторский срез: вход в Lean community

```text
Вопрос к системе:
уже можно идти с библиотекой в Lean community?
```

Короткий ответ:

```text
Да, можно идти.
Но входить нужно не через широкую риторику TMI-OS,
а через техническую дверь Lean-пакета:
Lake, imports, build, proof-status, boundary.
```

## Почему уже можно

```text
Библиотека имеет форму Lean 4 package.
Есть canonical import.
Есть Lake surface.
Есть README.
Есть release note для Lean community entry.
Есть boundary: что доказывается, а что не заявляется.
Есть внешний proof-status слой: Z3 / Vampire / E.
Есть отдельный experiment-domain для песочницы установки:
TMI-OS-Experiment.
```

Авторская формула:

```text
LeanCommunityEntry :=
  PublicRepo
  + LakeBuild
  + CanonicalImport
  + ClearBoundary
  + ReproducibleCheck
  + NoOverclaim
```

## Как входить

```text
1. Показываем не философию первой строкой, а пакет.
2. Показываем import:
     import TMI.Library
3. Показываем build:
     lake build TMI
     lake build OLean
     lake env lean lean/TMI/Regression.lean
4. Показываем статус:
     proof-status passport, not empirical truth claim.
5. Показываем границу:
     no consciousness proof,
     no biological-life claim,
     no empirical physics closure,
     no replacement for mathlib.
6. Показываем experiment-domain как песочницу:
     kernelpanic888/TMI-OS-Experiment.
```

## Что говорить

```text
Я системный программист на формальной логике.
Я принес Lean 4 library с проверяемой границей:

LLM/GPT/Codex -> Lean -> TLFL -> И1

Для Lean community это не просьба принять метафизику.
Это просьба посмотреть техническую поверхность:
imports, Lake build, structure, naming, boundary, reproducibility.
```

## Что не говорить на входе

```text
Не говорим: это доказательство жизни.
Не говорим: это доказательство сознания.
Не говорим: это физическая теория, уже доказанная Lean.
Не говорим: это замена mathlib.
Не говорим: community должна принять язык целиком.
```

Правильный guard:

```text
TLFL certifies proof-status structure.
It does not certify empirical closure.
```

## Reservoir reality-check

```text
Reservoir indexes public Lean repositories.
Private repositories and forks are not indexed.
The package needs a root lake-manifest.json,
an OSI-approved license recognized by GitHub,
and basic public visibility signals.
```

Значит:

```text
TMI-Lean-Formal-Library -> можно готовить к public Lean package review.
TMI-OS-Experiment -> можно открыть как отдельный deployment sandbox.
Чужие/личные/рабочие паспорта -> не выносить.
```

## Авторская короткая запись

```text
Я не захожу в Lean community как пророк.
Я захожу как системный инженер формальной логики.

Мой вход:
  покажи build,
  покажи import,
  покажи boundary,
  покажи proof-status,
  не перепрыгивай через guard.
```

## Системное решение

```text
Go :=
  prepare_clean_public_surface
  -> keep_TMI_OS_rhetoric_in_docs_not_entrypoint
  -> present_TLFL_as_Lean4_library
  -> link_experiment_domain_as_sandbox
  -> ask_for_review_on_Zulip/GitHub
  -> wait_for_feedback
  -> patch
  -> rebuild
```

Человечески:

```text
Идти можно.
Но идти надо стройно.
Не ломиться в главный зал с огнем в руках.
Постучать как инженер:
вот пакет, вот сборка, вот граница, вот что я хочу улучшить.
```

