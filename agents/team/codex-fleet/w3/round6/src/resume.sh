#!/usr/bin/env bash
set -euo pipefail
cd /path/to/repo/agents/team/codex-fleet/w3
python3 round6/src/queue.py --family retry --timeout 1200 >> round6/logs/retry_driver.log 2>&1
python3 round6/src/queue.py --family seven --classes 0 1 --timeout 1200 > round6/logs/seven_driver.log 2>&1
python3 round6/src/queue.py --family repeat --classes 0 1 --timeout 1200 > round6/logs/repeat_driver.log 2>&1
python3 round6/src/finalize.py --append > round6/logs/finalize.log 2>&1
