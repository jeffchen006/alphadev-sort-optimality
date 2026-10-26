"""Validate the duplicate-minimum repair with one additional instruction."""
import json
from pathlib import Path
import re
import subprocess
import sys
ROOT = Path(__file__).resolve().parents[6]
sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'src'))
from window_sat import read,concrete,GOALS
from satrep import emit
p,nr = read('round2/candidates/near14_frozen.s')
p.insert(15,(0,2,1))
cols,_ = concrete(p,nr-1)
witnesses = [next((t,r) for t,r,col in cols if col == goal) for goal in GOALS]
out = Path('round3/verified/duplicate_min_control32.s')
emit(p,witnesses,out)
mem = Path('round3/verified_mem/duplicate_min_control32.s')
lines = [f'mov S{i}, P{i}' for i in range(5)]
for line in out.read_text().splitlines():
    if not line or line.startswith('#'):
        continue
    line = re.sub(r'S(\d+)',lambda m:f'S{int(m[1])+5}',line)
    line = re.sub(r'P(\d+)',lambda m:f'S{m[1]}',line)
    if line.startswith('out '):
        j,r = line[4:].replace(',','').split()
        line = f'mov P{j}, {r}'
    lines.append(line)
mem.write_text('# n=5 model=mem iset=I1 core=32 L=42\n'+'\n'.join(lines)+'\n')
results = []
for path,model in ((out,'out'),(mem,'mem')):
    log = Path('round3/logs')/f'duplicate_min_control32_{model}_judge.log'
    with log.open('w') as f:
        result = subprocess.run(['nice','-n','19','python3','-B',str(ROOT/'shared/judge.py'),
            str(path),'--strict','--model',model],stdout=f,stderr=subprocess.STDOUT)
    ok = result.returncode == 0 and 'PASS ' in log.read_text()
    assert ok,log.read_text()
    results.append({'path':str(path),'model':model,'pass':ok,'log':str(log)})
Path('round3/artifacts/duplicate_min_control_ledger.json').write_text(json.dumps(results,indent=2))
print(json.dumps(results),flush=True)
