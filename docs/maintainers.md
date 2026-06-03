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
make bake                  # all 15, one by one
make bake TARGET=codex-full   # one target
```

## Publish to Docker Hub

Requires [buildx](https://docs.docker.com/build/building/multi-platform/) and `docker login`.

Each publish builds **amd64 + arm64 in parallel** for that single Hub tag, then pushes. `publish-all` runs 15 publishes **one tag at a time** (avoids hammering GitHub during CLI installs).

```bash
make publish TOOL=codex LANG=full    # one tag, multi-arch
make publish-all                     # all 15 tags, sequential
```

Default platforms: `linux/amd64,linux/arm64`. Override:

```bash
PLATFORMS=linux/arm64 make publish TOOL=codex LANG=full
```

`publish` uses **buildx bake** with `--push`. Language layers are build-only deps and are not pushed.

Pinned CLI versions can be passed on the command line:

```bash
CODEX_VERSION=0.136.0 make publish TOOL=codex LANG=full
```

`make build` forwards the same `*_VERSION` variables as `--build-arg`.

### Automated publish (GitHub Actions)

Three workflows share [`.github/workflows/publish-tool.yml`](../.github/workflows/publish-tool.yml):

| Workflow             | File                                                                | Schedule (UTC) |
| -------------------- | ------------------------------------------------------------------- | -------------- |
| **Publish Codex**    | [`publish-codex.yml`](../.github/workflows/publish-codex.yml)       | Daily 06:00    |
| **Publish Claude**   | [`publish-claude.yml`](../.github/workflows/publish-claude.yml)     | Daily 10:00    |
| **Publish OpenCode** | [`publish-opencode.yml`](../.github/workflows/publish-opencode.yml) | Daily 14:00    |

Each run checks one tool only via `TOOL=…` in [`docker/common/publish-plan.sh`](../docker/common/publish-plan.sh), compares GitHub stable vs max pinned tags on Docker Hub, and publishes five language variants sequentially when stale. Manual dispatch supports **force** to rebuild that tool even if Hub is up to date.

Requires repo secret `DOCKERHUB_TOKEN` and variable `DOCKERHUB_USERNAME`.

Hub **overview/readme** is synced from [`README.md`](../README.md) by [`.github/workflows/dockerhub-readme.yml`](../.github/workflows/dockerhub-readme.yml) (push to `main` or manual dispatch). Image publish alone does not update it.

**Docker Hub setup (GitHub → Settings → Secrets and variables → Actions):**

| Name                 | Type         | Value                                                                                                                     |
| -------------------- | ------------ | ------------------------------------------------------------------------------------------------------------------------- |
| `DOCKERHUB_TOKEN`    | **Secret**   | Docker Hub [access token](https://hub.docker.com/settings/security) with **Read & Write** (value only, e.g. `dckr_pat_…`) |
| `DOCKERHUB_USERNAME` | **Variable** | Hub username (e.g. `sayem314`)                                                                                            |

Do not use your Docker Hub account password or a GitHub PAT. `DOCKERHUB_TOKEN` is only used in the **publish** job for `docker login`; the plan job reads public tag metadata without it. A previous `HTTP 401` in the plan job was a script bug (sending the PAT as a Bearer token), not an invalid secret.

Version sources: Codex `openai/codex` (`rust-vX.Y.Z`), Claude `anthropics/claude-code` (`vX.Y.Z`), OpenCode `anomalyco/opencode` (`vX.Y.Z`).

Each publish emits a **floating tag** (e.g. `codex`) and a **version suffix tag** (e.g. `codex-0.136.0`). See [Images](images.md).

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
| `make bake`                       | All 15 tool images via buildx, one at a time |
| `make bake TARGET=codex-full`     | One tool image via buildx                    |
| `make publish TOOL=… LANG=…`      | Multi-arch build + push one Hub tag          |
| `make publish-all`                | Push all 15 Hub tags, one at a time          |

Variables: `TOOL`, `LANG`, `TAG`, `REGISTRY` (default `sayem314/ai-agents`), `PLATFORMS`, `CODEX_VERSION`, `CLAUDE_VERSION`, `OPENCODE_VERSION`.

## Repository layout

```
docker/
  common/install-agent-deps.sh   # shared apt packages
  common/install-codex.sh        # Codex tarball install
  common/install-node-tooling.sh # latest pnpm + bun for node/full layers
  common/publish-plan.sh         # upstream vs Hub version check
  langs/{node,python,go,rust,full}/Dockerfile
  tools/{codex,claude,opencode}/Dockerfile
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
| full   | Multi-stage merge into `python:3.14-bookworm` |

### Tool install

| Tool        | Method                                                                 | Install path          |
| ----------- | ---------------------------------------------------------------------- | --------------------- |
| Codex       | GitHub release tarball via `install-codex.sh` (pinned `CODEX_VERSION`) | `/root/.local/bin`    |
| Claude Code | `https://claude.ai/install.sh` (pinned `CLAUDE_VERSION` or `stable`)   | `/root/.local/bin`    |
| OpenCode    | `https://opencode.ai/install` (optional `OPENCODE_VERSION`)            | `/root/.opencode/bin` |

Entrypoints are the CLI binaries directly (`ENTRYPOINT ["codex"]`, etc.). Sandbox and permission flags are **not** set by the image — add them in your alias (see tool docs and [Security](security.md)).

## References

- [Codex secure devcontainer](https://github.com/openai/codex/tree/main/.devcontainer)
- [OpenCode docs](https://opencode.ai/docs)
