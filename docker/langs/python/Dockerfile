# ai-agents-lang-python — official Python image + uv + agent deps
# Tag: ai-agents-lang-python:latest
FROM python:3.14-bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TERM=xterm-256color \
    UV_VERSION=0.11.18 \
    PATH="/root/.local/bin:${PATH}"

COPY docker/common/install-agent-deps.sh /tmp/install-agent-deps.sh
RUN bash /tmp/install-agent-deps.sh && rm /tmp/install-agent-deps.sh \
    && curl -LsSf "https://astral.sh/uv/${UV_VERSION}/install.sh" | sh

RUN python3 --version && pip3 --version && uv --version

LABEL org.opencontainers.image.title="ai-agents-lang-python"
