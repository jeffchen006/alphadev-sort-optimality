#!/usr/bin/env python3
"""Strict-judge selected candidate files and their exact memory translations."""
import argparse
import json
from pathlib import Path
import subprocess
import sys

from analyze import parse

ROOT=Path(__file__).resolve().parent.parent
# Resolve from the fixed project root, without assuming parent-depth aliases.
JUDGE=Path('/path/to/repo/shared/judge.py')

def to_memory(path):
    p=parse(path.read_text())
    rs=sorted({r for op,a,b in p for r in ([b] if op=='out' else [a,b])})
    mapping={r:f'S{i}' for i,r in enumerate(rs)}
    text=['# n=5 model=mem iset=I1 source=w10_out_translation']
    text += [f'mov {mapping[f"P{i}"]}, P{i}' for i in range(5)]
    for op,a,b in p:
        text.append(f'mov P{a}, {mapping[b]}' if op=='out' else f'{op} {mapping[a]}, {mapping[b]}')
    target=path.with_name(path.stem+'_mem.s')
    target.write_text('\n'.join(text)+'\n')
    return target

if __name__=='__main__':
    ap=argparse.ArgumentParser()
    ap.add_argument('files',nargs='+')
    ap.add_argument('--log',default='logs/judge_selected.log')
    args=ap.parse_args()
    records=[]
    with (ROOT/args.log).open('w') as log:
        for name in args.files:
            file=(ROOT/name).resolve()
            for f,model in ((file,'out'),(to_memory(file),'mem')):
                p=subprocess.run(['nice','-n','10',sys.executable,str(JUDGE),str(f),'--strict','--model',model],capture_output=True,text=True)
                output=p.stdout+p.stderr
                log.write(output);log.flush()
                first=output.splitlines()[0] if output else 'EMPTY'
                record={'path':str(f.relative_to(ROOT)),'model':model,'returncode':p.returncode,'result':first}
                records.append(record)
                print(first,flush=True)
    (ROOT/args.log).with_suffix('.json').write_text(json.dumps(records,indent=2)+'\n')
