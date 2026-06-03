# OpenCode

Run [OpenCode](https://opencode.ai/docs) in Docker with your project and auth mounted.

**Image:** `sayem314/ai-agents:opencode` (full language stack)

## Prerequisites

1. Docker installed and running.
2. Sign in to OpenCode on your **host** once so config exists under `~/.config/opencode`.

## Default alias

Add to `~/.zshrc` or `~/.bashrc`:

```bash
alias opencode='docker run -it --rm -w /workspace \
  -v "$PWD:/workspace" \
  -v "$HOME/.config/opencode:/root/.config/opencode" \
  -v "$HOME/.local/share/opencode:/root/.local/share/opencode" \
  sayem314/ai-agents:opencode'
```

Then reload: `source ~/.zshrc`

## Usage

```bash
cd ~/my-app
opencode
opencode --help
```

First run pulls the image if it is not cached locally.

## What the alias does

| Flag / mount                                              | Purpose                                   |
| --------------------------------------------------------- | ----------------------------------------- |
| `-it --rm`                                                | Interactive TTY, remove container on exit |
| `-w /workspace`                                           | Working directory inside the container    |
| `-v "$PWD:/workspace"`                                    | Bind-mount current project                |
| `~/.config/opencode` → `/root/.config/opencode`           | OpenCode config                           |
| `~/.local/share/opencode` → `/root/.local/share/opencode` | OpenCode data                             |

OpenCode has no extra sandbox flag — Docker is the isolation boundary.

## Language variants

| Alias             | Image                                |
| ----------------- | ------------------------------------ |
| `opencode-node`   | `sayem314/ai-agents:opencode-node`   |
| `opencode-python` | `sayem314/ai-agents:opencode-python` |
| `opencode-go`     | `sayem314/ai-agents:opencode-go`     |
| `opencode-rust`   | `sayem314/ai-agents:opencode-rust`   |

Example:

```bash
alias opencode-go='docker run -it --rm -w /workspace \
  -v "$PWD:/workspace" \
  -v "$HOME/.config/opencode:/root/.config/opencode" \
  -v "$HOME/.local/share/opencode:/root/.local/share/opencode" \
  sayem314/ai-agents:opencode-go'
```

See [Images](images.md) for stack details.

## Optional: git and SSH

```bash
-v "$HOME/.gitconfig:/root/.gitconfig:ro" \
-v "$HOME/.ssh:/root/.ssh:ro"
```

## Optional: API key

```bash
-e OPENCODE_API_KEY \
```

See [Authentication](authentication.md).

## macOS

Add `:cached` to volume mounts on Docker Desktop, e.g. `-v "$PWD:/workspace:cached"`.

## References

- [OpenCode docs](https://opencode.ai/docs)
