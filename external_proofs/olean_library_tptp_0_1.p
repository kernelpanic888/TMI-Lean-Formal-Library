% TMI-Lean Formal Library 0.1 external proof surface.
% Scope: OLean + TMI.Library release boundary.
% ATP target: positive release-boundary theorem bundle.

tff(artifact_type, type, artifact: $tType).
tff(lean_object_type, type, lean_object: $tType).
tff(release_type, type, release: $tType).
tff(branch_type, type, branch: $tType).

tff(current_release_decl, type, current_release: release).

tff(md_decl, type, md: branch).
tff(qc_decl, type, qc: branch).
tff(qg_decl, type, qg: branch).
tff(life_decl, type, life: branch).
tff(ops_decl, type, ops: branch).

tff(encoded_in_lean_decl, type,
  encoded_in_lean: (artifact * lean_object) > $o).
tff(checked_by_lean_kernel_decl, type,
  checked_by_lean_kernel: lean_object > $o).
tff(formal_lean_status_decl, type,
  formal_lean_status: artifact > $o).

tff(imports_tmi_library_decl, type,
  imports_tmi_library: release > $o).
tff(uses_lean_kernel_decl, type,
  uses_lean_kernel: release > $o).
tff(introduces_new_kernel_decl, type,
  introduces_new_kernel: release > $o).
tff(tmi_lean_library_is_lean_fork_decl, type,
  tmi_lean_library_is_lean_fork: release > $o).
tff(guarded_branch_decl, type,
  guarded_branch: branch > $o).

tff(encoded_checked_gives_formal_status, axiom,
  ! [A: artifact, O: lean_object] :
    ( ( encoded_in_lean(A, O)
      & checked_by_lean_kernel(O) )
   => formal_lean_status(A) )).

tff(olean_imports_tmi_library, axiom,
  imports_tmi_library(current_release)).

tff(olean_uses_lean_kernel, axiom,
  uses_lean_kernel(current_release)).

tff(olean_does_not_introduce_new_kernel, axiom,
  ~ introduces_new_kernel(current_release)).

tff(tmi_lean_library_not_fork, axiom,
  ~ tmi_lean_library_is_lean_fork(current_release)).

tff(md_is_guarded, axiom, guarded_branch(md)).
tff(qc_is_guarded, axiom, guarded_branch(qc)).
tff(qg_is_guarded, axiom, guarded_branch(qg)).
tff(life_is_guarded, axiom, guarded_branch(life)).
tff(ops_is_guarded, axiom, guarded_branch(ops)).

tff(olean_library_release_boundary_bundle, conjecture,
  ( ! [A: artifact, O: lean_object] :
      ( ( encoded_in_lean(A, O)
        & checked_by_lean_kernel(O) )
     => formal_lean_status(A) )
  & imports_tmi_library(current_release)
  & uses_lean_kernel(current_release)
  & ~ introduces_new_kernel(current_release)
  & ~ tmi_lean_library_is_lean_fork(current_release)
  & guarded_branch(md)
  & guarded_branch(qc)
  & guarded_branch(qg)
  & guarded_branch(life)
  & guarded_branch(ops) )).
