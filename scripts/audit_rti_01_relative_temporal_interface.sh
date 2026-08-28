#!/usr/bin/env bash
set -euo pipefail

readonly REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly LEAN_CORE="lean/TMI/InterfaceFoundations/RelativeTemporalInterface.lean"
readonly LEAN_AUDIT="lean/TMI/InterfaceFoundations/RelativeTemporalInterfaceAudit.lean"
readonly QUANTUM_CORE="lean/TMI/InterfaceFoundations/QuantumComparisonBoundary.lean"
readonly QUANTUM_AUDIT="lean/TMI/InterfaceFoundations/QuantumComparisonBoundaryAudit.lean"
readonly TPTP_RTI="external_proofs/rti_01_future_reading_cannot_be_both_tptp_0_1.p"
readonly TPTP_QUANTUM="external_proofs/rti_02_quantum_reversal_requires_explicit_branch_tptp_0_1.p"

fail() {
  printf 'RTI / FAIL / %s\n' "$*" >&2
  exit 1
}

pass() {
  printf 'RTI / PASS / %s\n' "$*"
}

require_tool() {
  command -v "$1" >/dev/null 2>&1 || fail "required tool is unavailable: $1"
}

last_szs_status() {
  sed -nE 's/.*SZS status ([^[:space:]]+).*/\1/p' "$1" | tail -n 1
}

run_lean_audit() {
  local source="$1"
  local expected="$2"
  local label="$3"
  local output="$4"
  local observed

  if ! lake env lean "$source" >"$output" 2>&1; then
    cat "$output"
    fail "$label Lean axiom audit failed"
  fi
  cat "$output"
  observed="$(grep -c 'does not depend on any axioms' "$output" || true)"
  [[ "$observed" == "$expected" ]] \
    || fail "$label expected $expected axiom-free theorem reports, observed $observed"
  pass "$label reports $expected Lean theorems with no axiom dependencies"
}

run_vampire() {
  local input="$1"
  local output
  local status

  output="$(mktemp "${TMPDIR:-/tmp}/rti-vampire.XXXXXX")"
  if ! vampire --mode casc --time_limit 10 "$input" >"$output" 2>&1; then
    cat "$output"
    rm -f "$output"
    fail "Vampire execution failed for $input"
  fi
  cat "$output"
  status="$(last_szs_status "$output")"
  rm -f "$output"
  [[ "$status" == "Theorem" ]] \
    || fail "Vampire returned SZS status ${status:-missing} for $input"
  pass "Vampire returned SZS status Theorem for $(basename "$input")"
}

run_eprover() {
  local input="$1"
  local output
  local status

  output="$(mktemp "${TMPDIR:-/tmp}/rti-eprover.XXXXXX")"
  if ! eprover --auto --cpu-limit=10 "$input" >"$output" 2>&1; then
    cat "$output"
    rm -f "$output"
    fail "E prover execution failed for $input"
  fi
  cat "$output"
  status="$(last_szs_status "$output")"
  rm -f "$output"
  [[ "$status" == "Theorem" ]] \
    || fail "E prover returned SZS status ${status:-missing} for $input"
  pass "E prover returned SZS status Theorem for $(basename "$input")"
}

cd "$REPO_ROOT"

for tool in lake rg vampire eprover; do
  require_tool "$tool"
done

for input in "$TPTP_RTI" "$TPTP_QUANTUM"; do
  [[ -s "$input" ]] || fail "TPTP input is unavailable or empty: $input"
done

if rg -n \
  '(^|[^[:alnum:]_])(sorry|admit)([^[:alnum:]_]|$)|^[[:space:]]*axiom[[:space:]]' \
  "$LEAN_CORE" "$LEAN_AUDIT" "$QUANTUM_CORE" "$QUANTUM_AUDIT"; then
  fail "Lean sources contain sorry, admit, or a declared axiom"
fi
pass "Lean sources contain no sorry, admit, or declared axiom"

lake build \
  TMI.InterfaceFoundations.RelativeTemporalInterface \
  TMI.InterfaceFoundations.RelativeTemporalInterfaceAudit \
  TMI.InterfaceFoundations.QuantumComparisonBoundary \
  TMI.InterfaceFoundations.QuantumComparisonBoundaryAudit \
  || fail "Lean module build failed"

readonly LEAN_OUTPUT="$(mktemp "${TMPDIR:-/tmp}/rti-01-lean.XXXXXX")"
readonly QUANTUM_OUTPUT="$(mktemp "${TMPDIR:-/tmp}/rti-02-lean.XXXXXX")"
trap 'rm -f "$LEAN_OUTPUT" "$QUANTUM_OUTPUT"' EXIT

run_lean_audit "$LEAN_AUDIT" 5 "RTI-01 core" "$LEAN_OUTPUT"
run_lean_audit "$QUANTUM_AUDIT" 4 "RTI-02 quantum boundary" "$QUANTUM_OUTPUT"

readonly VAMPIRE_VERSION="$(vampire --version 2>&1 | sed -n '1p')"
printf 'RTI / INFO / %s\n' "$VAMPIRE_VERSION"
run_vampire "$TPTP_RTI"
run_vampire "$TPTP_QUANTUM"

readonly E_VERSION="$(eprover --version 2>&1 | sed -n '1p')"
printf 'RTI / INFO / %s\n' "$E_VERSION"
run_eprover "$TPTP_RTI"
run_eprover "$TPTP_QUANTUM"

pass "Lean kernel plus independent Vampire/E mirrors complete"
