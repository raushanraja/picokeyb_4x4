#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
DRIVE=""
DRY_RUN=0
UF2=""

usage() {
    cat <<'EOF'
Usage: upload.sh [--dry-run] [--drive PATH] [UF2_PATH]

Builds the default firmware when UF2_PATH is omitted, then copies it to
an RP2040 RPI-RP2 bootloader volume.
EOF
}

while (($# > 0)); do
    case "$1" in
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        --drive)
            if (($# < 2)); then
                echo "error: --drive requires a path" >&2
                exit 2
            fi
            DRIVE=$2
            shift 2
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
            if [[ -n "$UF2" ]]; then
                echo "error: only one UF2 path may be supplied" >&2
                exit 2
            fi
            UF2=$1
            shift
            ;;
    esac
done

if [[ -z "$UF2" ]]; then
    "$ROOT/scripts/build.sh"
    UF2="$ROOT/.artifacts/pico_4x4_default.uf2"
fi

if [[ ! -f "$UF2" ]]; then
    echo "error: UF2 file not found: $UF2" >&2
    exit 1
fi

case "${UF2,,}" in
    *.uf2) ;;
    *)
        echo "error: firmware file must have a .uf2 extension: $UF2" >&2
        exit 1
        ;;
esac

if [[ -z "$DRIVE" ]]; then
    user_name=${USER:-$(id -un)}
    candidates=(
        "/media/$user_name/RPI-RP2"
        "/run/media/$user_name/RPI-RP2"
        "/Volumes/RPI-RP2"
    )
    for candidate in "${candidates[@]}"; do
        if [[ -f "$candidate/INFO_UF2.TXT" ]]; then
            DRIVE=$candidate
            break
        fi
    done
fi

if [[ -z "$DRIVE" ]]; then
    echo "error: RPI-RP2 bootloader drive not found" >&2
    echo "Hold BOOTSEL while plugging in the Pico, then retry with:" >&2
    echo "  $0 --drive /path/to/RPI-RP2" >&2
    exit 1
fi

if [[ ! -d "$DRIVE" || ! -f "$DRIVE/INFO_UF2.TXT" ]]; then
    echo "error: not an RP2040 RPI-RP2 bootloader drive: $DRIVE" >&2
    exit 1
fi

destination="$DRIVE/pico_4x4.uf2"
if ((DRY_RUN)); then
    echo "DRY RUN: would copy $UF2 to $destination"
else
    cp -- "$UF2" "$destination"
    sync
    echo "Uploaded $UF2 to $destination"
fi
