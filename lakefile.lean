import Lake
open Lake DSL

package tmi_lean_formal_library_0_1 where
  -- TMI-Lean Formal Library is a standalone Lean 4 package.
  -- The public OLean adapter is compiled by the Lean kernel through Lake.
  weakLeanArgs := #["-j", "1"]

lean_lib LayerBridge where
  srcDir := "lean"
  roots := #[`LayerBridge]

lean_lib TMI where
  srcDir := "lean"
  roots := #[
    `TMI.Core,
    `TMI.PicT,
    `TMI.FormulaInterface,
    `TMI.BoundaryEvent,
    `TMI.ImportBoundary,
    `TMI.BridgePhysics,
    `TMI.Bridge,
    `TMI.ExternalProverBoundary,
    `TMI.ProofStatusClassification,
    `TMI.ProofChainSelfModel,
    `TMI.ClaimPassport,
    `TMI.WrapperTop,
    `TMI.TruthChain,
    `TMI.CollectiveIntelligence,
    `TMI.IESTA,
    `TMI.SelfThinkingUniverse,
    `TMI.InterfaceMathematics,
    `TMI.InterfaceFoundationsAlpha,
    `TMI.InterfaceFoundationsV051Alpha,
    `TMI.InterfaceFoundationsV052Alpha,
    `TMI.SpinorOntology,
    `TMI.InvariantTransportClosure,
    `TMI.InvariantTransportClosureAudit,
    `TMI.ActivationRelicTwoAxisTime,
    `TMI.ActivationRelicTwoAxisTimeAudit,
    `TMI.InterfaceFoundations.RelativeTemporalInterface,
    `TMI.InterfaceFoundations.RelativeTemporalInterfaceAudit,
    `TMI.InterfaceFoundations.QuantumComparisonBoundary,
    `TMI.InterfaceFoundations.QuantumComparisonBoundaryAudit,
    `TMI.InterfaceFoundations.SampledHypergraphImpulse,
    `TMI.InterfaceFoundations.SampledHypergraphImpulseAudit,
    `TMI.DigitalLifeTwoAxisTick,
    `TMI.DigitalLifeTwoAxisTickAudit,
    `TMI.DigitalLifeRuntimeAdapter,
    `TMI.DigitalLifeRuntimeAdapterAudit,
    `TMI.DigitalLifeNeuralProposer,
    `TMI.DigitalLifeNeuralProposerAudit,
    `TMI.DigitalLifeBoundedLearning,
    `TMI.DigitalLifeBoundedLearningAudit,
    `TMI.DigitalLifeCertifiedLearningLoop,
    `TMI.DigitalLifeCertifiedLearningLoopAudit,
    `TMI.DigitalLifeValidationAdapter,
    `TMI.DigitalLifeValidationAdapterAudit,
    `TMI.DigitalLifeValidationCapability,
    `TMI.DigitalLifeValidationCapabilityAudit,
    `TMI.DigitalLifeValidationWire,
    `TMI.DigitalLifeValidationWireAudit,
    `TMI.DigitalLifeValidationWireRuntime,
    `TMI.DigitalLifePersistentTrust,
    `TMI.DigitalLifePersistentTrustAudit,
    `TMI.DigitalLifePersistentTrustRuntime,
    `TMI.DigitalLifeAtomicTrustStore,
    `TMI.DigitalLifeAtomicTrustStoreAudit,
    `TMI.DigitalLifeAtomicTrustStoreRuntime,
    `TMI.DigitalLifeExternalRollbackWitness,
    `TMI.DigitalLifeExternalRollbackWitnessAudit,
    `TMI.DigitalLifeExternalRollbackWitnessRuntime,
    `TMI.DigitalLifeProcessIsolation,
    `TMI.DigitalLifeProcessIsolationAudit,
    `TMI.DigitalLifeProcessIsolationRuntime,
    `TMI.DigitalLifeWitnessQuorum,
    `TMI.DigitalLifeWitnessQuorumAudit,
    `TMI.DigitalLifeWitnessQuorumRuntime,
    `TMI.DigitalLifeFaultDomainQuorum,
    `TMI.DigitalLifeFaultDomainQuorumAudit,
    `TMI.DigitalLifeFaultDomainQuorumRuntime,
    `TMI.DigitalLifeRemoteWitnessChallenge,
    `TMI.DigitalLifeRemoteWitnessChallengeAudit,
    `TMI.DigitalLifeRemoteWitnessChallengeRuntime,
    `TMI.DigitalLifeTransportAttestation,
    `TMI.DigitalLifeTransportAttestationAudit,
    `TMI.DigitalLifeTransportAttestationRuntime,
    `TMI.DigitalLifeHardwareAttestation,
    `TMI.DigitalLifeHardwareAttestationAudit,
    `TMI.DigitalLifeHardwareAttestationRuntime,
    `TMI.DigitalLifePhysicalHardwareChallenge,
    `TMI.DigitalLifePhysicalHardwareChallengeAudit,
    `TMI.DigitalLifePhysicalHardwareChallengeRuntime,
    `TMI.DigitalLifeTrustedPlatformEnrollment,
    `TMI.DigitalLifeTrustedPlatformEnrollmentAudit,
    `TMI.DigitalLifeTrustedPlatformEnrollmentRuntime,
    `TMI.DigitalLifeIndependentHardwareAdmission,
    `TMI.DigitalLifeIndependentHardwareAdmissionRuntime,
    `TMI.DigitalLifeCertifiedCognitiveAct,
    `TMI.DigitalLifeCertifiedCognitiveActRuntime,
    `TMI.Branches,
    `TMI.Library
  ]

lean_exe i3_trainer where
  srcDir := "lean"
  root := `TMI.DigitalLifeTrainerMain

