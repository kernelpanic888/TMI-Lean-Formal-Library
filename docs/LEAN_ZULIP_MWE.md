# Lean Zulip Minimal Working Example

This document follows the Lean community MWE rule: include all imports and make
the snippet copy-pasteable into an empty Lean file after cloning the package.

## How To Test Locally

From the repository root:

```bash
lake env lean examples/lean/TLFL_MWE.lean
lake env lean examples/lean/TLFL_CANONICAL_PASSPORT_STANDALONE.lean
```

Expected:

```text
the file elaborates successfully and prints #check output
```

## Copy-Paste MWE

```lean
import TMI.Library
import OLean

#check TMI.libraryName
#check TMI.manifest
#check TMI.tmi_lean_library_compiled_by_lean_kernel
#check TMI.tmi_lean_library_is_not_lean_fork

#check OLean.boundary
#check OLean.olean_imports_tmi_library
#check OLean.olean_uses_lean_kernel
#check OLean.olean_does_not_introduce_new_kernel

example : TMI.manifest.compiledByLeanKernel := by
  exact TMI.tmi_lean_library_compiled_by_lean_kernel

example : ¬ TMI.manifest.isLeanFork := by
  exact TMI.tmi_lean_library_is_not_lean_fork

example : OLean.boundary.importsTMILibrary := by
  exact OLean.olean_imports_tmi_library

example : OLean.boundary.usesLeanKernel := by
  exact OLean.olean_uses_lean_kernel

example : ¬ OLean.boundary.introducesNewKernel := by
  exact OLean.olean_does_not_introduce_new_kernel
```

## Standalone Canonical Passport

If the target environment does not contain the TLFL package and only accepts
plain Lean code, use the standalone passport file:

```text
examples/lean/TLFL_CANONICAL_PASSPORT_STANDALONE.lean
```

It has no imports and starts directly with:

```lean
namespace TLFLLibraryPassport
```

This avoids two common copy/paste failure modes:

```text
Markdown headers before Lean code
late import commands after pasted prose
```

## Zulip Text

```text
Hi! I’m preparing a standalone Lean 4 package for technical review.

Here is a minimal working example after cloning the repo:

  lake env lean examples/lean/TLFL_MWE.lean

It imports the package entry point and checks the package manifest and OLean
boundary facts. I’d appreciate feedback on whether this is a good MWE and on
the package shape: Lake setup, imports, module boundaries, naming, and
Reservoir readiness.

Package passport:
https://github.com/kernelpanic888/TMI-Lean-Formal-Library/blob/llm-gpt-codex-lean-tlfl-i1/latest-public-surface/docs/TLFL_LIBRARY_PASSPORT.md

MWE:
https://github.com/kernelpanic888/TMI-Lean-Formal-Library/blob/llm-gpt-codex-lean-tlfl-i1/latest-public-surface/examples/lean/TLFL_MWE.lean
```

## Guard

```text
This MWE demonstrates package imports and boundary facts.
It does not ask reviewers to evaluate the full philosophical surface.
```
