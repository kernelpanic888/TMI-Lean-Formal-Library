#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

I3="$ROOT/.lake/build/bin/i3_physical"
HELPER="${I3_SECURE_ENCLAVE_HELPER:-}"
TAG="chatgpt.site.kernelpanic888.i3.l14.local-hardware.dpk.v1"
PUB="$TMP/hardware-public.bin"
POLICY="$TMP/physical.policy"
CHALLENGE="$TMP/challenge.i3phc"
SIG="$TMP/challenge.sig"
RECEIPT="$TMP/local.i3phr"
BASE="$TMP/l13.certificate"
PASS=0

if [[ -z "$HELPER" ]]; then
  if [[ -n "${I3_APP_SIGNING_IDENTITY:-}" && -n "${I3_PROVISIONING_PROFILE:-}" && -n "${I3_TEAM_ID:-}" ]]; then
    APP="$TMP/I3SecureEnclave.app"
    "$ROOT/scripts/build_i3_secure_enclave_app.sh" "$APP" >/dev/null
    HELPER="$APP/Contents/MacOS/i3-secure-enclave"
  else
    printf 'HOLD | trusted app signature and authorized provisioning profile required\n' >&2
    printf 'Set I3_APP_SIGNING_IDENTITY, I3_PROVISIONING_PROFILE and I3_TEAM_ID, or I3_SECURE_ENCLAVE_HELPER.\n' >&2
    exit 3
  fi
fi
[[ -x "$HELPER" ]] || { printf 'HOLD | signed helper unavailable\n' >&2; exit 3; }
codesign --verify --strict "$HELPER"

printf 'I3HAC1|1|i3-l13|2|base|hardware|v1,v2|d1,d2|a1,a2\n' > "$BASE"
BASE_DIGEST="$(/opt/homebrew/bin/openssl dgst -sha256 -r "$BASE" | awk '{print $1}')"
"$HELPER" ensure "$TAG" "$PUB" >/dev/null
PUB_DIGEST="$(/opt/homebrew/bin/openssl dgst -sha256 -r "$PUB" | awk '{print $1}')"

cat > "$POLICY" <<EOF
I3PHP1|1|i3-l14-local|i3-l13|$BASE_DIGEST|30|2
PROFILE|witness-local|node-local|apple-silicon|apple-secure-enclave|i3-l14-key|local-owner|$PUB_DIGEST
EOF

CHALLENGE_ID="$(printf '%064d' 0)"
"$I3" issue "$POLICY" "$CHALLENGE_ID" 100 30 "$CHALLENGE" >/dev/null
"$I3" sign "$HELPER" "$TAG" "$CHALLENGE" "$SIG" "$PUB" >/dev/null

expect_hold() {
  local label="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    printf 'FAIL %s\n' "$label"
    exit 1
  else
    PASS=$((PASS + 1))
    printf 'PASS %s\n' "$label"
  fi
}

GOOD_OUTPUT="$("$I3" verify-local "$HELPER" "$TAG" "$POLICY" "$CHALLENGE" \
  "$SIG" "$PUB" "$RECEIPT" 110)"
if [[ "$GOOD_OUTPUT" == *"LOCAL HARDWARE PASS"* && \
      "$GOOD_OUTPUT" == *"GLOBAL HARDWARE ADMISSION=HOLD"* ]]; then
  PASS=$((PASS + 1))
  printf 'PASS REAL SECURE ENCLAVE LOCAL PASS / GLOBAL HOLD\n'
else
  printf 'FAIL REAL SECURE ENCLAVE LOCAL PASS / GLOBAL HOLD\n'
  exit 1
fi

cp "$POLICY" "$TMP/changed-base.policy"
sed -i '' "s/$BASE_DIGEST/$(printf 'f%.0s' {1..64})/" "$TMP/changed-base.policy"
expect_hold "CHANGED L13 DIGEST" "$I3" verify-local "$HELPER" "$TAG" \
  "$TMP/changed-base.policy" "$CHALLENGE" "$SIG" "$PUB" "$TMP/a" 110

expect_hold "EXPIRED CHALLENGE" "$I3" verify-local "$HELPER" "$TAG" \
  "$POLICY" "$CHALLENGE" "$SIG" "$PUB" "$TMP/b" 131

cp "$CHALLENGE" "$TMP/changed-nonce.challenge"
sed -i '' "s/$BASE_DIGEST/$(printf 'e%.0s' {1..64})/g" "$TMP/changed-nonce.challenge"
expect_hold "CHANGED NONCE" "$I3" verify-local "$HELPER" "$TAG" \
  "$POLICY" "$TMP/changed-nonce.challenge" "$SIG" "$PUB" "$TMP/c" 110

printf 'invalid-signature' > "$TMP/invalid.sig"
expect_hold "INVALID SIGNATURE" "$I3" verify-local "$HELPER" "$TAG" \
  "$POLICY" "$CHALLENGE" "$TMP/invalid.sig" "$PUB" "$TMP/d" 110

cp "$POLICY" "$TMP/changed-platform.policy"
sed -i '' 's/apple-silicon/other-platform/' "$TMP/changed-platform.policy"
expect_hold "CHANGED PLATFORM POLICY" "$I3" verify-local "$HELPER" "$TAG" \
  "$TMP/changed-platform.policy" "$CHALLENGE" "$SIG" "$PUB" "$TMP/e" 110

cp "$POLICY" "$TMP/wrong-public.policy"
sed -i '' "s/$PUB_DIGEST/$(printf 'd%.0s' {1..64})/" "$TMP/wrong-public.policy"
expect_hold "WRONG PUBLIC KEY DIGEST" "$I3" verify-local "$HELPER" "$TAG" \
  "$TMP/wrong-public.policy" "$CHALLENGE" "$SIG" "$PUB" "$TMP/f" 110

expect_hold "WRONG HARDWARE KEY HANDLE" "$I3" verify-local "$HELPER" \
  "chatgpt.site.kernelpanic888.i3.l14.other-key" "$POLICY" "$CHALLENGE" \
  "$SIG" "$PUB" "$TMP/g" 110

"$I3" issue "$POLICY" "$(printf '1%.0s' {1..64})" 120 10 "$TMP/future.challenge" >/dev/null
"$I3" sign "$HELPER" "$TAG" "$TMP/future.challenge" "$TMP/future.sig" "$PUB" >/dev/null
expect_hold "FUTURE CHALLENGE" "$I3" verify-local "$HELPER" "$TAG" \
  "$POLICY" "$TMP/future.challenge" "$TMP/future.sig" "$PUB" "$TMP/h" 110

if [[ "$PASS" -ne 9 ]]; then
  printf 'FAIL expected 9 scenarios, got %s\n' "$PASS"
  exit 1
fi

printf 'I3 PHYSICAL HARDWARE BLIND AUDIT: %s/9 PASS\n' "$PASS"
