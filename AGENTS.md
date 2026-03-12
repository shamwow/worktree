# Worktree Scripts

This repo contains git worktree management scripts. When the user asks to list, create, switch, or clean up worktrees, use these scripts.

## Scripts

All scripts are in `scripts/` relative to wherever this repo is cloned. If installed globally, they'll be at `~/.worktree/scripts/`.

### tree.sh — List, switch, or create worktrees

```bash
scripts/tree.sh              # list worktrees + show current status
scripts/tree.sh 2            # switch to worktree #2
scripts/tree.sh my-feature   # create or switch to worktree for "my-feature"
```

- If the output contains `SWITCH:<path>`, change your working directory to that path using the `workdir` parameter.
- If the output contains `SELECT:`, ask the user which worktree to switch to (number) or branch name to create, then re-run with their answer.
- New branches are created off the repo's default branch. Worktrees are stored at `<repo>/.worktrees/<branch>`.

### cleanup.sh — Remove a worktree and delete its branch

```bash
scripts/cleanup.sh my-feature   # remove specific branch + worktree
scripts/cleanup.sh              # remove current branch + worktree
```

- If the output contains `SWITCH:<path>`, change your working directory to that path.
- Deletes the branch, removes the worktree directory, prunes, and pulls the default branch.

### pr.sh — Push and create a pull request

```bash
scripts/pr.sh                   # create PR with auto-generated title
scripts/pr.sh "Add user auth"   # create PR with custom title
```

- Pushes the current branch and creates a PR via `gh pr create`.
- Requires GitHub CLI (`gh`).
