/-
External prover boundary for TMI-Core-Proof 0.2-A7.

This module names ATP/SMT proof and countermodel artifacts without trusting
prover status as a Lean theorem. A real Lean-trusted integration must add a
checked kernel later; this file only defines the boundary vocabulary.
-/

namespace TMI
namespace ExternalProverBoundary

inductive TargetKind where
  | theorem
  | countermodel
  deriving Repr, DecidableEq

inductive ProverFamily where
  | atp
  | smt
  | modelFinder
  | leanChecker
  deriving Repr, DecidableEq

inductive ArtifactKind where
  | tstpProof
  | smtProof
  | finiteModel
  | leanCheckedProof
  | runLog
  deriving Repr, DecidableEq

inductive CheckStatus where
  | unchecked
  | parserAccepted
  | independentlyChecked
  | leanKernelChecked
  deriving Repr, DecidableEq

structure ExternalTarget where
  id : String
  kind : TargetKind
  version : String
  deriving Repr

structure ProverRun where
  prover : ProverFamily
  proverName : String
  proverVersion : String
  commandLine : String
  deriving Repr

structure ExternalArtifact where
  target : ExternalTarget
  artifactKind : ArtifactKind
  path : String
  digest : String
  deriving Repr

structure CheckedExternalArtifact where
  artifact : ExternalArtifact
  run : ProverRun
  status : CheckStatus
  checkerName : String
  checkerVersion : String
  deriving Repr

structure ProofKernelGate where
  id : String
  commandLine : String
  requiresLean : Bool
  requiresZ3 : Bool
  requiresVampire : Bool
  requiresE : Bool
  deriving Repr

def GateRequiresLeanZ3VampireE (gate : ProofKernelGate) : Prop :=
  gate.requiresLean = true
    ∧ gate.requiresZ3 = true
    ∧ gate.requiresVampire = true
    ∧ gate.requiresE = true

def GateRequiresZ3VampireE (gate : ProofKernelGate) : Prop :=
  gate.requiresZ3 = true
    ∧ gate.requiresVampire = true
    ∧ gate.requiresE = true

def intelligenceProofKernelGate : ProofKernelGate :=
  { id := "TMI-HYP-INTEL-001/proof-kernel"
    commandLine := "make proof-kernel"
    requiresLean := true
    requiresZ3 := true
    requiresVampire := true
    requiresE := true }

def intelligenceExternalAtpPairGate : ProofKernelGate :=
  { id := "TMI-HYP-INTEL-001/external-atp-pair"
    commandLine := "make external-atp-pair"
    requiresLean := false
    requiresZ3 := true
    requiresVampire := true
    requiresE := true }

theorem intelligence_proof_kernel_gate_requires_lean_z3_vampire_e :
    GateRequiresLeanZ3VampireE intelligenceProofKernelGate := by
  simp [GateRequiresLeanZ3VampireE, intelligenceProofKernelGate]

theorem intelligence_external_atp_pair_gate_requires_z3_vampire_e :
    GateRequiresZ3VampireE intelligenceExternalAtpPairGate := by
  simp [GateRequiresZ3VampireE, intelligenceExternalAtpPairGate]

def ExternallyAcceptedStatus (status : CheckStatus) : Prop :=
  status = CheckStatus.independentlyChecked ∨ status = CheckStatus.leanKernelChecked

def ExternalProofCertificate (target : ExternalTarget) : Prop :=
  ∃ checked : CheckedExternalArtifact,
    checked.artifact.target = target
    ∧ target.kind = TargetKind.theorem
    ∧ ExternallyAcceptedStatus checked.status

def LeanTrustedProofCertificate (target : ExternalTarget) : Prop :=
  ∃ checked : CheckedExternalArtifact,
    checked.artifact.target = target
    ∧ target.kind = TargetKind.theorem
    ∧ checked.status = CheckStatus.leanKernelChecked

def ExternalCountermodelCertificate (target : ExternalTarget) : Prop :=
  ∃ checked : CheckedExternalArtifact,
    checked.artifact.target = target
    ∧ target.kind = TargetKind.countermodel
    ∧ ExternallyAcceptedStatus checked.status

