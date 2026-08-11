import test from "node:test";
import assert from "node:assert/strict";

import { admitted, execute } from "../agent-zero-validation-kernel.mjs";

const action = Object.freeze({ id: "X" });

function gate(bits) {
  return {
    selfValidate: (value) => (value === action ? bits[0] : 0),
    externalValidate: (value) => (value === action ? bits[1] : 0),
    safe: (value) => (value === action ? bits[2] : 0),
  };
}

for (let mask = 0; mask < 8; mask += 1) {
  const bits = [2, 1, 0].map((shift) => (mask >> shift) & 1);
  test(`Agent Zero ${bits.join("")} executes only for 111`, () => {
    const validators = gate(bits);
    const expected = mask === 7 ? action : null;
    assert.equal(admitted(action, validators), mask === 7 ? 1 : 0);
    assert.equal(execute(action, validators), expected);
  });
}

test("triple admission returns the same action object", () => {
  assert.equal(execute(action, gate([1, 1, 1])), action);
});

test("one failed predicate means no action", () => {
  assert.equal(execute(action, gate([1, 0, 1])), null);
});

test("a non-binary predicate result is rejected", () => {
  assert.throws(
    () => execute(action, { ...gate([1, 1, 1]), externalValidate: () => 2 }),
    /Vext must return 0 or 1/,
  );
});
