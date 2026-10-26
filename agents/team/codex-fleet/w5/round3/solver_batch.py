"""Run one CPU solver job at a time. The other CPU has the three-edit query."""
from pathlib import Path
import json
import resource
import subprocess
import sys
import time

from verify import verify

HERE = Path(__file__).resolve().parent
NEAR = HERE.parent.parent/'w6/round2/candidates'
JOBS = [
    ('near14_sources_all', 'near14_frozen', 180, ['--mode', 'sources', '--changes', '-1']),
    ('near14_suffix4', 'near14_frozen', 180, ['--changes', '4', '--prefix', '15', '--fixed-outs']),
    ('near14_classes4', 'near14_frozen', 180, ['--mode', 'classes', '--changes', '4']),
    ('near30_general3', 'b31a_near', 300, ['--changes', '3']),
    ('near14_general4', 'near14_frozen', 300, ['--changes', '4']),
]

rows = []
for name, seed, cap, options in JOBS:
    output = HERE/'candidates'/f'{name}.s'
    log = HERE/'logs'/f'{name}.log'
    cmd = ['nice', '-n', '19', sys.executable, '-B', str(HERE/'repair_sat.py'),
           str(NEAR/(seed+'.s')), str(output)] + options
    start = time.monotonic()
    status = 'UNKNOWN'
    code = None
    with log.open('w') as stream:
        try:
            code = subprocess.run(cmd, stdout=stream, stderr=subprocess.STDOUT,
                                  timeout=cap).returncode
        except subprocess.TimeoutExpired:
            status = 'TIMEOUT'
    if code == 0:
        for line in log.read_text().splitlines():
            try:
                item = json.loads(line)
            except json.JSONDecodeError:
                continue
            if 'status' in item:
                status = item['status']
    row = dict(name=name, command=cmd, cap=cap, code=code, status=status,
               seconds=time.monotonic()-start, log=str(log))
    if status == 'CANDIDATE':
        row['judge_pass'] = verify(output)
    rows.append(row)
    print(json.dumps(row), flush=True)
    (HERE/'solver_batch.json').write_text(json.dumps(rows, indent=2)+'\n')
    if row.get('judge_pass') and len([s for s in output.read_text().splitlines()
                                    if s and not s.startswith(('#', 'out'))]) <= 31:
        break
