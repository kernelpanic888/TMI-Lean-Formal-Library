# TMI-OS Mathematical Board Plugin

Codex-плагин для первой публичной математической доски TMI-OS / И1.

```text
CodexPlugin(TMI-OS-Board)
:= Skill(read board)
 + Asset(render math)
 + Source(read .i1)
 + Guard(block leaks)
 + Trace(explain dependency chain)
```

## Не Просто Доска

Это интерфейс программирования для LLM-систем:

```text
intent -> formal surface -> guard -> trace -> readable model action
```

Доска является визуальной проекцией, но плагин является рабочим протоколом:
он говорит Codex, что читать, как проверять, где граница публикации и как не
поднимать claim выше proof-status boundary.

## Зависимости

```text
Codex Desktop
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
