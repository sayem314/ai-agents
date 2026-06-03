# Images

Published on Docker Hub: [`sayem314/ai-agents`](https://hub.docker.com/r/sayem314/ai-agents)

Multi-arch: `linux/amd64` and `linux/arm64`.

## Tag scheme

```
sayem314/ai-agents:<tool>[-<lang>]
```

| Pattern         | Example                            | Stack                    |
| --------------- | ---------------------------------- | ------------------------ |
| `<tool>`        | `codex`, `claude-code`, `opencode` | **full** — all languages |
| `<tool>-node`   | `codex-node`                       | Node.js only             |
| `<tool>-python` | `claude-python`                    | Python only              |
| `<tool>-go`     | `opencode-go`                      | Go only                  |
| `<tool>-rust`   | `codex-rust`                       | Rust only                |
| `<tool>-java`   | `claude-java`                      | Java only                |

Claude uses the tag `claude-code` (not `claude`) for the default full image.

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
docker pull sayem314/ai-agents:claude-code
docker pull sayem314/ai-agents:opencode
docker pull sayem314/ai-agents:codex-node
```

## Image layout (maintainers)

```
lang layer (node | python | go | rust | java | full)
    └── tool layer (codex | claude | opencode)
            └── CLI via official install.sh
```

Language layers are build-only dependencies and are **not** pushed to Docker Hub. Only the 18 tool tags above are published.

See [Maintainers](maintainers.md) for build and publish commands.
