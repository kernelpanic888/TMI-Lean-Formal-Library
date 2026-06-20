/-
Smoke example for the OLean adapter.

This file is deliberately tiny: it proves that a trivial artifact can pass
through the OLean connection shape and receive formal Lean status.
-/

import OLean

namespace OLean

def SmokeConnection : Connection :=
  { sourceArtifact := Unit
    leanObject := Unit
    encodedInLean := fun _ _ => True
    checkedByLeanKernel := fun _ => True }

theorem smoke_compiles_through_lean_kernel :
    CompilesThroughLeanKernel SmokeConnection := by
  intro artifact
  exact ⟨(), by trivial, by trivial⟩

theorem smoke_artifact_has_formal_status :
    FormalLeanStatus SmokeConnection () := by
  exact compilation_gives_formal_lean_status
    smoke_compiles_through_lean_kernel
    ()

end OLean
