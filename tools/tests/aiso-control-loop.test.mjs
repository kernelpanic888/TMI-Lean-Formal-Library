import test from "node:test";
import assert from "node:assert/strict";

import {
  executeDecision,
  selectBest,
  weightedObjective,
} from "../aiso-control-loop.mjs";

const weights = Object.freeze({ alpha: 4, beta: 3, gamma: 2, lambda: 1 });
const state = Object.freeze({ quality: 10, value: 10 });

function candidate(id, overrides = {}) {
  return {
    id,
    available: true,
    constrained: true,
    metrics: { improvement: 4, risk: 1, cost: 1, entropy: 1 },
    validated: true,
    permitted: true,
    safe: true,
    preservesInvariant: true,
    qualityAfter: 14,
    rollbackWitness: { id: `rollback-${id}` },
    ...overrides,
  };
}

test("objective follows alpha improvement minus weighted penalties", () => {
  assert.equal(weightedObjective(weights, candidate("a").metrics), 10);
});

test("selects the objective maximum only inside the admissible set", () => {
  const decision = selectBest({
    state,
    weights,
    riskBound: 3,
    candidates: [candidate("low"), candidate("high", { metrics: { improvement: 8, risk: 1, cost: 1, entropy: 1 }, qualityAfter: 18 })],
  });
  assert.equal(decision.kind, "act");
  assert.equal(decision.action.id, "high");
});

test("rejects risk above rho", () => {
  const decision = selectBest({ state, weights, riskBound: 3, candidates: [candidate("risk", { metrics: { improvement: 99, risk: 4, cost: 0, entropy: 0 } })] });
  assert.equal(decision.kind, "hold");
});

test("rejects failed validation", () => {
  assert.equal(selectBest({ state, weights, riskBound: 3, candidates: [candidate("v", { validated: false })] }).kind, "hold");
});

test("rejects an unauthorized action", () => {
  assert.equal(selectBest({ state, weights, riskBound: 3, candidates: [candidate("p", { permitted: false })] }).kind, "hold");
});

test("rejects an unsafe or invariant-breaking action", () => {
  const decision = selectBest({ state, weights, riskBound: 3, candidates: [candidate("unsafe", { safe: false }), candidate("invariant", { preservesInvariant: false })] });
  assert.equal(decision.kind, "hold");
});

test("rejects an action without rollback evidence", () => {
  assert.equal(selectBest({ state, weights, riskBound: 3, candidates: [candidate("r", { rollbackWitness: null })] }).kind, "hold");
});

test("empty admissible set deterministically selects NO_OP", () => {
  const decision = selectBest({ state, weights, riskBound: 3, candidates: [] });
  assert.deepEqual({ kind: decision.kind, id: decision.action.id }, { kind: "hold", id: "NO_OP" });
});

test("equal objective uses a deterministic action-id tie break", () => {
  const decision = selectBest({ state, weights, riskBound: 3, candidates: [candidate("beta"), candidate("alpha")] });
  assert.equal(decision.action.id, "alpha");
});

const runtime = {
  apply: (before, action) => ({ quality: action.qualityAfter, value: action.qualityAfter }),
  quality: (current) => current.quality,
  invariantsHold: () => true,
  rollback: (_next, _witness, before) => before,
  makeReceipt: (before, action, next) => ({ from: before.value, action: action.id, to: next.value }),
  learn: (model, _before, action) => ({ ...model, learned: [...model.learned, action.id] }),
};

test("failed post-verification rolls back and cannot learn", () => {
  const decision = selectBest({ state, weights, riskBound: 3, candidates: [candidate("change")] });
  const result = executeDecision({ ...runtime, state, model: { learned: [] }, decision, postVerify: () => false });
  assert.equal(result.kind, "rolled-back");
  assert.equal(result.learned, false);
  assert.deepEqual(result.state, state);
  assert.deepEqual(result.model.learned, []);
});

test("verified improvement commits a receipt before learning", () => {
  const decision = selectBest({ state, weights, riskBound: 3, candidates: [candidate("change")] });
  const result = executeDecision({ ...runtime, state, model: { learned: [] }, decision, postVerify: () => true });
  assert.equal(result.kind, "committed");
  assert.equal(result.learned, true);
  assert.deepEqual(result.receipt, { from: 10, action: "change", to: 14 });
  assert.deepEqual(result.model.learned, ["change"]);
});

