# PowerDNS Recursor Docker Image

## Supported tags and respective `Dockerfile` links

- [`4.4.0`, `latest` (*4.4.0/Dockerfile*)](https://github.com/hybridadmin/docker-pdns-recursor/tree/main/4.4.0/Dockerfile)
- [`4.3.0`, (*4.3.0/Dockerfile*)](https://github.com/hybridadmin/docker-pdns-recursor/tree/main/4.3.0/Dockerfile)

## What is PowerDNS Recursor?

PowerDNS Recursor is a high-performance DNS recursor with built-in scripting capabilities.
> [doc.powerdns.com/recursor](https://doc.powerdns.com/recursor/)

## How to use this image

### Standard usage

Run this container with the following command:

```console
docker run --name pdns-rec -d -p 53:53/udp -p 53:53/tcp --restart=always hybridadmin/pdns-recursor:latest
```

To run older versions use the version tag for the required container image, i.e for version 4.3.0, run the following command:

```console
docker run --name pdns-rec -d -p 53:53/udp -p 53:53/tcp --restart=always hybridadmin/pdns-recursor:4.3.0
```


### DNSBL support

By default, the settings below have been configured in /etc/powerdns/recursor.conf inside the container.

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

Additional settings from the official configuration documentation at https://doc.powerdns.com/recursor/settings.html can be added as well.



# User feedback

## Documentation

Documentation fo PowerDNS Recursor is available on the [project's website](https://doc.powerdns.com/recursor/).
