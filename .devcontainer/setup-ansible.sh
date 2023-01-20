#!/usr/bin/env bash

set -o errexit
set -o pipefail

PRJ_ROOT="$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)")"
export PRJ_ROOT

apt update

apt_install() {
    # /repo is not always available
    DEBIAN_FRONTEND=noninteractive apt install --quiet --yes "$@"
}

echo "*** Configure python3"
apt_install python-is-python3 python3 python3-pip python3-netaddr

if [ ! -r /etc/jehon/restricted/ansible-key ]; then
    mkdir -p /etc/jehon/restricted
    echo "1234" > /etc/jehon/restricted/ansible-key
fi
