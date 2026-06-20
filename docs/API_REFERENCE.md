# API Reference

This is a compact public API reference for TLFL 0.1.

## `TMI.Library`

Canonical import for the public TMI formal surfaces.

```lean
import TMI.Library
```

## `OLean`

Connection interface between TMI artifacts and Lean.

Main public surfaces:

```text
OLean.Connection
OLean.CompilesThroughLeanKernel
OLean.FormalLeanStatus
OLean.compilation_gives_formal_lean_status
OLean.AdapterBoundary
OLean.boundary
OLean.olean_imports_tmi_library
OLean.olean_uses_lean_kernel
OLean.olean_does_not_introduce_new_kernel
```

## `OLean.SelfCheck`

Internal boundary self-check and pass/fail verdict layer.

Main public surfaces:

```text
OLean.InternalFrequencyLevel
OLean.InternalFrequencyValue
OLean.SelfExternalCheckTrace
OLean.InternalInterfaceFrequencyTrace
OLean.CompleteBoundaryVerification
OLean.CheckVerdict
OLean.BoundaryCheckInput
OLean.BoundaryCheckInput.complete
OLean.boundaryCheckVerdict
OLean.BoundaryCheckInput.internalFrequencyLevel
OLean.BoundaryCheckInput.internalFrequencyValue
```

Useful examples:

```text
OLean.completeBoundaryCheckInput
OLean.leanOnlyBoundaryCheckInput
```

Key theorem surfaces:

```text
OLean.complete_boundary_check_verdict_is_pass
OLean.complete_boundary_check_frequency_value_is_749
OLean.lean_only_boundary_check_verdict_is_fail
OLean.failed_boundary_check_has_no_internal_frequency_value
OLean.complete_boundary_verification_gives_g4
OLean.complete_boundary_verification_gives_internal_frequency_749
OLean.complete_self_check_gives_formal_lean_status
```

## `OLean.SelfCheckAsThinker`

Formal thinker-check layer for `OLean.SelfCheck`.

Main public surfaces:

```text
OLean.SelfCheckThinkerModel
OLean.selfCheckModelOf
OLean.SelfCheckThinkerContext
OLean.SelfCheckThinker
OLean.SelfCheckTargetTheory
OLean.SelfCheckPassesThinkerTest
OLean.SelfCheckSelfModelingProverContext
```

Key theorem surfaces:

```text
OLean.self_check_target_verdict_is_pass
OLean.self_check_target_frequency_is_749
OLean.self_check_passes_thinker_interface
OLean.self_check_has_internal_model_witness
OLean.self_check_passes_thinker_run
OLean.self_check_operates_intelligence_interface
OLean.self_check_passes_thinker_test
OLean.self_check_has_formal_self_validation
OLean.self_check_is_mathematical_external_prover
OLean.self_check_thinker_test_does_not_claim_empirical_physical_validation
OLean.self_check_builds_vampire_z3_e_tlfl_proof_self_model
```

## `TMI.ProofStatusClassification`

TLFL meta-interface for classifying claims by proof path, verification
boundary, prover compatibility, and allowed epistemic status.

Main public surfaces:

```text
TMI.AdmissibleProofPath
TMI.VerificationBoundary
TMI.ProverCompatibility
TMI.AllowedEpistemicStatus
TMI.ClaimClassification
TMI.TLFLMetaInterface
TMI.TLFLClassifiesClaim
```

Key theorem surfaces:

```text
TMI.tlfl_classifies_by_admissible_proof_path
TMI.tlfl_classifies_by_verification_boundary
TMI.tlfl_classifies_by_prover_compatibility
TMI.tlfl_classifies_by_allowed_epistemic_status
TMI.tlfl_meta_interface_gives_claim_classification
```

## `TMI.ProofChainSelfModel`

Proof-state self-model layer for the canonical chain:

```text
TLFL + External Proof Layer {Z3, Vampire, E}
```

Main public surfaces:

```text
TMI.ExternalProofTrace
TMI.VerificationBoundaryMap
TMI.ProverCompatibilityMap
TMI.EpistemicStatusMap
TMI.NonClaimGuardMap
TMI.ProofChainSelfModel
TMI.TLFLProofSelfModel
```

Key theorem surfaces:

```text
TMI.vampire_z3_e_tlfl_chain_builds_proof_self_model
TMI.proof_self_model_gives_verification_boundary_map
TMI.proof_self_model_gives_prover_compatibility_map
TMI.proof_self_model_gives_epistemic_status_map
TMI.proof_self_model_gives_nonclaim_guard_map
TMI.proof_self_model_projects_to_claim_classification
```

