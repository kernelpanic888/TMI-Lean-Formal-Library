# I3 sample-free validation wire

This layer moves the validation boundary from Lean types into two real
processes without weakening the formal admission rule.

```text
trainer -> sample-free request -> validator
trainer <- Ed25519-signed receipt <- validator
trainer -> verify signature + Lean gates -> ADMIT | HOLD
```

The request contains model identity, version, receipt index, parameters,
bounded parameter delta, baseline loss, public holdout manifest SHA-256, and a
fresh request id. It contains no validation samples. The validator alone reads
the holdout file and private key.

## Holdout format

```text
I3HOLD1|9001|1
1|0|0|0|0|0|1
```

Each sample row is `id|x|y|z|memory|reflection|target`.

## Local specimen

Generate an ephemeral validator key outside the repository:

```sh
export I3_OPENSSL=${I3_OPENSSL:-/opt/homebrew/bin/openssl}
"$I3_OPENSSL" genpkey -algorithm ED25519 -out /tmp/i3-validator-key.pem
"$I3_OPENSSL" pkey -in /tmp/i3-validator-key.pem -pubout -out /tmp/i3-validator-pub.pem
```

Build the two executables, calculate the holdout manifest, create a request,
validate it, and verify the signed receipt:

```sh
lake build i3_trainer i3_validator TMI.DigitalLifeValidationWireAudit
manifest=$("$I3_OPENSSL" dgst -sha256 -r /tmp/i3-holdout.txt | cut -d' ' -f1)
.lake/build/bin/i3_trainer request /tmp/i3-request.txt 101 "$manifest"
.lake/build/bin/i3_validator /tmp/i3-validator-key.pem /tmp/i3-holdout.txt \
  /tmp/i3-request.txt /tmp/i3-receipt.txt /tmp/i3-receipt.sig 41
.lake/build/bin/i3_trainer verify /tmp/i3-validator-pub.pem \
  /tmp/i3-request.txt /tmp/i3-receipt.txt /tmp/i3-receipt.sig 41
```

Successful verification prints `ADMIT`. Invalid syntax, a wrong manifest,
signature failure, request tampering, replay against another request, an
unbounded delta, baseline mismatch, or worse validation loss prints `HOLD` and
does not advance the model state.

## Red boundary

Lean proves the admission/refinement contract. OpenSSL supplies SHA-256 and
Ed25519 execution. This package does not prove the cryptographic assumptions,
OS isolation, secrecy, dataset quality, generalization, consciousness,
digital life, or true AI. Private keys and runtime holdouts must never be
committed.
