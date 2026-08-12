import TMI.DigitalLifeHardwareAttestation
import TMI.DigitalLifeTransportAttestationRuntime
import TMI.DigitalLifeValidationWireRuntime

namespace TMI.DigitalLifeHardwareAttestationRuntime

open TMI.DigitalLifeHardwareAttestation
open TMI.DigitalLifeTransportAttestationRuntime
open TMI.DigitalLifeValidationWireRuntime

def hardwarePolicyProtocol : String := "I3HPOL1"
def platformReceiptProtocol : String := "I3HQR1"
def splitApprovalProtocol : String := "I3HSA1"
def hardwareCertificateProtocol : String := "I3HAC1"

structure RuntimeHardwareProfile where
  profile : HardwareProfile
  platformVerifierPublicKeyPath : String
  deriving Repr

structure RuntimeSplitVerifierProfile where
  profile : SplitVerifierProfile
  publicKeyPath : String
  deriving Repr

structure RuntimeHardwarePolicy where
  policy : HardwarePolicy
  baseVerifierPublicKeyPath : String
  hardwareProfiles : List RuntimeHardwareProfile
  verifierProfiles : List RuntimeSplitVerifierProfile
  deriving Repr

private def cleanLines (text : String) : List String :=
  (text.splitOn "\n").map String.trim |>.filter (fun line => line != "")

private def parseBool (text : String) : Option Bool :=
  if text == "true" then some true else if text == "false" then some false else none

private def parseHardwareProfile (line : String) : Option RuntimeHardwareProfile :=
  match line.splitOn "|" with
  | ["HARDWARE", witnessId, nodeId, platformId, rootId, verifierId, custody, publicKey] =>
      some {
        profile := {
          witnessId := witnessId
          nodeId := nodeId
          platformId := platformId
          attestationRootId := rootId
          platformVerifierId := verifierId
          platformVerifierCustody := custody }
        platformVerifierPublicKeyPath := publicKey }
  | _ => none

private def parseVerifierProfile (line : String) : Option RuntimeSplitVerifierProfile :=
  match line.splitOn "|" with
  | ["VERIFIER", verifierId, custody, publicKey] =>
      some {
        profile := { verifierId := verifierId, custodyDomain := custody }
        publicKeyPath := publicKey }
  | _ => none

def parseRuntimeHardwarePolicy (text : String) : Option RuntimeHardwarePolicy :=
  match cleanLines text with
  | header :: body =>
      match header.splitOn "|" with
      | [protocol, versionText, policyId, basePolicyId, lifetimeText,
          thresholdText, baseVerifierPublicKey] =>
          match versionText.toNat?, lifetimeText.toNat?, thresholdText.toNat? with
          | some version, some maxQuoteLifetime, some minApprovals =>
              if protocol != hardwarePolicyProtocol || version != hardwareAttestationProtocolVersion then none
              else
                let hardware := body.filterMap parseHardwareProfile
                let verifiers := body.filterMap parseVerifierProfile
                if hardware.length + verifiers.length != body.length then none
                else
                  let policy : HardwarePolicy := {
                    policyId := policyId
                    basePolicyId := basePolicyId
                    maxQuoteLifetime := maxQuoteLifetime
                    minApprovals := minApprovals
                    hardwareProfiles := hardware.map (fun p => p.profile)
                    verifierProfiles := verifiers.map (fun p => p.profile) }
                  if HardwarePolicyWellFormed policy then
                    some {
                      policy := policy
                      baseVerifierPublicKeyPath := baseVerifierPublicKey
                      hardwareProfiles := hardware
                      verifierProfiles := verifiers }
                  else none
          | _, _, _ => none
      | _ => none
  | [] => none

def readRuntimeHardwarePolicy (path : String) : IO (Option RuntimeHardwarePolicy) := do
  try pure (parseRuntimeHardwarePolicy (← IO.FS.readFile path))
  catch _ => pure none

def findRuntimeHardwareProfile
    (profiles : List RuntimeHardwareProfile) (witnessId : String) : Option RuntimeHardwareProfile :=
  profiles.find? (fun p => p.profile.witnessId == witnessId)

def findRuntimeVerifierProfile
    (profiles : List RuntimeSplitVerifierProfile) (verifierId : String) : Option RuntimeSplitVerifierProfile :=
  profiles.find? (fun p => p.profile.verifierId == verifierId)

structure ParsedPlatformReceipt where
  formal : PlatformVerifierReceipt
  deriving Repr

