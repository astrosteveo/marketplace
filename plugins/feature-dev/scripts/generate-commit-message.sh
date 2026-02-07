#!/bin/bash
# Generates conventional commit message from milestone metadata
#
# Usage:
#   ./generate-commit-message.sh -n "Milestone Name" -s "scope" -d "deliverable1" -d "deliverable2" -v "PASS" -c 3 -m 2 -t 5
#
# Arguments:
#   -n, --name         Milestone name (required)
#   -s, --scope        Scope for commit (optional, e.g., "auth", "api")
#   -d, --deliverable  Deliverable item (can be repeated)
#   -v, --verification Verification status string (e.g., "type:PASS lint:PASS tests:4/4")
#   -c, --file-count   Number of files changed
#   -m, --milestone    Current milestone number
#   -t, --total        Total milestones
#   --type             Override commit type (feat, fix, refactor, test, docs, chore)
#
# Output: Formatted conventional commit message

set -euo pipefail

# Defaults
NAME=""
SCOPE=""
DELIVERABLES=()
VERIFICATION=""
FILE_COUNT=0
MILESTONE_NUM=0
TOTAL_MILESTONES=0
COMMIT_TYPE=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -n|--name)
      NAME="$2"
      shift 2
      ;;
    -s|--scope)
      SCOPE="$2"
      shift 2
      ;;
    -d|--deliverable)
      DELIVERABLES+=("$2")
      shift 2
      ;;
    -v|--verification)
      VERIFICATION="$2"
      shift 2
      ;;
    -c|--file-count)
      FILE_COUNT="$2"
      shift 2
      ;;
    -m|--milestone)
      MILESTONE_NUM="$2"
      shift 2
      ;;
    -t|--total)
      TOTAL_MILESTONES="$2"
      shift 2
      ;;
    --type)
      COMMIT_TYPE="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

# Validate required arguments
if [[ -z "$NAME" ]]; then
  echo "Error: Milestone name is required (-n)" >&2
  exit 1
fi

# Determine commit type if not specified
if [[ -z "$COMMIT_TYPE" ]]; then
  NAME_LOWER=$(echo "$NAME" | tr '[:upper:]' '[:lower:]')
  if echo "$NAME_LOWER" | grep -qE '(fix|bug|patch|repair|resolve)'; then
    COMMIT_TYPE="fix"
  elif echo "$NAME_LOWER" | grep -qE '(refactor|restructure|reorganize|cleanup|clean up)'; then
    COMMIT_TYPE="refactor"
  elif echo "$NAME_LOWER" | grep -qE '(test|spec|coverage)'; then
    COMMIT_TYPE="test"
  elif echo "$NAME_LOWER" | grep -qE '(doc|readme|comment)'; then
    COMMIT_TYPE="docs"
  elif echo "$NAME_LOWER" | grep -qE '(config|build|ci|chore)'; then
    COMMIT_TYPE="chore"
  else
    COMMIT_TYPE="feat"
  fi
fi

# Build header
if [[ -n "$SCOPE" ]]; then
  HEADER="${COMMIT_TYPE}(${SCOPE}): ${NAME}"
else
  HEADER="${COMMIT_TYPE}: ${NAME}"
fi

# Build body from deliverables
BODY=""
if [[ ${#DELIVERABLES[@]} -gt 0 ]]; then
  for deliverable in "${DELIVERABLES[@]}"; do
    BODY="${BODY}- ${deliverable}\n"
  done
fi

# Build footer
FOOTER=""
if [[ $MILESTONE_NUM -gt 0 && $TOTAL_MILESTONES -gt 0 ]]; then
  FOOTER="Milestone: ${MILESTONE_NUM}/${TOTAL_MILESTONES}"
fi

if [[ -n "$VERIFICATION" ]]; then
  if [[ -n "$FOOTER" ]]; then
    FOOTER="${FOOTER}\nVerification: ${VERIFICATION}"
  else
    FOOTER="Verification: ${VERIFICATION}"
  fi
fi

if [[ $FILE_COUNT -gt 0 ]]; then
  if [[ -n "$FOOTER" ]]; then
    FOOTER="${FOOTER}\nFiles: ${FILE_COUNT} changed"
  else
    FOOTER="Files: ${FILE_COUNT} changed"
  fi
fi

# Output complete message
echo "$HEADER"
if [[ -n "$BODY" ]]; then
  echo ""
  echo -e "$BODY"
fi
if [[ -n "$FOOTER" ]]; then
  echo ""
  echo -e "$FOOTER"
fi
