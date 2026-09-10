# Download base image
# Pin to linux/amd64: Sencha Cmd (and especially its bundled Fashion Sass compiler)
# ship x86_64-only binaries. On arm64 hosts (Apple Silicon) an arm64 image can run the
# Java/Ruby parts but NOT Fashion. Building amd64 lets the whole toolchain run under
# Rosetta emulation. Requires "Use Rosetta for x86/amd64 emulation" in Docker Desktop.
FROM ruby:2.7.4-bullseye

# LABEL about this image
LABEL org.opencontainers.image.title="SenchaCmd"
LABEL org.opencontainers.image.description="Dockerimage for building ExtJS apps with SenchaCmd"
LABEL org.opencontainers.image.revision="2.3.0"
LABEL org.opencontainers.image.licenses="GNU GPLv3"
LABEL org.opencontainers.image.authors="Benjamin W. Bohl https://github.com/bwbohl"
LABEL org.opencontainers.image.ref.name="bwbohl_sencha-cmd_2.3.0"
LABEL org.opencontainers.image.base.name="ruby:2.7.4-bullseye"
LABEL org.opencontainers.image.documentation="https://github.com/bwbohl/sencha-cmd"
LABEL org.opencontainers.image.source="https://github.com/bwbohl/sencha-cmd"
LABEL org.opencontainers.image.url="https://github.com/bwbohl/sencha-cmd"
LABEL org.opencontainers.image.version="7.0.0.40+6.7.0.63+6.2.0.103-CE"


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

# Install SenchaCmd 6.2.0.103 (matched Cmd for Ext 6.2.0; also builds Ext 5.1.1 — the Cmd 6.x line retains Ext 5 support)
RUN wget -q --show-progress --progress=bar:force:noscroll -P /tmp http://cdn.sencha.com/cmd/6.2.0.103/no-jre/SenchaCmd-6.2.0.103-linux-amd64.sh.zip && \
    unzip -q /tmp/SenchaCmd-6.2.0.103-linux-amd64.sh.zip -d /tmp  && \
    unlink /tmp/SenchaCmd-6.2.0.103-linux-amd64.sh.zip  && \
    chmod o+x /tmp/SenchaCmd-6.2.0.103-linux-amd64.sh && \
    /tmp/SenchaCmd-6.2.0.103-linux-amd64.sh -Dall=true -q -dir /opt/Sencha/Cmd/6.2.0.103 && \
    unlink /tmp/SenchaCmd-6.2.0.103-linux-amd64.sh

# Install SenchaCmd 6.7.0.63 (latest 6.x: has the ES6->ES5 transpiler introduced in Cmd 6.5, while the 6.x line still builds Ext 5.1.1)
RUN wget -q --show-progress --progress=bar:force:noscroll -P /tmp http://cdn.sencha.com/cmd/6.7.0.63/no-jre/SenchaCmd-6.7.0.63-linux-amd64.sh.zip && \
    unzip -q /tmp/SenchaCmd-6.7.0.63-linux-amd64.sh.zip -d /tmp  && \
    unlink /tmp/SenchaCmd-6.7.0.63-linux-amd64.sh.zip  && \
    chmod o+x /tmp/SenchaCmd-6.7.0.63-linux-amd64.sh && \
    /tmp/SenchaCmd-6.7.0.63-linux-amd64.sh -Dall=true -q -dir /opt/Sencha/Cmd/6.7.0.63 && \
    unlink /tmp/SenchaCmd-6.7.0.63-linux-amd64.sh

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

# Increase JVM max heap for all Sencha Cmd versions.
# The default -Xmx1024m OOMs ("Java heap space") when the Closure Compiler
# transpiles large frameworks (e.g. Ext 5.1.1) from ES6 to ES5.
RUN for v in 6.2.0.103 6.7.0.63 7.0.0.40; do \
        sed -i 's/^-Xmx.*/-Xmx4g/' /opt/Sencha/Cmd/$v/sencha.vmoptions; \
    done

ENTRYPOINT [ "/bin/bash", "-l", "-c" ]

WORKDIR /app
