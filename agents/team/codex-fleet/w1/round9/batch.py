"""Run one process at a time and preserve every final status."""
import argparse,json,os,resource,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
def main():
 ap=argparse.ArgumentParser()
 ap.add_argument('--kind',choices=['c9','c8'],required=True)
 ap.add_argument('--mode',choices=['exclusive','tail','cone','schedule'],required=True)
 ap.add_argument('--tail',type=int,default=6);ap.add_argument('--cpu',type=float,default=30)
 ap.add_argument('--schedule-scope',choices=['exclusive','tail','cone'],default='tail')
 ap.add_argument('--start',type=int,default=0);ap.add_argument('--end',type=int,default=100000)
 ap.add_argument('--extra',type=int,default=2);ap.add_argument('--unbounded',action='store_true')
 ap.add_argument('--control',action='store_true');ap.add_argument('--all-cases',action='store_true')
 ap.add_argument('--stem',required=True);a=ap.parse_args()
 os.chdir(HERE.parent);os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
 if os.getpriority(os.PRIO_PROCESS,0)<19:os.nice(19-os.getpriority(os.PRIO_PROCESS,0))
 resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
 rows=[]
 for i,b in enumerate(json.loads((HERE/'bases.json').read_text())):
  if b['kind']!=a.kind or not a.start<=b['id']<a.end:continue
  stem=f'{a.stem}_{b["id"]:02d}'
  cmd=[sys.executable,'round9/search.py','--index',str(i),'--mode',a.mode,'--tail',str(a.tail),
   '--cpu',str(a.cpu),'--extra',str(a.extra),'--stem',stem,'--schedule-scope',a.schedule_scope]
  for flag in ('unbounded','control','all_cases'):
   if getattr(a,flag):cmd.append('--'+flag.replace('_','-'))
  print('START',b['key'],flush=True)
  with (HERE/(stem+'.log')).open('w') as f:
   p=subprocess.run(['/usr/bin/time','-v','-o',str(HERE/(stem+'.resources'))]+cmd,stdout=f,stderr=subprocess.STDOUT)
  path=HERE/(stem+'.json')
  res=json.loads(path.read_text()) if p.returncode==0 and path.exists() else dict(status='UNKNOWN',reason='process exit',returncode=p.returncode)
  rows.append(dict(index=i,result=stem+'.json',command=cmd,**res))
  (HERE/(a.stem+'_batch.json')).write_text(json.dumps(rows,indent=2)+'\n')
  print('DONE',b['key'],res['status'],res.get('total_cpu'),flush=True)
  if res['status']=='CANDIDATE':
   with (HERE/(stem+'.verify.log')).open('w') as f:
    q=subprocess.run([sys.executable,'round9/verify.py',stem+'.s'],stdout=f,stderr=subprocess.STDOUT)
   if q.returncode:print('STRICT_REJECTED',stem,flush=True)
if __name__=='__main__':main()
