"""Record a target only after strict out and memory judge PASS results."""
import subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
def check(path,out_result=None):
    path=Path(path);judge=ROOT.parents[3]/'shared/judge.py'
    if out_result is None:
        q=subprocess.run(['nice','-n','19','python3',str(judge),str(path),'--strict','--model','out'],capture_output=True,text=True)
        out_result=q.stdout+q.stderr
        print('JUDGE',out_result,flush=True)
    rows=[s for s in path.read_text().splitlines() if s and not s.startswith('#')]
    k=sum(not s.startswith('out ') for s in rows)
    if 'PASS ' not in out_result or k>31:return
    mem=path.with_name(path.stem+'_mem.s')
    lines=['# n=5 R=200 iset=I1 model=mem source=w3_round2_conversion']+[f'mov S{i}, P{i}' for i in range(5)]
    reg=lambda r:'S'+str(int(r[1:])+(0 if r.startswith('P') else 5))
    for line in rows:
        op,rest=line.split(None,1);a,b=[s.strip() for s in rest.split(',')]
        lines.append(f'mov P{a}, {reg(b)}' if op=='out' else f'{op} {reg(a)}, {reg(b)}')
    mem.write_text('\n'.join(lines)+'\n')
    q=subprocess.run(['nice','-n','19','python3',str(judge),str(mem),'--strict','--model','mem'],capture_output=True,text=True)
    mem_result=q.stdout+q.stderr
    print('MEM_JUDGE',mem_result,flush=True)
    if 'PASS ' not in mem_result:return
    result=ROOT/'RESULTS.md';line=f'FOUND k={k} out={path.relative_to(ROOT)} mem={mem.relative_to(ROOT)}\n'
    result.write_text(line+result.read_text())
    path.with_suffix('.judge.txt').write_text(out_result+'\n'+mem_result)
    print(line,flush=True)
