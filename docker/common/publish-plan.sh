#!/usr/bin/env bash
# Resolve latest stable CLI versions from GitHub and decide what to publish.
# Publishes when the Docker Hub version tag is missing or older than upstream.
set -euo pipefail

REGISTRY="${REGISTRY:-sayem314/ai-agents}"
FORCE="${FORCE:-false}"
GITHUB_API="${GITHUB_API:-https://api.github.com}"
LANGS=(node python go rust full)

curl_gh() {
  local url="$1"
  if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    curl -fsSL -H "Authorization: Bearer ${GITHUB_TOKEN}" -H "Accept: application/vnd.github+json" "$url"
  else
    curl -fsSL -H "Accept: application/vnd.github+json" "$url"
  fi
}

gh_tags() {
  local owner_repo="$1"
  local page=1
  local tags=""
  while true; do
    local resp count chunk
    resp="$(curl_gh "${GITHUB_API}/repos/${owner_repo}/tags?per_page=100&page=${page}")"
    chunk="$(echo "$resp" | jq -r '.[].name')"
    [[ -n "$chunk" ]] || break
    tags+=$'\n'"$chunk"
    count="$(echo "$resp" | jq 'length')"
    [[ "$count" -lt 100 ]] && break
    page=$((page + 1))
  done
  echo "$tags" | sed '/^$/d'
}

latest_codex() {
  gh_tags "openai/codex" \
    | grep -E '^rust-v[0-9]+\.[0-9]+\.[0-9]+$' \
    | sed 's/^rust-v//' \
    | sort -V \
    | tail -1
}

latest_semver_tag() {
  local owner_repo="$1"
  gh_tags "$owner_repo" \
    | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' \
    | sed 's/^v//' \
    | sort -V \
    | tail -1
}

# List tags from the public Hub API. Do not send DOCKERHUB_TOKEN here — Hub PATs are
# for docker login (password), not Authorization: Bearer (that always returns 401).
hub_tags() {
  local page=1
  local tags=""
  while true; do
    local resp chunk next code
    resp="$(curl -sSL -w '\n%{http_code}' \
      "https://hub.docker.com/v2/repositories/${REGISTRY}/tags?page_size=100&page=${page}")"
    code="$(echo "$resp" | tail -1)"
    resp="$(echo "$resp" | sed '$d')"
    if [[ "$code" == "404" ]]; then
      return 0
    fi
    [[ "$code" =~ ^2 ]] || {
      echo "hub tags API HTTP ${code} for ${REGISTRY}" >&2
      return 1
    }
    chunk="$(echo "$resp" | jq -r '.results[].name // empty')"
    [[ -n "$chunk" ]] || break
    tags+=$'\n'"$chunk"
    next="$(echo "$resp" | jq -r '.next // empty')"
    [[ -n "$next" ]] || break
    page=$((page + 1))
  done
  echo "$tags" | sed '/^$/d'
}

hub_max_version() {
  local prefix="$1"
  hub_tags \
    | grep -E "^${prefix}-[0-9]+\\.[0-9]+\\.[0-9]+$" \
    | sed "s/^${prefix}-//" \
    | sort -V \
    | tail -1
}

needs_publish() {
  local upstream="$1"
  local hub_max="$2"
  if [[ "$FORCE" == "true" ]]; then
    return 0
  fi
  if [[ -z "$hub_max" ]]; then
    return 0
  fi
  [[ "$(printf '%s\n%s\n' "$hub_max" "$upstream" | sort -V | tail -1)" == "$upstream" && "$hub_max" != "$upstream" ]]
}

require_upstream() {
  local tool="$1" version="$2"
  if [[ -z "$version" ]]; then
    echo "${tool}: failed to resolve upstream version" >&2
    exit 1
  fi
}

CODEX_UPSTREAM="$(latest_codex)"
CLAUDE_UPSTREAM="$(latest_semver_tag "anthropics/claude-code")"
OPENCODE_UPSTREAM="$(latest_semver_tag "anomalyco/opencode")"

require_upstream codex "$CODEX_UPSTREAM"
require_upstream claude "$CLAUDE_UPSTREAM"
require_upstream opencode "$OPENCODE_UPSTREAM"

CODEX_HUB="$(hub_max_version "codex")"
CLAUDE_HUB="$(hub_max_version "claude-code")"
OPENCODE_HUB="$(hub_max_version "opencode")"

declare -a MATRIX_ENTRIES=()
PLAN_JSON='[]'

add_tool() {
  local tool="$1" upstream="$2" hub_max="$3"
  if ! needs_publish "$upstream" "$hub_max"; then
    echo "${tool}: up to date (${upstream}, hub: ${hub_max:-none})"
    return 0
  fi
  echo "${tool}: publish ${upstream} (hub: ${hub_max:-none})"
  PLAN_JSON="$(echo "$PLAN_JSON" | jq -c \
    --arg tool "$tool" --arg upstream "$upstream" --arg hub "${hub_max:-}" \
    '. + [{tool:$tool, upstream:$upstream, hub:($hub | select(length > 0))}]')"
  local lang
  for lang in "${LANGS[@]}"; do
    MATRIX_ENTRIES+=("$(jq -nc \
      --arg tool "$tool" --arg lang "$lang" --arg version "$upstream" \
      '{tool:$tool, lang:$lang, version:$version}')")
  done
}

add_tool codex "$CODEX_UPSTREAM" "$CODEX_HUB"
add_tool claude "$CLAUDE_UPSTREAM" "$CLAUDE_HUB"
add_tool opencode "$OPENCODE_UPSTREAM" "$OPENCODE_HUB"

if [[ "${#MATRIX_ENTRIES[@]}" -gt 0 ]]; then
  MATRIX="$(printf '%s\n' "${MATRIX_ENTRIES[@]}" | jq -sc '{include:.}')"
  PUBLISH=true
else
  MATRIX='{"include":[]}'
  PUBLISH=false
fi

echo ""
echo "Upstream: codex=${CODEX_UPSTREAM} claude=${CLAUDE_UPSTREAM} opencode=${OPENCODE_UPSTREAM}"
echo "Hub max:  codex=${CODEX_HUB:-none} claude=${CLAUDE_HUB:-none} opencode=${OPENCODE_HUB:-none}"
echo "Publish:  ${PUBLISH}"

if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  {
    echo "publish=${PUBLISH}"
    echo "matrix=${MATRIX}"
    echo "plan<<EOF"
    echo "$PLAN_JSON"
    echo "EOF"
  } >> "$GITHUB_OUTPUT"
fi
