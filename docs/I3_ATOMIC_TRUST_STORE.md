# I³-L06: Atomic Trust Store

`I³-L06` closes the local two-writer race left open by the persistent trust
head.  It does not replace the Lean admission model with shell logic.  The
runtime obtains the lock, rereads the current snapshot, verifies the existing
Lean predicate and cryptographic binding inside the critical section, and only
then publishes the formally selected successor.

## Contract

```text
AtomicHeadMatches(S, g, h) := g = S.generation ∧ h = S.trust.receiptHead

ReceiptCASReady(S, i) :=
  AtomicHeadMatches(S, i.expectedGeneration, i.expectedReceiptHead)
  ∧ PersistentAdmissible(S.trust, i.request, i.receipt, i.signature)

commit(S, i) :=
  if ReceiptCASReady(S, i)
  then { generation := S.generation + 1, trust := admitted successor }
  else S
```

The same compare-and-swap gate is used for signed key rotation.

## Runtime sequence

```text
exclusive lock directory
  -> reread current snapshot
  -> compare generation and receipt HEAD
  -> verify request/receipt or rotation signature
  -> evaluate Lean admission predicate
  -> write same-directory temporary snapshot
  -> atomic rename over the old snapshot
  -> release lock
```

`i3_trust_tx request` emits the exact generation and HEAD that must accompany
the later commit.  Multiple readers may propose work, but only one writer can
publish a successor for a given generation.

## Commands

```text
i3_trust_tx init <store-file> <persistent-trust-file>
i3_trust_tx request <store-file> <request-file> <nonce>
i3_trust_tx commit-receipt <public-key> <store-file> <request-file> <receipt-file> <signature-file> <expected-generation> <expected-head>
i3_trust_tx commit-rotation <old-public-key> <store-file> <rotation-file> <signature-file> <expected-generation> <expected-head>
i3_trust_tx show <store-file>
```

The signing and verification executables require OpenSSL 3 with Ed25519
`pkeyutl -rawin` support.  A legacy LibreSSL binary must not be selected by
`PATH`.

## Blind concurrency audit

Two independent receipt writers were started with the same generation and
HEAD.  Exactly one returned `ADMIT`; the other returned `HOLD`.  Replaying the
losing intent returned a stale compare-and-swap result.  A manually occupied
lock also failed closed.  The same race was repeated with two incompatible,
validly signed key rotations: one rotation advanced the generation and key
epoch, while the other remained unapplied.  No `.next` file or lock directory
remained after either completed race.

## Red boundary

- Same-directory `rename` gives atomic visibility on the supported local
  filesystem, but this layer does not call `fsync`; power-loss durability is
  not claimed.
- A crashed writer can leave a stale lock directory.  Automatic lock stealing
  is intentionally absent because ownership cannot yet be proved.
- Local locking does not detect rollback of the whole filesystem snapshot.
- The operating system, key files, SHA-256, and Ed25519 remain trusted runtime
  dependencies rather than objects whose security is proved by Lean.
- This is a continuity and admission mechanism, not evidence of consciousness,
  digital life, or true AI.
