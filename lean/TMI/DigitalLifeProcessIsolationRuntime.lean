import TMI.DigitalLifeProcessIsolation
import TMI.DigitalLifeAtomicTrustStoreRuntime

/-! Runtime codecs and macOS sandbox profiles for I3-L08. -/

namespace TMI.DigitalLifeProcessIsolationRuntime

open TMI.DigitalLifeNeuralProposer
open TMI.DigitalLifeBoundedLearning
open TMI.DigitalLifeValidationAdapter
open TMI.DigitalLifeValidationCapability
open TMI.DigitalLifeValidationWire
open TMI.DigitalLifePersistentTrust
open TMI.DigitalLifePersistentTrustRuntime
open TMI.DigitalLifeAtomicTrustStore
open TMI.DigitalLifeAtomicTrustStoreRuntime
open TMI.DigitalLifeProcessIsolation

def publicSnapshotProtocol : String := "I3PUBLIC1"
def isolatedProposalProtocol : String := "I3PROPOSAL1"

def encodePublicSnapshot (snapshot : PublicModelSnapshot) : String :=
  String.intercalate "|"
    [ publicSnapshotProtocol,
      toString snapshot.protocolVersion,
      toString snapshot.generation,
      toString snapshot.validatorId,
      toString snapshot.trustEpoch,
      toString snapshot.keyId,
      toString snapshot.lastRequestId,
      snapshot.receiptHead,
      snapshot.manifestDigest,
      toString snapshot.learning.modelIdentity,
      toString snapshot.learning.version,
      toString (encodeInt snapshot.learning.parameters.wx),
      toString (encodeInt snapshot.learning.parameters.wy),
      toString (encodeInt snapshot.learning.parameters.wz),
      toString (encodeInt snapshot.learning.parameters.wm),
      toString (encodeInt snapshot.learning.parameters.wr),
      toString (encodeInt snapshot.learning.parameters.bias),
      toString snapshot.learning.validationLoss,
      toString snapshot.learning.receipt ]

def parsePublicSnapshot (text : String) : Option PublicModelSnapshot := do
  match text.trim.splitOn "|" with
  | [ protocol, protocolVersion, generation, validatorId, trustEpoch, keyId,
      lastRequestId, receiptHead, manifestDigest, modelIdentity, modelVersion,
      wx, wy, wz, wm, wr, bias, validationLoss, receiptIndex ] =>
      if protocol != publicSnapshotProtocol then none
      let protocolVersion ← protocolVersion.toNat?
      let generation ← generation.toNat?
      let validatorId ← validatorId.toNat?
      let trustEpoch ← trustEpoch.toNat?
      let keyId ← keyId.toNat?
      let lastRequestId ← lastRequestId.toNat?
      let modelIdentity ← modelIdentity.toNat?
      let modelVersion ← modelVersion.toNat?
      let wx ← wx.toNat?
      let wy ← wy.toNat?
      let wz ← wz.toNat?
      let wm ← wm.toNat?
      let wr ← wr.toNat?
      let bias ← bias.toNat?
      let validationLoss ← validationLoss.toNat?
      let receiptIndex ← receiptIndex.toNat?
      some
        { protocolVersion, generation, validatorId, trustEpoch, keyId,
          lastRequestId, receiptHead, manifestDigest,
          learning :=
            { modelIdentity, version := modelVersion,
              parameters :=
                { wx := decodeInt wx, wy := decodeInt wy, wz := decodeInt wz,
                  wm := decodeInt wm, wr := decodeInt wr, bias := decodeInt bias },
              validationLoss, receipt := receiptIndex } }
  | _ => none

def encodeIsolatedProposal (proposal : IsolatedProposal) : String :=
  String.intercalate "|"
    [ isolatedProposalProtocol,
      toString proposal.protocolVersion,
      toString proposal.generation,
      toString proposal.modelIdentity,
      toString proposal.modelVersion,
      toString proposal.receiptIndex,
      proposal.previousReceiptHead,
      toString proposal.trustEpoch,
      toString proposal.keyId,
      toString proposal.lastRequestId,
      proposal.manifestDigest,
      toString (encodeInt proposal.delta.wx),
      toString (encodeInt proposal.delta.wy),
      toString (encodeInt proposal.delta.wz),
      toString (encodeInt proposal.delta.wm),
      toString (encodeInt proposal.delta.wr),
      toString (encodeInt proposal.delta.bias) ]

