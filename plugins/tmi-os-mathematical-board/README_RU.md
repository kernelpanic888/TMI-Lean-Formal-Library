# TMI-OS Engineering Surface Plugin

Codex-плагин для первой публичной программы TMI-OS / И1.

```text
ProgramName := "Инженерная поверхность"
```

```text
CodexPlugin(TMI-OS-Board)
:= Skill(read board)
 + Asset(render math)
 + Source(read .i1)
 + Guard(block leaks)
 + Trace(explain dependency chain)
```

## Не Просто Доска

Это сильная среда системной разработки и инженерный интерфейс для
LLM/GPT-систем на базе Lean, TLFL и И1:

```text
LLM/GPT/Codex -> Lean -> TLFL -> И1
```

Формальная логика здесь читается так:

```text
formal logic := language for building canonical records with passports
```

Верхний принцип:

```text
LogicRoot := source(FormalLogic, CanonicalRecord, Passport, Guard, Trace, Action)
```

Авторское чтение:

```text
логика как верхний источник построения; всё построение истекает из неё
```

Формула живой инженерной среды:

```text
OperationallyLive(I1)
:= runnable
 + readable
 + versioned
 + guarded
 + passported
 + extensible_in_use
```

Guard:

```text
LogicRoot != theological proof
OperationallyLive(I1) != biological life claim
```

Рабочая цепочка:

```text
intent -> formal surface -> guard -> trace -> readable model action
```

Доска является визуальной проекцией, но плагин является инженерным протоколом:
он говорит Codex, что читать, как проверять, где граница публикации, как
сохранять доменный порядок и как не поднимать claim выше proof-status boundary.

## Зависимости

```text
Codex Desktop
LLM/GPT working context
Lean boundary
TLFL proof-status layer
И1 guarded-action layer
domain-order preservation
.codex-plugin/plugin.json
skills/tmi-os-mathematical-board/SKILL.md
assets/index.html
assets/tmi_os_virtual_space_point.i1
scripts/verify_board_export.sh
bash
python3
```

Смысловая цепочка:

```text
Intent
-> Matrix((Я)-Я-я)
-> TLFL
-> Lean/OLean
-> ProofStatus
-> Guard
-> Trace
-> MathematicalBoard
-> {Z3, Vampire, E}
```

## Локальный Просмотр

```bash
cd assets
python3 -m http.server 8765 --bind 127.0.0.1
```

Открыть:

```text
http://127.0.0.1:8765/index.html
```

## Проверка

```bash
bash scripts/verify_board_export.sh
```

Ожидаемый результат:

```text
TMI-OS export verification: PASS
```
