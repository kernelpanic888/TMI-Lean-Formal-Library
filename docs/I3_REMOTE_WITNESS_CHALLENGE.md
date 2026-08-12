# I³-L11: attested witness transport and fresh remote challenge-response

L10 rejects votes that share declared administrative, network or host fault
domains. L11 tests whether a designated remote witness produced a fresh signed
response for the exact current target and transport binding.

## Protocol

1. The verifier signs a one-time 256-bit challenge identifier together with the
   policy digest, round, target anchor, witness/key identity, endpoint ID,
   expected TLS peer SPKI digest and a bounded validity interval.
2. The witness verifies the challenge signature and freshness, reads its local
   witness HEAD, then signs the challenge digest and observed anchor.
3. The verifier checks both signatures, exact policy and target binding,
   endpoint and TLS peer binding, response time and the replay ledger.
4. A valid challenge is consumed through an exclusive filesystem marker before
   its receipt is emitted. A second use fails closed.

The verified response projects to an L10 `FaultDomainVote`; therefore remote
freshness extends rather than bypasses the independent quorum rule.

## HTTPS adapter

`scripts/i3_https_pinned_transport.sh` requires TLS 1.3 and curl SPKI pinning.
It POSTs the signed challenge and accepts the witness signature only from the
`X-I3-Response-Signature` header. The endpoint is expected to return the raw
`I3RSP1` envelope as its body.

## Honest boundary

This is cryptographic channel evidence, not hardware attestation. The runtime
relies on the supplied clock, OpenSSL, curl, TLS and local filesystem semantics.
A pin proves continuity with a key, not organisational independence or honest
execution. Real assurance requires different operators, hosts and networks,
separate key custody, monitored clocks and independent transport observation.
The layer does not prove consciousness, digital life or true AI.
