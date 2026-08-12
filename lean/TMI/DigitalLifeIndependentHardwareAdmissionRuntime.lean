import TMI.DigitalLifeIndependentHardwareAdmission

namespace TMI.DigitalLifeIndependentHardwareAdmissionRuntime

open TMI.DigitalLifeIndependentHardwareAdmission

inductive VerificationOutcome where
  | admitted
  | hold (reason : String)
  deriving Repr

private def field? (fields : List String) (index : Nat) : Except String String :=
  match fields[index]? with
  | some value => .ok value
  | none => .error s!"missing field {index + 1}"

private def parseNatField (name value : String) : Except String Nat :=
  match value.toNat? with
  | some parsed => .ok parsed
  | none => .error s!"invalid natural number in {name}"

private def parseBoolField (name value : String) : Except String Bool :=
  match value with
  | "1" | "true" => .ok true
  | "0" | "false" => .ok false
  | _ => .error s!"invalid boolean in {name}"

def parsePolicy (text : String) : Except String AdmissionPolicy := do
  let fields := text.trimAscii.toString.splitOn "|"
  if fields.length != 14 then
    throw s!"policy must contain 14 fields, found {fields.length}"
  return {
    protocol := ← field? fields 0
    version := ← parseNatField "version" (← field? fields 1)
    policyId := ← field? fields 2
    expectedL15PolicyDigest := ← field? fields 3
    expectedL14ReceiptDigest := ← field? fields 4
    expectedPlatformProfileDigest := ← field? fields 5
    expectedTransportProfileDigest := ← field? fields 6
    expectedChallengeDomain := ← field? fields 7
    expectedTlsPeerDigest := ← field? fields 8
    expectedMeasurementPolicyDigest := ← field? fields 9
    expectedWitnessPolicyDigest := ← field? fields 10
    minIndependentWitnesses := ← parseNatField "minIndependentWitnesses" (← field? fields 11)
    minFaultDomains := ← parseNatField "minFaultDomains" (← field? fields 12)
    maxEvidenceAge := ← parseNatField "maxEvidenceAge" (← field? fields 13)
  }

def parseEvidence (text : String) : Except String AdmissionEvidence := do
  let fields := text.trimAscii.toString.splitOn "|"
  if fields.length != 24 then
    throw s!"evidence must contain 24 fields, found {fields.length}"
  return {
    protocol := ← field? fields 0
    version := ← parseNatField "version" (← field? fields 1)
    policyId := ← field? fields 2
    l15PolicyDigest := ← field? fields 3
    l14ReceiptDigest := ← field? fields 4
    platformProfileDigest := ← field? fields 5
    transportProfileDigest := ← field? fields 6
    challengeDomain := ← field? fields 7
    tlsPeerDigest := ← field? fields 8
    measurementPolicyDigest := ← field? fields 9
    witnessPolicyDigest := ← field? fields 10
    observedAt := ← parseNatField "observedAt" (← field? fields 11)
    witnessCount := ← parseNatField "witnessCount" (← field? fields 12)
    faultDomainCount := ← parseNatField "faultDomainCount" (← field? fields 13)
    l15EnrollmentReady := ← parseBoolField "l15EnrollmentReady" (← field? fields 14)
    localHardwarePass := ← parseBoolField "localHardwarePass" (← field? fields 15)
    freshRemoteChallenge := ← parseBoolField "freshRemoteChallenge" (← field? fields 16)
    remoteResponseSignatureValid := ← parseBoolField "remoteResponseSignatureValid" (← field? fields 17)
    transportAttestationValid := ← parseBoolField "transportAttestationValid" (← field? fields 18)
    platformQuoteChainTrusted := ← parseBoolField "platformQuoteChainTrusted" (← field? fields 19)
    measurementsAccepted := ← parseBoolField "measurementsAccepted" (← field? fields 20)
    splitCustodyApproved := ← parseBoolField "splitCustodyApproved" (← field? fields 21)
    witnessSignaturesValid := ← parseBoolField "witnessSignaturesValid" (← field? fields 22)
    faultDomainQuorumIndependent := ← parseBoolField "faultDomainQuorumIndependent" (← field? fields 23)
  }

