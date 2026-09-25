#!/usr/bin/env bash
# Checks the page contract of a brain. Thin entry to the TypeScript validator in the bundled CLI;
# no rules live in this file.
# Usage: verify-brain.sh <brain-root>    Exit: 0 ok, 1 rule violations, 2 not a brain, 69 no runtime
set -u
root="${1:-.}"
HERE="$(cd "$(dirname "$0")" && pwd)"
POLA=""
for cand in "$HERE/../tools/pola" "$HERE/../../../dist/claude/tools/pola"; do
  if [ -f "$cand" ] && [ -f "$cand.cjs" ]; then POLA="$cand"; break; fi
done
if [ -z "$POLA" ]; then
  echo "ERROR: bundled CLI not found next to $HERE (run scripts/build-plugins.sh in the repository)"; exit 69
fi
sh "$POLA" validate --brain "$root" --text
