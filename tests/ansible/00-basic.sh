#!/usr/bin/env bash

set -o errexit
set -o pipefail

# Script Working Directory
SWD="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

# shellcheck source=SCRIPTDIR/lib-ansible-test.sh
. "$SWD/lib-ansible-test.sh"

(
	cat <<-'EOS'

		echo "************* Ansible is installed *******************"
		ansible --version
		test "$(type -p ansible)" = "/.python/bin/ansible"
		test "$(type -p ansible-playbook)" = "/.python/bin/ansible-playbook"

		echo "************* Share ansible is mounted *******************"
		ls ansible.cfg

		echo "************* Secrets are ok *******************"
		ls /ansible/inventory/
		cat /ansible/inventory/00-all_vars.yml
		! cat /ansible/inventory/00-all_vars.yml | grep -q '!vault'

	EOS
) | test_in_docker
