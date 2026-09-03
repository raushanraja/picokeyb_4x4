# Raspberry Pi Pico 4x4 QMK Keypad

QMK firmware for a hand-wired 16-key matrix on a Raspberry Pi Pico.

All layer tables below are shown as viewed on the physical pad (top row
first, left to right). They follow `LAYOUT_ortho_4x4` row-major order in
`firmware/keyboards/pico_4x4/profile_switching.h`.

Legend:

- `LCA(x)` = `Ctrl+Alt+x`
- `M` = `M_TOGGLE`: toggle M1 ↔ M2 within the active OS profile
- `Fn` = momentary Fn layer (`MO(...)`)
- `OS†` = `OS_TOGGLE`: switch Windows ↔ Linux; only fires while `Ctrl` is held
- `Alt-Tab*` = `ALT_TAB_MODE`: persistent Alt-Tab mode (see notes)
- `CAS‡` = `CTRL_ALT_SHIFT_MODE`: one-shot `Ctrl+Alt+Shift` number mode (see notes)
- `—` = `KC_TRNS`: transparent, falls through to the base layer underneath

## Base Layout (M1)

This is the power-on layout for both OS profiles. Windows M1, Linux M1,
and Linux M2 all share this arrangement; only the Fn target differs
(`L_WIN_FN` on Windows, `L_LINUX_FN` on Linux).

| Row | Col 1 | Col 2 | Col 3 | Col 4 |
| --- | --- | --- | --- | --- |
| 1 | `Ctrl+Alt+1` | `Ctrl+Alt+5` | `M` | `Fn` |
| 2 | `Ctrl+Alt+2` | `Ctrl+Alt+6` | `Left` | `Ctrl` |
| 3 | `Ctrl+Alt+3` | `Up` | `Down` | `Esc` |
| 4 | `Ctrl+Alt+4` | `Ctrl+Alt+7` | `Right` | `Enter` |

Notes:

- There is no `Backspace` on the base layer. `Backspace` lives on
  Windows M1 + Fn at row 4, col 2.
- `Ctrl+Alt+7` is at row 4, col 2 (not row 3, col 2, which is `Down`).

## Profiles and Layers

- The keyboard boots to M1 of the last-selected OS profile.
- `M` toggles M1 ↔ M2 within the active OS profile.
- Hold `Fn` for the momentary Fn layer.
- To switch OS, hold `Fn`, hold `Ctrl`, then tap the `OS†` key
  (row 1, col 3 on any Fn layer). This preserves the current M1/M2 state.
- The OS selection is stored in EEPROM and survives unplugging and
  rebooting. The M1/M2 selection resets to M1 on boot.

| Layer | How to reach it | Purpose |
| --- | --- | --- |
| Windows M1 | Default | `Ctrl+Alt+1` … `Ctrl+Alt+7` shortcuts |
| Windows M2 | Tap `M` on Windows M1 | App and window controls |
| Windows M1 + Fn | Hold `Fn` on Windows M1 | Numbers, Alt-Tab, mouse, navigation |
| Windows M2 + Fn | Hold `Fn` on Windows M2 | Text editing |
| Linux M1 / M2 | Switch OS, then tap `M` | Same base layout as Windows M1 |
| Linux + Fn | Hold `Fn` on Linux | Mouse movement and navigation (mostly transparent) |

### Windows M2 — App and Window Controls

| Row | Col 1 | Col 2 | Col 3 | Col 4 |
| --- | --- | --- | --- | --- |
| 1 | `Alt+Tab` | `Win+E` | `M` | `Fn` |
| 2 | `Win+Tab` | `Win+R` | `Win+Left` | `Ctrl` |
| 3 | `Win+D` | `Win+Up` | `Win+Down` | `Esc` |
| 4 | `Alt+F4` | `Win+L` | `Win+Right` | `Enter` |

### Windows M1 + Fn — Numbers, Mouse, and Navigation

| Row | Col 1 | Col 2 | Col 3 | Col 4 |
| --- | --- | --- | --- | --- |
| 1 | `Alt-Tab*` | `5` | `OS†` | `—` |
| 2 | `Win+D` | `6` | `Mouse Left` | `Ctrl` |
| 3 | `Win+F` | `Mouse Up` | `Mouse Down` | `Mouse Btn1` |
| 4 | `CAS‡` | `Backspace` | `Mouse Right` | `Mouse Btn2` |

- `Alt-Tab*` (row 1, col 1): first press holds `Alt` and taps `Tab`.
  Further presses send `Tab` while `Alt` stays held. Pressing any other
  key releases `Alt` and exits the mode.
- `Win+D` (row 2, col 1) and `Win+F` (row 3, col 1) are on the first
  column, under the base `Ctrl+Alt+2` / `Ctrl+Alt+3` positions.
- `CAS‡` (row 4, col 1) arms one-shot `Ctrl+Alt+Shift`. While armed,
  tapping `1`–`6` sends that digit with `Ctrl+Alt+Shift`, then disarms.
  Tap `CAS‡` again to cancel before tapping a number. `7` is not part of
  this mode.
- `Backspace` is at row 4, col 2 (the base `Ctrl+Alt+7` position).
- Mouse keys mirror the base arrows: `Left`/`Up`/`Down`/`Right` become
  `Mouse Left`/`Up`/`Down`/`Right`; base `Esc`/`Enter` become
  left/right mouse click.
