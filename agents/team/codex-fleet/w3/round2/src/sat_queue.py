#!/usr/bin/env python3
"""One SAT job at a time. Run alongside one routing job."""
import json,subprocess,time
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
start=time.monotonic()
def run(script,tag,args):
 log=ROOT/'round2/logs'/f'{tag}.log'
 cmd=['nice','-n','19','python3',str(ROOT/'round2/src'/script),'--tag',tag]+args
 with log.open('w') as f:p=subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,cwd=ROOT)
 txt=log.read_text()
 result=[s for s in txt.splitlines() if '"event": "RESULT"' in s or s.startswith(('JUDGE','Traceback','ALL_PERMUTATIONS'))]
 print(json.dumps(dict(tag=tag,rc=p.returncode,result=result,elapsed=round(time.monotonic()-start,2))),flush=True)
 return txt,p.returncode
s,rc=run('register_sat.py','physical_control53',['--control','--timeout','60'])
if rc or 'PASS ' not in s:raise SystemExit('Physical encoding control failed')
run('experiments.py','complete_fixed_mv5',['--complete','--all','--origin','--movbound','5','--timeout','240'])
for R,profile,tree,mask,adaptive in [
 (6,'3,3,4,4,4,3,3',5,0,False),
 (7,'3,3,5,4,3,3,3',1,0,False),
 (8,'3,3,5,4,3,3,3',5,10,False),
 (7,'4,3,5,3,3,3,3',5,0,True),
 (8,'4,3,5,3,3,3,3',1,6,True),
 (9,'4,4,4,3,3,3,3',5,12,True),
]:
 tag=f"physical_R{R}_t{tree}_m{mask}_{'adapt' if adaptive else 'fixed'}"
 run('register_sat.py',tag,['--registers',str(R),'--profile',profile,'--tree',str(tree),'--mask',str(mask),'--timeout','120']+(['--adaptive'] if adaptive else []))
run('experiments.py','complete_adaptive_mv5',['--complete','--adaptive','--all','--origin','--movbound','5','--timeout','240'])
for g in [22,20,19]:
 run('experiments.py',f'adaptive_extra_select_g{g}',['--adaptive','--adaptive-prefix','--union','--origin','--all','--free-last','--gates',str(g),'--timeout','120'])
