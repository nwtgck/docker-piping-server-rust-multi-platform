FROM alpine:3.15.0 as download

ARG TARGETPLATFORM

RUN apk add --no-cache curl

RUN case $TARGETPLATFORM in \
      linux/amd64)  target="x86_64-unknown-linux-musl";; \
      linux/arm64)  target="aarch64-unknown-linux-musl";; \
      linux/arm/v7) target="armv7-unknown-linux-musleabihf";; \
      linux/arm/v6) target="arm-unknown-linux-musleabi";; \
      *)            exit 1;; \
    esac &&\
    curl -L https://github.com/nwtgck/piping-server-rust/releases/download/v0.10.2/piping-server-${target}.tar.gz | tar xzf - &&\
    cp ./piping-server-${target}/piping-server /piping-server

FROM scratch

COPY --from=download /piping-server /piping-server

ENTRYPOINT ["/piping-server"]
