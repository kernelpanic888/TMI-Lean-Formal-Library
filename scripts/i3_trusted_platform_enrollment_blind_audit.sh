#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
I3="$ROOT/.lake/build/bin/i3_enrollment"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
POLICY="$TMP/enrollment.policy"
OBS="$TMP/enrollment.observation"
PASS=0

d() { printf '%064d' "$1"; }
cat >"$POLICY" <<EOF
I3TPEP1|1|i3-l15|$(d 1)|TEAM42|chatgpt.site.kernelpanic888.i3.l14|$(d 2)|$(d 3)|$(d 4)|TEAM42.chatgpt.site.kernelpanic888.i3.l14|$(d 5)|30
EOF
cat >"$OBS" <<EOF
I3TPEO1|1|i3-l15|$(d 1)|TEAM42|chatgpt.site.kernelpanic888.i3.l14|$(d 2)|$(d 3)|$(d 4)|TEAM42.chatgpt.site.kernelpanic888.i3.l14|$(d 5)|100|true|true|true|true|true
EOF

expect_hold() {
  local label="$1" file="$2" now="${3:-110}"
  if "$I3" verify "$POLICY" "$file" "$now" >/dev/null 2>&1; then
    printf 'FAIL %s\n' "$label"; exit 1
  fi
  PASS=$((PASS + 1)); printf 'PASS %s\n' "$label"
}

OUT="$("$I3" verify "$POLICY" "$OBS" 110)"
[[ "$OUT" == *"READY FOR HARDWARE PROBE"* && "$OUT" == *"LOCAL HARDWARE PASS=HOLD"* ]] || { printf 'FAIL EXACT ENROLLMENT\n'; exit 1; }
PASS=$((PASS + 1)); printf 'PASS EXACT ENROLLMENT / HARDWARE HOLD\n'

mutate() { sed "$1" "$OBS" >"$2"; }
mutate 's/TEAM42/OTHERTEAM/' "$TMP/team"; expect_hold "TEAM ID" "$TMP/team"
mutate 's/chatgpt.site.kernelpanic888.i3.l14/other.bundle/' "$TMP/id"; expect_hold "SIGNING IDENTIFIER" "$TMP/id"
mutate "s/$(d 2)/$(d 6)/" "$TMP/dr"; expect_hold "DESIGNATED REQUIREMENT" "$TMP/dr"
mutate "s/$(d 3)/$(d 7)/" "$TMP/profile"; expect_hold "PROFILE DIGEST" "$TMP/profile"
mutate "s/$(d 4)/$(d 8)/" "$TMP/entitlements"; expect_hold "ENTITLEMENTS DIGEST" "$TMP/entitlements"
mutate 's/TEAM42.chatgpt.site.kernelpanic888.i3.l14/TEAM42.other.group/' "$TMP/group"; expect_hold "KEYCHAIN GROUP" "$TMP/group"
mutate "s/$(d 5)/$(d 9)/" "$TMP/helper"; expect_hold "HELPER DIGEST" "$TMP/helper"
mutate 's/|true|true|true|true|true$/|false|true|true|true|true/' "$TMP/apple"; expect_hold "APPLE CHAIN" "$TMP/apple"
mutate 's/|true|true|true|true|true$/|true|false|true|true|true/' "$TMP/signature"; expect_hold "SIGNATURE" "$TMP/signature"
mutate 's/|true|true|true|true|true$/|true|true|false|true|true/' "$TMP/auth"; expect_hold "PROFILE AUTHORIZATION" "$TMP/auth"
mutate 's/|true|true|true|true|true$/|true|true|true|false|true/' "$TMP/effective"; expect_hold "EFFECTIVE ENTITLEMENTS" "$TMP/effective"
mutate 's/|true|true|true|true|true$/|true|true|true|true|false/' "$TMP/runtime"; expect_hold "HARDENED RUNTIME" "$TMP/runtime"
expect_hold "EXPIRED OBSERVATION" "$OBS" 131

[[ "$PASS" -eq 14 ]] || { printf 'FAIL expected 14 scenarios, got %s\n' "$PASS"; exit 1; }
printf 'I3 TRUSTED PLATFORM ENROLLMENT BLIND AUDIT: %s/14 PASS\n' "$PASS"
