#!/usr/bin/env bash
# Common packages for AI agent sandboxes (git, curl, build tools).
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    build-essential \
    sudo \
    unzip \
    wget \
    jq \
    gnupg \
    pkg-config \
    libssl-dev \
    file \
    locales
locale-gen en_US.UTF-8
rm -rf /var/lib/apt/lists/*
