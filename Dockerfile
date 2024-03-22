FROM ghcr.io/linuxserver/wireguard:1.0.20210914

LABEL maintainer="dezza" \
      version="0.1"

RUN apk add --no-cache libnatpmp

COPY /root /
