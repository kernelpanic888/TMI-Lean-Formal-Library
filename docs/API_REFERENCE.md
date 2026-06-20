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
Vampire/Z3/E/TLFL
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

## Meaning Of `pass`

`OLean.CheckVerdict.pass` means that the represented boundary check is complete
inside the TLFL release model. It requires Lean/Lake plus external proof
witnesses. It does not mean empirical closure.
