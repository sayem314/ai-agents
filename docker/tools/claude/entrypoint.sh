#!/bin/sh
# Inside Docker, Claude Code runs with permission checks skipped — host protection is the container boundary.
set -e
CLAUDE_BIN="${CLAUDE_BIN:-claude}"
DEFAULT_FLAG="--dangerously-skip-permissions"

has_danger_flag() {
  for arg in "$@"; do
    case "$arg" in
      --dangerously-skip-permissions) return 0 ;;
    esac
  done
  return 1
}

if has_danger_flag "$@"; then
  exec "$CLAUDE_BIN" "$@"
fi

exec "$CLAUDE_BIN" "$DEFAULT_FLAG" "$@"
