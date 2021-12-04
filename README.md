# docker-piping-server-rust-multi-platform

Supports `linux/amd64`, `linux/arm64`, `linux/arm/v7` and `linux/arm/v6`.

```bash
docker run --platform=linux/arm64 -p 8080:8080 nwtgck/piping-server-rust-multi-platform
```

```bash
docker run --platform=linux/arm/v7 -p 8080:8080 nwtgck/piping-server-rust-multi-platform
```

```bash
docker run --platform=linux/arm/v6 -p 8080:8080 nwtgck/piping-server-rust-multi-platform
```

```bash
docker run --platform=linux/amd64 -p 8080:8080 nwtgck/piping-server-rust-multi-platform
```
