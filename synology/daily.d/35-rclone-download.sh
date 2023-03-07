#!/usr/bin/env bash

# shellcheck source=SCRIPTDIR/../lib.sh
. "$(dirname "${BASH_SOURCE[0]}")"/../lib.sh

cd "$TMP"
ZIP="$TMP"/rclone.zip
EXT="$TMP"/rclone-zip
TARGET="$TMP"/rclone

date

echo "* Downloading rclone... "
rm -f "$ZIP"
/bin/curl -fsSL https://downloads.rclone.org/rclone-current-linux-arm.zip --output "$ZIP"
echo "* ...downloaded"

echo "* Extracting..."
rm -fr "$EXT"
mkdir "$EXT"
cd "$EXT"
7z x "$ZIP"
cd ..
echo "* ...extracted"

kill_rclone

echo "* Installing..."
rm -fr "$TARGET"
mv "$EXT"/rclone-v* "$TARGET"
rm -fr "$EXT"
echo "* ...installed"

echo "* Checking install..."
"$TARGET"/rclone version
echo "* ...checked"

if [ -r "$ROOT"/rclone.conf ]; then
    echo "* Installing config..."
    mkdir -p /root/.config/rclone/
    mv "$ROOT"/rclone.conf /root/.config/rclone/rclone.conf
    echo "* ...installed"
fi

echo "* Done"
