#!/usr/bin/env bash

set -o errexit
set -o pipefail

# Script Working Directory
SWD="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

# shellcheck source=SCRIPTDIR/lib-packages-test.sh
. "$SWD/lib-packages-test.sh"

(
	cat <<-'EOS'

		ok_ko "lib can test something positive" "[ 1 == 1 ]"

		ok_ko "Testing Release is present" "[ -r /setup/repo/Release ]"
		ok_ko "Testing docker is present" "type docker"

		echo "************* all jehon packages available *******************"
		apt-cache search jehon

		echo "************* all version of jehon packages *******************"
		apt-cache policy
		apt-cache policy dpkg
		apt-cache policy jehon
	EOS
) | test_in_docker
