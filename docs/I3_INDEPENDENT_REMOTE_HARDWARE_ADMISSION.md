# I³-L16: Independent Remote Hardware Admission

## Purpose

L16 is the first composition layer that binds the local I³ hardware path to an
independent remote verifier. It does not implement signatures, TPM/TEE quotes,
TLS, or hardware measurement. Those mechanisms remain responsibilities of the
lower verified adapters and platform-specific implementations.

## Admission formula

```text
GLOBAL HARDWARE ADMIT =
  L15 ENROLLMENT READY
  ∩ L14 LOCAL HARDWARE PASS
  ∩ FRESH REMOTE CHALLENGE
  ∩ VALID TRANSPORT ATTESTATION
  ∩ TRUSTED QUOTE + ACCEPTED MEASUREMENTS
  ∩ SPLIT CUSTODY
  ∩ SIGNED, INDEPENDENT FAULT-DOMAIN QUORUM
```

Every identity, policy, profile, and lower-layer receipt is bound by an exact
digest. Any mismatch, stale or future timestamp, rejected signature, missing
approval, insufficient witness count, or shared fault domain produces `HOLD`.

## Wire contracts

- Policy protocol: `I3IRHAP1`, 14 pipe-delimited fields.
- Evidence protocol: `I3IRHAE1`, 24 pipe-delimited fields.
- Runtime: `i3_remote_hardware verify <policy> <evidence> <now>`.

The wire format is deliberately minimal and is not a cryptographic container.
Production evidence must be assembled only from results already verified by
the lower cryptographic and platform adapters.

## Formal boundary

The Lean model proves the admission selector is fail-closed relative to its
inputs. The synthetic audit proves that mutations of every admission gate are
rejected. Neither result proves that a real machine produced the evidence.

Current factual state: `FORMAL READY · REAL GLOBAL HARDWARE HOLD`.

Missing real-world evidence:

- trusted L15 signing identity and matching provisioning profile;
- real L14 local hardware receipt;
- real platform quote and accepted reference measurements;
- an independent remote verifier and split-custody approvals;
- two or more independently controlled fault domains.

This layer does not prove consciousness, digital life, or true AI.

## External shoulders

- RFC 9334, Remote ATtestation procedureS (RATS) Architecture:
  <https://www.rfc-editor.org/rfc/rfc9334.html>
- RFC 9711, Entity Attestation Token:
  <https://www.rfc-editor.org/rfc/rfc9711.html>
- NIST SP 1800-34, Validating the Integrity of Computing Devices:
  <https://csrc.nist.gov/pubs/sp/1800/34/final>
