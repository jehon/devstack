#!/usr/bin/env bash

set -o errexit
set -o pipefail

PRJ_ROOT="$( dirname "$(realpath "$( dirname "${BASH_SOURCE[0]}")")" )"
PRJ_TMP="$PRJ_ROOT/tmp"

export PRJ_ROOT
export PRJ_TMP

mkdir -p "$PRJ_TMP"

runDockerCompose() {
    docker compose --env-file=/etc/jehon/restricted/jenkins.env "$@"
}
