#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="${I3_BIN_DIR:-$REPO_ROOT/.lake/build/bin}"
OPENSSL="${OPENSSL_BIN:-/opt/homebrew/bin/openssl}"
ROOT="$(mktemp -d /tmp/i3-l11-blind.XXXXXX)"
trap 'rm -rf "$ROOT"' EXIT

manifest="$(printf 'c%.0s' {1..64})"
peer_a="$(printf '1%.0s' {1..64})"
peer_b="$(printf '2%.0s' {1..64})"
peer_c="$(printf '3%.0s' {1..64})"
trust="$ROOT/trust.head"
store="$ROOT/store.head"

"$BIN/i3_trust" init "$trust" "$manifest" 111 1 211 >/dev/null
"$BIN/i3_trust_tx" init "$store" "$trust" >/dev/null

"$OPENSSL" genpkey -algorithm ED25519 -out "$ROOT/verifier.private.pem" >/dev/null 2>&1
"$OPENSSL" pkey -in "$ROOT/verifier.private.pem" -pubout -out "$ROOT/verifier.public.pem" >/dev/null 2>&1
for witness in a b c; do
  "$OPENSSL" genpkey -algorithm ED25519 -out "$ROOT/$witness.private.pem" >/dev/null 2>&1
  "$OPENSSL" pkey -in "$ROOT/$witness.private.pem" -pubout -out "$ROOT/$witness.public.pem" >/dev/null 2>&1
  "$BIN/i3_witness" init "$ROOT/witness-$witness" "$store" "witness-$witness" >/dev/null
done

cat > "$ROOT/policy.i3rp" <<EOF
I3RPOL1|1|remote-2of3|2|verifier-main|verifier-key|$ROOT/verifier.public.pem|60
MEMBER|witness-a|key-a|$ROOT/a.public.pem|admin-a|network-a|host-a|endpoint-a|https://a.invalid/i3|$peer_a
MEMBER|witness-b|key-b|$ROOT/b.public.pem|admin-b|network-b|host-b|endpoint-b|https://b.invalid/i3|$peer_b
MEMBER|witness-c|key-c|$ROOT/c.public.pem|admin-c|network-c|host-c|endpoint-c|https://c.invalid/i3|$peer_c
EOF

issue() {
  local name="$1" witness="$2" issued="$3" ttl="$4" idchar="$5"
  local id; id="$(printf "$idchar%.0s" {1..64})"
  "$BIN/i3_remote_witness" challenge "$ROOT/policy.i3rp" "$store" "$witness" 11 \
    "$issued" "$ttl" "$id" "$ROOT/verifier.private.pem" \
    "$ROOT/$name.i3ch" "$ROOT/$name.i3ch.sig" >/dev/null
}
respond() {
  local name="$1" witness="$2" now="$3" key="$4"
  "$BIN/i3_remote_witness" respond "$ROOT/policy.i3rp" "$ROOT/$name.i3ch" \
    "$ROOT/$name.i3ch.sig" "$now" "$ROOT/witness-$witness" "$ROOT/$key.private.pem" \
    "$ROOT/$name.i3rsp" "$ROOT/$name.i3rsp.sig" >/dev/null
}
verify() {
  local name="$1" ledger="$2" now="$3"
  "$BIN/i3_remote_witness" verify "$ROOT/policy.i3rp" "$store" "$ROOT/$name.i3ch" \
    "$ROOT/$name.i3ch.sig" "$ROOT/$name.i3rsp" "$ROOT/$name.i3rsp.sig" \
    "$ROOT/$ledger" "$ROOT/$name.i3rr" "$now"
}

issue valid witness-a 1000 60 a
respond valid a 1001 a
printf '01 FRESH PINNED RESPONSE: '
verify valid ledger-valid 1002 | grep -q 'FRESH REMOTE RESPONSE VERIFIED'
echo 'VERIFIED'

printf '02 REPLAY SAME CHALLENGE: '
if verify valid ledger-valid 1003 >/dev/null 2>&1; then exit 1; fi
echo 'HOLD'

issue expired witness-a 2000 10 b
respond expired a 2001 a
printf '03 EXPIRED CHALLENGE: '
if verify expired ledger-expired 2011 >/dev/null 2>&1; then exit 1; fi
echo 'HOLD'

