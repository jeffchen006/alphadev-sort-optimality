#!/usr/bin/env bash
set -euo pipefail
cd /path/to/repo/agents/team/codex-fleet/w9
exec 9>round5/RUN.lock
flock -n 9 || exit 1
if [[ ! -f round5/artifacts/queue.json ]]; then
    nice -n 19 python3 -B round5/src/run.py prepare >round5/logs/preparation.log 2>&1
fi
if [[ ! -f round5/artifacts/controls.json ]]; then
    nice -n 19 python3 -B round5/src/run.py controls >round5/logs/controls.log 2>&1
fi
if [[ -f round5/FOUND.json ]]; then exit 0; fi
nice -n 19 python3 -B round5/src/run.py run --seconds 900 >>round5/logs/classes.log 2>&1
nice -n 19 python3 -B round5/src/audit.py >round5/logs/audit.log 2>&1
nice -n 19 python3 -B round5/src/run.py report
