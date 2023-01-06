#!/usr/bin/env bash

set -o errexit

# shellcheck source=SCRIPTDIR/lib.sh
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/lib.sh

SCOPE="$1"

for F in "$ROOT/scripts/${SCOPE}.d"/*; do
    echo "Found $F"
    "$F" || echo "$F has failed, continuing..."
done
