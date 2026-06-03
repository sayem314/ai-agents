# ai-agents-claude-{lang} — Claude Code via native installer
# Build: make build TOOL=claude LANG=full
FROM lang

ARG CLAUDE_VERSION=

ENV PATH="/root/.local/bin:${PATH}"

# install.sh accepts: stable | latest | x.y.z
RUN set -eux; \
    if [ -n "${CLAUDE_VERSION}" ]; then \
        curl -fsSL https://claude.ai/install.sh | bash -s -- "${CLAUDE_VERSION}"; \
    else \
        curl -fsSL https://claude.ai/install.sh | bash -s -- stable; \
    fi \
    && (command -v claude >/dev/null && claude --version) || true

COPY docker/common/install-login-path.sh /tmp/install-login-path.sh
RUN bash /tmp/install-login-path.sh && rm /tmp/install-login-path.sh

WORKDIR /workspace
ENTRYPOINT ["claude"]
CMD []

LABEL org.opencontainers.image.title="ai-agents-claude"
