#!/usr/bin/env python3
import concurrent.futures as cf,subprocess,itertools,time,pathlib,sys,json
sys.path.insert(0,str(pathlib.Path(__file__).parent))
import window
p,_,_=window.read('candidates/seed33.s')
widths=list(map(int,sys.argv[1].split(','))) if len(sys.argv)>1 else [4,5,6,7,8]
seconds=int(sys.argv[2]) if len(sys.argv)>2 else 30
workers=int(sys.argv[3]) if len(sys.argv)>3 else 6
jobs=[(a,a+w) for w in widths for a in range(len(p)-w+1)]
def job(ab):
 a,b=ab;tag=f'w{a}_{b}_{seconds}';log=f'logs/{tag}.log';out=f'candidates/{tag}.s'
 cmd=['python3','src/window.py','candidates/seed33.s','--a',str(a),'--b',str(b),'--seconds',str(seconds),'--out',out]
 t=time.monotonic()
 try:
  with open(log,'w') as f:subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,timeout=seconds+60)
  result=open(log).read().splitlines()[-1]
 except subprocess.TimeoutExpired:result='PROCESS_TIMEOUT'
 if pathlib.Path(out).exists():
  jr=subprocess.run(['python3','/path/to/repo/shared/judge.py',out,'--strict','--model','out'],capture_output=True,text=True)
  pathlib.Path(f'logs/{tag}.judge').write_text(jr.stdout+jr.stderr);result+=' '+jr.stdout.strip()
 return {'a':a,'b':b,'sec':round(time.monotonic()-t,1),'result':result}
with cf.ThreadPoolExecutor(max_workers=workers) as pool:
 for result in pool.map(job,jobs):print(json.dumps(result),flush=True)
