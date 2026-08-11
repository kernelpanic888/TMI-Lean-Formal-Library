import test from "node:test";
import assert from "node:assert/strict";
import fsp from "node:fs/promises";
import os from "node:os";
import path from "node:path";
import { fileURLToPath } from "node:url";

import {
  detectForkEvidence,
  loadPassport,
  runTransition,
  verifyLatest,
} from "../certified-system-steward.mjs";

async function fixture() {
  const root = await fsp.mkdtemp(path.join(os.tmpdir(), "certified-steward-test-"));
  await fsp.mkdir(path.join(root, "alpha", ".lake"), { recursive: true });
  await fsp.writeFile(path.join(root, "alpha", ".lake", "cache.bin"), "reproducible");
  await fsp.mkdir(path.join(root, "beta"), { recursive: true });
  await fsp.writeFile(path.join(root, "kernel.txt"), "protected-kernel\n");
  await fsp.mkdir(path.join(root, "provider"), { recursive: true });
  const providerSource = fileURLToPath(new URL("../platform/macos-safe-remove.c", import.meta.url));
  await fsp.copyFile(providerSource, path.join(root, "provider", "macos-safe-remove.c"));
  const passportFile = path.join(root, "passport.json");
  const passport = {
    schema: "certified-system-steward/passport-v1",
    passportId: "test-cleanup-v1",
    platform: process.platform,
    workspaceRoot: root,
    operation: "remove-reproducible-caches",
    confirmation: "TEST-AND-CLEAN",
    auditDirectory: "audit",
    provider: { kind: "macos-openat-quarantine-v2", source: "provider/macos-safe-remove.c" },
    allowedKinds: { lake: ".lake", nodeModules: "node_modules" },
    targets: [
      { path: "alpha/.lake", kind: "lake" },
      { path: "beta/node_modules", kind: "nodeModules" },
    ],
    protectedPaths: ["kernel.txt", "provider/macos-safe-remove.c"],
  };
  await fsp.writeFile(passportFile, `${JSON.stringify(passport, null, 2)}\n`);
  return { root, passportFile, passport };
}

test("normal cleanup produces an admitted receipt and preserves the kernel", async (t) => {
  const scene = await fixture();
  t.after(() => fsp.rm(scene.root, { recursive: true, force: true }));
  const passport = await loadPassport(scene.passportFile);
  const preview = await runTransition(passport, { mode: "preview" });
  assert.equal(preview.status, "PREVIEW");
  assert.equal(preview.summary.count, 1);
  const result = await runTransition(passport, { mode: "apply", confirmation: "TEST-AND-CLEAN" });
  assert.equal(result.status, "ACCEPTED");
  await assert.rejects(fsp.access(path.join(scene.root, "alpha", ".lake")));
  assert.equal(await fsp.readFile(path.join(scene.root, "kernel.txt"), "utf8"), "protected-kernel\n");
  assert.equal((await verifyLatest(passport)).status, "PASS");
});

test("a passport target outside the workspace is rejected", async (t) => {
  const scene = await fixture();
  t.after(() => fsp.rm(scene.root, { recursive: true, force: true }));
  scene.passport.targets = [{ path: "../foreign/node_modules", kind: "nodeModules" }];
  await fsp.writeFile(scene.passportFile, JSON.stringify(scene.passport));
  await assert.rejects(loadPassport(scene.passportFile), /escapes the workspace/);
});

test("a symbolic-link cleanup target is rejected", async (t) => {
  const scene = await fixture();
  t.after(() => fsp.rm(scene.root, { recursive: true, force: true }));
  const outside = await fsp.mkdtemp(path.join(os.tmpdir(), "certified-steward-outside-"));
  t.after(() => fsp.rm(outside, { recursive: true, force: true }));
  await fsp.symlink(outside, path.join(scene.root, "beta", "node_modules"));
  const passport = await loadPassport(scene.passportFile);
  await assert.rejects(runTransition(passport, { mode: "preview" }), /symbolic-link/);
});