def LeanTrustedCountermodelCertificate (target : ExternalTarget) : Prop :=
  ∃ checked : CheckedExternalArtifact,
    checked.artifact.target = target
    ∧ target.kind = TargetKind.countermodel
    ∧ checked.status = CheckStatus.leanKernelChecked

def StatusOnlyTrustClaim : Prop :=
  ∀ target : ExternalTarget,
    (∃ artifact : CheckedExternalArtifact,
      artifact.artifact.target = target
      ∧ artifact.status = CheckStatus.unchecked)
    → LeanTrustedProofCertificate target

def ProofCertificateImpliesTargetTheoremClaim : Prop :=
  ∀ target : ExternalTarget, ExternalProofCertificate target → True

theorem lean_trusted_proof_is_external_proof :
    ∀ target : ExternalTarget,
      LeanTrustedProofCertificate target → ExternalProofCertificate target := by
  intro target htrusted
  rcases htrusted with ⟨checked, htarget, hkind, hstatus⟩
  exact ⟨checked, htarget, hkind, Or.inr hstatus⟩

theorem lean_trusted_countermodel_is_external_countermodel :
    ∀ target : ExternalTarget,
      LeanTrustedCountermodelCertificate target → ExternalCountermodelCertificate target := by
  intro target htrusted
  rcases htrusted with ⟨checked, htarget, hkind, hstatus⟩
  exact ⟨checked, htarget, hkind, Or.inr hstatus⟩

namespace TrustedCNF

inductive Lit where
  | pos : Nat → Lit
  | neg : Nat → Lit
  deriving Repr, DecidableEq

abbrev Assignment := Nat → Bool
abbrev Clause := List Lit
abbrev Cnf := List Clause

def evalLit (σ : Assignment) : Lit → Prop
  | Lit.pos atom => σ atom = true
  | Lit.neg atom => σ atom = false

def negate : Lit → Lit
  | Lit.pos atom => Lit.neg atom
  | Lit.neg atom => Lit.pos atom

def evalClause (σ : Assignment) (clause : Clause) : Prop :=
  ∃ lit, lit ∈ clause ∧ evalLit σ lit

def evalCnf (σ : Assignment) (formula : Cnf) : Prop :=
  ∀ clause, clause ∈ formula → evalClause σ clause

def hasEmptyClause : Cnf → Bool
  | [] => false
  | [] :: _ => true
  | (_ :: _) :: rest => hasEmptyClause rest

def checkUnsatByEmptyClause (formula : Cnf) : Bool :=
  hasEmptyClause formula

def CnfUnsat (formula : Cnf) : Prop :=
  ∀ σ : Assignment, ¬ evalCnf σ formula

def EmptyClauseCertificate (target : ExternalTarget) (formula : Cnf) : Prop :=
  target.kind = TargetKind.theorem ∧ checkUnsatByEmptyClause formula = true

def hasUnitContradiction : Cnf → Bool
  | [] => false
  | [Lit.pos atom] :: rest =>
      if [Lit.neg atom] ∈ rest then true else hasUnitContradiction rest
  | [Lit.neg atom] :: rest =>
      if [Lit.pos atom] ∈ rest then true else hasUnitContradiction rest
  | _ :: rest => hasUnitContradiction rest

def checkUnsatByUnitContradiction (formula : Cnf) : Bool :=
  hasUnitContradiction formula

def UnitContradictionCertificate (target : ExternalTarget) (formula : Cnf) : Prop :=
  target.kind = TargetKind.theorem ∧ checkUnsatByUnitContradiction formula = true

def UnitPropagationStep (formula : Cnf) (trigger derived : Lit) : Prop :=
  [trigger] ∈ formula
    ∧ ([negate trigger, derived] ∈ formula ∨ [derived, negate trigger] ∈ formula)

inductive UnitPropagationTrace : Cnf → Cnf → Prop where
  | done (formula : Cnf) : UnitPropagationTrace formula formula
  | step {formula final : Cnf} (trigger derived : Lit) :
      UnitPropagationStep formula trigger derived →
      UnitPropagationTrace ([derived] :: formula) final →
      UnitPropagationTrace formula final

