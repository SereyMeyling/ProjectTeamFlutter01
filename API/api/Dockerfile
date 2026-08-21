# ============================================================
# Stage 1: Build Stage
# ============================================================
FROM nexus.cambofreelance.com/docker-hosted/core/gradle:8.5-jdk21 AS builder

WORKDIR /app

ENV TZ=Asia/Phnom_Penh

# 1. Copy Gradle configuration first (Optimizes Docker Layer Caching)
COPY gradle gradle
COPY build.gradle settings.gradle gradle.properties ./
COPY gradle.properties /root/.gradle/gradle.properties

# 2. Download dependencies to cache layers
RUN gradle dependencies --no-daemon || true

# 3. Copy source code and build final executable JAR
COPY src ./src
RUN gradle bootJar -x test --no-daemon

# ============================================================
# Stage 2: Runtime Stage
# ============================================================
FROM nexus.cambofreelance.com/docker-hosted/core/eclipse-temurin:21-jdk-alpine

WORKDIR /app

ENV TZ=Asia/Phnom_Penh

# Install tzdata for timezone support in Alpine
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# Create non-root user for security best practices
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy built executable JAR
COPY --chown=appuser:appgroup --from=builder /app/build/libs/*[!plain].jar /app/app.jar

# Match application.yml server port 30033
EXPOSE 30033

USER appuser

ENTRYPOINT ["java", "-Duser.timezone=Asia/Phnom_Penh", "-jar", "/app/app.jar"]