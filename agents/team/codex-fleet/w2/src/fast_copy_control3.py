#!/usr/bin/env python3
"""Check root-order changes against prior exhaustive sort3 controls."""
import json
import os
from pathlib import Path
import re
import resource
import subprocess
resource.setrlimit(resource.RLIMIT_AS,(2800000000,2800000000))
out=Path('logs/fast_copy_control3');out.mkdir(exist_ok=True)
records=[]
for fn in sorted(Path('sk/future_control3').glob('*.txt')):
    for cost in [9,10,11,12]:
        baseline=(Path('logs/future_control3')/f'{fn.stem}_k{cost}_f0.log').read_text()
        expected=re.search(r'^RESULT (\w+)',baseline,re.M)[1]
        for order in [0,1]:
            env=dict(os.environ,ROOTORDER=str(order),CHECKCPL="1",LEGACYFILL="1")
            dst=out/f'{fn.stem}_k{cost}_o{order}.log'
            result=subprocess.run(['nice','-n','19','./dagx_fast3',str(fn),str(cost),'1','3000000'],
                                  env=env,capture_output=True,text=True,timeout=90)
            dst.write_text(result.stdout+result.stderr)
            match=re.search(r'^RESULT (\w+).*calls=(\d+)',result.stdout,re.M)
            assert result.returncode==0 and match,(dst,result.returncode)
            record=dict(file=str(fn),cost=cost,order=order,expected=expected,status=match[1],calls=int(match[2]),log=str(dst))
            record['same_exhaustive_status']=record['status'] in ['NONE','FOUND'] and record['status']==expected
            records.append(record)
            if not record['same_exhaustive_status']:
                (out/'failure.json').write_text(json.dumps(record,indent=2)+'\n')
                print('CONTROL FAILURE',json.dumps(record),flush=True)
                raise SystemExit(1)
summary=dict(queries=len(records),all_same_exhaustive_status=all(r['same_exhaustive_status'] for r in records),
             calls_by_order={str(o):sum(r['calls'] for r in records if r['order']==o) for o in [0,1]},records=records)
(out/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:v for k,v in summary.items() if k!='records'}),flush=True)
