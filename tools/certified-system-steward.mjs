import { createHash } from "node:crypto";
import { execFile, spawn } from "node:child_process";
import { promisify } from "node:util";
import { fileURLToPath } from "node:url";
import fs from "node:fs";
import fsp from "node:fs/promises";
import os from "node:os";
import path from "node:path";

const execFileAsync = promisify(execFile);
const ZERO_HEAD = "0".repeat(64);
const RECEIPT_PROTOCOL = "CSS-RUNTIME-RECEIPT-v1";
const WITNESS_PROTOCOL = "SCCP-COMPACT-WITNESS-v1";

export class StewardError extends Error {
  constructor(message, code = "STEWARD_BLOCKED") {
    super(message);
    this.name = "StewardError";
    this.code = code;
  }
}

function canonical(value) {
  if (value === null || typeof value === "boolean" || typeof value === "string") {
    return JSON.stringify(value);
  }
  if (typeof value === "number") {
    if (!Number.isFinite(value)) throw new StewardError("Non-finite number in canonical value.");
    return JSON.stringify(value);
  }
  if (Array.isArray(value)) return `[${value.map(canonical).join(",")}]`;
  if (typeof value === "object") {
    const entries = Object.keys(value)
      .sort()
      .map((key) => `${JSON.stringify(key)}:${canonical(value[key])}`);
    return `{${entries.join(",")}}`;
  }
  throw new StewardError(`Unsupported canonical value: ${typeof value}`);
}

export function hashValue(value) {
  return createHash("sha256").update(canonical(value)).digest("hex");
}

async function hashFile(file) {
  const hash = createHash("sha256");
  const stream = fs.createReadStream(file);
  for await (const chunk of stream) hash.update(chunk);
  return hash.digest("hex");
}

function isInside(root, candidate) {
  const relative = path.relative(root, candidate);
  return relative !== "" && relative !== ".." && !relative.startsWith(`..${path.sep}`) && !path.isAbsolute(relative);
}

function validateRelative(relative, label) {
  if (typeof relative !== "string" || relative.length === 0 || path.isAbsolute(relative)) {
    throw new StewardError(`${label} must be a non-empty relative path.`);
  }
  const normalized = path.normalize(relative);
  if (normalized === "." || normalized === ".." || normalized.startsWith(`..${path.sep}`)) {
    throw new StewardError(`${label} escapes the workspace: ${relative}`);
  }
  return normalized;
}

function resolveInside(root, relative, label) {
  const normalized = validateRelative(relative, label);
  const absolute = path.resolve(root, normalized);
  if (!isInside(root, absolute)) throw new StewardError(`${label} escapes the workspace: ${relative}`);
  return absolute;
}

async function lstatOrNull(file) {
  try {
    return await fsp.lstat(file);
  } catch (error) {
    if (error.code === "ENOENT") return null;
    throw error;
  }
}

async function assertNoSymlinkComponents(root, absolute, label) {
  const relative = path.relative(root, absolute);
  let cursor = root;
  for (const component of relative.split(path.sep).filter(Boolean)) {
    cursor = path.join(cursor, component);
    const stat = await lstatOrNull(cursor);
    if (!stat) break;
    if (stat.isSymbolicLink()) throw new StewardError(`${label} contains a symbolic-link component: ${cursor}`);
  }
}

async function directorySizeBytes(directory) {
  const { stdout } = await execFileAsync("/usr/bin/du", ["-sk", directory], {
    encoding: "utf8",
    maxBuffer: 1024 * 1024,
  });
  const kib = Number.parseInt(stdout.trim().split(/\s+/)[0], 10);
  if (!Number.isFinite(kib)) throw new StewardError(`Unable to measure target: ${directory}`);
  return kib * 1024;
}

function passportPolicyView(passport) {
  return {
    schema: passport.schema,
    passportId: passport.passportId,
    platform: passport.platform,
    workspaceRoot: passport.workspaceRoot,
    operation: passport.operation,
    confirmation: passport.confirmation,
    auditDirectory: passport.auditDirectory,
    provider: passport.provider,
    allowedKinds: passport.allowedKinds,
    targets: passport.targets,
    protectedPaths: passport.protectedPaths,
  };
}

