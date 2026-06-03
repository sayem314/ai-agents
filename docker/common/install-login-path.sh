#!/usr/bin/env bash
# Codex/Claude/OpenCode run shell commands with bash -lc, which resets Docker ENV PATH.
# Write /etc/profile.d so login shells see node, playwright, go, codex, etc.
set -euo pipefail

PROFILE=/etc/profile.d/ai-agents-path.sh
{
  printf '%s\n' '# Login shells reset Docker ENV PATH — restore agent tool paths (CLIs use bash -lc).'
  printf 'export PATH=%q\n' "$PATH"
} > "$PROFILE"
chmod 644 "$PROFILE"

actual="$(bash -lc 'echo "$PATH"')"
if [ "$actual" != "$PATH" ]; then
  echo "install-login-path: login shell PATH mismatch" >&2
  echo "  expected: $PATH" >&2
  echo "  actual:   $actual" >&2
  exit 1
fi
