import test from "node:test";
import assert from "node:assert/strict";

import { closed, execute } from "../aiso-validation-kernel.mjs";

const stateA = Object.freeze({ id: "SA" });
const stateB = Object.freeze({ id: "SB" });
const act = Object.freeze({ stateA, stateB });

function interfaceGate(bits) {
  return {
    validateA: (value) => (value === stateA ? bits[0] : 0),
    validateB: (value) => (value === stateB ? bits[1] : 0),
    compatible: (left, right) => (left === stateA && right === stateB ? bits[2] : 0),
  };
}

for (let mask = 0; mask < 8; mask += 1) {
  const bits = [2, 1, 0].map((shift) => (mask >> shift) & 1);
  test(`closure ${bits.join("")} yields an act only for 111`, () => {
    const gate = interfaceGate(bits);
    const expected = mask === 7 ? act : null;
    assert.equal(closed(act, gate), mask === 7 ? 1 : 0);
    assert.equal(execute(act, gate), expected);
  });
}

test("triple agreement returns the unchanged candidate act", () => {
  assert.equal(execute(act, interfaceGate([1, 1, 1])), act);
});

test("one failed compatibility predicate means silence", () => {
  assert.equal(execute(act, interfaceGate([1, 1, 0])), null);
});

test("a non-binary predicate result is rejected", () => {
  assert.throws(
    () => execute(act, { ...interfaceGate([1, 1, 1]), compatible: () => 2 }),
    /CI must return 0 or 1/,
  );
});
