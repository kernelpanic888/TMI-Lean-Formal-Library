% TLFL 0.2 claim passport mirror.
% Positive theorem bundle for Vampire and E.

fof(claim_passport_axiom, axiom,
  ((claim_presented
    & lean_kernel_trace
    & z3_trace
    & vampire_trace
    & e_trace
    & tlfl_classification_trace
    & nonclaim_guard_trace
    & proof_self_model)
    => claim_passport)).

fof(allowed_ceiling_axiom, axiom,
  (claim_passport => allowed_claim_ceiling)).

fof(forbidden_jump_map_axiom, axiom,
  (claim_passport => forbidden_jump_map)).

fof(proof_state_certification_axiom, axiom,
  (claim_passport => proof_state_certification)).

fof(complete_input_verdict_axiom, axiom,
  (complete_claim_passport_input => verdict_pass)).

fof(missing_classification_verdict_axiom, axiom,
  (missing_tlfl_classification_input => verdict_fail)).

fof(pass_ceiling_axiom, axiom,
  (verdict_pass => certified_ceiling)).

fof(fail_ceiling_axiom, axiom,
  (verdict_fail => unadmitted_ceiling)).

fof(pass_no_jump_status_axiom, axiom,
  ((verdict_pass & no_forbidden_jump_request)
    => proof_state_certified_status)).

fof(fail_no_jump_status_axiom, axiom,
  ((verdict_fail & no_forbidden_jump_request)
    => unadmitted_status)).

fof(forbidden_jump_status_axiom, axiom,
  (forbidden_jump_request => overclaim_blocked_status)).

fof(certificate_axiom, axiom,
  ((claim_passport
    & proof_state_certification
    & proof_state_certified_status
    & forbidden_jump_map)
    => claim_passport_certificate)).

fof(public_certificate_surface_axiom, axiom,
  (claim_passport_certificate => public_certificate_surface)).

fof(public_surface_status_axiom, axiom,
  (public_certificate_surface => public_surface_certified_status)).

fof(public_surface_forbidden_boundary_axiom, axiom,
  (public_certificate_surface => public_surface_forbidden_jump_map)).

fof(audit_sheet_axiom, axiom,
  (public_certificate_surface => claim_passport_audit_sheet)).

fof(public_audit_surface_axiom, axiom,
  (claim_passport_audit_sheet => public_audit_surface)).

fof(audit_external_proof_layer_axiom, axiom,
  (claim_passport_audit_sheet => audit_sheet_external_proof_layer)).

fof(audit_certified_status_axiom, axiom,
  (claim_passport_audit_sheet => audit_sheet_certified_status)).

fof(audit_forbidden_boundary_axiom, axiom,
  (claim_passport_audit_sheet => audit_sheet_forbidden_jump_map)).

fof(review_gate_axiom, axiom,
  ((claim_passport_audit_sheet
    & audit_sheet_external_proof_layer
    & audit_sheet_certified_status
    & audit_sheet_forbidden_jump_map
    & certified_ceiling)
    => claim_passport_review_gate)).

fof(review_gate_public_audit_axiom, axiom,
  (claim_passport_review_gate => review_gate_public_audit_surface)).

fof(review_gate_external_proof_axiom, axiom,
  (claim_passport_review_gate => review_gate_external_proof_layer)).

fof(review_gate_certified_status_axiom, axiom,
  (claim_passport_review_gate => review_gate_certified_status)).

fof(review_gate_allowed_ceiling_axiom, axiom,
  (claim_passport_review_gate => review_gate_allowed_ceiling)).

fof(review_gate_forbidden_boundary_axiom, axiom,
  (claim_passport_review_gate => review_gate_forbidden_jump_map)).

fof(review_ready_surface_axiom, axiom,
  (claim_passport_review_gate => review_ready_surface)).

fof(release_gate_axiom, axiom,
  ((claim_passport_review_gate
    & review_ready_surface
    & review_gate_external_proof_layer
    & review_gate_certified_status
    & review_gate_allowed_ceiling
    & review_gate_forbidden_jump_map
    & external_mirror_verified
    & public_docs_synchronized)
    => claim_passport_release_gate)).

fof(release_gate_review_ready_axiom, axiom,
  (claim_passport_release_gate => release_gate_review_ready)).

fof(release_gate_external_mirror_axiom, axiom,
  (claim_passport_release_gate => release_gate_external_mirror_verified)).

fof(release_gate_public_docs_axiom, axiom,
  (claim_passport_release_gate => release_gate_public_docs_synchronized)).

fof(release_gate_certified_status_axiom, axiom,
  (claim_passport_release_gate => release_gate_certified_status)).

fof(release_gate_allowed_ceiling_axiom, axiom,
  (claim_passport_release_gate => release_gate_allowed_ceiling)).

fof(release_gate_forbidden_boundary_axiom, axiom,
  (claim_passport_release_gate => release_gate_forbidden_jump_map)).

fof(release_candidate_surface_axiom, axiom,
  (claim_passport_release_gate => release_candidate_surface)).

fof(complete_claim_facts, axiom,
  (claim_presented
    & lean_kernel_trace
    & z3_trace
    & vampire_trace
    & e_trace
    & tlfl_classification_trace
    & nonclaim_guard_trace
    & proof_self_model
    & complete_claim_passport_input
    & missing_tlfl_classification_input
    & no_forbidden_jump_request
    & forbidden_jump_request
    & external_mirror_verified
    & public_docs_synchronized)).

fof(tlfl_claim_passport_bundle, conjecture,
  (claim_passport
    & allowed_claim_ceiling
    & forbidden_jump_map
    & proof_state_certification
    & verdict_pass
    & verdict_fail
    & certified_ceiling
    & unadmitted_ceiling
    & proof_state_certified_status
    & unadmitted_status
    & overclaim_blocked_status
    & claim_passport_certificate
    & public_certificate_surface
    & public_surface_certified_status
    & public_surface_forbidden_jump_map
    & claim_passport_audit_sheet
    & public_audit_surface
    & audit_sheet_external_proof_layer
    & audit_sheet_certified_status
    & audit_sheet_forbidden_jump_map
    & claim_passport_review_gate
    & review_gate_public_audit_surface
    & review_gate_external_proof_layer
    & review_gate_certified_status
    & review_gate_allowed_ceiling
    & review_gate_forbidden_jump_map
    & review_ready_surface
    & claim_passport_release_gate
    & release_gate_review_ready
    & release_gate_external_mirror_verified
    & release_gate_public_docs_synchronized
    & release_gate_certified_status
    & release_gate_allowed_ceiling
    & release_gate_forbidden_jump_map
    & release_candidate_surface)).
