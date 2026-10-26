#!/usr/bin/env python3
"""A correct control whose added comparison recovers a bit through equality."""
import itertools
import json
import os
from pathlib import Path
import resource
import subprocess
import sys
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'round4/src'))
from insertion_sat import PERMS,parse,run

def main():
    resource.setrlimit(resource.RLIMIT_AS,(2900*1024**2,)*2)
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    prefix=ROOT/'round5/classes/p0.s'
    suffix=parse(ROOT/'round5/programs/control_suffix22.s')
    assert suffix[:3]==[('cmp','S0','S2'),('cmovg','S0','S2'),('cmovge','S2','P3')]
    suffix=suffix[:3]+[('cmp','S2','P3')]+suffix[3:]
    path=ROOT/'round6/programs/repeat_state_suffix23.s'
    path.write_text('\n'.join(f'{op} {d}, {s}' for op,d,s in suffix)+'\n')
    program=parse(prefix)+suffix
    indices=[i for i,(op,d,s) in enumerate(program) if op=='cmp']
    columns=[]
    for ty in PERMS:
        trace=run(program,ty,True)[3]
        columns.append((trace[indices[3]][1]+1,trace[indices[4]][1]+1))
    matches=[permutation for permutation in itertools.permutations(range(3))
             if all(permutation[old]==new for old,new in columns)]
    assert matches and all(p not in ((0,1,2),(2,1,0)) for p in matches)
    print(json.dumps(dict(event='FLAG_STATE_CONTROL',matching_permutations=matches,
                         old_states=sorted({a for a,b in columns}),new_states=sorted({b for a,b in columns}))),flush=True)
    result=subprocess.run([sys.executable,str(ROOT/'round6/src/interleave_sat.py'),str(prefix),
       '--tag','repeat_state_control37','--comparisons','7','--slots','23','--fix',str(path),
       '--all','--history','--capacity','--preserve','--scratch','--repeat-flag','--repeat-mode','state',
       '--timeout','60'])
    if result.returncode:raise SystemExit(result.returncode)

if __name__=='__main__':main()
