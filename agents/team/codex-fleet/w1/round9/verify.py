"""Strict-judge emitted candidates and translate out programs to memory."""
import argparse,hashlib,json,os,resource,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve().parent;WORK=HERE.parent;ROOT=WORK.parents[3]
def lower(text):
 q=[ln for ln in text.splitlines() if ln and not ln.startswith('#')]
 names={f'P{i}':f'S{i}' for i in range(5)}
 for ln in q:
  op,a,b=ln.replace(',',' ').split()
  for r in ([b] if op=='out' else [a,b]):
   if r not in names:names[r]=f'S{len(names)}'
 lines=['# n=5 model=mem iset=I1 source=w1-round9-median-path']
 lines += [f'mov S{i}, P{i}' for i in range(5)]
 for ln in q:
  op,a,b=ln.replace(',',' ').split()
  lines.append(f'mov P{a}, {names[b]}' if op=='out' else f'{op} {names[a]}, {names[b]}')
 return '\n'.join(lines)+'\n'
def main():
 ap=argparse.ArgumentParser();ap.add_argument('patterns',nargs='+');a=ap.parse_args()
 os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
 if os.getpriority(os.PRIO_PROCESS,0)<19:os.nice(19-os.getpriority(os.PRIO_PROCESS,0))
 resource.setrlimit(resource.RLIMIT_AS,(2800*1024**2,2800*1024**2))
 lp=HERE/'pass_ledger.json';ledger=json.loads(lp.read_text()) if lp.exists() else []
 paths=sorted(set(p for pat in a.patterns for p in HERE.glob(pat) if not p.stem.endswith('_mem')))
 for p in paths:
  q=p.with_name(p.stem+'_mem.s');q.write_text(lower(p.read_text()))
  for path,model in [(p,'out'),(q,'mem')]:
   cmd=[sys.executable,str(ROOT/'shared/judge.py'),str(path),'--strict','--model',model]
   r=subprocess.run(cmd,capture_output=True,text=True);log=path.with_suffix('.judge.log')
   log.write_text(r.stdout+r.stderr)
   row=dict(path=str(path),sha256=hashlib.sha256(path.read_bytes()).hexdigest(),model=model,
    result='PASS' if r.returncode==0 and r.stdout.startswith('PASS ') else 'FAIL',command=cmd,log=str(log))
   ledger=[v for v in ledger if v['path']!=str(path)]+[row]
   lp.write_text(json.dumps(ledger,indent=2)+'\n');print(r.stdout.strip(),flush=True)
   if row['result']=='PASS' and model=='out':
    k=sum(1 for ln in path.read_text().splitlines() if ln and not ln.startswith(('#','out ')))
    if k<=31:
     out=WORK/'RESULTS.md';s=out.read_text();line=f'FOUND k={k} strict PASS: {path}\n'
     if line not in s:out.write_text(line+'\n'+s)
   assert row['result']=='PASS',row
if __name__=='__main__':main()
