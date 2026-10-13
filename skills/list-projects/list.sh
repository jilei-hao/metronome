#!/usr/bin/env bash
# List the project folders under the current repo's projects/ directory as a
# markdown table. Called by /list-projects; wiring is in SKILL.md.
#
# Read-only and dependency-free (bash 3.2, git, grep, sed, sort). Always exits
# 0: SKILL.md injects this output, and a non-zero exit would abort the whole
# skill instead of showing the message.
set -uo pipefail

root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
dir="$root/projects"

if [ ! -d "$dir" ]; then
  echo "No projects/ directory in $root."
  exit 0
fi

# First markdown heading of a file, without the leading #s. A literal | would
# split the table cell, so escape it.
title() {
  [ -f "$1" ] || return 1
  grep -m1 '^#' "$1" | sed -e 's/^#*[[:space:]]*//' -e 's/|/\\|/g'
}

# One line per project: "<last commit date><TAB><name><TAB><table row>".
# The first two fields are sort keys only.
lines=""
for path in "$dir"/*/; do
  [ -d "$path" ] || continue
  name="$(basename "$path")"

  sprint=""
  [ -f "$path/SPRINT_PLAN.md" ] && sprint="plan"
  [ -f "$path/PROGRESS_LOG.md" ] && sprint="${sprint:+$sprint, }log"
  [ -f "$path/NEXT_SESSION_PROMPT.md" ] && sprint="${sprint:+$sprint, }next"

  # Commit date, not file mtime: mtime changes on every checkout.
  last="$(git -C "$root" log -1 --date=short --format=%cd -- "projects/$name" 2>/dev/null)"

  about="$(title "$path/README.md" || title "$path/SPRINT_PLAN.md" || true)"

  lines="$lines$last	$name	| $name | ${sprint:-—} | ${last:-—} | ${about:-—} |
"
done

if [ -z "$lines" ]; then
  echo "$dir has no project folders."
  exit 0
fi

count="$(printf '%s' "$lines" | grep -c .)"
echo "$count project folder(s) in $dir, most recently committed first:"
echo
echo "| Project | Sprint files | Last commit | About |"
echo "|---|---|---|---|"
# Newest commit first; folders with no commit sort last; ties go by name.
printf '%s' "$lines" | sort -t '	' -k1,1r -k2,2 | cut -f3-

exit 0
