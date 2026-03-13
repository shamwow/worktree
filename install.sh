#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_CMD_DIR="${HOME}/.claude/commands"
CLAUDE_SCRIPT_DIR="${HOME}/.claude/scripts"

# Install commands as symlinks
mkdir -p "$CLAUDE_CMD_DIR"
for cmd in cleanup pr tree; do
  ln -sf "$SCRIPT_DIR/commands/$cmd.md" "$CLAUDE_CMD_DIR/$cmd.md"
  echo "Installed /$cmd → $CLAUDE_CMD_DIR/$cmd.md (symlink)"
done

# Install scripts as symlinks
mkdir -p "$CLAUDE_SCRIPT_DIR"
for script in cleanup.sh pr.sh tree.sh; do
  ln -sf "$SCRIPT_DIR/scripts/$script" "$CLAUDE_SCRIPT_DIR/$script"
  echo "Installed $script → $CLAUDE_SCRIPT_DIR/$script (symlink)"
done

echo ""
echo "Done. Available commands:"
echo "  /tree         List, switch, or create worktrees"
echo "  /cleanup      Remove a worktree and delete its branch"
echo "  /pr           Push and create a pull request"
