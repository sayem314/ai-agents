# Codex

Run [OpenAI Codex](https://developers.openai.com/codex) in Docker with your project and subscription auth mounted.

**Image:** `sayem314/ai-agents:codex` (full language stack)

## Prerequisites

1. Docker installed and running.
2. Sign in to Codex on your **host** once so `~/.codex` exists.

## Default alias

Add to `~/.zshrc` or `~/.bashrc`:

```bash
alias codex='docker run -it --rm -w /workspace \
  -v "$PWD:/workspace" \
  -v "$HOME/.codex:/root/.codex" \
  -v "$HOME/.config/codex:/root/.config/codex" \
  sayem314/ai-agents:codex --sandbox danger-full-access'
```

Then reload: `source ~/.zshrc`

## Usage

```bash
cd ~/my-app
codex
codex --help
```

First run pulls the image if it is not cached locally.

## What the alias does

| Flag / mount                              | Purpose                                                              |
| ----------------------------------------- | -------------------------------------------------------------------- |
| `-it --rm`                                | Interactive TTY, remove container on exit                            |
| `-w /workspace`                           | Working directory inside the container                               |
| `-v "$PWD:/workspace"`                    | Bind-mount current project                                           |
| `~/.codex` → `/root/.codex`               | Codex subscription auth                                              |
| `~/.config/codex` → `/root/.config/codex` | Additional Codex config                                              |
| `--sandbox danger-full-access`            | Full tool access inside the container (Docker is the outer boundary) |

Pass this flag in your alias — the image does **not** add it for you.

## Language variants

Smaller images with one language stack. Same auth mounts; only the image tag changes.

| Alias          | Image                             |
| -------------- | --------------------------------- |
| `codex-node`   | `sayem314/ai-agents:codex-node`   |
| `codex-python` | `sayem314/ai-agents:codex-python` |
| `codex-go`     | `sayem314/ai-agents:codex-go`     |
| `codex-rust`   | `sayem314/ai-agents:codex-rust`   |

Example:

```bash
alias codex-node='docker run -it --rm -w /workspace \
  -v "$PWD:/workspace" \
  -v "$HOME/.codex:/root/.codex" \
  -v "$HOME/.config/codex:/root/.config/codex" \
  sayem314/ai-agents:codex-node --sandbox danger-full-access'
```

See [Images](images.md) for what each language stack includes.

## Optional: git and SSH

To push from inside the container, add:

```bash
-v "$HOME/.gitconfig:/root/.gitconfig:ro" \
-v "$HOME/.ssh:/root/.ssh:ro"
```

## Optional: API key

Instead of subscription auth, pass an API key:

```bash
-e OPENAI_API_KEY \
```

See [Authentication](authentication.md).

## macOS

Add `:cached` to volume mounts for faster bind mounts on Docker Desktop, e.g. `-v "$PWD:/workspace:cached"`.

## References

- [Codex agent approvals & security](https://developers.openai.com/codex/agent-approvals-security)
- [Codex secure devcontainer](https://github.com/openai/codex/tree/main/.devcontainer)
