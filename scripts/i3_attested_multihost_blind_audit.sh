#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="${I3_BIN_DIR:-$REPO_ROOT/.lake/build/bin}"
OPENSSL="${OPENSSL_BIN:-/opt/homebrew/bin/openssl}"
ROOT="$(mktemp -d /tmp/i3-l12-blind.XXXXXX)"
trap 'rm -rf "$ROOT"' EXIT

hex() { printf "$1%.0s" {1..64}; }
manifest="$(hex c)"; peer_a="$(hex 1)"; peer_b="$(hex 2)"; peer_c="$(hex 3)"
boot="$(hex b)"; runtime="$(hex d)"; trust="$ROOT/trust.head"; store="$ROOT/store.head"

"$BIN/i3_trust" init "$trust" "$manifest" 111 1 211 >/dev/null
"$BIN/i3_trust_tx" init "$store" "$trust" >/dev/null

for key in verifier witness-a witness-b witness-c attest-a attest-b attest-c observer-a observer-b observer-c; do
  "$OPENSSL" genpkey -algorithm ED25519 -out "$ROOT/$key.private.pem" >/dev/null 2>&1
  "$OPENSSL" pkey -in "$ROOT/$key.private.pem" -pubout -out "$ROOT/$key.public.pem" >/dev/null 2>&1
done
for witness in a b c; do "$BIN/i3_witness" init "$ROOT/witness-$witness" "$store" "witness-$witness" >/dev/null; done

cat > "$ROOT/remote.i3rp" <<EOF
I3RPOL1|1|remote-2of3|2|verifier-main|verifier-key|$ROOT/verifier.public.pem|60
MEMBER|witness-a|key-a|$ROOT/witness-a.public.pem|admin-a|network-a|host-a|endpoint-a|https://a.invalid/i3|$peer_a
MEMBER|witness-b|key-b|$ROOT/witness-b.public.pem|admin-b|network-b|host-b|endpoint-b|https://b.invalid/i3|$peer_b
MEMBER|witness-c|key-c|$ROOT/witness-c.public.pem|admin-c|network-c|host-c|endpoint-c|https://c.invalid/i3|$peer_c
EOF
cat > "$ROOT/attestation.i3ap" <<EOF
I3APOL1|1|attested-2of3|verifier-evidence|$ROOT/verifier.public.pem|60
NODE|witness-a|node-a|custody-a|attest-key-a|$ROOT/attest-a.public.pem|observer-a|observer-custody-a|observer-key-a|$ROOT/observer-a.public.pem
NODE|witness-b|node-b|custody-b|attest-key-b|$ROOT/attest-b.public.pem|observer-b|observer-custody-b|observer-key-b|$ROOT/observer-b.public.pem
NODE|witness-c|node-c|custody-c|attest-key-c|$ROOT/attest-c.public.pem|observer-c|observer-custody-c|observer-key-c|$ROOT/observer-c.public.pem
EOF

make_remote() {
  local w="$1" char="$2" t="$3" id; id="$(hex "$char")"
  "$BIN/i3_remote_witness" challenge "$ROOT/remote.i3rp" "$store" "witness-$w" 12 "$t" 60 "$id" "$ROOT/verifier.private.pem" "$ROOT/$w.i3ch" "$ROOT/$w.i3ch.sig" >/dev/null
  "$BIN/i3_remote_witness" respond "$ROOT/remote.i3rp" "$ROOT/$w.i3ch" "$ROOT/$w.i3ch.sig" "$((t+1))" "$ROOT/witness-$w" "$ROOT/witness-$w.private.pem" "$ROOT/$w.i3rsp" "$ROOT/$w.i3rsp.sig" >/dev/null
  "$BIN/i3_remote_witness" verify "$ROOT/remote.i3rp" "$store" "$ROOT/$w.i3ch" "$ROOT/$w.i3ch.sig" "$ROOT/$w.i3rsp" "$ROOT/$w.i3rsp.sig" "$ROOT/ledger-$w" "$ROOT/$w.i3rr" "$((t+2))" >/dev/null
}
make_evidence() {
  local w="$1" t="$2"
  "$BIN/i3_attestation" attest "$ROOT/attestation.i3ap" "$ROOT/$w.i3rr" "$t" 30 "$boot" "$runtime" "$ROOT/attest-$w.private.pem" "$ROOT/$w.i3na" "$ROOT/$w.i3na.sig" >/dev/null
  "$BIN/i3_attestation" observe "$ROOT/attestation.i3ap" "$ROOT/$w.i3rr" "$((t+1))" "$ROOT/observer-$w.private.pem" "$ROOT/$w.i3to" "$ROOT/$w.i3to.sig" >/dev/null
}
verify_evidence() {
  local w="$1" now="$2" out="$3"
  "$BIN/i3_attestation" verify "$ROOT/attestation.i3ap" "$ROOT/$w.i3rr" "$ROOT/$w.i3na" "$ROOT/$w.i3na.sig" "$ROOT/$w.i3to" "$ROOT/$w.i3to.sig" "$ROOT/verifier.private.pem" "$out" "$out.sig" "$now"
}

