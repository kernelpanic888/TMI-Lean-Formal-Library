import test from "node:test";
import assert from "node:assert/strict";

import { hashValue, RECEIPT_PROTOCOL, validateAisoSelection } from "../certified-system-steward.mjs";
import {
  learnFromCertifiedReceipt,
  selectForSteward,
  verifyReceiptForLearning,
} from "../aiso-steward-bridge.mjs";

const passport = Object.freeze({ passportId: "fixture-passport", policyHash: "policy-01" });
const observation = Object.freeze({ targetSnapshot: "snapshot-01", protectedRoot: "root-01" });
const action = Object.freeze({ actionId: "cleanup-01", targets: ["cache/.lake"] });
const field = Object.freeze([action]);
const weights = Object.freeze({ alpha: 4, beta: 3, gamma: 2, lambda: 1 });

function candidate(overrides = {}) {
  return {
    id: "candidate-01",
    stewardAction: action,
    available: true,
    constrained: true,
    metrics: { improvement: 5, risk: 1, cost: 1, entropy: 1 },
    validated: true,
    permitted: true,
    safe: true,
    preservesInvariant: true,
    qualityAfter: 15,
    rollbackWitness: { id: "rollback-01" },
    ...overrides,
  };
}

function selectionResult() {
  return selectForSteward({
    state: { quality: 10 },
    candidates: [candidate()],
    weights,
    riskBound: 2,
    noOp: { id: "NO_OP" },
    passport,
    observation,
    field,
  });
}

function receiptFor(selection, overrides = {}) {
  const payload = {
    passportId: selection.passportId,
    policyHash: selection.policyHash,
    selectionHash: selection.selectionHash,
    actionId: selection.action.actionId,
    before: selection.observation,
    after: { protectedRoot: selection.observation.protectedRoot, targetSnapshot: "snapshot-02" },
    ...overrides,
  };
  return {
    protocol: RECEIPT_PROTOCOL,
    next: { epoch: 1, digest: hashValue(payload) },
    payload,
  };
}

test("AISO selection is bound to the current CSS observation and field", () => {
  const result = selectionResult();
  assert.equal(result.kind, "act");
  assert.deepEqual(validateAisoSelection(passport, observation, field, result.selection), action);
});

test("observation drift invalidates the selection before execution", () => {
  const { selection } = selectionResult();
  assert.throws(
    () => validateAisoSelection(passport, { ...observation, targetSnapshot: "drift" }, field, selection),
    { code: "AISO_BINDING_MISMATCH" },
  );
});

test("field drift invalidates the selection before execution", () => {
  const { selection } = selectionResult();
  assert.throws(
    () => validateAisoSelection(passport, observation, [{ ...action, targets: ["other"] }], selection),
    { code: "AISO_FIELD_MISMATCH" },
  );
});

test("an admissible-set hold never produces a CSS selection", () => {
  const result = selectForSteward({
    state: { quality: 10 },
    candidates: [candidate({ permitted: false })],
    weights,
    riskBound: 2,
    noOp: { id: "NO_OP" },
    passport,
    observation,
    field,
  });
  assert.equal(result.kind, "hold");
  assert.equal(result.selection, null);
});

test("a bound receipt and independent PASS unlock exactly one learning step", () => {
  const { selection } = selectionResult();
  const receipt = receiptFor(selection);
  const result = learnFromCertifiedReceipt({
    model: { learned: [] },
    selection,
    receipt,
    verification: { status: "PASS", head: receipt.next.digest },
    learn: (model, evidence) => ({ learned: [...model.learned, evidence.action.actionId] }),
  });
  assert.deepEqual(result.model.learned, ["cleanup-01"]);
  assert.equal(result.evidence.receiptHead, receipt.next.digest);
});

test("receipt action substitution blocks learning", () => {
  const { selection } = selectionResult();
  const receipt = receiptFor(selection, { actionId: "substituted-action" });
  assert.throws(
    () => verifyReceiptForLearning({ selection, receipt, verification: { status: "PASS", head: receipt.next.digest } }),
    { code: "LEARNING_BINDING_MISMATCH" },
  );
});

test("receipt payload mutation without a new digest blocks learning", () => {
  const { selection } = selectionResult();
  const receipt = receiptFor(selection);
  receipt.payload.after.targetSnapshot = "tampered";
  assert.throws(
    () => verifyReceiptForLearning({ selection, receipt, verification: { status: "PASS", head: receipt.next.digest } }),
    { code: "LEARNING_RECEIPT_DIGEST" },
  );
});

test("failed independent verification blocks learning", () => {
  const { selection } = selectionResult();
  const receipt = receiptFor(selection);
  assert.throws(
    () => verifyReceiptForLearning({ selection, receipt, verification: { status: "FAIL", head: receipt.next.digest } }),
    { code: "LEARNING_VERIFICATION_FAILED" },
  );
});

