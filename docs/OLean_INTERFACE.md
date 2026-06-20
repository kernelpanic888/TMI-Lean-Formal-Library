# OLean Interface

`OLean` is the working name for the connection interface between TMI and Lean.

It is not a fork of Lean. It is not a new proof kernel. It is a Lean module
compiled by the ordinary Lean kernel.

## Canonical Boundary

```text
TMI artifact
-> OLean encoding interface
-> Lean object
-> Lean kernel check
-> formal Lean status
```

## Lean Surface

```lean
import OLean
```

Main public surfaces:

```text
OLean.Connection
OLean.CompilesThroughLeanKernel
OLean.FormalLeanStatus
OLean.compilation_gives_formal_lean_status
OLean.AdapterBoundary
OLean.olean_does_not_introduce_new_kernel
OLean.SmokeConnection
OLean.smoke_artifact_has_formal_status
OLean.CheckVerdict
OLean.BoundaryCheckInput
OLean.boundaryCheckVerdict
OLean.completeBoundaryCheckInput
OLean.leanOnlyBoundaryCheckInput
```

## Pass / Fail Verdict

`OLean.SelfCheck` adds a computable verdict function:

```lean
OLean.boundaryCheckVerdict : OLean.BoundaryCheckInput -> OLean.CheckVerdict
```

The verdict is `pass` only when the boundary input represents:

```text
encoded in Lean
+ Lean-kernel checked
+ Lake build passed
+ Z3 passed
+ Vampire passed
+ E prover passed
+ no new kernel introduced
```

Otherwise the verdict is `fail`.

## Non-Claim Boundary

`OLean` does not claim that every TMI statement is already proved. It only
defines the interface by which a TMI artifact receives formal Lean status:
encoding plus Lean-kernel checking.
