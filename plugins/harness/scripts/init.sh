#!/usr/bin/env bash
# Harness - Feature Development Framework
# Initializes a project with harness skills and agents

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/../templates"
TARGET_DIR="$(pwd)"
MODE="init"  # init | update | force

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --update) MODE="update"; shift ;;
    --force)  MODE="force"; shift ;;
    *)        TARGET_DIR="$1"; shift ;;
  esac
done

# Resolve paths
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
TARGET_CLAUDE_DIR="$TARGET_DIR/.claude"
MANIFEST_FILE="$TARGET_CLAUDE_DIR/.harness-manifest"

# Track results
INSTALLED=()
UPDATED=()
SKIPPED_EXISTS=()
SKIPPED_CUSTOM=()

# Compute checksum for a file
checksum() {
  sha256sum "$1" 2>/dev/null | cut -d' ' -f1
}

# Get stored checksum from manifest
get_manifest_checksum() {
  local file="$1"
  grep "^$file " "$MANIFEST_FILE" 2>/dev/null | cut -d' ' -f2
}

# Save checksum to manifest
save_manifest_checksum() {
  local file="$1"
  local sum="$2"
  # Remove old entry if exists
  if [[ -f "$MANIFEST_FILE" ]]; then
    grep -v "^$file " "$MANIFEST_FILE" > "$MANIFEST_FILE.tmp" 2>/dev/null || true
    mv "$MANIFEST_FILE.tmp" "$MANIFEST_FILE"
  fi
  echo "$file $sum" >> "$MANIFEST_FILE"
}

# Copy a single file with mode-aware logic
copy_file() {
  local src="$1"
  local dest="$2"
  local rel_path="${dest#$TARGET_DIR/}"

  if [[ ! -f "$dest" ]]; then
    # File doesn't exist - always install
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    save_manifest_checksum "$rel_path" "$(checksum "$dest")"
    INSTALLED+=("$rel_path")
    return
  fi

  # File exists - behavior depends on mode
  case $MODE in
    init)
      SKIPPED_EXISTS+=("$rel_path")
      ;;
    force)
      cp "$src" "$dest"
      save_manifest_checksum "$rel_path" "$(checksum "$dest")"
      UPDATED+=("$rel_path")
      ;;
    update)
      local current_sum=$(checksum "$dest")
      local manifest_sum=$(get_manifest_checksum "$rel_path")
      if [[ "$current_sum" == "$manifest_sum" ]]; then
        # File unchanged from install - safe to update
        cp "$src" "$dest"
        save_manifest_checksum "$rel_path" "$(checksum "$dest")"
        UPDATED+=("$rel_path")
      else
        # File was customized - preserve it
        SKIPPED_CUSTOM+=("$rel_path")
      fi
      ;;
  esac
}

# Recursively copy directory
copy_dir() {
  local src_dir="$1"
  local dest_dir="$2"

  # Use process substitution to avoid subshell (preserves array modifications)
  while IFS= read -r src_file; do
    local rel="${src_file#$src_dir/}"
    copy_file "$src_file" "$dest_dir/$rel"
  done < <(find "$src_dir" -type f)
}

echo "Harness - initializing in $TARGET_DIR"
echo "Mode: $MODE"
echo ""

# Ensure .claude directory exists
mkdir -p "$TARGET_CLAUDE_DIR"

# Initialize manifest if needed
[[ -f "$MANIFEST_FILE" ]] || touch "$MANIFEST_FILE"

# Copy templates
[[ -d "$TEMPLATES_DIR/skills" ]] && copy_dir "$TEMPLATES_DIR/skills" "$TARGET_CLAUDE_DIR/skills"
[[ -d "$TEMPLATES_DIR/agents" ]] && copy_dir "$TEMPLATES_DIR/agents" "$TARGET_CLAUDE_DIR/agents"
[[ -d "$TEMPLATES_DIR/commands" ]] && copy_dir "$TEMPLATES_DIR/commands" "$TARGET_CLAUDE_DIR/commands"
[[ -f "$TEMPLATES_DIR/.mcp.json" ]] && copy_file "$TEMPLATES_DIR/.mcp.json" "$TARGET_DIR/.mcp.json"

# Report results
echo ""
[[ ${#INSTALLED[@]} -gt 0 ]] && echo "Installed: ${#INSTALLED[@]} files"
[[ ${#UPDATED[@]} -gt 0 ]] && echo "Updated: ${#UPDATED[@]} files"

if [[ ${#SKIPPED_EXISTS[@]} -gt 0 ]]; then
  echo ""
  echo "Skipped (already exist): ${#SKIPPED_EXISTS[@]} files"
  echo "  Use --update to update unchanged files, or --force to overwrite all"
fi

if [[ ${#SKIPPED_CUSTOM[@]} -gt 0 ]]; then
  echo ""
  echo "Preserved (customized): ${#SKIPPED_CUSTOM[@]} files"
  for f in "${SKIPPED_CUSTOM[@]}"; do
    echo "  - $f"
  done
  echo "  Use --force to overwrite these"
fi

echo ""
echo "Done!"
