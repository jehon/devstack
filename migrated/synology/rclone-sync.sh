#!/usr/bin/env bash

set -o errexit

# shellcheck source=SCRIPTDIR/lib.sh
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/lib.sh

# "$TMP"/rclone/rclone lsd --max-depth 1 pcloud:/

syncOne() {
	SOURCE="$1"
	TARGET="$2"
	echo "************************************************"
	echo "*** Syncing $SOURCE to $TARGET..."
	echo "************************************************"
	if [ ! -r "$TARGET" ]; then
		echo "TARGET $TARGET not found"
		exit 1
	fi

	#
	# rclone help flags
	#  --max-backlog (Kb): the backlog size (checking files) - https://rclone.org/docs/#max-backlog-n
	#
	#
	# https://rclone.org/filtering/
	# https://rclone.org/docs/
	#
	#

	"$TMP"/rclone/rclone sync \
		--verbose \
		pcloud:/"$SOURCE" "$TARGET" \
		--track-renames --transfers=1 --max-backlog 200000 \
		--exclude "@eaDir" --exclude "@eaDir/**"

	echo "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
	echo "vvv Syncing $SOURCE to $TARGET done"
	echo "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
}

kill_rclone

syncOne "Documents" "$MAIN_VOLUME/Documents"
syncOne "Photos" "$MAIN_VOLUME/Photos"
syncOne "Musiques" "$MAIN_VOLUME/Musiques"
syncOne "Videos" "$MAIN_VOLUME/Videos"

echo "ok"
