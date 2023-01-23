#!/usr/bin/env bash

set -o errexit
set -o pipefail

ROOT="$(realpath "$( dirname "${BASH_SOURCE[0]}")")"

case "$1" in
    "-f" )
        docker compose down
        docker compose rm
        ;;
esac

if [ ! -r jenkins/built/secrets/master.key ]; then
    mkdir -p jenkins/built/secrets
    sudo rsync -r /etc/jehon/restricted/jenkins/ jenkins/built/secrets 
    sudo chown -R jehon:jehon jenkins/built/
fi

docker compose up --build
