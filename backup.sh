#!/usr/bin/env bash

set -o errexit
set -o pipefail

SWD="$(realpath "$( dirname "${BASH_SOURCE[0]}")")"

for S in */backup.sh ; do
    echo "*** backup in $( dirname "$S") "
    "$S"
done

echo "*** All done"
