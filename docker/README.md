# Docker images

Language and tool layers for [ai-agents](https://github.com/sayem314/ai-agents) — Docker sandboxes for **Codex**, **Claude Code**, and **OpenCode**.

Published on Docker Hub: [`sayem314/ai-agents`](https://hub.docker.com/r/sayem314/ai-agents)

## Layout

```
docker/
  common/          Shared scripts (deps, Codex install, publish planning)
  langs/           Language base images (build-only deps, not pushed to Hub)
  tools/           Tool images — Codex, Claude, OpenCode (what gets published)
  tool-versions.mk Pinned CLI versions (env overrides for publish)
```

Repo root also has `docker-bake.hcl` (15-image buildx matrix) and `Makefile` (local build / bake / publish).

## Two-layer build

1. **Lang layer** — `docker/langs/{node,python,go,rust,full}/Dockerfile`  
   Official base images + shared agent deps (git, curl, build tools, stack-specific tooling).

2. **Tool layer** — `docker/tools/{codex,claude,opencode}/Dockerfile`  
   Installs the CLI on top of a lang layer via build context `lang`. Each tool image sets `ENTRYPOINT` to the CLI binary; pass flags in your `docker run` alias.

**3 tools × 5 langs = 15 published Hub tags.** Lang layers stay local/cache-only; only tool tags are pushed.

## Quick build

From the [repo root](https://github.com/sayem314/ai-agents):

```bash
git clone https://github.com/sayem314/ai-agents.git
cd ai-agents

make build-lang LANG=full
make build TOOL=codex LANG=full

docker run -it --rm -v "$PWD:/workspace" ai-agents-codex-full:latest --help
```

Multi-arch publish and the full matrix: see [Maintainers](../docs/maintainers.md).

## Further reading

| Doc                                                        | Purpose                                       |
| ---------------------------------------------------------- | --------------------------------------------- |
| [GitHub repository](https://github.com/sayem314/ai-agents) | Source, issues, CI workflows                  |
| [Maintainers](../docs/maintainers.md)                      | Build, bake, publish, automated Hub updates   |
| [Images](../docs/images.md)                                | All 15 Hub tags and language stacks           |
| [README](../README.md)                                     | End-user quick start (pull and run, no clone) |
