# Raspberry Pi Pico 4x4 QMK keypad

QMK firmware for a hand-wired 16-key matrix on a Raspberry Pi Pico.

## Keymap

```text
1       2       3       4
5       6       Up      Backspace
M       Left    Down    Right
Fn      Ctrl    Esc     Enter
```

### Profiles and layers

The keyboard starts in M1 for the last-selected OS profile. Press `M` to
toggle between M1 and M2. Hold `Fn` for the momentary Fn layer, then press
`Ctrl + M` to switch between Windows and Linux. The OS selection is stored in
EEPROM and survives unplugging and rebooting; the M1/M2 selection resets to M1
on boot.

The four profile layers are selected as follows:

| Layer | Activate with | Purpose |
| --- | --- | --- |
| Windows M1 | Default | `Ctrl+Alt+1` through `Ctrl+Alt+7` |
| Windows M2 | Tap `M` | App and window controls |
| Windows M1 + Fn | Hold `Fn` on M1 | Number keys, mouse, and navigation |
| Windows M2 + Fn | Hold `Fn` on M2 | Text-editing shortcuts |
| Linux M1/M2 | Switch OS, then tap `M` | Linux base layers |
| Linux + Fn | Hold `Fn` on Linux | Mouse movement and navigation |

`M` toggles M1 ↔ M2 within the active OS profile. The OS selection is stored
in EEPROM and survives unplugging and rebooting; the M1/M2 selection resets to
M1 on boot. Press `Fn + Ctrl + M` to switch between Windows and Linux while
preserving the current M1/M2 state.

#### Windows M2 — app and window controls

| 1 | 2 | 3 | 4 |
| --- | --- | --- | --- |
| `Alt+Tab` | `Win+Tab` | `Win+D` | `Alt+F4` |
| `Win+E` | `Win+R` | `Win+Up` | `Win+L` |
| `M` toggle | `Win+Left` | `Win+Down` | `Win+Right` |
| `Fn` | `Ctrl` | `Esc` | `Enter` |

#### Windows M2 + Fn — text editing

| 1 | 2 | 3 | 4 |
| --- | --- | --- | --- |
| `Ctrl+Z` | `Ctrl+Y` | `Ctrl+X` | `Ctrl+C` |
| `Ctrl+V` | `Ctrl+A` | `Home` | `Ctrl+Backspace` |
| OS switch | `Ctrl+Left` | `End` | `Ctrl+Right` |
| Transparent | `Ctrl` | `Esc` | `Enter` |

#### Windows M1 + Fn

The M1 Fn layer uses key 1 as a persistent Alt-Tab mode: the first press holds
Alt and sends Tab, and later presses send Tab while Alt remains held. Pressing
another key or releasing Fn exits the mode. The other number positions provide
normal `2` through `6` keys, with Backspace on physical key 8. It also provides
mouse movement on the arrow keys, the OS switch on `M`, and left/right mouse
click on `Esc`/`Enter`. The base profile layer provides `Ctrl+Alt+1` through
`Ctrl+Alt+7` in those number positions.

#### VIA layer order

In VIA, the seven editable layers are ordered as:

| VIA layer | Firmware layer | Description |
| ---: | --- | --- |
| 0 | `L_WIN_M1` | Windows M1 |
| 1 | `L_WIN_M2` | Windows M2 |
| 2 | `L_LINUX_M1` | Linux M1 |
| 3 | `L_LINUX_M2` | Linux M2 |
| 4 | `L_WIN_FN` | Windows M1 + Fn |
| 5 | `L_LINUX_FN` | Linux + Fn |
| 6 | `L_WIN_M2_FN` | Windows M2 + Fn |

The compiled defaults can be customized independently in VIA.

## Matrix wiring

The firmware defaults to GPIO numbers:

- Rows: `GP9`, `GP10`, `GP11`, `GP12`
- Columns: `GP1`, `GP2`, `GP3`, `GP4`
- Diodes: `COL2ROW`

USB identity: VID `0x4449` (the DIY `DI` identifier) and PID `0x0001`.

The matrix must have one diode per switch. For `COL2ROW`, put the diode in the row connection with its stripe/band toward the column side (away from the row wire); use `ROW2COL` if your physical diode orientation is opposite.

To swap the two four-pin groups, change this line in `firmware/keyboards/pico_4x4/config.h`:

```c
#define PICO_4X4_LOW_PINS_ARE_ROWS 0
```

Change `0` to `1`. To reverse diode orientation, change `COL2ROW` to `ROW2COL` on the `DIODE_DIRECTION` line in the same file.

## Setup, build, test, and flash

From this directory:

```bash
make setup
make build
```

Run the complete workflow with:

```bash
make all
```

The default firmware is intentionally a separate non-VIA build. To build the
VIA-enabled variant instead, select its keymap:

```bash
make build KEYMAP=via
make flash KEYMAP=via
```

This creates `.artifacts/pico_4x4_via.uf2`. Flash that file before opening
`usevia.app`.

Other useful targets are `make help`, `make test`, `make lint`, `make doctor`, and `make clean`. `make lint` checks the base QMK keyboard metadata; the VIA variant is checked by the project tests and compiled with `make build KEYMAP=via`.

The first command creates `.venv`, installs the QMK CLI into it, and clones the upstream QMK checkout into the ignored `.qmk_firmware` directory. Once installed, later setup/build commands reuse the venv without network access. To explicitly upgrade QMK, run `FORCE_QMK_UPDATE=1 make setup`. The build output is:

```text
.artifacts/pico_4x4_default.uf2
```

## VIA configuration

Because this is a local DIY keyboard and its development VID/PID is not in
VIA's hosted database, load the project definition manually:

1. Open [usevia.app](https://usevia.app/) in Chrome or Edge.
2. Enable `Show Design Tab` in Settings.
3. In the Design tab, remove any older `Pico 4x4` draft definition, then load
   `firmware/keyboards/pico_4x4/via.json` as a draft definition.
4. Return to Configure, unplug/reconnect the Pico, and authorize it.

The VIA definition maps the visual key positions to the transposed electrical
matrix used by this hand-wired board, so the UI shows the same 4x4 arrangement
as the physical keypad.

## Upload

1. Hold `BOOTSEL` while plugging the Pico into USB, or double-tap the Pico reset button after the firmware has been installed once.
2. Run:

   ```bash
   make flash
   ```

The uploader detects common Linux and macOS mount paths. If it cannot find the drive, pass it explicitly:

```bash
make flash DRIVE=/media/$USER/RPI-RP2
```

To test the selected file and destination without copying:

```bash
make flash DRIVE=/media/$USER/RPI-RP2 DRY_RUN=1
```

## Local checks

```bash
make test
```