make_remote a a 1000; make_remote b e 1000; make_remote c f 1000
make_evidence a 1003; make_evidence b 1003; make_evidence c 1003
mkdir "$ROOT/good"

printf '01 INDEPENDENT NODE EVIDENCE: '
verify_evidence a 1005 "$ROOT/good/a.i3ae" | grep -q 'INDEPENDENT NODE EVIDENCE VERIFIED'; echo VERIFIED
verify_evidence b 1005 "$ROOT/good/b.i3ae" >/dev/null
printf '02 TWO-OF-THREE MULTI-HOST QUORUM: '
"$BIN/i3_attestation" quorum "$ROOT/attestation.i3ap" "$ROOT/good" 2 "$ROOT/good.i3ac" | grep -q 'ATTESTED MULTI-HOST QUORUM'; echo ADMITTED

printf '03 INSUFFICIENT QUORUM: '
if "$BIN/i3_attestation" quorum "$ROOT/attestation.i3ap" "$ROOT/good" 3 "$ROOT/no.i3ac" >/dev/null 2>&1; then exit 1; fi; echo HOLD

cp "$ROOT/a.i3na" "$ROOT/bad-endpoint.i3na"; cp "$ROOT/a.i3na.sig" "$ROOT/bad-endpoint.i3na.sig"
sed -i.bak 's/|endpoint-a|/|endpoint-z|/' "$ROOT/bad-endpoint.i3na"; rm "$ROOT/bad-endpoint.i3na.bak"
"$OPENSSL" pkeyutl -sign -rawin -inkey "$ROOT/attest-a.private.pem" -in "$ROOT/bad-endpoint.i3na" -out "$ROOT/bad-endpoint.i3na.sig"
printf '04 CHANGED ENDPOINT: '
if "$BIN/i3_attestation" verify "$ROOT/attestation.i3ap" "$ROOT/a.i3rr" "$ROOT/bad-endpoint.i3na" "$ROOT/bad-endpoint.i3na.sig" "$ROOT/a.i3to" "$ROOT/a.i3to.sig" "$ROOT/verifier.private.pem" "$ROOT/no.i3ae" "$ROOT/no.i3ae.sig" 1005 >/dev/null 2>&1; then exit 1; fi; echo HOLD

cp "$ROOT/a.i3to" "$ROOT/bad-peer.i3to"; sed -i.bak "s/$peer_a/$peer_b/" "$ROOT/bad-peer.i3to"; rm "$ROOT/bad-peer.i3to.bak"
"$OPENSSL" pkeyutl -sign -rawin -inkey "$ROOT/observer-a.private.pem" -in "$ROOT/bad-peer.i3to" -out "$ROOT/bad-peer.i3to.sig"
printf '05 CHANGED TLS PEER: '
if "$BIN/i3_attestation" verify "$ROOT/attestation.i3ap" "$ROOT/a.i3rr" "$ROOT/a.i3na" "$ROOT/a.i3na.sig" "$ROOT/bad-peer.i3to" "$ROOT/bad-peer.i3to.sig" "$ROOT/verifier.private.pem" "$ROOT/no.i3ae" "$ROOT/no.i3ae.sig" 1005 >/dev/null 2>&1; then exit 1; fi; echo HOLD

printf '06 EXPIRED ATTESTATION: '
if verify_evidence a 1034 "$ROOT/no.i3ae" >/dev/null 2>&1; then exit 1; fi; echo HOLD

cp "$ROOT/a.i3na.sig" "$ROOT/tampered-att.sig"; printf X >> "$ROOT/tampered-att.sig"
printf '07 TAMPERED ATTESTATION SIGNATURE: '
if "$BIN/i3_attestation" verify "$ROOT/attestation.i3ap" "$ROOT/a.i3rr" "$ROOT/a.i3na" "$ROOT/tampered-att.sig" "$ROOT/a.i3to" "$ROOT/a.i3to.sig" "$ROOT/verifier.private.pem" "$ROOT/no.i3ae" "$ROOT/no.i3ae.sig" 1005 >/dev/null 2>&1; then exit 1; fi; echo HOLD

