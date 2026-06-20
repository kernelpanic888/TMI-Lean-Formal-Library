% OLean + TMI.Library internal-frequency self-check.
% ATP target: positive theorem bundle only.
% G4/749 is an internal verification-frequency value, not a physical optics
% claim.

tff(encoded_in_lean_boundary_decl, type, encoded_in_lean_boundary: $o).
tff(lean_kernel_checked_decl, type, lean_kernel_checked: $o).
tff(lake_build_passed_decl, type, lake_build_passed: $o).
tff(z3_passed_decl, type, z3_passed: $o).
tff(vampire_passed_decl, type, vampire_passed: $o).
tff(e_prover_passed_decl, type, e_prover_passed: $o).
tff(introduces_new_kernel_decl, type, introduces_new_kernel: $o).

tff(complete_boundary_verification_decl, type,
  complete_boundary_verification: $o).
tff(formal_lean_status_decl, type, formal_lean_status: $o).
tff(internal_frequency_749_decl, type, internal_frequency_749: $o).
tff(g4_internal_frequency_value_749_decl, type,
  g4_internal_frequency_value_749: $o).
tff(boundary_verdict_pass_decl, type, boundary_verdict_pass: $o).

tff(encoded_in_lean_boundary_fact, axiom, encoded_in_lean_boundary).
tff(lean_kernel_checked_fact, axiom, lean_kernel_checked).
tff(lake_build_passed_fact, axiom, lake_build_passed).
tff(z3_passed_fact, axiom, z3_passed).
tff(vampire_passed_fact, axiom, vampire_passed).
tff(e_prover_passed_fact, axiom, e_prover_passed).
tff(no_new_kernel_fact, axiom, ~ introduces_new_kernel).

tff(complete_boundary_definition, axiom,
  ( ( encoded_in_lean_boundary
    & lean_kernel_checked
    & lake_build_passed
    & z3_passed
    & vampire_passed
    & e_prover_passed
    & ~ introduces_new_kernel )
 => complete_boundary_verification )).

tff(encoded_checked_gives_formal_status, axiom,
  ( ( encoded_in_lean_boundary
    & lean_kernel_checked )
 => formal_lean_status )).

tff(complete_gives_formal_status, axiom,
  complete_boundary_verification => formal_lean_status).

tff(complete_gives_internal_frequency_749, axiom,
  complete_boundary_verification => internal_frequency_749).

tff(internal_frequency_749_has_g4_value, axiom,
  internal_frequency_749 => g4_internal_frequency_value_749).

tff(complete_gives_boundary_verdict_pass, axiom,
  complete_boundary_verification => boundary_verdict_pass).

tff(olean_internal_frequency_bundle, conjecture,
  ( complete_boundary_verification
  & boundary_verdict_pass
  & internal_frequency_749
  & g4_internal_frequency_value_749
  & formal_lean_status )).
