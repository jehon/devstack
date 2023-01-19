#!/usr/bin/env bash

set -o errexit

# The root of the repository
PRJ_ROOT="$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)")"
export PRJ_ROOT

PRJ_TEST_DATA="$PRJ_ROOT/tests/data"
export PRJ_TEST_DATA

fatal() {
    echo "$@" >&2
    exit 1
}