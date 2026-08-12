import TMI.DigitalLifeWitnessQuorum

/-!
# I³-L10: fault-domain independence and quorum liveness

L09 counts distinct authenticated witness identities.  L10 additionally
requires the votes used by one admission to come from distinct declared
administrative, network and host fault domains.  Liveness is modelled
separately: a policy is live for an availability set when that set contains
an independent threshold subset.

The declarations prove rules over domain labels.  They do not prove that the
labels correspond to physically, organisationally or operationally
independent infrastructure.
-/

namespace TMI.DigitalLifeFaultDomainQuorum

open TMI.DigitalLifeExternalRollbackWitness
open TMI.DigitalLifeWitnessQuorum

def faultDomainProtocolVersion : Nat := 1

structure FaultDomainProfile where
  member : QuorumMember
  adminDomain : String
  networkDomain : String
  hostDomain : String
  deriving DecidableEq, Repr

structure FaultDomainPolicy where
  quorum : QuorumPolicy
  profiles : List FaultDomainProfile
  deriving DecidableEq, Repr

structure FaultDomainVote where
  base : SignedWitnessVote
  domainPolicyDigest : String
  deriving DecidableEq, Repr

def findProfileByWitnessId
    (profiles : List FaultDomainProfile)
    (witnessId : String) : Option FaultDomainProfile :=
  match profiles with
  | [] => none
  | profile :: rest =>
      if profile.member.witnessId == witnessId then some profile
      else findProfileByWitnessId rest witnessId

def profilesForWitnessIds
    (policy : FaultDomainPolicy) :
    List String → Option (List FaultDomainProfile)
  | [] => some []
  | witnessId :: rest => do
      let profile ← findProfileByWitnessId policy.profiles witnessId
      let tail ← profilesForWitnessIds policy rest
      pure (profile :: tail)

def DomainPolicyWellFormed (policy : FaultDomainPolicy) : Prop :=
  PolicyWellFormed policy.quorum ∧
  policy.profiles.map (fun profile => profile.member) = policy.quorum.members ∧
  ∀ profile ∈ policy.profiles,
    profile.adminDomain ≠ "" ∧
    profile.networkDomain ≠ "" ∧
    profile.hostDomain ≠ ""

instance (policy : FaultDomainPolicy) : Decidable (DomainPolicyWellFormed policy) := by
  unfold DomainPolicyWellFormed
  infer_instance

def AdminSeparated (policy : FaultDomainPolicy) (witnessIds : List String) : Prop :=
  match profilesForWitnessIds policy witnessIds with
  | some profiles => (profiles.map (fun profile => profile.adminDomain)).Nodup
  | none => False

def NetworkSeparated (policy : FaultDomainPolicy) (witnessIds : List String) : Prop :=
  match profilesForWitnessIds policy witnessIds with
  | some profiles => (profiles.map (fun profile => profile.networkDomain)).Nodup
  | none => False

def HostSeparated (policy : FaultDomainPolicy) (witnessIds : List String) : Prop :=
  match profilesForWitnessIds policy witnessIds with
  | some profiles => (profiles.map (fun profile => profile.hostDomain)).Nodup
  | none => False

instance (policy : FaultDomainPolicy) (ids : List String) :
    Decidable (AdminSeparated policy ids) := by
  unfold AdminSeparated
  split <;> infer_instance

instance (policy : FaultDomainPolicy) (ids : List String) :
    Decidable (NetworkSeparated policy ids) := by
  unfold NetworkSeparated
  split <;> infer_instance

instance (policy : FaultDomainPolicy) (ids : List String) :
    Decidable (HostSeparated policy ids) := by
  unfold HostSeparated
  split <;> infer_instance

def IndependentWitnessSet
    (policy : FaultDomainPolicy)
    (witnessIds : List String) : Prop :=
  witnessIds.Nodup ∧
  AdminSeparated policy witnessIds ∧
  NetworkSeparated policy witnessIds ∧
  HostSeparated policy witnessIds

instance (policy : FaultDomainPolicy) (ids : List String) :
    Decidable (IndependentWitnessSet policy ids) := by
  unfold IndependentWitnessSet
  infer_instance

def FaultDomainVoteBound
    (policy : FaultDomainPolicy)
    (policyDigest : String)
    (target : LocalAnchor)
    (round : Nat)
    (vote : FaultDomainVote) : Prop :=
  VoteBound policy.quorum target round vote.base ∧
  vote.domainPolicyDigest = policyDigest ∧
  policyDigest.length = 64

