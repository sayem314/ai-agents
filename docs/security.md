# Security

## Model

```
┌─────────────────────────────────────────┐
│  Host OS — protected by Docker          │
│  ┌───────────────────────────────────┐  │
│  │  Container                        │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │  /workspace (bind mount)    │  │  │  ← your repo, writable
│  │  │  Codex / Claude / OpenCode  │  │  │
│  │  └─────────────────────────────┘  │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

## What Docker protects

- Processes inside the container cannot reach the host filesystem **outside** mounted volumes (unless you mount extra paths).
- Network, packages, and tools are isolated to the container.
- Each run is ephemeral (`--rm`) — no leftover container state after exit.

## What Docker does **not** protect

- **Your repo.** `$PWD` is bind-mounted at `/workspace`. The agent can read, edit, and delete project files. That is intentional — it needs to write code.
- **Mounted auth dirs.** Config under `~/.codex`, `~/.claude`, etc. is writable from inside the container if mounted without `:ro`.
- **Secrets in the project.** `.env`, keys, or credentials in the repo are visible to the agent.

Treat the agent like a powerful local developer with full access to the mounted tree.

## In-container sandbox flags

Images do **not** inject tool flags — add them in your `docker run` alias after the image tag.

| Tool        | Recommended alias flag           | Meaning                                      |
| ----------- | -------------------------------- | -------------------------------------------- |
| Codex       | `--sandbox danger-full-access`   | Full shell/tool access inside the container  |
| Claude Code | `--dangerously-skip-permissions` | Skip permission prompts inside the container |
| OpenCode    | (none)                           | Docker is the boundary                       |

Docker is the **outer** sandbox. These flags disable or relax **inner** tool restrictions so agents can run builds, tests, and package installs inside the container.

Example:

```bash
docker run -it --rm ... sayem314/ai-agents:codex --sandbox danger-full-access
```

## Recommendations

1. Run from a project directory you are willing to let the agent modify.
2. Do not mount entire `$HOME` — only the auth paths documented in [Authentication](authentication.md).
3. Use subscription auth on the host; avoid putting API keys in shell rc files when possible.
4. Review agent changes before committing, same as any local assistant.

## References

- [Codex agent approvals & security](https://developers.openai.com/codex/agent-approvals-security)
- [Codex secure devcontainer](https://github.com/openai/codex/tree/main/.devcontainer)
