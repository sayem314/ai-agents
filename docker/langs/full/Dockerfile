# ai-agents-lang-full — all stacks via official images (multi-stage) + agent deps
# Tag: ai-agents-lang-full:latest
FROM golang:1.26-bookworm AS go

FROM rust:1-bookworm AS rust

FROM python:3.14-bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TERM=xterm-256color \
    UV_VERSION=0.11.18 \
    GOPATH=/go \
    RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH="/usr/local/bin:/root/.bun/bin:/root/.local/bin:/usr/local/go/bin:/go/bin:/usr/local/cargo/bin:${PATH}"

COPY docker/common/install-agent-deps.sh /tmp/install-agent-deps.sh
RUN bash /tmp/install-agent-deps.sh && rm /tmp/install-agent-deps.sh \
    && curl -LsSf "https://astral.sh/uv/${UV_VERSION}/install.sh" | sh \
    && apt-get update \
    && apt-get install -y --no-install-recommends clang lld \
    && rm -rf /var/lib/apt/lists/*

COPY --from=node:24-bookworm /usr/local/bin/node /usr/local/bin/node
COPY --from=node:24-bookworm /usr/local/bin/npm /usr/local/bin/npm
COPY --from=node:24-bookworm /usr/local/bin/npx /usr/local/bin/npx
COPY --from=node:24-bookworm /usr/local/lib/node_modules /usr/local/lib/node_modules

COPY docker/common/install-node-tooling.sh /tmp/install-node-tooling.sh
RUN bash /tmp/install-node-tooling.sh && rm /tmp/install-node-tooling.sh

COPY --from=go /usr/local/go /usr/local/go
RUN mkdir -p /go/bin

COPY --from=rust /usr/local/cargo /usr/local/cargo
COPY --from=rust /usr/local/rustup /usr/local/rustup

RUN node --version && npm --version && pnpm --version && bun --version \
    && python3 --version | grep -qE '^Python 3\.14\.' \
    && go version \
    && rustc --version && cargo --version \
    && uv --version

LABEL org.opencontainers.image.title="ai-agents-lang-full"
