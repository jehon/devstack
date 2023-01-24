#!/usr/bin/env bash

set -o errexit
set -o pipefail

ROOT="$(realpath "$( dirname "${BASH_SOURCE[0]}")")"

case "$1" in
    "-f" )
        docker compose down
        docker compose rm
        ;;
    "-d" )
        OPTS=( "-d" )
        ;;
esac

mkdir -p jenkins/built/secrets

if [ ! -r jenkins/built/secrets/master.key ]; then
    cp -f /etc/jehon/restricted/jenkins-master.key jenkins/built/secrets/master.key
fi

docker compose --env-file=/etc/jehon/restricted/jenkins.env up --build "${OPTS[@]}"
