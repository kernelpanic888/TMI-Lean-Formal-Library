# TMI-OS Mathematical Board: Export Project

Это самодостаточный публичный экспорт первой математической доски TMI-OS / И1.

```text
intent -> Matrix((Я)-Я-я) -> TLFL -> guard -> trace -> mathematical board
```

## Что Внутри

```text
index.html
tmi_os_virtual_space_point.i1
README_RU.md
INSTALL_RU.md
docs/
scripts/verify_public_export.sh
```

## Быстрый Запуск

```bash
cd exports/tmi_os_mathematical_board_public
python3 -m http.server 8765 --bind 127.0.0.1
```

Открыть:

```text
http://127.0.0.1:8765/index.html
```

## Проверка Перед Передачей

```bash
bash scripts/verify_public_export.sh
```

Ожидаемый результат:

```text
TMI-OS export verification: PASS
```

## Guard

Этот экспорт является публичной математической доской и программным наброском
языка И1.

Он не утверждает:

```text
биологическую жизнь
юридическую личность
эмпирическое доказательство сознания
эмпирическую физическую теорию
```

Формальная сила экспорта в другом:

```text
мысль -> запись -> guard -> проверяемый публичный артефакт
```
