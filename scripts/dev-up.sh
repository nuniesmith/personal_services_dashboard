#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
ROOT_DIR="${SCRIPT_DIR}/.."
cd "$ROOT_DIR"

if [ ! -d shared_nginx ]; then
  echo "Initializing shared_nginx submodule..." >&2
  git submodule add ../../shared/nginx shared_nginx || true
fi

git submodule update --init --recursive

# Example: bring up nginx only (adjust compose path as needed)
if [ -f shared_nginx/docker-compose.simple.yml ]; then
  COMPOSE_FILE=shared_nginx/docker-compose.simple.yml
else
  COMPOSE_FILE=shared_nginx/docker-compose.yml
fi

echo "Using compose file: $COMPOSE_FILE"
DOCKER_BUILDKIT=1 docker compose -f "$COMPOSE_FILE" up -d --build

echo "Stack started. Logs:
  docker compose -f $COMPOSE_FILE logs -f --tail=100"
