#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="${I3_BIN_DIR:-$REPO_ROOT/.lake/build/bin}"
OPENSSL="${OPENSSL_BIN:-/opt/homebrew/bin/openssl}"
ROOT="$(mktemp -d /tmp/i3-l09-blind.XXXXXX)"
trap 'rm -rf "$ROOT"' EXIT

manifest="$(printf 'a%.0s' {1..64})"
trust="$ROOT/trust.head"
store="$ROOT/store.head"

"$BIN/i3_trust" init "$trust" "$manifest" 109 1 209 >/dev/null
"$BIN/i3_trust_tx" init "$store" "$trust" >/dev/null

for witness in a b c; do
  "$OPENSSL" genpkey -algorithm ED25519 \
    -out "$ROOT/$witness.private.pem" >/dev/null 2>&1
  "$OPENSSL" pkey -in "$ROOT/$witness.private.pem" -pubout \
    -out "$ROOT/$witness.public.pem" >/dev/null 2>&1
  "$BIN/i3_witness" init "$ROOT/witness-$witness" "$store" \
    "witness-$witness" >/dev/null
done

cat > "$ROOT/policy.i3qp" <<EOF
I3QPOL1|1|primary-2of3|2
MEMBER|witness-a|key-a|$ROOT/a.public.pem
MEMBER|witness-b|key-b|$ROOT/b.public.pem
MEMBER|witness-c|key-c|$ROOT/c.public.pem
EOF

mkdir "$ROOT/valid" "$ROOT/under" "$ROOT/duplicate" "$ROOT/conflict"
"$BIN/i3_quorum" vote primary-2of3 9 "$ROOT/witness-a" key-a \
  "$ROOT/a.private.pem" "$ROOT/valid/a.i3qv" "$ROOT/valid/a.i3qv.sig" >/dev/null
"$BIN/i3_quorum" vote primary-2of3 9 "$ROOT/witness-b" key-b \
  "$ROOT/b.private.pem" "$ROOT/valid/b.i3qv" "$ROOT/valid/b.i3qv.sig" >/dev/null

cp "$ROOT/valid/a.i3qv" "$ROOT/under/a.i3qv"
cp "$ROOT/valid/a.i3qv.sig" "$ROOT/under/a.i3qv.sig"

cp "$ROOT/valid/a.i3qv" "$ROOT/duplicate/a.i3qv"
cp "$ROOT/valid/a.i3qv.sig" "$ROOT/duplicate/a.i3qv.sig"
cp "$ROOT/valid/a.i3qv" "$ROOT/duplicate/a-copy.i3qv"
cp "$ROOT/valid/a.i3qv.sig" "$ROOT/duplicate/a-copy.i3qv.sig"

cp "$ROOT/valid/a.i3qv" "$ROOT/conflict/a.i3qv"
cp "$ROOT/valid/a.i3qv.sig" "$ROOT/conflict/a.i3qv.sig"
conflict_head="$(printf 'f%.0s' {1..64})"
sed -e 's/witness-a|key-a/witness-c|key-c/' \
  -e "s/|0|[^|]*|/|0|$conflict_head|/" \
  "$ROOT/valid/a.i3qv" > "$ROOT/conflict/c.i3qv"
"$OPENSSL" pkeyutl -sign -rawin -inkey "$ROOT/c.private.pem" \
  -in "$ROOT/conflict/c.i3qv" -out "$ROOT/conflict/c.i3qv.sig" >/dev/null 2>&1

printf '01 VALID 2/3: '
"$BIN/i3_quorum" admit "$ROOT/policy.i3qp" "$store" 9 \
  "$ROOT/valid" "$ROOT/quorum.cert" >/dev/null
"$BIN/i3_quorum" verify "$ROOT/policy.i3qp" "$store" 9 \
  "$ROOT/valid" "$ROOT/quorum.cert" >/dev/null
echo 'ADMIT + CERTIFICATE VERIFIED'

expect_hold() {
  local label="$1" directory="$2" certificate="$3"
  set +e
  "$BIN/i3_quorum" admit "$ROOT/policy.i3qp" "$store" 9 \
    "$directory" "$certificate" >/dev/null 2>&1
  local result=$?
  set -e
  if [[ "$result" -ne 2 || -e "$certificate" ]]; then
    echo "$label: FAIL"
    exit 1
  fi
  echo "$label: HOLD"
}

expect_hold '02 INSUFFICIENT 1/3' "$ROOT/under" "$ROOT/under.cert"
expect_hold '03 DUPLICATE IDENTITY' "$ROOT/duplicate" "$ROOT/duplicate.cert"
expect_hold '04 CONFLICTING HEAD' "$ROOT/conflict" "$ROOT/conflict.cert"

cp "$ROOT/quorum.cert" "$ROOT/tampered.cert"
sed -i.bak 's/witness-a/witness-x/' "$ROOT/tampered.cert"
set +e
"$BIN/i3_quorum" verify "$ROOT/policy.i3qp" "$store" 9 \
  "$ROOT/valid" "$ROOT/tampered.cert" >/dev/null 2>&1
tamper_result=$?
set -e
if [[ "$tamper_result" -ne 2 ]]; then
  echo "05 TAMPERED CERTIFICATE: FAIL"
  exit 1
fi
echo '05 TAMPERED CERTIFICATE: HOLD'

if grep -R -l 'PRIVATE KEY' "$ROOT/valid" "$ROOT/under" \
    "$ROOT/duplicate" "$ROOT/conflict" "$ROOT/quorum.cert" >/dev/null; then
  echo '06 PRIVATE KEY BOUNDARY: FAIL'
  exit 1
fi
echo '06 PRIVATE KEY BOUNDARY: NO PRIVATE KEY IN VOTE/CERT CORPUS'
echo 'BLIND AUDIT: 6/6 PASS'
