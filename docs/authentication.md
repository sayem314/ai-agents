# Authentication

## Default: subscription login (recommended)

Sign in on your **host** first. The alias mounts your existing config into the container — no API keys in the image or environment.

| Tool        | Host paths                                      | Container paths                                         |
| ----------- | ----------------------------------------------- | ------------------------------------------------------- |
| Codex       | `~/.codex`, `~/.config/codex`                   | `/root/.codex`, `/root/.config/codex`                   |
| Claude Code | `~/.claude`, `~/.config/claude`                 | `/root/.claude`, `/root/.config/claude`                 |
| OpenCode    | `~/.config/opencode`, `~/.local/share/opencode` | `/root/.config/opencode`, `/root/.local/share/opencode` |

Images run as **root**; CLIs are installed under `/root/.local/bin`. Mount auth dirs to `/root/...` so the tools find your tokens.

### First-time host login

Run the tool natively on your host once (outside Docker), complete the login flow, then use the Docker alias. If you are prompted to log in on every container run, the host config dirs are missing or empty.

## API keys (optional)

For API billing or CI, pass env vars into `docker run`:

```bash
-e OPENAI_API_KEY        # Codex
-e ANTHROPIC_API_KEY     # Claude Code
-e CLAUDE_CODE_OAUTH_TOKEN
-e OPENCODE_API_KEY      # OpenCode
```

Example:

```bash
alias codex='docker run -it --rm ... -e OPENAI_API_KEY sayem314/ai-agents:codex ...'
```

Do not commit keys. Prefer host subscription auth for local development.

## Git and SSH

To commit or push from inside the container:

```bash
-v "$HOME/.gitconfig:/root/.gitconfig:ro" \
-v "$HOME/.ssh:/root/.ssh:ro"
```

Add these to any tool alias. SSH keys stay on the host; the container reads them read-only.

## File ownership (`--user`)

Some Docker setups use:

```bash
--user "$(id -u):$(id -g)"
```

so files created in the bind-mounted project are owned by your host user instead of root.

**These images do not support that today.** CLIs are installed to `/root/.local/bin` during the image build. Running as a non-root UID cannot execute them.

If root-owned project files become a problem, the fix is an image change (non-root user + system-wide CLI install), not adding `--user` to the alias.

## Docker Hub login

Pulling public images does not require login. Publishing images (maintainers) requires `docker login`.
