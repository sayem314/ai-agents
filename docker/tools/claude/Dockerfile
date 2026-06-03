# ai-agents-claude-{lang} — Claude Code via native installer
# Build: make build TOOL=claude LANG=full
FROM lang

ENV PATH="/root/.local/bin:${PATH}"

# Native installer places `claude` in ~/.local/bin
RUN curl -fsSL https://claude.ai/install.sh | bash

COPY docker/tools/claude/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh \
    && (command -v claude >/dev/null && claude --version) || true

WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD []

LABEL org.opencontainers.image.title="ai-agents-claude"
