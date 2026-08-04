import Std

/-!
# Certified System Steward

A pure Lean model of a portable, certified system-optimization step.

The formal core does not know macOS, Linux, Windows, filesystems or shell
commands. A concrete platform supplies an adapter. The core accepts a state
transition only when the action belongs to the available action field, the
domain policy admits the candidate state, and the protected projection is
unchanged.

This file deliberately models continuity and admissibility, not real-world
cryptographic security. Hashes and signatures belong to an implementation and
must be supplied by reviewed cryptographic primitives.
-/

namespace CertifiedSystemSteward

universe uState uAction uObservation uProtected uDigest

/-! ## Universal system interface -/

/-- Platform-specific observation and action semantics. -/
structure Adapter
    (State : Type uState)
    (Action : Type uAction)
    (Observation : Type uObservation)
    (Protected : Type uProtected) where
  observe : State → Observation
  applyAction : State → Action → State
  protectedView : State → Protected

/-- Domain policy. It decides which proposed transition is admissible. -/
structure Policy
    (State : Type uState)
    (Action : Type uAction) where
  admit : State → Action → State → Prop

/-- Actions currently exposed to a selector. -/
abbrev ActionField (Action : Type uAction) := List Action

/-- A selector reads an observation and may choose one exposed action. -/
def Selector
    (Observation : Type uObservation)
    (Action : Type uAction) :=
  Observation → ActionField Action → Option Action

/-- A selector is sound when it never returns an action outside its field. -/
def Selector.Sound
    {Observation : Type uObservation}
    {Action : Type uAction}
    (selector : Selector Observation Action) : Prop :=
  ∀ observation field action,
    selector observation field = some action → action ∈ field

/-- Complete portable passport of a system steward. -/
structure Passport
    (State : Type uState)
    (Action : Type uAction)
    (Observation : Type uObservation)
    (Protected : Type uProtected) where
  adapter : Adapter State Action Observation Protected
  policy : Policy State Action
  selector : Selector Observation Action
  selectorSound : selector.Sound

/-! ## Admitted transitions -/

/--
The core transition contract:

1. the action was exposed in the current field;
2. the candidate is exactly the adapter result;
3. the domain policy admits the candidate;
4. the protected projection remains unchanged.
-/
def AdmittedTransition
    {State : Type uState}
    {Action : Type uAction}
    {Observation : Type uObservation}
    {Protected : Type uProtected}
    (passport : Passport State Action Observation Protected)
    (before : State)
    (field : ActionField Action)
    (action : Action)
    (after : State) : Prop :=
  action ∈ field ∧
  after = passport.adapter.applyAction before action ∧
  passport.policy.admit before action after ∧
  passport.adapter.protectedView after = passport.adapter.protectedView before

/-- Every admitted transition preserves the protected projection. -/
theorem admitted_preserves_protected
    {State : Type uState}
    {Action : Type uAction}
    {Observation : Type uObservation}
    {Protected : Type uProtected}
    {passport : Passport State Action Observation Protected}
    {before after : State}
    {field : ActionField Action}
    {action : Action}
    (h : AdmittedTransition passport before field action after) :
    passport.adapter.protectedView after = passport.adapter.protectedView before := by
  exact h.2.2.2

/-- An action outside the current field cannot form an admitted transition. -/
theorem action_outside_field_is_rejected
    {State : Type uState}
    {Action : Type uAction}
    {Observation : Type uObservation}
    {Protected : Type uProtected}
    {passport : Passport State Action Observation Protected}
    {before after : State}
    {field : ActionField Action}
    {action : Action}
    (hOutside : action ∉ field) :
    ¬ AdmittedTransition passport before field action after := by
  intro hAdmitted
  exact hOutside hAdmitted.1

/-- A policy-rejected candidate cannot form an admitted transition. -/
theorem policy_rejection_blocks_transition
    {State : Type uState}
    {Action : Type uAction}
    {Observation : Type uObservation}
    {Protected : Type uProtected}
    {passport : Passport State Action Observation Protected}
    {before after : State}
    {field : ActionField Action}
    {action : Action}
    (hRejected : ¬ passport.policy.admit before action after) :
    ¬ AdmittedTransition passport before field action after := by
  intro hAdmitted
  exact hRejected hAdmitted.2.2.1

/-! ## Certified continuity -/

/-- Logical continuity head. `digest` is abstract in the formal core. -/
structure Head (Digest : Type uDigest) where
  epoch : Nat
  digest : Digest
deriving Repr

/--
A proof-carrying receipt. The certificate carries the transition proof and
strict epoch growth. It does not claim that `Digest` is cryptographically
secure.
-/
structure Receipt
    {State : Type uState}
    {Action : Type uAction}
    {Observation : Type uObservation}
    {Protected : Type uProtected}
    (Digest : Type uDigest)
    (passport : Passport State Action Observation Protected) where
  parent : Head Digest
  next : Head Digest
  before : State
  field : ActionField Action
  action : Action
  after : State
  epochStep : next.epoch = parent.epoch + 1
  certified : AdmittedTransition passport before field action after

