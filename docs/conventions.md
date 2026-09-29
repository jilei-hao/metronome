# Conventions: which mechanism for what, and why

Claude Code offers several places to put instructions. They differ on two
axes: **when the content fires** (always / on demand / on path / at an event)
and **whether firing is guaranteed** (advisory to the model vs. enforced by
the harness). Choose by those axes, not by convenience.

## CLAUDE.md — always-on, advisory

Loaded into every session, every project. That makes it the most expensive
real estate we have: every line taxes every session forever.

- Only always-true, universal, brief facts — the working contract.
- Hold it to a hard ceiling on the order of 150–200 instructions' worth of
  content; in practice ours should stay far below that. Point to docs, never
  inline them.
- **Never** transient or sprint state. If a line will be false in a month, it
  doesn't belong here.

## Output styles — how every reply reads, advisory

`~/.claude/output-styles/<name>.md`, selected by `outputStyle` in
settings.json. `/output-style <name>` also works in the terminal, but it saves
to the current project's `settings.local.json`, so it applies to that project
only. The style's instructions go out with every request. That makes it the
place for *how* replies read (voice, length, format), while CLAUDE.md holds
*what* Claude should know and do.

- One style at a time: a custom style replaces a built-in one (Concise,
  Explanatory, …) rather than stacking on top of it.
- Set `keep-coding-instructions: true`, or the style drops Claude Code's own
  software-engineering instructions without any warning.
- `outputStyle` is case-sensitive. A name that doesn't match exactly falls
  back to Default without an error.
- Subagents run their own system prompt and don't inherit the style; only a
  fork does.

Use one when a voice rule outgrows a line or two of CLAUDE.md (say, it needs
a before/after example), or when you want to switch it on and off. None exist
yet. Adding one means adding `output-styles` to `ARTIFACTS` in install.sh.

## Skills — deliberate procedures, on demand

`~/.claude/skills/<name>/SKILL.md`, invoked as `/name`. Progressive
disclosure: the body costs nothing until invoked, so procedures can afford to
be thorough. Use for rituals and recipes executed on purpose (`/handoff`).
Set `disable-model-invocation: true` when the procedure should only ever run
because a human asked for it.

Not for how every reply should read. A skill loads only when invoked or when
Claude matches the task to its description, so a style rule placed in one
would hold on some turns and not others. That belongs in CLAUDE.md or an
output style.

## Rules — scoped guidance, on path

`~/.claude/rules/*.md` with `paths:` glob frontmatter loads only when Claude
works on matching files — one subsystem's guidance, paid for only when that
subsystem is touched. A rule without `paths:` loads unconditionally: same cost
as CLAUDE.md, same bar. Project-specific rules belong in that project's
`.claude/rules/`, not here.

## Hooks — guaranteed, at lifecycle events

Everything above is advisory: the model reads it and usually complies. Hooks
are enforced: the harness runs them at events (`PreToolUse`, `SessionEnd`, …)
and an exit code 2 blocks the action no matter what the model intended. Any
"must" — commit gates, handoff gates, review gates — is a hook, or it is a
hope. Keep hook scripts deterministic and dependency-free; ship them disabled
and enable deliberately (see hooks/README.md).

## Subagents — independent judgment, own context

`~/.claude/agents/<name>.md`. A subagent gets a fresh context: it sees what
it's given, not the session's accumulated reasoning. That isolation is the
point — `code-reviewer` reviews the diff against the requirement precisely
because it *cannot* be contaminated by the author's rationalizations. For the
same reason, its checks live in the agent file, not CLAUDE.md: an author
session that can read the checklist can pre-satisfy it.

## Sprint state is data, not instructions

`SPRINT_PLAN.md`, `PROGRESS_LOG.md`, `NEXT_SESSION_PROMPT.md` live in a
project's `projects/<sprint>/` directory. They change every session; anything
that changes every session is data. CLAUDE.md may say *where* they live —
never *what* they currently say. See docs/sprint-workflow.md.

## The decision rule

1. Must it be **guaranteed**? → hook.
2. Needed **every session, everywhere**, and brief? → CLAUDE.md.
3. Shapes **how every reply reads**, and needs more than a line or two? →
   output style.
4. Only when touching **certain files**? → rule with `paths:`.
5. A **procedure** someone runs on purpose? → skill.
6. Needs a **clean, independent context**? → subagent.
7. Changes **session to session**? → it's data; put it in the project, point
   to it.

---

Verified against Claude Code 2.1.161 and code.claude.com/docs on 2026-07-06:
`memory.md` (CLAUDE.md + rules and `paths:`), `skills.md` (SKILL.md location,
frontmatter, `/name` invocation; `.claude/commands/` is deprecated in favor of
skills), `sub-agents.md` (agents/ location + frontmatter), `hooks.md` (event
names, exit-code semantics), `headless.md` (`claude -p`,
`--output-format text|json|stream-json` — relevant if a gate ever needs to
invoke Claude non-interactively).

Output styles verified against Claude Code 2.1.219 and `output-styles.md` on
2026-09-28 (file location, frontmatter, `outputStyle` setting, subagent
inheritance).
