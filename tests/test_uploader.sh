#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
test -x "$ROOT/scripts/upload.sh"
bash -n "$ROOT/scripts/upload.sh"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/RPI-RP2"
printf 'Raspberry Pi RP2 Boot\n' > "$TMP/RPI-RP2/INFO_UF2.TXT"
printf 'test uf2\n' > "$TMP/input.uf2"

output=$("$ROOT/scripts/upload.sh" --dry-run --drive "$TMP/RPI-RP2" "$TMP/input.uf2")
grep -Fq "pico_4x4.uf2" <<<"$output"
test ! -e "$TMP/RPI-RP2/pico_4x4.uf2"