export async function loadPassport(passportFile) {
  const sourcePath = path.resolve(passportFile);
  const raw = JSON.parse(await fsp.readFile(sourcePath, "utf8"));
  if (raw.schema !== "certified-system-steward/passport-v1") {
    throw new StewardError("Unsupported passport schema.");
  }
  if (typeof raw.passportId !== "string" || !raw.passportId) throw new StewardError("Passport id is missing.");
  if (raw.platform !== process.platform) {
    throw new StewardError(`Passport requires ${raw.platform}; current platform is ${process.platform}.`);
  }
  if (raw.operation !== "remove-reproducible-caches") throw new StewardError("Unsupported passport operation.");
  if (typeof raw.confirmation !== "string" || !raw.confirmation) throw new StewardError("Confirmation phrase is missing.");
  if (!path.isAbsolute(raw.workspaceRoot)) throw new StewardError("Workspace root must be absolute.");

  const workspaceRoot = path.resolve(raw.workspaceRoot);
  const rootStat = await lstatOrNull(workspaceRoot);
  if (!rootStat?.isDirectory() || rootStat.isSymbolicLink()) throw new StewardError("Workspace root is missing or unsafe.");

  if (!raw.allowedKinds || typeof raw.allowedKinds !== "object") throw new StewardError("Allowed cache kinds are missing.");
  if (!Array.isArray(raw.targets) || !Array.isArray(raw.protectedPaths)) {
    throw new StewardError("Passport targets and protected paths must be arrays.");
  }

  const targets = raw.targets.map((target, index) => {
    if (!target || typeof target !== "object") throw new StewardError(`Target ${index} is invalid.`);
    const relative = validateRelative(target.path, `Target ${index}`);
    const expectedBase = raw.allowedKinds[target.kind];
    if (typeof expectedBase !== "string" || path.basename(relative) !== expectedBase) {
      throw new StewardError(`Target ${relative} does not match its declared cache kind.`);
    }
    resolveInside(workspaceRoot, relative, `Target ${index}`);
    return { path: relative, kind: target.kind };
  });
  if (new Set(targets.map((target) => target.path)).size !== targets.length) {
    throw new StewardError("Passport contains duplicate targets.");
  }

  const protectedPaths = raw.protectedPaths.map((entry, index) => {
    const relative = validateRelative(entry, `Protected path ${index}`);
    resolveInside(workspaceRoot, relative, `Protected path ${index}`);
    return relative;
  });
  if (new Set(protectedPaths).size !== protectedPaths.length) {
    throw new StewardError("Passport contains duplicate protected paths.");
  }

  if (!raw.provider || raw.provider.kind !== "macos-openat-v1") {
    throw new StewardError("A supported OS-level provider is required.");
  }
  const providerSource = validateRelative(raw.provider.source, "Provider source");
  resolveInside(workspaceRoot, providerSource, "Provider source");
  if (!protectedPaths.includes(providerSource)) {
    throw new StewardError("OS-level provider source must belong to the protected projection.");
  }

  for (const protectedPath of protectedPaths) {
    for (const target of targets) {
      if (protectedPath === target.path || protectedPath.startsWith(`${target.path}${path.sep}`)) {
        throw new StewardError(`Protected path is inside a cleanup target: ${protectedPath}`);
      }
    }
  }

  const auditDirectory = validateRelative(raw.auditDirectory, "Audit directory");
  resolveInside(workspaceRoot, auditDirectory, "Audit directory");
  for (const target of targets) {
    if (auditDirectory === target.path || auditDirectory.startsWith(`${target.path}${path.sep}`)) {
      throw new StewardError("Audit directory is inside a cleanup target.");
    }
  }

  const passport = {
    ...raw,
    workspaceRoot,
    targets,
    protectedPaths,
    provider: { kind: raw.provider.kind, source: providerSource },
    auditDirectory,
    sourcePath,
  };
  passport.policyHash = hashValue(passportPolicyView(passport));
  return Object.freeze(passport);
}

