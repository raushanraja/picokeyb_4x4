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

// Change this to 1 when GP1-GP4 are the matrix rows.
#define PICO_4X4_LOW_PINS_ARE_ROWS 0

#if PICO_4X4_LOW_PINS_ARE_ROWS
#    define MATRIX_ROW_PINS { GP1, GP2, GP3, GP4 }
#    define MATRIX_COL_PINS { GP9, GP10, GP11, GP12 }
#else
#    define MATRIX_ROW_PINS { GP9, GP10, GP11, GP12 }
#    define MATRIX_COL_PINS { GP1, GP2, GP3, GP4 }
#endif

// Change to ROW2COL if the diode bands are oriented the other way.
#define DIODE_DIRECTION COL2ROW

#define MATRIX_ROWS 4
#define MATRIX_COLS 4

// VIA exposes the four profile layers plus the momentary Fn layer.
#define DYNAMIC_KEYMAP_LAYER_COUNT 5

#define USB_POLLING_INTERVAL_MS 1

// Double-tap reset enters the Pico UF2 bootloader after the first flash.
#define RP2040_BOOTLOADER_DOUBLE_TAP_RESET
#define RP2040_BOOTLOADER_DOUBLE_TAP_RESET_TIMEOUT 200U
#define RP2040_BOOTLOADER_DOUBLE_TAP_RESET_LED GP25
