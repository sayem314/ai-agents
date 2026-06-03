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

## Full matrix (18 published tags)

|              | node            | python            | go            | rust            | java            | full          |
| ------------ | --------------- | ----------------- | ------------- | --------------- | --------------- | ------------- |
| **codex**    | `codex-node`    | `codex-python`    | `codex-go`    | `codex-rust`    | `codex-java`    | `codex`       |
| **claude**   | `claude-node`   | `claude-python`   | `claude-go`   | `claude-rust`   | `claude-java`   | `claude-code` |
| **opencode** | `opencode-node` | `opencode-python` | `opencode-go` | `opencode-rust` | `opencode-java` | `opencode`    |

## Language stacks

Each language layer is built on official Docker Hub base images plus shared agent deps (git, curl, build tools).

| Lang       | Base image                                                | Extra tooling              |
| ---------- | --------------------------------------------------------- | -------------------------- |
| **node**   | `node:24-bookworm`                                        | pnpm via corepack          |
| **python** | `python:3.14-bookworm`                                    | uv                         |
| **go**     | `golang:1.26-bookworm`                                    | —                          |
| **rust**   | `rust:1-bookworm`                                         | clang, lld                 |
| **java**   | `eclipse-temurin:25-jdk`                                  | Maven 3.9.15, Gradle 9.5.1 |
| **full**   | Multi-stage copy of all above into `python:3.14-bookworm` | All stacks                 |

## Which variant to pick

| Situation                      | Pick                                         |
| ------------------------------ | -------------------------------------------- |
| General use, polyglot projects | `codex`, `claude-code`, or `opencode` (full) |
| Node/TS monorepo only          | `*-node`                                     |
| Python-only repo               | `*-python`                                   |
| Go module                      | `*-go`                                       |
| Rust crate                     | `*-rust`                                     |
| Java/Kotlin/Maven/Gradle       | `*-java`                                     |

Full images are larger but work everywhere. Language-specific images pull faster and use less disk.

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
lang layer (node | python | go | rust | java | full)
    └── tool layer (codex | claude | opencode)
            └── Codex: GitHub release tarball (install-codex.sh)
            └── Claude / OpenCode: official install scripts
```

Language layers are build-only dependencies and are **not** pushed to Docker Hub. Only the 18 tool tags above are published.

See [Maintainers](maintainers.md) for build and publish commands.