def UnitPropagationTraceCertificate
    (target : ExternalTarget) (formula final : Cnf) : Prop :=
  target.kind = TargetKind.theorem
    ∧ UnitPropagationTrace formula final
    ∧ checkUnsatByUnitContradiction final = true

def resolutionResolvent (leftRest rightRest : Clause) : Clause :=
  leftRest ++ rightRest

def ResolutionStep
    (formula : Cnf) (pivot : Lit) (leftRest rightRest : Clause) : Prop :=
  (pivot :: leftRest) ∈ formula
    ∧ (negate pivot :: rightRest) ∈ formula

def ResolutionStepUnsatCertificate
    (target : ExternalTarget)
    (formula : Cnf)
    (pivot : Lit)
    (leftRest rightRest : Clause) : Prop :=
  target.kind = TargetKind.theorem
    ∧ ResolutionStep formula pivot leftRest rightRest
    ∧ (checkUnsatByEmptyClause
          (resolutionResolvent leftRest rightRest :: formula) = true
        ∨ checkUnsatByUnitContradiction
          (resolutionResolvent leftRest rightRest :: formula) = true)

inductive ResolutionTrace : Cnf → Cnf → Prop where
  | done (formula : Cnf) : ResolutionTrace formula formula
  | step {formula final : Cnf} (pivot : Lit) (leftRest rightRest : Clause) :
      ResolutionStep formula pivot leftRest rightRest →
      ResolutionTrace (resolutionResolvent leftRest rightRest :: formula) final →
      ResolutionTrace formula final

def ResolutionTraceCertificate
    (target : ExternalTarget) (formula final : Cnf) : Prop :=
  target.kind = TargetKind.theorem
    ∧ ResolutionTrace formula final
    ∧ (checkUnsatByEmptyClause final = true
      ∨ checkUnsatByUnitContradiction final = true)

abbrev ClauseId := Nat

structure ClauseEntry where
  id : ClauseId
  clause : Clause
  deriving Repr

abbrev ClauseTable := List ClauseEntry

def ClauseTableHas (table : ClauseTable) (id : ClauseId) (clause : Clause) : Prop :=
  ∃ entry, entry ∈ table ∧ entry.id = id ∧ entry.clause = clause

structure ResolutionStepRecord where
  leftParent : ClauseId
  rightParent : ClauseId
  derivedId : ClauseId
  pivot : Lit
  leftRest : Clause
  rightRest : Clause
  derivedClause : Clause
  deriving Repr

def ResolutionStepRecord.resolvent (step : ResolutionStepRecord) : Clause :=
  resolutionResolvent step.leftRest step.rightRest

def ClauseTable.extendWithResolution
    (table : ClauseTable) (step : ResolutionStepRecord) : ClauseTable :=
  { id := step.derivedId, clause := step.resolvent } :: table

def ResolutionStepRecordObligation
    (table : ClauseTable) (formula : Cnf) (step : ResolutionStepRecord) : Prop :=
  ClauseTableHas table step.leftParent (step.pivot :: step.leftRest)
    ∧ ClauseTableHas table step.rightParent (negate step.pivot :: step.rightRest)
    ∧ step.derivedClause = step.resolvent
    ∧ ResolutionStep formula step.pivot step.leftRest step.rightRest

inductive ResolutionReplay : ClauseTable → Cnf → List ResolutionStepRecord → Cnf → Prop where
  | done (table : ClauseTable) (formula : Cnf) :
      ResolutionReplay table formula [] formula
  | step {table : ClauseTable} {formula final : Cnf}
      (record : ResolutionStepRecord) (rest : List ResolutionStepRecord) :
      ResolutionStepRecordObligation table formula record →
      ResolutionReplay
        (ClauseTable.extendWithResolution table record)
        (record.resolvent :: formula)
        rest
        final →
      ResolutionReplay table formula (record :: rest) final

structure ResolutionProofArtifactFormat where
  artifact : ExternalArtifact
  parserStatus : CheckStatus
  source : Cnf
  initialTable : ClauseTable
  steps : List ResolutionStepRecord
  final : Cnf
  deriving Repr

