#!/usr/bin/env bash

set -o errexit

# shellcheck source=SCRIPTDIR/lib.sh
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/lib.sh

SWD="$(dirname "$( realpath "${BASH_SOURCE[0]}")")"

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
	# --stats 99d: print stats only every 99 days (https://forum.rclone.org/t/can-we-have-rsync-kind-of-logs-with-rclone/9110/2?u=jehon)
	#
	#

	"$TMP"/rclone/rclone sync \
		--verbose \
		--stats 99d \
		pcloud:/"$SOURCE" "$TARGET" \
		--exclude "@eaDir" --exclude "@eaDir/**"

	"$SWD"/remove-empty-eadir.sh "$TARGET"

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
