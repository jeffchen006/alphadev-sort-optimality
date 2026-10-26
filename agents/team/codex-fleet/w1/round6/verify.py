"""Emit and strict-judge every concrete surviving edit, one process at a time."""
import hashlib
import json
import subprocess
from pathlib import Path
from time import time

HERE=Path(__file__).resolve().parent
WORK=HERE.parent
ROOT=WORK.parents[3]
OPS=['mov','cmp','cmovl','cmovle','cmovg','cmovge','out']
manifest=json.loads((HERE/'manifest.json').read_text())
(HERE/'verified').mkdir(exist_ok=True)
(HERE/'judges').mkdir(exist_ok=True)
ledger=[]

def emit(base,edit,free):
    names=base['registers']+['S999']
    q=[]
    ci=0
    for z in base['code']:
        if z[0]==6:
            if not free:q.append(z)
        else:
            if ci!=edit['delete']:q.append(z)
            ci+=1
    q.insert(edit['gap'],edit['instruction'])
    lines=['# n=5 model=out iset=I1 source=w1-round6-insertion']
    slots=[(mask&-mask).bit_length()-1 for mask in edit['output_masks']]
    def outs(slot,reg):
        if free:
            for j in range(5):
                if slots[j]==slot:lines.append(f'out {j}, {names[reg]}')
    for r in range(5):outs(r,r)
    for i,(op,d,s) in enumerate(q):
        lines.append(f'out {d}, {names[s]}' if op==6 else f'{OPS[op]} {names[d]}, {names[s]}')
        if op not in (1,6):outs(5+i,d)
    return '\n'.join(lines)+'\n'

def judge(path,model):
    log=HERE/'judges'/f'{path.stem}.log'
    command=['python3',str(ROOT/'shared/judge.py'),str(path),'--strict','--model',model]
    start=time()
    p=subprocess.run(command,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
    log.write_text(p.stdout)
    row=dict(path=str(path),sha256=hashlib.sha256(path.read_bytes()).hexdigest(),model=model,
             result='PASS' if p.returncode==0 and p.stdout.startswith('PASS ') else 'FAIL',
             log=str(log),command=command,seconds=time()-start)
    ledger.append(row)
    (HERE/'pass_ledger.json').write_text(json.dumps(ledger,indent=2)+'\n')
    if row['result']!='PASS': print(p.stdout,flush=True)
    return row

def lower(text):
    # Give every logical register a different physical register. Replace each
    # output snapshot with its actual store. P cells are used only in loads/stores.
    q=[s for s in text.splitlines() if s and not s.startswith('#')]
    regs={f'P{i}':f'S{i}' for i in range(5)}
    for line in q:
        op,a,b=line.replace(',',' ').split()
        for r in ([b] if op=='out' else [a,b]):
            if r not in regs:regs[r]=f'S{len(regs)}'
    lines=['# n=5 model=mem iset=I1 source=w1-round6-insertion']
    lines += [f'mov S{i}, P{i}' for i in range(5)]
    for line in q:
        op,a,b=line.replace(',',' ').split()
        lines.append(f'mov P{a}, {regs[b]}' if op=='out' else f'{op} {regs[a]}, {regs[b]}')
    return '\n'.join(lines)+'\n'

if __name__=='__main__':
    for mode in ['fixed','free','relocate_fixed','relocate_free']:
        edits=[json.loads(s) for s in (HERE/f'{mode}.jsonl').read_text().splitlines()]
        bybase={}
        for i,edit in enumerate(edits):
            base=manifest[int(edit['base'][1:])]
            path=HERE/'verified'/f'{mode}_{i:04d}_{edit["base"]}.s'
            text=emit(base,edit,'free' in mode)
            path.write_text(text)
            row=judge(path,'out')
            row['edit']=edit
            if row['result']=='PASS' and edit['base'] not in bybase:
                bybase[edit['base']]=path
                mempath=path.with_name(path.stem+'_mem.s')
                mempath.write_text(lower(text))
                judge(mempath,'mem')
                print(mode,edit['base'],row['result'],str(path),flush=True)
            if i%25==0:print('PROGRESS',mode,i,'of',len(edits),flush=True)
        print('DONE',mode,'edits',len(edits),'first_pass_bases',len(bybase),flush=True)
    (HERE/'pass_ledger.json').write_text(json.dumps(ledger,indent=2)+'\n')
