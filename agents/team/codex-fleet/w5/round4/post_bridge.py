"""One CPU after the bridge walk: SAT variants, structure audit, and judges."""
from pathlib import Path
import json,subprocess,sys
from verify import verify
HERE=Path(__file__).resolve().parent
for path in sorted((HERE/'candidates').glob('bridge_found_k*.s')):
    if verify(path):
        raise SystemExit(0)
for script in ['dest_batch.py','structures.py']:
    with (HERE/'logs'/f'{Path(script).stem}.log').open('w') as f:
        subprocess.run(['nice','-n','19',sys.executable,'-B',str(HERE/script)],stdout=f,stderr=subprocess.STDOUT,check=True)
paths=sorted((HERE/'candidates').glob('bridge*.s'))
for i,path in enumerate(paths):
    assert verify(path),path
    if i%20==0:print(json.dumps(dict(step='judge_bridge',done=i+1,total=len(paths))),flush=True)
(HERE/'bridge_judges_done.json').write_text(json.dumps(dict(files=len(paths),both_models=True))+'\n')
