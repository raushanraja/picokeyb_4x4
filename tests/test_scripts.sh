#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
for script in setup_qmk.sh build.sh; do
    test -x "$ROOT/scripts/$script"
    bash -n "$ROOT/scripts/$script"
done
grep -Fq -- '-m venv' "$ROOT/scripts/setup_qmk.sh"
grep -Fq 'FORCE_QMK_UPDATE' "$ROOT/scripts/setup_qmk.sh"
grep -Fq 'artifact_name="pico_4x4_${KEYMAP}.uf2"' "$ROOT/scripts/build.sh"
grep -Fq 'KEYMAP' "$ROOT/scripts/build.sh"
