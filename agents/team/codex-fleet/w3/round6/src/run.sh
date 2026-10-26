#!/usr/bin/env bash
set -euo pipefail
cd /path/to/repo/agents/team/codex-fleet/w3
bash round6/src/controls.sh
rg -q '"status": "PASS"' round6/logs/sink_transform_audit.log
rg -q 'INDEPENDENT_DATA_CIRCUIT_CHECK PASS' round6/logs/data_control16.log
rg -q 'INDEPENDENT_DATA_CIRCUIT_CHECK PASS' round6/logs/data_scratch_control17.log
rg -q 'STRICT_PASS 37' round6/logs/repeat_control37.log
python3 round6/src/gate_bound.py round5/classes/p37.s --gates 9 --tag class21_gate9_sinks --solver kissat --timeout 1200 --proof --sink-outputs > round6/logs/class21_gate9_sinks.log 2>&1
if rg -q 's VERIFIED' round6/logs/class21_gate9_sinks.drat_check 2>/dev/null; then
  python3 round6/src/gate_bound.py round5/classes/p37.s --gates 10 --tag class21_gate10_sinks --solver kissat --timeout 1200 --proof --sink-outputs > round6/logs/class21_gate10_sinks.log 2>&1
fi
python3 round6/src/data_bound.py round5/classes/p37.s --slots 13 --minimum-gates 9 --tag class21_data13 --timeout 1200 --proof > round6/logs/class21_data13.log 2>&1
python3 round6/src/queue.py --family retry --timeout 1200 > round6/logs/retry_driver.log 2>&1
python3 round6/src/queue.py --family seven --classes 0 1 --timeout 1200 > round6/logs/seven_driver.log 2>&1
python3 round6/src/queue.py --family repeat --classes 0 1 --timeout 1200 > round6/logs/repeat_driver.log 2>&1
python3 round6/src/finalize.py --append > round6/logs/finalize.log 2>&1
