#!/usr/bin/env bash

set -o errexit
set -o pipefail

apt update

apt_install() {
    # /repo is not always available
    DEBIAN_FRONTEND=noninteractive apt install --quiet --yes "$@"
}

apt_install ansible ansible-lint
