#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
ROOT_DIR="${SCRIPT_DIR}/.."
cd "$ROOT_DIR"

if [ ! -d shared-nginx/.git ]; then
  echo "Submodule not initialized (shared-nginx). Run: git submodule update --init --recursive" >&2
  exit 1
fi

pushd shared-nginx >/dev/null
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" != "main" ]; then
  echo "Switching shared-nginx to main branch" >&2
  git checkout main
fi

echo "Fetching latest origin/main" >&2
git fetch origin
LATEST_LOCAL=$(git rev-parse HEAD)
LATEST_REMOTE=$(git rev-parse origin/main)
if [ "$LATEST_LOCAL" = "$LATEST_REMOTE" ]; then
  echo "Already up to date." >&2
else
  git pull --ff-only origin main
fi
NEW_SHA=$(git rev-parse HEAD)
popd >/dev/null

echo "Pinned shared-nginx at $NEW_SHA"

git add shared-nginx
echo "Submodule updated; commit this change (e.g. git commit -m 'chore: bump shared-nginx to $NEW_SHA')" >&2