def ResolutionProofArtifactReplayObligation
    (cert : ResolutionProofArtifactFormat) : Prop :=
  cert.artifact.target.kind = TargetKind.theorem
    ∧ ResolutionReplay cert.initialTable cert.source cert.steps cert.final
    ∧ (checkUnsatByEmptyClause cert.final = true
      ∨ checkUnsatByUnitContradiction cert.final = true)

def ParserStatusOnlyResolutionTrustClaim : Prop :=
  ∀ cert : ResolutionProofArtifactFormat,
    cert.parserStatus = CheckStatus.parserAccepted → CnfUnsat cert.source

def leanResolutionReplayCheckerRun : ProverRun :=
  { prover := ProverFamily.leanChecker
    proverName := "Lean"
    proverVersion := "v4.31.0-rc1"
    commandLine := "lake env lean lean/TMI/ExternalProverBoundary.lean" }

def leanCheckedResolutionReplayArtifact
    (cert : ResolutionProofArtifactFormat) : CheckedExternalArtifact :=
  { artifact := cert.artifact
    run := leanResolutionReplayCheckerRun
    status := CheckStatus.leanKernelChecked
    checkerName :=
      "TMI.ExternalProverBoundary.TrustedCNF.resolutionProofArtifactReplayObligation_sound"
    checkerVersion := "0.3" }

def tinyUnitContradictionTarget : ExternalTarget :=
  { id := "trusted-cnf/tiny-unit-contradiction"
    kind := TargetKind.theorem
    version := "0.3" }

def tinyUnitContradictionArtifact : ExternalArtifact :=
  { target := tinyUnitContradictionTarget
    artifactKind := ArtifactKind.leanCheckedProof
    path := "lean/TMI/ExternalProverBoundary.lean#tinyUnitContradiction"
    digest := "lean-native-trusted-cnf-tiny-unit-contradiction-v0.3" }

def tinyUnitContradictionCnf : Cnf :=
  [[Lit.pos 0], [Lit.neg 0]]

def tinyUnitContradictionResolutionProofArtifact :
    ResolutionProofArtifactFormat :=
  { artifact := tinyUnitContradictionArtifact
    parserStatus := CheckStatus.parserAccepted
    source := tinyUnitContradictionCnf
    initialTable := []
    steps := []
    final := tinyUnitContradictionCnf }

theorem evalClause_nil_false : ∀ σ : Assignment, ¬ evalClause σ [] := by
  intro σ h
  rcases h with ⟨lit, hmem, _⟩
  cases hmem

theorem evalClause_singleton_iff :
    ∀ (σ : Assignment) (lit : Lit), evalClause σ [lit] ↔ evalLit σ lit := by
  intro σ lit
  constructor
  · intro h
    rcases h with ⟨lit', hmem, heval⟩
    simp at hmem
    subst lit'
    exact heval
  · intro heval
    exact ⟨lit, by simp, heval⟩

theorem evalClause_cons_iff :
    ∀ (σ : Assignment) (lit : Lit) (rest : Clause),
      evalClause σ (lit :: rest) ↔ evalLit σ lit ∨ evalClause σ rest := by
  intro σ lit rest
  constructor
  · intro h
    rcases h with ⟨lit', hmem, heval⟩
    simp at hmem
    cases hmem with
    | inl hhead =>
        subst lit'
        exact Or.inl heval
    | inr htail =>
        exact Or.inr ⟨lit', htail, heval⟩
  · intro h
    cases h with
    | inl hhead =>
        exact ⟨lit, by simp, hhead⟩
    | inr htail =>
        rcases htail with ⟨lit', hmem, heval⟩
        exact ⟨lit', by simp [hmem], heval⟩

theorem evalClause_append_of_left :
    ∀ (σ : Assignment) (left right : Clause),
      evalClause σ left → evalClause σ (left ++ right) := by
  intro σ left right h
  rcases h with ⟨lit, hmem, heval⟩
  exact ⟨lit, by simp [hmem], heval⟩

