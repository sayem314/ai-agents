# Images

Published on Docker Hub: [`sayem314/ai-agents`](https://hub.docker.com/r/sayem314/ai-agents)

Multi-arch: `linux/amd64` and `linux/arm64`.

## Tag scheme

Images are **not** published as a single `:latest` for the whole repo. Each variant gets a **tool-based tag name** (floating / “latest” for that line) and, when a CLI version is passed at build time, a **version suffix tag** on the same image.

```
sayem314/ai-agents:<tool>[-<lang>][-<cli-version>]
```

| Pattern                   | Example                            | Meaning                         |
| ------------------------- | ---------------------------------- | ------------------------------- |
| `<tool>`                  | `codex`, `claude-code`, `opencode` | **full** stack, floating CLI    |
| `<tool>-<lang>`           | `codex-node`, `claude-python`      | Single lang stack, floating CLI |
| `<tool>-<cli-version>`    | `codex-0.136.0`                    | **full**, pinned Codex version  |
| `<tool>-<lang>-<version>` | `codex-node-0.136.0`               | Single lang, pinned CLI version |

Claude uses the tag `claude-code` (not `claude`) for the default full image.

Version suffix tags are emitted when `*_VERSION` is set at build time (Dockerfile default, `make publish CODEX_VERSION=…`, or the Publish workflow). Local `make bake` without version args only pushes floating tags for Claude and OpenCode.

## Full matrix (15 published tags)

|              | node            | python            | go            | rust            | full          |
| ------------ | --------------- | ----------------- | ------------- | --------------- | ------------- |
| **codex**    | `codex-node`    | `codex-python`    | `codex-go`    | `codex-rust`    | `codex`       |
| **claude**   | `claude-node`   | `claude-python`   | `claude-go`   | `claude-rust`   | `claude-code` |
| **opencode** | `opencode-node` | `opencode-python` | `opencode-go` | `opencode-rust` | `opencode`    |

## Language stacks

Each language layer is built on official Docker Hub base images plus shared agent deps (git, curl, build tools).

| Lang       | Base image                                                             | Extra tooling                          |
| ---------- | ---------------------------------------------------------------------- | -------------------------------------- |
| **node**   | `node:24-bookworm`                                                     | node, npm, pnpm (latest), bun (latest) |
| **python** | `python:3.14-bookworm`                                                 | uv                                     |
| **go**     | `golang:1.26-bookworm`                                                 | —                                      |
| **rust**   | `rust:1-bookworm`                                                      | clang, lld                             |
| **full**   | Multi-stage copy of node, python, go, rust into `python:3.14-bookworm` | All stacks, Playwright CLI + Chromium  |

## Which variant to pick

| Situation                      | Pick                                         |
| ------------------------------ | -------------------------------------------- |
| General use, polyglot projects | `codex`, `claude-code`, or `opencode` (full) |
| Node/TS monorepo only          | `*-node`                                     |
| Python-only repo               | `*-python`                                   |
| Go module                      | `*-go`                                       |
| Rust crate                     | `*-rust`                                     |

Full images are larger but work everywhere. Language-specific images pull faster and use less disk.

**Playwright** (`playwright` CLI, Chromium + OS deps) is included only on **full** tags (`codex`, `claude-code`, `opencode`), not on `*-node`, `*-python`, etc.

## Pull manually

```bash
docker pull sayem314/ai-agents:codex
docker pull sayem314/ai-agents:codex-0.136.0
docker pull sayem314/ai-agents:claude-code
docker pull sayem314/ai-agents:opencode
docker pull sayem314/ai-agents:codex-node
```

## Image layout (maintainers)

```
lang layer (node | python | go | rust | full)
    └── tool layer (codex | claude | opencode)
            └── Codex: GitHub release tarball (install-codex.sh)
            └── Claude / OpenCode: official install scripts
```

Language layers are build-only dependencies and are **not** pushed to Docker Hub. Only the 15 tool tags above are published.

See [Maintainers](maintainers.md) for build and publish commands.
