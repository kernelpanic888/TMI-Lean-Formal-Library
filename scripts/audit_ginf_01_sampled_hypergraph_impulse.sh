#!/usr/bin/env bash
set -euo pipefail

readonly REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly LEAN_CORE="lean/TMI/InterfaceFoundations/SampledHypergraphImpulse.lean"
readonly LEAN_AUDIT="lean/TMI/InterfaceFoundations/SampledHypergraphImpulseAudit.lean"
readonly PASSPORT="docs/GINF_01_SAMPLED_HYPERGRAPH_IMPULSE_PASSPORT_RU_EN.md"

fail() {
  printf 'GINF-01 / FAIL / %s\n' "$*" >&2
  exit 1
}

pass() {
  printf 'GINF-01 / PASS / %s\n' "$*"
}

cd "$REPO_ROOT"

for tool in lake rg; do
  command -v "$tool" >/dev/null 2>&1 \
    || fail "required tool is unavailable: $tool"
done

for input in "$LEAN_CORE" "$LEAN_AUDIT" "$PASSPORT"; do
  [[ -s "$input" ]] || fail "required input is unavailable or empty: $input"
done

if rg -n \
  '(^|[^[:alnum:]_])(sorry|admit)([^[:alnum:]_]|$)|^[[:space:]]*axiom[[:space:]]' \
  "$LEAN_CORE" "$LEAN_AUDIT"; then
  fail "Lean sources contain sorry, admit, or a declared axiom"
fi
pass "Lean sources contain no sorry, admit, or declared axiom"

lake build \
  TMI.InterfaceFoundations.SampledHypergraphImpulse \
  TMI.InterfaceFoundations.SampledHypergraphImpulseAudit \
  || fail "Lean module build failed"
pass "both GINF-01 modules build"

readonly LEAN_OUTPUT="$(mktemp "${TMPDIR:-/tmp}/ginf-01-lean.XXXXXX")"
trap 'rm -f "$LEAN_OUTPUT"' EXIT

if ! lake env lean "$LEAN_AUDIT" >"$LEAN_OUTPUT" 2>&1; then
  cat "$LEAN_OUTPUT"
  fail "Lean theorem audit failed"
fi
cat "$LEAN_OUTPUT"

readonly AXIOM_FREE_COUNT="$(grep -c 'does not depend on any axioms' "$LEAN_OUTPUT" || true)"
[[ "$AXIOM_FREE_COUNT" == "17" ]] \
  || fail "expected 17 axiom-free theorem reports, observed $AXIOM_FREE_COUNT"

if rg -n 'depends on axioms:|sorryAx' "$LEAN_OUTPUT"; then
  fail "Lean output reports an axiom dependency"
fi

pass "17 reported theorems have no axiom dependencies"
pass "sample/full-carrier, admitted-impulse, and view boundaries complete"
