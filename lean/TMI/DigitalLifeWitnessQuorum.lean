import TMI.DigitalLifeExternalRollbackWitness

/-!
# I³-L09: witness quorum and threshold acceptance

One external witness detects local rollback, but remains one trust point.  This
layer admits an anchor only when a well-formed policy receives enough distinct,
authorized and signature-verified votes for the exact same round and anchor.

The theorem layer models threshold admission.  It does not prove key secrecy,
network independence, Byzantine safety above the configured threshold, or the
correctness of a concrete signature implementation.
-/

namespace TMI.DigitalLifeWitnessQuorum

open TMI.DigitalLifeExternalRollbackWitness

def quorumProtocolVersion : Nat := 1

structure QuorumMember where
  witnessId : String
  keyId : String
  deriving DecidableEq, Repr

structure QuorumPolicy where
  policyId : String
  threshold : Nat
  members : List QuorumMember
  deriving DecidableEq, Repr

structure SignedWitnessVote where
  policyId : String
  round : Nat
  witnessId : String
  keyId : String
  anchor : LocalAnchor
  checkpointDigest : String
  signatureVerified : Bool
  deriving DecidableEq, Repr

def AuthorizedMember (policy : QuorumPolicy) (vote : SignedWitnessVote) : Prop :=
  ∃ member ∈ policy.members,
    member.witnessId = vote.witnessId ∧ member.keyId = vote.keyId

instance (policy : QuorumPolicy) (vote : SignedWitnessVote) :
    Decidable (AuthorizedMember policy vote) := by
  unfold AuthorizedMember
  infer_instance

def PolicyWellFormed (policy : QuorumPolicy) : Prop :=
  policy.policyId ≠ "" ∧
  0 < policy.threshold ∧
  policy.threshold ≤ policy.members.length ∧
  (policy.members.map (fun member => member.witnessId)).Nodup ∧
  (policy.members.map (fun member => member.keyId)).Nodup

instance (policy : QuorumPolicy) : Decidable (PolicyWellFormed policy) := by
  unfold PolicyWellFormed
  infer_instance

def VoteBound
    (policy : QuorumPolicy)
    (target : LocalAnchor)
    (round : Nat)
    (vote : SignedWitnessVote) : Prop :=
  vote.signatureVerified = true ∧
  vote.policyId = policy.policyId ∧
  vote.round = round ∧
  vote.anchor = target ∧
  vote.checkpointDigest.length = 64 ∧
  AuthorizedMember policy vote

instance
    (policy : QuorumPolicy)
    (target : LocalAnchor)
    (round : Nat)
    (vote : SignedWitnessVote) :
    Decidable (VoteBound policy target round vote) := by
  unfold VoteBound
  infer_instance

def QuorumReady
    (policy : QuorumPolicy)
    (target : LocalAnchor)
    (round : Nat)
    (votes : List SignedWitnessVote) : Prop :=
  PolicyWellFormed policy ∧
  (votes.map (fun vote => vote.witnessId)).Nodup ∧
  policy.threshold ≤ votes.length ∧
  ∀ vote ∈ votes, VoteBound policy target round vote

instance
    (policy : QuorumPolicy)
    (target : LocalAnchor)
    (round : Nat)
    (votes : List SignedWitnessVote) :
    Decidable (QuorumReady policy target round votes) := by
  unfold QuorumReady
  infer_instance

def quorumAdmitOrHold
    (policy : QuorumPolicy)
    (target : LocalAnchor)
    (round : Nat)
    (votes : List SignedWitnessVote) : Option LocalAnchor :=
  if QuorumReady policy target round votes then some target else none

theorem ready_quorum_admits
    (hReady : QuorumReady policy target round votes) :
    quorumAdmitOrHold policy target round votes = some target := by
  simp [quorumAdmitOrHold, hReady]

theorem below_threshold_holds
    (hBelow : votes.length < policy.threshold) :
    quorumAdmitOrHold policy target round votes = none := by
  apply if_neg
  intro hReady
  exact (Nat.not_le_of_lt hBelow) hReady.2.2.1

theorem duplicate_witness_holds
    (hDuplicate : ¬ (votes.map (fun vote => vote.witnessId)).Nodup) :
    quorumAdmitOrHold policy target round votes = none := by
  apply if_neg
  intro hReady
  exact hDuplicate hReady.2.1

theorem unsigned_vote_prevents_quorum
    (hMember : vote ∈ votes)
    (hUnsigned : vote.signatureVerified = false) :
    quorumAdmitOrHold policy target round votes = none := by
  apply if_neg
  intro hReady
  have hBound := hReady.2.2.2 vote hMember
  have hSigned := hBound.1
  simp [hUnsigned] at hSigned

theorem conflicting_anchor_prevents_quorum
    (hMember : vote ∈ votes)
    (hConflict : vote.anchor ≠ target) :
    quorumAdmitOrHold policy target round votes = none := by
  apply if_neg
  intro hReady
  have hBound := hReady.2.2.2 vote hMember
  exact hConflict hBound.2.2.2.1

theorem admitted_anchor_is_exact
    (hAdmit : quorumAdmitOrHold policy target round votes = some admitted) :
    admitted = target := by
  unfold quorumAdmitOrHold at hAdmit
  split at hAdmit <;> simp_all

end TMI.DigitalLifeWitnessQuorum
