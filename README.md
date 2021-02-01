# PowerDNS Recursor Docker Image

![ci](https://github.com/hybridadmin/docker-pdns-recursor/workflows/ci/badge.svg?branch=main) ![Docker Pulls](https://img.shields.io/docker/pulls/hybridadmin/pdns-recursor)

## Supported tags and respective `Dockerfile` links

- [`master`](https://github.com/hybridadmin/docker-pdns-recursor/tree/main/master/Dockerfile)
- [`4.5.0`](https://github.com/hybridadmin/docker-pdns-recursor/tree/main/4.5.0/Dockerfile)
- [`4.4.0`, `latest`](https://github.com/hybridadmin/docker-pdns-recursor/tree/main/4.4.0/Dockerfile)
- [`4.3.0`](https://github.com/hybridadmin/docker-pdns-recursor/tree/main/4.3.0/Dockerfile)

## What is PowerDNS Recursor?

PowerDNS Recursor is a high-performance DNS recursor with built-in scripting capabilities.
> [`doc.powerdns.com/recursor`](https://doc.powerdns.com/recursor/)

## Usage

### docker-compose
```yaml
---
version: "3.2"
services:
  pdns-recursor:
    image: hybridadmin/pdns-recursor:latest
    container_name: pdns-recursor-server
    hostname: pdns-recursor-server #optional
    environment:
      - USER_ID=daemon
      - GROUP_ID=daemon
      - SERVER_ID=disabled
      - DNSSEC_MODE=process-no-validate
      - LOCAL_ADDRESS=0.0.0.0
      - MAX_CACHE_TTL=28800
      - MAX_NEGATIVE_TTL=3600
      - PACKETCACHE_TTL=3600
      - GETTAG_NEEDS_EDNS_OPTIONS=no
      - USE_INCOMING_EDNS_SUBNET=no
      - ANY_TO_TCP=yes
    ports:
      - 53:53/tcp
      - 53:53/udp
    restart: always
```


### docker cli

Run a container with default settings:

```console
docker run -d -p 53:53/udp -p 53:53/tcp --restart=always hybridadmin/pdns-recursor:latest
```

To run a container with customized settings:
```console
docker run -d --name tester_dns \
-e USER_ID=daemon #optional \
-e GROUP_ID=daemon #optional \
-e SERVER_ID=disabled \
-e DNSSEC_MODE=process-no-validate \
-e LOCAL_ADDRESS=0.0.0.0 #optional \
-e MAX_CACHE_TTL=28800 #optional \
-e MAX_NEGATIVE_TTL=3600 #optional \
-e PACKETCACHE_TTL=3600 #optional \
-e GETTAG_NEEDS_EDNS_OPTIONS=no #optional \
-e USE_INCOMING_EDNS_SUBNET=no #optional \
-e ANY_TO_TCP=yes #optional \
-p 53:53/udp -p 53:53/tcp -p 8081:8081/tcp --restart=always hybridadmin/pdns-recursor:latest
```

Connect to the container:
```console
docker exec -it [container_id] /bin/bash
```

### Configuration Settings

By default, the settings below have been configured in `/etc/powerdns/recursor.conf` via the script [`docker-entrypoint.sh`](./docker-entrypoint.sh) inside the container.

Example `recursor.conf`:
```
    local-address=0.0.0.0
    allow-from=0.0.0.0/0
    version-string=Not Supported
    setuid=daemon
    setgid=daemon
    max-cache-ttl=28800
    max-negative-ttl=3600
    packetcache-ttl=3600
    gettag-needs-edns-options=yes
    use-incoming-edns-subnet=yes
    any-to-tcp=yes
    reuseport=yes
    socket-dir=/var/run
```

Additional settings from the official configuration [`documentation`](https://doc.powerdns.com/recursor/settings.html) can be added as well if needed.


## Environment Variables

| Variable | Function |
| :----: | --- |
| `USER_ID` | User to change to after binding to socket |
| `GROUP_ID` | Group to change to after binding to socket |
| `SERVER_ID` | The reply given by The PowerDNS recursor to a query for ‘id.server’  |
| `DNSSEC_MODE` | Set the mode for DNSSEC processing, [`more info`](https://docs.powerdns.com/recursor/dnssec.html) |
| `LOCAL_ADDRESS` | Local IP address(es) to bind to |
| `MAX_CACHE_TTL` | Maximum number of seconds to cache an item in the DNS cache |
| `MAX_NEGATIVE_TTL` | Maximum amount of time negative entries are cached |
| `PACKETCACHE_TTL` | Maximum number of seconds to cache an item in the packet cache |
| `GETTAG_NEEDS_EDNS_OPTIONS` | Specify whether to extract and pass EDNS options in incoming queries |
| `USE_INCOMING_EDNS_SUBNET` | Specify whether to process and pass along a received EDNS Client Subnet to authoritative servers |
| `ANY_TO_TCP` | Answer questions for the ANY type on UDP with a truncated packet that refers the remote server to TCP |
