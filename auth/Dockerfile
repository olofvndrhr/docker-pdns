FROM git.44net.ch/44net/debian-s6:12

LABEL maintainer="Ivan Schaller" \
    description="powerdns-auth"

COPY rootfs /

RUN \
    echo "**** installing pdns-auth ****" \
    && install -d /etc/apt/keyrings \
    && curl https://repo.powerdns.com/FD380FBB-pub.asc | tee /etc/apt/keyrings/auth-pub.asc \
    && apt-get update \
    && apt-get install -y \
        # https://repo.powerdns.com/debian/dists/bookworm-auth-49/main/binary-amd64/Packages
        pdns-server=4.9.5-1pdns.bookworm \
        pdns-backend-lmdb \
        pdns-backend-bind \
        pdns-backend-mysql \
        pdns-backend-pgsql \
        pdns-backend-sqlite3 \
        dns-root-data \
        publicsuffix

RUN \
    echo "**** creating folders ****" \
    && rm -rf /etc/powerdns \
    && mv /etc/_powerdns /etc/powerdns \
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
