FROM golang:1.22-bullseye as builder

ENV LS_VERSION="v0.4.2"

ENV GOBIN=/usr/local/bin

RUN \
    echo "*** installing lightningstream ***" \
    && git clone https://github.com/PowerDNS/lightningstream.git --depth 1 --branch "${LS_VERSION}" \
    && cd lightningstream \
    && go mod download \
    && go install ./cmd/lightningstream/

#####

FROM git.44net.ch/44net/debian-s6:11

LABEL maintainer="Ivan Schaller" \
    description="powerdns-lightningstream"

COPY --from=builder /usr/local/bin/lightningstream /usr/local/bin/lightningstream
COPY rootfs /

RUN \
    echo "*** other stuff ***" \
    && update-ca-certificates

VOLUME ["/data"]
