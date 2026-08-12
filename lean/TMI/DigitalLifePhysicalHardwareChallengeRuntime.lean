import TMI.DigitalLifePhysicalHardwareChallenge
import TMI.DigitalLifeValidationWireRuntime

/-! Executable local adapter for the I³-L14 physical hardware challenge. -/

namespace TMI.DigitalLifePhysicalHardwareChallengeRuntime

open TMI.DigitalLifePhysicalHardwareChallenge
open TMI.DigitalLifeValidationWireRuntime

def physicalPolicyProtocol : String := "I3PHP1"
def physicalChallengeProtocol : String := "I3PHC1"
def localHardwareReceiptProtocol : String := "I3PHR1"

private def cleanLines (text : String) : List String :=
  (text.splitOn "\n").map String.trim |>.filter (fun line => line != "")

private def safeToken (value : String) : Bool :=
  !value.isEmpty &&
  !value.toList.any (fun c => c == '|' || c == '\n' || c == '\r')

def parsePhysicalPolicy (text : String) : Option PhysicalHardwarePolicy := do
  match cleanLines text with
  | [header, profileLine] =>
      match header.splitOn "|", profileLine.splitOn "|" with
      | [protocol, versionText, policyId, basePolicyId, baseDigest, lifetimeText,
          approvalsText],
        ["PROFILE", witnessId, nodeId, platformId, providerId, keyHandle,
          custodyDomain, publicKeyDigest] =>
          let version ← versionText.toNat?
          let maxChallengeLifetime ← lifetimeText.toNat?
          let minRemoteApprovals ← approvalsText.toNat?
          if protocol != physicalPolicyProtocol ||
              version != physicalHardwareProtocolVersion ||
              !safeToken policyId || !safeToken basePolicyId ||
              !safeToken witnessId || !safeToken nodeId ||
              !safeToken platformId || !safeToken providerId ||
              !safeToken keyHandle || !safeToken custodyDomain then none
          let policy : PhysicalHardwarePolicy := {
            policyId, basePolicyId,
            expectedBaseEvidenceDigest := baseDigest,
            maxChallengeLifetime, minRemoteApprovals,
            profile := {
              witnessId := witnessId, nodeId := nodeId,
              platformId := platformId, providerId := providerId,
              keyHandle := keyHandle, custodyDomain := custodyDomain,
              trustedPublicKeyDigest := publicKeyDigest } }
          if PhysicalPolicyWellFormed policy then some policy else none
      | _, _ => none
  | _ => none

def readPhysicalPolicy (path : String) : IO (Option PhysicalHardwarePolicy) := do
  try pure (parsePhysicalPolicy (← IO.FS.readFile path))
  catch _ => pure none

def encodePhysicalChallenge (challenge : PhysicalChallenge) : String :=
  String.intercalate "|" [physicalChallengeProtocol,
    toString physicalHardwareProtocolVersion, challenge.policyId,
    challenge.policyDigest, challenge.basePolicyId, challenge.baseEvidenceDigest,
    challenge.challengeId, toString challenge.issuedAt, toString challenge.expiresAt,
    challenge.witnessId, challenge.nodeId, challenge.platformId,
    challenge.keyHandle, challenge.quoteNonce] ++ "\n"

def parsePhysicalChallenge (text : String) : Option PhysicalChallenge := do
  match text.trim.splitOn "|" with
  | [protocol, versionText, policyId, policyDigest, basePolicyId, baseDigest,
      challengeId, issuedText, expiresText, witnessId, nodeId, platformId,
      keyHandle, quoteNonce] =>
      let version ← versionText.toNat?
      let issuedAt ← issuedText.toNat?
      let expiresAt ← expiresText.toNat?
      if protocol != physicalChallengeProtocol ||
          version != physicalHardwareProtocolVersion then none
      let challenge : PhysicalChallenge := {
        policyId := policyId
        policyDigest := policyDigest
        basePolicyId := basePolicyId
        baseEvidenceDigest := baseDigest
        challengeId := challengeId
        issuedAt := issuedAt
        expiresAt := expiresAt
        witnessId := witnessId
        nodeId := nodeId
        platformId := platformId
        keyHandle := keyHandle
        quoteNonce := quoteNonce }
      some challenge
  | _ => none

def encodeLocalHardwareReceipt (receipt : LocalHardwareReceipt) : String :=
  String.intercalate "|" [localHardwareReceiptProtocol,
    toString physicalHardwareProtocolVersion, receipt.policyId,
    receipt.challengeId, receipt.challengeDigest, receipt.baseEvidenceDigest,
    receipt.witnessId, receipt.nodeId, receipt.platformId, receipt.providerId,
    receipt.keyHandle, receipt.custodyDomain, receipt.publicKeyDigest,
    toString receipt.signedAt, toString receipt.signatureVerified,
    toString receipt.hardwareTokenVerified,
    toString receipt.privateKeyNonExportable] ++ "\n"