async function inspectTarget(passport, target) {
  const absolute = resolveInside(passport.workspaceRoot, target.path, "Cleanup target");
  await assertNoSymlinkComponents(passport.workspaceRoot, absolute, "Cleanup target");
  const stat = await lstatOrNull(absolute);
  if (!stat) {
    return { path: target.path, kind: target.kind, exists: false, sizeBytes: 0, mtimeMs: null, mode: null };
  }
  if (!stat.isDirectory()) throw new StewardError(`Cleanup target is not a directory: ${target.path}`);
  const physicalRoot = await fsp.realpath(passport.workspaceRoot);
  const physicalParent = await fsp.realpath(path.dirname(absolute));
  if (physicalParent !== physicalRoot && !isInside(physicalRoot, physicalParent)) {
    throw new StewardError(`Cleanup target has a physical parent outside the workspace: ${target.path}`);
  }
  return {
    path: target.path,
    kind: target.kind,
    exists: true,
    sizeBytes: await directorySizeBytes(absolute),
    mtimeMs: Math.trunc(stat.mtimeMs),
    mode: stat.mode & 0o7777,
  };
}

async function protectedProjection(passport) {
  const entries = [];
  for (const relative of [...passport.protectedPaths].sort()) {
    const absolute = resolveInside(passport.workspaceRoot, relative, "Protected path");
    await assertNoSymlinkComponents(passport.workspaceRoot, absolute, "Protected path");
    const stat = await lstatOrNull(absolute);
    if (!stat) {
      entries.push({ path: relative, state: "missing" });
      continue;
    }
    if (!stat.isFile()) throw new StewardError(`Protected path is not a regular file: ${relative}`);
    entries.push({
      path: relative,
      state: "file",
      sizeBytes: stat.size,
      mode: stat.mode & 0o7777,
      sha256: await hashFile(absolute),
    });
  }
  const projection = { policyHash: passport.policyHash, entries };
  return { projection, root: hashValue(projection) };
}

export async function observe(passport) {
  const targets = [];
  for (const target of passport.targets) targets.push(await inspectTarget(passport, target));
  const protectedState = await protectedProjection(passport);
  return {
    observedAt: new Date().toISOString(),
    passportId: passport.passportId,
    policyHash: passport.policyHash,
    targets,
    targetSnapshot: hashValue(targets),
    protectedRoot: protectedState.root,
    protectedProjection: protectedState.projection,
  };
}

export function buildActionField(passport, observation) {
  const targets = observation.targets.filter((target) => target.exists).map((target) => target.path).sort();
  if (targets.length === 0) return [];
  const action = {
    type: "remove-reproducible-caches",
    passportId: passport.passportId,
    targets,
    targetSnapshot: observation.targetSnapshot,
  };
  return [{ ...action, actionId: hashValue(action) }];
}

export function selectAction(_observation, field) {
  return field.length === 0 ? null : field[0];
}

function actionInField(action, field) {
  return field.some((candidate) => candidate.actionId === action.actionId && hashValue(candidate) === hashValue(action));
}

function policyAdmits(passport, action) {
  if (action.type !== passport.operation || action.passportId !== passport.passportId) return false;
  const allowlist = new Set(passport.targets.map((target) => target.path));
  return action.targets.length === new Set(action.targets).size && action.targets.every((target) => allowlist.has(target));
}

function adapterResultMatches(before, action, after) {
  const selected = new Set(action.targets);
  const beforeByPath = new Map(before.targets.map((target) => [target.path, target]));
  const afterByPath = new Map(after.targets.map((target) => [target.path, target]));
  for (const [targetPath, beforeTarget] of beforeByPath) {
    const afterTarget = afterByPath.get(targetPath);
    if (!afterTarget) return false;
    if (selected.has(targetPath)) {
      if (afterTarget.exists) return false;
    } else if (hashValue(afterTarget) !== hashValue(beforeTarget)) {
      return false;
    }
  }
  return true;
}

async function ensureAuditDirectory(passport) {
  const directory = resolveInside(passport.workspaceRoot, passport.auditDirectory, "Audit directory");
  await assertNoSymlinkComponents(passport.workspaceRoot, directory, "Audit directory");
  await fsp.mkdir(directory, { recursive: true, mode: 0o700 });
  const stat = await fsp.lstat(directory);
  if (!stat.isDirectory() || stat.isSymbolicLink()) throw new StewardError("Audit directory is unsafe.");
  return directory;
}

