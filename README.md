caddy-gen
=========

Automated Caddy configuration generation for Docker containers.

Based on [Caddy v2](https://hub.docker.com/_/caddy) and [docker-gen](https://github.com/jwilder/docker-gen). Heavily inspired by [caddy-gen](https://github.com/wemake-services/caddy-gen).

Usage
-----

`caddy-gen` is built to be used with [docker-compose](https://docs.docker.com/compose/).

Copy the code below to a file named `docker-compose.yml` at the base of your project.

```yaml
version: "3.7"

# Use named volumes to preserve certificates across container deletion
volumes:
    proxy_acme:
    proxy_ocsp:

services:
    proxy:
        image: ffminus/caddy-gen:1.0.0
        depends_on:
            - www
        ports:
            - "80:80"   # HTTP
            - "443:443" # HTTPS
        volumes:
            - proxy_acme:/etc/caddy/acme                   # ACME data
            - proxy_ocsp:/etc/caddy/ocsp                   # Certificates
            - /var/run/docker.sock:/var/run/docker.sock:ro # Docker events

    www:
        image: nginx:1.18.0-alpine
        labels:
            - virtual.host=www.localhost # Service address
```

Run `docker-compose up` from your project directory to start both proxy and service.  
The test service can be accessed from your browser at http://www.localhost


Configuration
-------------

Arguments are specified using labels.

- `virtual.host` is the address of your service, see [`Caddy` documentation](https://caddyserver.com/docs/caddyfile/concepts#addresses) for valid formats
- `virtual.port` is the port your service listens on inside the container (defaults to 80)
- `virtual.tls-email` can be omitted to use plain HTTP, or set to a valid email to enable TLS
