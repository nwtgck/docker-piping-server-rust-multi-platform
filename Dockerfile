FROM --platform=linux/amd64 alpine:3.15.0 as download

ARG TARGETPLATFORM

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
    curl -L https://github.com/krallin/tini/releases/download/v0.19.0/tini-static-${tini_static_arch} > /tini-static &&\
    chmod +x /tini-static &&\
    curl -L https://github.com/nwtgck/piping-server-rust/releases/download/v0.10.2/piping-server-${rust_target}.tar.gz | tar xzf - &&\
    cp ./piping-server-${rust_target}/piping-server /piping-server

FROM scratch

COPY --from=download /tini-static /tini-static
COPY --from=download /piping-server /piping-server

ENTRYPOINT [ "/tini-static", "--", "/piping-server" ]
