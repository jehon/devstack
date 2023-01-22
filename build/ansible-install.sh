#!/usr/bin/env bash

set -o errexit
set -o pipefail

pip install --upgrade --target .python ansible ansible-lint ansible-vault

PWD="$(pwd)"

export PATH="$PWD/.python/bin:$PATH"
export PYTHONPATH="$PWD/.python:$PATH"