cp "$ROOT/a.i3to.sig" "$ROOT/tampered-obs.sig"; printf X >> "$ROOT/tampered-obs.sig"
printf '08 TAMPERED OBSERVER SIGNATURE: '
if "$BIN/i3_attestation" verify "$ROOT/attestation.i3ap" "$ROOT/a.i3rr" "$ROOT/a.i3na" "$ROOT/a.i3na.sig" "$ROOT/a.i3to" "$ROOT/tampered-obs.sig" "$ROOT/verifier.private.pem" "$ROOT/no.i3ae" "$ROOT/no.i3ae.sig" 1005 >/dev/null 2>&1; then exit 1; fi; echo HOLD

cp "$ROOT/a.i3rr" "$ROOT/changed.i3rr"; sed -i.bak 's/|endpoint-a|/|endpoint-z|/' "$ROOT/changed.i3rr"; rm "$ROOT/changed.i3rr.bak"
printf '09 REMOTE RECEIPT CHANGED AFTER EVIDENCE: '
if "$BIN/i3_attestation" verify "$ROOT/attestation.i3ap" "$ROOT/changed.i3rr" "$ROOT/a.i3na" "$ROOT/a.i3na.sig" "$ROOT/a.i3to" "$ROOT/a.i3to.sig" "$ROOT/verifier.private.pem" "$ROOT/no.i3ae" "$ROOT/no.i3ae.sig" 1005 >/dev/null 2>&1; then exit 1; fi; echo HOLD

mkdir "$ROOT/duplicate"; cp "$ROOT/good/a.i3ae" "$ROOT/duplicate/a.i3ae"; cp "$ROOT/good/a.i3ae.sig" "$ROOT/duplicate/a.i3ae.sig"; cp "$ROOT/good/a.i3ae" "$ROOT/duplicate/z.i3ae"; cp "$ROOT/good/a.i3ae.sig" "$ROOT/duplicate/z.i3ae.sig"
printf '10 DUPLICATE WITNESS RECEIPT: '
if "$BIN/i3_attestation" quorum "$ROOT/attestation.i3ap" "$ROOT/duplicate" 2 "$ROOT/no.i3ac" >/dev/null 2>&1; then exit 1; fi; echo HOLD

cp "$ROOT/attestation.i3ap" "$ROOT/shared.i3ap"; sed -i.bak 's/|node-b|custody-b|/|node-b|custody-a|/' "$ROOT/shared.i3ap"; rm "$ROOT/shared.i3ap.bak"
printf '11 SHARED KEY CUSTODY POLICY: '
if "$BIN/i3_attestation" quorum "$ROOT/shared.i3ap" "$ROOT/good" 2 "$ROOT/no.i3ac" >/dev/null 2>&1; then exit 1; fi; echo HOLD

cp "$ROOT/attestation.i3ap" "$ROOT/same-observer.i3ap"; sed -i.bak 's/observer-custody-a/custody-a/' "$ROOT/same-observer.i3ap"; rm "$ROOT/same-observer.i3ap.bak"
printf '12 OBSERVER SHARES NODE CUSTODY: '
if "$BIN/i3_attestation" verify "$ROOT/same-observer.i3ap" "$ROOT/a.i3rr" "$ROOT/a.i3na" "$ROOT/a.i3na.sig" "$ROOT/a.i3to" "$ROOT/a.i3to.sig" "$ROOT/verifier.private.pem" "$ROOT/no.i3ae" "$ROOT/no.i3ae.sig" 1005 >/dev/null 2>&1; then exit 1; fi; echo HOLD

cp "$ROOT/good/a.i3ae" "$ROOT/tampered-receipt.i3ae"; cp "$ROOT/good/a.i3ae.sig" "$ROOT/tampered-receipt.i3ae.sig"; printf X >> "$ROOT/tampered-receipt.i3ae"
mkdir "$ROOT/tampered-dir"; cp "$ROOT/tampered-receipt.i3ae" "$ROOT/tampered-dir/a.i3ae"; cp "$ROOT/tampered-receipt.i3ae.sig" "$ROOT/tampered-dir/a.i3ae.sig"; cp "$ROOT/good/b.i3ae" "$ROOT/tampered-dir/b.i3ae"; cp "$ROOT/good/b.i3ae.sig" "$ROOT/tampered-dir/b.i3ae.sig"
printf '13 TAMPERED VERIFIER RECEIPT: '
if "$BIN/i3_attestation" quorum "$ROOT/attestation.i3ap" "$ROOT/tampered-dir" 2 "$ROOT/no.i3ac" >/dev/null 2>&1; then exit 1; fi; echo HOLD

if rg -n --hidden --glob '!*.private.pem' --glob '!*.public.pem' 'BEGIN (OPENSSH |EC |RSA |DSA )?PRIVATE KEY' "$ROOT" >/dev/null; then echo 'PRIVATE KEY LEAK: FAIL'; exit 1; fi
echo 'BLIND AUDIT: 13/13 PASS'
