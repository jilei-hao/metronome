---
paths:
  - "__metronome_docs_never_match__/**"
---

# rules/

Path-scoped (or global) rules, loaded by Claude Code from `~/.claude/rules/`
once this directory is symlinked in.

How loading works (verified: code.claude.com/docs/en/memory.md):
- A rule file **with** `paths:` frontmatter (glob patterns) is loaded only when
  Claude works on files matching those globs.
- A rule file **without** `paths:` is loaded unconditionally, every session —
  same cost as putting it in CLAUDE.md, so hold it to the same bar.

This README and `_template.md` carry a `paths:` value that matches nothing, so
they never enter context even though they live in the live rules directory.
Real rules: copy `_template.md`, give it real globs (or delete `paths:` for a
deliberate global rule), and keep each rule to one subsystem's worth of
guidance. When a rule only applies to one project, prefer that project's
`.claude/rules/` over this user-level directory.
