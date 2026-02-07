#!/bin/bash
set -euo pipefail

# Copy text to clipboard using wl-copy (Wayland) with fallback to xclip (X11)
# Usage: echo "text" | clipboard.sh
#    or: clipboard.sh "text as argument"

copy_to_clipboard() {
  local text="$1"

  if command -v wl-copy &>/dev/null; then
    printf '%s' "$text" | wl-copy
    echo "wl-copy"
  elif command -v xclip &>/dev/null; then
    printf '%s' "$text" | xclip -selection clipboard
    echo "xclip"
  elif command -v xsel &>/dev/null; then
    printf '%s' "$text" | xsel --clipboard --input
    echo "xsel"
  elif command -v pbcopy &>/dev/null; then
    printf '%s' "$text" | pbcopy
    echo "pbcopy"
  else
    echo "ERROR: No clipboard tool found. Install wl-clipboard (Wayland), xclip (X11), or xsel." >&2
    exit 1
  fi
}

if [ $# -gt 0 ]; then
  copy_to_clipboard "$*"
else
  input=$(cat)
  copy_to_clipboard "$input"
fi
