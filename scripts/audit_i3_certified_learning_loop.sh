#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="$ROOT/.lake/build/bin/i3_learning_loop"

lake --dir "$ROOT" build i3_learning_loop >/dev/null

pass=0
total=0

expect_pass() {
  total=$((total + 1))
  local output
  output="$($BIN "$1")"
  [[ "$output" == *"$2"* ]]
  pass=$((pass + 1))
  printf 'PASS %02d | %s\n' "$total" "$1"
}

expect_hold() {
  total=$((total + 1))
  local output status=0
  output="$($BIN "$1" 2>&1)" || status=$?
  [[ $status -ne 0 && "$output" == *"HOLD"* ]]
  pass=$((pass + 1))
  printf 'PASS %02d | %s fail-closed\n' "$total" "$1"
}

expect_pass admit "CERTIFIED LEARNING LOOP"
expect_pass rollback "ROLLBACK EXACT"
expect_hold worse
expect_hold unbounded
expect_hold tampered-act
expect_hold stale-feedback
expect_hold wrong-head
expect_hold parameter-drift

printf 'I3-L18 BLIND AUDIT: %d/%d PASS\n' "$pass" "$total"
