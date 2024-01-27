FROM rust:1.75-bullseye as builder

ENV PDNS_VERSION="5.0.1"

ENV MAKEFLAGS="--jobs 4"

# https://salsa.debian.org/debian/pdns-recursor/-/blob/master/debian/control?ref_type=heads
RUN \
    echo "*** installing deps ***" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    libboost-context-dev \
    libboost-dev \
    libboost-filesystem-dev \
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-test-dev \
    libboost-thread-dev \
    libcap-dev \
    libcurl4-openssl-dev \
    libfstrm-dev \
    liblua5.3-dev \
    libluajit-5.1-dev \
    libprotobuf-dev \
    libsnmp-dev \
    libsodium-dev \
    libssl-dev \
    libsystemd-dev \
    pkgconf \
    ragel \
    dns-root-data \
    publicsuffix \
    dpkg-dev \
    equivs

ADD "https://downloads.powerdns.com/releases/pdns-recursor-${PDNS_VERSION}.tar.bz2" /source/

RUN \
    echo "*** installing pdns-recursor ***" \
    && mkdir /build \
    && cd /source \
    && tar -xf "pdns-recursor-${PDNS_VERSION}.tar.bz2" \
    && cd "pdns-recursor-${PDNS_VERSION}" \
    && LUAVER="$(if [ "$(dpkg --print-architecture)" == "arm64" ]; then echo "lua5.3"; else echo "luajit"; fi)" \
    ./configure \
    --prefix=/usr \
    --sysconfdir=/etc/powerdns \
    --sbindir=/usr/sbin \
    --with-libsodium \
    --with-lua=${LUAVER} \
    --with-net-snmp \
    --enable-option-checking=fatal \
    --enable-dns-over-tls \
    --enable-auto-var-init=zero \
    --disable-silent-rules \
    --disable-systemd \
    && make clean \
    && make install DESTDIR=/build \
    && make clean \
    && strip /build/usr/bin/* /build/usr/sbin/*

RUN \
    echo "*** preparing stuff ***" \
    && mkdir -p \
    /build/tmp/ \
    /tmp/debian/ \
    && cd /tmp \
    && echo 'Source: docker-deps-for-pdns' > debian/control \
    && dpkg-shlibdeps /build/usr/bin/* /build/usr/sbin/* \
    && sed 's/^shlibs:Depends=/Depends: /' debian/substvars >> debian/control \
    && equivs-build debian/control \
    && dpkg-deb -I equivs-dummy_1.0_all.deb \
    && cp equivs-dummy_1.0_all.deb /build/tmp/

#####

FROM git.44net.ch/44net-assets/debian-s6:11

LABEL maintainer="Ivan Schaller" \
    description="powerdns cluster: recursor"

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
    /var/run/pdns-recursor \
    /etc/powerdns/recursor.d \
    && chown -R abc:abc \
    /var/run/pdns-recursor \
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

EXPOSE 53/udp
EXPOSE 53/tcp
EXPOSE 8082/tcp
