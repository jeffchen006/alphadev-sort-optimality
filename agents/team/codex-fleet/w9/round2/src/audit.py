"""Judge every emitted candidate and record memory conversion for each PASS."""
import hashlib
import json
from pathlib import Path
import re
import subprocess
from orders import HERE,ROOT

def judge(path,model):
    log=HERE/'logs'/f'{path.stem}_{model}_audit.log'
    with log.open('w') as stream:
        proc=subprocess.run(['nice','-n','19','python3','-B',str(ROOT/'shared/judge.py'),str(path),'--strict','--model',model],stdout=stream,stderr=subprocess.STDOUT)
    text=log.read_text();ops=[line.split()[0] for line in path.read_text().splitlines() if line.strip() and not line.startswith(('#','out'))]
    row={'path':str(path),'model':model,'length':len(ops),'cmp':ops.count('cmp'),'mov':ops.count('mov'),
         'cmov':sum(op.startswith('cmov') for op in ops),'pass':proc.returncode==0 and 'PASS' in text,
         'returncode':proc.returncode,'log':str(log),'sha256':hashlib.sha256(path.read_bytes()).hexdigest()}
    if row['pass']:
        retained=HERE/'verified'/path.name;retained.write_bytes(path.read_bytes())
        assert retained.read_bytes()==path.read_bytes()
        row['retained_copy']=str(retained)
    print(json.dumps(row),flush=True);return row

def memory(path):
    names={f'P{i}':f'S{i}' for i in range(5)}
    lines=['# n=5 model=mem iset=I1 source=w9-round2-audit']+[f'mov S{i}, P{i}' for i in range(5)]
    for line in path.read_text().splitlines():
        z=line.split('#')[0].replace(',',' ').split()
        if not z:continue
        op,d,s=z
        for name in ([s] if op=='out' else [d,s]):
            if name not in names:names[name]=f'S{len(names)}'
        lines.append(f'mov P{d}, {names[s]}' if op=='out' else f'{op} {names[d]}, {names[s]}')
    dest=path.with_stem(path.stem+'_mem');dest.write_text('\n'.join(lines)+'\n');return dest

def main():
    ledger=[]
    for path in sorted((HERE/'candidates').glob('*.s')):
        if path.stem.endswith('_mem'):continue
        row=judge(path,'out');ledger.append(row)
        if row['pass']:ledger.append(judge(memory(path),'mem'))
    (HERE/'artifacts/strict_ledger.json').write_text(json.dumps(ledger,indent=2)+'\n')

if __name__=='__main__':main()
