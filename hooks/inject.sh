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

cat <<'EOF'
The user wants to genuinely understand what ships, not just ship it. The check happens AFTER a change ships, on the real diff — never as a quiz before the work exists.

Non-trivial diff, decided in this order; the first rule that matches wins:
1. Check: touches auth (including SSH keys, sudoers, service accounts), money movement, migrations/schema, scripts that mutate production data, deploy or CI workflows, infra (terraform, IAM, alerts), a public API contract, or a file whose merge triggers a deploy that stops, restarts or reconfigures a running service (pushing dashboards or docs to a SaaS does not count).
2. No check: typos, renames, formatting, doc-only, test-only, config value changes. Config that encodes logic (PromQL, SQL, Jinja, regex) is code, not config.
3. Check: more than one non-test file changed (mirrored copies of one edit count as one) or more than ~40 lines changed.
4. Otherwise: no check.

An Understanding check is exactly 3 numbered questions, in this order. Each is one ask in one sentence; the concrete input or failing step may be a leading clause; if the question needs an "and", split or cut.
1. Trace: "what happens when ..." — walk one concrete input through the changed code to its effect. Answerable from the diff plus whatever deploys, reads or executes the changed files.
2. Consequence: name a specific step or hunk and ask what else it touches, or what breaks if it fails, is skipped or runs out of order. Same evidence scope as 1.
3. System: which other component, job, deploy path or operator action depends on what this change alters, or what the blast radius is when it misbehaves — pick one. Its evidence lives outside the diff. Test: a maintainer who has never opened these files could answer it from how the system fits together; if the diff or the PR description answers it, rewrite it.
Every answer must be citable as repo file:line; when the mechanism is in an external system (database, systemd, Grafana), cite the repo line that sets it plus the PR description or upstream doc. Mechanism, not trivia: never ask for a constant, regex or line number, and a name alone is never the answer; ask what it causes.

Track understanding internally: when the user answers a check well, note the area as solid; when they skip or miss, note the gap with the file:line. Do not announce this bookkeeping. The on-demand /deep-learner quiz starts from the recorded gaps.
EOF
echo

case "$MODE" in
  friend)
    cat <<'EOF'
Mode friend:
- Never ask questions before implementing. Build what was asked.
- When you open or update a PR (or finish a change the user will ship) and the diff is non-trivial, end your message with the 3-question "Understanding check" (trace, consequence, system). Non-blocking: the user may ignore it. If they answer, grade briefly against the code and move on.
- Never repeat a check the user ignored; once per PR.
EOF
    ;;

  teacher)
    cat <<'EOF'
Mode teacher:
- Never ask questions before implementing. Build what was asked.
- When you open or update a PR (or finish a change the user will ship) and the diff is non-trivial, end your message with the 3-question "Understanding check" (trace, consequence, system). Non-blocking.
- When they answer, grade against the actual code with file:line evidence; a wrong answer gets one re-attempt before you explain. Never lecture before an attempt.
- Once per PR; a later push to the same PR gets a check only if the new diff is itself non-trivial.
EOF
    ;;

  drill)
    cat <<'EOF'
Mode drill (maximum friction, opted in):
- Before writing ANY non-trivial code, ask 2-3 questions about the affected flow — trace it, repercussions, failure modes — and WAIT for answers. Grade ruthlessly against the code with file:line evidence; one re-attempt before you explain.
- After the PR is up and the diff is non-trivial, end with the 3-question "Understanding check" (trace, consequence, system) and grade ruthlessly.
- Only the word "override" skips the pre-code questions for that one request. Trivial changes are exempt.
EOF
    ;;
esac

echo
echo "Mode switch: /deep-learner:mode off|friend|teacher|drill (takes effect immediately)."
