# -------------------------------- Fetch --------------------------------------
# Use separate stage to fetch docker-gen binary to reduce end image size
FROM curlimages/curl:7.70.0 AS fetch

ARG DOCKER_GEN_VERSION=0.7.4

# Fetch and decompress pre-built binary from `docker-gen` repository
RUN curl -L "https://github.com/jwilder/docker-gen/releases/download/${DOCKER_GEN_VERSION}/docker-gen-alpine-linux-amd64-${DOCKER_GEN_VERSION}.tar.gz" | tar -xz -C /home/curl_user

# -------------------------------- Main ---------------------------------------
FROM caddy:2.0.0-alpine

WORKDIR /etc/caddy

COPY Caddyfile.tmpl docker-gen.cfg entrypoint.sh ./

# Copy binary over from previous stage
COPY --from=fetch /home/curl_user/docker-gen /usr/bin

# Watch for Docker events to update configuration
ENTRYPOINT ["./entrypoint.sh"]