theorem evalClause_append_of_right :
    ∀ (σ : Assignment) (left right : Clause),
      evalClause σ right → evalClause σ (left ++ right) := by
  intro σ left right h
  rcases h with ⟨lit, hmem, heval⟩
  exact ⟨lit, by simp [hmem], heval⟩

theorem hasEmptyClause_sound :
    ∀ (formula : Cnf) (σ : Assignment),
      hasEmptyClause formula = true → ¬ evalCnf σ formula := by
  intro formula
  induction formula with
  | nil =>
      intro σ h
      cases h
  | cons clause rest ih =>
      cases clause with
      | nil =>
          intro σ _ hsat
          exact evalClause_nil_false σ (hsat [] (by simp))
      | cons lit lits =>
          intro σ h hsat
          exact ih σ h (by
            intro clause hmem
            exact hsat clause (by simp [hmem]))

theorem checkUnsatByEmptyClause_sound :
    ∀ formula : Cnf, checkUnsatByEmptyClause formula = true → CnfUnsat formula := by
  intro formula h σ
  exact hasEmptyClause_sound formula σ h

theorem emptyClauseCertificate_sound :
    ∀ (target : ExternalTarget) (formula : Cnf),
      EmptyClauseCertificate target formula → CnfUnsat formula := by
  intro target formula hcert
  exact checkUnsatByEmptyClause_sound formula hcert.right

theorem unitContradiction_unsat :
    ∀ (formula : Cnf) (atom : Nat),
      [Lit.pos atom] ∈ formula → [Lit.neg atom] ∈ formula → CnfUnsat formula := by
  intro formula atom hpos hneg σ hsat
  have hpClause : evalClause σ [Lit.pos atom] := hsat [Lit.pos atom] hpos
  have hnClause : evalClause σ [Lit.neg atom] := hsat [Lit.neg atom] hneg
  have hp : σ atom = true := (evalClause_singleton_iff σ (Lit.pos atom)).mp hpClause
  have hn : σ atom = false := (evalClause_singleton_iff σ (Lit.neg atom)).mp hnClause
  rw [hp] at hn
  cases hn

theorem hasUnitContradiction_sound :
    ∀ formula : Cnf,
      hasUnitContradiction formula = true →
        ∃ atom, [Lit.pos atom] ∈ formula ∧ [Lit.neg atom] ∈ formula := by
  intro formula
  induction formula with
  | nil =>
      intro h
      cases h
  | cons clause rest ih =>
      cases clause with
      | nil =>
          intro h
          rcases ih h with ⟨atom, hpos, hneg⟩
          exact ⟨atom, by simp [hpos], by simp [hneg]⟩
      | cons lit tail =>
          cases tail with
          | nil =>
              cases lit with
              | pos atom =>
                  by_cases hneg : [Lit.neg atom] ∈ rest
                  · intro _
                    exact ⟨atom, by simp, by simp [hneg]⟩
                  · intro h
                    simp [hasUnitContradiction, hneg] at h
                    rcases ih h with ⟨atom', hpos, hneg'⟩
                    exact ⟨atom', by simp [hpos], by simp [hneg']⟩
              | neg atom =>
                  by_cases hpos : [Lit.pos atom] ∈ rest
                  · intro _
                    exact ⟨atom, by simp [hpos], by simp⟩
                  · intro h
                    simp [hasUnitContradiction, hpos] at h
                    rcases ih h with ⟨atom', hpos', hneg⟩
                    exact ⟨atom', by simp [hpos'], by simp [hneg]⟩
          | cons lit' tail' =>
              intro h
              simp [hasUnitContradiction] at h
              rcases ih h with ⟨atom, hpos, hneg⟩
              exact ⟨atom, by simp [hpos], by simp [hneg]⟩

theorem checkUnsatByUnitContradiction_sound :
    ∀ formula : Cnf, checkUnsatByUnitContradiction formula = true → CnfUnsat formula := by
  intro formula h
  rcases hasUnitContradiction_sound formula h with ⟨atom, hpos, hneg⟩
  exact unitContradiction_unsat formula atom hpos hneg

