#!/usr/bin/env python3
import concurrent.futures as cf,os,pathlib,subprocess,json,time,sys
sys.path.insert(0,'src');import window
K=int(sys.argv[1]) if len(sys.argv)>1 else 16
jobs=sorted(pathlib.Path('sk/merge').glob('t*.txt'))
env=dict(os.environ,INITIAL='sk/merge/initial.txt',HISTORY='sk/merge/history.txt')
p,o,n=window.read('candidates/seed33.s')
def job(fn):
 t=time.monotonic();tag=f'{fn.stem}_k{K}';r=subprocess.run(['./merge_dag',str(fn),str(K),'1','100000000'],env=env,capture_output=True,text=True)
 pathlib.Path(f'logs/merge_{tag}.log').write_text(r.stdout+r.stderr)
 lines=r.stdout.splitlines()
 if any(l.startswith('SOLUTION') for l in lines):
  core=lines[next(i for i,l in enumerate(lines) if l.startswith('SOLUTION'))+1:lines.index('END')]
  dest=f'candidates/merge_{tag}.s'
  pathlib.Path(dest).write_text('# n=5 model=out iset=I1 source=w4-merge-routing\n'+'\n'.join(f'{op} {a}, {b}' for op,a,b in p[:15])+'\n'+'\n'.join(core)+'\n')
  jr=subprocess.run(['python3','/path/to/repo/shared/judge.py',dest,'--strict','--model','out'],capture_output=True,text=True)
  pathlib.Path(f'logs/merge_{tag}.judge').write_text(jr.stdout+jr.stderr)
  print(jr.stdout,flush=True)
 return {'tree':fn.stem,'K':K,'sec':round(time.monotonic()-t,3),'result':lines[-1]}
with cf.ThreadPoolExecutor(max_workers=1) as pool:
 for x in pool.map(job,jobs):print(json.dumps(x),flush=True)