def verify (p : AdmissionPolicy) (e : AdmissionEvidence) (now : Nat) : VerificationOutcome :=
  if p.protocol != "I3IRHAP1" ∨ p.version != 1 then .hold "unsupported policy protocol"
  else if p.policyId.isEmpty then .hold "empty policy identity"
  else if p.expectedL15PolicyDigest.length != 64 then .hold "invalid L15 policy digest"
  else if p.expectedL14ReceiptDigest.length != 64 then .hold "invalid L14 receipt digest"
  else if p.expectedPlatformProfileDigest.length != 64 then .hold "invalid platform profile digest"
  else if p.expectedTransportProfileDigest.length != 64 then .hold "invalid transport profile digest"
  else if p.expectedChallengeDomain.isEmpty then .hold "empty challenge domain"
  else if p.expectedTlsPeerDigest.length != 64 then .hold "invalid TLS peer digest"
  else if p.expectedMeasurementPolicyDigest.length != 64 then .hold "invalid measurement policy digest"
  else if p.expectedWitnessPolicyDigest.length != 64 then .hold "invalid witness policy digest"
  else if p.minIndependentWitnesses < 2 then .hold "witness policy is not independent"
  else if p.minFaultDomains < 2 then .hold "fault-domain policy is not independent"
  else if p.maxEvidenceAge = 0 then .hold "zero evidence lifetime"
  else if e.protocol != "I3IRHAE1" ∨ e.version != 1 then .hold "unsupported evidence protocol"
  else if e.policyId != p.policyId then .hold "policy identity mismatch"
  else if e.l15PolicyDigest != p.expectedL15PolicyDigest then .hold "L15 policy mismatch"
  else if e.l14ReceiptDigest != p.expectedL14ReceiptDigest then .hold "L14 receipt mismatch"
  else if e.platformProfileDigest != p.expectedPlatformProfileDigest then .hold "platform profile mismatch"
  else if e.transportProfileDigest != p.expectedTransportProfileDigest then .hold "transport profile mismatch"
  else if e.challengeDomain != p.expectedChallengeDomain then .hold "challenge domain mismatch"
  else if e.tlsPeerDigest != p.expectedTlsPeerDigest then .hold "TLS peer mismatch"
  else if e.measurementPolicyDigest != p.expectedMeasurementPolicyDigest then .hold "measurement policy mismatch"
  else if e.witnessPolicyDigest != p.expectedWitnessPolicyDigest then .hold "witness policy mismatch"
  else if now < e.observedAt then .hold "evidence timestamp is in the future"
  else if p.maxEvidenceAge < now - e.observedAt then .hold "evidence expired"
  else if e.witnessCount < p.minIndependentWitnesses then .hold "insufficient independent witnesses"
  else if e.faultDomainCount < p.minFaultDomains then .hold "insufficient fault domains"
  else if !e.l15EnrollmentReady then .hold "L15 enrollment is not ready"
  else if !e.localHardwarePass then .hold "L14 local hardware receipt is not PASS"
  else if !e.freshRemoteChallenge then .hold "remote challenge is stale"
  else if !e.remoteResponseSignatureValid then .hold "remote response signature rejected"
  else if !e.transportAttestationValid then .hold "transport attestation rejected"
  else if !e.platformQuoteChainTrusted then .hold "platform quote chain untrusted"
  else if !e.measurementsAccepted then .hold "platform measurements rejected"
  else if !e.splitCustodyApproved then .hold "split custody approval missing"
  else if !e.witnessSignaturesValid then .hold "witness signatures rejected"
  else if !e.faultDomainQuorumIndependent then .hold "fault-domain quorum is not independent"
  else
    match evaluate p e now with
    | .globalHardwareAdmitted => .admitted
    | .hold => .hold "formal admission predicate rejected the stack"

end TMI.DigitalLifeIndependentHardwareAdmissionRuntime
