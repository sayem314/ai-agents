# Pinned CLI versions (empty = floating install, no version suffix on Hub tags).
CODEX_VERSION   := $(strip $(shell sed -n 's/^ARG CODEX_VERSION=//p' docker/tools/codex/Dockerfile))
CLAUDE_VERSION  := $(strip $(shell sed -n 's/^ARG CLAUDE_VERSION=//p' docker/tools/claude/Dockerfile))
OPENCODE_VERSION := $(strip $(shell sed -n 's/^ARG OPENCODE_VERSION=//p' docker/tools/opencode/Dockerfile))
