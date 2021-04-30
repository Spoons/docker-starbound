FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
ENV STARBOUND_PATH="/steam/starbound"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN \
 set +x && \
 echo steam steam/question select "I AGREE" | debconf-set-selections && \
 echo steam steam/license note '' | debconf-set-selections && \
 dpkg --add-architecture i386 && \
 apt-get update -y && \
 apt-get install -y --no-install-recommends ca-certificates locales gosu steamcmd && \
 apt-get clean autoclean && \
 apt-get autoremove -y && \
 rm -rf /var/lib/apt/lists/* && \
 locale-gen en_US.UTF-8 && \
 ln -s /usr/games/steamcmd /usr/bin/steamcmd && \
 steamcmd +quit
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en'
ADD root /
ENTRYPOINT ["/bin/entry.sh"]
