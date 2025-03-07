# Download base image
FROM ruby:2.7.4-bullseye

# LABEL about this image
LABEL maintainer="bwbohl@gmail.com"

ARG ANT_VERSION=1.10.12
ARG ANT_HOME=/opt/ant
#ARG SENCHACMD_VERSION=7.6.0.33

# Update software repository
RUN apt-get update -y -q

# Update installed software
#RUN apt upgrade

# Install JRE8 from adoptium

## Ensure necessary packages are present
### apparently not necessary as already present in baseimage
###RUN apt-get install -y sudo wget apt-transport-https gpg

## Download the Eclipse Adoptium GPG key
RUN wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null

## Configure the Eclipse Adoptium apt repository
RUN echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list

## Install JRE8
### TODO test --no-install-recommends
RUN apt-get update -y -q \
    && apt-get -y install temurin-8-jre

# Install ant
RUN apt-get install -y --no-install-recommends \
    ant

# Cleanup after apt-get installs
RUN rm -rf /var/lib/apt/lists/*


# Install nodejs and npm
#RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
#    && sudo apt update \
#    && sudo apt update \
#    && sudo apt install -y nodejs


# Installing SenchaCmd Community Edition

# download senchaCmd
RUN curl --silent http://cdn.sencha.com/cmd/7.0.0.40/no-jre/SenchaCmd-7.0.0.40-linux-amd64.sh.zip -o /tmp/senchaCmd.zip && \
    unzip /tmp/senchaCmd.zip -d /tmp  && \
    unlink /tmp/senchaCmd.zip  && \
    chmod o+x /tmp/SenchaCmd-7.0.0.40-linux-amd64.sh && \
    /tmp/SenchaCmd-7.0.0.40-linux-amd64.sh -Dall=true -q -dir /opt/Sencha/Cmd/7.0.0.40 && \
    unlink /tmp/SenchaCmd-7.0.0.40-linux-amd64.sh

# add 5.1.1-gpl
RUN cd /opt/Sencha \
    && pwd \
    && wget -c http://cdn.sencha.com/ext/gpl/ext-5.1.1-gpl.zip \
    && unzip ext-5.1.1-gpl.zip \
    && unlink /opt/Sencha/ext-5.1.1-gpl.zip

# add 6.2.0-gpl
RUN cd /opt/Sencha \
    && pwd \
    && wget -c http://cdn.sencha.com/ext/gpl/ext-6.2.0-gpl.zip \
    && unzip ext-6.2.0-gpl.zip \
    && unlink /opt/Sencha/ext-6.2.0-gpl.zip

# add 7.0.0-gpl
RUN cd /opt/Sencha \
    && pwd \
    && wget -c http://cdn.sencha.com/ext/gpl/ext-7.0.0-gpl.zip \
    && unzip ext-7.0.0-gpl.zip \
    && unlink /opt/Sencha/ext-7.0.0-gpl.zip

# TODO increase vmmemory for build
# vim /opt/Sencha/Cmd/7.0.0.40/sencha.vmoptions
#RUN ls /opt/Sencha/Cmd/7.0.0.40/sencha.vmoptions \
#    && cat /opt/Sencha/Cmd/7.0.0.40/sencha.vmoptions

#RUN file_contents=$(</opt/Sencha/Cmd/7.0.0.40/sencha.vmoptions) \
#    && echo "${file_contents//E/X}" > /opt/Sencha/Cmd/7.0.0.40/sencha.vmoptions

#RUN wget --no-check-certificate --no-cookies https://cdn.sencha.com/cmd/${SENCHACMD_VERSION}/no-jre/SenchaCmd-${SENCHACMD_VERSION}-linux-amd64.sh.zip \
#    && unzip SenchaCmd-${SENCHACMD_VERSION}-linux-amd64.sh.zip -d /tmp \
#    && unlink SenchaCmd-${SENCHACMD_VERSION}-linux-amd64.sh.zip \
#    && chmod o+x /tmp/SenchaCmd-${SENCHACMD_VERSION}*-linux-amd64.sh \
#    && /tmp/SenchaCmd-${SENCHACMD_VERSION}*-linux-amd64.sh -Dall=true -q -dir /opt/Sencha/Cmd/${SENCHACMD_VERSION} \
#    && unlink /tmp/SenchaCmd-${SENCHACMD_VERSION}*-linux-amd64.sh

WORKDIR /app

ENV PATH="/opt/ant/bin:/opt/Sencha/Cmd:${PATH}"
