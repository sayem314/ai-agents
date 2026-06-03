#!/usr/bin/env bash
# Node tooling: latest pnpm (npm global) + latest bun (official installer).
set -euo pipefail

npm install -g pnpm@latest
curl -fsSL https://bun.sh/install | bash

export PATH="/root/.bun/bin:${PATH}"

command -v node >/dev/null
command -v npm >/dev/null
command -v pnpm >/dev/null
command -v bun >/dev/null
node --version
npm --version
pnpm --version
bun --version
