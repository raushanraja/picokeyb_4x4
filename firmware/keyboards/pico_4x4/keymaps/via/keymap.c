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
#include "../../profile_switching.h"

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [L_WIN_M1] = PICO_4X4_PROFILE_LAYER,
    [L_WIN_M2] = PICO_4X4_PROFILE_LAYER,
    [L_LINUX_M1] = PICO_4X4_PROFILE_LAYER,
    [L_LINUX_M2] = PICO_4X4_PROFILE_LAYER,
    [L_FN] = PICO_4X4_FN_LAYER,
};
