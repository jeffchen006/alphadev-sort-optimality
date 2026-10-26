"""Run sequential processes. Keep a durable ledger, including abnormal exits."""
import argparse,json,os,resource,subprocess,sys,time
from pathlib import Path
HERE=Path(__file__).resolve().parent
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--mode',choices=['exclusive','tail','cone'],default='exclusive')
 ap.add_argument('--tail',type=int,default=6);ap.add_argument('--cpu',type=float,default=45)
 ap.add_argument('--start',type=int,default=0);ap.add_argument('--end',type=int,default=62)
 ap.add_argument('--extra',type=int,default=2);ap.add_argument('--all-cases',action='store_true')
 ap.add_argument('--control',action='store_true')
 ap.add_argument('--fast',action='store_true')
 ap.add_argument('--unbounded',action='store_true')
 ap.add_argument('--stem',required=True);a=ap.parse_args()
 os.chdir(HERE.parent);os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
 if os.getpriority(os.PRIO_PROCESS,0)<19:os.nice(19-os.getpriority(os.PRIO_PROCESS,0))
 resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
 rows=[]
 for i in range(a.start,a.end):
  stem=f'{a.stem}_{i:02d}';cmd=[sys.executable,'round8/search.py','--index',str(i),
   '--mode',a.mode,'--tail',str(a.tail),'--cpu',str(a.cpu),'--extra',str(a.extra),'--stem',stem]
  if a.all_cases:cmd.append('--all-cases')
  if a.control:cmd.append('--control')
  if a.fast:cmd.append('--fast')
  if a.unbounded:cmd.append('--unbounded')
  print('START',i,flush=True)
  with (HERE/(stem+'.log')).open('w') as f:
   proc=subprocess.run(['/usr/bin/time','-v','-o',str(HERE/(stem+'.resources'))]+cmd,stdout=f,stderr=subprocess.STDOUT)
  path=HERE/(stem+'.json')
  res=json.loads(path.read_text()) if proc.returncode==0 and path.exists() else dict(status='UNKNOWN',reason='process exit',returncode=proc.returncode)
  rows.append(dict(index=i,result=stem+'.json',command=cmd,**res))
  (HERE/(a.stem+'_batch.json')).write_text(json.dumps(rows,indent=2)+'\n')
  print('END',i,res['status'],res.get('total_cpu'),flush=True)
  if res['status']=='CANDIDATE' and not a.control:
   with (HERE/(stem+'.verification.log')).open('w') as f:
    checked=subprocess.run([sys.executable,'round8/verify.py',stem+'.s'],stdout=f,stderr=subprocess.STDOUT)
   if checked.returncode==0:
    print('STRICT_PASS',stem,flush=True);return
if __name__=='__main__':main()
