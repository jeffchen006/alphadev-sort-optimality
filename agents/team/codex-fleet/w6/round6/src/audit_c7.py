from pathlib import Path
import subprocess,json,collections,hashlib
root=Path.cwd().parents[3];rows=[]
for name in ('c7_fixed_t4','c7_fixed_t10'):
 p=Path('round6/candidates',name+'_near.s');log=Path('round6/logs',name+'_near_judge.log')
 with log.open('w') as f:rc=subprocess.run(['nice','-n','19','python3','-B',str(root/'shared/judge.py'),str(p),'--strict','--model','out'],stdout=f,stderr=subprocess.STDOUT).returncode
 text=p.read_text();counts=collections.Counter(l.split()[0] for l in text.splitlines() if l.strip() and not l.startswith('#'))
 assert counts['cmp']==7
 assert log.read_text().startswith('FAIL ')
 rows.append(dict(file=str(p),header=text.splitlines()[0],counts=dict(counts),result='FAIL',judge=str(log),exit=rc,sha256=hashlib.sha256(p.read_bytes()).hexdigest()))
Path('round6/artifacts/c7_near_judges.json').write_text(json.dumps(rows,indent=2));print(json.dumps(rows,indent=2))
