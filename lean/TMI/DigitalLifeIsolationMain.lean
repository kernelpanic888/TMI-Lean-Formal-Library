import TMI.DigitalLifeProcessIsolationRuntime

open TMI.DigitalLifeProcessIsolation
open TMI.DigitalLifeProcessIsolationRuntime

private def usage : String :=
  "i3_isolation init-layout <runtime-root>\n" ++
  "i3_isolation profile <trainer|validator|trust|witness> <repository-root> <runtime-root> <profile-file>\n" ++
  "i3_isolation export <atomic-store> <public-snapshot>\n" ++
  "i3_isolation propose <public-snapshot> <proposal-file>\n" ++
  "i3_isolation request <atomic-store> <proposal-file> <request-file> <nonce>"

private def emitHold (reason : String) : IO UInt32 := do
  IO.println s!"HOLD | {reason}"
  pure 2

def main (args : List String) : IO UInt32 := do
  match args with
  | ["init-layout", root] =>
      initializeRoleLayout root
      IO.println s!"ISOLATION LAYOUT | {root}"
      pure 0
  | ["profile", roleText, repositoryRoot, runtimeRoot, profilePath] =>
      match parseRole roleText with
      | none => emitHold "unknown process role"
      | some role =>
          if (← writeSandboxProfile role repositoryRoot runtimeRoot profilePath) then
            IO.println s!"ISOLATION PROFILE | role={roleName role} | {profilePath}"
            pure 0
          else
            emitHold "profile paths must be absolute, safe, and outside the repository"
  | ["export", storePath, snapshotPath] =>
      if (← exportPublicModel storePath snapshotPath) then
        IO.println s!"PUBLIC MODEL | {snapshotPath}"
        pure 0
      else
        emitHold "atomic trust store parse failed"
  | ["propose", snapshotPath, proposalPath] =>
      if (← produceDemoProposal snapshotPath proposalPath) then
        IO.println s!"ISOLATED PROPOSAL | {proposalPath}"
        pure 0
      else
        emitHold "public model snapshot parse or protocol check failed"
  | ["request", storePath, proposalPath, requestPath, nonce] =>
      match (← makeAtomicRequestFromProposal storePath proposalPath requestPath nonce) with
      | none => emitHold "proposal is stale, unbounded, malformed, or nonce is invalid"
      | some (snapshot, request) =>
          IO.println s!"BOUND REQUEST | generation={snapshot.generation} | head={snapshot.trust.receiptHead} | request={request.wire.requestId}"
          pure 0
  | _ =>
      IO.eprintln usage
      pure 64
