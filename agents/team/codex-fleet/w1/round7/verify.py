"""Strict-judge new synthesis controls and any executable candidate."""
import hashlib,json,os,resource,subprocess,sys,time
from pathlib import Path
HERE=Path(__file__).resolve().parent;WORK=HERE.parent;ROOT=WORK.parents[3]
os.sched_setaffinity(0,{min(os.sched_getaffinity(0))});resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))

def lower(text):
 regs={f'P{i}':f'S{i}' for i in range(5)};q=[]
 for ln in text.splitlines():
  if not ln or ln.startswith('#'):continue
  op,a,b=ln.replace(',',' ').split();q.append((op,a,b))
  for r in ([b] if op=='out' else [a,b]):
   if r not in regs:regs[r]=f'S{len(regs)}'
 lines=['# n=5 model=mem iset=I1 source=w1-round7-median-path']+[f'mov S{i}, P{i}' for i in range(5)]
 for op,a,b in q:lines.append(f'mov P{a}, {regs[b]}' if op=='out' else f'{op} {regs[a]}, {regs[b]}')
 return '\n'.join(lines)+'\n'
ledger=[]
for path in sorted(HERE.glob('*.s')):
 if path.stem.endswith('_mem'):continue
 mem=path.with_name(path.stem+'_mem.s');mem.write_text(lower(path.read_text()))
 for p,model in [(path,'out'),(mem,'mem')]:
  cmd=[sys.executable,str(ROOT/'shared/judge.py'),str(p),'--strict','--model',model];started=time.time();proc=subprocess.run(cmd,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);log=p.with_suffix('.judge.log');log.write_text(proc.stdout)
  passed=proc.returncode==0 and proc.stdout.startswith('PASS ');row=dict(path=str(p),model=model,result='PASS' if passed else 'FAIL',sha256=hashlib.sha256(p.read_bytes()).hexdigest(),command=cmd,log=str(log),seconds=time.time()-started);ledger.append(row)
  (HERE/'pass_ledger.json').write_text(json.dumps(ledger,indent=2)+'\n');print(proc.stdout.strip(),flush=True)
  if not passed:raise SystemExit('Candidate failed strict judge')
