#!/bin/bash
# usage: run.sh N  (reads pN.txt, writes outN.md)
cd /path/to/repo/agents/codex
bash /path/to/workspace/schur6/lib/codex_quota.sh || exit 1
codex exec --skip-git-repo-check --sandbox read-only --config model_reasoning_effort="high" -o out$1.md - < p$1.txt > run$1.log 2>&1