def parsePlatformReceipt (text : String) : Option ParsedPlatformReceipt :=
  match text.trim.splitOn "|" with
  | [protocol, versionText, policyId, baseEvidenceDigest, witnessId, nodeId,
      platformId, rootId, platformVerifierId, platformVerifierCustody, quoteNonce,
      rawQuoteDigest, pcrDigest, eventLogDigest, firmwareDigest, issuedText,
      expiresText, quoteVerifiedText, chainText, measurementsText] =>
      match versionText.toNat?, issuedText.toNat?, expiresText.toNat?,
          parseBool quoteVerifiedText, parseBool chainText, parseBool measurementsText with
      | some version, some issuedAt, some expiresAt, some quoteSignatureVerified,
          some chainAccepted, some measurementsAccepted =>
          if protocol != platformReceiptProtocol || version != hardwareAttestationProtocolVersion then none
          else some { formal := {
            policyId := policyId
            baseEvidenceDigest := baseEvidenceDigest
            witnessId := witnessId
            nodeId := nodeId
            platformId := platformId
            attestationRootId := rootId
            platformVerifierId := platformVerifierId
            platformVerifierCustody := platformVerifierCustody
            quoteNonce := quoteNonce
            rawQuoteDigest := rawQuoteDigest
            pcrDigest := pcrDigest
            eventLogDigest := eventLogDigest
            firmwareDigest := firmwareDigest
            issuedAt := issuedAt
            expiresAt := expiresAt
            quoteSignatureVerified := quoteSignatureVerified
            chainAccepted := chainAccepted
            measurementsAccepted := measurementsAccepted
            platformVerifierSignatureVerified := false } }
      | _, _, _, _, _, _ => none
  | _ => none

def parseSplitApproval (text : String) : Option SplitVerifierApproval :=
  match text.trim.splitOn "|" with
  | [protocol, versionText, policyId, evidenceDigest, verifierId, custody, decisionText] =>
      match versionText.toNat?, parseBool decisionText with
      | some version, some decision =>
          if protocol != splitApprovalProtocol || version != hardwareAttestationProtocolVersion then none
          else some {
            policyId := policyId
            hardwareEvidenceDigest := evidenceDigest
            verifierId := verifierId
            custodyDomain := custody
            decision := decision
            signatureVerified := false }
      | _, _ => none
  | _ => none

def encodeSplitApproval (a : SplitVerifierApproval) : String :=
  String.intercalate "|" [splitApprovalProtocol, toString hardwareAttestationProtocolVersion,
    a.policyId, a.hardwareEvidenceDigest, a.verifierId, a.custodyDomain,
    toString a.decision] ++ "\n"

private def verifiedBaseRef (runtime : RuntimeHardwarePolicy)
    (basePath baseSig : String) : IO (Option VerifiedAttestedEvidenceRef) := do
  match parseEvidenceReceipt (← IO.FS.readFile basePath), (← sha256File basePath) with
  | some base, some digest =>
      let verified ← verifyFile runtime.baseVerifierPublicKeyPath basePath baseSig
      pure (some {
        basePolicyId := base.policyId
        evidenceDigest := digest
        witnessId := base.witnessId
        nodeId := base.nodeId
        signatureVerified := verified })
  | _, _ => pure none

private def verifiedPlatformReceipt (runtime : RuntimeHardwarePolicy)
    (basePath baseSig receiptPath receiptSig : String) (now : Nat) :
    IO (Option (VerifiedAttestedEvidenceRef × PlatformVerifierReceipt × String)) := do
  match (← verifiedBaseRef runtime basePath baseSig),
      parsePlatformReceipt (← IO.FS.readFile receiptPath), (← sha256File receiptPath) with
  | some base, some parsed, some digest =>
      match findRuntimeHardwareProfile runtime.hardwareProfiles base.witnessId with
      | none => pure none
      | some hp =>
          let signatureVerified ← verifyFile hp.platformVerifierPublicKeyPath receiptPath receiptSig
          let receipt := { parsed.formal with platformVerifierSignatureVerified := signatureVerified }
          if PlatformReceiptBound runtime.policy hp.profile base now receipt then
            pure (some (base, receipt, digest))
          else pure none
  | _, _, _ => pure none

inductive HardwareVerificationOutcome where
  | verified (base : VerifiedAttestedEvidenceRef) (receipt : PlatformVerifierReceipt)
      (evidenceDigest : String)
  | hold (reason : String)
  deriving Repr

def verifyHardwareReceipt (policyPath basePath baseSig receiptPath receiptSig : String)
    (now : Nat) : IO HardwareVerificationOutcome := do
  match (← readRuntimeHardwarePolicy policyPath) with
  | none => pure (.hold "hardware policy parse or separation check failed")
  | some runtime =>
      match (← verifiedPlatformReceipt runtime basePath baseSig receiptPath receiptSig now) with
      | some (base, receipt, digest) => pure (.verified base receipt digest)
      | none => pure (.hold "base signature, quote binding, platform signature, trust chain, measurements or freshness failed")