theorem unitContradictionCertificate_sound :
    ∀ (target : ExternalTarget) (formula : Cnf),
      UnitContradictionCertificate target formula → CnfUnsat formula := by
  intro target formula hcert
  exact checkUnsatByUnitContradiction_sound formula hcert.right

theorem evalLit_negate_not :
    ∀ (σ : Assignment) (lit : Lit), evalLit σ lit → ¬ evalLit σ (negate lit) := by
  intro σ lit h hn
  cases lit with
  | pos atom =>
      simp [evalLit, negate] at h hn
      rw [h] at hn
      cases hn
  | neg atom =>
      simp [evalLit, negate] at h hn
      rw [h] at hn
      cases hn

theorem unitPropagationStep_sound :
    ∀ (formula : Cnf) (trigger derived : Lit) (σ : Assignment),
      UnitPropagationStep formula trigger derived →
      evalCnf σ formula →
      evalLit σ derived := by
  intro formula trigger derived σ hstep hsat
  rcases hstep with ⟨hunit, hclause⟩
  have htriggerClause : evalClause σ [trigger] := hsat [trigger] hunit
  have htrigger : evalLit σ trigger :=
    (evalClause_singleton_iff σ trigger).mp htriggerClause
  cases hclause with
  | inl hforward =>
      have hderivedClause : evalClause σ [negate trigger, derived] :=
        hsat [negate trigger, derived] hforward
      rcases hderivedClause with ⟨lit, hmem, heval⟩
      simp at hmem
      cases hmem with
      | inl hneg =>
          subst lit
          exact False.elim ((evalLit_negate_not σ trigger htrigger) heval)
      | inr hderived =>
          subst lit
          exact heval
  | inr hbackward =>
      have hderivedClause : evalClause σ [derived, negate trigger] :=
        hsat [derived, negate trigger] hbackward
      rcases hderivedClause with ⟨lit, hmem, heval⟩
      simp at hmem
      cases hmem with
      | inl hderived =>
          subst lit
          exact heval
      | inr hneg =>
          subst lit
          exact False.elim ((evalLit_negate_not σ trigger htrigger) heval)

theorem unitPropagationTrace_preserves_models :
    ∀ (formula final : Cnf),
      UnitPropagationTrace formula final →
      ∀ σ : Assignment, evalCnf σ formula → evalCnf σ final := by
  intro formula final htrace
  induction htrace with
  | done formula =>
      intro σ hsat
      exact hsat
  | step trigger derived hstep hrest ih =>
      intro σ hsat
      apply ih
      intro clause hmem
      simp at hmem
      cases hmem with
      | inl hhead =>
          subst clause
          exact (evalClause_singleton_iff σ derived).mpr
            (unitPropagationStep_sound _ trigger derived σ hstep hsat)
      | inr htail =>
          exact hsat clause htail

theorem unitPropagationTrace_unsat :
    ∀ (formula final : Cnf),
      UnitPropagationTrace formula final →
      CnfUnsat final →
      CnfUnsat formula := by
  intro formula final htrace hunsat σ hsat
  exact hunsat σ (unitPropagationTrace_preserves_models formula final htrace σ hsat)

theorem unitPropagationTraceCertificate_sound :
    ∀ (target : ExternalTarget) (formula final : Cnf),
      UnitPropagationTraceCertificate target formula final → CnfUnsat formula := by
  intro target formula final hcert
  rcases hcert with ⟨_, htrace, hcontradiction⟩
  exact unitPropagationTrace_unsat formula final htrace
    (checkUnsatByUnitContradiction_sound final hcontradiction)

