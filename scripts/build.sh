#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
VENV="$ROOT/.venv"
QMK_HOME="$ROOT/.qmk_firmware"
SOURCE="$ROOT/firmware/keyboards/pico_4x4"
DEST="$QMK_HOME/keyboards/pico_4x4"
KEYMAP="${KEYMAP:-default}"
CLEAN=0

usage() {
    cat <<'EOF'
Usage: build.sh [KEYMAP] [--clean]

Compiles a Pico 4x4 QMK keymap and writes the UF2 to .artifacts.
KEYMAP defaults to default; supported project keymaps include default and via.
EOF
}

keymap_from_argument=0
while (($# > 0)); do
    case "$1" in
        --clean)
            CLEAN=1
            shift
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        --*)
            echo "error: unknown option: $1" >&2
            usage >&2
            exit 2
            ;;
        *)
            if ((keymap_from_argument)); then
                echo "error: only one keymap may be supplied" >&2
                usage >&2
                exit 2
            fi
            KEYMAP=$1
            keymap_from_argument=1
            shift
            ;;
    esac
done

if [[ ! "$KEYMAP" =~ ^[A-Za-z0-9_-]+$ ]]; then
    echo "error: invalid keymap name: $KEYMAP" >&2
    exit 2
fi

artifact_name="pico_4x4_${KEYMAP}.uf2"
OUTPUT="$ROOT/.artifacts/$artifact_name"

if [[ ! -x "$VENV/bin/qmk" || ! -d "$QMK_HOME/.git" ]]; then
    "$ROOT/scripts/setup_qmk.sh"
fi

if [[ ! -d "$SOURCE" ]]; then
    echo "error: tracked keyboard source is missing: $SOURCE" >&2
    exit 1
fi

mkdir -p "$QMK_HOME/keyboards"
mkdir -p "$DEST"
cp -a "$SOURCE"/. "$DEST"/

compile_args=(-kb pico_4x4 -km "$KEYMAP")
if ((CLEAN)); then
    compile_args+=(--clean)
fi

echo "Compiling pico_4x4/$KEYMAP"
(
    cd "$QMK_HOME"
    QMK_HOME="$QMK_HOME" "$VENV/bin/qmk" compile "${compile_args[@]}"
)

artifact="$QMK_HOME/$artifact_name"
if [[ ! -f "$artifact" ]]; then
    artifact=$(find "$QMK_HOME" -type f -name "$artifact_name" -print -quit)
fi

if [[ -z "$artifact" || ! -f "$artifact" ]]; then
    echo "error: QMK did not produce $artifact_name" >&2
    exit 1
fi

mkdir -p "$(dirname "$OUTPUT")"
cp -f "$artifact" "$OUTPUT"
echo "Built $OUTPUT"
