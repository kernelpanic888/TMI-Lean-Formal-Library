import TMI.DigitalLifeFaultDomainQuorum

/-!
# I³-L11: fresh remote witness challenge-response

A declared fault domain is not yet evidence that a response came freshly from
that domain.  This layer binds a verifier-signed one-time challenge to the
domain policy, target anchor, witness identity, endpoint and TLS peer digest.
The witness signs a response for that exact challenge and its current anchor.
A consumed, stale, redirected, peer-mismatched or unsigned response holds.

The model proves rules over verified signatures, times and transport labels.
It does not prove hardware attestation, wall-clock correctness, TLS library
correctness or that a declared endpoint is physically independent.
-/

namespace TMI.DigitalLifeRemoteWitnessChallenge

open TMI.DigitalLifeExternalRollbackWitness
open TMI.DigitalLifeWitnessQuorum
open TMI.DigitalLifeFaultDomainQuorum

def remoteChallengeProtocolVersion : Nat := 1

structure RemoteWitnessProfile where
  domain : FaultDomainProfile
  endpointId : String
  endpointUrl : String
  tlsPeerDigest : String
  deriving DecidableEq, Repr

structure RemoteWitnessPolicy where
  domainPolicy : FaultDomainPolicy
  verifierId : String
  verifierKeyId : String
  maxLifetime : Nat
  profiles : List RemoteWitnessProfile
  deriving DecidableEq, Repr

structure RemoteChallenge where
  policyId : String
  domainPolicyDigest : String
  challengeId : String
  verifierId : String
  verifierKeyId : String
  round : Nat
  issuedAt : Nat
  expiresAt : Nat
  target : LocalAnchor
  witnessId : String
  keyId : String
  endpointId : String
  tlsPeerDigest : String
  signatureVerified : Bool
  deriving DecidableEq, Repr

structure RemoteResponse where
  policyId : String
  domainPolicyDigest : String
  challengeId : String
  challengeDigest : String
  round : Nat
  witnessId : String
  keyId : String
  endpointId : String
  tlsPeerDigest : String
  respondedAt : Nat
  anchor : LocalAnchor
  checkpointDigest : String
  signatureVerified : Bool
  deriving DecidableEq, Repr

def findRemoteProfile
    (profiles : List RemoteWitnessProfile)
    (witnessId : String) : Option RemoteWitnessProfile :=
  match profiles with
  | [] => none
  | profile :: rest =>
      if profile.domain.member.witnessId == witnessId then some profile
      else findRemoteProfile rest witnessId

def RemotePolicyWellFormed (policy : RemoteWitnessPolicy) : Prop :=
  DomainPolicyWellFormed policy.domainPolicy ∧
  policy.verifierId ≠ "" ∧
  policy.verifierKeyId ≠ "" ∧
  0 < policy.maxLifetime ∧
  policy.profiles.map (fun profile => profile.domain) =
    policy.domainPolicy.profiles ∧
  (policy.profiles.map (fun profile => profile.endpointId)).Nodup ∧
  ∀ profile ∈ policy.profiles,
    profile.endpointId ≠ "" ∧
    profile.endpointUrl.startsWith "https://" = true ∧
    profile.tlsPeerDigest.length = 64

instance (policy : RemoteWitnessPolicy) : Decidable (RemotePolicyWellFormed policy) := by
  unfold RemotePolicyWellFormed
  infer_instance

def ChallengeBound
    (policy : RemoteWitnessPolicy)
    (policyDigest : String)
    (target : LocalAnchor)
    (challenge : RemoteChallenge) : Prop :=
  challenge.signatureVerified = true ∧
  challenge.policyId = policy.domainPolicy.quorum.policyId ∧
  challenge.domainPolicyDigest = policyDigest ∧
  policyDigest.length = 64 ∧
  challenge.challengeId.length = 64 ∧
  challenge.verifierId = policy.verifierId ∧
  challenge.verifierKeyId = policy.verifierKeyId ∧
  challenge.round > 0 ∧
  challenge.target = target ∧
  challenge.issuedAt < challenge.expiresAt ∧
  challenge.expiresAt - challenge.issuedAt ≤ policy.maxLifetime ∧
  ∃ profile ∈ policy.profiles,
    profile.domain.member.witnessId = challenge.witnessId ∧
    profile.domain.member.keyId = challenge.keyId ∧
    profile.endpointId = challenge.endpointId ∧
    profile.tlsPeerDigest = challenge.tlsPeerDigest

instance
    (policy : RemoteWitnessPolicy)
    (policyDigest : String)
    (target : LocalAnchor)
    (challenge : RemoteChallenge) :
    Decidable (ChallengeBound policy policyDigest target challenge) := by
  unfold ChallengeBound
  infer_instance

def ChallengeFreshAt (now : Nat) (challenge : RemoteChallenge) : Prop :=
  challenge.issuedAt ≤ now ∧ now ≤ challenge.expiresAt

instance (now : Nat) (challenge : RemoteChallenge) :
    Decidable (ChallengeFreshAt now challenge) := by
  unfold ChallengeFreshAt
  infer_instance

