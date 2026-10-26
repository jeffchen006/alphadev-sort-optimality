"""Check that the partial-column witness restriction is not vacuous."""
import json
import os
from pathlib import Path
import resource
import sys

ROUND = Path(__file__).resolve().parents[1]
BASE = ROUND/'partial'
sys.path.insert(0,str(BASE/'src'))
from controller import run_task, digest, save, read


if __name__ == '__main__':
    assert os.getpriority(os.PRIO_PROCESS,0) == 19
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
    path = BASE/'logs/controls.json'
    controls = json.loads(path.read_text())
    if not any(r['task']['tag']=='negative_partial32' for r in controls):
        seed = BASE/'seeds/c8_108b52d1733c50f9.s'
        task = dict(tag='negative_partial32',seed=str(seed),seed_sha256=digest(seed),
                    registers=read(seed)[1]-1,seconds=120,mode='fixed_program',
                    canonical=True,all_cases=True,force_partial=True,group='control')
        row = run_task(task)
        assert row['status']=='UNSAT' and row['certificate']['verified']
        controls.append(row)
        save(path,controls)
    print('The fixed no-partial k=32 control is checked UNSAT under the partial-witness restriction.')
