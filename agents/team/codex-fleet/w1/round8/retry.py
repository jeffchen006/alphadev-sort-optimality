"""Retry only unresolved tests with the exact prefix/cache encoding."""
import argparse,json,os,resource,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
ap=argparse.ArgumentParser();ap.add_argument('--source',default='exclusive_batch.json')
ap.add_argument('--cpu',type=float,default=120);ap.add_argument('--stem',default='exclusive_retry')
ap.add_argument('--all-cases',action='store_true');a=ap.parse_args()
os.chdir(HERE.parent);os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
if os.getpriority(os.PRIO_PROCESS,0)<19:os.nice(19-os.getpriority(os.PRIO_PROCESS,0))
resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
todo=[row for row in json.loads((HERE/a.source).read_text()) if row['status']=='UNKNOWN'];rows=[]
for row in todo:
 i=row['index'];stem=f'{a.stem}_{i:02d}'
 old=row.get('args',{})
 cmd=[sys.executable,'round8/search.py','--index',str(i),'--mode',old.get('mode','exclusive'),
  '--tail',str(old.get('tail',6)),'--cpu',str(a.cpu),'--stem',stem,'--fast']
 if a.all_cases:cmd.append('--all-cases')
 print('START',i,flush=True)
 with (HERE/(stem+'.log')).open('w') as f:
  proc=subprocess.run(['/usr/bin/time','-v','-o',str(HERE/(stem+'.resources'))]+cmd,stdout=f,stderr=subprocess.STDOUT)
 path=HERE/(stem+'.json')
 res=json.loads(path.read_text()) if proc.returncode==0 and path.exists() else dict(status='UNKNOWN',reason='process exit',returncode=proc.returncode)
 rows.append(dict(index=i,result=stem+'.json',command=cmd,**res))
 (HERE/(a.stem+'_batch.json')).write_text(json.dumps(rows,indent=2)+'\n')
 print('END',i,res['status'],res.get('total_cpu'),flush=True)
 if res['status']=='CANDIDATE':
  with (HERE/(stem+'.verification.log')).open('w') as f:
   checked=subprocess.run([sys.executable,'round8/verify.py',stem+'.s'],stdout=f,stderr=subprocess.STDOUT)
  if checked.returncode==0:
   print('STRICT_PASS',stem,flush=True);break
