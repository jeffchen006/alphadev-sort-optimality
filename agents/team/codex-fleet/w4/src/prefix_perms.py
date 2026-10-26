#!/usr/bin/env python3
import os,pathlib,subprocess,concurrent.futures as cf,json,sys,re
sys.path.insert(0,'src');import window
prefix=int(sys.argv[1]);K=int(sys.argv[2]);root=pathlib.Path(f'sk/prefix{prefix}');p,o,n=window.read('candidates/seed33.s');seedcols=pathlib.Path('sk/seed33.txt').read_text().splitlines()[1:];remaining=seedcols[sum(op=='cmp' for op,_,_ in p[:prefix]):4]
env=dict(os.environ,INITIAL=str(root/'initial.txt'),HISTORY=str(root/'history.txt'))
def job(fn):
 tag=fn.stem+f'_pfx{prefix}_k{K}';sk=root/(tag+'.txt');sk.write_text('\n'.join(remaining)+'\n'+fn.read_text())
 r=subprocess.run(['./merge_dag',str(sk),str(K),'1','10000000'],env=env,capture_output=True,text=True);result={'tag':tag,'result':r.stdout.splitlines()[-1]}
 if 'SOLUTION' in r.stdout:
  pathlib.Path('logs/'+tag+'.log').write_text(r.stdout+r.stderr);ls=r.stdout.splitlines();code=ls[next(i for i,s in enumerate(ls) if s.startswith('SOLUTION'))+1:ls.index('END')]
  raw='# n=5 model=out iset=I1 source=w4-prefix-permutation-routing\n'+'\n'.join(f'{op} {a}, {b}' for op,a,b in p[:prefix])+'\n'+'\n'.join(code)+'\n';mapping={}
  def sub(m):
   name=m.group(0)
   if name not in mapping:mapping[name]='S'+str(len(mapping))
   return mapping[name]
  raw=re.sub(r'S\d+',sub,raw);dest=pathlib.Path('candidates/'+tag+'.s');dest.write_text(raw)
  jr=subprocess.run(['python3','/path/to/repo/shared/judge.py',str(dest),'--strict','--model','out'],capture_output=True,text=True);pathlib.Path('logs/'+tag+'.judge').write_text(jr.stdout+jr.stderr);result['judge']=jr.stdout.strip()
 return result
with cf.ThreadPoolExecutor(max_workers=6) as pool:
 for row in pool.map(job,sorted(pathlib.Path('sk/permutations').glob('p*.txt'))):print(json.dumps(row),flush=True)
