#!/usr/bin/env bash

# Thin macOS entrypoint. Policy, selection, execution and receipts live in the
# Certified System Steward runtime and its explicit passport.

set -euo pipefail

ROOT="/Users/test/Documents/Codex/2026-07-26/sites-plugin-sites-openai-bundled-build-3"
RUNTIME="$ROOT/tools/certified-system-steward.mjs"
PASSPORT="$ROOT/tools/passports/macos-cache-cleanup.json"

if [[ -n "${STEWARD_NODE:-}" ]]; then
  NODE="$STEWARD_NODE"
elif command -v node >/dev/null 2>&1; then
  NODE="$(command -v node)"
elif [[ -x "/Users/test/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node" ]]; then
  NODE="/Users/test/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node"
else
  printf '%s\n' "Blocked: Node.js runtime was not found." >&2
  exit 2
fi

exec "$NODE" "$RUNTIME" --passport "$PASSPORT" "$@"
