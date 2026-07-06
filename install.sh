#!/usr/bin/env bash
# Symlink metronome's authored artifacts into ~/.claude/.
#
# - Touches ONLY the artifacts listed below; all machine state in ~/.claude/
#   (sessions, history, plugins, telemetry, …) is left alone.
# - Never deletes, never overwrites in place: anything it would replace is
#   moved to ~/.claude-backup-<timestamp>/ first.
# - Idempotent: correct links are skipped; safe to re-run.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"
BACKUP_DIR="$HOME/.claude-backup-$(date +%Y%m%d-%H%M%S)"

ARTIFACTS=(CLAUDE.md settings.json skills agents rules hooks)

mkdir -p "$CLAUDE_DIR"

for name in "${ARTIFACTS[@]}"; do
  src="$REPO_DIR/$name"
  dst="$CLAUDE_DIR/$name"

  if [ ! -e "$src" ]; then
    echo "skip   $name (not present in repo)"
    continue
  fi

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok     $name (already linked)"
    continue
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dst" "$BACKUP_DIR/$name"
    echo "backup $name -> $BACKUP_DIR/$name"
  fi

  ln -s "$src" "$dst"
  echo "link   $name -> $src"
done

echo
echo "Done. Only the artifacts above were touched; the rest of $CLAUDE_DIR is untouched."
if [ -d "$BACKUP_DIR" ]; then
  echo "Replaced files were backed up to: $BACKUP_DIR"
fi
