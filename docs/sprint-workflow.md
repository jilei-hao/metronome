# Sprint workflow: the three-file pattern

Session memory does not survive; files do. Each project keeps its sprint state
in `projects/<sprint>/` as three files with fixed names and distinct lifetimes:

| File | Lifetime | Discipline |
|---|---|---|
| `SPRINT_PLAN.md` | the sprint | written at sprint start; only checkboxes change mid-sprint |
| `PROGRESS_LOG.md` | append-only, forever | one dated entry per session; never rewritten |
| `NEXT_SESSION_PROMPT.md` | one session | rewritten wholesale at every handoff |

`SPRINT_PLAN.md` holds scope, goals, and done-criteria. `PROGRESS_LOG.md` is
the journal: what was attempted, what landed (commit hashes), what broke,
decisions and their reasons. `NEXT_SESSION_PROMPT.md` is the ignition key: the
exact prompt the next session starts from, written for a reader with zero
memory. It holds the current state in a paragraph, the open items, the files to
read first, and known traps.

**The next-session prompt lists the open work but doesn't pick from it; the
user chooses each session's goal.** The agent writing a handoff knows the least
about what will matter next time. Priorities shift between sessions — a review,
a planning meeting, other projects — and a goal written into the prompt tends
to get executed rather than questioned. The prompt groups the open items as a
reminder, notes where one item depends on another, and records a next goal
only if the user named it.

This is data, not instructions: it lives in the project, is committed with the
project, and is *referenced* from memory files, never inlined (see
conventions.md).

## Start ritual

1. Read `NEXT_SESSION_PROMPT.md` — it is the session's brief.
2. Unless the user has already said, ask which open item this session is for.
   Show the grouped list; don't pick one yourself.
3. Skim `SPRINT_PLAN.md` for where that item sits in the sprint, and flag any
   unfinished dependency before starting.
4. Only then touch code.

## End ritual

Run `/handoff`. It appends the log entry, rewrites the next-session prompt,
ticks plan checkboxes, and makes a checkpoint commit — in that order, and
starts no new work. The ritual is a skill so it's executed, not remembered.

## Test-as-ratchet

Tests only ratchet forward:

- A sprint item is done only when its behavior has a test that would **fail on
  regression** — existence and greenness of tests is not the bar; catching
  power is (this is exactly what the `code-reviewer` agent probes).
- Never delete or weaken a test to get to green. If a test is genuinely wrong,
  fixing it is its own logged decision in `PROGRESS_LOG.md`, not a drive-by.
- Red tests at handoff don't block the checkpoint commit, but they must be
  recorded in the log entry and reflected in `NEXT_SESSION_PROMPT.md` — the
  next session inherits them as stated debt, not as a surprise.
- Bypassing gates (`git commit --no-verify`) is the anti-pattern; the
  `pre-commit-gate.sh` hook exists to make it impossible rather than
  discouraged (see hooks/README.md).
