---
name: list-projects
description: List the project folders in the current repo's projects/ directory — which sprint files each has, its last commit date, and a one-line summary.
disable-model-invocation: true
allowed-tools: Bash(${CLAUDE_SKILL_DIR}/list.sh)
---

# List projects

Claude Code ran `list.sh` (next to this file) before you saw this. Its output
is below: one row per folder in the current repo's `projects/` directory.

!`${CLAUDE_SKILL_DIR}/list.sh`

Show that output to the user as it is. Keep the table, the row order, and
every row.

How to read the columns, if the user asks:

- **Sprint files** — which of the three sprint-state files the folder has:
  `plan` is `SPRINT_PLAN.md`, `log` is `PROGRESS_LOG.md`, `next` is
  `NEXT_SESSION_PROMPT.md`. `/handoff` needs all three, so a folder showing
  fewer, or `—`, isn't set up as a sprint.
- **Last commit** — date of the newest commit that touched the folder. `—`
  means nothing in it is committed yet.
- **About** — the first heading of the folder's `README.md`, or of
  `SPRINT_PLAN.md` if there's no README.

Loose files directly under `projects/` aren't projects, so they're left out.

This is a listing only. Don't open any project, read its sprint files, or
start work from here. The user picks what to work on.
