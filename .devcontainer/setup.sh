#!/usr/bin/env bash

set -o errexit
set -o pipefail

SWD="$(dirname "${BASH_SOURCE[0]}")"

PRJ_ROOT="$(dirname "$SWD")"
export PRJ_ROOT

apt update

mkdir tmp
curl -fsSL https://jehon.github.io/packages/jehon.deb -o tmp/jehon.deb
chmod 777 tmp
apt install --yes ./tmp/jehon.deb

"$SWD"/ansible-requirements.sh
