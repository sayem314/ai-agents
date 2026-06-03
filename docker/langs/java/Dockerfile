# ai-agents-lang-java — official Eclipse Temurin JDK + Maven + Gradle + agent deps
# Tag: ai-agents-lang-java:latest
# Temurin has no official Debian bookworm tag (Ubuntu noble/jammy only).
FROM eclipse-temurin:25-jdk

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TERM=xterm-256color \
    MAVEN_VERSION=3.9.15 \
    GRADLE_VERSION=9.5.1

COPY docker/common/install-agent-deps.sh /tmp/install-agent-deps.sh
RUN bash /tmp/install-agent-deps.sh && rm /tmp/install-agent-deps.sh \
    && curl -fsSL \
        "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
        | tar -xz -C /opt \
    && curl -fsSL \
        "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
        -o /tmp/gradle.zip \
    && unzip -q /tmp/gradle.zip -d /opt \
    && rm /tmp/gradle.zip

ENV PATH="/opt/apache-maven-${MAVEN_VERSION}/bin:/opt/gradle-${GRADLE_VERSION}/bin:${PATH}"

RUN java -version && mvn -version && gradle -version

LABEL org.opencontainers.image.title="ai-agents-lang-java"
