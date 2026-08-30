#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
VENV="$ROOT/.venv"
QMK_HOME="$ROOT/.qmk_firmware"
PYTHON_BIN="${PYTHON_BIN:-python3}"

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
    echo "error: $PYTHON_BIN was not found" >&2
    exit 1
fi

if ! command -v git >/dev/null 2>&1; then
    echo "error: git is required to download QMK Firmware" >&2
    exit 1
fi

if [[ ! -x "$VENV/bin/python" ]]; then
    echo "Creating Python virtual environment at $VENV"
    "$PYTHON_BIN" -m venv "$VENV"
fi

if [[ ! -x "$VENV/bin/qmk" || "${FORCE_QMK_UPDATE:-0}" == "1" ]]; then
    echo "Installing QMK CLI in the virtual environment"
    "$VENV/bin/python" -m pip install --upgrade pip qmk
else
    echo "QMK CLI already installed in $VENV"
fi

if [[ -d "$QMK_HOME/.git" ]]; then
    echo "QMK Firmware already initialized at $QMK_HOME"
elif [[ -e "$QMK_HOME" ]]; then
    echo "error: $QMK_HOME exists but is not a QMK git checkout" >&2
    exit 1
else
    echo "Cloning QMK Firmware into $QMK_HOME"
    "$VENV/bin/qmk" setup -H "$QMK_HOME" -y
fi

echo "QMK setup complete"
