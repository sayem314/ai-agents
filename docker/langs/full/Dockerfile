# ai-agents-lang-full — all stacks via official images (multi-stage) + agent deps
# Tag: ai-agents-lang-full:latest
FROM node:24-bookworm AS node
ENV PATH="/root/.bun/bin:${PATH}"
COPY docker/common/install-node-tooling.sh /tmp/install-node-tooling.sh
RUN bash /tmp/install-node-tooling.sh && rm /tmp/install-node-tooling.sh

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
    PATH="/usr/local/bin:/usr/local/node-runtime/bin:/root/.bun/bin:/root/.local/bin:/usr/local/go/bin:/go/bin:/usr/local/cargo/bin:${PATH}"

COPY docker/common/install-agent-deps.sh /tmp/install-agent-deps.sh
RUN bash /tmp/install-agent-deps.sh && rm /tmp/install-agent-deps.sh \
    && curl -LsSf "https://astral.sh/uv/${UV_VERSION}/install.sh" | sh \
    && apt-get update \
    && apt-get install -y --no-install-recommends clang lld \
    && rm -rf /var/lib/apt/lists/*

# Full Node tree under a separate prefix — partial bin/lib copies break npm/pnpm shims.
COPY --from=node /usr/local /usr/local/node-runtime
COPY --from=node /root/.bun /root/.bun

COPY --from=go /usr/local/go /usr/local/go
RUN mkdir -p /go/bin

COPY --from=rust /usr/local/cargo /usr/local/cargo
COPY --from=rust /usr/local/rustup /usr/local/rustup

COPY docker/common/install-playwright.sh /tmp/install-playwright.sh
RUN bash /tmp/install-playwright.sh && rm /tmp/install-playwright.sh

RUN node --version && npm --version && pnpm --version && bun --version \
    && python3 --version | grep -qE '^Python 3\.14\.' \
    && go version \
    && rustc --version && cargo --version \
    && uv --version \
    && playwright --version

COPY docker/common/install-login-path.sh /tmp/install-login-path.sh
RUN bash /tmp/install-login-path.sh && rm /tmp/install-login-path.sh \
    && bash -lc 'command -v node playwright go uv >/dev/null'

LABEL org.opencontainers.image.title="ai-agents-lang-full"
