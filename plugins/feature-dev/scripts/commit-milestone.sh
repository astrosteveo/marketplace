#!/bin/bash
# Commits milestone changes with error handling
# Expects milestone files as arguments, commit message via stdin or -m flag
#
# Usage:
#   echo "commit message" | ./commit-milestone.sh file1.ts file2.ts
#   ./commit-milestone.sh -m "commit message" file1.ts file2.ts
#
# Output: JSON with commit result
#   {"status": "success", "hash": "abc1234"}
#   {"status": "failed", "reason": "error message"}
#   {"status": "skipped", "reason": "reason"}

set -euo pipefail

# Parse arguments
COMMIT_MESSAGE=""
FILES=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -m|--message)
      COMMIT_MESSAGE="$2"
      shift 2
      ;;
    *)
      FILES+=("$1")
      shift
      ;;
  esac
done

# Read commit message from stdin if not provided via flag
if [[ -z "$COMMIT_MESSAGE" ]]; then
  COMMIT_MESSAGE=$(cat)
fi

# Validate inputs
if [[ -z "$COMMIT_MESSAGE" ]]; then
  echo '{"status": "failed", "reason": "No commit message provided"}'
  exit 1
fi

if [[ ${#FILES[@]} -eq 0 ]]; then
  echo '{"status": "failed", "reason": "No files to commit"}'
  exit 1
fi

# Validate git repo
if [[ ! -d ".git" ]]; then
  echo '{"status": "skipped", "reason": "Not a git repository"}'
  exit 0
fi

# Check for merge conflicts
if git diff --check 2>/dev/null | grep -q "conflict"; then
  echo '{"status": "failed", "reason": "Merge conflicts detected - resolve before committing"}'
  exit 2
fi

# Stage milestone files only
STAGED_COUNT=0
for file in "${FILES[@]}"; do
  if [[ -e "$file" ]]; then
    git add "$file" 2>/dev/null || true
    ((STAGED_COUNT++)) || true
  elif git ls-files --deleted | grep -q "^${file}$"; then
    # File was deleted - stage the deletion
    git add "$file" 2>/dev/null || true
    ((STAGED_COUNT++)) || true
  fi
done

if [[ $STAGED_COUNT -eq 0 ]]; then
  echo '{"status": "skipped", "reason": "No files to stage"}'
  exit 0
fi

# Check if there are actually staged changes
if git diff --cached --quiet; then
  echo '{"status": "skipped", "reason": "No changes to commit"}'
  exit 0
fi

# Attempt commit
COMMIT_OUTPUT=$(git commit -m "$COMMIT_MESSAGE" 2>&1) || {
  EXIT_CODE=$?
  # Escape output for JSON
  ESCAPED_OUTPUT=$(echo "$COMMIT_OUTPUT" | head -10 | tr '\n' ' ' | sed 's/"/\\"/g')
  echo "{\"status\": \"failed\", \"reason\": \"$ESCAPED_OUTPUT\", \"exit_code\": $EXIT_CODE}"
  exit 2
}

# Success - get commit hash
COMMIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
echo "{\"status\": \"success\", \"hash\": \"$COMMIT_HASH\"}"