issue future witness-a 3000 20 c
printf '04 FUTURE CHALLENGE: '
if "$BIN/i3_remote_witness" respond "$ROOT/policy.i3rp" "$ROOT/future.i3ch" \
    "$ROOT/future.i3ch.sig" 2999 "$ROOT/witness-a" "$ROOT/a.private.pem" \
    "$ROOT/future.i3rsp" "$ROOT/future.i3rsp.sig" >/dev/null 2>&1; then exit 1; fi
echo 'HOLD'

for variant in endpoint peer anchor; do
  issue "$variant" witness-a 4000 60 "${variant:0:1}"
  respond "$variant" a 4001 a
done
sed -i.bak 's/|endpoint-a|/|endpoint-z|/' "$ROOT/endpoint.i3rsp" && rm "$ROOT/endpoint.i3rsp.bak"
"$OPENSSL" pkeyutl -sign -rawin -inkey "$ROOT/a.private.pem" -in "$ROOT/endpoint.i3rsp" -out "$ROOT/endpoint.i3rsp.sig"
printf '05 REDIRECTED ENDPOINT: '
if verify endpoint ledger-endpoint 4002 >/dev/null 2>&1; then exit 1; fi
echo 'HOLD'

sed -i.bak "s/$peer_a/$peer_b/" "$ROOT/peer.i3rsp" && rm "$ROOT/peer.i3rsp.bak"
"$OPENSSL" pkeyutl -sign -rawin -inkey "$ROOT/a.private.pem" -in "$ROOT/peer.i3rsp" -out "$ROOT/peer.i3rsp.sig"
printf '06 CHANGED TLS PEER: '
if verify peer ledger-peer 4002 >/dev/null 2>&1; then exit 1; fi
echo 'HOLD'

bad_head="$(printf 'f%.0s' {1..64})"
sed -i.bak "s/|0|[^|]*|[^|]*$/|0|$bad_head|$bad_head/" "$ROOT/anchor.i3rsp" && rm "$ROOT/anchor.i3rsp.bak"
"$OPENSSL" pkeyutl -sign -rawin -inkey "$ROOT/a.private.pem" -in "$ROOT/anchor.i3rsp" -out "$ROOT/anchor.i3rsp.sig"
printf '07 CONFLICTING REMOTE ANCHOR: '
if verify anchor ledger-anchor 4002 >/dev/null 2>&1; then exit 1; fi
echo 'HOLD'

issue badchallenge witness-a 5000 60 d
printf 'X' >> "$ROOT/badchallenge.i3ch.sig"
printf '08 TAMPERED CHALLENGE SIGNATURE: '
if "$BIN/i3_remote_witness" respond "$ROOT/policy.i3rp" "$ROOT/badchallenge.i3ch" \
    "$ROOT/badchallenge.i3ch.sig" 5001 "$ROOT/witness-a" "$ROOT/a.private.pem" \
    "$ROOT/badchallenge.i3rsp" "$ROOT/badchallenge.i3rsp.sig" >/dev/null 2>&1; then exit 1; fi
echo 'HOLD'

issue badresponse witness-a 6000 60 e
respond badresponse a 6001 a
printf 'X' >> "$ROOT/badresponse.i3rsp.sig"
printf '09 TAMPERED RESPONSE SIGNATURE: '
if verify badresponse ledger-badresponse 6002 >/dev/null 2>&1; then exit 1; fi
echo 'HOLD'

issue changedpolicy witness-a 7000 60 f
respond changedpolicy a 7001 a
cp "$ROOT/policy.i3rp" "$ROOT/original-policy.i3rp"
sed -i.bak 's/endpoint-a/endpoint-z/' "$ROOT/policy.i3rp" && rm "$ROOT/policy.i3rp.bak"
printf '10 POLICY CHANGED AFTER CHALLENGE: '
if verify changedpolicy ledger-policy 7002 >/dev/null 2>&1; then exit 1; fi
mv "$ROOT/original-policy.i3rp" "$ROOT/policy.i3rp"
echo 'HOLD'

if rg -n --hidden --glob '!*.private.pem' --glob '!*.public.pem' \
    'BEGIN (OPENSSH |EC |RSA |DSA )?PRIVATE KEY' "$ROOT" >/dev/null; then
  echo 'PRIVATE KEY LEAK: FAIL'
  exit 1
fi

echo 'BLIND AUDIT: 10/10 PASS'
