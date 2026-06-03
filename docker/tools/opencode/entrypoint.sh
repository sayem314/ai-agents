#!/bin/sh
# OpenCode: pass through args; outer isolation is Docker (no extra sandbox flag required).
set -e
OPENCODE_BIN="${OPENCODE_BIN:-opencode}"
exec "$OPENCODE_BIN" "$@"
