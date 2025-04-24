FROM git.44net.ch/44net/debian-s6:11

LABEL maintainer="Ivan Schaller" \
    description="powerdns-dnsdist"

COPY rootfs /

RUN \
    echo "**** installing pdns-dnsdist ****" \
    && install -d /etc/apt/keyrings \
    && curl https://repo.powerdns.com/FD380FBB-pub.asc | tee /etc/apt/keyrings/dnsdist-pub.asc \
    && apt-get update \
    && apt-get install -y \
        # https://repo.powerdns.com/debian/dists/bullseye-dnsdist-20/main/binary-amd64/Packages
        dnsdist=2.0.0~alpha1-1pdns.debian11 \
        dns-root-data

RUN \
    echo "**** creating folders ****" \
    && rm -rf /etc/dnsdist \
    && mv /etc/_dnsdist /etc/dnsdist \
    && mkdir -p \
        /var/run/dnsdist \
        /etc/dnsdist/conf.d \
    && chown -R abc:abc \
        /var/run/dnsdist \
        /etc/dnsdist \
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
EXPOSE 443/udp
EXPOSE 443/tcp
EXPOSE 853/udp
EXPOSE 853/tcp
