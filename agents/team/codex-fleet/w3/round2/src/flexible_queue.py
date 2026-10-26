#!/usr/bin/env python3
import json,subprocess,time
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
start=time.monotonic()
def run(tag,args):
 log=ROOT/'round2/logs'/f'{tag}.log'
 with log.open('w') as f:q=subprocess.run(['nice','-n','19','python3',str(ROOT/'round2/src/register_sat.py'),'--tag',tag]+args,stdout=f,stderr=subprocess.STDOUT,cwd=ROOT)
 text=log.read_text();result=[s for s in text.splitlines() if '"event": "RESULT"' in s or s.startswith(('JUDGE','Traceback'))]
 print(json.dumps(dict(tag=tag,rc=q.returncode,result=result,elapsed=round(time.monotonic()-start,2))),flush=True)
 return text
# Let the solver select the schedule. At most eight data operations follow a cmp.
for R,mask,adaptive in [(6,0,False),(8,10,True)]:
 tag=f"flex_R{R}_m{mask}_{'adapt' if adaptive else 'fixed'}"
 run(tag,['--registers',str(R),'--tree','5','--mask',str(mask),'--phasecap','8','--timeout','150']+(['--adaptive'] if adaptive else []))
# Permit more prefix operations than the first fixed-profile pass did.
for n,(prof,R,mask,adaptive) in enumerate([
 ('3,3,6,3,3,3,3',6,0,False),('3,3,6,3,3,3,3',8,10,False),
 ('3,4,6,3,3,3,2',7,6,False),('4,4,5,3,3,3,2',8,8,False),
 ('4,4,6,3,3,2,2',9,12,False),('4,4,6,3,3,2,2',9,0,True),
 ('4,4,5,3,3,3,2',8,10,True),('3,4,6,3,3,3,2',8,6,True),
]):
 run(f'prefix_heavy_{n}',['--registers',str(R),'--profile',prof,'--mask',str(mask),'--tree',str(n%6),'--timeout','60']+(['--adaptive'] if adaptive else []))
