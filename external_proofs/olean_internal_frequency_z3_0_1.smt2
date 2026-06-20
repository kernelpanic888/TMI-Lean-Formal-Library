; OLean + TMI.Library internal-frequency self-check.
; Scope: complete boundary verification translated into internal interface
; frequency using the existing G0..G4 light-gradient values.
;
; Expected output:
;   unsat
;   unsat
;   unsat
;   unsat
;   unsat
;   sat
;   sat
;   sat
;   sat

(set-logic ALL)

(declare-fun encoded_in_lean_boundary () Bool)
(declare-fun lean_kernel_checked () Bool)
(declare-fun lake_build_passed () Bool)
(declare-fun z3_passed () Bool)
(declare-fun vampire_passed () Bool)
(declare-fun e_prover_passed () Bool)
(declare-fun introduces_new_kernel () Bool)

(declare-fun complete_boundary_verification () Bool)
(declare-fun formal_lean_status () Bool)
(declare-fun internal_frequency_749 () Bool)
(declare-fun boundary_verdict_pass () Bool)
(declare-fun boundary_verdict_fail () Bool)
(declare-fun empirical_physical_proof () Bool)

(declare-fun internal_frequency_value () Int)

(assert
  (= complete_boundary_verification
    (and
      encoded_in_lean_boundary
      lean_kernel_checked
      lake_build_passed
      z3_passed
      vampire_passed
      e_prover_passed
      (not introduces_new_kernel))))

(assert
  (=>
    (and encoded_in_lean_boundary lean_kernel_checked)
    formal_lean_status))

(assert (=> complete_boundary_verification formal_lean_status))
(assert (=> complete_boundary_verification internal_frequency_749))
(assert (=> internal_frequency_749 (= internal_frequency_value 749)))
(assert (= boundary_verdict_pass complete_boundary_verification))
(assert (= boundary_verdict_fail (not complete_boundary_verification)))

; Theorem: complete boundary verification gives internal frequency 749.
(push)
(assert complete_boundary_verification)
(assert (not internal_frequency_749))
(check-sat)
(pop)

; Theorem: internal frequency G4 has value 749.
(push)
(assert internal_frequency_749)
(assert (not (= internal_frequency_value 749)))
(check-sat)
(pop)

; Theorem: complete boundary verification gives formal Lean status.
(push)
(assert complete_boundary_verification)
(assert (not formal_lean_status))
(check-sat)
(pop)

; Theorem: complete boundary verification gives pass verdict.
(push)
(assert complete_boundary_verification)
(assert (not boundary_verdict_pass))
(check-sat)
(pop)

; Theorem: Lean/Lake only gives fail verdict.
(push)
(assert encoded_in_lean_boundary)
(assert lean_kernel_checked)
(assert lake_build_passed)
(assert (not z3_passed))
(assert (not vampire_passed))
(assert (not e_prover_passed))
(assert (not boundary_verdict_fail))
(check-sat)
(pop)

; Guard: Lean/Lake only does not imply full external-frequency G4.
(push)
(assert encoded_in_lean_boundary)
(assert lean_kernel_checked)
(assert lake_build_passed)
(assert (not z3_passed))
(assert (not vampire_passed))
(assert (not e_prover_passed))
(assert (not internal_frequency_749))
(check-sat)
(pop)

; Guard: encoded-only artifact does not imply self-check pass.
(push)
(assert encoded_in_lean_boundary)
(assert (not lean_kernel_checked))
(assert (not complete_boundary_verification))
(check-sat)
(pop)

; Guard: external prover results without Lean-kernel check do not imply formal Lean status.
(push)
(assert z3_passed)
(assert vampire_passed)
(assert e_prover_passed)
(assert (not lean_kernel_checked))
(assert (not formal_lean_status))
(check-sat)
(pop)

; Guard: internal frequency does not imply empirical physical proof.
(push)
(assert internal_frequency_749)
(assert (not empirical_physical_proof))
(check-sat)
(pop)
