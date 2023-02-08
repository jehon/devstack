#!/usr/bin/env bash

set -o errexit
set -o pipefail

# Script Working Directory
SWD="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

# shellcheck source=SCRIPTDIR/../test-helpers.sh
. "$SWD/../test-helpers.sh"

TEST_NAME="$(basename "${BASH_SOURCE[1]}")"
exec &> >( $PRJ_ROOT/build/tag "$TEST_NAME" )

echo "*******************************************************"
echo "***"
echo "*** Test in docker: $TEST_NAME"
echo "***"
echo "*******************************************************"

# shellcheck disable=SC2120
# shellcheck disable=SC2119
test_in_docker() {
	IMG="${1:-test-ansible/ansible}:local"

	# See also Dockerfile for ENV REMOTE_PRJ=
	REMOTE_PRJ="/workspace"

	echo "***    - image: $IMG"

	(
		cat <<-EOS
			echo "+ pre-script begin"
			set -o errexit
			set -o pipefail

			cd /$REMOTE_PRJ
			make ansible-dependencies
		EOS
		cat -
		cat <<-EOS
			set +x
			echo
		EOS
	) | docker run --rm --interactive  \
			-v "$PRJ_ROOT:$REMOTE_PRJ" \
			-v "$PRJ_ROOT/tmp/ansible/00-all_vars.yml:$REMOTE_PRJ/ansible/inventory/00-all_vars.yml" \
			-v "$PRJ_ROOT/tests/ansible-encryption-key:$REMOTE_PRJ/ansible/conf/ansible-encryption-key" \
			"$IMG" "bash" \
		|& $PRJ_ROOT/build/tag "inside" \
		|| fatal "!! Test failed: $TEST_NAME ($?) !!"

	echo "**************************************"
	echo "***                                ***"
	echo "*** Test in docker: $TEST_NAME - done"
	echo "***                                ***"
	echo "**************************************"
}
