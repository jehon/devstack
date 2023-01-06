#!/usr/bin/env bash

#
# We expose two variable to reuse it from start-debian
#   TEST_OS
#   TEST_NAME
#

set -o errexit
set -o pipefail

# Script Working Directory
SWD="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

# shellcheck source=SCRIPTDIR/lib-packages-test.sh
. "$SWD/lib-packages-test.sh"

(
	cat <<-'EOS'
		ok_ko "Repository github is disabled" "apt policy | grep jehon.github.io | grep 12"
		ok_ko "sshd config file is installed" "[ -r "/etc/ssh/sshd_config.d/jehon.conf" ]"

		sshd_version="$(ssh -V 2>&1 | awk -F '[^0-9.]+' '{print $2}')"
		ok_ko "sshd version is ok (found $sshd_version)" "[[ '$sshd_version' > '8.1' ]]"

		cat /etc/inputrc | grep "set bell-style none" > /dev/null || jh_fatal "Patching /etc/inputrc incorrect"
	EOS
) | test_in_docker
