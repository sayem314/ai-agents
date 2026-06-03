# ai-agents-opencode-{lang} — OpenCode via official install script
# Build: make build TOOL=opencode LANG=full
FROM lang

ARG OPENCODE_VERSION=

ENV PATH="/root/.opencode/bin:/root/.local/bin:${PATH}"

RUN set -eux; \
    if [ -n "${OPENCODE_VERSION}" ]; then \
        curl -fsSL https://opencode.ai/install | bash -s -- --version "${OPENCODE_VERSION}"; \
    else \
        curl -fsSL https://opencode.ai/install | bash; \
    fi \
    && (command -v opencode >/dev/null && opencode --version) || true

COPY docker/common/install-login-path.sh /tmp/install-login-path.sh
RUN bash /tmp/install-login-path.sh && rm /tmp/install-login-path.sh

WORKDIR /workspace
ENTRYPOINT ["opencode"]
CMD []

LABEL org.opencontainers.image.title="ai-agents-opencode"
