---
description: Set deep-learner intensity (off | friend | teacher | drill)
---

Set the deep-learner mode to: $ARGUMENTS

1. Valid modes: `off`, `friend`, `teacher`, `drill`. If the argument isn't one of these (or is empty), show the current mode (`~/.config/deep-learner/mode`, default `friend`) and the four options with a one-line description each, then stop.
2. Otherwise run: `mkdir -p ~/.config/deep-learner && echo <mode> > ~/.config/deep-learner/mode`
3. Adopt the new mode's behavior immediately for the rest of this session — don't wait for the SessionStart hook (it applies the mode to future sessions). Confirm in one line.

Mode meanings:
- **off** — no interjections; `/deep-learner` quiz still available on demand.
- **friend** — no questions before coding; one non-blocking understanding question after a non-trivial PR.
- **teacher** — no questions before coding; two graded questions after a non-trivial PR, file:line evidence on misses.
- **drill** — 2-3 questions blocking any non-trivial code, ruthless grading, post-PR quiz; only "override" skips.
