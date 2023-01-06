#!/usr/bin/env bash

# shellcheck source=SCRIPTDIR/lib.sh
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/lib.sh

echo "* Currently running"
# shellcheck disable=SC2009 # pgrep does not exist on synology
ps -e | grep rclone

kill_rclone

echo "ok"
