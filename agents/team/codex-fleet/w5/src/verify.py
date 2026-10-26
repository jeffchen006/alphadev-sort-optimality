"""Copy stable output-model programs, convert them to memory, and judge both."""
from pathlib import Path
import re, subprocess, sys

HERE=Path(__file__).resolve().parents[1]
JUDGE=Path('/path/to/repo/shared/judge.py')
def reg(r):
    return f'S{int(r[1:])+(5 if r[0]=="S" else 0)}'
for source in map(Path,sys.argv[1:]):
    text=source.read_text()
    out=HERE/'verified'/source.name
    out.write_text(text)
    mem=out.with_name(out.stem+'_mem.s')
    body=['# n=5 R=37 iset=I1 model=mem source=w5 out-to-memory conversion']
    body += [f'mov S{i}, P{i}' for i in range(5)]
    for line in text.splitlines():
        line=line.split('#')[0].strip()
        if not line:continue
        op,a,b=line.replace(',','').split()
        body.append(f'mov P{a}, {reg(b)}' if op=='out' else f'{op} {reg(a)}, {reg(b)}')
    mem.write_text('\n'.join(body)+'\n')
    for path,model in ((out,'out'),(mem,'mem')):
        result=subprocess.run(['nice','-n','10',sys.executable,str(JUDGE),str(path),'--strict','--model',model],capture_output=True,text=True)
        log=HERE/'logs'/f'judge_{path.stem}.log'
        log.write_text(result.stdout+result.stderr)
        print(result.stdout+result.stderr,end='',flush=True)
        if result.returncode or not result.stdout.startswith('PASS '):raise RuntimeError(path)
