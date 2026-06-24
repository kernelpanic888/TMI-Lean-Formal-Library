# TMI-OS: Первая Публичная Программа

TMI-OS / И1 здесь читается как язык программирования широкого уровня:

```text
intent -> mathematical board -> trace -> guard -> proof-status boundary
```

Имя программы:

```text
TMI-OS Mathematical Board
```

Короткое чтение:

```text
математическая доска
самомодель-точка
блоквселенная как внутренняя проекция
тик как касание точки к срезу
```

## Файлы

```text
program source:
programs/tmi_os_mathematical_board/tmi_os_virtual_space_point.i1

web board:
programs/tmi_os_mathematical_board/TMI_OS_MATHEMATICAL_BOARD.html

installation:
docs/TMI_OS_INSTALL_RU.md
```

## Формула

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

## Почему Это Программа

В TMI-OS программирование начинается не с чужого синтаксиса, а с intent:

```text
intent "взять виртуальное пространство и оставить только математику"
```

Дальше intent разворачивается:

```text
intent
-> typed objects
-> model relation
-> tick
-> claim
-> guard
-> visual board
```

## Публичная Граница

Эта программа публична как математическая доска и language-surface example.
Она не публикует непубличные материалы и не поднимает claim выше
proof-status boundary.

Перед публикацией:

```bash
bash scripts/tmi_os_public_leak_check.sh
```
