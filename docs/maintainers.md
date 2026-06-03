# Maintainers

Build and publish the Docker image matrix from this repo.

## Clone and build

```bash
git clone https://github.com/sayem314/ai-agents.git
cd ai-agents
```

### Local single-arch (fast, current machine)

```bash
make build-lang LANG=node
make build TOOL=codex LANG=full
```

Test:

```bash
docker run -it --rm -v "$PWD:/workspace" ai-agents-codex-full:latest --help
```

### Full matrix (buildx, sequential)

Builds one tool image at a time (lang layer pulled in as a bake dependency). Current machine arch only — results stay in buildx cache unless you use `make build` with `--load`.

```bash
make bake                  # all 18, one by one
make bake TARGET=codex-full   # one target
```

## Publish to Docker Hub

Requires [buildx](https://docs.docker.com/build/building/multi-platform/) and `docker login`.

Each publish builds **amd64 + arm64 in parallel** for that single Hub tag, then pushes. `publish-all` runs 18 publishes **one tag at a time** (avoids hammering GitHub during CLI installs).

```bash
make publish TOOL=codex LANG=full    # one tag, multi-arch
make publish-all                     # all 18 tags, sequential
```

Default platforms: `linux/amd64,linux/arm64`. Override:

```bash
PLATFORMS=linux/arm64 make publish TOOL=codex LANG=full
```

`publish` uses **buildx bake** with `--push`. Language layers are build-only deps and are not pushed.

## Tag mapping

| Local build name          | Docker Hub tag                   |
| ------------------------- | -------------------------------- |
| `ai-agents-codex-full`    | `sayem314/ai-agents:codex`       |
| `ai-agents-claude-full`   | `sayem314/ai-agents:claude-code` |
| `ai-agents-opencode-full` | `sayem314/ai-agents:opencode`    |
| `ai-agents-codex-node`    | `sayem314/ai-agents:codex-node`  |
| …                         | …                                |

Full matrix: [Images](images.md).

## Makefile targets

| Target                            | Description                                  |
| --------------------------------- | -------------------------------------------- |
| `make help`                       | List targets and variables                   |
| `make build-lang LANG=node`       | Build one language layer                     |
| `make build TOOL=codex LANG=full` | Build one tool image (local docker)          |
| `make bake`                       | All 18 tool images via buildx, one at a time |
| `make bake TARGET=codex-full`     | One tool image via buildx                    |
| `make publish TOOL=… LANG=…`      | Multi-arch build + push one Hub tag          |
| `make publish-all`                | Push all 18 Hub tags, one at a time          |

Variables: `TOOL`, `LANG`, `TAG`, `REGISTRY` (default `sayem314/ai-agents`), `PLATFORMS`.

## Repository layout

```
docker/
  common/install-agent-deps.sh   # shared apt packages
  langs/{node,python,go,rust,java,full}/Dockerfile
  tools/{codex,claude,opencode}/Dockerfile + entrypoint.sh
docker-bake.hcl                  # buildx bake matrix
Makefile
```

### Language bases

| Layer  | Base                                          |
| ------ | --------------------------------------------- |
| node   | `node:24-bookworm`                            |
| python | `python:3.14-bookworm`                        |
| go     | `golang:1.26-bookworm`                        |
| rust   | `rust:1-bookworm`                             |
| java   | `eclipse-temurin:25-jdk`                      |
| full   | Multi-stage merge into `python:3.14-bookworm` |

### Tool install

| Tool        | Method                                                          |
| ----------- | --------------------------------------------------------------- |
| Codex       | `https://chatgpt.com/codex/install.sh` (pinned `CODEX_VERSION`) |
| Claude Code | `https://claude.ai/install.sh`                                  |
| OpenCode    | `https://opencode.ai/install`                                   |

CLIs install to `/root/.local/bin`. Entrypoints inject default sandbox/permission flags.

## Entrypoints

- **Codex:** adds `--sandbox danger-full-access` unless already passed
- **Claude:** adds `--dangerously-skip-permissions` unless already passed
- **OpenCode:** pass-through only

## References

- [Codex secure devcontainer](https://github.com/openai/codex/tree/main/.devcontainer)
- [OpenCode docs](https://opencode.ai/docs)
