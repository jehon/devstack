#!/usr/bin/env bash

set -o errexit
set -o pipefail

# Script Working Directory
SWD="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

# shellcheck source=SCRIPTDIR/lib-ansible-test.sh
. "$SWD/lib-ansible-test.sh"

(
	cat <<-'EOS'

		echo "************* ansible is installed *******************"
		ansible --version
		test "$(type -p ansible)" = "/.python/bin/ansible"
		test "$(type -p ansible-playbook)" = "/.python/bin/ansible-playbook"

		echo "************* ansible is mounted *******************"
		ls ansible.cfg

	EOS
) | test_in_docker
