---
description: List worktrees, switch between them, or create new ones
argument-hint: "[number | branch-name]"
allowed-tools: [Bash]
model: haiku
---
Run `${CLAUDE_PLUGIN_ROOT}/scripts/tree.sh $ARGUMENTS` and display the output. If the output contains a line starting with `SWITCH:`, run `cd` to the path after the colon. If no argument was provided in `$ARGUMENTS` and more than one worktree exists, ask the user which number to switch to, then run `${CLAUDE_PLUGIN_ROOT}/scripts/tree.sh <number>` and `cd` to the `SWITCH:` path. Do not add any commentary.
