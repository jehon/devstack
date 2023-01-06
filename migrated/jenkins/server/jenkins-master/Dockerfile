#
# https://github.com/jenkinsci/docker/blob/master/README.md
#
# !! /var/jenkins_home will be mounted as volume
#    nothing can be stored there from here
#

FROM jenkins/jenkins:lts

ENV PATH="/jenkins-bin:${PATH:-}"
ENV PLUGINS_FORCE_UPGRADE=true
ENV JENKINS_URL=http://localhost:8080/jenkins
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false ${JAVA_OPTS:-}"
ENV TZ=Europe/Brussels
ENV JENKINS_GUEST_HOME="$JENKINS_HOME"
ENV JENKINS_EXPORT=/mnt/docker/jenkins
ENV JENKINS_LOCAL_URL="http://localhost:8080/jenkins"

# See https://github.com/jenkinsci/docker/blob/master/README.md#installing-more-tools
ENV JENKINS_REF=/usr/share/jenkins/ref

 # Web access
EXPOSE 8080
EXPOSE 50000

WORKDIR $JENKINS_HOME

#####################################################
# Root section
#####################################################
USER root

RUN apt-get update && apt-get install -y rsync curl docker.io

# Add helper scripts
ADD ./jenkins-bin /jenkins-bin

## Add configuration to /tmp/config
ADD --chown=jenkins config/ /tmp/config

RUN mkdir $JENKINS_REF/secrets \
    && mkdir -p /etc/jehon/restricted/jenkins \
    && ln -s /secrets/hudson.util.Secret $JENKINS_REF/secrets/ \
    && ln -s /secrets/master.key $JENKINS_REF/secrets/ \
    && chown -R jenkins $JENKINS_REF/secrets/

RUN ls -al /usr/share/jenkins/ref/secrets/

#####################################################
# Back to jenkins user
#####################################################
USER jenkins

# Install plugins
RUN jenkins-plugin-cli --plugin-file /tmp/config/plugins.txt

# Copy all files directly into folder
ADD --chown=jenkins config/raw/ $JENKINS_GUEST_HOME
