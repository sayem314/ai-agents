# ai-agents-opencode-{lang} — OpenCode via official install script
# Build: make build TOOL=opencode LANG=full
FROM lang

ENV PATH="/root/.local/bin:${PATH}"

RUN curl -fsSL https://opencode.ai/install | bash

COPY docker/tools/opencode/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh \
    && (command -v opencode >/dev/null && opencode --version) || true

WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD []

LABEL org.opencontainers.image.title="ai-agents-opencode"
