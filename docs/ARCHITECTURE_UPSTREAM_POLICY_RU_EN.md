# TLFL Architecture and Upstream Policy / Архитектура TLFL и upstream

## RU

TLFL является самостоятельным пакетом Lean 4, а не постоянным форком Lean или
Mathlib.

```text
Lean 4 kernel
      |
   dependencies
      |
     TLFL
      |
OLean / TMI-OS / readers / experiments
```

Отдельный репозиторий используется, когда проект:

- вводит собственные пространства имён и теорию;
- имеет самостоятельную историю релизов;
- зависит от родительских библиотек, но не изменяет их;
- сохраняет собственную границу утверждений.

Форк используется только как временный мост, когда конкретное изменение
предназначено для обратного слияния в upstream. Публичность репозитория
разрешает предложить изменение, но не создаёт обязанности владельца принять
или рассмотреть его.

## EN

TLFL is an independent Lean 4 package, not a permanent fork of Lean or Mathlib.

```text
Lean 4 kernel
      |
   dependencies
      |
     TLFL
      |
OLean / TMI-OS / readers / experiments
```

An independent repository is appropriate when the project:

- introduces its own namespaces and theory;
- has an independent release history;
- depends on parent libraries without modifying them;
- maintains its own claim boundary.

A fork is used only as a temporary bridge when a concrete change is intended
for upstream merge. A public repository permits a contribution proposal, but
does not oblige its owner to accept or review it.
