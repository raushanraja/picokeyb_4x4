#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
CONFIG="$ROOT/firmware/keyboards/pico_4x4/config.h"
KEYMAP="$ROOT/firmware/keyboards/pico_4x4/keymaps/default/keymap.c"
VIA_KEYMAP="$ROOT/firmware/keyboards/pico_4x4/keymaps/via/keymap.c"
PROFILE_HEADER="$ROOT/firmware/keyboards/pico_4x4/profile_switching.h"
VIA_RULES="$ROOT/firmware/keyboards/pico_4x4/keymaps/via/rules.mk"
VIA_DEFINITION="$ROOT/firmware/keyboards/pico_4x4/via.json"

test -f "$CONFIG"
test -f "$KEYMAP"
grep -Fq '#define PICO_4X4_LOW_PINS_ARE_ROWS 0' "$CONFIG"
grep -Fq '#define DIODE_DIRECTION COL2ROW' "$CONFIG"
grep -Fq 'GP1, GP2, GP3, GP4' "$CONFIG"
grep -Fq 'GP9, GP10, GP11, GP12' "$CONFIG"
grep -Fq '#define PICO_4X4_PROFILE_LAYER(fn_layer)' "$PROFILE_HEADER"
grep -Eq 'LCA\(KC_2\),[[:space:]]+LCA\(KC_6\),[[:space:]]+KC_LEFT,[[:space:]]+KC_LCTL' "$PROFILE_HEADER"
grep -Eq 'LCA\(KC_3\),[[:space:]]+KC_UP,[[:space:]]+KC_DOWN,[[:space:]]+KC_ESC' "$PROFILE_HEADER"
grep -Eq 'LCA\(KC_4\),[[:space:]]+LCA\(KC_7\),[[:space:]]+KC_RGHT,[[:space:]]+KC_ENT' "$PROFILE_HEADER"

test -f "$VIA_KEYMAP"
test -f "$VIA_RULES"
test -f "$VIA_DEFINITION"
python3 -m json.tool "$VIA_DEFINITION" >/dev/null
if grep -Fq '"lighting"' "$VIA_DEFINITION"; then
    echo "legacy lighting field must not be present in the V3 definition" >&2
    exit 1
fi
grep -Fq 'VIA_ENABLE = yes' "$VIA_RULES"
grep -Fq '#define PICO_4X4_PROFILE_LAYER(fn_layer)' "$PROFILE_HEADER"
grep -Eq 'LCA\(KC_2\),[[:space:]]+LCA\(KC_6\),[[:space:]]+KC_LEFT,[[:space:]]+KC_LCTL' "$PROFILE_HEADER"
grep -Eq 'LCA\(KC_3\),[[:space:]]+KC_UP,[[:space:]]+KC_DOWN,[[:space:]]+KC_ESC' "$PROFILE_HEADER"
grep -Eq 'LCA\(KC_4\),[[:space:]]+LCA\(KC_7\),[[:space:]]+KC_RGHT,[[:space:]]+KC_ENT' "$PROFILE_HEADER"
grep -Fq '"vid": "0x4449"' "$ROOT/firmware/keyboards/pico_4x4/keyboard.json"
grep -Fq '"vendorId": "0x4449"' "$VIA_DEFINITION"
if grep -Fq '0xFEED' "$VIA_DEFINITION" "$ROOT/firmware/keyboards/pico_4x4/keyboard.json"; then
    echo "placeholder 0xFEED USB ID must not be used" >&2
    exit 1
fi
grep -Fq '"productId": "0x0001"' "$VIA_DEFINITION"
grep -Fq '"rows": 4' "$VIA_DEFINITION"
grep -Fq '"cols": 4' "$VIA_DEFINITION"
grep -Fq '"0,0", "1,0", "2,0", "3,0"' "$VIA_DEFINITION"
grep -Fq '"0,1", "1,1", "2,1", "3,1"' "$VIA_DEFINITION"
grep -Fq '"0,2", "1,2", "2,2", "3,2"' "$VIA_DEFINITION"
grep -Fq '"0,3", "1,3", "2,3", "3,3"' "$VIA_DEFINITION"
