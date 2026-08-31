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

The four profile layers initially contain the same keymap. Windows M1 and M2
use independent momentary Fn layers, initially with the same Windows mouse and
shortcut bindings, so M2 can be customized separately in VIA. Linux keeps its
current shared Fn layer behavior.

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