async function writeAtomic(file, value) {
  const data = typeof value === "string" ? value : `${JSON.stringify(value, null, 2)}\n`;
  const temporary = `${file}.next-${process.pid}-${Date.now()}`;
  await fsp.writeFile(temporary, data, { mode: 0o600 });
  await fsp.rename(temporary, file);
}

async function appendJsonLineAtomic(file, value) {
  let previous = "";
  try {
    previous = await fsp.readFile(file, "utf8");
  } catch (error) {
    if (error.code !== "ENOENT") throw error;
  }
  await writeAtomic(file, `${previous}${JSON.stringify(value)}\n`);
}

async function readParentHead(auditDirectory) {
  const headFile = path.join(auditDirectory, "HEAD");
  const epochFile = path.join(auditDirectory, "EPOCH");
  const head = await lstatOrNull(headFile);
  const epoch = await lstatOrNull(epochFile);
  if (!head && !epoch) return { epoch: 0, digest: ZERO_HEAD };
  if (!head || !epoch) throw new StewardError("Audit HEAD and EPOCH are inconsistent.");
  const digest = (await fsp.readFile(headFile, "utf8")).trim();
  const epochText = (await fsp.readFile(epochFile, "utf8")).trim();
  if (!/^[a-f0-9]{64}$/.test(digest) || !/^\d+$/.test(epochText)) {
    throw new StewardError("Audit HEAD or EPOCH is malformed.");
  }
  return { epoch: Number.parseInt(epochText, 10), digest };
}

async function removeActionTargets(passport, action) {
  const provider = await compileProvider(passport);
  const results = [];
  for (const relative of action.targets) {
    const descriptor = passport.targets.find((target) => target.path === relative);
    if (!descriptor) throw new StewardError(`Action escaped the passport field: ${relative}`);
    await inspectTarget(passport, descriptor);
    const absolute = resolveInside(passport.workspaceRoot, relative, "Cleanup target");
    const { stdout } = await execFileAsync(provider.executable, [passport.workspaceRoot, relative], {
      encoding: "utf8",
      maxBuffer: 1024 * 1024,
    });
    const providerResult = JSON.parse(stdout);
    if (providerResult.removed !== true || providerResult.provider !== passport.provider.kind) {
      throw new StewardError(`OS-level provider returned an invalid result for ${relative}.`);
    }
    results.push({ path: relative, removed: true });
  }
  return { results, provider };
}

async function compileProvider(passport) {
  const source = resolveInside(passport.workspaceRoot, passport.provider.source, "Provider source");
  const sourceHash = await hashFile(source);
  const executable = path.join(os.tmpdir(), `certified-system-steward-${passport.provider.kind}-${sourceHash}`);
  const existing = await lstatOrNull(executable);
  if (!existing) {
    const temporary = `${executable}.next-${process.pid}`;
    await execFileAsync("/usr/bin/clang", [
      "-std=c17", "-O2", "-Wall", "-Wextra", "-Werror",
      source, "-o", temporary,
    ], { encoding: "utf8", maxBuffer: 1024 * 1024 });
    await fsp.chmod(temporary, 0o700);
    try {
      await fsp.rename(temporary, executable);
    } catch (error) {
      if (error.code !== "EEXIST") throw error;
      await fsp.rm(temporary, { force: true });
    }
  }
  const stat = await fsp.lstat(executable);
  if (!stat.isFile() || stat.isSymbolicLink()) throw new StewardError("Compiled provider cache is unsafe.");
  return {
    kind: passport.provider.kind,
    sourceHash,
    binaryHash: await hashFile(executable),
    executable,
  };
}

async function signReceiptIfConfigured(receiptFile) {
  const signingKey = process.env.CCP_SIGNING_KEY ?? "";
  if (!signingKey) return "UNSIGNED_LOCAL_HASH_CHAIN";
  const keyStat = await lstatOrNull(path.resolve(signingKey));
  if (!keyStat?.isFile() || keyStat.isSymbolicLink()) throw new StewardError("Configured signing key is missing or unsafe.");
  await execFileAsync("/usr/bin/ssh-keygen", ["-Y", "sign", "-f", path.resolve(signingKey), "-n", "css-steward", receiptFile]);
  return "SSH_SIGNATURE";
}

