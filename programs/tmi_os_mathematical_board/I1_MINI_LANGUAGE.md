# И1 Mini Language

Минимальное ядро языка для сайта TMI-OS.

```text
Language := И1
Mode := small kernel now, grows in use
Rule := write in the language you think in
Boundary := NoLogin + NoServerUpload + GuardedAction
```

## Цепочка

```text
LLM/GPT/Codex -> Lean -> TLFL -> И1
```

```text
ProgrammingOnMathematics :=
  Intent -> FormalLogic -> CanonicalRecord -> Passport -> GuardedAction
```

## Команды

```text
intent "<что хочу от системы>"
```

Задает человеческое намерение.

```text
point <name> := SelfModelPoint
```

Создает точку самомодели.

```text
domain <name> := ExternalDomain
```

Задает внешний домен, который будет проецироваться.

```text
slice <name> from <domain>
```

Создает срез домена.

```text
touch <point> <slice> as <tick>
```

Создает тик как касание точки к срезу.

```text
guard <claim>
```

Фиксирует границу: что нельзя заявлять выше proof-status.

```text
passport <name>
```

Собирает читаемый паспорт текущей модели.

```text
run board
run artifact3d
run protected_page
```

Открывает соответствующий артефакт.

## Пример

```text
intent "Показать мой домен как срез памяти внутри SelfModelPoint."

point p_author := SelfModelPoint
domain D_author := ExternalDomain
slice s_current from D_author

touch p_author s_current as tau

guard "board artifact != empirical proof"
guard "passport != biological/legal/consciousness claim"

passport MyModel
run artifact3d
```

## Guard

```text
И1 mini language != full compiler
И1 mini language != proof by itself
Protected page != login system
User intent != automatic public claim
```

Дальше язык пишется в процессе использования: команда появляется тогда, когда
она стала нужна поверхности и прошла guard.
