#!/usr/bin/env sh

# Generate initial Caddyfile from containers metadata
docker-gen Caddyfile.tmpl Caddyfile

# Start proxy service in the background
caddy start

# Watch for Docker events to update configuration
docker-gen -config docker-gen.cfg
