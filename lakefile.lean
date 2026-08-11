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
    `TMI.ActivationRelicTwoAxisTime,
    `TMI.ActivationRelicTwoAxisTimeAudit,
    `TMI.DigitalLifeTwoAxisTick,
    `TMI.DigitalLifeTwoAxisTickAudit,
    `TMI.DigitalLifeRuntimeAdapter,
    `TMI.DigitalLifeRuntimeAdapterAudit,
    `TMI.DigitalLifeNeuralProposer,
    `TMI.DigitalLifeNeuralProposerAudit,
    `TMI.DigitalLifeBoundedLearning,
    `TMI.DigitalLifeBoundedLearningAudit,
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
