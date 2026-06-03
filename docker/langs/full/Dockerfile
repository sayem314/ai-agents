# ai-agents-lang-full — all stacks via official images (multi-stage) + agent deps
# Tag: ai-agents-lang-full:latest
FROM node:24-bookworm AS node
RUN corepack enable && corepack prepare pnpm@11.5.0 --activate

FROM golang:1.26-bookworm AS go

FROM rust:1-bookworm AS rust

FROM eclipse-temurin:25-jdk AS java
ARG MAVEN_VERSION=3.9.15
ARG GRADLE_VERSION=9.5.1
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl unzip \
    && curl -fsSL \
        "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
        | tar -xz -C /opt \
    && curl -fsSL \
        "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
        -o /tmp/gradle.zip \
    && unzip -q /tmp/gradle.zip -d /opt \
    && rm -rf /var/lib/apt/lists/* /tmp/gradle.zip

FROM python:3.14-bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TERM=xterm-256color \
    UV_VERSION=0.11.18 \
    GOPATH=/go \
    RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    JAVA_HOME=/opt/java/openjdk \
    MAVEN_VERSION=3.9.15 \
    GRADLE_VERSION=9.5.1

# JAVA_HOME must be set before PATH; BuildKit does not expand ${JAVA_HOME} in the same ENV line.
ENV PATH="/usr/local/bin:/root/.local/bin:/usr/local/go/bin:/go/bin:/usr/local/cargo/bin:/opt/java/openjdk/bin:/opt/apache-maven-${MAVEN_VERSION}/bin:/opt/gradle-${GRADLE_VERSION}/bin:${PATH}"

COPY docker/common/install-agent-deps.sh /tmp/install-agent-deps.sh
RUN bash /tmp/install-agent-deps.sh && rm /tmp/install-agent-deps.sh \
    && curl -LsSf "https://astral.sh/uv/${UV_VERSION}/install.sh" | sh \
    && apt-get update \
    && apt-get install -y --no-install-recommends clang lld \
    && rm -rf /var/lib/apt/lists/*

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/bin/npm /usr/local/bin/npm
COPY --from=node /usr/local/bin/npx /usr/local/bin/npx
COPY --from=node /usr/local/bin/corepack /usr/local/bin/corepack
COPY --from=node /usr/local/bin/pnpm /usr/local/bin/pnpm
COPY --from=node /usr/local/bin/pnpx /usr/local/bin/pnpx
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules

COPY --from=go /usr/local/go /usr/local/go
RUN mkdir -p /go/bin

COPY --from=rust /usr/local/cargo /usr/local/cargo
COPY --from=rust /usr/local/rustup /usr/local/rustup

COPY --from=java /opt/java/openjdk /opt/java/openjdk
COPY --from=java /opt/apache-maven-${MAVEN_VERSION} /opt/apache-maven-${MAVEN_VERSION}
COPY --from=java /opt/gradle-${GRADLE_VERSION} /opt/gradle-${GRADLE_VERSION}

RUN node --version \
    && python3 --version | grep -qE '^Python 3\.14\.' \
    && go version \
    && rustc --version && cargo --version \
    && java -version && mvn -version && gradle -version \
    && uv --version && pnpm --version

LABEL org.opencontainers.image.title="ai-agents-lang-full"
