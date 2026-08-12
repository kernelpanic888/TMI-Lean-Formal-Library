#!/usr/bin/env bash
set -euo pipefail

APP="${1:?app wrapper required}"
L14_POLICY="${2:?L14 policy required}"
POLICY_ID="${3:?L15 policy id required}"
OBSERVED_AT="${4:?observation time required}"
OUT="${5:?observation output required}"
OPENSSL="${OPENSSL:-/opt/homebrew/bin/openssl}"

hold() { printf 'HOLD | %s\n' "$1" >&2; exit 3; }
digest_file() { "$OPENSSL" dgst -sha256 -r "$1" | awk '{print $1}'; }

[[ -d "$APP" ]] || hold "app wrapper unavailable"
[[ -f "$L14_POLICY" ]] || hold "L14 policy unavailable"
CONTENTS="$APP/Contents"
INFO="$CONTENTS/Info.plist"
PROFILE="$CONTENTS/embedded.provisionprofile"
[[ -f "$INFO" && -f "$PROFILE" ]] || hold "bundle metadata or profile unavailable"

EXECUTABLE="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleExecutable' "$INFO" 2>/dev/null)" || hold "bundle executable missing"
HELPER="$CONTENTS/MacOS/$EXECUTABLE"
[[ -x "$HELPER" ]] || hold "bundle helper unavailable"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
CODESIGN_INFO="$TMP/codesign.txt"
REQUIREMENT="$TMP/requirement.txt"
ENTITLEMENTS="$TMP/entitlements.plist"
PROFILE_PLIST="$TMP/profile.plist"

codesign --verify --deep --strict "$APP" || hold "code signature invalid"
codesign -d -vvv "$APP" 2>"$CODESIGN_INFO" || hold "signing metadata unavailable"
codesign -d -r- "$APP" 2>"$REQUIREMENT" || hold "designated requirement unavailable"
codesign -d --entitlements :- "$APP" >"$ENTITLEMENTS" 2>/dev/null || hold "effective entitlements unavailable"
security cms -D -i "$PROFILE" >"$PROFILE_PLIST" || hold "provisioning profile cannot be decoded"

TEAM_ID="$(sed -n 's/^TeamIdentifier=//p' "$CODESIGN_INFO" | head -n1)"
SIGNING_ID="$(sed -n 's/^Identifier=//p' "$CODESIGN_INFO" | head -n1)"
[[ -n "$TEAM_ID" && -n "$SIGNING_ID" ]] || hold "Team ID or signing identifier missing"

KEYCHAIN_GROUP="$(/usr/libexec/PlistBuddy -c 'Print :keychain-access-groups:0' "$ENTITLEMENTS" 2>/dev/null)" || hold "effective keychain group missing"
PROFILE_TEAM="$(/usr/libexec/PlistBuddy -c 'Print :TeamIdentifier:0' "$PROFILE_PLIST" 2>/dev/null)" || hold "profile Team ID missing"
PROFILE_APP_ID="$(/usr/libexec/PlistBuddy -c 'Print :Entitlements:application-identifier' "$PROFILE_PLIST" 2>/dev/null)" || hold "profile application identifier missing"
PROFILE_GROUP="$(/usr/libexec/PlistBuddy -c 'Print :Entitlements:keychain-access-groups:0' "$PROFILE_PLIST" 2>/dev/null)" || hold "profile keychain group missing"
EFFECTIVE_APP_ID="$(/usr/libexec/PlistBuddy -c 'Print :com.apple.application-identifier' "$ENTITLEMENTS" 2>/dev/null)" || hold "effective application identifier missing"

APPLE_OK=false
if codesign --verify --deep --strict -R "anchor apple generic and certificate leaf[subject.OU] = \"$TEAM_ID\" and identifier \"$SIGNING_ID\"" "$APP" >/dev/null 2>&1; then APPLE_OK=true; fi
PROFILE_OK=false
if [[ "$PROFILE_TEAM" == "$TEAM_ID" && "$PROFILE_APP_ID" == "$TEAM_ID.$SIGNING_ID" && "$PROFILE_GROUP" == "$KEYCHAIN_GROUP" ]]; then PROFILE_OK=true; fi
ENTITLEMENTS_OK=false
if [[ "$EFFECTIVE_APP_ID" == "$TEAM_ID.$SIGNING_ID" && "$KEYCHAIN_GROUP" == "$TEAM_ID.$SIGNING_ID" ]]; then ENTITLEMENTS_OK=true; fi
RUNTIME_OK=false
if grep -Eq 'flags=.*runtime' "$CODESIGN_INFO"; then RUNTIME_OK=true; fi

L14_DIGEST="$(digest_file "$L14_POLICY")"
REQUIREMENT_DIGEST="$(digest_file "$REQUIREMENT")"
PROFILE_DIGEST="$(digest_file "$PROFILE")"
ENTITLEMENTS_DIGEST="$(digest_file "$ENTITLEMENTS")"
HELPER_DIGEST="$(digest_file "$HELPER")"

printf 'I3TPEO1|1|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|true|%s|%s|%s\n' \
  "$POLICY_ID" "$L14_DIGEST" "$TEAM_ID" "$SIGNING_ID" \
  "$REQUIREMENT_DIGEST" "$PROFILE_DIGEST" "$ENTITLEMENTS_DIGEST" \
  "$KEYCHAIN_GROUP" "$HELPER_DIGEST" "$OBSERVED_AT" "$APPLE_OK" \
  "$PROFILE_OK" "$ENTITLEMENTS_OK" "$RUNTIME_OK" >"$OUT"
printf 'PLATFORM OBSERVATION READY | %s\n' "$OUT"
