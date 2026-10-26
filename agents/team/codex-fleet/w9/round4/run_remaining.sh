#!/usr/bin/env bash
set -euo pipefail
cd /path/to/repo/agents/team/codex-fleet/w9
if [[ ! -f round4/artifacts/controls.json ]]; then
    nice -n 19 python3 -B round4/src/run.py controls > round4/logs/controls.log 2>&1
fi
nice -n 19 python3 -B round4/src/run.py extra3 --seconds 5 > round4/logs/median_extra3.log 2>&1
if [[ -f round4/FOUND.json ]]; then exit 0; fi
if [[ -f round4/STOP_AFTER_QUERY ]]; then exit 0; fi
nice -n 19 python3 -B round4/src/run.py top100 --seconds 600 > round4/logs/top100.log 2>&1
nice -n 19 python3 -B round4/src/run.py report
