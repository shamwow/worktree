---
description: Remove a worktree and delete its branch
argument-hint: "[branch-name]"
allowed-tools: [Bash]
model: haiku
---
Run `${CLAUDE_PLUGIN_ROOT}/scripts/cleanup.sh $ARGUMENTS` and display the output. If the output contains a line starting with `SWITCH:`, run `cd` to the path after the colon. Do not add any commentary.
