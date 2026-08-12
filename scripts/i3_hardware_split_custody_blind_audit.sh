#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="${I3_BIN_DIR:-$REPO_ROOT/.lake/build/bin}"
OPENSSL="${OPENSSL_BIN:-/opt/homebrew/bin/openssl}"
ROOT="$(mktemp -d /tmp/i3-l13-blind.XXXXXX)"
trap 'rm -rf "$ROOT"' EXIT

hex() { printf "$1%.0s" {1..64}; }
digest() { "$OPENSSL" dgst -sha256 "$1" | awk '{print $NF}'; }
sign() { "$OPENSSL" pkeyutl -sign -rawin -inkey "$1" -in "$2" -out "$3"; }
expect_hold() { if "$@" >/dev/null 2>&1; then exit 1; fi; }

manifest="$(hex c)"; peer="$(hex 1)"; boot="$(hex b)"; runtime="$(hex d)"
raw_quote="$(hex 4)"; pcr="$(hex 5)"; eventlog="$(hex 6)"; firmware="$(hex 7)"
trust="$ROOT/trust.head"; store="$ROOT/store.head"

for key in base witness attest observer platform split-a split-b split-c; do
  "$OPENSSL" genpkey -algorithm ED25519 -out "$ROOT/$key.private.pem" >/dev/null 2>&1
  "$OPENSSL" pkey -in "$ROOT/$key.private.pem" -pubout -out "$ROOT/$key.public.pem" >/dev/null 2>&1
done

"$BIN/i3_trust" init "$trust" "$manifest" 111 1 211 >/dev/null
"$BIN/i3_trust_tx" init "$store" "$trust" >/dev/null
"$BIN/i3_witness" init "$ROOT/witness" "$store" witness-a >/dev/null

cat > "$ROOT/remote.i3rp" <<EOF
I3RPOL1|1|remote-one|1|base-verifier|base-key|$ROOT/base.public.pem|60
MEMBER|witness-a|witness-key|$ROOT/witness.public.pem|admin-a|network-a|host-a|endpoint-a|https://a.invalid/i3|$peer
EOF
cat > "$ROOT/l12.i3ap" <<EOF
I3APOL1|1|l12-policy|base-verifier|$ROOT/base.public.pem|60
NODE|witness-a|node-a|custody-a|attest-key|$ROOT/attest.public.pem|observer-a|observer-custody-a|observer-key|$ROOT/observer.public.pem
EOF

challenge="$(hex a)"
"$BIN/i3_remote_witness" challenge "$ROOT/remote.i3rp" "$store" witness-a 12 1000 60 "$challenge" "$ROOT/base.private.pem" "$ROOT/a.i3ch" "$ROOT/a.i3ch.sig" >/dev/null
"$BIN/i3_remote_witness" respond "$ROOT/remote.i3rp" "$ROOT/a.i3ch" "$ROOT/a.i3ch.sig" 1001 "$ROOT/witness" "$ROOT/witness.private.pem" "$ROOT/a.i3rsp" "$ROOT/a.i3rsp.sig" >/dev/null
"$BIN/i3_remote_witness" verify "$ROOT/remote.i3rp" "$store" "$ROOT/a.i3ch" "$ROOT/a.i3ch.sig" "$ROOT/a.i3rsp" "$ROOT/a.i3rsp.sig" "$ROOT/ledger" "$ROOT/a.i3rr" 1002 >/dev/null
"$BIN/i3_attestation" attest "$ROOT/l12.i3ap" "$ROOT/a.i3rr" 1003 30 "$boot" "$runtime" "$ROOT/attest.private.pem" "$ROOT/a.i3na" "$ROOT/a.i3na.sig" >/dev/null
"$BIN/i3_attestation" observe "$ROOT/l12.i3ap" "$ROOT/a.i3rr" 1004 "$ROOT/observer.private.pem" "$ROOT/a.i3to" "$ROOT/a.i3to.sig" >/dev/null
"$BIN/i3_attestation" verify "$ROOT/l12.i3ap" "$ROOT/a.i3rr" "$ROOT/a.i3na" "$ROOT/a.i3na.sig" "$ROOT/a.i3to" "$ROOT/a.i3to.sig" "$ROOT/base.private.pem" "$ROOT/base.i3ae" "$ROOT/base.i3ae.sig" 1005 >/dev/null

cat > "$ROOT/hardware.i3hp" <<EOF
I3HPOL1|1|hardware-2of3|l12-policy|30|2|$ROOT/base.public.pem
HARDWARE|witness-a|node-a|platform-a|root-a|platform-verifier-a|platform-custody|$ROOT/platform.public.pem
VERIFIER|split-a|verifier-custody-a|$ROOT/split-a.public.pem
VERIFIER|split-b|verifier-custody-b|$ROOT/split-b.public.pem
VERIFIER|split-c|verifier-custody-c|$ROOT/split-c.public.pem
EOF

