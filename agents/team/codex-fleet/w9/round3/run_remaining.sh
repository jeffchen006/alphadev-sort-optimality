#!/usr/bin/env bash
set -euo pipefail
cd /path/to/repo/agents/team/codex-fleet/w9
if [[ ! -f round3/artifacts/origin_controls.json ]]; then
    nice -n 19 python3 -B round3/src/origin_controls.py > round3/logs/origin_controls.log 2>&1
fi
nice -n 19 python3 -B round3/src/run.py unknown --seconds 900 --origin-cuts > round3/logs/remaining_unknown.log 2>&1
nice -n 19 python3 -B round3/src/audit.py > round3/logs/remaining_audit.log 2>&1
nice -n 19 python3 -B round3/src/final_report.py
