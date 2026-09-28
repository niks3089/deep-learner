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

It reads the code first, then asks one question at a time (trace the flow, why, what breaks if, predict the output), pushes back on vague or wrong answers with `file:line` evidence, and ends with a scorecard: solid / shaky / gaps, each gap pointing at the exact code to go read.
