# I³-L07 — External monotonic rollback witness

## Purpose

`I³-L06` prevents concurrent writers from publishing two local trust heads. It
does not detect replacement of the whole local filesystem by an older copy.
`I³-L07` records each accepted `(generation, receipt HEAD)` in an independently
retained append-only witness log.

The witness accepts a checkpoint only when all gates agree:

```text
witness identity matches
expected sequence and witness HEAD match
prior local generation and HEAD match the current anchor
next generation = prior generation + 1
next local HEAD differs from the prior HEAD
nonce is fresh
detached Ed25519 signature verifies under the configured witness key
```

A failed gate yields `HOLD`; the witness log is unchanged.

## State readings

- `EXACT`: local generation and HEAD equal the external anchor.
- `PENDING WITNESS`: the local store is exactly one generation ahead. The
  checkpoint may be submitted, but no further local transition should run.
- `ROLLBACK DETECTED`: the local generation is older than the witness anchor.
- `FORK DETECTED`: the generation is equal but the local HEAD differs.
- `GENERATION GAP`: the local store is more than one generation ahead.

## Runtime protocol

The executable `i3_witness` owns a separate witness directory. Accepted
checkpoints are immutable files named `checkpoint.<sequence>.i3w`. The runtime
serializes appends with an exclusive lock, re-reads and validates the complete
log, verifies a detached signature, writes a same-directory temporary record,
and atomically renames it to the next checkpoint name.

```text
i3_witness init <witness-dir> <atomic-store> <witness-id>
i3_witness request <witness-dir> <atomic-store> <request-file> <nonce> <key-id>
i3_witness append <trusted-public-key> <trusted-key-id> <witness-dir> <request-file> <signature-file>
i3_witness check <witness-dir> <atomic-store>
i3_witness show <witness-dir>
```

Ed25519 verification uses OpenSSL 3 and `pkeyutl -rawin`, as in the existing
validation wire. The trusted public key and key id are operator configuration,
not discovered from the submitted request.

## Red boundary

The Lean model proves properties of the transition relation, not the physical
independence of a witness. The reference adapter detects rollback of the local
store only while the witness directory is retained independently and remains
unmodified. Rolling back or compromising both stores is outside this layer.
The implementation does not prove disk flush durability, stale-lock recovery,
OS integrity, key secrecy, or the cryptographic strength of SHA-256/Ed25519.
Automatic lock stealing remains forbidden.