/-- A certified receipt inherits protected-state preservation. -/
theorem receipt_preserves_protected
    {State : Type uState}
    {Action : Type uAction}
    {Observation : Type uObservation}
    {Protected : Type uProtected}
    {Digest : Type uDigest}
    {passport : Passport State Action Observation Protected}
    (receipt : Receipt Digest passport) :
    passport.adapter.protectedView receipt.after =
      passport.adapter.protectedView receipt.before := by
  exact admitted_preserves_protected receipt.certified

/-- Two receipts address the same logical successor slot. -/
def sameSlot
    {State : Type uState}
    {Action : Type uAction}
    {Observation : Type uObservation}
    {Protected : Type uProtected}
    {Digest : Type uDigest}
    {passport : Passport State Action Observation Protected}
    (left right : Receipt Digest passport) : Prop :=
  left.parent = right.parent ∧ left.next.epoch = right.next.epoch

/-- Compact fork evidence: one slot carries two distinct next digests. -/
def ForkEvidence
    {State : Type uState}
    {Action : Type uAction}
    {Observation : Type uObservation}
    {Protected : Type uProtected}
    {Digest : Type uDigest}
    {passport : Passport State Action Observation Protected}
    (left right : Receipt Digest passport) : Prop :=
  sameSlot left right ∧ left.next.digest ≠ right.next.digest

/-- A receipt cannot be fork evidence against itself. -/
theorem no_self_fork
    {State : Type uState}
    {Action : Type uAction}
    {Observation : Type uObservation}
    {Protected : Type uProtected}
    {Digest : Type uDigest}
    {passport : Passport State Action Observation Protected}
    (receipt : Receipt Digest passport) :
    ¬ ForkEvidence receipt receipt := by
  intro hFork
  exact hFork.2 rfl

/-! ## First adapter: reproducible-cache cleanup -/

/-- Cache classes currently permitted by the macOS adapter. -/
inductive CacheKind where
  | lake
  | nodeModules
deriving BEq, DecidableEq, ReflBEq, LawfulBEq, Repr

/-- Logical path kept independent of operating-system path syntax. -/
structure CachePath where
  components : List String
  kind : CacheKind
deriving BEq, DecidableEq, ReflBEq, LawfulBEq, Repr

/-- Minimal cleanup state used by the formal adapter. -/
structure CleanupState where
  existing : List CachePath
  protectedRoot : String
deriving DecidableEq, Repr

/-- One proposed cleanup action. -/
structure CleanupAction where
  targets : List CachePath
deriving DecidableEq, Repr

/-- Observation exposed to the selector. -/
structure CleanupObservation where
  cacheCount : Nat
  protectedRoot : String
deriving DecidableEq, Repr

/-- Every selected target must belong to the fixed logical allowlist. -/
def targetsAllowed
    (allowlist : List CachePath)
    (action : CleanupAction) : Prop :=
  ∀ target, target ∈ action.targets → target ∈ allowlist

/-- Pure cache deletion: remove selected cache paths from the logical state. -/
def applyCleanup
    (state : CleanupState)
    (action : CleanupAction) : CleanupState :=
  { existing := state.existing.filter (fun path => !action.targets.contains path)
    protectedRoot := state.protectedRoot }

/-- The cleanup adapter changes cache presence but not the protected root. -/
def cleanupAdapter :
    Adapter CleanupState CleanupAction CleanupObservation String where
  observe state :=
    { cacheCount := state.existing.length
      protectedRoot := state.protectedRoot }
  applyAction := applyCleanup
  protectedView := CleanupState.protectedRoot

/-- Cleanup policy generated from one explicit allowlist. -/
def cleanupPolicy (allowlist : List CachePath) :
    Policy CleanupState CleanupAction where
  admit before action after :=
    targetsAllowed allowlist action ∧
    after = applyCleanup before action

/-- Logical cleanup cannot alter the protected root. -/
theorem applyCleanup_preserves_protected
    (state : CleanupState)
    (action : CleanupAction) :
    (applyCleanup state action).protectedRoot = state.protectedRoot := by
  rfl

/-- Every path remaining after cleanup was not selected for deletion. -/
theorem remaining_path_was_not_selected
    {state : CleanupState}
    {action : CleanupAction}
    {path : CachePath}
    (hRemaining : path ∈ (applyCleanup state action).existing) :
    path ∉ action.targets := by
  intro hSelected
  have hKept : (!action.targets.contains path) = true :=
    (List.mem_filter.mp hRemaining).2
  simp at hKept
  exact hKept hSelected

/-! ## Formal boundary -/

/--
The portable theorem proved by the model:

If a platform adapter implements the declared transition semantics and the
transition is admitted, then the protected projection is invariant.

The theorem does not prove that a shell program implements the adapter, that a
hash function is collision resistant, or that an endpoint is uncompromised.
-/
theorem portable_protected_invariant
    {State : Type uState}
    {Action : Type uAction}
    {Observation : Type uObservation}
    {Protected : Type uProtected}
    {passport : Passport State Action Observation Protected}
    {before after : State}
    {field : ActionField Action}
    {action : Action}
    (hCertified : AdmittedTransition passport before field action after) :
    passport.adapter.protectedView after = passport.adapter.protectedView before := by
  exact admitted_preserves_protected hCertified

end CertifiedSystemSteward
