#!/usr/bin/env bash
# Playwright CLI (npm) + Chromium and OS deps. Used by the full lang layer only.
set -euo pipefail

command -v node >/dev/null
command -v npm >/dev/null

npm install -g playwright@latest
export PATH="$(npm prefix -g)/bin:${PATH}"

playwright install --with-deps chromium
playwright --version
