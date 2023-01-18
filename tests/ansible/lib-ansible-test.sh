#!/usr/bin/env bash

set -o errexit
set -o pipefail

# Script Working Directory
SWD="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

# shellcheck source=SCRIPTDIR/../test-helpers.sh
. "$SWD/../test-helpers.sh"

TEST_NAME="$(basename "${BASH_SOURCE[1]}")"
exec &> >( jh-tag-stdin "$TEST_NAME" )

echo "*******************************************************"
echo "***"
echo "*** Test in docker: $TEST_NAME"
echo "***"
echo "*******************************************************"

# shellcheck disable=SC2120
# shellcheck disable=SC2119
test_in_docker() {
	IMG="${1:-test-dockers/devcontainer:local}"

	echo "***    - image: $IMG"

	(
		cat <<-'EOS'
			echo "+ pre-script begin"
			set -o errexit
			set -o pipefail

			header_begin "Custom script"
		EOS
		cat -
		cat <<-'EOS'
			echo
			header_end
		EOS
	) | docker run --label temp --rm -i --privileged "$IMG" "bash" \
		|& jh-tag-stdin "inside" \
		|| jh_fatal "!! Test failed: $TEST_NAME ($?) !!"

	echo "**************************************"
	echo "***                                ***"
	echo "*** Test in docker: $TEST_NAME - done"
	ok "docker test $TEST_NAME"
	echo "***                                ***"
	echo "**************************************"
}
