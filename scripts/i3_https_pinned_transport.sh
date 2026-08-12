#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 7 ]]; then
  echo "usage: i3_https_pinned_transport.sh <https-url> <tls-spki-sha256-hex> <challenge> <challenge-signature> <response> <response-signature> <timeout-seconds>" >&2
  exit 64
fi

url="$1"
peer_hex="$2"
challenge="$3"
challenge_sig="$4"
response="$5"
response_sig="$6"
timeout="$7"

[[ "$url" == https://* ]] || { echo "HOLD: HTTPS required" >&2; exit 2; }
[[ "$peer_hex" =~ ^[0-9a-fA-F]{64}$ ]] || { echo "HOLD: invalid peer digest" >&2; exit 2; }
[[ "$timeout" =~ ^[1-9][0-9]*$ ]] || { echo "HOLD: invalid timeout" >&2; exit 2; }

OPENSSL="${OPENSSL_BIN:-/opt/homebrew/bin/openssl}"
headers="$(mktemp /tmp/i3-remote-headers.XXXXXX)"
body="$(mktemp /tmp/i3-remote-body.XXXXXX)"
trap 'rm -f "$headers" "$body"' EXIT

pin_b64="$(printf '%s' "$peer_hex" | xxd -r -p | "$OPENSSL" base64 -A)"
challenge_sig_b64="$("$OPENSSL" base64 -A -in "$challenge_sig")"

curl --fail-with-body --silent --show-error \
  --proto '=https' --tlsv1.3 --max-time "$timeout" \
  --pinnedpubkey "sha256//$pin_b64" \
  --request POST --header 'Content-Type: application/octet-stream' \
  --header "X-I3-Challenge-Signature: $challenge_sig_b64" \
  --data-binary "@$challenge" --dump-header "$headers" --output "$body" "$url"

sig_b64="$(awk 'BEGIN{IGNORECASE=1} /^X-I3-Response-Signature:/ {sub(/^[^:]*:[[:space:]]*/,""); sub(/\r$/,""); print}' "$headers" | tail -n 1)"
[[ -n "$sig_b64" ]] || { echo "HOLD: missing response signature" >&2; exit 2; }

cp "$body" "$response"
printf '%s' "$sig_b64" | "$OPENSSL" base64 -d -A > "$response_sig"
echo "PINNED HTTPS RESPONSE RECEIVED"
