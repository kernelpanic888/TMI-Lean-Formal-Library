# I³-L05: Persistent Trust Head

## Purpose

`I³-L04` authenticates one sample-free validation exchange. `I³-L05` makes
that exchange part of a persistent history. The trainer persists the current
model, the last request identifier, the receipt head, the validator trust
epoch, the key identifier, and every consumed nonce.

An update is admitted only when:

```text
signature valid
∧ requestId = lastRequestId + 1
∧ request model = persisted model
∧ previousReceiptHead = persisted receiptHead
∧ trustEpoch/keyId = current trust root
∧ nonce is 64 characters and unused
∧ bounded delta
∧ independently computed candidateLoss ≤ baselineLoss
```

Failure of any gate returns `HOLD`; the persisted state is not advanced.

## Processes

```text
i3_trust     owns trust-state initialization and signed key rotation
i3_trainer   proposes a state-bound request and applies an admitted receipt
i3_validator owns holdout samples and the current Ed25519 private key
```

The stateful path is additive. The original stateless L04 commands remain
available for reproducibility.

## Stateful cycle

```text
i3_trust init trust.state MANIFEST_SHA256 17 1 41
i3_trust nonce
i3_trainer state-request trust.state request.txt NONCE
i3_validator stateful private.pem holdout.txt request.txt receipt.txt receipt.sig 17 1 41
i3_trainer state-verify public.pem trust.state request.txt receipt.txt receipt.sig
```

After `ADMIT`, replaying the same request against `trust.state` produces
`HOLD`: the request id, previous head, and nonce are all stale.

## Signed key rotation

```text
i3_trust rotation-request trust.state rotation.txt 42 ROTATION_NONCE
i3_trust rotation-sign old-private.pem rotation.txt rotation.sig
i3_trust rotation-apply old-public.pem trust.state rotation.txt rotation.sig
```

The old key authorizes one transition to `trustEpoch + 1` and a distinct key
identifier. A replay after the state advances is rejected. Two signed rotation
requests with the same validator, source epoch, source key, and previous head
but different destinations are compact fork evidence.

## Red boundary

- Lean proves the transition and admission contract, not Ed25519 or SHA-256.
- The state file survives ordinary process restart but is not protected from
  filesystem rollback, concurrent writers, power-loss tearing, or privileged
  modification.
- Key files are external. This layer does not provide an OS sandbox, HSM,
  remote witness, or confidential-computing boundary.
- Validation improvement on one holdout is not proof of generalization,
  consciousness, digital life, or true AI.

The next refinement is a transactional state writer plus an external witness
for the monotone head. Only then can rollback and concurrent-fork attacks be
treated as executable adversarial cases rather than an explicit red boundary.
