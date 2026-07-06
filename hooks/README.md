# hooks/

Enforcement scripts. Memory, skills, and rules are *advisory* — the model can
drift past them. Hooks are *deterministic*: the harness runs them at lifecycle
events regardless of what the model intends. Use them for gates.

**Everything here ships DISABLED.** A script in this directory does nothing
until you wire it into `settings.json` yourself — enabling enforcement is a
deliberate act, not a side effect of installing.

## Wiring (verified: code.claude.com/docs/en/hooks.md, Claude Code 2.1.161)

Hook config lives under the `"hooks"` key in `settings.json`. Event names in
current use include `PreToolUse`, `PostToolUse`, `UserPromptSubmit`, `Stop`,
`SubagentStop`, `SessionStart`, `SessionEnd`, `PreCompact`. For a `command`
hook: exit `0` lets the action proceed, exit `2` **blocks it** with stderr fed
back to Claude as the reason; other codes proceed with a visible error notice.
The hook receives a JSON payload (tool name, tool input, …) on stdin.

## Example: `pre-commit-gate.sh`

Blocks `git commit --no-verify` — the agent must fix a failing pre-commit
check, not bypass it. This is the test-as-ratchet principle enforced at the
tool boundary (see docs/sprint-workflow.md).

Enable by adding to `settings.json`:

```json
"hooks": {
  "PreToolUse": [
    {
      "matcher": "Bash",
      "hooks": [
        { "type": "command", "command": "$HOME/.claude/hooks/pre-commit-gate.sh" }
      ]
    }
  ]
}
```

Note the path points at the `~/.claude/hooks/` symlink, not at the repo, so
the wiring survives a repo move.
