#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
MAKEFILE="$ROOT/Makefile"

test -f "$MAKEFILE"

help=$(make -C "$ROOT" help)
for target in setup build clean test lint all flash doctor qmk; do
    grep -Fq "make $target" <<<"$help"
done

make -C "$ROOT" -n all >/dev/null
make -C "$ROOT" -n flash DRIVE=/tmp/RPI-RP2 DRY_RUN=1 >/dev/null
make -C "$ROOT" -n build KEYMAP=via | grep -Fq 'build.sh "via"'
make -C "$ROOT" -n flash KEYMAP=via DRIVE=/tmp/RPI-RP2 DRY_RUN=1 | grep -Fq 'pico_4x4_via.uf2'
