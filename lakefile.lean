import Lake
open Lake DSL

package tmi_lean_formal_library_0_1 where
  -- TMI-Lean Formal Library 0.1 is a standalone Lean 4 package.
  -- The public OLean adapter is compiled by the Lean kernel through Lake.
  weakLeanArgs := #["-j", "1"]

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
    `TMI.Branches,
    `TMI.Library
  ]

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
