#!/usr/bin/env bash

set -o errexit
set -o pipefail

ROOT="$(realpath "$( dirname "${BASH_SOURCE[0]}")")"

dc() {
    docker compose --env-file=/etc/jehon/restricted/jenkins.env "$@"
}

case "$1" in
    "-f" )
        dc down
        dc rm
        ;;
    "-d" )
        OPTS=( "-d" )
        ;;
esac

mkdir -p jenkins/built/secrets

if [ ! -r jenkins/built/secrets/master.key ]; then
    cp -f /etc/jehon/restricted/jenkins-master.key jenkins/built/secrets/master.key
fi

dc up --remove-orphans --build "${OPTS[@]}"
