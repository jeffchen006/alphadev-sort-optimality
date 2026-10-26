#!/usr/bin/env python3
"""Compare exhaustive sort3 routing results with and without the future-use bound."""
import collections
import json
import os
from pathlib import Path
import re
import resource
import subprocess

resource.setrlimit(resource.RLIMIT_AS,(2800000000,2800000000))
out=Path('logs/future_control3');out.mkdir(exist_ok=True)
records=[]
for fn in sorted(Path('sk/future_control3').glob('*.txt')):
    for cost in [9,10,11,12]:
        pair=[]
        for future in [0,1]:
            env=dict(os.environ,FUTURE=str(future))
            dst=out/f'{fn.stem}_k{cost}_f{future}.log'
            result=subprocess.run(['nice','-n','19','./dagx_future3',str(fn),str(cost),'1','3000000'],
                                  env=env,capture_output=True,text=True,timeout=90)
            dst.write_text(result.stdout+result.stderr)
            match=re.search(r'^RESULT (\w+).*calls=(\d+).*best=(-?\d+)',result.stdout,re.M)
            assert result.returncode==0 and match,(dst,result.returncode)
            pair.append(dict(future=future,status=match[1],calls=int(match[2]),best=int(match[3]),log=str(dst)))
        record=dict(file=str(fn),cost=cost,runs=pair)
        record['same_exhaustive_status']=all(x['status'] in ['NONE','FOUND'] for x in pair) and pair[0]['status']==pair[1]['status']
        records.append(record)
        if not record['same_exhaustive_status']:
            print('CONTROL FAILURE',json.dumps(record),flush=True)
            break
    else:continue
    break
summary=dict(queries=len(records),all_same_exhaustive_status=all(r['same_exhaustive_status'] for r in records),
             baseline_calls=sum(r['runs'][0]['calls'] for r in records),future_calls=sum(r['runs'][1]['calls'] for r in records),
             status_pairs=dict(collections.Counter('/'.join(x['status'] for x in r['runs']) for r in records)),records=records)
(out/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:v for k,v in summary.items() if k!='records'}),flush=True)
