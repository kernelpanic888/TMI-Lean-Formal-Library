import AISOControlLoop
import CertifiedSystemSteward

/-!
AISOToStewardBridge.lean

A proof-carrying bridge from an AISO selection certificate to a Certified
System Steward receipt and then to verified learning.
-/

namespace AISOToStewardBridge

open CertifiedSystemSteward

universe uState uModel uAction uInvariant uRollback uObservation uProtected uDigest

structure BoundReceipt
    {State : Type uState}
    {Model : Type uModel}
    {Action : Type uAction}
    {Invariant : Type uInvariant}
    {RollbackReceipt : Type uRollback}
    {Observation : Type uObservation}
    {Protected : Type uProtected}
    (Digest : Type uDigest)
    (sys : AISO State Model Action Invariant RollbackReceipt)
    (passport : Passport State Action Observation Protected)
    (time : Nat)
    (selected : Action) where
  selection : BestAdmissible sys time selected
  receipt : Receipt Digest passport
  beforeBound : receipt.before = sys.stateAt time
  actionBound : receipt.action = selected
  afterBound : receipt.after = sys.apply (sys.stateAt time) selected
  postVerified :
    sys.postVerify (sys.stateAt time) selected receipt.after

theorem bound_receipt_certifies_selected_transition
    {State : Type uState}
    {Model : Type uModel}
    {Action : Type uAction}
    {Invariant : Type uInvariant}
    {RollbackReceipt : Type uRollback}
    {Observation : Type uObservation}
    {Protected : Type uProtected}
    {Digest : Type uDigest}
    {sys : AISO State Model Action Invariant RollbackReceipt}
    {passport : Passport State Action Observation Protected}
    {time : Nat}
    {selected : Action}
    (bridge : BoundReceipt Digest sys passport time selected) :
    AdmittedTransition
      passport
      (sys.stateAt time)
      bridge.receipt.field
      selected
      (sys.apply (sys.stateAt time) selected) := by
  simpa [bridge.beforeBound, bridge.actionBound, bridge.afterBound] using
    bridge.receipt.certified

def toVerifiedTransition
    {State : Type uState}
    {Model : Type uModel}
    {Action : Type uAction}
    {Invariant : Type uInvariant}
    {RollbackReceipt : Type uRollback}
    {Observation : Type uObservation}
    {Protected : Type uProtected}
    {Digest : Type uDigest}
    {sys : AISO State Model Action Invariant RollbackReceipt}
    {passport : Passport State Action Observation Protected}
    {time : Nat}
    {selected : Action}
    (bridge : BoundReceipt Digest sys passport time selected) :
    VerifiedTransition sys time selected where
  next := bridge.receipt.after
  applied := bridge.afterBound
  postVerified := bridge.postVerified
  qualityImproved := by
    simpa [bridge.afterBound] using bridge.selection.admissible.qualityImproves
  invariantsPreserved := by
    intro invariant hProtected hBefore
    have hPreserved :=
      bridge.selection.admissible.preservesInvariant invariant hProtected hBefore
    simpa [bridge.afterBound] using hPreserved

def learnFromBoundReceipt
    {State : Type uState}
    {Model : Type uModel}
    {Action : Type uAction}
    {Invariant : Type uInvariant}
    {RollbackReceipt : Type uRollback}
    {Observation : Type uObservation}
    {Protected : Type uProtected}
    {Digest : Type uDigest}
    {sys : AISO State Model Action Invariant RollbackReceipt}
    {passport : Passport State Action Observation Protected}
    {time : Nat}
    {selected : Action}
    (bridge : BoundReceipt Digest sys passport time selected) :
    LearningStep sys time selected where
  transition := toVerifiedTransition bridge
  nextModel :=
    sys.learn
      (sys.modelAt time)
      (sys.stateAt time)
      selected
      bridge.receipt.after
  learned := rfl

theorem bound_receipt_action_cannot_drift
    {State : Type uState}
    {Model : Type uModel}
    {Action : Type uAction}
    {Invariant : Type uInvariant}
    {RollbackReceipt : Type uRollback}
    {Observation : Type uObservation}
    {Protected : Type uProtected}
    {Digest : Type uDigest}
    {sys : AISO State Model Action Invariant RollbackReceipt}
    {passport : Passport State Action Observation Protected}
    {time : Nat}
    {selected : Action}
    (bridge : BoundReceipt Digest sys passport time selected) :
    bridge.receipt.action = selected :=
  bridge.actionBound

theorem bound_receipt_state_cannot_drift
    {State : Type uState}
    {Model : Type uModel}
    {Action : Type uAction}
    {Invariant : Type uInvariant}
    {RollbackReceipt : Type uRollback}
    {Observation : Type uObservation}
    {Protected : Type uProtected}
    {Digest : Type uDigest}
    {sys : AISO State Model Action Invariant RollbackReceipt}
    {passport : Passport State Action Observation Protected}
    {time : Nat}
    {selected : Action}
    (bridge : BoundReceipt Digest sys passport time selected) :
    bridge.receipt.before = sys.stateAt time ∧
      bridge.receipt.after = sys.apply (sys.stateAt time) selected :=
  ⟨bridge.beforeBound, bridge.afterBound⟩

theorem receipt_bound_learning_is_post_verified
    {State : Type uState}
    {Model : Type uModel}
    {Action : Type uAction}
    {Invariant : Type uInvariant}
    {RollbackReceipt : Type uRollback}
    {Observation : Type uObservation}
    {Protected : Type uProtected}
    {Digest : Type uDigest}
    {sys : AISO State Model Action Invariant RollbackReceipt}
    {passport : Passport State Action Observation Protected}
    {time : Nat}
    {selected : Action}
    (bridge : BoundReceipt Digest sys passport time selected) :
    sys.postVerify
      (sys.stateAt time)
      selected
      (learnFromBoundReceipt bridge).transition.next :=
  learning_requires_post_verification (learnFromBoundReceipt bridge)

theorem mismatched_action_blocks_binding
    {State : Type uState}
    {Model : Type uModel}
    {Action : Type uAction}
    {Invariant : Type uInvariant}
    {RollbackReceipt : Type uRollback}
    {Observation : Type uObservation}
    {Protected : Type uProtected}
    {Digest : Type uDigest}
    {sys : AISO State Model Action Invariant RollbackReceipt}
    {passport : Passport State Action Observation Protected}
    {time : Nat}
    {selected : Action}
    (bridge : BoundReceipt Digest sys passport time selected)
    (mismatch : bridge.receipt.action ≠ selected) : False :=
  mismatch bridge.actionBound

end AISOToStewardBridge
