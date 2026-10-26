#!/usr/bin/env python3
import argparse,json,subprocess,time,re,resource,concurrent.futures
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('manifest');p.add_argument('--tag',required=True);p.add_argument('--jobs',type=int,default=1);p.add_argument('--conflicts',type=int,default=20000);p.add_argument('--seconds',type=int,default=45);a=p.parse_args()
out=Path('logs')/a.tag;out.mkdir(exist_ok=True)
def limits():resource.setrlimit(resource.RLIMIT_AS,(3*1024**3,3*1024**3))
def run(row):
 src=Path(row['file']);ident=src.parent.name+'_'+src.stem;prog=Path('programs')/(a.tag+'_'+ident+'.s');start=time.monotonic()
 cmd=['nice','-n','10','python3','src/pool_sat.py',str(src),'31',str(prog),'--conflicts',str(a.conflicts),'--verify']
 try:
  r=subprocess.run(cmd,capture_output=True,text=True,timeout=a.seconds,preexec_fn=limits);text=r.stdout+r.stderr
 except subprocess.TimeoutExpired as e:text=(e.stdout or b'').decode()+(e.stderr or b'').decode()+'\nRESULT TIMEOUT\n'
 log=out/(ident+'.log');log.write_text(text);status=re.findall(r'^RESULT (\w+)',text,re.M)
 return dict(file=str(src),log=str(log),status=status[-1] if status else 'ERROR',seconds=round(time.monotonic()-start,3),conflicts=a.conflicts)
with (out/'sat_results.jsonl').open('a') as f:
 with concurrent.futures.ThreadPoolExecutor(max_workers=a.jobs) as pool:
  for r in pool.map(run,json.loads(Path(a.manifest).read_text())):print(json.dumps(r),flush=True);f.write(json.dumps(r)+'\n');f.flush()
