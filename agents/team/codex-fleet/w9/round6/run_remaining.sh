#!/usr/bin/env bash
set -euo pipefail
cd /path/to/repo/agents/team/codex-fleet/w9
exec 9>round5/RUN.lock
# Wait for the active representative and its final report. This wait uses no CPU.
flock 9
rm -f round5/STOP_AFTER_QUERY
if [[ ! -f round5/FOUND.json ]]; then
    nice -n 19 python3 -B round5/src/run.py run --seconds 900 >>round6/logs/classes.log 2>&1
fi
nice -n 19 python3 -B round5/src/audit.py >round6/logs/audit.log 2>&1
nice -n 19 python3 -B round5/src/run.py report
nice -n 19 python3 -B round6/src/report.py >round6/logs/final_report.log
