#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

SWD="$(realpath "$( dirname "${BASH_SOURCE[0]}")")"

for S in */*-backup.sh ; do
    echo "*** backup $( basename "$S") "
    # "$S"
done

echo "*** All done"