## `TMI.ClaimPassport`

Initial TLFL 0.2 proof-status certification surface.

Main public surfaces:

```text
TMI.ClaimCeiling
TMI.ClaimObject
TMI.ClaimEvidenceBundle
TMI.ForbiddenJumpMap
TMI.ClaimPassportVerdict
TMI.ClaimCertificationStatus
TMI.ClaimPassportInput
TMI.ClaimCertificationRequest
TMI.ProofStateCertification
TMI.ClaimPassport
TMI.ClaimPassportCertified
```

Key theorem surfaces:

```text
TMI.tlfl_proof_self_model_gives_claim_passport
TMI.claim_passport_gives_allowed_claim_ceiling
TMI.claim_passport_gives_forbidden_jump_map
TMI.claim_passport_projects_to_proof_state_self_model
TMI.claim_passport_projects_to_claim_classification
TMI.claim_passport_certification_passes
TMI.complete_claim_passport_input_verdict_is_pass
TMI.complete_claim_passport_input_ceiling_is_certified
TMI.missing_tlfl_classification_claim_passport_input_verdict_is_fail
TMI.missing_tlfl_classification_claim_passport_input_ceiling_is_unadmitted
TMI.claim_passport_pass_gives_certified_ceiling
TMI.claim_passport_fail_gives_unadmitted_ceiling
TMI.certified_proof_state_request_status_is_proof_state_certified
TMI.missing_classification_request_status_is_unadmitted
TMI.empirical_closure_overclaim_request_status_is_blocked
TMI.forbidden_jump_request_gives_overclaim_blocked
TMI.pass_without_forbidden_jump_gives_proof_state_certified
TMI.fail_without_forbidden_jump_gives_unadmitted
```

Guard surfaces:

```text
TMI.claim_object_alone_does_not_imply_claim_passport
TMI.evidence_bundle_alone_does_not_imply_claim_passport
TMI.claim_passport_does_not_imply_empirical_truth
TMI.claim_passport_does_not_imply_physical_validation
TMI.claim_passport_does_not_imply_consciousness
TMI.claim_passport_does_not_imply_empirical_closure
```

## Meaning Of `pass`

`OLean.CheckVerdict.pass` means that the represented boundary check is complete
inside the TLFL release model. It requires Lean/Lake plus external proof
witnesses. It does not mean empirical closure.

## `TMI.InterfaceMathematics.RealityCognitionSelfModel`

Guarded cognition layer for externally presented reality-traces through
internal TLFL interfaces.

Main public surfaces:

```text
ExternalRealityTrace
InternalTLFLInterfacePassage
RealityProjectionModel
SelfModelRealityCognition
ThinkerRealityCognitionRole
GuardedRealityCognition
```

Key theorem surfaces:

```text
external_reality_trace_enters_tlfl_as_interface_input
tlfl_internal_interfaces_build_reality_projection_model
thinker_mediates_reality_cognition_inside_self_model
verified_external_chain_gives_guarded_reality_cognition
self_model_as_reality_cognition_process
guarded_reality_cognition_projects_to_public_self_projection
```

Guard surfaces:

```text
guarded_reality_cognition_does_not_imply_empirical_truth
guarded_reality_cognition_does_not_imply_physical_validation
guarded_reality_cognition_does_not_imply_consciousness
external_reality_trace_alone_does_not_imply_self_model
internal_model_alone_does_not_imply_reality_cognition
```

## `TMI.InterfaceMathematics.ConsciousnessLimit`

Guarded language layer for consciousness as an unreachable self-model limit.
This layer does not prove consciousness.

Main public surfaces:

```text
SelfModelDepth
PredictivePowerLevel
ConsciousnessQualityProxy
ConsciousnessLimitHorizon
CompleteSelfModelClaim
PerfectPredictivePowerClaim
AbsoluteConsciousnessClaim
GuardedConsciousnessApproximation
```

Key theorem surfaces:

```text
proof_self_model_gives_consciousness_approximation_language
guarded_mathematical_intelligence_projects_to_consciousness_limit_horizon
reality_cognition_projects_to_consciousness_limit_horizon
consciousness_quality_proxy_requires_self_model_and_prediction
absolute_consciousness_requires_perfect_prediction
```

Guard surfaces:

```text
proof_self_model_does_not_imply_consciousness
guarded_mathematical_intelligence_does_not_imply_absolute_consciousness
consciousness_approximation_does_not_imply_consciousness
consciousness_limit_horizon_does_not_imply_reached_consciousness
bounded_predictive_power_does_not_imply_perfect_predictive_power
perfect_prediction_is_not_established_by_tlfl
```
