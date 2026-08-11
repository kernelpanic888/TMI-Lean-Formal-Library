import TMI.DigitalLifeValidationCapability

/-! Kernel-facing audit surface for the capability-isolated validator. -/

open TMI.DigitalLifeValidationCapability

#check capabilityLearningCycle
#check runtime_receipt_bound
#check runtime_hides_holdout_behind_manifest

#print axioms runtime_receipt_bound
#print axioms runtime_hides_holdout_behind_manifest
#print axioms capability_demo_accepts
#print axioms adversarial_validator_holds
#print axioms wrong_validator_root_holds
#print axioms wrong_manifest_root_holds
#print axioms stale_receipt_rejected
