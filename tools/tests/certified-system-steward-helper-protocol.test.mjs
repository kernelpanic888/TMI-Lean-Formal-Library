import assert from "node:assert/strict";
import {
  NonceLedger,
  createReceipt,
  createRequest,
  digestCanonical,
  verifyAndConsume,
  verifyTransition,
} from "../certified-system-steward-helper-protocol.mjs";

const sha = (character) => character.repeat(64);
const helperCodeRequirement = 'anchor apple generic and identifier "chatgpt.site.css.helper"';
const expected = Object.freeze({
  helperCodeRequirement,
  policyDigest: sha("a"),
  providerId: "macos-openat-quarantine-v2",
});
const channel = Object.freeze({
  transport: "xpc",
  peerEuid: 0,
  peerCodeRequirementMatched: true,
  peerCodeRequirement: helperCodeRequirement,
});

function request(overrides = {}) {
  return createRequest({
    epoch: 51,
    target: "/Users/test/project/node_modules",
    expectedIdentity: { dev: "16777234", ino: "90210" },
    policyDigest: expected.policyDigest,
    protectedBefore: sha("b"),
    clientUid: 501,
    clientCodeRequirement: 'anchor apple generic and identifier "chatgpt.site.css.client"',
    nonce: "0123456789abcdef0123456789abcdef",
    ...overrides,
  });
}

function receipt(req, overrides = {}) {
  return createReceipt({
    requestDigest: digestCanonical(req),
    actor: "launchd-root-helper",
    providerId: expected.providerId,
    actualIdentity: req.expectedIdentity,
    quarantineIdentity: req.expectedIdentity,
    protectedAfter: req.protectedBefore,
    quarantined: true,
    removed: true,
    sourceReappeared: false,
    accepted: true,
    ...overrides,
  });
}

const cases = [];
function test(name, run) {
  cases.push({ name, run });
}

test("accepts one OS-authenticated helper transition", () => {
  const req = request();
  assert.deepEqual(verifyTransition({ request: req, receipt: receipt(req), channel, expected }), {
    ok: true,
    errors: [],
  });
});

test("rejects a same-uid peer even when its JSON claims root", () => {
  const req = request();
  const result = verifyTransition({
    request: req,
    receipt: receipt(req, { peerEuid: 0 }),
    channel: { ...channel, peerEuid: 501 },
    expected,
  });
  assert.equal(result.ok, false);
  assert(result.errors.includes("channel-peer-euid"));
});

test("rejects an unverified code identity", () => {
  const req = request();
  const result = verifyTransition({
    request: req,
    receipt: receipt(req),
    channel: { ...channel, peerCodeRequirementMatched: false },
    expected,
  });
  assert.equal(result.ok, false);
  assert(result.errors.includes("channel-peer-code-requirement"));
});

test("rejects mutation after the request digest was committed", () => {
  const original = request();
  const mutated = { ...original, target: "/Users/test/other/node_modules" };
  const result = verifyTransition({
    request: mutated,
    receipt: receipt(original),
    channel,
    expected,
  });
  assert.equal(result.ok, false);
  assert(result.errors.includes("receipt-request-digest"));
});

test("rejects target identity substitution", () => {
  const req = request();
  const result = verifyTransition({
    request: req,
    receipt: receipt(req, { actualIdentity: { dev: "16777234", ino: "90211" } }),
    channel,
    expected,
  });
  assert.equal(result.ok, false);
  assert(result.errors.includes("actual-identity"));
});

test("rejects protected-state drift", () => {
  const req = request();
  const result = verifyTransition({
    request: req,
    receipt: receipt(req, { protectedAfter: sha("c") }),
    channel,
    expected,
  });
  assert.equal(result.ok, false);
  assert(result.errors.includes("protected-state"));
});

test("rejects public-name reappearance", () => {
  const req = request();
  const result = verifyTransition({
    request: req,
    receipt: receipt(req, { sourceReappeared: true }),
    channel,
    expected,
  });
  assert.equal(result.ok, false);
  assert(result.errors.includes("source-reappeared"));
});

test("rejects a policy selected outside the expected passport", () => {
  const req = request({ policyDigest: sha("d") });
  const result = verifyTransition({ request: req, receipt: receipt(req), channel, expected });
  assert.equal(result.ok, false);
  assert(result.errors.includes("expected-policy-digest"));
});

test("consumes a nonce once and rejects replay", () => {
  const req = request();
  const ledger = new NonceLedger();
  const first = verifyAndConsume({ request: req, receipt: receipt(req), channel, expected, ledger });
  const second = verifyAndConsume({ request: req, receipt: receipt(req), channel, expected, ledger });
  assert.equal(first.ok, true);
  assert.equal(second.ok, false);
  assert(second.errors.includes("replay"));
});

let passed = 0;
for (const item of cases) {
  try {
    item.run();
    passed += 1;
    process.stdout.write(`PASS  ${item.name}\n`);
  } catch (error) {
    process.stderr.write(`FAIL  ${item.name}\n${error.stack}\n`);
    process.exitCode = 1;
  }
}
process.stdout.write(`RESULT  ${passed}/${cases.length} PASS\n`);
