# I³-L15: trusted platform enrollment

## Purpose

L15 closes the authorization gap immediately before the L14 Secure Enclave
probe. It verifies that one signed macOS app matches one enrolled platform
passport. A successful L15 result means only `READY FOR HARDWARE PROBE`.
It does not mean `LOCAL HARDWARE PASS`.

## Exact intersection

```text
READY FOR HARDWARE PROBE :=
  digest(L14 policy)
  ∩ Apple signing chain + Team ID
  ∩ signing identifier
  ∩ designated requirement digest
  ∩ provisioning profile digest
  ∩ effective entitlements digest
  ∩ keychain access group
  ∩ helper binary digest
  ∩ fresh observation
```

No individual field is sufficient. The signing identifier is signer-chosen, so
the policy also binds the Apple validation category, Team ID and designated
requirement. Restricted keychain entitlements must be authorized by the
embedded provisioning profile.

## Runtime

1. Build the app wrapper with `build_i3_secure_enclave_app.sh`.
2. Collect a normalized observation with `i3_collect_macos_enrollment.sh`.
3. Verify it with `i3_enrollment verify`.
4. Only a `READY FOR HARDWARE PROBE` result permits the L14 nine-scene audit.

The synthetic blind corpus checks the verifier. It is not evidence that this
Mac passed real enrollment.

## Factual state

This checkout has no available trusted Apple Development identity and matching
authorized provisioning profile. Therefore real enrollment remains `HOLD`, and
the L14 Secure Enclave operation remains unexecuted.

## Red boundary

Enrollment proves an exact configured code identity at one observation time.
It does not prove a successful Secure Enclave signature, remote attestation,
physical independence, consciousness, digital life or true AI.

Apple references:

- https://developer.apple.com/documentation/technotes/tn3125-inside-code-signing-provisioning-profiles
- https://developer.apple.com/documentation/technotes/tn3127-inside-code-signing-requirements
- https://developer.apple.com/documentation/lightweightcoderequirements/signingidentifier
- https://developer.apple.com/documentation/xcode/creating-distribution-signed-code-for-the-mac/
