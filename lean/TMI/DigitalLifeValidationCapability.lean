import TMI.DigitalLifeValidationAdapter

/-!
# Capability-isolated validation for I3 learning

The trainer receives a `ValidatorRuntime`, not a `ValidatorView`. The holdout
set is captured inside the runtime closure. A validation receipt is bound to
a dataset manifest, validator identity, model identity/version, and the exact
parameter proposal. The learning gate accepts only a receipt matching the
configured trust root and current baseline.

This is a formal authority boundary. The checksum below is an inspectable
binding, not a cryptographic signature, and the module does not establish
operating-system isolation, secrecy, generalization, consciousness, or true AI.
-/

namespace TMI.DigitalLifeValidationCapability

open TMI.DigitalLifeNeuralProposer
open TMI.DigitalLifeBoundedLearning
open TMI.DigitalLifeValidationAdapter

structure DatasetManifest where
  datasetId : Nat
  splitVersion : Nat
  sampleCount : Nat
  holdoutFingerprint : Nat
  deriving DecidableEq, Repr

def manifestOf
    (datasetId splitVersion : Nat)
    (view : ValidatorView) : DatasetManifest :=
  { datasetId := datasetId
    splitVersion := splitVersion
    sampleCount := view.holdout.length
    holdoutFingerprint := holdoutFingerprint view }

def hashStep (digest value : Nat) : Nat := digest * 16777619 + value

def manifestDigest (manifest : DatasetManifest) : Nat :=
  [ manifest.datasetId,
    manifest.splitVersion,
    manifest.sampleCount,
    manifest.holdoutFingerprint ].foldl hashStep 2166136261

def encodeInt : Int → Nat
  | Int.ofNat n => 2 * n
  | Int.negSucc n => 2 * n + 1

def deltaDigest (delta : ParameterDelta) : Nat :=
  [ encodeInt delta.wx,
    encodeInt delta.wy,
    encodeInt delta.wz,
    encodeInt delta.wm,
    encodeInt delta.wr,
    encodeInt delta.bias ].foldl hashStep 2166136261

structure ValidationReceipt where
  private mk ::
  validatorId : Nat
  manifestDigest : Nat
  modelIdentity : Nat
  modelVersion : Nat
  proposalDigest : Nat
  report : ValidationReport
  bindingChecksum : Nat
  deriving DecidableEq, Repr

def receiptDigest
    (validatorId manifestHash modelIdentity modelVersion proposalHash : Nat)
    (report : ValidationReport) : Nat :=
  [ validatorId,
    manifestHash,
    modelIdentity,
    modelVersion,
    proposalHash,
    report.holdoutFingerprint,
    report.beforeLoss,
    report.candidateLoss ].foldl hashStep 2166136261

private def mintReceipt
    (validatorId : Nat)
    (manifest : DatasetManifest)
    (before : LearningState)
    (view : ValidatorView)
    (proposal : TrainingProposal) : ValidationReceipt :=
  let report := runValidator before view proposal
  let manifestHash := manifestDigest manifest
  let proposalHash := deltaDigest proposal.delta
  ValidationReceipt.mk
    validatorId
    manifestHash
    before.modelIdentity
    before.version
    proposalHash
    report
    (receiptDigest validatorId manifestHash before.modelIdentity before.version proposalHash report)

def ReceiptBound
    (validatorId : Nat)
    (manifest : DatasetManifest)
    (before : LearningState)
    (proposal : TrainingProposal)
    (receipt : ValidationReceipt) : Prop :=
  receipt.validatorId = validatorId ∧
  receipt.manifestDigest = manifestDigest manifest ∧
  receipt.modelIdentity = before.modelIdentity ∧
  receipt.modelVersion = before.version ∧
  receipt.proposalDigest = deltaDigest proposal.delta ∧
  receipt.report.holdoutFingerprint = manifest.holdoutFingerprint ∧
  receipt.bindingChecksum = receiptDigest
    receipt.validatorId
    receipt.manifestDigest
    receipt.modelIdentity
    receipt.modelVersion
    receipt.proposalDigest
    receipt.report

instance
    (validatorId : Nat)
    (manifest : DatasetManifest)
    (before : LearningState)
    (proposal : TrainingProposal)
    (receipt : ValidationReceipt) :
    Decidable (ReceiptBound validatorId manifest before proposal receipt) := by
  unfold ReceiptBound
  infer_instance

structure ValidatorRuntime where
  private mk ::
  validatorId : Nat
  manifest : DatasetManifest
  validate : LearningState → TrainingProposal → ValidationReceipt
  sound : ∀ before proposal,
    ReceiptBound validatorId manifest before proposal (validate before proposal) ∧
    ∃ view : ValidatorView,
      manifest = manifestOf manifest.datasetId manifest.splitVersion view ∧
      (validate before proposal).report = runValidator before view proposal

