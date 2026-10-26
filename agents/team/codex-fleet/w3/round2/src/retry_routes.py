#!/usr/bin/env python3
"""Extend only unresolved new round-2 skeletons; use one CPU worker."""
import json,subprocess,sys,time
from pathlib import Path
from candidate import check
ROOT=Path(__file__).resolve().parents[2]
mode=int(sys.argv[1]) if len(sys.argv)>1 else 0
jobs=[]
for line in (ROOT/'round2/logs/route_batch.jsonl').read_text().splitlines():
    r=json.loads(line)
    if 'RESULT LIMIT ' in r.get('result',''):jobs.append(ROOT/r['file'])
jobs=jobs[mode::2];start=time.monotonic()
print(json.dumps(dict(event='RETRIES',partition=mode,jobs=len(jobs),calls=2000000)),flush=True)
for fn in jobs:
    log=ROOT/'round2/logs'/f'{fn.stem}.retry'
    with log.open('w') as f:q=subprocess.run(['nice','-n','19','timeout','20',str(ROOT/'src/dagx'),str(fn),'31','1','2000000'],stdout=f,stderr=subprocess.STDOUT)
    rows=log.read_text().splitlines();result=rows[-1] if rows else 'EMPTY'
    print(json.dumps(dict(file=str(fn.relative_to(ROOT)),rc=q.returncode,result=result,elapsed=round(time.monotonic()-start,2))),flush=True)
    if 'RESULT FOUND ' in result:
        asm=[s for s in rows if s.startswith(('mov ','cmp ','cmovl ','cmovle ','cmovg ','cmovge ','out '))]
        path=ROOT/'round2/programs'/f'{fn.stem}_retry.s'
        path.write_text('# n=5 R=100 iset=I1 model=out source=w3_round2_routing\n'+'\n'.join(asm)+'\n')
        check(path)
