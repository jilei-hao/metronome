#!/usr/bin/env bash
# PreToolUse gate: block `git commit --no-verify`.
# Wiring and semantics: see hooks/README.md. Ships disabled.
#
# Receives the PreToolUse JSON payload on stdin. Matching is a plain substring
# scan of the payload — deliberately dependency-free (no jq). A commit MESSAGE
# containing the literal string "--no-verify" would false-positive; acceptable
# for a gate whose answer is "reword or don't bypass".
set -euo pipefail

payload="$(cat)"

if printf '%s' "$payload" | grep -q 'git commit' \
   && printf '%s' "$payload" | grep -q -- '--no-verify'; then
  echo "Blocked: 'git commit --no-verify' skips the pre-commit gate." >&2
  echo "Fix the failing check instead of bypassing it (test-as-ratchet)." >&2
  exit 2
fi

exit 0