instance
    (policy : FaultDomainPolicy)
    (policyDigest : String)
    (target : LocalAnchor)
    (round : Nat)
    (vote : FaultDomainVote) :
    Decidable (FaultDomainVoteBound policy policyDigest target round vote) := by
  unfold FaultDomainVoteBound
  infer_instance

def IndependentQuorumReady
    (policy : FaultDomainPolicy)
    (policyDigest : String)
    (target : LocalAnchor)
    (round : Nat)
    (votes : List FaultDomainVote) : Prop :=
  DomainPolicyWellFormed policy ∧
  QuorumReady policy.quorum target round (votes.map (fun vote => vote.base)) ∧
  (∀ vote ∈ votes, FaultDomainVoteBound policy policyDigest target round vote) ∧
  IndependentWitnessSet policy (votes.map (fun vote => vote.base.witnessId))

instance
    (policy : FaultDomainPolicy)
    (policyDigest : String)
    (target : LocalAnchor)
    (round : Nat)
    (votes : List FaultDomainVote) :
    Decidable (IndependentQuorumReady policy policyDigest target round votes) := by
  unfold IndependentQuorumReady
  infer_instance

def independentAdmitOrHold
    (policy : FaultDomainPolicy)
    (policyDigest : String)
    (target : LocalAnchor)
    (round : Nat)
    (votes : List FaultDomainVote) : Option LocalAnchor :=
  if IndependentQuorumReady policy policyDigest target round votes then
    some target
  else
    none

def QuorumLive
    (policy : FaultDomainPolicy)
    (availableWitnessIds : List String) : Prop :=
  ∃ selectedWitnessIds,
    selectedWitnessIds.length = policy.quorum.threshold ∧
    (∀ witnessId ∈ selectedWitnessIds, witnessId ∈ availableWitnessIds) ∧
    IndependentWitnessSet policy selectedWitnessIds

def LivenessCertified
    (policy : FaultDomainPolicy)
    (availableWitnessIds : List String) : Prop :=
  DomainPolicyWellFormed policy ∧ QuorumLive policy availableWitnessIds

theorem independent_ready_admits
    (hReady : IndependentQuorumReady policy policyDigest target round votes) :
    independentAdmitOrHold policy policyDigest target round votes = some target := by
  simp [independentAdmitOrHold, hReady]

theorem shared_admin_domain_holds
    (hShared : ¬ AdminSeparated policy (votes.map (fun vote => vote.base.witnessId))) :
    independentAdmitOrHold policy policyDigest target round votes = none := by
  apply if_neg
  intro hReady
  exact hShared hReady.2.2.2.2.1

theorem shared_network_domain_holds
    (hShared : ¬ NetworkSeparated policy (votes.map (fun vote => vote.base.witnessId))) :
    independentAdmitOrHold policy policyDigest target round votes = none := by
  apply if_neg
  intro hReady
  exact hShared hReady.2.2.2.2.2.1

theorem shared_host_domain_holds
    (hShared : ¬ HostSeparated policy (votes.map (fun vote => vote.base.witnessId))) :
    independentAdmitOrHold policy policyDigest target round votes = none := by
  apply if_neg
  intro hReady
  exact hShared hReady.2.2.2.2.2.2

theorem changed_domain_policy_holds
    (hMember : vote ∈ votes)
    (hChanged : vote.domainPolicyDigest ≠ policyDigest) :
    independentAdmitOrHold policy policyDigest target round votes = none := by
  apply if_neg
  intro hReady
  have hBound := hReady.2.2.1 vote hMember
  exact hChanged hBound.2.1

theorem independent_admission_is_exact
    (hAdmit : independentAdmitOrHold policy policyDigest target round votes = some admitted) :
    admitted = target := by
  unfold independentAdmitOrHold at hAdmit
  split at hAdmit <;> simp_all

theorem live_of_available_independent_set
    (hPolicy : DomainPolicyWellFormed policy)
    (hLength : selectedWitnessIds.length = policy.quorum.threshold)
    (hAvailable : ∀ witnessId ∈ selectedWitnessIds, witnessId ∈ availableWitnessIds)
    (hIndependent : IndependentWitnessSet policy selectedWitnessIds) :
    LivenessCertified policy availableWitnessIds := by
  exact ⟨hPolicy, ⟨selectedWitnessIds, hLength, hAvailable, hIndependent⟩⟩

end TMI.DigitalLifeFaultDomainQuorum
