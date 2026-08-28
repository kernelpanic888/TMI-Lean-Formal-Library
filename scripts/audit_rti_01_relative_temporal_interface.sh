#!/usr/bin/env bash
set -euo pipefail

readonly REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly LEAN_CORE="lean/TMI/InterfaceFoundations/RelativeTemporalInterface.lean"
readonly LEAN_AUDIT="lean/TMI/InterfaceFoundations/RelativeTemporalInterfaceAudit.lean"
readonly TPTP_INPUT="external_proofs/rti_01_future_reading_cannot_be_both_tptp_0_1.p"

fail() {
  printf 'RTI-01 / FAIL / %s\n' "$*" >&2
  exit 1
}

pass() {
  printf 'RTI-01 / PASS / %s\n' "$*"
}

require_tool() {
  command -v "$1" >/dev/null 2>&1 || fail "required tool is unavailable: $1"
}

last_szs_status() {
  sed -nE 's/.*SZS status ([^[:space:]]+).*/\1/p' "$1" | tail -n 1
}

cd "$REPO_ROOT"

for tool in lake rg vampire eprover; do
  require_tool "$tool"
done

if rg -n \
  '(^|[^[:alnum:]_])(sorry|admit)([^[:alnum:]_]|$)|^[[:space:]]*axiom[[:space:]]' \
  "$LEAN_CORE" "$LEAN_AUDIT"; then
  fail "Lean sources contain sorry, admit, or a declared axiom"
fi
pass "Lean sources contain no sorry, admit, or declared axiom"

lake build \
  TMI.InterfaceFoundations.RelativeTemporalInterface \
  TMI.InterfaceFoundations.RelativeTemporalInterfaceAudit \
  || fail "Lean module build failed"

readonly LEAN_OUTPUT="$(mktemp "${TMPDIR:-/tmp}/rti-01-lean.XXXXXX")"
readonly VAMPIRE_OUTPUT="$(mktemp "${TMPDIR:-/tmp}/rti-01-vampire.XXXXXX")"
readonly E_OUTPUT="$(mktemp "${TMPDIR:-/tmp}/rti-01-eprover.XXXXXX")"
trap 'rm -f "$LEAN_OUTPUT" "$VAMPIRE_OUTPUT" "$E_OUTPUT"' EXIT

if ! lake env lean "$LEAN_AUDIT" >"$LEAN_OUTPUT" 2>&1; then
  cat "$LEAN_OUTPUT"
  fail "Lean axiom audit failed"
fi
cat "$LEAN_OUTPUT"

readonly AXIOM_FREE_COUNT="$(grep -c 'does not depend on any axioms' "$LEAN_OUTPUT" || true)"
[[ "$AXIOM_FREE_COUNT" == "5" ]] \
  || fail "expected five axiom-free theorem reports, observed $AXIOM_FREE_COUNT"
pass "five Lean theorems report no axiom dependencies"

readonly VAMPIRE_VERSION="$(vampire --version 2>&1 | sed -n '1p')"
printf 'RTI-01 / INFO / %s\n' "$VAMPIRE_VERSION"
if ! vampire --mode casc --time_limit 10 "$TPTP_INPUT" >"$VAMPIRE_OUTPUT" 2>&1; then
  cat "$VAMPIRE_OUTPUT"
  fail "Vampire execution failed"
fi
cat "$VAMPIRE_OUTPUT"
readonly VAMPIRE_STATUS="$(last_szs_status "$VAMPIRE_OUTPUT")"
[[ "$VAMPIRE_STATUS" == "Theorem" ]] \
  || fail "Vampire returned SZS status ${VAMPIRE_STATUS:-missing}"
pass "Vampire returned SZS status Theorem"

readonly E_VERSION="$(eprover --version 2>&1 | sed -n '1p')"
printf 'RTI-01 / INFO / %s\n' "$E_VERSION"
if ! eprover --auto --cpu-limit=10 "$TPTP_INPUT" >"$E_OUTPUT" 2>&1; then
  cat "$E_OUTPUT"
  fail "E prover execution failed"
fi
cat "$E_OUTPUT"
readonly E_STATUS="$(last_szs_status "$E_OUTPUT")"
[[ "$E_STATUS" == "Theorem" ]] \
  || fail "E prover returned SZS status ${E_STATUS:-missing}"
pass "E prover returned SZS status Theorem"

pass "Lean kernel plus independent Vampire/E mirror complete"
