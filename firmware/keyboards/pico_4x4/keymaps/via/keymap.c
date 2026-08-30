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

#include QMK_KEYBOARD_H

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    // Keep the same working transposed electrical mapping as the default keymap.
    [0] = LAYOUT_ortho_4x4(
        KC_1,    KC_5,    KC_Z,    KC_LGUI,
        KC_2,    KC_6,    KC_LEFT, KC_LCTL,
        KC_3,    KC_UP,   KC_DOWN, KC_ESC,
        KC_4,    KC_DEL,  KC_RGHT, KC_ENT
    )
};
