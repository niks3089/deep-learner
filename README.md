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

Two hooks make it interject while you work. SessionStart loads the mode's rules once; UserPromptSubmit re-injects them on every prompt that asks for a code change or a PR (implement, fix, refactor, open a PR, push a branch, …), so the questions keep coming late in a long session instead of fading with the opening context. Questions, reviews and explanations pass through untouched, and so does a prompt that says "just do it" or "override". When a prompt matches, Claude first asks whether you understand what the change touches and what it could break. Intensity is configurable:

```
/deep-learner:mode friend    # one quick check before non-trivial changes; "just do it" wins (default)
/deep-learner:mode teacher   # 1-2 questions before coding, graded against the code, recall question after
/deep-learner:mode drill     # 2-3 blocking questions, ruthless grading, post-implementation quiz; only "override" skips
/deep-learner:mode off       # no interjections; /deep-learner quiz still works on demand
```

The mode persists in `~/.config/deep-learner/mode` and applies to every project.

It reads the code first, then asks one question at a time (trace the flow, why, what breaks if, predict the output), pushes back on vague or wrong answers with `file:line` evidence, and ends with a scorecard: solid / shaky / gaps, each gap pointing at the exact code to go read.
