# powerdns docker images for amd64 & arm64

## features

- amd64 & arm64 builds
- s6 supervisor
- common unix tools installed (tar, curl, rsync etc.)
- non-root image
- UID/GID freely changeable

## docker images in this repo

### [powerdns-recursor](https://github.com/PowerDNS/pdns/tree/master)

[docker hub](https://hub.docker.com/r/olofvndrhr/pdns-recursor)

image name: `olofvndrhr/pdns-recursor`

```bash
docker run olofvndrhr/pdns-recursor
```

### [powerdns-authoritative](https://github.com/PowerDNS/pdns/tree/master)

[docker hub](https://hub.docker.com/r/olofvndrhr/pdns-auth)

image name: `olofvndrhr/pdns-auth`

```bash
docker run olofvndrhr/pdns-auth
```

### [powerdns-lightningstream](https://github.com/PowerDNS/lightningstream)

[docker hub](https://hub.docker.com/r/olofvndrhr/pdns-lightningstream)

image name: `olofvndrhr/pdns-lightningstream`

```bash
docker run olofvndrhr/pdns-lightningstream
```

### examples

see [compose.example.yml](./compose.example.yml)

more examples in [config-examples](./config-examples/)
