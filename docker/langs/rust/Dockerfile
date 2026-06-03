# ai-agents-lang-rust — official Rust image + agent deps
# Tag: ai-agents-lang-rust:latest
FROM rust:1-bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TERM=xterm-256color

COPY docker/common/install-agent-deps.sh /tmp/install-agent-deps.sh
RUN bash /tmp/install-agent-deps.sh && rm /tmp/install-agent-deps.sh \
    && apt-get update \
    && apt-get install -y --no-install-recommends clang lld \
    && rm -rf /var/lib/apt/lists/*

RUN rustc --version && cargo --version

COPY docker/common/install-login-path.sh /tmp/install-login-path.sh
RUN bash /tmp/install-login-path.sh && rm /tmp/install-login-path.sh

LABEL org.opencontainers.image.title="ai-agents-lang-rust"
