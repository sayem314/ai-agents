# Troubleshooting

## Pull fails

```bash
docker pull sayem314/ai-agents:codex
```

Check network, Docker Hub rate limits, and that Docker Desktop / the daemon is running.

## Login prompt every run

Sign in on the **host** first so config dirs exist:

| Tool        | Check                   |
| ----------- | ----------------------- |
| Codex       | `ls ~/.codex`           |
| Claude Code | `ls ~/.claude`          |
| OpenCode    | `ls ~/.config/opencode` |

Mount paths must target `/root/...` in the container (see [Authentication](authentication.md)).

## Command not found inside container

Images install CLIs to `/root/.local/bin`. Do not use `--user "$(id -u):$(id -g)"` — non-root users cannot access that path.

## Git push or SSH fails

Add read-only mounts to your alias:

```bash
-v "$HOME/.gitconfig:/root/.gitconfig:ro" \
-v "$HOME/.ssh:/root/.ssh:ro"
```

Ensure your SSH agent or keys work on the host first.

## Root-owned files on the host

The container runs as root. New files in your project may be owned by root on the host.

Fix ownership once:

```bash
sudo chown -R "$(id -u):$(id -g)" .
```

Long-term fix requires image changes (non-root user). See [Authentication](authentication.md).

## macOS slow bind mounts

In Docker Desktop → Settings → General, enable **VirtioFS** (or the fastest file-sharing option available).

Add `:cached` to volume mounts:

```bash
-v "$PWD:/workspace:cached"
```

## Wrong architecture

Images are multi-arch (`amd64` + `arm64`). Docker picks the matching manifest automatically. On Apple Silicon you get `arm64`; on Intel/AMD you get `amd64`.

If you built a local image with `make build`, it is single-arch for your machine only.

## Build / publish issues (maintainers)

See [Maintainers](maintainers.md).

Common fixes:

```bash
docker buildx create --use    # one-time builder setup
docker login                  # before publish
make build TOOL=codex LANG=full
```
