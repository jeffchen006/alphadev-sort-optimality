#!/usr/bin/env bash
set -euo pipefail
cd /path/to/repo/agents/team/codex-fleet/w3
python3 round6/src/audit_sinks.py > round6/logs/sink_transform_audit.log 2>&1
python3 round6/src/data_bound.py round5/classes/p0.s --slots 16 --fix round5/programs/control_suffix22.s --tag data_control16 --timeout 60 > round6/logs/data_control16.log 2>&1
python3 round6/src/data_bound.py round5/classes/p0.s --slots 17 --fix round5/programs/control_scratch_suffix23.s --tag data_scratch_control17 --timeout 60 > round6/logs/data_scratch_control17.log 2>&1
python3 - <<'PY'
from pathlib import Path
p=Path('round5/programs/control_suffix22.s')
Path('round6/programs/repeat_control_suffix23.s').write_text('cmp S0, S2\n'+p.read_text())
PY
python3 round6/src/interleave_sat.py round5/classes/p0.s --slots 23 --comparisons 7 --fix round6/programs/repeat_control_suffix23.s --repeat-flag --tag repeat_control37 --all --history --preserve --scratch --timeout 60 > round6/logs/repeat_control37.log 2>&1
