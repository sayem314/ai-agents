#!/usr/bin/env bash
# Install Codex standalone package from GitHub releases (glibc/musl Linux tarballs).
set -euo pipefail

VERSION="${CODEX_VERSION:?CODEX_VERSION is required}"
ARCH="${TARGETARCH:?TARGETARCH is required}"

case "$ARCH" in
  amd64) TARGET="x86_64-unknown-linux-musl" ;;
  arm64) TARGET="aarch64-unknown-linux-musl" ;;
  *)
    echo "install-codex: unsupported TARGETARCH: $ARCH" >&2
    exit 1
    ;;
esac

PKG="codex-package-${TARGET}.tar.gz"
BASE="https://github.com/openai/codex/releases/download/rust-v${VERSION}"
CODEX_HOME="${CODEX_HOME:-/root/.codex}"
STANDALONE_ROOT="${CODEX_HOME}/packages/standalone"
RELEASE_DIR="${STANDALONE_ROOT}/releases/${VERSION}-${TARGET}"
CURRENT_LINK="${STANDALONE_ROOT}/current"
BIN_DIR="/root/.local/bin"

tmpdir="$(mktemp -d)"
cleanup() { rm -rf "$tmpdir"; }
trap cleanup EXIT

download() {
  local url="$1" out="$2"
  local attempt
  for attempt in 1 2 3; do
    if curl -fsSL "$url" -o "$out"; then
      return 0
    fi
    sleep "$attempt"
  done
  echo "install-codex: failed to download $url" >&2
  return 1
}

download "${BASE}/codex-package_SHA256SUMS" "$tmpdir/SHA256SUMS"
download "${BASE}/${PKG}" "$tmpdir/${PKG}"
(
  cd "$tmpdir"
  grep -F " ${PKG}" SHA256SUMS | sha256sum -c -
)

mkdir -p "$RELEASE_DIR" "$BIN_DIR"
rm -rf "$RELEASE_DIR"/*
tar -xzf "$tmpdir/${PKG}" -C "$RELEASE_DIR"
chmod 0755 "$RELEASE_DIR/bin/codex" "$RELEASE_DIR/codex-path/rg"
if [[ -f "$RELEASE_DIR/codex-resources/bwrap" ]]; then
  chmod 0755 "$RELEASE_DIR/codex-resources/bwrap"
fi
ln -sf "bin/codex" "$RELEASE_DIR/codex"
ln -sfn "$RELEASE_DIR" "$CURRENT_LINK"
ln -sf "$CURRENT_LINK/bin/codex" "$BIN_DIR/codex"

command -v codex >/dev/null
codex --version
