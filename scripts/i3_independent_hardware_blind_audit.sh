#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="$ROOT/.lake/build/bin/i3_remote_hardware"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

digest() { printf '%064d' "$1"; }
mutate() {
  local index="$1" value="$2" source="$3" target="$4"
  awk -F'|' -v OFS='|' -v i="$index" -v v="$value" '{$i=v; print}' "$source" > "$target"
}

POLICY="$WORK/policy.txt"
EVIDENCE="$WORK/evidence.txt"

printf 'I3IRHAP1|1|i3-l16-policy|%s|%s|%s|%s|remote-verifier.example|%s|%s|%s|2|2|30\n' \
  "$(digest 15)" "$(digest 14)" "$(digest 13)" "$(digest 12)" \
  "$(digest 11)" "$(digest 10)" "$(digest 9)" > "$POLICY"

printf 'I3IRHAE1|1|i3-l16-policy|%s|%s|%s|%s|remote-verifier.example|%s|%s|%s|100|2|2|1|1|1|1|1|1|1|1|1|1\n' \
  "$(digest 15)" "$(digest 14)" "$(digest 13)" "$(digest 12)" \
  "$(digest 11)" "$(digest 10)" "$(digest 9)" > "$EVIDENCE"

pass=0
total=0

expect_admit() {
  total=$((total + 1))
  if "$BIN" verify "$POLICY" "$1" "$2" | grep -q '^GLOBAL HARDWARE ADMIT'; then
    pass=$((pass + 1))
  fi
}

expect_hold() {
  total=$((total + 1))
  local output
  output="$("$BIN" verify "$POLICY" "$1" "$2" 2>/dev/null || true)"
  if grep -q '^GLOBAL HARDWARE HOLD' <<< "$output"; then
    pass=$((pass + 1))
  fi
}

expect_admit "$EVIDENCE" 110

case_no=0
for spec in \
  "4:$(digest 115)" "5:$(digest 114)" "6:$(digest 113)" "7:$(digest 112)" \
  "8:redirected.example" "9:$(digest 111)" "10:$(digest 110)" "11:$(digest 109)" \
  "15:0" "16:0" "17:0" "18:0" "19:0" "20:0" "21:0" "22:0" "23:0" "24:0" \
  "13:1" "14:1"; do
  case_no=$((case_no + 1))
  field="${spec%%:*}"
  value="${spec#*:}"
  candidate="$WORK/mutation-$case_no.txt"
  mutate "$field" "$value" "$EVIDENCE" "$candidate"
  expect_hold "$candidate" 110
done

expect_hold "$EVIDENCE" 131
expect_hold "$EVIDENCE" 99

printf 'I3-L16 BLIND AUDIT %d/%d PASS\n' "$pass" "$total"
test "$pass" -eq "$total"
