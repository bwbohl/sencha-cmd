# Download base image
FROM openjdk:8-jre-slim

# LABEL about this image
LABEL maintainer="bwbohl@gmail.com"

# Update software repository
#RUN apt update

# Update installed software
#RUN apt upgrade


# Install curl and unzip
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        unzip \
		libfreetype6 \
		fontconfig \
	&& rm -rf /var/lib/apt/lists/*

# Installing SenchaCmd
RUN curl --silent http://cdn.sencha.com/cmd/7.3.0.19/no-jre/SenchaCmd-7.3.0.19-linux-amd64.sh.zip -o /tmp/sencha.zip && \
    unzip /tmp/sencha.zip -d /tmp  && \
    unlink /tmp/sencha.zip  && \
    chmod o+x /tmp/SenchaCmd-7.3.0.19-linux-amd64.sh && \
    /tmp/SenchaCmd-7.3.0.19-linux-amd64.sh -q -dir /opt/Sencha/Cmd/7.3.0.19 && \
    unlink /tmp/SenchaCmd-7.3.0.19-linux-amd64.sh

WORKDIR /app

ENV PATH="/opt/Sencha/Cmd:${PATH}"

ENTRYPOINT [ "/opt/Sencha/Cmd/sencha" ]
