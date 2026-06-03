# Build matrix: 3 tools × 6 language variants = 18 published images.
# Lang layers are build-only deps; tool images push to REGISTRY with hub tags.

variable "REGISTRY" {
  default = ""
}

variable "TAG" {
  default = "latest"
}

variable "CODEX_VERSION" {
  default = ""
}

variable "CLAUDE_VERSION" {
  default = ""
}

variable "OPENCODE_VERSION" {
  default = ""
}

function "lang_tag" {
  params = [lang]
  result = "ai-agents-lang-${lang}:${TAG}"
}

function "hub_tag" {
  params = [tool, lang]
  result = tool == "claude" && lang == "full" ? "claude-code" : (
    lang == "full" ? tool : "${tool}-${lang}"
  )
}

function "tool_version" {
  params = [tool]
  result = tool == "codex" ? CODEX_VERSION : (
    tool == "claude" ? CLAUDE_VERSION : OPENCODE_VERSION
  )
}

function "hub_tag_names" {
  params = [tool, lang]
  result = tool_version(tool) != "" ? [
    hub_tag(tool, lang),
    "${hub_tag(tool, lang)}-${tool_version(tool)}",
  ] : [hub_tag(tool, lang)]
}

function "tool_tags" {
  params = [tool, lang]
  result = REGISTRY != "" ? [
    for name in hub_tag_names(tool, lang) : "${REGISTRY}:${name}"
  ] : ["ai-agents-${tool}-${lang}:${TAG}"]
}

group "default" {
  targets = ["matrix"]
}

target "lang-node" {
  context    = "."
  dockerfile = "docker/langs/node/Dockerfile"
  tags       = [lang_tag("node")]
  output     = ["type=cacheonly"]
}

target "lang-python" {
  context    = "."
  dockerfile = "docker/langs/python/Dockerfile"
  tags       = [lang_tag("python")]
  output     = ["type=cacheonly"]
}

target "lang-go" {
  context    = "."
  dockerfile = "docker/langs/go/Dockerfile"
  tags       = [lang_tag("go")]
  output     = ["type=cacheonly"]
}

target "lang-rust" {
  context    = "."
  dockerfile = "docker/langs/rust/Dockerfile"
  tags       = [lang_tag("rust")]
  output     = ["type=cacheonly"]
}

target "lang-java" {
  context    = "."
  dockerfile = "docker/langs/java/Dockerfile"
  tags       = [lang_tag("java")]
  output     = ["type=cacheonly"]
}

target "lang-full" {
  context    = "."
  dockerfile = "docker/langs/full/Dockerfile"
  tags       = [lang_tag("full")]
  output     = ["type=cacheonly"]
}

target "matrix" {
  matrix = {
    tool = ["codex", "claude", "opencode"]
    lang = ["node", "python", "go", "rust", "java", "full"]
  }
  name       = "${tool}-${lang}"
  context    = "."
  dockerfile = "docker/tools/${tool}/Dockerfile"
  contexts = {
    lang = "target:lang-${lang}"
  }
  args = {
    CODEX_VERSION    = CODEX_VERSION
    CLAUDE_VERSION   = CLAUDE_VERSION
    OPENCODE_VERSION = OPENCODE_VERSION
  }
  tags       = tool_tags(tool, lang)
  depends_on = ["lang-${lang}"]
}
