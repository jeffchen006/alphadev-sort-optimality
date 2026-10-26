#!/usr/bin/env python3
import concurrent.futures as cf,os,pathlib,subprocess,json,time,sys
K=int(sys.argv[1]) if len(sys.argv)>1 else 11
jobs=[(i,s) for i in sorted(pathlib.Path('sk/insertion').glob('*.initial')) for s in sorted(pathlib.Path('sk/insertion').glob('t*.txt'))]
def job(args):
 ini,sk=args;t=time.monotonic();tag=ini.stem+'_'+sk.stem+f'_k{K}'
 env=dict(os.environ,INITIAL=str(ini),HISTORY=str(ini.with_suffix('.history')))
 try:r=subprocess.run(['./merge_dag',str(sk),str(K),'1','1000000'],env=env,capture_output=True,text=True,timeout=45)
 except subprocess.TimeoutExpired:return {'tag':tag,'result':'WALL_LIMIT'}
 lines=r.stdout.splitlines();result=lines[-1]
 if any(l.startswith('SOLUTION') for l in lines):
  pathlib.Path(f'logs/ins_{tag}.log').write_text(r.stdout+r.stderr)
  core=lines[next(i for i,l in enumerate(lines) if l.startswith('SOLUTION'))+1:lines.index('END')]
  dest=f'candidates/ins_{tag}.s';pref=ini.with_suffix('.s').read_text()
  # Normalize scratch names to reduce judge initialization overhead.
  raw=pref+'\n'+'\n'.join(core)+'\n';mapping={};import re
  def sub(m):
   k=m.group(0)
   if k not in mapping:mapping[k]='S'+str(len(mapping))
   return mapping[k]
  raw=re.sub(r'S\d+',sub,raw);pathlib.Path(dest).write_text(raw)
  jr=subprocess.run(['python3','/path/to/repo/shared/judge.py',dest,'--strict','--model','out'],capture_output=True,text=True)
  pathlib.Path(f'logs/ins_{tag}.judge').write_text(jr.stdout+jr.stderr);result+=' '+jr.stdout.strip()
 return {'tag':tag,'sec':round(time.monotonic()-t,3),'result':result}
with cf.ThreadPoolExecutor(max_workers=6) as pool:
 for x in pool.map(job,jobs):print(json.dumps(x),flush=True)
