#!/bin/sh
set -e

PDNS_CONF="/etc/powerdns/recursor.conf"

if [ "$1" = "pdns_recursor" ]; then
    sed -i -e "s/^#\ allow-from=.*/allow-from=0.0.0.0\/0/g" \
        -e "s/^#\ version-string=.*/version-string=Not Supported/g" \
        -e "s/^setuid=.*/setuid=${USER_ID:-daemon}/" \
        -e "s/^setgid=.*/setgid=${GROUP_ID:-daemon}/" \
        -e "s/^local-address=127.0.0.1/local-address=${LOCAL_ADDRESS:-0.0.0.0}/" \
        -e "s/^#\ max-cache-ttl=.*/max-cache-ttl=${MAX_CACHE_TTL:-28800}/g" \
        -e "s/^#\ max-negative-ttl=.*/max-negative-ttl=${MAX_NEGATIVE_TTL:-3600}/g" \
        -e "s/^#\ packetcache-ttl=.*/packetcache-ttl=${PACKETCACHE_TTL:-3600}/g" \
        -e "s/^#\ gettag-needs-edns-options=.*/gettag-needs-edns-options=${GETTAG_NEEDS_EDNS_OPTIONS:-yes}/g" \
        -e "s/^#\ use-incoming-edns-subnet=.*/use-incoming-edns-subnet=${USE_INCOMING_EDNS_SUBNET:-yes}/g" \
        -e "s/^#\ any-to-tcp=.*/any-to-tcp=${ANY_TO_TCP:-yes}/g" \
        -e "s/^#\ server-id=.*/server-id=${SERVER_ID:-disabled}/g" \
        -e "s/^#\ dnssec=.*/dnssec=${DNSSEC_MODE:-off}/g" \
        -e "s/^#\ reuseport=.*/reuseport=yes/g" \
        -e "s/^#\ socket-dir=/socket-dir=\/var\/run/" ${PDNS_CONF}
fi

exec "$@"
