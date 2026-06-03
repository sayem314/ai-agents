# ai-agents-codex-{lang} — Codex CLI from GitHub release tarball
# Build: make build TOOL=codex LANG=full
# Bake:  contexts.lang = target:lang-full (see docker-bake.hcl)
FROM lang

ARG TARGETARCH
ARG CODEX_VERSION=0.136.0

ENV PATH="/root/.local/bin:${PATH}"

COPY docker/common/install-codex.sh /tmp/install-codex.sh
RUN chmod +x /tmp/install-codex.sh \
    && CODEX_VERSION="${CODEX_VERSION}" TARGETARCH="${TARGETARCH}" /tmp/install-codex.sh \
    && rm /tmp/install-codex.sh

COPY docker/common/install-login-path.sh /tmp/install-login-path.sh
RUN bash /tmp/install-login-path.sh && rm /tmp/install-login-path.sh

WORKDIR /workspace
ENTRYPOINT ["codex"]
CMD []

LABEL org.opencontainers.image.title="ai-agents-codex"
