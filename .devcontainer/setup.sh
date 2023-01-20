#!/usr/bin/env bash

set -o errexit
set -o pipefail

SWD="$(dirname "${BASH_SOURCE[0]}")"

PRJ_ROOT="$(dirname "$SWD")"
export PRJ_ROOT

$SWD/ansible-requirements.sh
