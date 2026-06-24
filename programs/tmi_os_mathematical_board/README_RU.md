# Инженерная Поверхность

Первая публичная программа TMI-OS / И1.

```text
ProgramName := "Инженерная поверхность"
```

TMI-OS / И1 - язык программирования широкого уровня и сильная среда системной
разработки на базе LLM/GPT/Codex -> Lean -> TLFL -> И1:

```text
intent -> mathematical board -> trace -> guard -> proof-status boundary
```

```text
ProgrammingOnMathematics :=
  Intent -> FormalLogic -> CanonicalRecord -> Passport -> GuardedAction
```

## Что Это

```text
Minimal block-universe model inside a self-model point
```

Математическая формула:

```text
V : VirtualSpace
p in V
p : SelfModelPoint

D : ExternalDomain
B := projection(D)
B subset p

B = (x1, x2, x3, t)
s subset B
domain_order(d1, d2) -> slice_order(projection(d1), projection(d2))

tau := touch(p, s)
TimeTick(tau) := SelfModelContact(p, s)

SlicePassport(p, s, tau) :=
  ProjectionSlice(s)
  and read(p, s)
  and tau = touch(p, s)
  and CanonicalRecord(s)
  and PassportBoundary(s)
```

## Файлы

```text
tmi_os_virtual_space_point.i1
TMI_OS_MATHEMATICAL_BOARD.html
```

## Запуск

Из корня репозитория:

```bash
cd programs/tmi_os_mathematical_board
python3 -m http.server 8765 --bind 127.0.0.1
```

Открыть:

```text
http://127.0.0.1:8765/TMI_OS_MATHEMATICAL_BOARD.html
```

## Что Можно Программировать На И1 / TMI-OS

```text
intent formulas
mathematical boards
self-model point/slice/tick diagrams
proof-status passports
guard contracts
formal idea visualizations
installation and verification traces
domain-order preserving model interfaces
slice-passport current-state records
```

## Зависимости Языка

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

## Guard

```text
VirtualSpace != empirical universe
SelfModelPoint != biological subject
TimeTick != external absolute time
Mathematical board != proof by itself
TMI-OS passport != consciousness proof
```
