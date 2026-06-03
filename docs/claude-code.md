# Claude Code

Run [Claude Code](https://docs.anthropic.com/en/docs/claude-code) in Docker with your project and subscription auth mounted.

**Image:** `sayem314/ai-agents:claude-code` (full language stack)

## Prerequisites

1. Docker installed and running.
2. Sign in to Claude Code on your **host** once so `~/.claude` exists.

## Default alias

Add to `~/.zshrc` or `~/.bashrc`:

```bash
alias claude-code='docker run -it --rm -w /workspace \
  -v "$PWD:/workspace" \
  -v "$HOME/.claude:/root/.claude" \
  -v "$HOME/.config/claude:/root/.config/claude" \
  sayem314/ai-agents:claude-code --dangerously-skip-permissions'

alias claude='claude-code'
```

Then reload: `source ~/.zshrc`

## Usage

```bash
cd ~/my-app
claude-code
claude --help
```

First run pulls the image if it is not cached locally.

## What the alias does

| Flag / mount                                | Purpose                                                             |
| ------------------------------------------- | ------------------------------------------------------------------- |
| `-it --rm`                                  | Interactive TTY, remove container on exit                           |
| `-w /workspace`                             | Working directory inside the container                              |
| `-v "$PWD:/workspace"`                      | Bind-mount current project                                          |
| `~/.claude` → `/root/.claude`               | Claude Code auth and state                                          |
| `~/.config/claude` → `/root/.config/claude` | Additional Claude config                                            |
| `--dangerously-skip-permissions`            | Skip in-container permission prompts (Docker is the outer boundary) |

Pass this flag in your alias — the image does **not** add it for you.

## Language variants

| Alias           | Image                              |
| --------------- | ---------------------------------- |
| `claude-node`   | `sayem314/ai-agents:claude-node`   |
| `claude-python` | `sayem314/ai-agents:claude-python` |
| `claude-go`     | `sayem314/ai-agents:claude-go`     |
| `claude-rust`   | `sayem314/ai-agents:claude-rust`   |

Example:

```bash
alias claude-python='docker run -it --rm -w /workspace \
  -v "$PWD:/workspace" \
  -v "$HOME/.claude:/root/.claude" \
  -v "$HOME/.config/claude:/root/.config/claude" \
  sayem314/ai-agents:claude-python --dangerously-skip-permissions'
```

See [Images](images.md) for stack details.

## Optional: git and SSH

```bash
-v "$HOME/.gitconfig:/root/.gitconfig:ro" \
-v "$HOME/.ssh:/root/.ssh:ro"
```

## Optional: API key or OAuth token

```bash
-e ANTHROPIC_API_KEY \
# or
-e CLAUDE_CODE_OAUTH_TOKEN \
```

See [Authentication](authentication.md).

## macOS

Add `:cached` to volume mounts on Docker Desktop, e.g. `-v "$PWD:/workspace:cached"`.
