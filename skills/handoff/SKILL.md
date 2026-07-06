---
name: handoff
description: End-of-session ritual — append the progress log, rewrite the next-session prompt, checkpoint commit. Run before ending any working session.
disable-model-invocation: true
---

# Handoff

End-of-session ritual. Operates on the current project's active sprint
directory, `projects/<sprint>/` — locate it via the project's `SPRINT_PLAN.md`
reference; if more than one sprint is active, ask which. If the project has no
sprint directory yet, say so and stop — don't invent one mid-handoff.

1. **Append to `PROGRESS_LOG.md`** — one dated entry: what was attempted, what
   landed (with commit hashes), what broke or surprised, decisions made and
   why. Append only; never edit earlier entries.
2. **Rewrite `NEXT_SESSION_PROMPT.md`** — replace it wholesale with the prompt
   the next session should start from: current state in one paragraph, the
   single next goal, files to read first, known traps. Write for a reader with
   zero memory of this session.
3. **Tick `SPRINT_PLAN.md`** — mark finished items done. Don't reword the plan
   or add scope; that's a planning act, not a handoff act.
4. **Checkpoint commit** — if tests exist, run them and record the result in
   the log entry (red doesn't block the checkpoint, but it must be recorded).
   Then commit the sprint-state files plus any intentional work-in-progress:
   `checkpoint: <one-line session summary>`.

Never start new work from inside a handoff.
