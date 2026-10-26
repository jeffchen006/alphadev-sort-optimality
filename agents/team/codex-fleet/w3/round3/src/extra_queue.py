#!/usr/bin/env python3
"""Further one-select profiles, after the eleven extensions finish."""
import json, os, resource, subprocess, time
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
resource.setrlimit(resource.RLIMIT_AS,(2900*1024**2,2900*1024**2))
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
cases=[
 ('control_routing53',[],60),
 ('control_cadical53',['--control','--exact'],60),
 ('retry_fixed_t5_cadical',['--exact'],300),
 ('retry_flex_R6_cadical',['--registers','6','--tree','5','--mask','0','--phasecap','8'],300),
 ('complete_one_select_g18',['--complete','--adaptive','--adaptive-prefix','--gates','18'],300),
 ('freecopy_complete_g18_fixed',['--complete','--gates','18','--free-copy'],300),
 ('freecopy_complete_g18_adaptive',['--complete','--adaptive','--gates','18','--free-copy'],300),
 ('control_free_finished53',['--control','--partial-init','--phasecap','1'],60),
 ('partial_free_finished_R8',['--registers','8','--tree','5','--mask','6','--adaptive','--phasecap','8','--partial-init'],300),
 ('control_robust_finished53',['--control','--partial-init','--phasecap','1'],60),
 ('partial_robust_finished_R8',['--registers','8','--tree','5','--mask','6','--adaptive','--phasecap','8','--partial-init'],300),
]
for tag,args,limit in cases:
 if (ROOT/'RESULTS.md').read_text().startswith('FOUND '):break
 log=ROOT/'round3/logs'/f'{tag}.log';start=time.monotonic()
 routing=tag=='control_routing53'
 robust=tag in ('control_robust_finished53','partial_robust_finished_R8')
 cadical=tag in ('control_cadical53','retry_fixed_t5_cadical','retry_flex_R6_cadical')
 physical=robust or tag in ('control_free_finished53','partial_free_finished_R8','retry_flex_R6_cadical')
 script='route_candidate.py' if routing else 'register_sat.py' if tag=='retry_flex_R6_cadical' else 'register_sat_robust.py' if robust else 'register_sat_free.py' if physical else 'experiments.py'
 common=[] if physical or routing else ['--all','--origin']+([] if cadical else ['--free-last'])
 env=dict(os.environ);env['W3_ROUND3_SOLVER']='cadical' if cadical else 'kissat'
 with log.open('w') as f:
  q=subprocess.run(['/usr/bin/time','-v','nice','-n','19','python3',
   str(ROOT/'round3/src'/script),'--tag',tag,'--timeout',str(limit)]+common+args,stdout=f,stderr=subprocess.STDOUT,env=env)
 txt=log.read_text();result=[s for s in txt.splitlines() if '"event": "RESULT"' in s or s.startswith(('JUDGE','MEM_JUDGE','Traceback','ALL_PERMUTATIONS'))]
 rss=[int(s.split(':',1)[1]) for s in txt.splitlines() if 'Maximum resident set size (kbytes):' in s]
 row=dict(tag=tag,script=script,args=args,solver='cadical' if cadical else 'none' if routing else 'kissat',timeout=limit,rc=q.returncode,result=result,max_rss_kib=max(rss,default=0),seconds=round(time.monotonic()-start,3))
 with (ROOT/'round3/logs/extra.jsonl').open('a') as f:f.write(json.dumps(row)+'\n')
 print(json.dumps(row),flush=True)
 if tag.startswith('control_') and 'JUDGE PASS ' not in txt:raise SystemExit('Free-finished control failed')
q=subprocess.run(['nice','-n','19','python3',str(ROOT/'round3/src/report.py'),'--append'])
if q.returncode:raise SystemExit('Final report failed')
print(json.dumps(dict(event='EXTRA_QUEUE_COMPLETE')),flush=True)
