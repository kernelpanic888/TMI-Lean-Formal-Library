# TMI-OS: Установка Первой Публичной Программы

Эта инструкция запускает первую публичную программу TMI-OS:

```text
Minimal block-universe model inside a self-model point
```

TMI-OS / И1 в этом релизе читается как язык программирования широкого уровня:

```text
intent -> mathematical board -> trace -> guard -> proof-status boundary
```

Программа состоит из двух частей:

```text
source:
programs/tmi_os_mathematical_board/tmi_os_virtual_space_point.i1

web board:
programs/tmi_os_mathematical_board/TMI_OS_MATHEMATICAL_BOARD.html
```

## Что Устанавливается

```text
TMI-OS Mathematical Board
= VirtualSpace
+ SelfModelPoint p
+ BlockUniverse projection B inside p
+ ProjectionSlice s
+ TimeTick tau = touch(p, s)
+ Guard boundary.
```

Это не отдельное доказательное ядро и не эмпирическое утверждение. Это первая
публичная программа на языке TMI-OS: математическая доска, где исходник `.i1`
разворачивается в читаемую веб-модель.

## Зависимости

Минимально:

```text
Git
Python 3
modern web browser
```

Для полной формальной проверки TLFL:

```text
Lean 4
Lake
TLFL repository dependencies
Z3 / Vampire / E only for external proof gates
```

## Установка Из Репозитория

Если устанавливаете из публичного fork:

```bash
git clone git@github.com:osalkutsan-godaddy/TMI-OS.git
cd TMI-OS
```

Если работаете из родительской библиотеки:

```bash
git clone git@github.com:kernelpanic888/TMI-Lean-Formal-Library.git
cd TMI-Lean-Formal-Library
```

## Запуск Математической Доски

Перейдите в папку визуализации:

```bash
cd programs/tmi_os_mathematical_board
```

Поднимите локальный read-only web server:

```bash
python3 -m http.server 8765 --bind 127.0.0.1
```

Откройте:

```text
http://127.0.0.1:8765/TMI_OS_MATHEMATICAL_BOARD.html
```

## Фильтр Перед Публикацией

Перед commit/push публичной поверхности TMI-OS запустите:

```bash
bash scripts/tmi_os_public_leak_check.sh
```

Публиковать можно только при:

```text
TMI-OS public leak check: PASS
```

Фильтр проверяет, что наружу не уезжают рабочие личные данные, локальные пути,
секреты, внутренние каталоги и непубличные маркеры.

Критерии отказа описаны здесь:

```text
docs/TMI_OS_PUBLICATION_REFUSAL_CRITERIA_RU.md
```

## Что Должно Появиться

На экране должна быть математическая доска:

```text
p = SelfModelPoint
B subset p
B = (x1, x2, x3, t)
s subset B
tau = touch(p, s)
```

Чтение:

```text
В виртуальном пространстве есть самомодель.
Самомодель - точка.
Внутри точки есть проекция блоквселенной.
Тик времени - касание точки к одному срезу.
```

## Исходник Программы

Откройте исходник:

```bash
cat programs/tmi_os_mathematical_board/tmi_os_virtual_space_point.i1
```

Канонический фрагмент:

```text
space V := VirtualSpace
domain D := ExternalDomain

self_model_point p := point("Я") inside V
block_universe B := projection(D) inside p

slice s from B.current_projection_slice
tick t := touch(p, s)
```

## Полная Проверка TLFL

В корне репозитория:

```bash
lake build TMI
lake build OLean
lake env lean lean/TMI/Regression.lean
```

Если в этой ветке присутствует модуль `SelfThinkingUniverse`:

```bash
lake build TMI.SelfThinkingUniverse
```

## Guard

```text
VirtualSpace != empirical universe
SelfModelPoint != biological subject
TimeTick != external absolute time
Mathematical board != proof by itself
TMI-OS passport != consciousness proof
```

## Минимальное Правило Установки

```text
Пишите на своем языке.
Говорите, что хотите от системы.
Система разворачивает intent в trace, board, guard и проверяемую границу.
```
