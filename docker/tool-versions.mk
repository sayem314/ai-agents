# Pinned CLI versions — env overrides Dockerfile defaults (used by CI publish).
_codex_from_file    := $(strip $(shell sed -n 's/^ARG CODEX_VERSION=//p' docker/tools/codex/Dockerfile))
_claude_from_file   := $(strip $(shell sed -n 's/^ARG CLAUDE_VERSION=//p' docker/tools/claude/Dockerfile))
_opencode_from_file := $(strip $(shell sed -n 's/^ARG OPENCODE_VERSION=//p' docker/tools/opencode/Dockerfile))

CODEX_VERSION    ?= $(_codex_from_file)
CLAUDE_VERSION   ?= $(_claude_from_file)
OPENCODE_VERSION ?= $(_opencode_from_file)
