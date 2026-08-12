# I³-L08: Least-privilege process isolation

`I³-L08` removes proposal authority from the atomic trust-store process and
places four stages behind separate capability profiles:

```text
trainer/executor -> isolated proposal
validator        -> signed validation receipt
trust store      -> verified atomic HEAD commit
external witness -> signed monotonic checkpoint
```

No role owns all four sensitive authorities: reading the holdout, minting a
validation receipt, rewriting the trust HEAD, and advancing the external
witness.

## Proposal binding

The trust role first exports a public, sample-free model snapshot. The trainer
uses that projection to emit `I3PROPOSAL1`. The proposal is bound to generation,
model identity and version, receipt index, prior HEAD, trust epoch, key id,
manifest, and the exact bounded parameter delta.

```text
ProposalRequestReady(S, p, nonce) :=
  p matches every public field of S
  and BoundedDelta(p.delta)
  and nonce is fresh
```

The trust role may convert a ready proposal into the existing stateful
validation request. It cannot silently substitute another delta: the generated
request contains exactly `p.delta`. A stale or unbounded proposal yields
`HOLD` and leaves the trust store unchanged.

## Runtime profiles

Build the executable and formal audit:

```sh
lake build i3_isolation TMI.DigitalLifeProcessIsolationAudit
```

Create a runtime root outside the source repository and emit four macOS
Sandbox profiles:

```sh
.lake/build/bin/i3_isolation init-layout /private/tmp/i3-runtime
.lake/build/bin/i3_isolation profile trainer "$PWD" /private/tmp/i3-runtime /private/tmp/i3-runtime/profiles/trainer.sb
.lake/build/bin/i3_isolation profile validator "$PWD" /private/tmp/i3-runtime /private/tmp/i3-runtime/profiles/validator.sb
.lake/build/bin/i3_isolation profile trust "$PWD" /private/tmp/i3-runtime /private/tmp/i3-runtime/profiles/trust.sb
.lake/build/bin/i3_isolation profile witness "$PWD" /private/tmp/i3-runtime /private/tmp/i3-runtime/profiles/witness.sb
```

Run each stage as a distinct `sandbox-exec` process. Example:

```sh
/usr/bin/sandbox-exec -f /private/tmp/i3-runtime/profiles/trainer.sb \
  .lake/build/bin/i3_isolation propose \
  /private/tmp/i3-runtime/public/model.i3p \
  /private/tmp/i3-runtime/trainer/outbox/proposal.i3p
```

The validator profile can read the holdout and validator private key but cannot
read or write the atomic store. The trust profile can consume proposals and
receipts and atomically update the store but cannot read either private key or
the holdout. The witness profile can read the atomic store and update only its
own independent log. The trainer profile can read only public state and its own
training area.

## Red boundary

- The Lean theorem proves the role/authority relation and proposal refinement,
  not Apple Sandbox correctness.
- `sandbox-exec` is a reference macOS adapter. Strong deployment should use
  distinct operating-system identities, containers, or equivalent mandatory
  access control.
- The launcher/operator remains trusted to select the correct profile.
- The sample trainer still uses the bounded deterministic demonstration data;
  this layer does not establish learning quality or generalization.
- One external witness is not a Byzantine quorum.
- No claim of consciousness, digital life, or completed true AI is made.
