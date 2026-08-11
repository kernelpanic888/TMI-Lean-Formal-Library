import TMI.DigitalLifeValidationWire

/-! Runtime adapters for the I3 validation wire. -/

namespace TMI.DigitalLifeValidationWireRuntime

open TMI.DigitalLifeValidationAdapter
open TMI.DigitalLifeValidationWire

def opensslCommand : IO String := do
  match (← IO.getEnv "I3_OPENSSL") with
  | some command => pure command
  | none => pure "/opt/homebrew/bin/openssl"

structure HoldoutBundle where
  datasetId : Nat
  splitVersion : Nat
  view : ValidatorView
  deriving DecidableEq, Repr

def parseSampleLine (line : String) : Option Sample := do
  match line.trim.splitOn "|" with
  | [id, x, y, z, memory, reflection, target] =>
      let id ← id.toNat?
      let x ← x.toInt?
      let y ← y.toInt?
      let z ← z.toInt?
      let memory ← memory.toInt?
      let reflection ← reflection.toInt?
      let target ← target.toInt?
      some { id, x, y, z, memory, reflection, target }
  | _ => none

def parseHoldout (text : String) : Option HoldoutBundle := do
  match text.trim.splitOn "\n" with
  | header :: rows =>
      match header.trim.splitOn "|" with
      | ["I3HOLD1", datasetId, splitVersion] =>
          let datasetId ← datasetId.toNat?
          let splitVersion ← splitVersion.toNat?
          let samples ← rows.mapM parseSampleLine
          some { datasetId, splitVersion, view := { holdout := samples } }
      | _ => none
  | _ => none

def sha256File (path : String) : IO (Option String) := do
  let openssl ← opensslCommand
  let result ← IO.Process.output
    { cmd := openssl, args := #["dgst", "-sha256", "-r", path] }
  if result.exitCode != 0 then
    pure none
  else
    match result.stdout.trim.splitOn " " with
    | digest :: _ => pure (if digest.length = 64 then some digest else none)
    | _ => pure none

def signFile (privateKey payload signature : String) : IO Bool := do
  let openssl ← opensslCommand
  let result ← IO.Process.output
    { cmd := openssl
      args := #["pkeyutl", "-sign", "-rawin", "-inkey", privateKey,
        "-in", payload, "-out", signature] }
  pure (result.exitCode = 0)

def verifyFile (publicKey payload signature : String) : IO Bool := do
  let openssl ← opensslCommand
  let result ← IO.Process.output
    { cmd := openssl
      args := #["pkeyutl", "-verify", "-rawin", "-pubin", "-inkey", publicKey,
        "-in", payload, "-sigfile", signature] }
  pure (result.exitCode = 0)

def readRequest (path : String) : IO (Option WireRequest) := do
  pure (parseRequest (← IO.FS.readFile path))

def readReceipt (path : String) : IO (Option WireReceiptBody) := do
  pure (parseReceipt (← IO.FS.readFile path))

def readHoldout (path : String) : IO (Option HoldoutBundle) := do
  pure (parseHoldout (← IO.FS.readFile path))

def writeRequest (path : String) (request : WireRequest) : IO Unit :=
  IO.FS.writeFile path (encodeRequest request ++ "\n")

def writeReceipt (path : String) (receipt : WireReceiptBody) : IO Unit :=
  IO.FS.writeFile path (encodeReceipt receipt ++ "\n")

end TMI.DigitalLifeValidationWireRuntime