async function verifySshSignature(receiptFile) {
  const signature = `${receiptFile}.sig`;
  if (!(await lstatOrNull(signature))) return "not configured";
  const allowedSigners = process.env.CCP_ALLOWED_SIGNERS ?? "";
  if (!allowedSigners) return "present, not independently verified";
  const identity = process.env.CCP_SIGNING_IDENTITY ?? "local-operator";
  const content = await fsp.readFile(receiptFile);
  await new Promise((resolve, reject) => {
    const child = spawn("/usr/bin/ssh-keygen", [
      "-Y", "verify", "-f", path.resolve(allowedSigners), "-I", identity,
      "-n", "css-steward", "-s", signature,
    ], { stdio: ["pipe", "ignore", "pipe"] });
    let stderr = "";
    child.stderr.on("data", (chunk) => { stderr += chunk; });
    child.on("error", reject);
    child.on("close", (code) => code === 0 ? resolve() : reject(new StewardError(`Signature verification failed: ${stderr.trim()}`)));
    child.stdin.end(content);
  });
  return "verified";
}

function receiptName(epoch) {
  return `receipt-${String(epoch).padStart(6, "0")}.json`;
}

function actionSummary(observation, action) {
  const selected = new Set(action?.targets ?? []);
  const targets = observation.targets.filter((target) => selected.has(target.path));
  return {
    count: targets.length,
    bytes: targets.reduce((sum, target) => sum + target.sizeBytes, 0),
    targets: targets.map((target) => ({ path: target.path, sizeBytes: target.sizeBytes })),
  };
}

