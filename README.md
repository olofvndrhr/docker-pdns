# powerdns docker images for amd64 & arm64

> [github source](https://github.com/olofvndrhr/docker-pdns)

## features

- amd64 & arm64 builds
- s6 supervisor
- cron
- common unix tools installed (tar, curl, rsync etc.)
- non-root image
- UID/GID freely changeable

---

## infos for all images

### UID/GID + time-zone

the default UID/GID is set to `4444`. if you want to change it, set the ENV variables `PGID` and `PUID`.
same for the time-zone, set via ENV variable `TZ`.

```bash
docker run \
    -e TZ=Europe/Zurich \
    -e PGID=1001 \
    -e PUID=1001 \
    -v ./auth.conf:/etc/powerdns/pdns.d/auth.conf \
    olofvndrhr/pdns-recursor
```

```yml
# compose.yml
recursor:
  image: olofvndrhr/pdns-recursor:latest
  volumes:
    - ./recursor.conf/:/etc/powerdns/recursor.d/recursor.conf:ro
  environment:
    - TZ=Europe/Zurich
    - PUID=1001
    - PGID=1001
```

### cron

this image also has cron installed. custom crontabs should be placed in `/etc/cron.d/`.

```yml
# compose.yml
recursor:
  image: olofvndrhr/pdns-recursor:latest
  volumes:
    - ./recursor.conf/:/etc/powerdns/recursor.d/recursor.conf:ro
    - ./custom-crontab:/etc/cron.d/custom-crontab:ro
```

### examples

see [compose.example.yml](./compose.example.yml)

more examples in [config-examples](./config-examples/)

---

## [powerdns-recursor](https://github.com/PowerDNS/pdns/tree/master)

[**docker hub**](https://hub.docker.com/r/olofvndrhr/pdns-recursor)

**image name**: `olofvndrhr/pdns-recursor`

to use custom configs either override the default `/etc/powerdns/pdns.conf` or mount the
folder `/etc/powerdns/pdns.d/` to supply your own config files.

```bash
docker run \
    -v ./auth.conf:/etc/powerdns/pdns.d/auth.conf \
    olofvndrhr/pdns-recursor
```

### default config

```txt
local-address=0.0.0.0,::
include-dir=/etc/powerdns/pdns.d
launch=
```

---

## [powerdns-authoritative](https://github.com/PowerDNS/pdns/tree/master)

[**docker hub**](https://hub.docker.com/r/olofvndrhr/pdns-auth)

**image name**: `olofvndrhr/pdns-auth`

to use custom configs either override the default `/etc/powerdns/recursor.conf` or mount the
folder `/etc/powerdns/recursor.d/` to supply your own config files.

```bash
docker run \
    -v ./recursor.conf/:/etc/powerdns/recursor.d/recursor.conf \
    olofvndrhr/pdns-auth
```

### default config

```yml
incoming:
  listen:
    - 0.0.0.0
    - "::"

recursor:
  include_dir: /etc/powerdns/recursor.d
```

---

## [powerdns-lightningstream](https://github.com/PowerDNS/lightningstream)

[**docker hub**](https://hub.docker.com/r/olofvndrhr/pdns-lightningstream)

**image name**: `olofvndrhr/pdns-lightningstream`

to use your config, mount it at `/lightningstream.yml`.

```bash
docker run \
    -v ./lightningstream.yml:/lightningstream.yml \
    olofvndrhr/pdns-lightningstream
```

### env variables

| env variable   | usage                          | required |
| -------------- | ------------------------------ | -------- |
| AWS_ACCESS_KEY | S3 access key for LMDB storage | yes      |
| AWS_SECRET_KEY | S3 secret key for LMDB storage | yes      |
| INSTANCE_NAME  | _unique_ name for the instance | yes      |

### default config

> no default config in this image

## [powerdns-dnsdist](https://www.dnsdist.org/index.html)

[**docker hub**](https://hub.docker.com/r/olofvndrhr/pdns-dnsdist)

**image name**: `olofvndrhr/pdns-dnsdist`

to use custom configs mount your own config file to `/etc/dnsdist/dnsdist.yml`

```bash
docker run \
    -v ./dnsdist.yml:/etc/dnsdist/dnsdist.yml \
    olofvndrhr/pdns-dnsdist
```

### env variables

| env variable | usage                                                 | required |
| ------------ | ----------------------------------------------------- | -------- |
| CERT_DOMAIN  | domain of the certificate for DNS over TLS/HTTPS/QUIC | no       |

### default config

```yml
acl:
  - 0.0.0.0/0
  - ::/0

binds:
  - listen_address: "0.0.0.0:53"
    additional_addresses: ["[::]:53"]
    protocol: "Do53"

backends:
  - address: "127.0.0.1:53"
    protocol: "Do53"
    name: local-recursor
    tcp_only: true
    health_checks:
      qname: "a.root-servers.net."
      qtype: "AAAA"
      qclass: "CHAOS"
      must_resolve: true

load_balancing_policies:
  default_policy: "firstAvailable"
```
