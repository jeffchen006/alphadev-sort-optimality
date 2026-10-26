"""Run the remaining checks and broader families, one CPU job at a time."""
import json,os,resource,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;WORK=HERE.parent
os.chdir(WORK);os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
if os.getpriority(os.PRIO_PROCESS,0)<19:os.nice(19-os.getpriority(os.PRIO_PROCESS,0))
resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
jobs=[('audit',[sys.executable,'round8/audit.py']),
 ('audit_registers',[sys.executable,'round8/audit_registers.py']),
 ('symmetry',[sys.executable,'round8/symmetry.py']),
 ('unbounded_batch',[sys.executable,'round8/batch.py','--mode','exclusive','--unbounded','--fast','--cpu','8','--stem','unbounded']),
 ('tail6_batch',[sys.executable,'round8/batch.py','--mode','tail','--tail','6','--fast','--cpu','12','--stem','tail6']),
 ('cone_batch',[sys.executable,'round8/batch.py','--mode','cone','--fast','--cpu','10','--stem','cone']),
 ('finish',[sys.executable,'round8/finish.py'])]
for stem,cmd in jobs:
 print('PHASE',stem,flush=True)
 with (HERE/(stem+'.log')).open('w') as f:
  subprocess.run(['/usr/bin/time','-v','-o',str(HERE/(stem+'.resources'))]+cmd,stdout=f,stderr=subprocess.STDOUT,check=True)
 print('DONE',stem,flush=True)
 ledger=json.loads((HERE/'pass_ledger.json').read_text())
 short=[r for r in ledger if r['result']=='PASS' and r['model']=='out' and sum(1 for ln in Path(r['path']).read_text().splitlines() if ln and not ln.startswith(('#','out ')))<=31]
 if short:print('FOUND',short,flush=True);break
