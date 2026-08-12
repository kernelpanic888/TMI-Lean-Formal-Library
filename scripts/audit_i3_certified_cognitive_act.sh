#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="$ROOT/.lake/build/bin/i3_cognitive_act"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

lake --dir "$ROOT" build i3_cognitive_act >/dev/null

d64() { printf '%064d' "$1"; }
MODEL="$(d64 101)"
SELECTOR="$(d64 102)"
D1="$(d64 201)"; D2="$(d64 202)"; D3="$(d64 203)"; D4="$(d64 204)"
D5="$(d64 205)"; D6="$(d64 206)"; D7="$(d64 207)"; D8="$(d64 208)"

cat >"$TMP/cognitive.policy" <<EOF
I3CAP1|1|i3-l17-policy|$MODEL|$SELECTOR|30
EOF
cat >"$TMP/candidate.evidence" <<EOF
I3CAE1|1|i3-l17-policy|act-001|$MODEL|$SELECTOR|100|1|0|1|0|0|0|0|0|0|1|-1|1|1|-1|1|1
EOF
cat >"$TMP/l16.policy" <<EOF
I3IRHAP1|1|i3-l16-policy|$D1|$D2|$D3|$D4|challenge.example|$D5|$D6|$D7|2|2|30
EOF
cat >"$TMP/l16.evidence" <<EOF
I3IRHAE1|1|i3-l16-policy|$D1|$D2|$D3|$D4|challenge.example|$D5|$D6|$D7|100|3|3|1|1|1|1|1|1|1|1|1|1
EOF

mutate() {
  awk -v FS='|' -v OFS='|' -v n="$3" -v v="$4" '{$n=v; print}' "$1" >"$2"
}

pass=0
total=0
expect_pass() {
  total=$((total + 1))
  local output
  output="$($BIN verify "$1" "$2" "$3" "$4" "$5")"
  [[ "$output" == *"CERTIFIED COGNITIVE ACT"* && "$output" == *"return=available"* ]]
  pass=$((pass + 1))
  printf 'PASS %02d | certified act\n' "$total"
}
expect_hold() {
  total=$((total + 1))
  local output status=0
  output="$($BIN verify "$1" "$2" "$3" "$4" "$5" 2>&1)" || status=$?
  [[ $status -ne 0 && "$output" == *"HOLD"* ]]
  pass=$((pass + 1))
  printf 'PASS %02d | fail-closed\n' "$total"
}

expect_pass "$TMP/cognitive.policy" "$TMP/candidate.evidence" "$TMP/l16.policy" "$TMP/l16.evidence" 110

mutate "$TMP/candidate.evidence" "$TMP/bad-model" 5 "$(d64 999)"
expect_hold "$TMP/cognitive.policy" "$TMP/bad-model" "$TMP/l16.policy" "$TMP/l16.evidence" 110
mutate "$TMP/candidate.evidence" "$TMP/bad-selector" 6 "$(d64 998)"
expect_hold "$TMP/cognitive.policy" "$TMP/bad-selector" "$TMP/l16.policy" "$TMP/l16.evidence" 110
mutate "$TMP/candidate.evidence" "$TMP/bad-policy" 3 "wrong-policy"
expect_hold "$TMP/cognitive.policy" "$TMP/bad-policy" "$TMP/l16.policy" "$TMP/l16.evidence" 110
expect_hold "$TMP/cognitive.policy" "$TMP/candidate.evidence" "$TMP/l16.policy" "$TMP/l16.evidence" 131
expect_hold "$TMP/cognitive.policy" "$TMP/candidate.evidence" "$TMP/l16.policy" "$TMP/l16.evidence" 99
mutate "$TMP/candidate.evidence" "$TMP/unsafe-prefix" 16 1
expect_hold "$TMP/cognitive.policy" "$TMP/unsafe-prefix" "$TMP/l16.policy" "$TMP/l16.evidence" 110
mutate "$TMP/candidate.evidence" "$TMP/tampered-proposal" 23 -1
expect_hold "$TMP/cognitive.policy" "$TMP/tampered-proposal" "$TMP/l16.policy" "$TMP/l16.evidence" 110
mutate "$TMP/candidate.evidence" "$TMP/bad-protocol" 1 I3BAD
expect_hold "$TMP/cognitive.policy" "$TMP/bad-protocol" "$TMP/l16.policy" "$TMP/l16.evidence" 110
mutate "$TMP/l16.evidence" "$TMP/bad-signature" 18 0
expect_hold "$TMP/cognitive.policy" "$TMP/candidate.evidence" "$TMP/l16.policy" "$TMP/bad-signature" 110
mutate "$TMP/l16.evidence" "$TMP/bad-domain-count" 14 1
expect_hold "$TMP/cognitive.policy" "$TMP/candidate.evidence" "$TMP/l16.policy" "$TMP/bad-domain-count" 110
mutate "$TMP/l16.evidence" "$TMP/bad-l16-policy" 3 wrong-l16-policy
expect_hold "$TMP/cognitive.policy" "$TMP/candidate.evidence" "$TMP/l16.policy" "$TMP/bad-l16-policy" 110

printf 'I3-L17 BLIND AUDIT: %d/%d PASS\n' "$pass" "$total"
