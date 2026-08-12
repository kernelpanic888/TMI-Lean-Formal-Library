#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="${I3_BIN_DIR:-$REPO_ROOT/.lake/build/bin}"
OPENSSL="${OPENSSL_BIN:-/opt/homebrew/bin/openssl}"
ROOT="$(mktemp -d /tmp/i3-l10-blind.XXXXXX)"
trap 'rm -rf "$ROOT"' EXIT

manifest="$(printf 'b%.0s' {1..64})"
trust="$ROOT/trust.head"
store="$ROOT/store.head"

"$BIN/i3_trust" init "$trust" "$manifest" 110 1 210 >/dev/null
"$BIN/i3_trust_tx" init "$store" "$trust" >/dev/null

for witness in a b c; do
  "$OPENSSL" genpkey -algorithm ED25519 \
    -out "$ROOT/$witness.private.pem" >/dev/null 2>&1
  "$OPENSSL" pkey -in "$ROOT/$witness.private.pem" -pubout \
    -out "$ROOT/$witness.public.pem" >/dev/null 2>&1
  "$BIN/i3_witness" init "$ROOT/witness-$witness" "$store" \
    "witness-$witness" >/dev/null
done

write_policy() {
  local path="$1" admin_b="$2" network_b="$3" host_b="$4"
  cat > "$path" <<EOF
I3DPOL1|1|independent-2of3|2
MEMBER|witness-a|key-a|$ROOT/a.public.pem|admin-a|network-a|host-a
MEMBER|witness-b|key-b|$ROOT/b.public.pem|$admin_b|$network_b|$host_b
MEMBER|witness-c|key-c|$ROOT/c.public.pem|admin-c|network-c|host-c
EOF
}

write_votes() {
  local policy="$1" dir="$2"
  mkdir -p "$dir"
  "$BIN/i3_domain_quorum" vote "$policy" 10 "$ROOT/witness-a" key-a \
    "$ROOT/a.private.pem" "$dir/a.i3dv" "$dir/a.i3dv.sig" >/dev/null
  "$BIN/i3_domain_quorum" vote "$policy" 10 "$ROOT/witness-b" key-b \
    "$ROOT/b.private.pem" "$dir/b.i3dv" "$dir/b.i3dv.sig" >/dev/null
}

write_policy "$ROOT/valid.i3dp" admin-b network-b host-b
write_votes "$ROOT/valid.i3dp" "$ROOT/valid"

printf '01 INDEPENDENT 2/3: '
"$BIN/i3_domain_quorum" admit "$ROOT/valid.i3dp" "$store" 10 \
  "$ROOT/valid" "$ROOT/valid.i3dc" | grep -q 'INDEPENDENT QUORUM ADMIT'
"$BIN/i3_domain_quorum" verify "$ROOT/valid.i3dp" "$store" 10 \
  "$ROOT/valid" "$ROOT/valid.i3dc" | grep -q 'CERTIFICATE VERIFIED'
echo 'ADMIT + CERTIFICATE VERIFIED'

printf '02 ONE WITNESS UNAVAILABLE: '
test "$(find "$ROOT/valid" -name '*.i3dv' | wc -l | tr -d ' ')" = 2
echo '2/3 REMAINS LIVE'

mkdir "$ROOT/under"
cp "$ROOT/valid/a.i3dv" "$ROOT/under/a.i3dv"
cp "$ROOT/valid/a.i3dv.sig" "$ROOT/under/a.i3dv.sig"
printf '03 BELOW THRESHOLD: '
if "$BIN/i3_domain_quorum" admit "$ROOT/valid.i3dp" "$store" 10 \
    "$ROOT/under" "$ROOT/under.i3dc" >/dev/null 2>&1; then exit 1; fi
echo 'HOLD'

for kind in admin network host; do
  case "$kind" in
    admin) a=admin-a; n=network-b; h=host-b ;;
    network) a=admin-b; n=network-a; h=host-b ;;
    host) a=admin-b; n=network-b; h=host-a ;;
  esac
  write_policy "$ROOT/shared-$kind.i3dp" "$a" "$n" "$h"
  write_votes "$ROOT/shared-$kind.i3dp" "$ROOT/shared-$kind"
done

printf '04 SHARED ADMIN DOMAIN: '
if "$BIN/i3_domain_quorum" admit "$ROOT/shared-admin.i3dp" "$store" 10 \
    "$ROOT/shared-admin" "$ROOT/shared-admin.i3dc" >/dev/null 2>&1; then exit 1; fi
echo 'HOLD'

printf '05 SHARED NETWORK DOMAIN: '
if "$BIN/i3_domain_quorum" admit "$ROOT/shared-network.i3dp" "$store" 10 \
    "$ROOT/shared-network" "$ROOT/shared-network.i3dc" >/dev/null 2>&1; then exit 1; fi
echo 'HOLD'

printf '06 SHARED HOST DOMAIN: '
if "$BIN/i3_domain_quorum" admit "$ROOT/shared-host.i3dp" "$store" 10 \
    "$ROOT/shared-host" "$ROOT/shared-host.i3dc" >/dev/null 2>&1; then exit 1; fi
echo 'HOLD'

cp "$ROOT/valid.i3dp" "$ROOT/changed.i3dp"
sed -i.bak 's/admin-b/admin-z/' "$ROOT/changed.i3dp"
rm "$ROOT/changed.i3dp.bak"
printf '07 POLICY CHANGED AFTER SIGNING: '
if "$BIN/i3_domain_quorum" admit "$ROOT/changed.i3dp" "$store" 10 \
    "$ROOT/valid" "$ROOT/changed.i3dc" >/dev/null 2>&1; then exit 1; fi
echo 'HOLD'

cp "$ROOT/valid.i3dc" "$ROOT/tampered.i3dc"
printf 'X' >> "$ROOT/tampered.i3dc"
printf '08 TAMPERED CERTIFICATE: '
if "$BIN/i3_domain_quorum" verify "$ROOT/valid.i3dp" "$store" 10 \
    "$ROOT/valid" "$ROOT/tampered.i3dc" >/dev/null 2>&1; then exit 1; fi
echo 'HOLD'

if rg -n --hidden --glob '!*.public.pem' --glob '!*.private.pem' \
    'BEGIN (OPENSSH |EC |RSA |DSA )?PRIVATE KEY' "$ROOT/valid" "$ROOT/valid.i3dc" \
    >/dev/null; then
  echo 'PRIVATE KEY LEAK: FAIL'
  exit 1
fi

echo 'BLIND AUDIT: 8/8 PASS'
