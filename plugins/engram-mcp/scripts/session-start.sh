#!/usr/bin/env bash
# Session start - inject previous session context
# Uses local engram install for speed

cat | uv run --directory ~/workspace/engram engram-session-start
