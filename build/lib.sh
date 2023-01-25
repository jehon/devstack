#!/usr/bin/env bash

set -o errexit
set -o pipefail

SWD="$(realpath "$( dirname "${BASH_SOURCE[0]}")")"
PRJ_ROOT="$( dirname "$SWD" )"

export PRJ_ROOT

runDockerCompose() {
    docker compose --env-file=/etc/jehon/restricted/jenkins.env "$@"
}
