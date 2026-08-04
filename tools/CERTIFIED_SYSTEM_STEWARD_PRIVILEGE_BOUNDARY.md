# CSS-03 / Privilege boundary passport

Status: formal contract and blind protocol tests. Not yet an installed macOS helper.

## Claim

The client that selects a cache target must not possess the authority used to
mutate the private quarantine. A valid transition therefore requires two
different principals:

```text
client selector -> authenticated XPC channel -> launchd root helper
       request                                      observation
          \---------------- bound receipt ----------------/
```

The receipt payload cannot authenticate itself. Root authority and code
identity must arrive as trusted channel facts supplied by macOS.

## Formal core

For a quarantine resource `q`, client `c`, helper `h`, and write relation `W`:

```text
W(h, q) and not W(c, q)  ->  c != h
```

An admitted helper transition additionally binds the exact request, preserves
the protected digest, preserves target identity across quarantine, and rejects
public-name reappearance.

Lean source:
`CertifiedSystemStewardPrivilegeBoundary.lean`

## Runtime-neutral protocol

`certified-system-steward-helper-protocol.mjs` verifies:

1. Exact request digest, policy digest, target identity and nonce.
2. XPC as the transport.
3. Root peer identity supplied outside the receipt payload.
4. A matching helper code requirement supplied outside the receipt payload.
5. Stable protected state and object identity.
6. Completed quarantine and deletion with no source-name reappearance.
7. Single consumption of every client UID and nonce pair.

The protocol deliberately does not accept a JSON field such as
`"peerEuid": 0` as authority evidence.

## Primary platform anchors

- [Apple Service Management](https://developer.apple.com/documentation/servicemanagement/):
  launch daemons run in the system context and receive low-level requests such
  as XPC.
- [Apple: updating helper executables](https://developer.apple.com/documentation/servicemanagement/updating-helper-executables-from-earlier-versions-of-macos):
  macOS 13+ uses `SMAppService`; a launch daemon requires user authorization.
- [Apple XPC updates](https://developer.apple.com/documentation/updates/xpc):
  XPC supports peer entitlement, platform identity, team identity and code
  requirement checks.
- [Apple TN3127](https://developer.apple.com/documentation/technotes/tn3127-inside-code-signing-requirements):
  code-signing requirements establish executable identity and can restrict XPC
  clients.
- [MITRE CWE-362](https://cwe.mitre.org/data/definitions/362.html):
  concurrent access to shared resources requires synchronization and least
  privilege.

## Red boundary

This slice does not install, sign or authorize a launch daemon. It proves and
tests the protocol that such a daemon must implement. Until an `SMAppService`
daemon and authenticated XPC transport exist, the operational system remains
at CSS-02. No claim of same-UID adversary isolation is made.

## Русское чтение

Клиент выбирает действие, но не должен владеть карантином. Помощник владеет
карантином, но принимает только запрос, прошедший политику, проверку личности
объекта и проверку XPC-пира средствами macOS. Квитанция связывает запрос и
наблюдаемый результат, но сама не создаёт полномочия.

Следующий шаг: упаковать подписанный `LaunchDaemon` в приложение, зарегистрировать
его через `SMAppService`, проверить XPC-пира по code requirement и повторить тот
же слепой корпус уже через физический канал.
