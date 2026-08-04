import { createHash } from "node:crypto";

export const PROTOCOL_ID = "css-helper-v1";
export const XPC_TRANSPORT = "xpc";
export const ROOT_EUID = 0;

function canonical(value) {
  if (value === null || typeof value === "boolean" || typeof value === "string") {
    return JSON.stringify(value);
  }
  if (typeof value === "number" && Number.isFinite(value)) {
    return JSON.stringify(value);
  }
  if (Array.isArray(value)) {
    return `[${value.map(canonical).join(",")}]`;
  }
  if (value && typeof value === "object") {
    return `{${Object.keys(value)
      .sort()
      .map((key) => `${JSON.stringify(key)}:${canonical(value[key])}`)
      .join(",")}}`;
  }
  throw new TypeError("canonical payload contains an unsupported value");
}

export function digestCanonical(value) {
  return createHash("sha256").update(canonical(value)).digest("hex");
}

function isSha256(value) {
  return typeof value === "string" && /^[a-f0-9]{64}$/.test(value);
}

function isIdentity(value) {
  return Boolean(
    value &&
      typeof value === "object" &&
      typeof value.dev === "string" &&
      /^[0-9]+$/.test(value.dev) &&
      typeof value.ino === "string" &&
      /^[0-9]+$/.test(value.ino),
  );
}

function sameIdentity(left, right) {
  return isIdentity(left) && isIdentity(right) && left.dev === right.dev && left.ino === right.ino;
}

export function validateRequest(request) {
  const errors = [];
  if (!request || typeof request !== "object") errors.push("request-object");
  if (request?.protocol !== PROTOCOL_ID) errors.push("protocol");
  if (!Number.isSafeInteger(request?.epoch) || request.epoch < 0) errors.push("epoch");
  if (typeof request?.target !== "string" || !request.target.startsWith("/")) errors.push("target");
  if (!isIdentity(request?.expectedIdentity)) errors.push("expected-identity");
  if (!isSha256(request?.policyDigest)) errors.push("policy-digest");
  if (!isSha256(request?.protectedBefore)) errors.push("protected-before");
  if (!Number.isSafeInteger(request?.clientUid) || request.clientUid < 0) errors.push("client-uid");
  if (typeof request?.clientCodeRequirement !== "string" || request.clientCodeRequirement.length < 8) {
    errors.push("client-code-requirement");
  }
  if (typeof request?.nonce !== "string" || !/^[a-f0-9]{32,128}$/.test(request.nonce)) {
    errors.push("nonce");
  }
  return errors;
}

export function createRequest(input) {
  const request = Object.freeze({
    protocol: PROTOCOL_ID,
    epoch: input.epoch,
    target: input.target,
    expectedIdentity: Object.freeze({ ...input.expectedIdentity }),
    policyDigest: input.policyDigest,
    protectedBefore: input.protectedBefore,
    clientUid: input.clientUid,
    clientCodeRequirement: input.clientCodeRequirement,
    nonce: input.nonce,
  });
  const errors = validateRequest(request);
  if (errors.length) throw new TypeError(`invalid helper request: ${errors.join(", ")}`);
  return request;
}

export function createReceipt(input) {
  return Object.freeze({
    protocol: PROTOCOL_ID,
    requestDigest: input.requestDigest,
    actor: input.actor,
    providerId: input.providerId,
    actualIdentity: Object.freeze({ ...input.actualIdentity }),
    quarantineIdentity: Object.freeze({ ...input.quarantineIdentity }),
    protectedAfter: input.protectedAfter,
    quarantined: input.quarantined,
    removed: input.removed,
    sourceReappeared: input.sourceReappeared,
    accepted: input.accepted,
  });
}

function check(condition, label, errors) {
  if (!condition) errors.push(label);
}

/**
Trusted channel facts are a separate argument. A receipt cannot authenticate
itself by embedding `peerEuid` or a code-signing claim in its own JSON payload.
*/
export function verifyTransition({ request, receipt, channel, expected }) {
  const errors = validateRequest(request);
  check(channel?.transport === XPC_TRANSPORT, "channel-transport", errors);
  check(channel?.peerEuid === ROOT_EUID, "channel-peer-euid", errors);
  check(channel?.peerCodeRequirementMatched === true, "channel-peer-code-requirement", errors);
  check(
    channel?.peerCodeRequirement === expected?.helperCodeRequirement,
    "channel-helper-identity",
    errors,
  );
  check(request?.policyDigest === expected?.policyDigest, "expected-policy-digest", errors);
  check(receipt?.protocol === PROTOCOL_ID, "receipt-protocol", errors);
  check(receipt?.requestDigest === digestCanonical(request), "receipt-request-digest", errors);
  check(receipt?.actor === "launchd-root-helper", "receipt-actor", errors);
  check(receipt?.providerId === expected?.providerId, "receipt-provider", errors);
  check(sameIdentity(receipt?.actualIdentity, request?.expectedIdentity), "actual-identity", errors);
  check(
    sameIdentity(receipt?.quarantineIdentity, request?.expectedIdentity),
    "quarantine-identity",
    errors,
  );
  check(receipt?.protectedAfter === request?.protectedBefore, "protected-state", errors);
  check(receipt?.quarantined === true, "quarantined", errors);
  check(receipt?.removed === true, "removed", errors);
  check(receipt?.sourceReappeared === false, "source-reappeared", errors);
  check(receipt?.accepted === true, "accepted", errors);
  return Object.freeze({ ok: errors.length === 0, errors: Object.freeze(errors) });
}

export class NonceLedger {
  #seen = new Set();

  consume(request) {
    const key = `${request.clientUid}:${request.nonce}`;
    if (this.#seen.has(key)) return false;
    this.#seen.add(key);
    return true;
  }
}

export function verifyAndConsume({ request, receipt, channel, expected, ledger }) {
  const verified = verifyTransition({ request, receipt, channel, expected });
  if (!verified.ok) return verified;
  if (!(ledger instanceof NonceLedger)) {
    return Object.freeze({ ok: false, errors: Object.freeze(["nonce-ledger"]) });
  }
  if (!ledger.consume(request)) {
    return Object.freeze({ ok: false, errors: Object.freeze(["replay"] ) });
  }
  return verified;
}