- `OS†` is at row 1, col 3 (the base `M` position) and requires `Ctrl`
  to be held.

### Windows M2 + Fn — Text Editing

| Row | Col 1 | Col 2 | Col 3 | Col 4 |
| --- | --- | --- | --- | --- |
| 1 | `Ctrl+Z` | `Ctrl+V` | `OS†` | `—` |
| 2 | `Ctrl+Y` | `Ctrl+A` | `Ctrl+Left` | `Ctrl` |
| 3 | `Ctrl+X` | `Home` | `End` | `Esc` |
| 4 | `CAS‡` | `Ctrl+Backspace` | `Ctrl+Right` | `Enter` |

- Row 1–3 provide undo (`Ctrl+Z`), redo (`Ctrl+Y`), cut (`Ctrl+X`),
  paste (`Ctrl+V`), select-all (`Ctrl+A`), `Home`/`End`, word-wise
  `Ctrl+Left`/`Ctrl+Right`, and word-wise delete (`Ctrl+Backspace`).
- There is no `Ctrl+C` on this layer.
- `OS†` (row 1, col 3) requires `Ctrl` to be held.
- `CAS‡` (row 4, col 1) behaves as on Windows M1 + Fn: while armed,
  `Z`/`Y`/`X`/`V`/`A` send `1`/`2`/`3`/`5`/`6` with
  `Ctrl+Alt+Shift`, then disarm. Tap `CAS‡` again to cancel.
- `—` (row 1, col 4) is transparent and keeps the Fn layer held.

### Linux + Fn — Mouse Movement and Navigation

Mostly transparent; transparent keys fall through to the Linux base layer.

| Row | Col 1 | Col 2 | Col 3 | Col 4 |
| --- | --- | --- | --- | --- |
| 1 | `—` | `—` | `OS†` | `—` |
| 2 | `—` | `—` | `Mouse Left` | `Ctrl` |
| 3 | `—` | `Mouse Up` | `Mouse Down` | `—` |
| 4 | `—` | `—` | `Mouse Right` | `—` |

- `OS†` (row 1, col 3) requires `Ctrl` to be held.
- `Ctrl` (row 2, col 4) and the four mouse directions are the only
  solid keys; everything else falls through to the base
  `Ctrl+Alt+number` / arrow layout.

### VIA Layer Order

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

## Matrix Wiring

The firmware defaults to GPIO numbers:

- Rows: `GP9`, `GP10`, `GP11`, `GP12`
- Columns: `GP1`, `GP2`, `GP3`, `GP4`
- Diodes: `COL2ROW`

USB identity: VID `0x4449` (the DIY `DI` identifier) and PID `0x0001`.

The matrix must have one diode per switch. For `COL2ROW`, put the diode
in the row connection with its stripe/band toward the column side (away
from the row wire); use `ROW2COL` if your physical diode orientation is
opposite.

To swap the two four-pin groups, change this line in
`firmware/keyboards/pico_4x4/config.h`:

```c
#define PICO_4X4_LOW_PINS_ARE_ROWS 0
```

Change `0` to `1`. To reverse diode orientation, change `COL2ROW` to
`ROW2COL` on the `DIODE_DIRECTION` line in the same file.

## Setup, Build, Test, and Flash

From this directory:

```bash
make setup
make build
```

Run the complete workflow with:

```bash
make all
```

The default firmware is intentionally a separate non-VIA build. To build
the VIA-enabled variant instead, select its keymap:

```bash
make build KEYMAP=via
make flash KEYMAP=via
```

This creates `.artifacts/pico_4x4_via.uf2`. Flash that file before opening
`usevia.app`.

Other useful targets are `make help`, `make test`, `make lint`,
`make doctor`, and `make clean`. `make lint` checks the base QMK keyboard
metadata; the VIA variant is checked by the project tests and compiled
with `make build KEYMAP=via`.

The first command creates `.venv`, installs the QMK CLI into it, and
clones the upstream QMK checkout into the ignored `.qmk_firmware`
directory. Once installed, later setup/build commands reuse the venv
without network access. To explicitly upgrade QMK, run
`FORCE_QMK_UPDATE=1 make setup`. The build output is:

```text
.artifacts/pico_4x4_default.uf2
```

## VIA Configuration

Because this is a local DIY keyboard and its development VID/PID is not
in VIA's hosted database, load the project definition manually:

1. Open [usevia.app](https://usevia.app/) in Chrome or Edge.
2. Enable `Show Design Tab` in Settings.
3. In the Design tab, remove any older `Pico 4x4` draft definition, then
   load `firmware/keyboards/pico_4x4/via.json` as a draft definition.
4. Return to Configure, unplug/reconnect the Pico, and authorize it.

The VIA definition maps the visual key positions to the transposed
electrical matrix used by this hand-wired board, so the UI shows the same
4x4 arrangement as the physical keypad.

## Upload

1. Hold `BOOTSEL` while plugging the Pico into USB, or double-tap the
   Pico reset button after the firmware has been installed once.
2. Run:

   ```bash
   make flash
   ```

The uploader detects common Linux and macOS mount paths. If it cannot
find the drive, pass it explicitly:

```bash
make flash DRIVE=/media/$USER/RPI-RP2
```

To test the selected file and destination without copying:

```bash
make flash DRIVE=/media/$USER/RPI-RP2 DRY_RUN=1
```

## Local Checks

```bash
make test
```
