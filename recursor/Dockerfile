FROM git.44net.ch/44net/debian-s6:13

LABEL maintainer="Ivan Schaller" \
    description="powerdns-recursor"

COPY rootfs /

RUN \
    echo "**** installing pdns-recursor ****" \
    && install -d /etc/apt/keyrings \
    && curl https://repo.powerdns.com/FD380FBB-pub.asc | tee /etc/apt/keyrings/rec-pub.asc \
    && apt-get update \
    && apt-get install -y \
        # https://repo.powerdns.com/debian/dists/trixie-rec-53/main/binary-amd64/Packages
        pdns-recursor=5.3.0-1pdns.debian13 \
        dns-root-data \
        publicsuffix

RUN \
    echo "**** creating folders ****" \
    && rm -rf /etc/powerdns \
    && mv /etc/_powerdns /etc/powerdns \
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

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 CMD [ "rec_control", "ping" ]

VOLUME [ "/etc/powerdns" ]

EXPOSE 53/udp
EXPOSE 53/tcp
EXPOSE 8082/tcp
