#!/usr/bin/env bash

set -o errexit
set -o pipefail

PWD="$(pwd)"

SWD="$(realpath "$( dirname "${BASH_SOURCE[0]}")")"
. "$SWD"/lib.sh

# pip install --upgrade --target .python ansible ansible-lint ansible-vault

# export PATH="$PWD/.python/bin:$PATH"
# export PYTHONPATH="$PWD/.python:$PATH"

mkdir -p "$PRJ_ROOT"/ansible/built

if [ ! -r "$PRJ_ROOT"/ansible/built/ansible-key ]; then
    if [ -r /etc/jehon/restricted/ansible-key ]; then
        echo "* Linking ansible-key to restricted one"
        ln -fs /etc/jehon/restricted/ansible-key "$PRJ_ROOT"/ansible/built/ansible-key
    else
        echo "* Creating dummy ansible-key"
        echo "1234" > "$PRJ_ROOT"/ansible/built/ansible-key
    fi
fi

if [ ! -r "$PRJ_ROOT"/ansible/built/ansible_ssh_key ]; then
    if [ -r /etc/jehon/restricted/ansible_ssh_key ]; then
        echo "* Linking ansible_ssh_key to restricted one"
        ln -fs /etc/jehon/restricted/ansible_ssh_key "$PRJ_ROOT"/ansible/built/ansible_ssh_key
    else 
        if [ -r $HOME/.ssh/id_rsa ]; then
            echo "* Linking ansible_ssh_key to home ssh key"
            ln -fs $HOME/.ssh/id_rsa "$PRJ_ROOT"/ansible/built/ansible_ssh_key
        fi
    fi
fi

echo "* Allow direnv"
direnv allow "$PRJ_ROOT"/ansible
