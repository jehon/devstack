#!/usr/bin/env bash

. /usr/bin/jh-lib

SWD="$(realpath "$( dirname "${BASH_SOURCE[0]}")")"

export TMP="$SWD/../tmp/jenkins"
export JENKINS_JAR="$TMP/jenkins-cli.jar"
export JENKINS_DOCKER_NAME="jenkins"
export JENKINS_GUEST_HOME="/var/jenkins_home"
export JENKINS_URL="http://localhost:8080/jenkins"
export DS_ROOT="$SWD/../"

if [ -r /etc/jehon/restricted/jenkins.env ]; then
    . /etc/jehon/restricted/jenkins.env
fi

mkdir -p "$TMP"

if [ ! -r "$JENKINS_JAR" ]; then
    echo -n "Getting jenkins-cli.jar"
    while ! curl -fsSL "$JENKINS_URL"/jnlpJars/jenkins-cli.jar --output "$JENKINS_JAR" &>/dev/null; do
        sleep 1
        echo -n "."
    done
    echo " done"
fi

jenkins_cli() {
    # Need JENKINS_URL
    java -jar "$JENKINS_JAR" -s "$JENKINS_URL" -webSocket -auth "${JENKINS_SYSTEM_USER}:${JENKINS_SYSTEM_KEY}" "$@"
}

jenkins_check() {
    echo "## Testing connectivity..."
    jenkins_cli "who-am-i"
    echo "## Testing connectivity done"
}
