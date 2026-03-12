#!/bin/bash
set -e

BRANCH_NAME="$1"

git rev-parse --show-toplevel >/dev/null 2>&1 || { echo "Error: not in a git repo."; exit 1; }

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

# If no branch name given, use current branch
if [ -z "$BRANCH_NAME" ]; then
  BRANCH_NAME=$(git branch --show-current)
fi

if [ "$BRANCH_NAME" = "$DEFAULT_BRANCH" ]; then
  echo "Error: can't clean up the default branch ($DEFAULT_BRANCH)."
  exit 1
fi

# Find worktree path for the branch
WORKTREE_PATH=$(git worktree list --porcelain | awk -v branch="$BRANCH_NAME" '
  /^worktree / { path=$2 }
  /^branch refs\/heads\// { b=$2; sub("refs/heads/","",b); if (b == branch) print path }
')

# Find main worktree (first entry)
MAIN_WORKTREE=$(git worktree list --porcelain | head -1 | sed 's/^worktree //')

# If we're currently in the worktree being removed, switch to main
CURRENT_PATH=$(pwd -P)
if [ -n "$WORKTREE_PATH" ] && [ "$CURRENT_PATH" = "$WORKTREE_PATH" ]; then
  echo "SWITCH:${MAIN_WORKTREE}"
fi

echo "Cleaning up branch '${BRANCH_NAME}'..."

# Remove worktree if it exists
if [ -n "$WORKTREE_PATH" ]; then
  echo "Removing worktree at ${WORKTREE_PATH}..."
  git worktree remove "$WORKTREE_PATH" --force 2>&1
fi

# Delete branch
git branch -d "$BRANCH_NAME" 2>&1 || git branch -D "$BRANCH_NAME" 2>&1

# Prune and update
git worktree prune
git -C "$MAIN_WORKTREE" fetch origin 2>&1
git -C "$MAIN_WORKTREE" pull 2>&1

echo ""
echo "Done. Branch '${BRANCH_NAME}' deleted."
if [ -n "$WORKTREE_PATH" ]; then
  echo "Worktree at ${WORKTREE_PATH} removed."
fi
echo "Main worktree at ${MAIN_WORKTREE} on ${DEFAULT_BRANCH} updated."
