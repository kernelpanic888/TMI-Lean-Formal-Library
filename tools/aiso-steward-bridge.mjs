import { selectBest } from "./aiso-control-loop.mjs";
import {
  bindAisoSelection,
  hashValue,
  RECEIPT_PROTOCOL,
  StewardError,
  validateAisoSelection,
} from "./certified-system-steward.mjs";

export function selectForSteward({
  state,
  candidates,
  weights,
  riskBound,
  noOp,
  passport,
  observation,
  field,
}) {
  const decision = selectBest({ state, candidates, weights, riskBound, noOp });
  if (decision.kind === "hold") {
    return Object.freeze({ kind: "hold", decision, selection: null });
  }
  const action = decision.action.stewardAction;
  if (!action) throw new StewardError("AISO candidate has no CSS action refinement.", "AISO_REFINEMENT_MISSING");
  const selection = bindAisoSelection(passport, observation, field, action, decision.score);
  validateAisoSelection(passport, observation, field, selection);
  return Object.freeze({ kind: "act", decision, selection });
}

export function verifyReceiptForLearning({ selection, receipt, verification }) {
  if (!selection) throw new StewardError("Learning requires an AISO selection.", "LEARNING_SELECTION_MISSING");
  if (receipt?.protocol !== RECEIPT_PROTOCOL) {
    throw new StewardError("Learning requires a CSS runtime receipt.", "LEARNING_RECEIPT_INVALID");
  }
  if (hashValue(receipt.payload) !== receipt.next?.digest) {
    throw new StewardError("Receipt digest does not bind its payload.", "LEARNING_RECEIPT_DIGEST");
  }
  if (
    receipt.payload.selectionHash !== selection.selectionHash
    || receipt.payload.passportId !== selection.passportId
    || receipt.payload.policyHash !== selection.policyHash
    || receipt.payload.actionId !== selection.action.actionId
    || receipt.payload.before?.targetSnapshot !== selection.observation.targetSnapshot
    || receipt.payload.before?.protectedRoot !== selection.observation.protectedRoot
  ) {
    throw new StewardError("Receipt is not bound to the selected transition.", "LEARNING_BINDING_MISMATCH");
  }
  if (verification?.status !== "PASS" || verification.head !== receipt.next.digest) {
    throw new StewardError("Independent receipt verification did not pass.", "LEARNING_VERIFICATION_FAILED");
  }
  return Object.freeze({
    selectionHash: selection.selectionHash,
    receiptHead: receipt.next.digest,
    epoch: receipt.next.epoch,
  });
}

export function learnFromCertifiedReceipt({ model, selection, receipt, verification, learn }) {
  const evidence = verifyReceiptForLearning({ selection, receipt, verification });
  const nextModel = learn(model, {
    action: selection.action,
    score: selection.score,
    receipt,
    evidence,
  });
  return Object.freeze({ model: nextModel, evidence });
}