def parseIsolatedProposal (text : String) : Option IsolatedProposal := do
  match text.trim.splitOn "|" with
  | [ protocol, protocolVersion, generation, modelIdentity, modelVersion,
      receiptIndex, previousReceiptHead, trustEpoch, keyId, lastRequestId,
      manifestDigest, wx, wy, wz, wm, wr, bias ] =>
      if protocol != isolatedProposalProtocol then none
      let protocolVersion ← protocolVersion.toNat?
      let generation ← generation.toNat?
      let modelIdentity ← modelIdentity.toNat?
      let modelVersion ← modelVersion.toNat?
      let receiptIndex ← receiptIndex.toNat?
      let trustEpoch ← trustEpoch.toNat?
      let keyId ← keyId.toNat?
      let lastRequestId ← lastRequestId.toNat?
      let wx ← wx.toNat?
      let wy ← wy.toNat?
      let wz ← wz.toNat?
      let wm ← wm.toNat?
      let wr ← wr.toNat?
      let bias ← bias.toNat?
      some
        { protocolVersion, generation, modelIdentity, modelVersion, receiptIndex,
          previousReceiptHead, trustEpoch, keyId, lastRequestId, manifestDigest,
          delta :=
            { wx := decodeInt wx, wy := decodeInt wy, wz := decodeInt wz,
              wm := decodeInt wm, wr := decodeInt wr, bias := decodeInt bias } }
  | _ => none

def readPublicSnapshot (path : String) : IO (Option PublicModelSnapshot) := do
  pure (parsePublicSnapshot (← IO.FS.readFile path))

def writePublicSnapshot (path : String) (snapshot : PublicModelSnapshot) : IO Unit :=
  IO.FS.writeFile path (encodePublicSnapshot snapshot ++ "\n")

def readIsolatedProposal (path : String) : IO (Option IsolatedProposal) := do
  pure (parseIsolatedProposal (← IO.FS.readFile path))

def writeIsolatedProposal (path : String) (proposal : IsolatedProposal) : IO Unit :=
  IO.FS.writeFile path (encodeIsolatedProposal proposal ++ "\n")

def exportPublicModel (storePath outputPath : String) : IO Bool := do
  match (← readAtomicSnapshot storePath) with
  | none => pure false
  | some snapshot =>
      writePublicSnapshot outputPath (publicSnapshotOf snapshot)
      pure true

def produceDemoProposal (snapshotPath proposalPath : String) : IO Bool := do
  match (← readPublicSnapshot snapshotPath) with
  | none => pure false
  | some snapshot =>
      if snapshot.protocolVersion != isolationProtocolVersion then
        pure false
      else
        let delta := (runTrainer snapshot.learning.parameters demoTraining).delta
        writeIsolatedProposal proposalPath (makeIsolatedProposal snapshot delta)
        pure true

def makeAtomicRequestFromProposal
    (storePath proposalPath requestPath nonce : String) :
    IO (Option (AtomicTrustSnapshot × StatefulWireRequest)) := do
  match (← readAtomicSnapshot storePath), (← readIsolatedProposal proposalPath) with
  | some snapshot, some proposal =>
      if ProposalRequestReady snapshot proposal nonce then
        let request := makeStatefulRequest snapshot.trust nonce proposal.delta
        writeStatefulRequest requestPath request
        pure (some (snapshot, request))
      else
        pure none
  | _, _ => pure none

def roleName : ProcessRole → String
  | .trainerExecutor => "trainer"
  | .validator => "validator"
  | .trustStore => "trust"
  | .externalWitness => "witness"

def parseRole : String → Option ProcessRole
  | "trainer" => some .trainerExecutor
  | "validator" => some .validator
  | "trust" => some .trustStore
  | "witness" => some .externalWitness
  | _ => none

def layoutDirectories : List String :=
  [ "public",
    "trainer/input", "trainer/outbox",
    "validator/holdout", "validator/private", "validator/outbox",
    "trust/store",
    "witness/private", "witness/log", "witness/outbox",
    "exchange/trust", "exchange/witness", "profiles" ]

