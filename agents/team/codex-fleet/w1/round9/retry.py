"""Retry only unresolved tests. Keep all accumulated failed input orders."""
import argparse,json,os,resource,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent
def main():
 ap=argparse.ArgumentParser();ap.add_argument('--source',required=True);ap.add_argument('--stem',required=True)
 ap.add_argument('--cpu',type=float,default=60);ap.add_argument('--all-cases',action='store_true');a=ap.parse_args()
 os.chdir(HERE.parent);os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
 if os.getpriority(os.PRIO_PROCESS,0)<19:os.nice(19-os.getpriority(os.PRIO_PROCESS,0))
 resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
 rows=[]
 for old in json.loads((HERE/(a.source+'_batch.json')).read_text()):
  if old['status']!='UNKNOWN':continue
  cmd=list(old['command']);stem=a.stem+'_'+old['key'];cmd[cmd.index('--stem')+1]=stem
  cmd[cmd.index('--cpu')+1]=str(a.cpu)
  if a.all_cases and '--all-cases' not in cmd:cmd.append('--all-cases')
  if (HERE/old['result']).exists():cmd+=['--resume-json',old['result']]
  print('START',old['key'],flush=True)
  with (HERE/(stem+'.log')).open('w') as f:
   p=subprocess.run(['/usr/bin/time','-v','-o',str(HERE/(stem+'.resources'))]+cmd,stdout=f,stderr=subprocess.STDOUT)
  path=HERE/(stem+'.json')
  res=json.loads(path.read_text()) if p.returncode==0 and path.exists() else dict(status='UNKNOWN',reason='process exit',returncode=p.returncode)
  rows.append(dict(index=old['index'],result=stem+'.json',command=cmd,**res))
  (HERE/(a.stem+'_batch.json')).write_text(json.dumps(rows,indent=2)+'\n')
  print('DONE',old['key'],res['status'],res.get('total_cpu'),flush=True)
  if res['status']=='CANDIDATE':
   with (HERE/(stem+'.verify.log')).open('w') as f:
    subprocess.run([sys.executable,'round9/verify.py',stem+'.s'],stdout=f,stderr=subprocess.STDOUT,check=True)
if __name__=='__main__':main()
