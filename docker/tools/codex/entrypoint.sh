#!/bin/sh
# Default in-container sandbox: Docker is the outer boundary.
set -e
CODEX_BIN="${CODEX_BIN:-codex}"
DEFAULT_SANDBOX="danger-full-access"

has_sandbox_flag() {
  for arg in "$@"; do
    case "$arg" in
      --sandbox|--sandbox=*) return 0 ;;
    esac
  done
  return 1
}

if has_sandbox_flag "$@"; then
  exec "$CODEX_BIN" "$@"
fi

exec "$CODEX_BIN" --sandbox "$DEFAULT_SANDBOX" "$@"
