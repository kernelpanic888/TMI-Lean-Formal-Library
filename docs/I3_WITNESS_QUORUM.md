# I³-L09: Witness quorum and threshold acceptance

`I³-L09` replaces one external rollback witness as the acceptance authority
with a configurable threshold of distinct witnesses.  The reference policy is
`2-of-3`.

```text
local atomic HEAD
      │
      ├── witness A ── signed vote ──┐
      ├── witness B ── signed vote ──┼── quorum verifier ── certificate / HOLD
      └── witness C ── signed vote ──┘
```

The quorum gate accepts only if:

```text
PolicyWellFormed(policy)
∧ distinct(vote.witnessId)
∧ threshold ≤ number of votes
∧ every vote is authorized, signature-verified,
  round-bound, policy-bound, and names the exact same (generation, HEAD)
```

One key cannot be counted twice.  A valid signature for a different anchor is
a conflict, not support.  Too few votes, a duplicate identity, an unknown key,
an invalid signature, or a mismatched round yields `HOLD` and no certificate.

## Runtime policy

```text
I3QPOL1|1|primary-2of3|2
MEMBER|witness-a|key-a|/absolute/path/a.pub.pem
MEMBER|witness-b|key-b|/absolute/path/b.pub.pem
MEMBER|witness-c|key-c|/absolute/path/c.pub.pem
```

Each witness signs its own `I3QVOTE1` file from its independently maintained
monotonic witness log.  The aggregator receives only public keys, vote files,
signatures, and the atomic public HEAD.  It receives no witness private key and
cannot rewrite the trust store.

Build the executable and theorem audit:

```sh
lake build i3_quorum TMI.DigitalLifeWitnessQuorumAudit
```

The commands are:

```sh
i3_quorum vote <policy-id> <round> <witness-dir> <key-id> <private-key> <vote-file> <signature-file>
i3_quorum admit <policy-file> <atomic-store> <round> <vote-dir> <certificate-file>
i3_quorum verify <policy-file> <atomic-store> <round> <vote-dir> <certificate-file>
```

## Reproducible blind audit

```bash
scripts/i3_witness_quorum_blind_audit.sh
```

The audit exercises one valid 2-of-3 admission and fail-closed handling for an
insufficient set, a duplicated identity, a conflicting signed HEAD and a
tampered certificate. Ephemeral private keys are destroyed when the audit
exits and are never copied into the vote or certificate corpus.

## Red boundary

- `2-of-3` tolerates one missing witness, but not two compromised signers.
- Distinct identifiers and keys are formal and cryptographic identities, not
  proof of physically independent operators, machines, or jurisdictions.
- The reference runtime verifies Ed25519 signatures through OpenSSL; Lean proves
  the admission contract, not OpenSSL or operating-system integrity.
- A quorum certificate establishes agreement on one anchor.  It does not prove
  that the underlying model is intelligent, conscious, alive, correct, or safe.
