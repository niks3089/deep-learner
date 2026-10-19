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

Two hooks make it work while you work, without quizzing you up front. SessionStart loads the mode's rules; UserPromptSubmit re-injects them on prompts that ship a change (open or update a PR, commit and push), so the behaviour holds late in a long session. Nothing is asked before coding. When a PR goes up and its diff is non-trivial (more than one non-test file, more than ~40 lines, or anything touching auth, money, migrations, deploy/CI, infra or a public API), Claude ends its message with a non-blocking **Understanding check** of three questions: two on the diff (trace a concrete input through it; what else it touches or what breaks if a piece fails) and one at system level (which other component, job or operator action depends on what changed, answerable by a maintainer who never opened the files). Answer it or ignore it. Claude tracks which areas you answered well and which you skipped, and the on-demand `/deep-learner` quiz starts from those gaps. Intensity is configurable:

```
/deep-learner:mode friend    # 3-question check after a non-trivial PR, briefly graded, non-blocking (default)
/deep-learner:mode teacher   # same 3 questions, graded with file:line evidence, one re-attempt on misses
/deep-learner:mode drill     # 2-3 blocking questions before coding plus the post-PR check; only "override" skips
/deep-learner:mode off       # no interjections; /deep-learner quiz still works on demand
```

The mode persists in `~/.config/deep-learner/mode` and applies to every project.

It reads the code first, then asks one question at a time (trace the flow, why, what breaks if, predict the output), pushes back on vague or wrong answers with `file:line` evidence, and ends with a scorecard: solid / shaky / gaps, each gap pointing at the exact code to go read.
