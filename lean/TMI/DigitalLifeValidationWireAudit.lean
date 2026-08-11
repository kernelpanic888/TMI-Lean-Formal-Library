import TMI.DigitalLifeValidationWire

/-! Audit specimens for the sample-free signed validation wire. -/

namespace TMI.DigitalLifeValidationWireAudit

open TMI.DigitalLifeValidationCapability
open TMI.DigitalLifeValidationWire

def auditRequest : WireRequest := demoWireRequest 101 "manifest-a"

def auditRoot : WireTrustRoot :=
  { validatorId := 41, manifestDigest := "manifest-a" }

def auditReceipt : WireReceiptBody :=
  { protocolVersion := wireProtocolVersion
    requestId := auditRequest.requestId
    requestDigest := "request-a"
    validatorId := auditRoot.validatorId
    manifestDigest := auditRoot.manifestDigest
    modelIdentity := auditRequest.modelIdentity
    modelVersion := auditRequest.modelVersion
    proposalDigest := deltaDigest auditRequest.delta
    beforeLoss := auditRequest.baselineLoss
    candidateLoss := 0 }

def replayRequest : WireRequest := { auditRequest with requestId := 102 }
def worseReceipt : WireReceiptBody := { auditReceipt with candidateLoss := 2 }

theorem valid_signed_receipt_admits :
    wireLearnOrHold auditRoot auditRequest "request-a" auditReceipt true =
      TMI.DigitalLifeBoundedLearning.candidateState
        (requestState auditRequest) auditRequest.delta 0 := by
  native_decide

theorem unsigned_receipt_holds :
    wireLearnOrHold auditRoot auditRequest "request-a" auditReceipt false =
      requestState auditRequest := by
  native_decide

theorem tampered_request_digest_holds :
    wireLearnOrHold auditRoot auditRequest "request-tampered" auditReceipt true =
      requestState auditRequest := by
  native_decide

theorem replayed_receipt_holds :
    wireLearnOrHold auditRoot replayRequest "request-b" auditReceipt true =
      requestState replayRequest := by
  native_decide

theorem worse_holdout_loss_holds :
    wireLearnOrHold auditRoot auditRequest "request-a" worseReceipt true =
      requestState auditRequest := by
  native_decide

theorem request_round_trip : parseRequest (encodeRequest auditRequest) = some auditRequest := by
  native_decide

theorem receipt_round_trip : parseReceipt (encodeReceipt auditReceipt) = some auditReceipt := by
  native_decide

#print axioms TMI.DigitalLifeValidationWire.admissible_requires_signature
#print axioms TMI.DigitalLifeValidationWire.admissible_requires_request_binding

end TMI.DigitalLifeValidationWireAudit
