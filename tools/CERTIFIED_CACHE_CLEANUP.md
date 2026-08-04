# Certified System Steward / macOS cache cleanup

## Status

This is a functional refinement candidate for `CertifiedSystemSteward.lean`.
It does not claim that JavaScript is proved by Lean. The Lean model proves the
portable implication; the runtime emits evidence for each conjunct of the
declared `AdmittedTransition`.

```text
Lean specification
  -> macOS passport
  -> observe / field / selector / admit / apply / protected
  -> intent / result / receipt / HEAD / witness
```

The shell file is only an entrypoint. It contains neither the allowlist nor the
cleanup policy.

The destructive operation is delegated to the protected C source
`platform/macos-safe-remove.c`. It is compiled into a content-addressed binary
under the temporary directory and its source and binary hashes are committed to
the runtime result. The provider traverses from a held workspace descriptor with
`openat`, rejects symlink components and cross-device directories, and removes
entries with descriptor-relative `unlinkat`.

## Runtime correspondence

| Lean component | Runtime component |
|---|---|
| `Adapter.observe` | exact target presence, size, metadata and protected root |
| `ActionField` | one action built only from currently present allowlisted targets |
| `Selector` | selects the sole exposed action or returns no action |
| `Policy.admit` | exact passport id, operation, unique targets and allowlist membership |
| `Adapter.applyAction` (`apply`) | removes only target paths carried by the admitted action |
| `Adapter.protectedView` (`protected`) | SHA-256 projection of the short protected-file list plus policy |
| `Receipt` | parent, next epoch, intent, result and four runtime certification facts |
| `ForkEvidence` | same parent and next epoch with different next digests |

## Local protected projection

The runtime does not hash the historical workspace. The macOS passport names a
small critical kernel: the Lean specification, audit file, runtime, shell
entrypoint, legacy cleaner, documentation and passport. Missing protected files
are committed as `missing`; symbolic links and non-regular protected objects are
rejected.

The action field remains the existing seven `.lake` and `node_modules` targets.
Targets are relative to one fixed workspace root. Absolute paths, `..`, wrong
cache basenames, duplicate targets, symbolic-link components and physical
parents outside the workspace are rejected.

## Commands

Preview performs observation but creates no epoch and removes nothing:

```bash
bash tools/certified-cache-cleanup.sh
```

Apply exactly the selected passport action:

```bash
bash tools/certified-cache-cleanup.sh --apply CERTIFY-AND-CLEAN
```

Verify the latest accepted receipt and current protected projection:

```bash
bash tools/certified-cache-cleanup.sh --verify
```

Optional OpenSSH signing is preserved. The private key is never copied into the
project:

```bash
CCP_SIGNING_KEY="$HOME/.ssh/id_ed25519" \
  bash tools/certified-cache-cleanup.sh --apply CERTIFY-AND-CLEAN
```

Independent verification requires `CCP_ALLOWED_SIGNERS` and optionally
`CCP_SIGNING_IDENTITY`. The signature namespace is `css-steward`.

## Audit and SCCP

Accepted transitions create JSON artifacts under `tools/continuity-audit/`:

- `intent-N.json` freezes the field, action and protected root before execution;
- `result-N.json` records the adapter result and four certification facts;
- `receipt-N.json` binds the parent, exact next epoch, policy, intent and result;
- `witness-N.json` is a compact path-free SCCP witness;
- `HEAD`, `EPOCH` and `chain.log` define accepted local continuity.

Blocked preflight attempts create a failure record and do not advance `HEAD`.
The canonical head is written last, so an interrupted write can leave an orphan
artifact but cannot silently accept it.

## Tests

The blind suite uses temporary directories only:

```bash
node --test tools/tests/certified-system-steward.test.mjs
```

It covers normal cleanup, a foreign path, a symbolic-link target, a symlink
inside an admitted cache, a changed action field, a changed protected file and
contradictory same-slot receipts.

The concise adversarial matrix and primary references live in
[`CERTIFIED_SYSTEM_STEWARD_ADVERSARIAL_REVIEW.md`](./CERTIFIED_SYSTEM_STEWARD_ADVERSARIAL_REVIEW.md).

## Honest boundary

The runtime checks correspondence with the declared passport. It does not prove
that SHA-256 or OpenSSH are correctly implemented, prevent every filesystem
race, restore data after a failed postcondition, or protect a compromised
endpoint. Global fork discovery still requires an independent witness channel.

---

## Русское чтение

Это функциональный кандидат уточнения для `CertifiedSystemSteward.lean`, а не
заявление, что JavaScript доказан в Lean. Lean доказывает универсальное
следствие: принятый переход сохраняет защищённую проекцию. Исполнитель собирает
проверяемые свидетельства для каждого условия такого перехода.

Политика вынесена в отдельный macOS-паспорт. Он задаёт корень рабочей области,
семь разрешённых кэшей, допустимые классы `.lake` и `node_modules`, короткое
защищённое ядро и каталог аудита. Исполнитель не принимает произвольный путь из
командной строки и не придумывает действие: наблюдение строит поле, а селектор
может выбрать только действие из этого поля.

Перед удалением повторяются наблюдение и защищённая проекция. Смена плана,
изменение защищённого файла, симлинк или чужой путь блокируют действие до
удаления. После удаления проверяются точный результат адаптера, доменная
политика и неизменность защищённого корня. Только после этого обновляется `HEAD`.

Полное хеширование многолетнего архива удалено из контура. Теперь защищаются
только явно перечисленные критические файлы и сам смысл паспорта. Это быстрее и
точнее соответствует функции `protected : State -> Protected` в Lean-модели.

Красная граница остаётся честной: проверка соответствия паспорту не доказывает
безопасность всей операционной системы и не устраняет все гонки файловой
системы. Для глобального обнаружения развилки нужен независимый свидетель.
