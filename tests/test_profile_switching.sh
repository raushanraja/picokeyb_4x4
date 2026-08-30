#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
HEADER="$ROOT/firmware/keyboards/pico_4x4/profile_switching.h"
DEFAULT_KEYMAP="$ROOT/firmware/keyboards/pico_4x4/keymaps/default/keymap.c"
VIA_KEYMAP="$ROOT/firmware/keyboards/pico_4x4/keymaps/via/keymap.c"
CONFIG="$ROOT/firmware/keyboards/pico_4x4/config.h"
RULES="$ROOT/firmware/keyboards/pico_4x4/rules.mk"

test -f "$HEADER"
grep -Fq 'L_WIN_M1' "$HEADER"
grep -Fq 'L_WIN_M2' "$HEADER"
grep -Fq 'L_LINUX_M1' "$HEADER"
grep -Fq 'L_LINUX_M2' "$HEADER"
grep -Fq 'L_FN' "$HEADER"
grep -Fq 'M_TOGGLE = SAFE_RANGE' "$HEADER"
grep -Fq 'OS_TOGGLE' "$HEADER"
grep -Fq 'eeconfig_read_user()' "$HEADER"
grep -Fq 'eeconfig_update_user' "$HEADER"
grep -Fq 'get_mods() & MOD_MASK_CTRL' "$HEADER"
grep -Fq 'layer_move' "$HEADER"

for keymap in "$DEFAULT_KEYMAP" "$VIA_KEYMAP"; do
    grep -Fq '#include "../../profile_switching.h"' "$keymap"
    grep -Fq '[L_WIN_M1] = PICO_4X4_PROFILE_LAYER' "$keymap"
    grep -Fq '[L_WIN_M2] = PICO_4X4_PROFILE_LAYER' "$keymap"
    grep -Fq '[L_LINUX_M1] = PICO_4X4_PROFILE_LAYER' "$keymap"
    grep -Fq '[L_LINUX_M2] = PICO_4X4_PROFILE_LAYER' "$keymap"
    grep -Fq '[L_FN] = PICO_4X4_FN_LAYER' "$keymap"
done

grep -Fq 'KC_1,    KC_5,    M_TOGGLE, MO(L_FN)' "$HEADER"
grep -Fq 'KC_TRNS, KC_TRNS, OS_TOGGLE, KC_TRNS' "$HEADER"
grep -Eq 'KC_TRNS,[[:space:]]+KC_TRNS,[[:space:]]+MS_UP,[[:space:]]+KC_LCTL' "$HEADER"
grep -Eq 'KC_TRNS,[[:space:]]+MS_LEFT,[[:space:]]+MS_DOWN,[[:space:]]+KC_TRNS' "$HEADER"
grep -Eq 'KC_TRNS,[[:space:]]+KC_TRNS,[[:space:]]+MS_RGHT,[[:space:]]+KC_TRNS' "$HEADER"
grep -Fq '#define DYNAMIC_KEYMAP_LAYER_COUNT 5' "$CONFIG"
grep -Fq 'MOUSEKEY_ENABLE = yes' "$RULES"
