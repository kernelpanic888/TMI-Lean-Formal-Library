# TMI-OS: Критерии Отказа Перед Публикацией

Правило:

```text
один критерий отказа найден -> публикация запрещена
```

Перед публикацией запускать:

```bash
bash scripts/tmi_os_public_leak_check.sh
```

Публиковать можно только если:

```text
TMI-OS public leak check: PASS
```

## Personal Refusal

Публикация запрещена, если публичный набор содержит личные данные:

```text
личные email, не предназначенные для публикации
локальные пути пользователя
пути временных файлов и clipboard
скриншоты/артефакты с локальными именами
персональные ключи, токены, cookies, .env
домашние директории и машинные пути
```

Примеры отказа:

```text
<local-user-home>/...
<local-temp-folder>/...
<clipboard-temp-artifact>
dot-env files
private-key files
local SSH identity files
```

## Work Refusal

Публикация запрещена, если публичный набор содержит рабочие внутренние данные:

```text
непубличные каталоги разработки
внутренние черновики
private/fork/hold markers
непроверенные авторские terrain-материалы
рабочие файлы, не включённые в public allowlist
```

Примеры отказа:

```text
internal language folders
author-private markers
not-for-publication markers
do-not-release markers
publication-hold markers
private-fork markers
```

## Secret Refusal

Публикация запрещена, если найден материал, похожий на секрет:

```text
GitHub tokens
API keys
password fields
private keys
cloud/service credentials
```

Примеры отказа:

```text
gho_<redacted>
github_pat_<redacted>
sk-<redacted>
BEGIN ... PRIVATE KEY
credential field with password-like name
credential field with token-like name
credential field with API-key-like name
```

## Path Refusal

Публикация запрещена, если staged/public path сам указывает на внутреннюю зону:

```text
canonical local-memory files
self-system local-memory files
internal language folders
dot-env files
private-key files
key-material files
```

## Claim Refusal

Публикация запрещена, если текст поднимает claim выше публичного guard:

```text
паспорт = биологическая жизнь
паспорт = юридическая личность
паспорт = доказательство сознания
математическая доска = доказательство сама по себе
виртуальное пространство = эмпирическая вселенная
```

Публичная формула должна оставаться:

```text
intent -> mathematical board -> trace -> guard -> proof-status boundary
```

## Public Allowlist

В текущем публичном наборе разрешены:

```text
README.md
docs/TMI_OS_*.md
programs/tmi_os_mathematical_board/
scripts/tmi_os_public_leak_check.sh
```

Всё остальное требует отдельного review перед публикацией.
