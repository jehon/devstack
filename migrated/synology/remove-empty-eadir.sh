#!/usr/bin/env bash

set -o errexit
set -o pipefail
shopt -s nullglob

SWD="$(dirname "$( realpath "${BASH_SOURCE[0]}")")"

if [ -n "$1" ]; then
    cd "$1"
fi

recurse() {
    local found

    echo "In $( pwd )"
    for f in * ; do
        case "$f" in
            "." | ".." )
                continue
                ;;
            "@eaDir" )
                continue
                ;;
        esac

        if [ -d "$f" ]; then
                if ! ( cd "$f" && recurse "$f" ) ; then
                    echo "Removing $f"
                    rmdir "$f"
                    continue
                fi
        fi

        found=1
    done

    if [ -z "$found" ]; then
        return 1
    fi

    return 0
}

recurse