export async function runTransition(passport, options = {}) {
  const mode = options.mode ?? "preview";
  const hooks = options.hooks ?? {};
  const before = await observe(passport);
  const field = buildActionField(passport, before);
  const action = selectAction(before, field);
  const summary = actionSummary(before, action);

  if (mode === "preview") return { status: "PREVIEW", before, field, action, summary };
  if (mode !== "apply") throw new StewardError(`Unsupported transition mode: ${mode}`);
  if (options.confirmation !== passport.confirmation) throw new StewardError("Confirmation phrase does not match the passport.");
  if (!action) return { status: "NO_ACTION", before, field, action: null, summary };
  if (!actionInField(action, field)) throw new StewardError("Selector returned an action outside the current field.");
  if (!policyAdmits(passport, action)) throw new StewardError("Policy rejected the selected action.");

  const auditDirectory = await ensureAuditDirectory(passport);
  const parent = await readParentHead(auditDirectory);
  const candidateEpoch = parent.epoch + 1;
  const intent = {
    protocol: "CSS-RUNTIME-INTENT-v1",
    passportId: passport.passportId,
    candidateEpoch,
    parent,
    policyHash: passport.policyHash,
    field: field.map((candidate) => candidate.actionId),
    action,
    before: { targetSnapshot: before.targetSnapshot, protectedRoot: before.protectedRoot },
    createdAt: new Date().toISOString(),
  };
  const intentFile = path.join(auditDirectory, `intent-${String(candidateEpoch).padStart(6, "0")}.json`);
  await writeAtomic(intentFile, intent);
  const intentHash = hashValue(intent);

  try {
    if (hooks.afterIntent) await hooks.afterIntent({ passport, before, action, intent });
    const preflight = await observe(passport);
    const preflightField = buildActionField(passport, preflight);
    if (preflight.targetSnapshot !== before.targetSnapshot || !actionInField(action, preflightField)) {
      throw new StewardError("Cleanup plan changed after certification.", "PLAN_CHANGED");
    }
    if (preflight.protectedRoot !== before.protectedRoot) {
      throw new StewardError("Protected state changed before execution.", "PROTECTED_CHANGED");
    }

    const execution = await removeActionTargets(passport, action);
    const removed = execution.results;
    if (hooks.afterApply) await hooks.afterApply({ passport, before: preflight, action, removed });
    const after = await observe(passport);
    const certification = {
      actionInField: actionInField(action, preflightField),
      adapterResult: adapterResultMatches(preflight, action, after),
      policyAdmitted: policyAdmits(passport, action),
      protectedInvariant: after.protectedRoot === preflight.protectedRoot,
    };
    if (!Object.values(certification).every(Boolean)) {
      throw new StewardError("Runtime candidate does not satisfy AdmittedTransition.", "POSTCONDITION_FAILED");
    }

    const result = {
      protocol: "CSS-RUNTIME-RESULT-v1",
      status: "PASS",
      candidateEpoch,
      removed,
      provider: {
        kind: execution.provider.kind,
        sourceHash: execution.provider.sourceHash,
        binaryHash: execution.provider.binaryHash,
      },
      after: { targetSnapshot: after.targetSnapshot, protectedRoot: after.protectedRoot },
      certification,
      completedAt: new Date().toISOString(),
    };
    const resultFile = path.join(auditDirectory, `result-${String(candidateEpoch).padStart(6, "0")}.json`);
    await writeAtomic(resultFile, result);
    const resultHash = hashValue(result);

    const payload = {
      passportId: passport.passportId,
      parent,
      nextEpoch: candidateEpoch,
      policyHash: passport.policyHash,
      intentHash,
      resultHash,
      actionId: action.actionId,
      before: { protectedRoot: preflight.protectedRoot, targetSnapshot: preflight.targetSnapshot },
      after: { protectedRoot: after.protectedRoot, targetSnapshot: after.targetSnapshot },
      certification,
    };
    const next = { epoch: candidateEpoch, digest: hashValue(payload) };
    const receipt = { protocol: RECEIPT_PROTOCOL, next, payload };
    const receiptFile = path.join(auditDirectory, receiptName(candidateEpoch));
    await writeAtomic(receiptFile, receipt);
    const signatureMode = await signReceiptIfConfigured(receiptFile);
    const receiptFileHash = await hashFile(receiptFile);

    const witness = {
      protocol: WITNESS_PROTOCOL,
      passportId: passport.passportId,
      parent,
      next,
      policyHash: passport.policyHash,
      intentHash,
      resultHash,
      status: "PASS",
    };
    await writeAtomic(path.join(auditDirectory, `witness-${String(candidateEpoch).padStart(6, "0")}.json`), witness);
    await appendJsonLineAtomic(path.join(auditDirectory, "chain.log"), {
      epoch: candidateEpoch,
      head: next.digest,
      receipt: path.basename(receiptFile),
      receiptFileHash,
    });
    await writeAtomic(path.join(auditDirectory, "EPOCH"), `${candidateEpoch}\n`);
    await writeAtomic(path.join(auditDirectory, "HEAD"), `${next.digest}\n`);
    return { status: "ACCEPTED", parent, next, receiptFile, signatureMode, summary, certification };
  } catch (error) {
    const failure = {
      protocol: "CSS-RUNTIME-FAILURE-v1",
      status: "BLOCKED",
      candidateEpoch,
      parent,
      intentHash,
      code: error.code ?? "EXECUTION_ERROR",
      message: error.message,
      recordedAt: new Date().toISOString(),
    };
    await writeAtomic(path.join(auditDirectory, `failure-${String(candidateEpoch).padStart(6, "0")}-${Date.now()}.json`), failure);
    throw error;
  }
}

