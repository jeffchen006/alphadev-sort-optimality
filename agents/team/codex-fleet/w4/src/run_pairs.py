#!/usr/bin/env python3
import concurrent.futures as cf,pathlib,subprocess,os,json,sys
D=int(sys.argv[1]);K=int(sys.argv[2]);base=pathlib.Path(f'sk/pairs{D}');env=dict(os.environ,INITIAL=str(base/'initial.txt'),HISTORY=str(base/'history.txt'))
def job(sk):
 tag=f'd{D}_{sk.stem}_k{K}';r=subprocess.run(['./merge_dag',str(sk),str(K),'1','10000000'],env=env,capture_output=True,text=True)
 result={'tag':tag,'result':r.stdout.splitlines()[-1]}
 if 'SOLUTION' in r.stdout:
  pathlib.Path('logs/pair_'+tag+'.log').write_text(r.stdout+r.stderr);ls=r.stdout.splitlines();code=ls[next(i for i,s in enumerate(ls) if s.startswith('SOLUTION'))+1:ls.index('END')]
  raw=(base/'prefix.s').read_text()+'\n'+'\n'.join(code)+'\n';import re;mapping={}
  def sub(m):
   k=m.group(0)
   if k not in mapping:mapping[k]='S'+str(len(mapping))
   return mapping[k]
  raw=re.sub(r'S\d+',sub,raw);fn=pathlib.Path('candidates/pair_'+tag+'.s');fn.write_text(raw)
  jr=subprocess.run(['python3','/path/to/repo/shared/judge.py',str(fn),'--strict','--model','out'],capture_output=True,text=True)
  pathlib.Path('logs/pair_'+tag+'.judge').write_text(jr.stdout+jr.stderr);result['judge']=jr.stdout.strip()
 return result
with cf.ThreadPoolExecutor(max_workers=6) as pool:
 for x in pool.map(job,sorted(base.glob('t*.txt'))):print(json.dumps(x),flush=True)
