#!/usr/bin/env python3
"""Necessary value-preservation and comparison-capacity checks."""
import itertools
import json
import math
import os
from pathlib import Path
import resource
import sys

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'round4/src'))
from insertion_sat import parse,run

def main():
    resource.setrlimit(resource.RLIMIT_AS,(2900*1024**2,)*2)
    os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
    classes=json.loads((ROOT/'round5/logs/classes.json').read_text())
    perms=list(itertools.permutations(range(4)))
    out=[]
    for cl in classes:
        prefix=parse(ROOT/f'round5/classes/p{cl["representative"]}.s')
        missing=[];groups={}
        for p in perms:
            regs,flag,_,_=run(prefix,p+(4,))
            lost=[j for j in range(4) if j not in regs.values()]
            if lost:missing.append(dict(input=p,missing_ranks=lost))
            names=sorted(regs)
            orig=tuple(p.index(regs[n]) if regs[n]<4 else regs[n] for n in names)
            groups.setdefault((orig,flag),0)
            groups[orig,flag]+=5
        size=max(groups.values())
        row=dict(class_id=cl['id'],representative=cl['representative'],programs=cl['programs'],
                 missing_input=bool(missing),witness=missing[:1],
                 largest_initial_state_group=size,minimum_suffix_comparisons=math.ceil(math.log2(size)),
                 state_group_sizes=sorted(groups.values()))
        out.append(row)
    summary=dict(classes=len(out),missing_classes=sum(r['missing_input'] for r in out),
                 missing_programs=sum(r['programs'] for r in out if r['missing_input']),
                 preserved_classes=sum(not r['missing_input'] for r in out),
                 minimum_comparisons=sorted(set(r['minimum_suffix_comparisons'] for r in out)))
    (ROOT/'round5/logs/preflight.json').write_text(json.dumps(out,indent=2)+'\n')
    (ROOT/'round5/logs/preflight_summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps(summary),flush=True)

if __name__=='__main__':main()
