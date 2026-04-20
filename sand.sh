#!/usr/bin/env bash
set -e
SAND_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v praia &>/dev/null; then
  echo "error: 'praia' not found in PATH" >&2
  exit 1
fi

praia "$SAND_DIR/main.praia" "$@"