theorem resolutionStep_sound :
    ∀ (formula : Cnf) (pivot : Lit) (leftRest rightRest : Clause)
      (σ : Assignment),
      ResolutionStep formula pivot leftRest rightRest →
      evalCnf σ formula →
      evalClause σ (resolutionResolvent leftRest rightRest) := by
  intro formula pivot leftRest rightRest σ hstep hsat
  rcases hstep with ⟨hleft, hright⟩
  have hleftClause : evalClause σ (pivot :: leftRest) :=
    hsat (pivot :: leftRest) hleft
  have hrightClause : evalClause σ (negate pivot :: rightRest) :=
    hsat (negate pivot :: rightRest) hright
  rcases (evalClause_cons_iff σ pivot leftRest).mp hleftClause with hpivot | hleftRest
  · rcases (evalClause_cons_iff σ (negate pivot) rightRest).mp hrightClause with hnegPivot | hrightRest
    · exact False.elim ((evalLit_negate_not σ pivot hpivot) hnegPivot)
    · exact evalClause_append_of_right σ leftRest rightRest hrightRest
  · exact evalClause_append_of_left σ leftRest rightRest hleftRest

theorem resolutionStep_extend_preserves_models :
    ∀ (formula : Cnf) (pivot : Lit) (leftRest rightRest : Clause),
      ResolutionStep formula pivot leftRest rightRest →
      ∀ σ : Assignment,
        evalCnf σ formula →
        evalCnf σ (resolutionResolvent leftRest rightRest :: formula) := by
  intro formula pivot leftRest rightRest hstep σ hsat
  intro clause hmem
  simp at hmem
  cases hmem with
  | inl hhead =>
      subst clause
      exact resolutionStep_sound formula pivot leftRest rightRest σ hstep hsat
  | inr htail =>
      exact hsat clause htail

theorem resolutionStep_unsat :
    ∀ (formula : Cnf) (pivot : Lit) (leftRest rightRest : Clause),
      ResolutionStep formula pivot leftRest rightRest →
      CnfUnsat (resolutionResolvent leftRest rightRest :: formula) →
      CnfUnsat formula := by
  intro formula pivot leftRest rightRest hstep hunsat σ hsat
  exact hunsat σ
    (resolutionStep_extend_preserves_models formula pivot leftRest rightRest hstep σ hsat)

theorem resolutionStepUnsatCertificate_sound :
    ∀ (target : ExternalTarget)
      (formula : Cnf)
      (pivot : Lit)
      (leftRest rightRest : Clause),
      ResolutionStepUnsatCertificate target formula pivot leftRest rightRest →
      CnfUnsat formula := by
  intro target formula pivot leftRest rightRest hcert
  rcases hcert with ⟨_, hstep, hcheckedUnsat⟩
  apply resolutionStep_unsat formula pivot leftRest rightRest hstep
  cases hcheckedUnsat with
  | inl hempty =>
      exact checkUnsatByEmptyClause_sound
        (resolutionResolvent leftRest rightRest :: formula) hempty
  | inr hunit =>
      exact checkUnsatByUnitContradiction_sound
        (resolutionResolvent leftRest rightRest :: formula) hunit

theorem resolutionTrace_preserves_models :
    ∀ (formula final : Cnf),
      ResolutionTrace formula final →
      ∀ σ : Assignment, evalCnf σ formula → evalCnf σ final := by
  intro formula final htrace
  induction htrace with
  | done formula =>
      intro σ hsat
      exact hsat
  | step pivot leftRest rightRest hstep hrest ih =>
      intro σ hsat
      apply ih
      exact resolutionStep_extend_preserves_models _ pivot leftRest rightRest hstep σ hsat

theorem resolutionTrace_unsat :
    ∀ (formula final : Cnf),
      ResolutionTrace formula final →
      CnfUnsat final →
      CnfUnsat formula := by
  intro formula final htrace hunsat σ hsat
  exact hunsat σ (resolutionTrace_preserves_models formula final htrace σ hsat)

theorem resolutionTraceCertificate_sound :
    ∀ (target : ExternalTarget) (formula final : Cnf),
      ResolutionTraceCertificate target formula final → CnfUnsat formula := by
  intro target formula final hcert
  rcases hcert with ⟨_, htrace, hcheckedUnsat⟩
  apply resolutionTrace_unsat formula final htrace
  cases hcheckedUnsat with
  | inl hempty =>
      exact checkUnsatByEmptyClause_sound final hempty
  | inr hunit =>
      exact checkUnsatByUnitContradiction_sound final hunit

