#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${1:-$ROOT/.build/I3SecureEnclave.app}"
IDENTITY="${I3_APP_SIGNING_IDENTITY:?set I3_APP_SIGNING_IDENTITY to a trusted Apple Development identity}"
PROFILE="${I3_PROVISIONING_PROFILE:?set I3_PROVISIONING_PROFILE to an authorized macOS provisioning profile}"
TEAM_ID="${I3_TEAM_ID:?set I3_TEAM_ID to the profile team identifier}"
APP_ID="${I3_APP_IDENTIFIER:-chatgpt.site.kernelpanic888.i3.l14}"
CONTENTS="$OUT/Contents"
BIN="$CONTENTS/MacOS/i3-secure-enclave"
ENTITLEMENTS="$CONTENTS/i3-secure-enclave.entitlements.plist"

[[ -f "$PROFILE" ]] || { printf 'HOLD | provisioning profile not found\n' >&2; exit 3; }

mkdir -p "$CONTENTS/MacOS"
cat > "$CONTENTS/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>CFBundleExecutable</key><string>i3-secure-enclave</string>
  <key>CFBundleIdentifier</key><string>$APP_ID</string>
  <key>CFBundleName</key><string>I3SecureEnclave</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>0.1.0</string>
  <key>CFBundleVersion</key><string>1</string>
</dict></plist>
PLIST
cat > "$ENTITLEMENTS" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>com.apple.application-identifier</key><string>$TEAM_ID.$APP_ID</string>
  <key>keychain-access-groups</key><array><string>$TEAM_ID.$APP_ID</string></array>
</dict></plist>
PLIST

cp "$PROFILE" "$CONTENTS/embedded.provisionprofile"
xcrun clang -fobjc-arc -fmodules-cache-path="${TMPDIR:-/tmp}/i3-module-cache" \
  "$ROOT/scripts/i3_secure_enclave_bridge.m" \
  -o "$BIN" -framework Foundation -framework Security
codesign --force --sign "$IDENTITY" --options runtime \
  --entitlements "$ENTITLEMENTS" "$OUT"
codesign --verify --deep --strict "$OUT"
printf 'SIGNED_APP=%s\nHELPER=%s\n' "$OUT" "$BIN"
