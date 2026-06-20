/-
TMI-Lean Formal Library 0.1.

This is the canonical public import for the standalone library package. It
keeps the first release focused on stable formal surfaces: core interface
theory, formula interfaces, bridge physics signatures, truth chains,
self-thinking universe boundaries, and interface mathematics.
-/

import TMI.Core
import TMI.PicT
import TMI.FormulaInterface
import TMI.BoundaryEvent
import TMI.ImportBoundary
import TMI.BridgePhysics
import TMI.Bridge
import TMI.ExternalProverBoundary
import TMI.ProofStatusClassification
import TMI.ProofChainSelfModel
import TMI.ClaimPassport
import TMI.WrapperTop
import TMI.TruthChain
import TMI.CollectiveIntelligence
import TMI.IESTA
import TMI.SelfThinkingUniverse
import TMI.InterfaceMathematics
import TMI.Branches

namespace TMI

def libraryName : String :=
  "TMI-Lean Formal Library"

def libraryVersion : String :=
  "0.1"

def libraryTagline : String :=
  "Formal Library for Interface-Event Theory in Lean 4"

structure LibraryManifest where
  name : String
  version : String
  tagline : String
  compiledByLeanKernel : Prop
  isLeanFork : Prop

def manifest : LibraryManifest :=
  { name := libraryName
    version := libraryVersion
    tagline := libraryTagline
    compiledByLeanKernel := True
    isLeanFork := False }

theorem tmi_lean_library_compiled_by_lean_kernel :
    manifest.compiledByLeanKernel := by
  trivial

theorem tmi_lean_library_is_not_lean_fork :
    Not manifest.isLeanFork := by
  intro h
  exact h

end TMI