base_digest="$(digest "$ROOT/base.i3ae")"
cat > "$ROOT/platform.i3hqr" <<EOF
I3HQR1|1|hardware-2of3|$base_digest|witness-a|node-a|platform-a|root-a|platform-verifier-a|platform-custody|$base_digest|$raw_quote|$pcr|$eventlog|$firmware|1006|1036|true|true|true
EOF
sign "$ROOT/platform.private.pem" "$ROOT/platform.i3hqr" "$ROOT/platform.i3hqr.sig"

printf '01 VERIFIED PLATFORM RECEIPT: '
"$BIN/i3_hardware" verify "$ROOT/hardware.i3hp" "$ROOT/base.i3ae" "$ROOT/base.i3ae.sig" "$ROOT/platform.i3hqr" "$ROOT/platform.i3hqr.sig" 1007 | grep -q 'HARDWARE EVIDENCE VERIFIED'; echo VERIFIED

mkdir "$ROOT/good"
for v in a b; do
  "$BIN/i3_hardware" approve "$ROOT/hardware.i3hp" "$ROOT/base.i3ae" "$ROOT/base.i3ae.sig" "$ROOT/platform.i3hqr" "$ROOT/platform.i3hqr.sig" 1007 "split-$v" "$ROOT/split-$v.private.pem" "$ROOT/good/$v.i3hs" "$ROOT/good/$v.i3hs.sig" >/dev/null
done
printf '02 TWO-OF-THREE SPLIT CUSTODY: '
"$BIN/i3_hardware" quorum "$ROOT/hardware.i3hp" "$ROOT/base.i3ae" "$ROOT/base.i3ae.sig" "$ROOT/platform.i3hqr" "$ROOT/platform.i3hqr.sig" 1007 "$ROOT/good" "$ROOT/good.i3hac" | grep -q 'HARDWARE-BOUND SPLIT QUORUM'; echo ADMITTED

printf '03 UNSIGNED PLATFORM RECEIPT: '
expect_hold "$BIN/i3_hardware" verify "$ROOT/hardware.i3hp" "$ROOT/base.i3ae" "$ROOT/base.i3ae.sig" "$ROOT/platform.i3hqr" "$ROOT/a.i3na.sig" 1007; echo HOLD

cp "$ROOT/base.i3ae" "$ROOT/changed-base.i3ae"; printf X >> "$ROOT/changed-base.i3ae"
printf '04 CHANGED L12 RECEIPT: '
expect_hold "$BIN/i3_hardware" verify "$ROOT/hardware.i3hp" "$ROOT/changed-base.i3ae" "$ROOT/base.i3ae.sig" "$ROOT/platform.i3hqr" "$ROOT/platform.i3hqr.sig" 1007; echo HOLD

cp "$ROOT/platform.i3hqr" "$ROOT/bad-nonce.i3hqr"; sed -i.bak "s/|$base_digest|$raw_quote/|$(hex 9)|$raw_quote/" "$ROOT/bad-nonce.i3hqr"; rm "$ROOT/bad-nonce.i3hqr.bak"; sign "$ROOT/platform.private.pem" "$ROOT/bad-nonce.i3hqr" "$ROOT/bad-nonce.i3hqr.sig"
printf '05 CHANGED QUOTE NONCE: '
expect_hold "$BIN/i3_hardware" verify "$ROOT/hardware.i3hp" "$ROOT/base.i3ae" "$ROOT/base.i3ae.sig" "$ROOT/bad-nonce.i3hqr" "$ROOT/bad-nonce.i3hqr.sig" 1007; echo HOLD

printf '06 EXPIRED QUOTE: '
expect_hold "$BIN/i3_hardware" verify "$ROOT/hardware.i3hp" "$ROOT/base.i3ae" "$ROOT/base.i3ae.sig" "$ROOT/platform.i3hqr" "$ROOT/platform.i3hqr.sig" 1037; echo HOLD

for field in 'true|false|true:UNTRUSTED CHAIN' 'true|true|false:REJECTED MEASUREMENTS' 'false|true|true:INVALID QUOTE SIGNATURE'; do
  values="${field%%:*}"; label="${field#*:}"; file="$(printf '%s' "$label" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')"
  cp "$ROOT/platform.i3hqr" "$ROOT/$file.i3hqr"; sed -i.bak "s/|true|true|true$/|$values/" "$ROOT/$file.i3hqr"; rm "$ROOT/$file.i3hqr.bak"; sign "$ROOT/platform.private.pem" "$ROOT/$file.i3hqr" "$ROOT/$file.i3hqr.sig"
  printf '%s: ' "$label"; expect_hold "$BIN/i3_hardware" verify "$ROOT/hardware.i3hp" "$ROOT/base.i3ae" "$ROOT/base.i3ae.sig" "$ROOT/$file.i3hqr" "$ROOT/$file.i3hqr.sig" 1007; echo HOLD
done

