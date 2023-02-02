#!/usr/bin/env bash

set -o errexit
set -o pipefail

PRJ_ROOT="$( dirname "$(realpath "$( dirname "${BASH_SOURCE[0]}")")" )"
export PRJ_ROOT
export PRJ_TMP="$PRJ_ROOT/tmp"

mkdir -p "$PRJ_TMP"

runDockerCompose() {
    docker compose --project-directory "$PRJ_ROOT" --env-file=/etc/jehon/restricted/jenkins.env "$@"
}
