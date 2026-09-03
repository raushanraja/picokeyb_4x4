/*
Copyright 2026 DIY

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.
*/

#pragma once

enum pico_4x4_layers {
    L_WIN_M1,
    L_WIN_M2,
    L_LINUX_M1,
    L_LINUX_M2,
    L_WIN_FN,
    L_LINUX_FN,
    L_WIN_M2_FN,
};

enum pico_4x4_custom_keycodes {
    M_TOGGLE = SAFE_RANGE,
    OS_TOGGLE,
    ALT_TAB_MODE,
    CTRL_ALT_SHIFT_MODE,
};

typedef enum {
    PICO_PROFILE_WINDOWS = 0,
    PICO_PROFILE_LINUX = 1,
} pico_4x4_profile_t;

static pico_4x4_profile_t pico_4x4_profile = PICO_PROFILE_WINDOWS;
static bool pico_4x4_alt_tab_active = false;
static bool pico_4x4_ctrl_alt_shift_active = false;

static void pico_4x4_release_ctrl_alt_shift(void) {
    unregister_code(KC_LSFT);
    unregister_code(KC_LALT);
    unregister_code(KC_LCTL);
    pico_4x4_ctrl_alt_shift_active = false;
}

static void pico_4x4_tap_ctrl_alt_shift(uint16_t keycode) {
    register_code(KC_LCTL);
    register_code(KC_LALT);
    register_code(KC_LSFT);
    tap_code(keycode);
    pico_4x4_release_ctrl_alt_shift();
}

#define PICO_4X4_PROFILE_LAYER(fn_layer) \
    LAYOUT_ortho_4x4( \
        LCA(KC_1), LCA(KC_5), M_TOGGLE, MO(fn_layer), \
        LCA(KC_2), LCA(KC_6), KC_LEFT,  KC_LCTL, \
        LCA(KC_3), KC_UP,     KC_DOWN,  KC_ESC, \
        LCA(KC_4), LCA(KC_7), KC_RGHT,  KC_ENT  \
    )

#define PICO_4X4_WINDOWS_M1_LAYER PICO_4X4_PROFILE_LAYER(L_WIN_FN)
#define PICO_4X4_LINUX_PROFILE_LAYER PICO_4X4_PROFILE_LAYER(L_LINUX_FN)

#define PICO_4X4_WINDOWS_M2_LAYER \
    LAYOUT_ortho_4x4( \
        LALT(KC_TAB), LGUI(KC_E), M_TOGGLE, MO(L_WIN_M2_FN), \
        LGUI(KC_TAB), LGUI(KC_R), LGUI(KC_LEFT), KC_LCTL, \
        LGUI(KC_D), LGUI(KC_UP), LGUI(KC_DOWN), KC_ESC, \
        LALT(KC_F4), LGUI(KC_L), LGUI(KC_RGHT), KC_ENT \
    )

#define PICO_4X4_WINDOWS_FN_LAYER \
    LAYOUT_ortho_4x4( \
        ALT_TAB_MODE, KC_5,        OS_TOGGLE, KC_TRNS, \
        LGUI(KC_D),   KC_6,        MS_LEFT,   KC_LCTL, \
        LGUI(KC_F),   MS_UP,       MS_DOWN,   MS_BTN1, \
        CTRL_ALT_SHIFT_MODE, KC_BSPC, MS_RGHT, MS_BTN2 \
    )

#define PICO_4X4_WINDOWS_M2_FN_LAYER \
    LAYOUT_ortho_4x4( \
        LCTL(KC_Z), LCTL(KC_V), OS_TOGGLE, KC_TRNS, \
        LCTL(KC_Y), LCTL(KC_A), LCTL(KC_LEFT), KC_LCTL, \
        LCTL(KC_X), KC_HOME, KC_END, KC_ESC, \
        CTRL_ALT_SHIFT_MODE, LCTL(KC_BSPC), LCTL(KC_RGHT), KC_ENT \
    )

#define PICO_4X4_LINUX_FN_LAYER \
    LAYOUT_ortho_4x4( \
        KC_TRNS, KC_TRNS, OS_TOGGLE, KC_TRNS, \
        KC_TRNS, KC_TRNS, MS_LEFT,   KC_LCTL, \
        KC_TRNS, MS_UP,   MS_DOWN,   KC_TRNS, \
        KC_TRNS, KC_TRNS, MS_RGHT,   KC_TRNS  \
    )

static uint8_t pico_4x4_layer_for_profile(pico_4x4_profile_t profile, bool m2) {
    if (profile == PICO_PROFILE_LINUX) {
        return m2 ? L_LINUX_M2 : L_LINUX_M1;
    }
    return m2 ? L_WIN_M2 : L_WIN_M1;
}

