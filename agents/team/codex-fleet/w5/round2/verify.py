"""Retain candidates and run strict out and memory judges at nice 19."""
from pathlib import Path
import json
import subprocess
import sys

HERE=Path(__file__).resolve().parent
JUDGE=Path('/path/to/repo/shared/judge.py')
ledger=[]
def reg(r):return f'S{int(r[1:])+(5 if r[0]=="S" else 0)}'
for source in map(Path,sys.argv[1:]):
    data=source.read_text()
    out=HERE/'verified'/source.name
    out.write_text(data)
    mem=out.with_name(out.stem+'_mem.s')
    body=['# n=5 R=37 iset=I1 model=mem source=w5_round2']
    body += [f'mov S{i}, P{i}' for i in range(5)]
    for line in data.splitlines():
        line=line.split('#')[0].strip()
        if not line:continue
        op,a,b=line.replace(',','').split()
        body.append(f'mov P{a}, {reg(b)}' if op=='out' else f'{op} {reg(a)}, {reg(b)}')
    mem.write_text('\n'.join(body)+'\n')
    for path,model in ((out,'out'),(mem,'mem')):
        p=subprocess.run(['nice','-n','19',sys.executable,str(JUDGE),str(path),'--strict','--model',model],capture_output=True,text=True)
        log=HERE/'logs'/f'judge_{path.stem}.log'
        log.write_text(p.stdout+p.stderr)
        print(p.stdout+p.stderr,end='',flush=True)
        ledger.append({'file':str(path),'model':model,'returncode':p.returncode,'output':p.stdout+p.stderr,'log':str(log)})
        if p.returncode or not p.stdout.startswith('PASS '):raise RuntimeError(path)
(HERE/'verify_ledger.jsonl').open('a').write(''.join(json.dumps(row)+'\n' for row in ledger))
