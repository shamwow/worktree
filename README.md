# worktree

Git worktree management for AI coding tools. Create, switch between, and clean up worktrees without leaving your conversation.

Claude Code supports worktrees via `claude --worktree`. The key difference between this plugin and the native plugin is the ability to manage worktrees from the same conversation vs having to exit and run claude again with --worktree.

Works with **Claude Code** (plugin) and **Codex CLI** (AGENTS.md).

## Install

### Claude Code

```bash
claude plugin add shamwow/worktree
```

This gives you `/tree`, `/cleanup`, and `/pr` slash commands.

### Codex CLI

Clone the repo and copy the AGENTS.md snippet into your project:

```bash
git clone https://github.com/shamwow/worktree.git ~/.worktree
```

Then add to your project's `AGENTS.md`:

```markdown
## Worktree management
Use the scripts at ~/.worktree/scripts/ for worktree operations.
See ~/.worktree/AGENTS.md for usage details.
```

## Commands

### `tree [number | branch-name]`

Shows current worktree status and lists all worktrees.

```
tree                  # show status + list worktrees
tree 2                # switch to worktree #2
tree my-feature       # create (or switch to) a worktree for "my-feature"
```

New branches are created off the default branch. Worktrees live at `<repo>/.worktrees/<branch>`.

### `cleanup [branch]`

Remove a worktree and delete its branch. Defaults to current branch if none given.

```
cleanup my-feature    # remove specific branch
cleanup               # remove current branch
```

### `pr [title]`

Push current branch and create a pull request.

```
pr                        # create PR with auto-generated title
pr "Add user auth"        # create PR with custom title
```

## Requirements

- Git
- GitHub CLI (`gh`) — for `pr` only
