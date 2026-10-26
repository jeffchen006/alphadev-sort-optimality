"""Independent sort3 boundary controls for both router implementations."""
import json
import os
from pathlib import Path
import re
import resource
import subprocess
import time

ROOT=Path('/path/to/repo')
resource.setrlimit(resource.RLIMIT_AS,(2800*1024*1024,)*2)
os.environ.update(ROOTORDER='0',CHECKLB='1',CHECKCPL='1')
sk=Path('round10/artifacts/sort3_control.txt')
# Sort three wires by compare-exchanges (0,1), (1,2), (0,1).
sk.write_text('0:1;1:0\n0|1:2;2:0|1\n01:02|12;02|12:01\n')
rows=[]
for engine in ['fast','safe']:
    for k in [11,10]:
        log=Path(f'round10/logs/sort3_{engine}_k{k}.log')
        cmd=[f'round10/bin/dagx_{engine}_n3',str(sk),str(k),'64' if k==11 else '1']
        t=time.monotonic()
        with log.open('w') as f:p=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,timeout=60)
        txt=log.read_text();expected='FOUND' if k==11 else 'NONE'
        assert p.returncode==0 and f'RESULT {expected}' in txt,txt
        row=dict(engine=engine,k=k,result=expected,log=str(log),wall_seconds=time.monotonic()-t)
        if k==11:
            row['strict_candidates']=[]
            for i,body in enumerate(re.findall(r'SOLUTION[^\n]*\n(.*?)\nEND',txt,re.S)):
                fn=Path(f'round10/candidates/sort3_{engine}_control_{i}_out.s')
                fn.write_text('# n=3 model=out iset=I1\n'+body+'\n')
                jl=Path(f'round10/logs/sort3_{engine}_control_{i}_out_judge.log')
                with jl.open('w') as f:j=subprocess.run(['python3',str(ROOT/'shared/judge.py'),str(fn),'--strict','--model','out'],stdout=f,stderr=subprocess.STDOUT)
                passed=j.returncode==0 and 'PASS' in jl.read_text()
                row['strict_candidates'].append({'file':str(fn),'log':str(jl),'result':'PASS' if passed else 'FAIL'})
                if passed:break
            # A permutation-only routing candidate can fail on ties. A failed
            # strict check is recorded; it does not invalidate strict-order NONE.
        rows.append(row)
        print(engine,k,expected,round(row['wall_seconds'],3),flush=True)
        Path('round10/artifacts/small_controls.json').write_text(json.dumps(rows,indent=2))