static uint8_t pico_4x4_active_working_layer(void) {
    layer_state_t working_state = layer_state;
    working_state &= ~((layer_state_t)1 << L_WIN_FN);
    working_state &= ~((layer_state_t)1 << L_LINUX_FN);
    working_state &= ~((layer_state_t)1 << L_WIN_M2_FN);
    uint8_t active_layer = get_highest_layer(working_state);

    switch (active_layer) {
        case L_WIN_M1:
        case L_WIN_M2:
        case L_LINUX_M1:
        case L_LINUX_M2:
            return active_layer;
        default:
            return pico_4x4_layer_for_profile(pico_4x4_profile, false);
    }
}

static void pico_4x4_cycle_m_layer(void) {
    switch (pico_4x4_active_working_layer()) {
        case L_WIN_M1:
            layer_move(L_WIN_M2);
            break;
        case L_WIN_M2:
            layer_move(L_WIN_M1);
            break;
        case L_LINUX_M1:
            layer_move(L_LINUX_M2);
            break;
        case L_LINUX_M2:
            layer_move(L_LINUX_M1);
            break;
        default:
            layer_move(pico_4x4_layer_for_profile(pico_4x4_profile, false));
            break;
    }
}

static void pico_4x4_toggle_os_profile(void) {
    uint8_t active_layer = pico_4x4_active_working_layer();
    bool m2 = active_layer == L_WIN_M2 || active_layer == L_LINUX_M2;

    pico_4x4_profile = pico_4x4_profile == PICO_PROFILE_WINDOWS
                           ? PICO_PROFILE_LINUX
                           : PICO_PROFILE_WINDOWS;
    eeconfig_update_user((uint32_t)pico_4x4_profile);
    layer_move(pico_4x4_layer_for_profile(pico_4x4_profile, m2));
}

void eeconfig_init_user(void) {
    eeconfig_update_user((uint32_t)PICO_PROFILE_WINDOWS);
}

void keyboard_post_init_user(void) {
    uint32_t stored_profile = eeconfig_read_user();
    pico_4x4_profile = stored_profile == PICO_PROFILE_LINUX
                           ? PICO_PROFILE_LINUX
                           : PICO_PROFILE_WINDOWS;
    layer_move(pico_4x4_layer_for_profile(pico_4x4_profile, false));
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    if (keycode != ALT_TAB_MODE && pico_4x4_alt_tab_active) {
        unregister_code(KC_LALT);
        pico_4x4_alt_tab_active = false;
    }

    if (pico_4x4_ctrl_alt_shift_active && keycode != CTRL_ALT_SHIFT_MODE) {
        uint16_t number = KC_NO;
        if (keycode == ALT_TAB_MODE || keycode == LCA(KC_1) || keycode == LCTL(KC_Z)) {
            number = KC_1;
        } else if (keycode == LGUI(KC_D) || keycode == LCA(KC_2) || keycode == LCTL(KC_Y)) {
            number = KC_2;
        } else if (keycode == LGUI(KC_F) || keycode == LCA(KC_3) || keycode == LCTL(KC_X)) {
            number = KC_3;
        } else if (keycode == LCA(KC_4)) {
            number = KC_4;
        } else if (keycode == KC_5 || keycode == LCA(KC_5) || keycode == LCTL(KC_V)) {
            number = KC_5;
        } else if (keycode == KC_6 || keycode == LCA(KC_6) || keycode == LCTL(KC_A)) {
            number = KC_6;
        }

        if (number != KC_NO) {
            if (record->event.pressed) {
                pico_4x4_tap_ctrl_alt_shift(number);
            }
            return false;
        }
    }

    switch (keycode) {
        case M_TOGGLE:
            if (record->event.pressed) {
                pico_4x4_cycle_m_layer();
            }
            return false;
        case OS_TOGGLE:
            if (record->event.pressed && (get_mods() & MOD_MASK_CTRL)) {
                pico_4x4_toggle_os_profile();
            }
            return false;
        case ALT_TAB_MODE:
            if (record->event.pressed) {
                if (!pico_4x4_alt_tab_active) {
                    register_code(KC_LALT);
                    pico_4x4_alt_tab_active = true;
                }
                tap_code(KC_TAB);
            }
            return false;
        case CTRL_ALT_SHIFT_MODE:
            if (record->event.pressed) {
                if (pico_4x4_ctrl_alt_shift_active) {
                    pico_4x4_release_ctrl_alt_shift();
                } else {
                    pico_4x4_ctrl_alt_shift_active = true;
                }
            }
            return false;
        default:
            return true;
    }
}
