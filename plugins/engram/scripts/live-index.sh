#!/usr/bin/env bash
# Live indexer wrapper - runs local engram with dependencies

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PLUGIN_DIR" && uv run engram-live-index
