#!/bin/bash

git rev-parse --show-toplevel >/dev/null 2>&1 || { echo "Error: not in a git repo."; exit 1; }

GIT_ROOT=$(git rev-parse --show-toplevel)
WORKTREE_PREFIX="${GIT_ROOT}/.worktrees/"
CURRENT=$(pwd -P)
ARG="$1"

# Ensure .worktrees is gitignored
if [ ! -f "${GIT_ROOT}/.worktrees/.gitignore" ]; then
  mkdir -p "${GIT_ROOT}/.worktrees"
  echo "*" > "${GIT_ROOT}/.worktrees/.gitignore"
fi

# --- List worktrees ---
i=0
declare -a PATHS
declare -a BRANCHES

while IFS= read -r line; do
  path=$(echo "$line" | awk '{print $1}')
  branch=$(echo "$line" | awk '{print $3}' | tr -d '[]')

  if [ "$path" = "$GIT_ROOT" ] || [[ "$path" == ${WORKTREE_PREFIX}* ]]; then
    i=$((i + 1))
    PATHS[$i]="$path"
    BRANCHES[$i]="$branch"

    if [ "$path" = "$CURRENT" ]; then
      marker="*"
    else
      marker=" "
    fi
    printf "%s %d  %-50s %s\n" "$marker" "$i" "$path" "$branch"
  fi
done < <(git worktree list)

# --- No argument: show status and list ---
if [ -z "$ARG" ]; then
  CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "detached")
  echo ""
  if [ "$CURRENT" = "$GIT_ROOT" ]; then
    echo "On $CURRENT_BRANCH (main worktree)"
  else
    echo "On $CURRENT_BRANCH at $CURRENT"
  fi
  if [ "$i" -le 1 ]; then
    echo ""
    echo "Only one worktree exists. Use /tree <name> to create a new one."
  else
    echo ""
    echo "SELECT: Pick a number to switch, or a name to create a new worktree."
  fi
  exit 0
fi

# --- Numeric argument: switch by index ---
if [ "$ARG" -ge 1 ] 2>/dev/null && [ "$ARG" -le "$i" ]; then
  echo ""
  echo "SWITCH:${PATHS[$ARG]}"
  echo "Switched to ${BRANCHES[$ARG]} at ${PATHS[$ARG]}"
  exit 0
fi

# --- Name argument: create or switch to branch worktree ---
BRANCH_NAME="$ARG"

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

WORKTREE_PATH="${WORKTREE_PREFIX}${BRANCH_NAME}"

git fetch origin "$DEFAULT_BRANCH" 2>/dev/null

# Check if branch already exists
BRANCH_EXISTS=false
git show-ref --verify --quiet "refs/heads/$BRANCH_NAME" 2>/dev/null && BRANCH_EXISTS=true
git show-ref --verify --quiet "refs/remotes/origin/$BRANCH_NAME" 2>/dev/null && BRANCH_EXISTS=true

if [ "$BRANCH_EXISTS" = true ]; then
  # Check if worktree already exists for this branch
  EXISTING_PATH=$(git worktree list --porcelain | awk -v branch="$BRANCH_NAME" '
    /^worktree / { path=$2 }
    /^branch refs\/heads\// { b=$2; sub("refs/heads/","",b); if (b == branch) print path }
  ')

  if [ -n "$EXISTING_PATH" ]; then
    echo ""
    echo "SWITCH:${EXISTING_PATH}"
    echo "Switched to existing worktree for branch '${BRANCH_NAME}' at ${EXISTING_PATH}"
    exit 0
  fi

  # Branch exists but no worktree — create one
  git worktree add "$WORKTREE_PATH" "$BRANCH_NAME" 2>&1
else
  # New branch
  git worktree add "$WORKTREE_PATH" -b "$BRANCH_NAME" "origin/$DEFAULT_BRANCH" 2>&1
fi

echo ""
echo "SWITCH:${WORKTREE_PATH}"
echo "Created worktree for branch '${BRANCH_NAME}' at ${WORKTREE_PATH}"
