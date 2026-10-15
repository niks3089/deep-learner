#!/bin/bash
# UserPromptSubmit: when the prompt ships a change (opens or updates a PR,
# commits and pushes), re-inject the mode's post-PR rule right next to the
# request, so the understanding check still happens late in a long session.
# Silent for every other prompt and in mode off. Drill also re-injects its
# pre-code questions on code-change prompts.

MODE_FILE="$HOME/.config/deep-learner/mode"
MODE="friend"
[ -f "$MODE_FILE" ] && MODE="$(tr -d '[:space:]' < "$MODE_FILE")"
case "$MODE" in off|friend|teacher|drill) ;; *) MODE="friend" ;; esac
[ "$MODE" = "off" ] && exit 0

PROMPT="$(jq -r '.prompt // empty' 2>/dev/null)"
[ -z "$PROMPT" ] && exit 0

# The user is overriding; stay out of the way.
if printf '%s' "$PROMPT" | grep -qiE '\bjust do it\b|\boverride\b|\bno questions?\b|\bskip the (quiz|check)\b'; then
  exit 0
fi

# Ships a change: opens/updates a PR, pushes, or works a PR referenced by URL
# or number (address/fix/resolve review comments, rebase, etc.).
SHIPS=0
printf '%s' "$PROMPT" | grep -qiE \
  '\b(open|create|make|raise|send|push|ship|update|refresh|rebase|amend)\b.*\b(pr|prs|pull request|merge request)\b|\bcommit\b.*\bpush\b|\bpush\b.*\b(branch|commits?|it|this|the fix)\b|\bmerge (this|it|the pr)\b|\b(address|fix|resolve|respond to|handle|apply)\b.*\b(review\w*|comments?|feedback|findings?|nits?)|(github\.com/[^ ]+/pull/[0-9]+|\bpr ?#?[0-9]+\b|\bpull request [0-9]+).*\b(address|fix|resolve|update|push|rebase|apply|change|implement|handle)\b|\b(address|fix|resolve|update|push|rebase|apply|change|implement|handle)\b.*(github\.com/[^ ]+/pull/[0-9]+|\bpr ?#?[0-9]+\b|\bpull request [0-9]+)' && SHIPS=1

NONTRIVIAL='Non-trivial means: more than one non-test file, more than ~40 changed lines, or anything touching auth, money movement, migrations/schema, deploy/CI workflows, infra (terraform, IAM, alerts) or a public API contract. Otherwise no check.'

if [ "$SHIPS" = 1 ]; then
  case "$MODE" in
    friend)
      echo "DEEP LEARNER (friend): this prompt ships a change. Do the work first. If the resulting diff is non-trivial, end your message with an 'Understanding check': ONE question about that diff, non-blocking, once per PR. $NONTRIVIAL"
      ;;
    teacher)
      echo "DEEP LEARNER (teacher): this prompt ships a change. Do the work first. If the resulting diff is non-trivial, end your message with an 'Understanding check' of 2 questions drawn from the diff (one trace, one consequence), non-blocking, once per PR. Grade answers against the code with file:line evidence. $NONTRIVIAL"
      ;;
    drill)
      echo "DEEP LEARNER (drill): this prompt ships a change. After the PR is up, if the diff is non-trivial, quiz on it: what changed, why there, what to check if it breaks in prod. $NONTRIVIAL"
      ;;
  esac
  exit 0
fi

# Drill keeps its pre-code questions on code-change prompts.
if [ "$MODE" = drill ] && printf '%s' "$PROMPT" | grep -qiE \
  '\b(implement|add|build|create|write|fix|refactor|remove|delete|migrate|update|change|rewrite|wire|convert|replace|introduce|extract)\b.*\b(code|function|class|module|endpoint|route|handler|hook|component|migration|schema|table|column|workflow|pipeline|script|flag|feature|bug|method|service|job|cron|api|page|query|model)\b'; then
  echo "DEEP LEARNER (drill): this prompt changes code. Unless trivial, before writing ANY code ask 2-3 questions about the affected flow (trace it, what else it touches, what breaks if) and WAIT for answers. Grade ruthlessly against the code with file:line evidence; one re-attempt before you explain. Only the word 'override' skips this."
fi