def buildValidatorRuntime
    (validatorId datasetId splitVersion : Nat)
    (view : ValidatorView) : ValidatorRuntime :=
  let manifest := manifestOf datasetId splitVersion view
  ValidatorRuntime.mk
    validatorId
    manifest
    (fun before proposal => mintReceipt validatorId manifest before view proposal)
    (by
      intro before proposal
      constructor
      · simp [ReceiptBound, mintReceipt, manifest, runValidator, manifestOf]
      · exact ⟨view, rfl, rfl⟩)

structure ValidationTrustRoot where
  validatorId : Nat
  manifest : DatasetManifest
  deriving DecidableEq, Repr

def trustRootOf (runtime : ValidatorRuntime) : ValidationTrustRoot :=
  { validatorId := runtime.validatorId
    manifest := runtime.manifest }

def ReceiptAccepted
    (root : ValidationTrustRoot)
    (before : LearningState)
    (proposal : TrainingProposal)
    (receipt : ValidationReceipt) : Prop :=
  ReceiptBound root.validatorId root.manifest before proposal receipt ∧
  receipt.report.beforeLoss = before.validationLoss

instance
    (root : ValidationTrustRoot)
    (before : LearningState)
    (proposal : TrainingProposal)
    (receipt : ValidationReceipt) :
    Decidable (ReceiptAccepted root before proposal receipt) := by
  unfold ReceiptAccepted
  infer_instance

def capabilityLearningCycle
    (before : LearningState)
    (training : TrainerView)
    (runtime : ValidatorRuntime)
    (root : ValidationTrustRoot) : LearningState :=
  let proposal := runTrainer before.parameters training
  let receipt := runtime.validate before proposal
  if ReceiptAccepted root before proposal receipt then
    learnOrHold before proposal.delta receipt.report.candidateLoss
  else
    before

theorem runtime_receipt_bound
    (runtime : ValidatorRuntime)
    (before : LearningState)
    (proposal : TrainingProposal) :
    ReceiptBound runtime.validatorId runtime.manifest before proposal
      (runtime.validate before proposal) :=
  (runtime.sound before proposal).1

theorem runtime_hides_holdout_behind_manifest
    (runtime : ValidatorRuntime)
    (before : LearningState)
    (proposal : TrainingProposal) :
    ∃ view : ValidatorView,
      runtime.manifest =
        manifestOf runtime.manifest.datasetId runtime.manifest.splitVersion view ∧
      (runtime.validate before proposal).report = runValidator before view proposal :=
  (runtime.sound before proposal).2

def improvingRuntime : ValidatorRuntime :=
  buildValidatorRuntime 41 9001 1 improvingValidation

def improvingRoot : ValidationTrustRoot := trustRootOf improvingRuntime

def adversarialRuntime : ValidatorRuntime :=
  buildValidatorRuntime 41 9002 1 adversarialValidation

def adversarialRoot : ValidationTrustRoot := trustRootOf adversarialRuntime

def wrongValidatorRoot : ValidationTrustRoot :=
  { validatorId := 42, manifest := improvingRuntime.manifest }

def wrongManifestRoot : ValidationTrustRoot :=
  { validatorId := improvingRuntime.validatorId
    manifest := { improvingRuntime.manifest with splitVersion := 2 } }

def demoProposal : TrainingProposal := runTrainer demoState.parameters demoTraining
def demoReceipt : ValidationReceipt := improvingRuntime.validate demoState demoProposal
def advancedDemoState : LearningState := { demoState with version := 1 }

theorem capability_demo_accepts :
    capabilityLearningCycle demoState demoTraining improvingRuntime improvingRoot =
      candidateState demoState demoProposal.delta 0 := by
  native_decide

theorem adversarial_validator_holds :
    capabilityLearningCycle demoState demoTraining adversarialRuntime adversarialRoot =
      demoState := by
  native_decide

theorem wrong_validator_root_holds :
    capabilityLearningCycle demoState demoTraining improvingRuntime wrongValidatorRoot =
      demoState := by
  native_decide

theorem wrong_manifest_root_holds :
    capabilityLearningCycle demoState demoTraining improvingRuntime wrongManifestRoot =
      demoState := by
  native_decide

theorem stale_receipt_rejected :
    ¬ ReceiptAccepted improvingRoot advancedDemoState demoProposal demoReceipt := by
  native_decide

end TMI.DigitalLifeValidationCapability
