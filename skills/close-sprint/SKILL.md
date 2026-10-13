---
name: close-sprint
description: Close a FINISHED sprint — ledger row, elevate findings to docs/memory/tools, remove every pointer into the sprint directory, tag, move the directory to the archive, commit. Run instead of /handoff when the sprint's goal is done (merged, shipped, or dropped by decision).
disable-model-invocation: true
---

# Close sprint

Operates on one `projects/<sprint>/` directory whose goal is finished. If the
goal is not finished, run `/handoff` instead. If more than one sprint is
active, ask which. Never start new work from inside a close.

The archive root is named in the project's `CLAUDE.md` (e.g.
`/data/jilei/vigil-data/__archive/vigil-developer/projects/` for
vigil-developer); if it names none, ask. The rule is in
`projects/README.md`; the history is `projects/LEDGER.md`.

1. **Final log entry.** Append to `PROGRESS_LOG.md`: what landed (PR numbers,
   branches, commits), what did not, tests run. Leave `NEXT_SESSION_PROMPT.md`
   as it was; the entry supersedes it.
2. **Ledger row** in `projects/LEDGER.md`: Sprint · Active · Goal · Landed ·
   Kept at wrapper level. Verify "Landed" against the upstream repo's history.
   Squash merges hide ancestry, so grep for the *change* in the target branch,
   not for the commit.
3. **Triage every non-state file by one rule.** Elevate it if a future session
   would act differently knowing it: a trap, a number that is now a shipped
   default, a decision and its why, an open ask to another team. Archive it if
   it describes the state of a branch on a date, a measurement whose conclusion
   shipped, or a plan that was executed. Destinations: a `docs/` **topic** page
   (never a sprint page; list it in `docs/README.md`), a memory note (one line
   in `MEMORY.md`), or `tools/` (list it in `tools/README.md`). Harnesses are
   archived unless something outside the sprint depends on them; then promote
   them to `tools/` and fix their internal paths and usage lines.
4. **Repoint.** Grep for `projects/<sprint>` across `CLAUDE.md`, `docs/`,
   `tools/`, `.claude/`, the launch scripts, the memory directory and
   `~/.claude/skills`. Each hit is a decision: promote the target, or rewrite
   the pointer to the docs/tools destination or to the archive path. Done when
   the grep returns nothing.
5. **Tag and move.**
   ```bash
   git tag archive/<sprint>-<yyyymm>
   mv projects/<sprint> <archive-root>/
   git add -u projects            # never `git add -A`: untracked outputs stay out of git
   git commit -m "archive: close <sprint> (see projects/LEDGER.md)"
   ```
   The tag keeps tracked content retrievable; the move is what carries the
   untracked and gitignored outputs. Copy-back is one `cp -r` from the archive.
6. **Check tier 1 did not grow.** `CLAUDE.md` and `MEMORY.md` gain pointers,
   not paragraphs. If a new memory hook is longer than one line, shorten it.
