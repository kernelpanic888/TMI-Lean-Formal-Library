# I³-L14: physical hardware challenge

## Purpose

L14 replaces a declared hardware flag with a real local cryptographic operation.
The exact L13 certificate digest becomes the nonce of a fresh challenge.  A
P-256 key generated inside Apple Secure Enclave signs that challenge; the
private key is permanent, hardware-backed and non-exportable.

## Admission split

- `LOCAL HARDWARE PASS` means the configured Secure Enclave key was present,
  non-exportable, matched the policy digest and signed the fresh L13-bound
  challenge.
- `GLOBAL HARDWARE ADMITTED` additionally requires an external attestation
  chain, accepted measurements and a threshold of distinct physical custody
  domains.
- A single local machine therefore reports `GLOBAL HARDWARE ADMISSION=HOLD`.

## Flow

```text
L13 certificate digest
        |
        v
fresh challenge + expiry + exact hardware profile
        |
        v
Apple Secure Enclave P-256 signature
        |
        v
normalized local receipt -> LOCAL HARDWARE PASS
        |
        +-- missing remote chain/quorum -> GLOBAL HOLD
```

## Runtime

Build `i3_physical`, then package `scripts/i3_secure_enclave_bridge.m` with
`scripts/build_i3_secure_enclave_app.sh`. The wrapper requires a trusted Apple
Development identity and an authorized macOS provisioning profile before it
grants the helper access to the Data Protection Keychain. The hardware audit
refuses to start without that signed helper, then exercises one real local pass
and eight fail-closed mutations.

The development signature is a local execution prerequisite, not remote
attestation, notarization or independent endorsement.

## Red boundary

The formal contract and native adapter are complete, but this checkout has no
trusted Apple Development identity or authorized provisioning profile. The
attempted local operation therefore returns `errSecMissingEntitlement (-34018)`
and the factual status is `LOCAL HARDWARE HOLD`. No successful hardware
signature is claimed yet.

Even after a local pass, this remains a Secure Enclave signing operation, not a
TPM quote or vendor remote attestation. It supplies no independent physical
witness, no firmware measurement claim and no evidence of consciousness or
true AI. It strengthens only the continuity and provenance boundary of the I³
runtime.

Apple references:

- https://developer.apple.com/documentation/Technotes/tn3137-on-mac-keychains
- https://developer.apple.com/documentation/security/ksecattrtokenidsecureenclave
- https://developer.apple.com/documentation/BundleResources/Entitlements/keychain-access-groups
