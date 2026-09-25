#!/usr/bin/env bash
# SessionStart hook: reports whether a brain folder is visible in this session
# and, if not, tells the assistant how to guide the user to select it.
set -u

HOOK_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "$HOOK_DIR/.." && pwd)"
# POLA_CONFIG_DIR isolates tests and hosts without a stable HOME; POLA_CONFIG_FILE overrides the file itself.
CONFIG_FILE="${POLA_CONFIG_FILE:-${POLA_CONFIG_DIR:-$HOME/.config/pola}/root}"

# Hook input arrives as JSON on stdin; we only need "cwd".
input=""
if [ ! -t 0 ]; then
  IFS= read -r -t 2 -d '' input || true
fi
cwd="$(printf '%s' "$input" | tr '\n' ' ' | sed -n 's/.*"cwd"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"
if [ -z "$cwd" ] || [ ! -d "$cwd" ]; then cwd="$PWD"; fi

# new brains keep their pages in pages/, brains created before 2026-09-21 in wiki/;
# the starter template (brain.yaml still holds {{OWNER_NAME}}) is never a brain
is_brain() {
  [ -f "$1/brain.yaml" ] && { [ -f "$1/pages/index.md" ] || [ -f "$1/wiki/index.md" ]; } && ! grep -qF '{{OWNER_NAME}}' "$1/brain.yaml"
}

# Looks at the folder itself only, never above or below it: there lie test brains, unpacked plugins and
# other people's folders, and where the brain lives is what the entry is for. (Cowork runs no hook.)
find_brain() {
  [ -n "$1" ] && [ -d "$1" ] && is_brain "$1" || return 1
  printf '%s' "$1"
}

same_folder() {
  [ -n "$1" ] && [ -n "$2" ] && [ "$(cd "$1" 2>/dev/null && pwd -P)" = "$(cd "$2" 2>/dev/null && pwd -P)" ]
}

json_escape() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\n'/\\n}"
  s="${s//$'\r'/}"
  s="${s//$'\t'/ }"
  printf '%s' "$s"
}

brain=""
for base in "$cwd" "${CLAUDE_PROJECT_DIR:-}"; do
  if [ -z "$brain" ]; then brain="$(find_brain "$base" || true)"; fi
done

configured=""
if [ -f "$CONFIG_FILE" ]; then
  configured="$(head -n 1 "$CONFIG_FILE" | tr -d '\r')"
fi

hint="$(cat "$PLUGIN_ROOT/platform/folder-hint.txt" 2>/dev/null || true)"
confirm="Ask the user to confirm once the folder is selected. After they confirm, check that brain.yaml is readable: if yes, say in one sentence that the brain is ready and continue with whatever they wanted; if not, say what you can see and repeat the instruction once. If a folder cannot be added to a running session, tell them to start a new session from their Brain folder or project. If the user prefers to continue without the brain, help them normally and do not raise this again in this session."

# The entry wins over the working folder; the folder itself counts only when the entry leads nowhere.
if [ -n "$configured" ] && is_brain "$configured" && ! same_folder "$brain" "$configured"; then
  state="reachable"
  msg="Pola [state=reachable]: the user's brain is at $configured. It is not the current working folder, but this session can read it. Use the 'pola-brain' skill with that path as brain root. Never create brain.yaml, sources/ or pages/ in the current folder."
elif [ -n "$brain" ]; then
  state="active"
  pages_dir="$brain/pages"; [ -d "$pages_dir" ] || pages_dir="$brain/wiki"
  pages="$(find "$pages_dir" -mindepth 2 -name '*.md' 2>/dev/null | wc -l | tr -d ' ')"
  msg="Pola [state=active]: brain folder at $brain ($pages pages). Use the 'pola-brain' skill for ingest, questions about the user's own knowledge, lint, and for capturing things the user tells you about people, companies, meetings or projects. Do not mention this notice unless it is relevant."
  if ! grep -q '"completed"[[:space:]]*:[[:space:]]*true' "$brain/.brain/onboarding.json" 2>/dev/null; then
    msg="$msg Onboarding is not finished. If the user asks to continue or to carry on, load the 'pola-onboard' skill and continue at the first open phase without asking for confirmation again. If they ask for something else, do that and offer once, in one sentence, to continue the onboarding."
  fi
elif [ -n "$configured" ]; then
  # Quiet: the user is working on something else. The brain is mentioned only when they bring it up.
  state="not-selected"
  msg="Pola [state=not-selected]: the user has a brain at $configured, but this session cannot access that folder. Do not mention the brain or this notice unless the user asks about their brain or wants to add something to it. If they do, say in one sentence that their brain at $configured is not selected in this session and explain in two sentences how to select it: $hint $confirm"
else
  # Quiet: the plugin is installed, nothing more. Nobody wants an onboarding offer in an unrelated project.
  state="unknown"
  msg="Pola [state=unknown]: the plugin is installed, but no brain folder is visible in this session. Do not mention the brain, the plugin or this notice unless the user asks about a brain or wants to set one up. If they do: a brain they already have is selected as described here ($hint $confirm); a new one is created with /pola:pola-onboard in about twenty minutes."
fi

printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$(json_escape "$msg")"
exit 0
