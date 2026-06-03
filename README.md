# ai-agents

Run **Codex**, **Claude Code**, and **OpenCode** in Docker — sandboxed, with your project and subscription login mounted. **No clone required.**

Published images: [`sayem314/ai-agents`](https://hub.docker.com/r/sayem314/ai-agents)

## Quick start

1. Install [Docker](https://docs.docker.com/get-docker/).
2. Sign in to each tool on your **host** once (`~/.codex`, `~/.claude`, etc.).
3. Add aliases to `~/.zshrc` or `~/.bashrc` (pick one or more tools):

```bash
# Codex
alias codex='docker run -it --rm -w /workspace \
  -v "$PWD:/workspace" \
  -v "$HOME/.codex:/root/.codex" \
  -v "$HOME/.config/codex:/root/.config/codex" \
  sayem314/ai-agents:codex --sandbox danger-full-access'

# Claude Code
alias claude-code='docker run -it --rm -w /workspace \
  -v "$PWD:/workspace" \
  -v "$HOME/.claude:/root/.claude" \
  -v "$HOME/.config/claude:/root/.config/claude" \
  sayem314/ai-agents:claude-code --dangerously-skip-permissions'
alias claude='claude-code'

# OpenCode
alias opencode='docker run -it --rm -w /workspace \
  -v "$PWD:/workspace" \
  -v "$HOME/.config/opencode:/root/.config/opencode" \
  -v "$HOME/.local/share/opencode:/root/.local/share/opencode" \
  sayem314/ai-agents:opencode'
```

4. Run from any project:

```bash
cd ~/my-app && codex          # or: claude-code / opencode
```

More aliases, language variants, and options → **[Documentation](docs/README.md)**

## Documentation

|                                            |                                                          |
| ------------------------------------------ | -------------------------------------------------------- |
| [Codex](docs/codex.md)                     | Aliases, sandbox flags, `-node` / `-python` / … variants |
| [Claude Code](docs/claude-code.md)         | Aliases, permission flags, language variants             |
| [OpenCode](docs/opencode.md)               | Aliases, language variants                               |
| [Images](docs/images.md)                   | All 15 tags, language stacks, which variant to pick      |
| [Authentication](docs/authentication.md)   | Subscription login, API keys, git/SSH                    |
| [Security](docs/security.md)               | What Docker protects (and what it does not)              |
| [Troubleshooting](docs/troubleshooting.md) | Pull, login, permissions, macOS mounts                   |
| [Maintainers](docs/maintainers.md)         | Build, publish, repo layout                              |

## Images at a glance

| Command                          | Image tag                          |
| -------------------------------- | ---------------------------------- |
| `codex`                          | `sayem314/ai-agents:codex`         |
| `claude-code`                    | `sayem314/ai-agents:claude-code`   |
| `opencode`                       | `sayem314/ai-agents:opencode`      |
| `codex-node`, `claude-python`, … | `sayem314/ai-agents:<tool>-<lang>` |

Default tags use the **full** language stack. Use `-node`, `-python`, `-go`, or `-rust` for smaller images.
