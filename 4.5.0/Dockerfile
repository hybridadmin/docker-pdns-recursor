FROM debian:buster-slim as powerdns
LABEL maintainer="Tinashe Chikomo"

ENV NAME=pdns_recursor \
    PDNS_RECURSOR_VERSION=4.5.0 \
    VERSION=1.1 \
    SUMMARY="${NAME} is a high-performance DNS recursor with built-in scripting capabilities." \
    DESCRIPTION="${NAME} is a high-performance DNS recursor with built-in scripting capabilities."

ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

LABEL summary="${SUMMARY}" \
      description="${DESCRIPTION}" \
      io.k8s.description="${DESCRIPTION}" \
      io.k8s.display-name="${NAME} ${PDNS_RECURSOR_VERSION}" \
      name="hybridadmin/${NAME}" \
      maintainer="Tinashe Chikomo"

WORKDIR /tmp/src

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qqy && apt-get install -qqy apt-utils sudo curl gnupg

ADD ${PDNS_RECURSOR_VERSION}/pdns.list /etc/apt/sources.list.d/pdns.list

ADD ${PDNS_RECURSOR_VERSION}/pdns /etc/apt/preferences.d/pdns

RUN curl https://repo.powerdns.com/FD380FBB-pub.asc -o /tmp/FD380FBB-pub.asc && \
    sudo apt-key add /tmp/FD380FBB-pub.asc  && \
    set -x && \
    DEBIAN_FRONTEND=noninteractive apt-get update -qqy && apt-get install -yqq --no-install-recommends \
      pdns-recursor \
      ldnsutils && \
    mkdir -p /var/run/pdns-recursor && \
    rm -rf \
        /tmp/* \
        /var/tmp/* \
        /var/lib/apt/lists/*

ADD docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

RUN chmod a+x /usr/bin/docker-entrypoint.sh

EXPOSE 53/tcp
EXPOSE 53/udp

WORKDIR "/etc/powerdns/"
#VOLUME "/etc/powerdns/"

HEALTHCHECK --interval=5s --timeout=3s --start-period=5s CMD drill @127.0.0.1 cloudflare.com || exit 1
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["pdns_recursor"]
