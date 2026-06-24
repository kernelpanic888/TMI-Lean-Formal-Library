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