def responseAsFaultDomainVote (response : RemoteResponse) : FaultDomainVote :=
  { base := {
      policyId := response.policyId,
      round := response.round,
      witnessId := response.witnessId,
      keyId := response.keyId,
      anchor := response.anchor,
      checkpointDigest := response.checkpointDigest,
      signatureVerified := response.signatureVerified },
    domainPolicyDigest := response.domainPolicyDigest }

def FreshRemoteResponse
    (policy : RemoteWitnessPolicy)
    (policyDigest challengeDigest : String)
    (target : LocalAnchor)
    (now : Nat)
    (consumedChallengeIds : List String)
    (challenge : RemoteChallenge)
    (response : RemoteResponse) : Prop :=
  RemotePolicyWellFormed policy ∧
  ChallengeBound policy policyDigest target challenge ∧
  ChallengeFreshAt now challenge ∧
  challenge.challengeId ∉ consumedChallengeIds ∧
  response.challengeId = challenge.challengeId ∧
  response.challengeDigest = challengeDigest ∧
  challengeDigest.length = 64 ∧
  response.endpointId = challenge.endpointId ∧
  response.tlsPeerDigest = challenge.tlsPeerDigest ∧
  challenge.issuedAt ≤ response.respondedAt ∧
  response.respondedAt ≤ now ∧
  response.respondedAt ≤ challenge.expiresAt ∧
  FaultDomainVoteBound policy.domainPolicy policyDigest target challenge.round
    (responseAsFaultDomainVote response)

instance
    (policy : RemoteWitnessPolicy)
    (policyDigest challengeDigest : String)
    (target : LocalAnchor)
    (now : Nat)
    (consumedChallengeIds : List String)
    (challenge : RemoteChallenge)
    (response : RemoteResponse) :
    Decidable (FreshRemoteResponse policy policyDigest challengeDigest target now
      consumedChallengeIds challenge response) := by
  unfold FreshRemoteResponse
  infer_instance

def remoteAdmitOrHold
    (policy : RemoteWitnessPolicy)
    (policyDigest challengeDigest : String)
    (target : LocalAnchor)
    (now : Nat)
    (consumedChallengeIds : List String)
    (challenge : RemoteChallenge)
    (response : RemoteResponse) : Option FaultDomainVote :=
  if FreshRemoteResponse policy policyDigest challengeDigest target now
      consumedChallengeIds challenge response then
    some (responseAsFaultDomainVote response)
  else
    none

theorem fresh_remote_response_admits
    (hFresh : FreshRemoteResponse policy policyDigest challengeDigest target now
      consumed challenge response) :
    remoteAdmitOrHold policy policyDigest challengeDigest target now consumed
      challenge response = some (responseAsFaultDomainVote response) := by
  simp [remoteAdmitOrHold, hFresh]

theorem replayed_challenge_holds
    (hConsumed : challenge.challengeId ∈ consumed) :
    remoteAdmitOrHold policy policyDigest challengeDigest target now consumed
      challenge response = none := by
  apply if_neg
  intro hFresh
  exact hFresh.2.2.2.1 hConsumed

theorem expired_challenge_holds
    (hExpired : challenge.expiresAt < now) :
    remoteAdmitOrHold policy policyDigest challengeDigest target now consumed
      challenge response = none := by
  apply if_neg
  intro hFresh
  exact (Nat.not_le_of_lt hExpired) hFresh.2.2.1.2

theorem redirected_endpoint_holds
    (hRedirect : response.endpointId ≠ challenge.endpointId) :
    remoteAdmitOrHold policy policyDigest challengeDigest target now consumed
      challenge response = none := by
  apply if_neg
  intro hFresh
  exact hRedirect hFresh.2.2.2.2.2.2.2.1

theorem changed_tls_peer_holds
    (hPeer : response.tlsPeerDigest ≠ challenge.tlsPeerDigest) :
    remoteAdmitOrHold policy policyDigest challengeDigest target now consumed
      challenge response = none := by
  apply if_neg
  intro hFresh
  exact hPeer hFresh.2.2.2.2.2.2.2.2.1

theorem unsigned_response_holds
    (hUnsigned : response.signatureVerified = false) :
    remoteAdmitOrHold policy policyDigest challengeDigest target now consumed
      challenge response = none := by
  apply if_neg
  intro hFresh
  rcases hFresh with ⟨_, _, _, _, _, _, _, _, _, _, _, _, hVoteBound⟩
  have hSigned := hVoteBound.1.1
  simp [responseAsFaultDomainVote, hUnsigned] at hSigned

theorem admitted_remote_vote_is_domain_bound
    (hAdmit : remoteAdmitOrHold policy policyDigest challengeDigest target now
      consumed challenge response = some vote) :
    FaultDomainVoteBound policy.domainPolicy policyDigest target challenge.round vote := by
  unfold remoteAdmitOrHold at hAdmit
  split at hAdmit
  · have hFresh := ‹FreshRemoteResponse policy policyDigest challengeDigest target now
      consumed challenge response›
    rcases hFresh with ⟨_, _, _, _, _, _, _, _, _, _, _, _, hVoteBound⟩
    have hVote : vote = responseAsFaultDomainVote response := by simp_all
    simpa [hVote] using hVoteBound
  · simp_all

end TMI.DigitalLifeRemoteWitnessChallenge
