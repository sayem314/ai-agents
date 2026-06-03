# ai-agents-lang-node — official Node.js image + agent deps
# Tag: ai-agents-lang-node:latest
FROM node:24-bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TERM=xterm-256color \
    PATH="/root/.bun/bin:${PATH}"

COPY docker/common/install-agent-deps.sh /tmp/install-agent-deps.sh
COPY docker/common/install-node-tooling.sh /tmp/install-node-tooling.sh
RUN bash /tmp/install-agent-deps.sh && rm /tmp/install-agent-deps.sh \
    && bash /tmp/install-node-tooling.sh && rm /tmp/install-node-tooling.sh

LABEL org.opencontainers.image.title="ai-agents-lang-node"
