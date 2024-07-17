FROM git.44net.ch/44net/debian-builder:11 AS builder

ENV PDNS_VERSION="4.9.1"

ENV MAKEFLAGS="--jobs 4"

# https://salsa.debian.org/debian/pdns/-/blob/master/debian/control?ref_type=heads
RUN \
    echo "*** installing deps ***" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    default-libmysqlclient-dev \
    dnsutils \
    flex \
    libboost-all-dev \
    libcdb-dev \
    libcurl4-openssl-dev \
    libgeoip-dev \
    libkrb5-dev \
    libldap2-dev \
    liblmdb-dev \
    libluajit-5.1-dev \
    liblua5.3-dev \
    libmaxminddb-dev \
    libp11-kit-dev \
    libpq-dev \
    libprotobuf-dev \
    libsodium-dev \
    libsqlite3-dev \
    libssl-dev \
    libyaml-cpp-dev \
    pkgconf \
    po-debconf \
    protobuf-compiler \
    ragel \
    unixodbc-dev \
    dpkg-dev \
    equivs

ADD "https://downloads.powerdns.com/releases/pdns-${PDNS_VERSION}.tar.bz2" /source/

RUN \
    echo "*** installing pdns-server ***" \
    && mkdir /build \
    && cd /source \
    && tar -xf "pdns-${PDNS_VERSION}.tar.bz2" \
    && cd "pdns-${PDNS_VERSION}" \
    && LUAVER="$(if [ "$(dpkg --print-architecture)" == "arm64" ]; then echo "lua5.3"; else echo "luajit"; fi)" \
    ./configure \
    --prefix=/usr \
    --sysconfdir=/etc/powerdns \
    --sbindir=/usr/sbin \
    --with-modules="" \
    --with-dynmodules="bind geoip gmysql godbc gpgsql gsqlite3 ldap lmdb lua2 pipe remote tinydns" \
    --with-libsodium \
    # --with-lua=${LUAVER} \
    --with-lmdb \
    --with-unixodbc-lib="/usr/lib/$(dpkg-architecture -q DEB_BUILD_GNU_TYPE)" \
    --enable-ixfrdist \
    --enable-option-checking=fatal \
    --enable-dns-over-tls \
    --enable-lto=thin \
    --enable-auto-var-init=zero \
    --disable-dependency-tracking \
    --disable-silent-rules \
    --disable-systemd \
    && make clean \
    && make -C ext \
    && make -C modules \
    && make -C pdns \
    && make -C pdns install DESTDIR=/build \
    && make -C modules install DESTDIR=/build \
    && make clean \
    && strip /build/usr/bin/* /build/usr/sbin/* /build/usr/lib/pdns/*.so

RUN \
    echo "*** preparing stuff ***" \
    && mkdir -p \
    /build/tmp/ \
    /tmp/debian/ \
    && cd /tmp \
    && echo 'Source: docker-deps-for-pdns' > debian/control \
    && dpkg-shlibdeps /build/usr/bin/* /build/usr/sbin/* /build/usr/lib/pdns/*.so \
    && sed 's/^shlibs:Depends=/Depends: /' debian/substvars >> debian/control \
    && equivs-build debian/control \
    && dpkg-deb -I equivs-dummy_1.0_all.deb \
    && cp equivs-dummy_1.0_all.deb /build/tmp/

#####

FROM git.44net.ch/44net/debian-s6:11

LABEL maintainer="Ivan Schaller" \
    description="powerdns-auth"

COPY --from=builder /build /
COPY rootfs /

RUN \
    echo "*** installing runtime deps ***" \
    && chmod 1777 /tmp \
    && apt-get update \
    && apt-get install -y \
    /tmp/equivs-dummy_1.0_all.deb

RUN \
    echo "**** creating folders ****" \
    && mkdir -p \
    /var/run/pdns \
    /etc/powerdns/pdns.d \
    && chown -R abc:abc \
    /var/run/pdns \
    /etc/powerdns \
    && echo "*** other stuff ***" \
    && update-ca-certificates

RUN \
    echo "**** cleanup ****" \
    && apt-get purge --auto-remove -y \
    && apt-get clean \
    && rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

EXPOSE 5353/udp
EXPOSE 5353/tcp
EXPOSE 8081/tcp
