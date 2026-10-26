#!/usr/bin/env python3
"""Reproduce the complete enumeration, minima and strict witness checks."""
from collections import Counter
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import subprocess
import sys

root=Path(__file__).resolve().parent
threads=int(sys.argv[1]) if len(sys.argv)>1 else 8
assert 1 <= threads <= 8
judge=Path('/path/to/repo/shared/judge.py')

def run(args, log=None, error=None):
    handles=[]
    try:
        kwargs={}
        if log:
            kwargs['stdout']=open(root/log,'w');handles.append(kwargs['stdout'])
        if error:
            kwargs['stderr']=open(root/error,'w');handles.append(kwargs['stderr'])
        subprocess.run(['nice','-n','10',*map(str,args)],cwd=root,check=True,**kwargs)
    finally:
        for h in handles:h.close()

run(['g++','-O3','-std=c++17','enumerate.cpp','-o','enumerate'])
run(['g++','-O3','-std=c++17','-fopenmp','reuse.cpp','-o','reuse'])
run(['./enumerate'],'enumeration.log')
for cap in (4,5,7):
    run(['./reuse','networks.txt',cap,14904,threads],f'reuse_q{cap}.log',f'reuse_q{cap}.err')
networks=(root/'networks.txt').read_text().splitlines(keepends=True)
minima=[int(s.split()[1]) for s in (root/'reuse_results_q7.txt').read_text().splitlines()]
unresolved=[i for i,v in enumerate(minima) if v<0]
assert len(networks)==14904 and len(unresolved)==744
(root/'networks_unresolved.txt').write_text(''.join(networks[i] for i in unresolved))
(root/'unresolved_indices.txt').write_text(''.join(f'{i}\n' for i in unresolved))
run(['./reuse','networks_unresolved.txt',9,len(unresolved),threads],'reuse_q9_unresolved.log','reuse_q9_unresolved.err')
answers=[int(s.split()[1]) for s in (root/'reuse_results_q9.txt').read_text().splitlines()]
for i,v in zip(unresolved,answers):minima[i]=v
assert Counter(minima)=={5:1710,6:7296,7:5154,8:744}
(root/'minimum_moves.tsv').write_text('sequence_index\tminimum_moves\n'+''.join(f'{i}\t{v}\n' for i,v in enumerate(minima)))
run(['python3','crosscheck.py'],'crosscheck.log','crosscheck.err')
for cap in (5,6,7,8):
    index=minima.index(cap)
    run(['./reuse','networks.txt',cap,index+1,1,index],f'emit_q{cap}.log')
    (root/'witness_out.s').replace(root/f'witness_q{cap}_out.s')
run(['python3','check_witnesses.py'],'witness_check.log')

def check(item):
    cap,model=item
    name=f'witness_q{cap}_{model}.s'
    log=f'judge_q{cap}_{model}.log'
    run(['python3',judge,name,'--strict','--model',model],log)
    output=(root/log).read_text()
    assert output.startswith('PASS '),output
    return output.strip()

with ThreadPoolExecutor(max_workers=threads) as pool:
    for result in pool.map(check,[(q,m) for q in (5,6,7,8) for m in ('out','mem')]):
        print(result,flush=True)
print('All enumeration counts, minimum move counts, independent checks, and strict judge checks passed.')
