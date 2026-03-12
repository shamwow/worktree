# worktree

A Claude Code plugin for git worktree workflows. Create, switch between, and clean up worktrees without leaving your conversation.

## Install

```bash
claude plugin add /path/to/worktree
# or from GitHub:
claude plugin add shahmeer-amir/worktree
```

## Commands

### `/tree`

Shows your current worktree status and lists all worktrees for the repo.

```
/tree                 # show status + list worktrees
/tree 2               # switch to worktree #2
/tree my-feature      # create (or switch to) a worktree for branch "my-feature"
```

New branches are created off the default branch. Worktrees live at `/tmp/claude-worktrees/<repo>/<branch>`.

### `/cleanup [branch]`

Remove a worktree and delete its branch. If no branch name is given, cleans up the current branch. Switches back to the main worktree automatically.

```
/cleanup my-feature   # remove specific branch
/cleanup              # remove current branch
```

### `/pr [title]`

Push the current branch and create a pull request. Uses `gh` CLI under the hood.

```
/pr                       # create PR with auto-generated title
/pr "Add user auth"       # create PR with custom title
```

## Requirements

- Git
- GitHub CLI (`gh`) — for `/pr` command only
