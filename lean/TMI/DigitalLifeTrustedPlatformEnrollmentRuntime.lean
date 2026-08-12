import TMI.DigitalLifeTrustedPlatformEnrollment

namespace TMI.DigitalLifeTrustedPlatformEnrollmentRuntime

open TMI.DigitalLifeTrustedPlatformEnrollment

def enrollmentPolicyProtocol : String := "I3TPEP1"
def enrollmentObservationProtocol : String := "I3TPEO1"

private def safeToken (value : String) : Bool :=
  !value.isEmpty && !value.contains '|' && !value.contains '\n' && !value.contains '\r'

private def parseFlag (value : String) : Option Bool :=
  if value = "true" then some true
  else if value = "false" then some false
  else none

def parseTrustedEnrollmentPolicy (text : String) : Option TrustedEnrollmentPolicy := do
  match text.trim.splitOn "|" with
  | [protocol, versionText, policyId, l14Digest, teamId, signingId,
      requirementDigest, profileDigest, entitlementsDigest, keychainGroup,
      helperDigest, ageText] =>
      let version ← versionText.toNat?
      let maxObservationAge ← ageText.toNat?
      if protocol != enrollmentPolicyProtocol ||
          version != trustedEnrollmentProtocolVersion ||
          !safeToken policyId || !safeToken teamId || !safeToken signingId ||
          !safeToken keychainGroup then none
      let policy : TrustedEnrollmentPolicy := {
        policyId := policyId
        expectedL14PolicyDigest := l14Digest
        expectedTeamIdentifier := teamId
        expectedSigningIdentifier := signingId
        expectedDesignatedRequirementDigest := requirementDigest
        expectedProvisioningProfileDigest := profileDigest
        expectedEntitlementsDigest := entitlementsDigest
        expectedKeychainGroup := keychainGroup
        expectedHelperDigest := helperDigest
        maxObservationAge := maxObservationAge }
      if TrustedEnrollmentPolicyWellFormed policy then some policy else none
  | _ => none

def parsePlatformEnrollmentObservation
    (text : String) : Option PlatformEnrollmentObservation := do
  match text.trim.splitOn "|" with
  | [protocol, versionText, policyId, l14Digest, teamId, signingId,
      requirementDigest, profileDigest, entitlementsDigest, keychainGroup,
      helperDigest, observedText, appleText, signatureText, profileText,
      entitlementsText, runtimeText] =>
      let version ← versionText.toNat?
      let observedAt ← observedText.toNat?
      let appleChainValidated ← parseFlag appleText
      let signatureValid ← parseFlag signatureText
      let profileAuthorizesEntitlements ← parseFlag profileText
      let effectiveEntitlementsMatch ← parseFlag entitlementsText
      let hardenedRuntimeEnabled ← parseFlag runtimeText
      if protocol != enrollmentObservationProtocol ||
          version != trustedEnrollmentProtocolVersion then none
      pure {
        policyId := policyId
        l14PolicyDigest := l14Digest
        teamIdentifier := teamId
        signingIdentifier := signingId
        designatedRequirementDigest := requirementDigest
        provisioningProfileDigest := profileDigest
        entitlementsDigest := entitlementsDigest
        keychainGroup := keychainGroup
        helperDigest := helperDigest
        observedAt := observedAt
        appleChainValidated := appleChainValidated
        signatureValid := signatureValid
        profileAuthorizesEntitlements := profileAuthorizesEntitlements
        effectiveEntitlementsMatch := effectiveEntitlementsMatch
        hardenedRuntimeEnabled := hardenedRuntimeEnabled }
  | _ => none

def readTrustedEnrollmentPolicy (path : String) : IO (Option TrustedEnrollmentPolicy) := do
  try pure (parseTrustedEnrollmentPolicy (← IO.FS.readFile path))
  catch _ => pure none

def readPlatformEnrollmentObservation
    (path : String) : IO (Option PlatformEnrollmentObservation) := do
  try pure (parsePlatformEnrollmentObservation (← IO.FS.readFile path))
  catch _ => pure none

inductive EnrollmentOutcome where
  | ready
  | hold (reason : String)
  deriving Repr

def verifyEnrollment
    (policyPath observationPath : String) (now : Nat) : IO EnrollmentOutcome := do
  match (← readTrustedEnrollmentPolicy policyPath),
      (← readPlatformEnrollmentObservation observationPath) with
  | some policy, some observation =>
      if TrustedPlatformEnrolled policy now observation then pure .ready
      else if observation.signatureValid != true then
        pure (.hold "code signature is invalid")
      else if observation.appleChainValidated != true then
        pure (.hold "Apple signing chain, Team ID or designated requirement rejected")
      else if observation.profileAuthorizesEntitlements != true then
        pure (.hold "provisioning profile does not authorize the restricted entitlements")
      else if observation.effectiveEntitlementsMatch != true then
        pure (.hold "effective entitlements differ from the enrolled contract")
      else if observation.hardenedRuntimeEnabled != true then
        pure (.hold "hardened runtime is absent")
      else if now < observation.observedAt then
        pure (.hold "platform observation is from the future")
      else if policy.maxObservationAge < now - observation.observedAt then
        pure (.hold "platform observation expired")
      else pure (.hold "platform identity or exact L14 binding differs from policy")
  | _, _ => pure (.hold "enrollment policy or observation parse failed")

end TMI.DigitalLifeTrustedPlatformEnrollmentRuntime
