FROM ubuntu:bionic as powerdns
LABEL maintainer="Tinashe Chikomo"

ENV NAME=pdns_recursor \
    PDNS_RECURSOR_VERSION=4.4.2 \
    VERSION=1.2 \
    SUMMARY="${NAME} is a high-performance DNS recursor with built-in scripting capabilities." \
    DESCRIPTION="${NAME} is a high-performance DNS recursor with built-in scripting capabilities."

LABEL summary="${SUMMARY}" \
      description="${DESCRIPTION}" \
      io.k8s.description="${DESCRIPTION}" \
      io.k8s.display-name="${NAME} ${PDNS_RECURSOR_VERSION}" \
      name="hybridadmin/${NAME}" \
      maintainer="Tinashe Chikomo"

WORKDIR /tmp/src

RUN build_deps="g++ make pkg-config" && \
    program_deps="libboost-dev libboost-filesystem-dev libboost-serialization-dev \
    libboost-system-dev libboost-thread-dev libboost-context-dev libboost-test-dev \
    libssl-dev libboost-test-dev libluajit-5.1-dev liblua5.2-dev" && \
    set -x && \
    DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
      $build_deps \
      $program_deps \
      apt-utils \
      curl \
      sudo \
      ca-certificates \
      ldnsutils && \
      groupadd pdns && \
      useradd -g pdns -s /etc -d /dev/null pdns && \
      curl -sSL "https://downloads.powerdns.com/releases/pdns-recursor-${PDNS_RECURSOR_VERSION}.tar.bz2" -o pdns_recursor.tar.bz && \
    tar xjf pdns_recursor.tar.bz && \
    rm -f pdns_recursor.tar.bz && \
    cd "pdns-recursor-${PDNS_RECURSOR_VERSION}" && \
    ./configure \
        --with-lua=lua52 && \
    make && make install && \
    cp /usr/local/etc/recursor.conf-dist /usr/local/etc/recursor.conf && \
    sed -i -e "s/^#\ local-address=.*/local-address=0.0.0.0/g" \
        -e "s/^#\ allow-from=.*/allow-from=0.0.0.0\/0/g" \
        -e "s/^#\ version-string=.*/version-string=Not Supported/g" \
        -e "s/^#\ setgid=.*/setgid=pdns/g" \
        -e "s/^#\ setuid=.*/setuid=pdns/g" /usr/local/etc/recursor.conf && \
    mkdir -p /var/run/pdns-recursor && \
    apt-get purge -y --auto-remove \
      $build_deps && \
    rm -rf \
        /tmp/* \
        /var/tmp/* \
        /var/lib/apt/lists/*


EXPOSE 53/tcp
EXPOSE 53/udp

HEALTHCHECK --interval=5s --timeout=3s --start-period=5s CMD drill @127.0.0.1 cloudflare.com || exit 1

CMD ["pdns_recursor"]
