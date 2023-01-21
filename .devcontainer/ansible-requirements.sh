#!/usr/bin/env bash

set -o errexit
set -o pipefail

SWD="$(dirname "${BASH_SOURCE[0]}")"
ROOT="$( dirname "$SWD" )"

apt update

apt_install() {
    # /repo is not always available
    DEBIAN_FRONTEND=noninteractive apt install --quiet --yes "$@"
}

echo "*** Configure python3"
apt_install python-is-python3 python3 python3-pip python3-netaddr

if [ ! -r conf/ansible-key ]; then
    mkdir -p conf
    echo "1234" > conf/ansible-key
fi
