/-!
Certified System Steward / CSS-03

This file isolates the privilege-boundary contract from any macOS transport.
It proves what follows from the contract; it does not postulate that an XPC
connection, code signature, or root helper exists in the physical system.
-/

namespace CertifiedSystemStewardPrivilegeBoundary

universe uP uR uT uF uD uN

/-- The helper can mutate the quarantine resource; the client cannot. -/
structure PrivilegeBoundary (Principal : Type uP) (Resource : Type uR) where
  client : Principal
  helper : Principal
  quarantine : Resource
  canWrite : Principal -> Resource -> Prop
  helperCanWrite : canWrite helper quarantine
  clientCannotWrite : Not (canWrite client quarantine)

/-- A request commits to the selected object, policy, protected state and nonce. -/
structure HelperRequest
    (Target : Type uT) (Fingerprint : Type uF) (Digest : Type uD)
    (Nonce : Type uN) where
  epoch : Nat
  target : Target
  expectedIdentity : Fingerprint
  policyDigest : Digest
  protectedBefore : Digest
  nonce : Nonce

/-- Observations made after the helper has taken authority over the target. -/
structure HelperObservation (Fingerprint : Type uF) (Digest : Type uD) where
  actualIdentity : Fingerprint
  quarantineIdentity : Fingerprint
  protectedAfter : Digest
  sourceReappeared : Bool

/-- A receipt binds one request to one helper observation. -/
structure HelperReceipt
    (Principal : Type uP) (Target : Type uT) (Fingerprint : Type uF)
    (Digest : Type uD) (Nonce : Type uN) where
  request : HelperRequest Target Fingerprint Digest Nonce
  actor : Principal
  observation : HelperObservation Fingerprint Digest
  accepted : Bool

/--
The proof-carrying transition. Transport authentication is represented by the
boundary and `actorIsHelper`; it is not a field supplied by the receipt payload.
-/
structure AdmittedHelperTransition
    {Principal : Type uP} {Resource : Type uR} {Target : Type uT}
    {Fingerprint : Type uF} {Digest : Type uD} {Nonce : Type uN}
    (boundary : PrivilegeBoundary Principal Resource)
    (request : HelperRequest Target Fingerprint Digest Nonce)
    (receipt : HelperReceipt Principal Target Fingerprint Digest Nonce) : Prop where
  actorIsHelper : receipt.actor = boundary.helper
  receiptBindsRequest : receipt.request = request
  targetIdentityMatches : receipt.observation.actualIdentity = request.expectedIdentity
  quarantineIdentityMatches :
    receipt.observation.quarantineIdentity = request.expectedIdentity
  protectedStatePreserved : receipt.observation.protectedAfter = request.protectedBefore
  sourceDidNotReappear : receipt.observation.sourceReappeared = false
  receiptAccepted : receipt.accepted = true

/-- A real privilege boundary necessarily separates the two principals. -/
theorem principals_distinct
    {Principal : Type uP} {Resource : Type uR}
    (boundary : PrivilegeBoundary Principal Resource) :
    boundary.client ≠ boundary.helper := by
  intro samePrincipal
  apply boundary.clientCannotWrite
  simpa [samePrincipal] using boundary.helperCanWrite

/-- An admitted helper transition preserves the protected-state digest. -/
theorem admitted_preserves_protected_state
    {Principal : Type uP} {Resource : Type uR} {Target : Type uT}
    {Fingerprint : Type uF} {Digest : Type uD} {Nonce : Type uN}
    {boundary : PrivilegeBoundary Principal Resource}
    {request : HelperRequest Target Fingerprint Digest Nonce}
    {receipt : HelperReceipt Principal Target Fingerprint Digest Nonce}
    (admitted : AdmittedHelperTransition boundary request receipt) :
    receipt.observation.protectedAfter = request.protectedBefore :=
  admitted.protectedStatePreserved

/-- A reappearing public name is incompatible with admission. -/
theorem admitted_excludes_source_reappearance
    {Principal : Type uP} {Resource : Type uR} {Target : Type uT}
    {Fingerprint : Type uF} {Digest : Type uD} {Nonce : Type uN}
    {boundary : PrivilegeBoundary Principal Resource}
    {request : HelperRequest Target Fingerprint Digest Nonce}
    {receipt : HelperReceipt Principal Target Fingerprint Digest Nonce}
    (admitted : AdmittedHelperTransition boundary request receipt) :
    receipt.observation.sourceReappeared = false :=
  admitted.sourceDidNotReappear

/-- An admitted receipt is bound to the exact request, not merely its target. -/
theorem admitted_receipt_binds_exact_request
    {Principal : Type uP} {Resource : Type uR} {Target : Type uT}
    {Fingerprint : Type uF} {Digest : Type uD} {Nonce : Type uN}
    {boundary : PrivilegeBoundary Principal Resource}
    {request : HelperRequest Target Fingerprint Digest Nonce}
    {receipt : HelperReceipt Principal Target Fingerprint Digest Nonce}
    (admitted : AdmittedHelperTransition boundary request receipt) :
    receipt.request = request :=
  admitted.receiptBindsRequest

end CertifiedSystemStewardPrivilegeBoundary
