# ai-agents-lang-go — official Go image + agent deps
# Tag: ai-agents-lang-go:latest
FROM golang:1.26-bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TERM=xterm-256color

COPY docker/common/install-agent-deps.sh /tmp/install-agent-deps.sh
RUN bash /tmp/install-agent-deps.sh && rm /tmp/install-agent-deps.sh

RUN go version

LABEL org.opencontainers.image.title="ai-agents-lang-go"
