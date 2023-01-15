ARG baseImage=jenkins/jenkins:2.346.3-lts-jdk11

# Load the JFR docker image
FROM jenkins/jenkinsfile-runner:latest as jfr


FROM ${baseImage}

USER root
RUN jenkins-plugin-cli --plugins workflow-aggregator git configuration-as-code
# copy the files needed to run the JFR binary
COPY --from=jfr /app /app
#COPY --from=jfr /usr/share/jenkins/ref/plugins/*.hpi /usr/share/jenkins/ref/plugins
COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins/plugins.txt 

# We need to explode the jenkins.war for JFR
RUN cd /usr/share/jenkins && jar -xvf jenkins.war

VOLUME /usr/share/jenkins/ref/casc
# Apply JCasc
ENV JENKINS_HOME="/usr/share/jenkins/ref/"
ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/jenkins.yaml
COPY config/jenkins.yaml /usr/share/jenkins/ref/jenkins.yaml

ENTRYPOINT ["/app/bin/jenkinsfile-runner", "-w", "/usr/share/jenkins/", "-p", "/usr/share/jenkins/ref/plugins", "-f"]

CMD ["/workspace/Jenkinsfile"]
