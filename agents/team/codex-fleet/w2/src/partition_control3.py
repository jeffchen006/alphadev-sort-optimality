#!/usr/bin/env python3
"""Compare partition and unique-column modes with completed baseline controls."""
import collections,json,os,re,resource,subprocess
from pathlib import Path
resource.setrlimit(resource.RLIMIT_AS,(2800000000,2800000000))
out=Path('logs/partition_control3');out.mkdir(exist_ok=True)
records=[]
configs=[(0,0,0),(0,1,0),(0,1,1),(1,0,0),(1,1,0),(1,1,1)]
for fn in sorted(Path('sk/future_control3').glob('*.txt')):
 for cost in [11,12]:
  baseline=(Path('logs/future_control3')/f'{fn.stem}_k{cost}_f0.log').read_text()
  expected=re.search(r'^RESULT (\w+)',baseline,re.M)[1]
  for order,pool,unique in configs:
   env=dict(os.environ,ROOTORDER=str(order),POOLPART=str(pool),UNIQUE=str(unique))
   dst=out/f'{fn.stem}_k{cost}_o{order}_p{pool}_u{unique}.log'
   result=subprocess.run(['nice','-n','19','./dagx_partition3',str(fn),str(cost),'1','3000000'],env=env,capture_output=True,text=True,timeout=90)
   dst.write_text(result.stdout+result.stderr)
   m=re.search(r'^RESULT (\w+).*calls=(\d+)',result.stdout,re.M)
   assert result.returncode==0 and m,(dst,result.returncode)
   r=dict(file=str(fn),cost=cost,order=order,pool=pool,unique=unique,expected=expected,status=m[1],calls=int(m[2]),log=str(dst))
   r['same_exhaustive_status']=m[1] in ['NONE','FOUND'] and m[1]==expected
   records.append(r)
   if not r['same_exhaustive_status']:
    (out/'failure.json').write_text(json.dumps(r,indent=2)+'\n');print('CONTROL FAILURE',json.dumps(r),flush=True);raise SystemExit(1)
summary=dict(queries=len(records),all_same_exhaustive_status=all(r['same_exhaustive_status'] for r in records),calls_by_mode={f'o{o}_p{p}_u{u}':sum(r['calls'] for r in records if (r['order'],r['pool'],r['unique'])==(o,p,u)) for o,p,u in configs},records=records)
(out/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({k:v for k,v in summary.items() if k!='records'}),flush=True)
