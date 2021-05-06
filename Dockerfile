# Download base image
FROM openjdk:8-jre-slim

# LABEL about this image
LABEL maintainer="bwbohl@gmail.com"

ENV ANT_VERSION=1.10.10
ENV ANT_HOME=/opt/ant

# Update software repository
#RUN apt update

# Update installed software
#RUN apt upgrade

# Install wget and unzip and ruby
RUN apt-get update && apt-get install -y --no-install-recommends \
        wget \
        unzip \
		libfreetype6 \
		fontconfig \
        ruby-full \
	&& rm -rf /var/lib/apt/lists/*

# Download and extract Apache Ant to opt folder
RUN wget --no-check-certificate --no-cookies http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
    && wget --no-check-certificate --no-cookies http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz.sha512 \
    && echo "$(cat apache-ant-${ANT_VERSION}-bin.tar.gz.sha512) apache-ant-${ANT_VERSION}-bin.tar.gz" | sha512sum -c \
    && tar -zvxf apache-ant-${ANT_VERSION}-bin.tar.gz -C /opt/ \
    && ln -s /opt/apache-ant-${ANT_VERSION} /opt/ant \
    && unlink apache-ant-${ANT_VERSION}-bin.tar.gz \
    && unlink apache-ant-${ANT_VERSION}-bin.tar.gz.sha512    

# Installing SenchaCmd
RUN wget --no-check-certificate --no-cookies http://cdn.sencha.com/cmd/7.3.0.19/no-jre/SenchaCmd-7.3.0.19-linux-amd64.sh.zip \
    && unzip SenchaCmd-7.3.0.19-linux-amd64.sh.zip -d /tmp \
    && unlink SenchaCmd-7.3.0.19-linux-amd64.sh.zip \
    && chmod o+x /tmp/SenchaCmd-7.3.0.19-linux-amd64.sh \
    && /tmp/SenchaCmd-7.3.0.19-linux-amd64.sh -Dall=true -q -dir /opt/Sencha/Cmd/7.3.0.19 \
    && unlink /tmp/SenchaCmd-7.3.0.19-linux-amd64.sh

WORKDIR /app

ENV PATH="/opt/Sencha/Cmd:${PATH}"

ENTRYPOINT [ "/opt/Sencha/Cmd/sencha" ]