def writeSplitApproval (policyPath basePath baseSig receiptPath receiptSig : String)
    (now : Nat) (verifierId privateKey output sig : String) : IO Bool := do
  match (← readRuntimeHardwarePolicy policyPath) with
  | none => pure false
  | some runtime =>
      match (← verifiedPlatformReceipt runtime basePath baseSig receiptPath receiptSig now),
          findRuntimeVerifierProfile runtime.verifierProfiles verifierId with
      | some (_, _, digest), some verifier =>
          let approval : SplitVerifierApproval := {
            policyId := runtime.policy.policyId, hardwareEvidenceDigest := digest,
            verifierId, custodyDomain := verifier.profile.custodyDomain,
            decision := true, signatureVerified := true }
          IO.FS.writeFile output (encodeSplitApproval approval)
          if !(← signFile privateKey output sig) then pure false
          else verifyFile verifier.publicKeyPath output sig
      | _, _ => pure false

private def collectApprovals (runtime : RuntimeHardwarePolicy) (dir : String) :
    IO (Except String (List (SplitVerifierApproval × String))) := do
  let entries ← (dir : System.FilePath).readDir
  let mut approvals : List (SplitVerifierApproval × String) := []
  for entry in entries do
    if entry.fileName.endsWith ".i3hs" then
      match parseSplitApproval (← IO.FS.readFile entry.path), (← sha256File entry.path.toString) with
      | some approval, some digest =>
          match findRuntimeVerifierProfile runtime.verifierProfiles approval.verifierId with
          | none => return .error s!"unknown split verifier: {approval.verifierId}"
          | some verifier =>
              let verified ← verifyFile verifier.publicKeyPath entry.path.toString
                (entry.path.toString ++ ".sig")
              approvals := ({ approval with signatureVerified := verified }, digest) :: approvals
      | _, _ => return .error s!"approval parse failed: {entry.fileName}"
  pure (.ok approvals.reverse)

def encodeHardwareCertificate (c : HardwareAdmissionCertificate) : String :=
  String.intercalate "|" [hardwareCertificateProtocol, toString c.protocolVersion,
    c.policyId, toString c.threshold, c.baseEvidenceDigest, c.hardwareEvidenceDigest,
    String.intercalate "," c.verifierIds, String.intercalate "," c.custodyDomains,
    String.intercalate "," c.approvalDigests] ++ "\n"

inductive HardwareQuorumOutcome where
  | admitted (certificate : HardwareAdmissionCertificate)
  | hold (reason : String)
  deriving Repr

def evaluateHardwareQuorum (policyPath basePath baseSig receiptPath receiptSig : String)
    (now : Nat) (approvalDir certificatePath : String) : IO HardwareQuorumOutcome := do
  match (← readRuntimeHardwarePolicy policyPath) with
  | none => pure (.hold "hardware policy parse or separation check failed")
  | some runtime =>
      match (← verifiedPlatformReceipt runtime basePath baseSig receiptPath receiptSig now) with
      | none => pure (.hold "hardware evidence failed before quorum")
      | some (base, _, evidenceDigest) =>
          match (← collectApprovals runtime approvalDir) with
          | .error reason => pure (.hold reason)
          | .ok paired =>
              let approvals := paired.map (fun p => p.1)
              if IndependentApprovalSet runtime.policy evidenceDigest approvals then
                let certificate : HardwareAdmissionCertificate := {
                  protocolVersion := hardwareAttestationProtocolVersion,
                  policyId := runtime.policy.policyId,
                  threshold := runtime.policy.minApprovals,
                  baseEvidenceDigest := base.evidenceDigest,
                  hardwareEvidenceDigest := evidenceDigest,
                  verifierIds := approvals.map (fun a => a.verifierId),
                  custodyDomains := approvals.map (fun a => a.custodyDomain),
                  approvalDigests := paired.map (fun p => p.2) }
                IO.FS.writeFile certificatePath (encodeHardwareCertificate certificate)
                pure (.admitted certificate)
              else if approvals.length < runtime.policy.minApprovals then
                pure (.hold "insufficient split-verifier approvals")
              else if !(decide (approvals.map (fun a => a.verifierId)).Nodup) then
                pure (.hold "duplicate split verifier")
              else if !(decide (approvals.map (fun a => a.custodyDomain)).Nodup) then
                pure (.hold "shared split-verifier custody")
              else if approvals.any (fun a => a.signatureVerified != true) then
                pure (.hold "invalid split-verifier signature")
              else pure (.hold "approval denied or bound to different hardware evidence")

end TMI.DigitalLifeHardwareAttestationRuntime
