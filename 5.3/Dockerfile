FROM debian:trixie-slim AS powerdns
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

RUN set -x && DEBIAN_FRONTEND=noninteractive apt-get update -y && apt-get install -y apt-utils sudo curl gnupg2 && \
    echo "deb [signed-by=/etc/apt/keyrings/rec-53-pub.asc] http://repo.powerdns.com/debian trixie-rec-53 main" | tee /etc/apt/sources.list.d/pdns.list && \
    printf "Package: pdns-*\nPin: origin repo.powerdns.com\nPin-Priority: 600" >> /etc/apt/preferences.d/rec-53 && \
    mkdir -p /etc/apt/keyrings && curl https://repo.powerdns.com/FD380FBB-pub.asc | sudo tee /etc/apt/keyrings/rec-53-pub.asc && \
    apt-get update -y && apt-get install -y --no-install-recommends \
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
