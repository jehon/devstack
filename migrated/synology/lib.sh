#!/usr/bin/env bash

set -o errexit

echo "* Loading lib.sh..."

export MAIN_VOLUME="/volume1"
export ROOT="$MAIN_VOLUME/scripts"
export TMP="$ROOT/temp"
SCRIPT="$(basename "$0")"
export SCRIPT
export LOG="$ROOT/temp/$SCRIPT.log"
export MIRROR_FOLDER="$MAIN_VOLUME/mirror"
export RCLONE="$TMP/rclone/rclone"

test_folder() {
    if [ ! -r "$2" ]; then
        echo "Folder $1 does not exists: $2" >&2
        exit 1
    fi
}
test_folder "ROOT" "$ROOT"

kill_rclone() {
    echo "* Killing running rclone..."
    pkill --echo --exact 'rclone' || true
    echo "* ...killed"
}

mkdir -p "$ROOT"/temp

echo "Log name: $LOG"

exec &> >(tee "$LOG")

date

echo "* Loading lib done..."
