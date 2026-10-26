#!/usr/bin/env python3
"""Test the next adaptive free-copy budget after the 18-gate UNSAT result."""
import json,os,resource,subprocess,time
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
resource.setrlimit(resource.RLIMIT_AS,(2900*1024**2,2900*1024**2))
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
driver=ROOT/'round3/logs/extra_driver.log'
while not driver.exists() or 'EXTRA_QUEUE_COMPLETE' not in driver.read_text():time.sleep(10)
if (ROOT/'RESULTS.md').read_text().startswith('FOUND '):
 print('FOLLOWUP_COMPLETE target already found',flush=True);raise SystemExit(0)
registry=ROOT/'round3/logs/judge_registry.json'
oldpass={r['file'] for r in json.loads(registry.read_text()) if r['status']=='PASS'}
tag='freecopy_complete_g19_adaptive';limit=300
args=['--complete','--adaptive','--gates','19','--free-copy','--all','--origin','--free-last']
log=ROOT/'round3/logs'/f'{tag}.log';start=time.monotonic()
env=dict(os.environ);env['W3_ROUND3_SOLVER']='kissat'
with log.open('w') as f:
 q=subprocess.run(['/usr/bin/time','-v','nice','-n','19','python3',str(ROOT/'round3/src/experiments.py'),
  '--tag',tag,'--timeout',str(limit)]+args,stdout=f,stderr=subprocess.STDOUT,env=env)
txt=log.read_text();result=[s for s in txt.splitlines() if '"event": "RESULT"' in s or s.startswith(('JUDGE','MEM_JUDGE','Traceback','ALL_PERMUTATIONS'))]
rss=[int(s.split(':',1)[1]) for s in txt.splitlines() if 'Maximum resident set size (kbytes):' in s]
row=dict(tag=tag,script='experiments.py',args=args,solver='kissat',timeout=limit,rc=q.returncode,result=result,
 max_rss_kib=max(rss,default=0),seconds=round(time.monotonic()-start,3))
with (ROOT/'round3/logs/followup.jsonl').open('a') as f:f.write(json.dumps(row)+'\n')
print(json.dumps(row),flush=True)
subprocess.run(['nice','-n','19','python3',str(ROOT/'round3/src/report.py')],check=True)
newpass=[r for r in json.loads(registry.read_text()) if r['status']=='PASS' and r['file'] not in oldpass]
statuses=[json.loads(s)['status'] for s in result if s.startswith('{')]
lines=['','## Round 3 final free-copy follow-up','',
 'The 18-gate adaptive free-copy model returned UNSATISFIABLE. One follow-up increased that budget to 19 conditional moves.',
 'The follow-up allows free copies, arbitrary history-dependent operand reversal, and 72 third-comparison/residual-tree choices per initial two-comparison history. The prefix implementation is free.',
 f"`{tag}` returned `{', '.join(statuses) or 'ERROR'}` with a {limit}-second solver limit. Total wall time was {row['seconds']:.3f} seconds. Peak process RSS was {row['max_rss_kib']} KiB.",
 'This is a gate-budget relaxation. Any decoded program has its real copy cost assigned and its new value skeleton considered at k=31. Earlier skeletons are skipped.',
 f"The result is recorded in `round3/logs/{tag}.log` and `round3/logs/followup.jsonl`.",'']
if newpass:
 lines += ['Every additional strict PASS file:','',
  '| File | Model | Core k | Comparisons |','| --- | --- | ---: | ---: |']
 for r in newpass:lines.append(f"| `{r['file']}` | {r['model']} | {r['k']} | {r['comparisons']} |")
else:lines += ['No additional strict PASS file was produced.']
lines += ['','A timeout gives no negative bound. The result applies to the stated flag-profile family.']
if not (ROOT/'RESULTS.md').read_text().startswith('FOUND '):lines += ['No program with core k <= 31 passed the strict judge in round 3.']
with (ROOT/'RESULTS.md').open('a') as f:f.write('\n'.join(lines)+'\n')
print('FOLLOWUP_COMPLETE',flush=True)
