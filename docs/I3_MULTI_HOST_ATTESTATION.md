# I³-L12: multi-host key custody and transport attestation

L12 does not infer independence from host labels.  It admits a remote witness
only when three signed views of one response agree:

1. the fresh L11 response and local verification receipt;
2. a node-state attestation signed by a separately configured attestation key;
3. a transport observation signed by an observer in another custody domain.

The aggregate certificate additionally requires unique witness identities,
node identities, key-custody domains and observer identities.  Missing,
expired, redirected, re-pinned, duplicated or tampered evidence holds.

## Runtime passport

`i3_attestation attest` signs boot/runtime measurements bound to one L11 receipt.
`i3_attestation observe` signs the endpoint and TLS peer seen for that receipt.
`i3_attestation verify` intersects both signatures and emits a verifier-signed
evidence receipt. `i3_attestation quorum` accepts only a threshold set with
distinct custody domains.

The policy stores public-key paths. Private keys remain outside policy and are
passed only to the role that signs. In real deployment the witness, attestation,
observer and verifier keys must be held by different principals or protected
services; the blind audit merely simulates that separation with distinct files.

## Honest boundary

The current adapter proves cryptographic consistency, freshness and configured
separation. It does not prove hardware provenance, TPM/TEE quote validity,
operator honesty, clock correctness, route independence or physical host
separation. Those claims require a real multi-host deployment and a platform
attestation verifier. This layer does not prove consciousness, digital life or
true AI.
