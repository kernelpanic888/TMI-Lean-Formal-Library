# I³-L13: hardware-bound evidence and split verifier custody

L13 closes two declared L12 gaps without pretending that software creates
hardware truth.

The admission route is an intersection:

1. a verifier-signed L12 evidence receipt;
2. a signed platform-verifier receipt whose quote nonce equals the exact L12
   receipt digest;
3. accepted quote signature, trust chain, PCR/event-log/firmware measurements
   and freshness;
4. a threshold of signatures from distinct final-verifier custody domains over
   the exact platform-receipt digest.

No channel can substitute for another.  A valid platform result without the
split quorum holds.  A quorum over changed or expired hardware evidence holds.

## Adapter boundary

`i3_hardware` does not parse vendor-specific TPM or TEE quotes.  It consumes a
normalized receipt signed by a configured platform verifier.  A real pilot must
place a vendor verifier in front of this adapter and populate the receipt only
after checking the raw quote, certificate chain, nonce, PCR policy, event log
and firmware policy.  The included blind audit signs normalized fixtures with
separate software keys; this tests protocol binding, not physical provenance.

## Commands

`verify` checks the L12 signature, exact digest/nonce binding, platform signature,
accepted measurements and freshness.

`approve` repeats that verification and signs the exact hardware-evidence digest
with one configured final-verifier key.

`quorum` repeats hardware verification, validates every detached approval
signature, rejects duplicate identities or custody domains, and emits a compact
certificate only at the configured threshold.

## Honest boundary

The Lean layer proves consequences of the declared verification predicates. The
runtime proves cryptographic consistency of normalized evidence. Neither proves
that a key is non-exportable, a machine is physically separate, an operator is
independent, a clock is correct, or a platform-verifier implementation is sound.
Those are deployment evidence required by the real two-host pilot. This layer
does not prove consciousness, digital life or true AI.
