#!/bin/bash
# UserPromptSubmit: when the prompt asks for a code change or a PR, re-inject the
# current mode's rule right next to the request. The SessionStart text fades in
# long sessions; this does not. Prints nothing for other prompts or in mode off.

MODE_FILE="$HOME/.config/deep-learner/mode"
MODE="friend"
[ -f "$MODE_FILE" ] && MODE="$(tr -d '[:space:]' < "$MODE_FILE")"
case "$MODE" in off|friend|teacher|drill) ;; *) MODE="friend" ;; esac
[ "$MODE" = "off" ] && exit 0

PROMPT="$(jq -r '.prompt // empty' 2>/dev/null)"
[ -z "$PROMPT" ] && exit 0

# A request to change code or ship it. Questions, reviews and explanations pass through.
if ! printf '%s' "$PROMPT" | grep -qiE \
  '\b(implement|add|build|create|write|fix|refactor|rename|remove|delete|migrate|update|change|rewrite|wire|hook up|make it|convert|replace|introduce|extract|inline|bump)\b.*\b(code|function|class|module|endpoint|route|handler|hook|component|test|tests|migration|schema|table|column|workflow|pipeline|script|config|flag|feature|bug|type|types|method|service|job|cron|api|ui|page|button|form|query|model)\b|\b(open|create|make|raise|send|push|ship)\b.*\b(pr|prs|pull request|merge request)\b|\bcommit\b.*\bpush\b|\bpush\b.*\bbranch\b'; then
  exit 0
fi

# The user is overriding; stay out of the way.
if printf '%s' "$PROMPT" | grep -qiE '\bjust do it\b|\boverride\b|\bno questions?\b|\bskip the quiz\b'; then
  exit 0
fi

case "$MODE" in
  friend)
    echo "DEEP LEARNER (friend): this prompt changes code or ships a PR. Unless it is trivial (typo, rename, formatting, config tweak), ask ONE quick question first: what does this change touch, or why this approach. Accept a short answer, then build. If they say 'just do it', build."
    ;;
  teacher)
    echo "DEEP LEARNER (teacher): this prompt changes code or ships a PR. Unless trivial, before writing any code ask 1-2 targeted questions ('what will this touch?', 'what could this break?') and WAIT. Grade the answers against the actual code with file:line evidence, correct what is wrong, then implement. After implementing, ask ONE recall question. Questions first, never a lecture before an attempt."
    ;;
  drill)
    echo "DEEP LEARNER (drill): this prompt changes code or ships a PR. Unless trivial, before writing ANY code ask 2-3 questions about the affected flow (trace it, what else it touches, what breaks if) and WAIT for answers. Grade ruthlessly against the code with file:line evidence; one re-attempt before you explain. After implementing, quiz: what changed, why there, what to check if it breaks in prod. Only the word 'override' skips this."
    ;;
esac
