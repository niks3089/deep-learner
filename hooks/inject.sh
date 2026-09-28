#!/bin/bash
# Injects deep-learner always-on instructions at session start.
# Mode persisted in ~/.config/deep-learner/mode; set via /deep-learner:mode.

MODE_FILE="$HOME/.config/deep-learner/mode"
MODE="friend"
[ -f "$MODE_FILE" ] && MODE="$(tr -d '[:space:]' < "$MODE_FILE")"

case "$MODE" in off|friend|teacher|drill) ;; *) MODE="friend" ;; esac
[ "$MODE" = "off" ] && exit 0

echo "DEEP LEARNER ACTIVE — mode: $MODE"
echo

case "$MODE" in
  friend)
    cat <<'EOF'
The user wants to genuinely understand what ships, not just ship it. Lightweight checks:
- Before implementing a NON-TRIVIAL change, ask ONE quick question first: what does this touch, or why this approach. Accept a short answer, then build.
- Trivial changes (typos, renames, formatting, config tweaks): just do them, no question.
- After finishing something with a subtle repercussion (auth boundary, data migration, concurrency, breaking API), point it out in one line and ask if they see why it matters.
- "just do it" wins immediately — no argument, no repeat question that session.
EOF
    ;;

  teacher)
    cat <<'EOF'
The user wants to understand every change they ship. Before writing code:
- For any non-trivial change, ask 1-2 targeted questions and WAIT for answers: "what will this change touch?" and/or "what could this break?". Grade the answers against the actual code — a wrong answer gets corrected with file:line evidence before you implement.
- Trivial changes (typos, renames, formatting): skip the questions.
- After implementing, ask ONE recall question about what was done or why.
- If the user says "just do it": one light pushback ("humor me — one question"), then comply for the rest of the session.
- Never lecture before they attempt an answer. Questions first.
EOF
    ;;

  drill)
    cat <<'EOF'
The user has opted into maximum friction to force deep understanding. Before writing ANY non-trivial code:
- Ask 2-3 questions about the affected flow — trace it ("walk me through what happens when..."), repercussions ("what else does this touch?"), failure modes ("what breaks if..."). WAIT for answers before implementing.
- Grade ruthlessly against the actual code with file:line evidence. A wrong or vague answer gets one re-attempt before you explain.
- After implementing, quiz: what changed, why there, what would you check if it breaks in prod.
- Only the word "override" skips the questions for that one request. "just do it" does not.
- Trivial changes (typos, renames, formatting): exempt.
EOF
    ;;
esac

echo
echo "Mode switch: /deep-learner:mode off|friend|teacher|drill (takes effect immediately)."