private def runHelper (helper : String) (args : Array String) : IO Bool := do
  try
    let result ← IO.Process.output { cmd := helper, args }
    if result.exitCode != 0 then
      if !result.stderr.trim.isEmpty then IO.eprintln result.stderr.trim
      pure false
    else pure true
  catch _ => pure false

def prepareHardwareKey
    (helper tag publicKeyPath : String) : IO (Option String) := do
  if !(← runHelper helper #["ensure", tag, publicKeyPath]) then pure none
  else sha256File publicKeyPath

def issuePhysicalChallenge
    (policyPath challengeId : String)
    (issuedAt lifetime : Nat)
    (challengePath : String) : IO Bool := do
  match (← readPhysicalPolicy policyPath), (← sha256File policyPath) with
  | some policy, some policyDigest =>
      if challengeId.length != 64 || lifetime = 0 ||
          policy.maxChallengeLifetime < lifetime then pure false
      else
        let p := policy.profile
        let challenge : PhysicalChallenge := {
          policyId := policy.policyId, policyDigest,
          basePolicyId := policy.basePolicyId,
          baseEvidenceDigest := policy.expectedBaseEvidenceDigest,
          challengeId, issuedAt, expiresAt := issuedAt + lifetime,
          witnessId := p.witnessId, nodeId := p.nodeId,
          platformId := p.platformId, keyHandle := p.keyHandle,
          quoteNonce := policy.expectedBaseEvidenceDigest }
        IO.FS.writeFile challengePath (encodePhysicalChallenge challenge)
        pure true
  | _, _ => pure false

def signPhysicalChallenge
    (helper tag challengePath signaturePath publicKeyPath : String) : IO Bool :=
  runHelper helper #["sign", tag, challengePath, signaturePath, publicKeyPath]

inductive LocalPhysicalOutcome where
  | verified (receipt : LocalHardwareReceipt) (receiptDigest : String)
  | hold (reason : String)
  deriving Repr

def verifyLocalHardwareChallenge
    (helper tag policyPath challengePath signaturePath publicKeyPath receiptPath : String)
    (now : Nat) : IO LocalPhysicalOutcome := do
  match (← readPhysicalPolicy policyPath), (← sha256File policyPath),
      parsePhysicalChallenge (← IO.FS.readFile challengePath),
      (← sha256File challengePath) with
  | some policy, some policyDigest, some challenge, some challengeDigest =>
      if !(← runHelper helper #["ensure", tag, publicKeyPath]) then
        pure (.hold "configured hardware key is unavailable or exportable")
      else
        match (← sha256File publicKeyPath) with
        | none => pure (.hold "hardware public key digest failed")
        | some publicKeyDigest =>
            let signatureVerified ←
              runHelper helper #["verify", publicKeyPath, challengePath, signaturePath]
            let p := policy.profile
            let receipt : LocalHardwareReceipt := {
              policyId := policy.policyId,
              challengeId := challenge.challengeId, challengeDigest,
              baseEvidenceDigest := challenge.baseEvidenceDigest,
              witnessId := p.witnessId, nodeId := p.nodeId,
              platformId := p.platformId, providerId := p.providerId,
              keyHandle := p.keyHandle, custodyDomain := p.custodyDomain,
              publicKeyDigest, signedAt := now, signatureVerified,
              hardwareTokenVerified := true,
              privateKeyNonExportable := true }
            if LocalHardwareBound policy policyDigest challengeDigest now challenge receipt then
              IO.FS.writeFile receiptPath (encodeLocalHardwareReceipt receipt)
              match (← sha256File receiptPath) with
              | some receiptDigest => pure (.verified receipt receiptDigest)
              | none => pure (.hold "normalized receipt digest failed")
            else if publicKeyDigest != p.trustedPublicKeyDigest then
              pure (.hold "hardware public key differs from policy")
            else if !signatureVerified then
              pure (.hold "physical challenge signature is invalid")
            else if now < challenge.issuedAt then
              pure (.hold "physical challenge is from the future")
            else if challenge.expiresAt < now then
              pure (.hold "physical challenge expired")
            else pure (.hold "challenge is not bound to policy, L13 digest or hardware profile")
  | _, _, _, _ => pure (.hold "policy or physical challenge parse failed")

end TMI.DigitalLifePhysicalHardwareChallengeRuntime
