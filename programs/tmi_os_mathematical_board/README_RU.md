# TMI-OS Mathematical Board

Первая публичная программа TMI-OS / И1.

TMI-OS / И1 - язык программирования широкого уровня:

```text
intent -> mathematical board -> trace -> guard -> proof-status boundary
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

tau := touch(p, s)
TimeTick(tau) := SelfModelContact(p, s)
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
```

## Guard

```text
VirtualSpace != empirical universe
SelfModelPoint != biological subject
TimeTick != external absolute time
Mathematical board != proof by itself
TMI-OS passport != consciousness proof
```