lean_exe i3_validator where
  srcDir := "lean"
  root := `TMI.DigitalLifeValidatorMain

lean_exe i3_trust where
  srcDir := "lean"
  root := `TMI.DigitalLifeTrustMain

lean_exe i3_trust_tx where
  srcDir := "lean"
  root := `TMI.DigitalLifeAtomicTrustMain

lean_exe i3_witness where
  srcDir := "lean"
  root := `TMI.DigitalLifeWitnessMain

lean_exe i3_isolation where
  srcDir := "lean"
  root := `TMI.DigitalLifeIsolationMain

lean_exe i3_quorum where
  srcDir := "lean"
  root := `TMI.DigitalLifeQuorumMain

lean_exe i3_domain_quorum where
  srcDir := "lean"
  root := `TMI.DigitalLifeFaultDomainQuorumMain

lean_exe i3_remote_witness where
  srcDir := "lean"
  root := `TMI.DigitalLifeRemoteWitnessChallengeMain

lean_exe i3_attestation where
  srcDir := "lean"
  root := `TMI.DigitalLifeTransportAttestationMain

lean_exe i3_hardware where
  srcDir := "lean"
  root := `TMI.DigitalLifeHardwareAttestationMain

lean_exe i3_physical where
  srcDir := "lean"
  root := `TMI.DigitalLifePhysicalHardwareChallengeMain

lean_exe i3_enrollment where
  srcDir := "lean"
  root := `TMI.DigitalLifeTrustedPlatformEnrollmentMain

lean_exe i3_remote_hardware where
  srcDir := "lean"
  root := `TMI.DigitalLifeIndependentHardwareAdmissionMain

lean_exe i3_cognitive_act where
  srcDir := "lean"
  root := `TMI.DigitalLifeCertifiedCognitiveActMain

lean_exe i3_learning_loop where
  srcDir := "lean"
  root := `TMI.DigitalLifeCertifiedLearningLoopMain

lean_lib OLean where
  srcDir := "lean"
  roots := #[
    `OLean,
    `OLean.Smoke,
    `OLean.SelfCheck,
    `OLean.SelfCheckAsThinker,
    `OLean.AdmittedProofProjection,
    `OLean.TLFLSelfModelProof
  ]