test("a symlink inside an admitted cache is removed without following it", async (t) => {
  const scene = await fixture();
  t.after(() => fsp.rm(scene.root, { recursive: true, force: true }));
  const outside = await fsp.mkdtemp(path.join(os.tmpdir(), "certified-steward-sentinel-"));
  t.after(() => fsp.rm(outside, { recursive: true, force: true }));
  const sentinel = path.join(outside, "must-survive.txt");
  await fsp.writeFile(sentinel, "survives\n");
  await fsp.symlink(outside, path.join(scene.root, "alpha", ".lake", "outside-link"));
  const passport = await loadPassport(scene.passportFile);
  const result = await runTransition(passport, { mode: "apply", confirmation: "TEST-AND-CLEAN" });
  assert.equal(result.status, "ACCEPTED");
  assert.equal(await fsp.readFile(sentinel, "utf8"), "survives\n");
});

test("a symlink in place of the owned quarantine is rejected", async (t) => {
  const scene = await fixture();
  t.after(() => fsp.rm(scene.root, { recursive: true, force: true }));
  const outside = await fsp.mkdtemp(path.join(os.tmpdir(), "certified-steward-quarantine-sentinel-"));
  t.after(() => fsp.rm(outside, { recursive: true, force: true }));
  const sentinel = path.join(outside, "must-survive.txt");
  await fsp.writeFile(sentinel, "survives\n");
  await fsp.symlink(outside, path.join(scene.root, ".certified-system-steward-quarantine"));
  const passport = await loadPassport(scene.passportFile);
  await assert.rejects(
    runTransition(passport, { mode: "apply", confirmation: "TEST-AND-CLEAN" }),
    /quarantine|directory component|OS-level provider/i,
  );
  await fsp.access(path.join(scene.root, "alpha", ".lake"));
  assert.equal(await fsp.readFile(sentinel, "utf8"), "survives\n");
});

test("a writable quarantine is rejected before the target moves", async (t) => {
  const scene = await fixture();
  t.after(() => fsp.rm(scene.root, { recursive: true, force: true }));
  const quarantine = path.join(scene.root, ".certified-system-steward-quarantine");
  await fsp.mkdir(quarantine, { mode: 0o755 });
  await fsp.chmod(quarantine, 0o755);
  const passport = await loadPassport(scene.passportFile);
  await assert.rejects(
    runTransition(passport, { mode: "apply", confirmation: "TEST-AND-CLEAN" }),
    /quarantine|OS-level provider/i,
  );
  await fsp.access(path.join(scene.root, "alpha", ".lake"));
});

test("a changed action field is blocked before deletion", async (t) => {
  const scene = await fixture();
  t.after(() => fsp.rm(scene.root, { recursive: true, force: true }));
  const passport = await loadPassport(scene.passportFile);
  await assert.rejects(
    runTransition(passport, {
      mode: "apply",
      confirmation: "TEST-AND-CLEAN",
      hooks: {
        afterIntent: () => fsp.mkdir(path.join(scene.root, "beta", "node_modules"), { recursive: true }),
      },
    }),
    /plan changed/,
  );
  await fsp.access(path.join(scene.root, "alpha", ".lake"));
});

test("a protected-file change is blocked before deletion", async (t) => {
  const scene = await fixture();
  t.after(() => fsp.rm(scene.root, { recursive: true, force: true }));
  const passport = await loadPassport(scene.passportFile);
  await assert.rejects(
    runTransition(passport, {
      mode: "apply",
      confirmation: "TEST-AND-CLEAN",
      hooks: {
        afterIntent: () => fsp.appendFile(path.join(scene.root, "kernel.txt"), "mutation\n"),
      },
    }),
    /Protected state changed/,
  );
  await fsp.access(path.join(scene.root, "alpha", ".lake"));
});

test("two incompatible signed views of one slot form fork evidence", () => {
  const parent = { epoch: 8, digest: "a".repeat(64) };
  const left = { next: { epoch: 9, digest: "b".repeat(64) }, payload: { parent } };
  const right = { next: { epoch: 9, digest: "c".repeat(64) }, payload: { parent } };
  assert.equal(detectForkEvidence(left, right), true);
  assert.equal(detectForkEvidence(left, left), false);
});
