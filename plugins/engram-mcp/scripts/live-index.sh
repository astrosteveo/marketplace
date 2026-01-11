#!/usr/bin/env bash
# Live indexer - runs engram-live-index via uvx

uvx --from git+https://github.com/astrosteveo/engram engram-live-index 2>/dev/null
