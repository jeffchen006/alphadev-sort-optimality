#!/usr/bin/env python3
"""Conditional scratch initialization experiments; one CPU job at a time."""
import json,subprocess,time
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2];start=time.monotonic()
def run(tag,args):
 log=ROOT/'round2/logs'/f'{tag}.log'
 with log.open('w') as f:q=subprocess.run(['nice','-n','19','python3',str(ROOT/'round2/src/register_sat.py'),'--tag',tag,'--partial-init']+args,stdout=f,stderr=subprocess.STDOUT,cwd=ROOT)
 txt=log.read_text();res=[s for s in txt.splitlines() if '"event": "RESULT"' in s or s.startswith(('JUDGE','Traceback'))]
 print(json.dumps(dict(tag=tag,rc=q.returncode,result=res,elapsed=round(time.monotonic()-start,2))),flush=True)
 return txt
s=run('partial_control53',['--control','--phasecap','1','--timeout','60'])
if 'JUDGE PASS ' not in s:raise SystemExit('Partial initialization control failed')
for n,(profile,mask,adapt) in enumerate([
 ('3,3,6,3,3,3,3',0,False),('4,4,6,3,3,2,2',10,True),
]):
 run(f'partial_profile_{n}',['--registers','8','--profile',profile,'--tree','5','--mask',str(mask),'--timeout','60']+(['--adaptive'] if adapt else []))
run('partial_flex_R8',['--registers','8','--phasecap','8','--tree','5','--mask','6','--adaptive','--timeout','120'])
with (ROOT/'round2/logs/retry_routes_1.jsonl').open('w') as f:
 subprocess.run(['nice','-n','19','python3',str(ROOT/'round2/src/retry_routes.py'),'1'],stdout=f,stderr=subprocess.STDOUT,cwd=ROOT)
