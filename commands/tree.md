---
description: List worktrees, switch between them, or create new ones
argument-hint: "[number | branch-name]"
allowed-tools: [Bash, AskUserQuestion]
model: haiku
---
Run `${CLAUDE_PLUGIN_ROOT}/scripts/tree.sh $ARGUMENTS` and display the output.

If the output contains a line starting with `SWITCH:`, you MUST immediately run `cd <path>` using the Bash tool, where `<path>` is the text after `SWITCH:`.

If the output contains a line starting with `SELECT:`, use AskUserQuestion to ask the user which worktree to switch to (number) or branch name to create. Then run `${CLAUDE_PLUGIN_ROOT}/scripts/tree.sh <their-answer>` and handle any `SWITCH:` line as above.

Do not add any commentary.
