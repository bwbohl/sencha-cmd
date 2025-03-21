# Download base image
FROM ruby:2.7.4-bullseye

# LABEL about this image
LABEL org.opencontainers.image.title="SenchaCmd"
LABEL org.opencontainers.image.description="Dockerimage for building ExtJS apps with SenchaCmd"
LABEL org.opencontainers.image.revision="2.0.0"
LABEL org.opencontainers.image.licenses="GNU GPLv3"
LABEL org.opencontainers.image.authors="Benjamin W. Bohl https://github.com/bwbohl"
LABEL org.opencontainers.image.ref.name="bwbohl_sencha-cmd_2.0.0"
LABEL org.opencontainers.image.base.name="ruby:2.7.4-bullseye"
LABEL org.opencontainers.image.documentation="https://github.com/bwbohl/sencha-cmd"
LABEL org.opencontainers.image.source="https://github.com/bwbohl/sencha-cmd"
LABEL org.opencontainers.image.url="https://github.com/bwbohl/sencha-cmd"
LABEL org.opencontainers.image.version="7.0.0.40-CE"


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

# Installing SenchaCmd Community Edition

# download senchaCmd
RUN wget -q --show-progress --progress=bar:force:noscroll -P /tmp http://cdn.sencha.com/cmd/7.0.0.40/no-jre/SenchaCmd-7.0.0.40-linux-amd64.sh.zip && \
    unzip -q /tmp/SenchaCmd-7.0.0.40-linux-amd64.sh.zip -d /tmp  && \
    unlink /tmp/SenchaCmd-7.0.0.40-linux-amd64.sh.zip  && \
    chmod o+x /tmp/SenchaCmd-7.0.0.40-linux-amd64.sh && \
    /tmp/SenchaCmd-7.0.0.40-linux-amd64.sh -Dall=true -q -dir /opt/Sencha/Cmd/7.0.0.40 && \
    unlink /tmp/SenchaCmd-7.0.0.40-linux-amd64.sh

# Add ExtJS versions
## add 5.1.1-gpl
RUN wget -q --show-progress --progress=bar:force:noscroll -P /opt/Sencha http://cdn.sencha.com/ext/gpl/ext-5.1.1-gpl.zip \
    && unzip -q /opt/Sencha/ext-5.1.1-gpl.zip \
    && unlink /opt/Sencha/ext-5.1.1-gpl.zip

## add 6.2.0-gpl
RUN wget -q --show-progress --progress=bar:force:noscroll -P /opt/Sencha http://cdn.sencha.com/ext/gpl/ext-6.2.0-gpl.zip \
    && unzip -q /opt/Sencha/ext-6.2.0-gpl.zip \
    && unlink /opt/Sencha/ext-6.2.0-gpl.zip

## add 7.0.0-gpl
RUN wget -q --show-progress --progress=bar:force:noscroll -P /opt/Sencha http://cdn.sencha.com/ext/gpl/ext-7.0.0-gpl.zip \
    && unzip -q /opt/Sencha/ext-7.0.0-gpl.zip \
    && unlink /opt/Sencha/ext-7.0.0-gpl.zip

# TODO increase vmmemory for build
# vim /opt/Sencha/Cmd/7.0.0.40/sencha.vmoptions
#RUN ls /opt/Sencha/Cmd/7.0.0.40/sencha.vmoptions \
#    && cat /opt/Sencha/Cmd/7.0.0.40/sencha.vmoptions

#RUN file_contents=$(</opt/Sencha/Cmd/7.0.0.40/sencha.vmoptions) \
#    && echo "${file_contents//E/X}" > /opt/Sencha/Cmd/7.0.0.40/sencha.vmoptions

ENTRYPOINT [ "/bin/bash", "-l", "-c" ]

WORKDIR /app
