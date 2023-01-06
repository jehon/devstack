#!/usr/bin/env bash

set -o errexit
set -o pipefail

# Script Working Directory
SWD="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

# shellcheck source=SCRIPTDIR/lib-packages-test.sh
. "$SWD/lib-packages-test.sh"

(
	cat <<-'EOS'
		( cd /setup/ansible && ansible-playbook setup.yml --connection=local --limit piscine )
	EOS
) | test_in_docker
