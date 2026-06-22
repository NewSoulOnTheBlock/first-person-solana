# Runtime image for First Person Solana (a customized cfoust/sour build).
# The prebuilt Linux binary and game assets are downloaded from this repo's
# GitHub Release at build time, so the git repo itself stays small.
FROM ubuntu:24.04

# Runtime libs the cgo-linked sour binary needs (built on Ubuntu 24.04).
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        libstdc++6 \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Which releases to pull artifacts from. Bump these to redeploy new builds.
ARG REPO=NewSoulOnTheBlock/first-person-solana
ARG BINARY_RELEASE=v3
ARG ASSETS_RELEASE=v1

# Download the prebuilt server binary and the game assets bundle.
RUN curl -fSL "https://github.com/${REPO}/releases/download/${BINARY_RELEASE}/sour" -o /app/sour \
    && chmod +x /app/sour \
    && mkdir -p /app/assets \
    && curl -fSL "https://github.com/${REPO}/releases/download/${ASSETS_RELEASE}/assets-dist.tar.gz" -o /tmp/assets.tar.gz \
    && tar xzf /tmp/assets.tar.gz -C /app/assets \
    && rm /tmp/assets.tar.gz

COPY prod.yaml /app/prod.yaml

# Render (and most PaaS) inject $PORT. Bind the HTTP server to it.
ENV PORT=10000
EXPOSE 10000

CMD ["/bin/sh", "-c", "exec /app/sour serve --address 0.0.0.0 --port ${PORT:-10000} /app/prod.yaml"]
