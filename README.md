# metronome

Dotfiles for Claude Code. This repo is the single source of truth for how Claude
behaves across all my projects: global memory (`CLAUDE.md`), skills, subagents,
path-scoped rules, hooks, and user-level settings. `install.sh` symlinks the
authored pieces into `~/.claude/`, so edits here apply live everywhere.

**Authored artifacts only.** Machine state — sessions, history, credentials,
plugin caches, telemetry — never lives here. `.gitignore` enforces the obvious
cases; the rule is absolute regardless.

## The decision rule (short form)

Pick the mechanism by *when it must fire* and *whether it must be guaranteed*:

| Mechanism | Fires | Guarantee | Use for |
|---|---|---|---|
| `CLAUDE.md` | every session | advisory | brief, universal, always-true facts |
| `skills/<name>/SKILL.md` | on `/name` | advisory | deliberate procedures (rituals, recipes) |
| `rules/*.md` + `paths:` | when touching matching files | advisory | one-subsystem guidance |
| `hooks/` + settings.json | at a lifecycle event | **deterministic** | gates that must not be skippable |
| `agents/<name>.md` | when delegated | own context | independent judgment (e.g. review) |

Sprint state (`SPRINT_PLAN.md`, `PROGRESS_LOG.md`, `NEXT_SESSION_PROMPT.md`) is
**data**, not instructions — it lives in each project's `projects/<sprint>/` and
is referenced, never inlined into `CLAUDE.md`.

Full rationale: [docs/conventions.md](docs/conventions.md).
Sprint rituals: [docs/sprint-workflow.md](docs/sprint-workflow.md).

## Layout

```
CLAUDE.md              global working contract (lean — see conventions.md)
settings.json          user-level settings; safe values only, no secrets
skills/handoff/        /handoff — end-of-session ritual
agents/code-reviewer.md  adversarial, independent review subagent
rules/                 path-scoped rules (template + README inside)
hooks/                 enforcement scripts; shipped DISABLED (see hooks/README.md)
docs/                  the "why" — conventions and sprint workflow
install.sh             symlinks the above into ~/.claude/, with backup
```

## Install

```sh
./install.sh
```

- Symlinks exactly six things into `~/.claude/`: `CLAUDE.md`, `settings.json`,
  `skills/`, `agents/`, `rules/`, `hooks/`. Everything else under `~/.claude/`
  (sessions, history, plugins, …) is left untouched.
- Anything it would replace is first moved to `~/.claude-backup-<timestamp>/`.
  It never deletes, never overwrites in place.
- Idempotent: already-correct links are skipped; re-run any time.

**settings.json caveat:** Claude Code itself writes to `~/.claude/settings.json`
(e.g. "don't ask again" permission grants, `/config` changes). Through the
symlink those writes land in this repo — treat them as diffs to review and
commit or revert. If an update ever replaces the file instead of writing
through the link (breaking the symlink), re-run `install.sh`.

## Safety

- No secrets, tokens, or session/auth files in this repo, ever. The imported
  `settings.json` was checked: preferences and a permission allowlist only.
- Hooks ship **disabled**. Enabling one is a deliberate edit to `settings.json`
  (snippet in [hooks/README.md](hooks/README.md)).
- `.gitignore` blocks `settings.local.json`, `.claude.json`, and anything
  matching `*token*` / `*key*` / `*credential*` / `*secret*`. If a legitimate
  file ever trips those globs, rename it rather than force-adding.

Verified against Claude Code **2.1.161** and the official docs
(code.claude.com/docs: `memory.md`, `skills.md`, `sub-agents.md`, `hooks.md`,
`headless.md`) on 2026-07-06.
