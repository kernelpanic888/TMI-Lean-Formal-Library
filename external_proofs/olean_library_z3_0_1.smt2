; TMI-Lean Formal Library 0.1 external proof surface.
; Scope: OLean + TMI.Library release boundary.
;
; Expected output:
;   unsat
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

(declare-sort Artifact 0)
(declare-sort LeanObject 0)
(declare-sort Branch 0)

(declare-fun artifact_candidate (Artifact) Bool)
(declare-fun encoded_in_lean (Artifact LeanObject) Bool)
(declare-fun checked_by_lean_kernel (LeanObject) Bool)
(declare-fun formal_lean_status (Artifact) Bool)

(declare-fun imports_tmi_library () Bool)
(declare-fun uses_lean_kernel () Bool)
(declare-fun introduces_new_kernel () Bool)
(declare-fun tmi_lean_library_is_lean_fork () Bool)
(declare-fun library_release () Bool)
(declare-fun empirical_proof_of_tmi_as_physics () Bool)

(declare-const MD Branch)
(declare-const QC Branch)
(declare-const QG Branch)
(declare-const LIFE Branch)
(declare-const OPS Branch)

(declare-fun guarded_branch (Branch) Bool)
(declare-fun empirical_physical_law (Branch) Bool)

(assert
  (forall ((a Artifact) (o LeanObject))
    (=>
      (and
        (encoded_in_lean a o)
        (checked_by_lean_kernel o))
      (formal_lean_status a))))

(assert imports_tmi_library)
(assert uses_lean_kernel)
(assert (not introduces_new_kernel))
(assert (not tmi_lean_library_is_lean_fork))
(assert library_release)

(assert (guarded_branch MD))
(assert (guarded_branch QC))
(assert (guarded_branch QG))
(assert (guarded_branch LIFE))
(assert (guarded_branch OPS))

; Theorem: encoded + checked implies formal status.
(push)
(assert
  (exists ((a Artifact) (o LeanObject))
    (and
      (encoded_in_lean a o)
      (checked_by_lean_kernel o)
      (not (formal_lean_status a)))))
(check-sat)
(pop)

; Theorem: OLean imports TMI.Library.
(push)
(assert (not imports_tmi_library))
(check-sat)
(pop)

; Theorem: OLean uses Lean kernel.
(push)
(assert (not uses_lean_kernel))
(check-sat)
(pop)

; Theorem: OLean does not introduce a new kernel.
(push)
(assert introduces_new_kernel)
(check-sat)
(pop)

; Theorem: TMI-Lean Library is not a Lean fork.
(push)
(assert tmi_lean_library_is_lean_fork)
(check-sat)
(pop)

; Theorem: all public branches are guarded.
(push)
(assert
  (not
    (and
      (guarded_branch MD)
      (guarded_branch QC)
      (guarded_branch QG)
      (guarded_branch LIFE)
      (guarded_branch OPS))))
(check-sat)
(pop)

; Guard: artifact alone does not imply formal status.
(push)
(assert
  (exists ((a Artifact))
    (and
      (artifact_candidate a)
      (not (formal_lean_status a)))))
(check-sat)
(pop)

; Guard: encoded alone does not imply formal status.
(push)
(assert
  (exists ((a Artifact) (o LeanObject))
    (and
      (encoded_in_lean a o)
      (not (checked_by_lean_kernel o))
      (not (formal_lean_status a)))))
(check-sat)
(pop)

; Guard: guarded branch does not imply empirical physical law.
(push)
(assert
  (exists ((b Branch))
    (and
      (guarded_branch b)
      (not (empirical_physical_law b)))))
(check-sat)
(pop)

; Guard: library release does not imply empirical proof of TMI as physics.
(push)
(assert
  (and
    library_release
    (not empirical_proof_of_tmi_as_physics)))
(check-sat)
(pop)