export async function verifyLatest(passport) {
  const auditDirectory = resolveInside(passport.workspaceRoot, passport.auditDirectory, "Audit directory");
  const stat = await lstatOrNull(auditDirectory);
  if (!stat) return { status: "EMPTY" };
  if (!stat.isDirectory() || stat.isSymbolicLink()) throw new StewardError("Audit directory is unsafe.");
  const parent = await readParentHead(auditDirectory);
  if (parent.epoch === 0) return { status: "EMPTY" };
  const lines = (await fsp.readFile(path.join(auditDirectory, "chain.log"), "utf8")).trim().split("\n");
  const chainEntry = JSON.parse(lines.at(-1));
  if (chainEntry.epoch !== parent.epoch || chainEntry.head !== parent.digest) {
    throw new StewardError("Chain tail does not match canonical HEAD.");
  }
  const receiptFile = path.join(auditDirectory, chainEntry.receipt);
  if (path.dirname(receiptFile) !== auditDirectory) throw new StewardError("Receipt path escaped the audit directory.");
  const receipt = JSON.parse(await fsp.readFile(receiptFile, "utf8"));
  if (receipt.protocol !== RECEIPT_PROTOCOL || hashValue(receipt.payload) !== receipt.next.digest) {
    throw new StewardError("Receipt digest is invalid.");
  }
  if (receipt.next.epoch !== parent.epoch || receipt.next.digest !== parent.digest) {
    throw new StewardError("Receipt does not match canonical HEAD.");
  }
  if (await hashFile(receiptFile) !== chainEntry.receiptFileHash) {
    throw new StewardError("Receipt file hash is invalid.");
  }
  const current = await observe(passport);
  if (current.protectedRoot !== receipt.payload.after.protectedRoot) {
    throw new StewardError("Current protected state differs from the accepted receipt.");
  }
  return {
    status: "PASS",
    epoch: parent.epoch,
    head: parent.digest,
    protectedRoot: current.protectedRoot,
    signature: await verifySshSignature(receiptFile),
  };
}

export function detectForkEvidence(left, right) {
  return left?.next?.epoch === right?.next?.epoch
    && left?.payload?.parent?.epoch === right?.payload?.parent?.epoch
    && left?.payload?.parent?.digest === right?.payload?.parent?.digest
    && left?.next?.digest !== right?.next?.digest;
}

function formatBytes(bytes) {
  const gib = bytes / 1024 / 1024 / 1024;
  return gib >= 1 ? `${gib.toFixed(2)} GiB` : `${(bytes / 1024 / 1024).toFixed(1)} MiB`;
}

function parseArguments(argv) {
  const defaultPassport = path.join(path.dirname(fileURLToPath(import.meta.url)), "passports", "macos-cache-cleanup.json");
  const parsed = { passport: defaultPassport, mode: "preview", confirmation: "" };
  for (let index = 0; index < argv.length; index += 1) {
    const argument = argv[index];
    if (argument === "--passport") parsed.passport = argv[++index];
    else if (argument === "--preview") parsed.mode = "preview";
    else if (argument === "--verify") parsed.mode = "verify";
    else if (argument === "--apply") {
      parsed.mode = "apply";
      parsed.confirmation = argv[++index] ?? "";
    } else throw new StewardError(`Unknown argument: ${argument}`);
  }
  return parsed;
}

async function main() {
  const options = parseArguments(process.argv.slice(2));
  const passport = await loadPassport(options.passport);
  if (options.mode === "verify") {
    const verification = await verifyLatest(passport);
    console.log("CERTIFIED SYSTEM STEWARD / VERIFY");
    console.log(`Status: ${verification.status}`);
    if (verification.status === "PASS") {
      console.log(`Epoch: ${verification.epoch}`);
      console.log(`Head: ${verification.head}`);
      console.log(`Protected root: ${verification.protectedRoot}`);
      console.log(`Signature: ${verification.signature}`);
    }
    return;
  }

  const outcome = await runTransition(passport, options);
  console.log("CERTIFIED SYSTEM STEWARD");
  console.log(`Passport: ${passport.passportId}`);
  console.log(`Policy: ${passport.policyHash}`);
  console.log(`Status: ${outcome.status}`);
  console.log(`Targets: ${outcome.summary.count}`);
  console.log(`Recoverable: ${formatBytes(outcome.summary.bytes)}`);
  for (const target of outcome.summary.targets) console.log(`  ${formatBytes(target.sizeBytes)}  ${target.path}`);
  if (outcome.status === "PREVIEW") {
    console.log("Nothing was deleted and no audit epoch was created.");
    console.log(`Apply with: --apply ${passport.confirmation}`);
  } else if (outcome.status === "ACCEPTED") {
    console.log(`Epoch: ${outcome.next.epoch}`);
    console.log(`Head: ${outcome.next.digest}`);
    console.log(`Receipt: ${outcome.receiptFile}`);
  }
}

const invokedDirectly = process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url);
if (invokedDirectly) {
  main().catch((error) => {
    console.error(`BLOCKED: ${error.message}`);
    process.exitCode = 1;
  });
}
