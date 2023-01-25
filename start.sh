#!/usr/bin/env bash

set -o errexit
set -o pipefail

ROOT="$(realpath "$( dirname "${BASH_SOURCE[0]}")")"
cd "$ROOT"

mkdir -p jenkins/built/secrets
if [ ! -r jenkins/built/secrets/master.key ]; then
    cp -f /etc/jehon/restricted/jenkins-master.key jenkins/built/secrets/master.key
fi

dc() {
    docker compose --env-file=/etc/jehon/restricted/jenkins.env "$@"
}

OPTS=( )
case "$1" in
    "-f" )
        dc down
        dc rm
        OPTS+="--build"
        ;;
    "-d" )
        OPTS+="-d"
        ;;
esac

dc up --remove-orphans "${OPTS[@]}"
