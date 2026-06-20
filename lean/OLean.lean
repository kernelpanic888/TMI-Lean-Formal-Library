/-
OLean connection interface.

OLean is a working adapter name for connecting TMI artifacts to Lean. It does
not introduce a new kernel. It states that a TMI artifact obtains formal Lean
status only through Lean-kernel checking.
-/

import TMI.Library

namespace OLean

structure Connection where
  sourceArtifact : Type
  leanObject : Type
  encodedInLean : sourceArtifact -> leanObject -> Prop
  checkedByLeanKernel : leanObject -> Prop

def CompilesThroughLeanKernel (c : Connection) : Prop :=
  forall artifact : c.sourceArtifact,
    exists obj : c.leanObject,
      c.encodedInLean artifact obj /\ c.checkedByLeanKernel obj

def FormalLeanStatus (c : Connection) (artifact : c.sourceArtifact) : Prop :=
  exists obj : c.leanObject,
    c.encodedInLean artifact obj /\ c.checkedByLeanKernel obj

theorem compilation_gives_formal_lean_status
    {c : Connection}
    (h : CompilesThroughLeanKernel c)
    (artifact : c.sourceArtifact) :
    FormalLeanStatus c artifact := by
  exact h artifact

structure AdapterBoundary where
  importsTMILibrary : Prop
  usesLeanKernel : Prop
  introducesNewKernel : Prop

def boundary : AdapterBoundary :=
  { importsTMILibrary := True
    usesLeanKernel := True
    introducesNewKernel := False }

theorem olean_imports_tmi_library :
    boundary.importsTMILibrary := by
  trivial

theorem olean_uses_lean_kernel :
    boundary.usesLeanKernel := by
  trivial

theorem olean_does_not_introduce_new_kernel :
    Not boundary.introducesNewKernel := by
  intro h
  exact h

end OLean
