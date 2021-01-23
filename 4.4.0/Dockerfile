FROM ubuntu:focal as powerdns
LABEL maintainer="Tinashe Chikomo"

ENV NAME=pdns_recursor \
    PDNS_RECURSOR_VERSION=4.4.0 \
    VERSION=1.2 \
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

ADD 4.4.0/pdns.list /etc/apt/sources.list.d/pdns.list

ADD 4.4.0/pdns /etc/apt/preferences.d/pdns

RUN curl https://repo.powerdns.com/FD380FBB-pub.asc -o /tmp/FD380FBB-pub.asc && \
    sudo apt-key add /tmp/FD380FBB-pub.asc  && \
    set -x && \
    DEBIAN_FRONTEND=noninteractive apt-get update -qqy && apt-get install -yqq --no-install-recommends \
      pdns-recursor \
      ldnsutils && \
    mkdir -p /var/run/pdns-recursor && \
    sed -i -e 's/^#\ allow-from=.*/allow-from=0.0.0.0\/0/g' \
        -e 's/^#\ version-string.*/version-string=Not Supported/g' \
        -e 's/^setuid=.*/setuid=daemon/' \
        -e 's/^setgid=.*/setgid=daemon/' \
        -e 's/^local-address=127.0.0.1/local-address=0.0.0.0/' \
        -e 's/^#\ max-cache-ttl=.*/max-cache-ttl=28800/g' \
        -e 's/^#\ max-negative-ttl=.*/max-negative-ttl=3600/g' \
        -e 's/^#\ packetcache-ttl=.*/packetcache-ttl=3600/g' \
        -e 's/^#\ gettag-needs-edns-options=.*/gettag-needs-edns-options=yes/g' \
        -e 's/^#\ use-incoming-edns-subnet=.*/use-incoming-edns-subnet=yes/g' \
        -e 's/^#\ any-to-tcp=.*/any-to-tcp=yes/g' \
        -e 's/^#\ reuseport=.*/reuseport=yes/g' \
        -e 's/^#\ socket-dir=/socket-dir=\/var\/run/' /etc/powerdns/recursor.conf && \
    rm -rf \
        /tmp/* \
        /var/tmp/* \
        /var/lib/apt/lists/*

EXPOSE 53/tcp
EXPOSE 53/udp

VOLUME "/etc/powerdns/"

HEALTHCHECK --interval=5s --timeout=3s --start-period=5s CMD drill @127.0.0.1 cloudflare.com || exit 1

CMD ["pdns_recursor"]
