"""Retry only resource-limited copy-pair tests, sequentially."""
import json
import os
from pathlib import Path
import re
import resource
import subprocess
import time

HERE=Path(__file__).resolve().parent
WORK=HERE.parent
ROOT=HERE.parents[4]
os.chdir(WORK)
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
rows=[dict(re.findall(r'(\w+)=([^\s]+)',line))
      for line in (HERE/'reuse_copy_free_hold.log').read_text().splitlines()
      if line.startswith('RESULT ') and 'status=LIMIT ' in line]
runs=[]
(HERE/'resolve_runs.json').write_text('[]\n')
for row in rows:
    index,test=int(row['index']),int(row['test'])
    stem=f'reuse_resolve_{index}_{test}'
    args=['./round4/reuse','round4/problems.txt',str(index),str(index+1),str(test),
          str(test+1),'30',f'round4/{stem}','31','1','1','1']
    start=time.monotonic()
    with (HERE/f'{stem}.log').open('w') as out,(HERE/f'{stem}.resources').open('w') as err:
        result=subprocess.run(['/usr/bin/time','-v',*args],stdout=out,stderr=err)
    assert result.returncode==0,(stem,result.returncode)
    runs.append({'stem':stem,'args':args})
    (HERE/'resolve_runs.json').write_text(json.dumps(runs,indent=2)+'\n')
    text=(HERE/f'{stem}.log').read_text()
    print(stem,round(time.monotonic()-start,3),text.splitlines()[0],flush=True)
    for source,k in re.findall(r'CANDIDATE file=(\S+) k=(\d+)',text):
        judge=ROOT/'shared/judge.py'
        with (HERE/f'{stem}_judge.log').open('w') as out:
            check=subprocess.run(['python3',str(judge),source,'--strict','--model','out'],stdout=out)
        assert check.returncode==0 and (HERE/f'{stem}_judge.log').read_text().startswith('PASS ')
        memory=HERE/'found_mem.s'
        subprocess.run(['python3','round3/lower.py',source,str(memory)],check=True)
        with (HERE/'found_mem_judge.log').open('w') as out:
            check=subprocess.run(['python3',str(judge),str(memory),'--strict','--model','mem'],stdout=out)
        assert check.returncode==0 and (HERE/'found_mem_judge.log').read_text().startswith('PASS ')
        report=WORK/'RESULTS.md'
        report.write_text(f'FOUND k={k} total={int(k)+10} strict out+mem PASS: {source}, {memory}\n\n'+report.read_text())
        raise SystemExit(0)
print('COMPLETE',len(runs),'limited tests retried',flush=True)
