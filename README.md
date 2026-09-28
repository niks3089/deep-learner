# deep-learner

A Claude Code skill that quizzes you on the system you're working in. Active recall, graded against the actual code — it never takes your word for it.

## Install

```
/plugin marketplace add niks3089/deep-learner
/plugin install deep-learner@niks3089
```

## Use

```
/deep-learner                      # quizzes you on the most active area of the repo
/deep-learner the vault auth flow  # quizzes you on a specific subsystem
/deep-learner grill me on server/  # 10+ questions, deepest details
```

## Always-on mode

A SessionStart hook makes it interject while you work: when you ask Claude to code something non-trivial, it first asks whether you understand what the change touches and what it could break. Intensity is configurable:

```
/deep-learner:mode friend    # one quick check before non-trivial changes; "just do it" wins (default)
/deep-learner:mode teacher   # 1-2 questions before coding, graded against the code, recall question after
/deep-learner:mode drill     # 2-3 blocking questions, ruthless grading, post-implementation quiz; only "override" skips
/deep-learner:mode off       # no interjections; /deep-learner quiz still works on demand
```

The mode persists in `~/.config/deep-learner/mode` and applies to every project.

It reads the code first, then asks one question at a time (trace the flow, why, what breaks if, predict the output), pushes back on vague or wrong answers with `file:line` evidence, and ends with a scorecard: solid / shaky / gaps, each gap pointing at the exact code to go read.
