# ai-agents-lang-node — official Node.js image + agent deps
# Tag: ai-agents-lang-node:latest
FROM node:24-bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TERM=xterm-256color

COPY docker/common/install-agent-deps.sh /tmp/install-agent-deps.sh
RUN bash /tmp/install-agent-deps.sh && rm /tmp/install-agent-deps.sh

RUN corepack enable \
    && corepack prepare pnpm@11.5.0 --activate

RUN node --version && npm --version && pnpm --version

LABEL org.opencontainers.image.title="ai-agents-lang-node"
