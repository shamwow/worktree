#!/bin/bash
set -e

TITLE="$1"

git rev-parse --show-toplevel >/dev/null 2>&1 || { echo "Error: not in a git repo."; exit 1; }

CURRENT_BRANCH=$(git branch --show-current)

# Detect default branch
DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
if [ -z "$DEFAULT_BRANCH" ]; then
  if git show-ref --verify --quiet refs/remotes/origin/main 2>/dev/null; then
    DEFAULT_BRANCH="main"
  elif git show-ref --verify --quiet refs/remotes/origin/master 2>/dev/null; then
    DEFAULT_BRANCH="master"
  else
    echo "Error: can't detect default branch."
    exit 1
  fi
fi

if [ "$CURRENT_BRANCH" = "$DEFAULT_BRANCH" ]; then
  echo "Error: you're on $DEFAULT_BRANCH. Switch to a feature branch first with /tree <name>."
  exit 1
fi

# Warn about uncommitted changes
DIRTY=$(git status --porcelain)
if [ -n "$DIRTY" ]; then
  echo "Warning: uncommitted changes:"
  echo "$DIRTY"
  echo ""
fi

# Push
echo "Pushing $CURRENT_BRANCH..."
git push -u origin "$CURRENT_BRANCH" 2>&1

# Create PR
echo ""
if [ -n "$TITLE" ]; then
  gh pr create --base "$DEFAULT_BRANCH" --head "$CURRENT_BRANCH" --title "$TITLE" --fill 2>&1 || gh pr view --json url -q .url 2>&1
else
  gh pr create --base "$DEFAULT_BRANCH" --head "$CURRENT_BRANCH" --fill 2>&1 || gh pr view --json url -q .url 2>&1
fi
