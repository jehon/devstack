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
		type -p ansible | grep .python/bin/ansible"
		type -p ansible-playbook | grep .python/bin/ansible-playbook

		echo "************* Share ansible is mounted *******************"
		ls ansible/ansible.cfg

		echo "************* Secrets are ok *******************"
		ls ansible/inventory/
		cat ansible/inventory/00-all_vars.yml
		! cat ansible/inventory/00-all_vars.yml | grep -q '!vault'

		cat ansible/conf/ansible-encryption-key
		! cat ansible/conf/ansible-encryption-key | grep -v "1234"
	EOS
) | test_in_docker
