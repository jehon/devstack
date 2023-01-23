#!/usr/bin/env bash

JENKINS_JAR="/tmp/jenkins-cli.jar"

if [ ! -r "$JENKINS_JAR" ]; then
    echo -n "Getting jenkins-cli.jar"
    while ! curl -fsSL "$JENKINS_LOCAL_URL"/jnlpJars/jenkins-cli.jar --output "$JENKINS_JAR" &>/dev/null; do
        sleep 1
        echo -n "."
    done
    echo " done"
fi

java -jar "$JENKINS_JAR" -webSocket "$@"
