FROM --platform=linux/amd64 alpine:3.18.0 as download

ARG TARGETPLATFORM

ENV TINI_STATIC_VERSION=0.19.0
ENV PIPING_SERVER_RUST_VERSION=0.16.0

RUN apk add --no-cache curl

RUN case $TARGETPLATFORM in\
      linux/amd64)  rust_target="x86_64-unknown-linux-musl";\
                    tini_static_arch="amd64";;\
      linux/arm64)  rust_target="aarch64-unknown-linux-musl";\
                    tini_static_arch="arm64";;\
      linux/arm/v7) rust_target="armv7-unknown-linux-musleabihf";\
                    tini_static_arch="armel";;\
      linux/arm/v6) rust_target="arm-unknown-linux-musleabi";\
                    tini_static_arch="armel";;\
      *)            exit 1;;\
    esac &&\
    curl -L https://github.com/krallin/tini/releases/download/v${TINI_STATIC_VERSION}/tini-static-${tini_static_arch} > /tini-static &&\
    chmod +x /tini-static &&\
    curl -L https://github.com/nwtgck/piping-server-rust/releases/download/v${PIPING_SERVER_RUST_VERSION}/piping-server-${rust_target}.tar.gz | tar xzf - &&\
    cp ./piping-server-${rust_target}/piping-server /piping-server

FROM scratch

COPY --from=download /tini-static /tini-static
COPY --from=download /piping-server /piping-server

ENTRYPOINT [ "/tini-static", "--", "/piping-server" ]