def initializeRoleLayout (root : String) : IO Unit := do
  for suffix in layoutDirectories do
    IO.FS.createDirAll (root ++ "/" ++ suffix)

private def hasUnsafeProfileChar (path : String) : Bool :=
  path.toList.any (fun c => c == '\"' || c == '\n' || c == '\r')

private def canonicalSandboxPath (path : String) : String :=
  if path == "/tmp" || path == "/var" then
    "/private" ++ path
  else if path.startsWith "/tmp/" || path.startsWith "/var/" then
    "/private" ++ path
  else
    path

def safeAbsolutePath (path : String) : Bool :=
  path.startsWith "/" && !hasUnsafeProfileChar path

def rootsSeparated (repositoryRoot runtimeRoot : String) : Bool :=
  !(runtimeRoot.startsWith (repositoryRoot ++ "/")) &&
  !(repositoryRoot.startsWith (runtimeRoot ++ "/")) &&
  repositoryRoot != runtimeRoot

private def rooted (root suffix : String) : String := root ++ "/" ++ suffix

def roleReadRoots (role : ProcessRole) (runtimeRoot : String) : List String :=
  match role with
  | .trainerExecutor =>
      [ rooted runtimeRoot "public", rooted runtimeRoot "trainer" ]
  | .validator =>
      [ rooted runtimeRoot "public", rooted runtimeRoot "validator",
        rooted runtimeRoot "exchange/trust" ]
  | .trustStore =>
      [ rooted runtimeRoot "public", rooted runtimeRoot "trust",
        rooted runtimeRoot "trainer/outbox", rooted runtimeRoot "validator/outbox",
        rooted runtimeRoot "exchange/trust" ]
  | .externalWitness =>
      [ rooted runtimeRoot "public", rooted runtimeRoot "witness",
        rooted runtimeRoot "trust/store", rooted runtimeRoot "exchange/witness" ]

def roleWriteRoots (role : ProcessRole) (runtimeRoot : String) : List String :=
  match role with
  | .trainerExecutor => [ rooted runtimeRoot "trainer/outbox" ]
  | .validator => [ rooted runtimeRoot "validator/outbox" ]
  | .trustStore =>
      [ rooted runtimeRoot "public", rooted runtimeRoot "trust/store",
        rooted runtimeRoot "exchange/trust" ]
  | .externalWitness =>
      [ rooted runtimeRoot "witness/log", rooted runtimeRoot "witness/outbox",
        rooted runtimeRoot "exchange/witness" ]

private def subpathClause (path : String) : String :=
  "(subpath \"" ++ path ++ "\")"

private def allowPathRule (operation : String) (paths : List String) : String :=
  "(allow " ++ operation ++ " " ++
    String.intercalate " " (paths.map subpathClause) ++ ")"

def sandboxProfile
    (role : ProcessRole)
    (repositoryRoot runtimeRoot : String) : Option String :=
  let repositoryRoot := canonicalSandboxPath repositoryRoot
  let runtimeRoot := canonicalSandboxPath runtimeRoot
  if !safeAbsolutePath repositoryRoot || !safeAbsolutePath runtimeRoot ||
      !rootsSeparated repositoryRoot runtimeRoot then
    none
  else
    let writes := roleWriteRoots role runtimeRoot
    let reads :=
      [ "/System", "/usr", "/Library", "/opt/homebrew",
        "/private/var/db/dyld", "/dev", repositoryRoot ] ++
      roleReadRoots role runtimeRoot ++ writes
    some (String.intercalate "\n"
      [ "(version 1)",
        "(deny default)",
        "(import \"system.sb\")",
        "(allow process*)",
        "(allow sysctl-read)",
        "(allow mach-lookup)",
        "(allow user-preference-read)",
        "(allow file-read-metadata)",
        allowPathRule "file-read*" reads,
        allowPathRule "file-write*" writes,
        "" ])

def writeSandboxProfile
    (role : ProcessRole)
    (repositoryRoot runtimeRoot outputPath : String) : IO Bool := do
  match sandboxProfile role repositoryRoot runtimeRoot with
  | none => pure false
  | some profile =>
      IO.FS.writeFile outputPath profile
      pure true

end TMI.DigitalLifeProcessIsolationRuntime
