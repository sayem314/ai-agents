#!/usr/bin/env bash
# Node tooling: pnpm (corepack) + bun official installer.
set -euo pipefail

PNPM_VERSION="${PNPM_VERSION:-11.5.1}"
BUN_VERSION="${BUN_VERSION:-1.3.14}"

corepack enable
corepack prepare "pnpm@${PNPM_VERSION}" --activate
curl -fsSL https://bun.sh/install | bash -s "bun-v${BUN_VERSION}"

command -v node >/dev/null
command -v npm >/dev/null
command -v pnpm >/dev/null
command -v bun >/dev/null
node --version
npm --version
pnpm --version
bun --version
