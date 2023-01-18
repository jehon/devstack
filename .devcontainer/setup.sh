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

apt_install ansible ansible-lint

if [ ! -r /etc/jehon/restricted/ansible-key ]; then
    mkdir -p /etc/jehon/restricted
    echo "1234" > /etc/jehon/restricted/ansible-key
fi

cd "$PRJ_ROOT/ansible" && ansible-playbook setup.yml --vault-password-file "$PRJ_ROOT"/tests/ansible/ansible-test-key --limit dev
