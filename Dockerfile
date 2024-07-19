# Download base image
FROM openjdk:8-jre-slim

# LABEL about this image
LABEL maintainer="bwbohl@gmail.com"

ARG ANT_VERSION=1.10.12
ARG ANT_HOME=/opt/ant
#ARG SENCHACMD_VERSION=7.6.0.33

# Update software repository
#RUN apt update

# Update installed software
#RUN apt upgrade

# Install wget and unzip and ruby
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        sudo \
        wget \
        unzip \
		libfreetype6 \
		fontconfig \
        ruby-full \
	&& rm -rf /var/lib/apt/lists/*

# Install nodejs and npm
#RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
#    && sudo apt update \
#    && sudo apt update \
#    && sudo apt install -y nodejs

# Download and extract Apache Ant to opt folder
#RUN wget --no-check-certificate --no-cookies http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
#    && wget --no-check-certificate --no-cookies http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz.sha512 \
#    && echo "$(cat apache-ant-${ANT_VERSION}-bin.tar.gz.sha512) apache-ant-${ANT_VERSION}-bin.tar.gz" | sha512sum -c \
#    && tar -zvxf apache-ant-${ANT_VERSION}-bin.tar.gz -C /opt/ \
#    && ln -s /opt/apache-ant-${ANT_VERSION} /opt/ant \
#    && unlink apache-ant-${ANT_VERSION}-bin.tar.gz \
#    && unlink apache-ant-${ANT_VERSION}-bin.tar.gz.sha512

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