theorem resolutionReplay_to_trace :
    ∀ (table : ClauseTable) (formula : Cnf)
      (steps : List ResolutionStepRecord) (final : Cnf),
      ResolutionReplay table formula steps final →
      ResolutionTrace formula final := by
  intro table formula steps final hreplay
  induction hreplay with
  | done table formula =>
      exact ResolutionTrace.done formula
  | step record rest hrecord hrest ih =>
      exact ResolutionTrace.step
        record.pivot
        record.leftRest
        record.rightRest
        hrecord.right.right.right
        ih

theorem resolutionProofArtifactReplayObligation_sound :
    ∀ cert : ResolutionProofArtifactFormat,
      ResolutionProofArtifactReplayObligation cert → CnfUnsat cert.source := by
  intro cert hcert
  rcases hcert with ⟨_, hreplay, hcheckedUnsat⟩
  apply resolutionTrace_unsat cert.source cert.final
    (resolutionReplay_to_trace cert.initialTable cert.source cert.steps cert.final hreplay)
  cases hcheckedUnsat with
  | inl hempty =>
      exact checkUnsatByEmptyClause_sound cert.final hempty
  | inr hunit =>
      exact checkUnsatByUnitContradiction_sound cert.final hunit

theorem resolutionProofArtifactReplayObligation_gives_lean_trusted_certificate :
    ∀ cert : ResolutionProofArtifactFormat,
      ResolutionProofArtifactReplayObligation cert →
        LeanTrustedProofCertificate cert.artifact.target := by
  intro cert hcert
  exact ⟨
    leanCheckedResolutionReplayArtifact cert,
    rfl,
    hcert.left,
    rfl
  ⟩

theorem resolutionProofArtifactReplayObligation_gives_external_proof_certificate :
    ∀ cert : ResolutionProofArtifactFormat,
      ResolutionProofArtifactReplayObligation cert →
        ExternalProofCertificate cert.artifact.target := by
  intro cert hcert
  exact lean_trusted_proof_is_external_proof cert.artifact.target
    (resolutionProofArtifactReplayObligation_gives_lean_trusted_certificate
      cert hcert)

theorem resolutionProofArtifactReplayObligation_gives_unsat_and_trusted_certificate :
    ∀ cert : ResolutionProofArtifactFormat,
      ResolutionProofArtifactReplayObligation cert →
        CnfUnsat cert.source ∧
          LeanTrustedProofCertificate cert.artifact.target := by
  intro cert hcert
  exact ⟨
    resolutionProofArtifactReplayObligation_sound cert hcert,
    resolutionProofArtifactReplayObligation_gives_lean_trusted_certificate
      cert hcert
  ⟩

theorem tinyUnitContradictionReplayObligation :
    ResolutionProofArtifactReplayObligation
      tinyUnitContradictionResolutionProofArtifact := by
  simp [ResolutionProofArtifactReplayObligation,
    tinyUnitContradictionResolutionProofArtifact,
    tinyUnitContradictionArtifact,
    tinyUnitContradictionTarget,
    tinyUnitContradictionCnf,
    ResolutionReplay.done,
    checkUnsatByUnitContradiction,
    hasUnitContradiction]

theorem tinyUnitContradictionUnsat :
    CnfUnsat tinyUnitContradictionCnf := by
  exact resolutionProofArtifactReplayObligation_sound
    tinyUnitContradictionResolutionProofArtifact
    tinyUnitContradictionReplayObligation

theorem tinyUnitContradictionLeanTrustedCertificate :
    LeanTrustedProofCertificate tinyUnitContradictionTarget := by
  exact resolutionProofArtifactReplayObligation_gives_lean_trusted_certificate
    tinyUnitContradictionResolutionProofArtifact
    tinyUnitContradictionReplayObligation

theorem tinyUnitContradictionExternalProofCertificate :
    ExternalProofCertificate tinyUnitContradictionTarget := by
  exact resolutionProofArtifactReplayObligation_gives_external_proof_certificate
    tinyUnitContradictionResolutionProofArtifact
    tinyUnitContradictionReplayObligation

end TrustedCNF

end ExternalProverBoundary
end TMI
