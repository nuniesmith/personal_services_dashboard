#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
ROOT_DIR="${SCRIPT_DIR}/.."
cd "$ROOT_DIR"

if [ -f shared-nginx/docker-compose.simple.yml ]; then
  COMPOSE_FILE=shared-nginx/docker-compose.simple.yml
else
  COMPOSE_FILE=shared-nginx/docker-compose.yml
fi

echo "Stopping stack via $COMPOSE_FILE"
docker compose -f "$COMPOSE_FILE" down