mkdir "$ROOT/unsigned"; cp "$ROOT/good/a.i3hs" "$ROOT/unsigned/a.i3hs"; cp "$ROOT/good/a.i3hs.sig" "$ROOT/unsigned/a.i3hs.sig"; cp "$ROOT/good/b.i3hs" "$ROOT/unsigned/b.i3hs"; cp "$ROOT/good/a.i3hs.sig" "$ROOT/unsigned/b.i3hs.sig"
printf '10 INVALID SPLIT SIGNATURE: '
expect_hold "$BIN/i3_hardware" quorum "$ROOT/hardware.i3hp" "$ROOT/base.i3ae" "$ROOT/base.i3ae.sig" "$ROOT/platform.i3hqr" "$ROOT/platform.i3hqr.sig" 1007 "$ROOT/unsigned" "$ROOT/no.i3hac"; echo HOLD

mkdir "$ROOT/duplicate"; cp "$ROOT/good/a.i3hs" "$ROOT/duplicate/a.i3hs"; cp "$ROOT/good/a.i3hs.sig" "$ROOT/duplicate/a.i3hs.sig"; cp "$ROOT/good/a.i3hs" "$ROOT/duplicate/z.i3hs"; cp "$ROOT/good/a.i3hs.sig" "$ROOT/duplicate/z.i3hs.sig"
printf '11 DUPLICATE SPLIT VERIFIER: '
expect_hold "$BIN/i3_hardware" quorum "$ROOT/hardware.i3hp" "$ROOT/base.i3ae" "$ROOT/base.i3ae.sig" "$ROOT/platform.i3hqr" "$ROOT/platform.i3hqr.sig" 1007 "$ROOT/duplicate" "$ROOT/no.i3hac"; echo HOLD

cp "$ROOT/hardware.i3hp" "$ROOT/shared.i3hp"; sed -i.bak 's/verifier-custody-b/verifier-custody-a/' "$ROOT/shared.i3hp"; rm "$ROOT/shared.i3hp.bak"
printf '12 SHARED VERIFIER CUSTODY POLICY: '
expect_hold "$BIN/i3_hardware" quorum "$ROOT/shared.i3hp" "$ROOT/base.i3ae" "$ROOT/base.i3ae.sig" "$ROOT/platform.i3hqr" "$ROOT/platform.i3hqr.sig" 1007 "$ROOT/good" "$ROOT/no.i3hac"; echo HOLD

mkdir "$ROOT/one"; cp "$ROOT/good/a.i3hs" "$ROOT/one/a.i3hs"; cp "$ROOT/good/a.i3hs.sig" "$ROOT/one/a.i3hs.sig"
printf '13 INSUFFICIENT SPLIT QUORUM: '
expect_hold "$BIN/i3_hardware" quorum "$ROOT/hardware.i3hp" "$ROOT/base.i3ae" "$ROOT/base.i3ae.sig" "$ROOT/platform.i3hqr" "$ROOT/platform.i3hqr.sig" 1007 "$ROOT/one" "$ROOT/no.i3hac"; echo HOLD

mkdir "$ROOT/denied"; cp "$ROOT/good/a.i3hs" "$ROOT/denied/a.i3hs"; cp "$ROOT/good/a.i3hs.sig" "$ROOT/denied/a.i3hs.sig"; cp "$ROOT/good/b.i3hs" "$ROOT/denied/b.i3hs"; sed -i.bak 's/|true$/|false/' "$ROOT/denied/b.i3hs"; rm "$ROOT/denied/b.i3hs.bak"; sign "$ROOT/split-b.private.pem" "$ROOT/denied/b.i3hs" "$ROOT/denied/b.i3hs.sig"
printf '14 EXPLICIT DENIAL: '
expect_hold "$BIN/i3_hardware" quorum "$ROOT/hardware.i3hp" "$ROOT/base.i3ae" "$ROOT/base.i3ae.sig" "$ROOT/platform.i3hqr" "$ROOT/platform.i3hqr.sig" 1007 "$ROOT/denied" "$ROOT/no.i3hac"; echo HOLD

cp "$ROOT/platform.i3hqr" "$ROOT/wrong-root.i3hqr"; sed -i.bak 's/|root-a|/|root-z|/' "$ROOT/wrong-root.i3hqr"; rm "$ROOT/wrong-root.i3hqr.bak"; sign "$ROOT/platform.private.pem" "$ROOT/wrong-root.i3hqr" "$ROOT/wrong-root.i3hqr.sig"
printf '15 WRONG ATTESTATION ROOT: '
expect_hold "$BIN/i3_hardware" verify "$ROOT/hardware.i3hp" "$ROOT/base.i3ae" "$ROOT/base.i3ae.sig" "$ROOT/wrong-root.i3hqr" "$ROOT/wrong-root.i3hqr.sig" 1007; echo HOLD

if rg -n --hidden --glob '!*.private.pem' --glob '!*.public.pem' 'BEGIN (OPENSSH |EC |RSA |DSA )?PRIVATE KEY' "$ROOT" >/dev/null; then echo 'PRIVATE KEY LEAK: FAIL'; exit 1; fi
echo 'BLIND AUDIT: 15/15 PASS'
