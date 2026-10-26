#!/usr/bin/env python3
"""Create conditional-initial-write seeds from the known c=8 programs."""
import itertools
import json
from pathlib import Path

from analyze import parse, dump, summary, CONDS
from normalize import run_detail, WEAK
from run_campaign import snapshot_error

ROOT=Path(__file__).resolve().parent.parent
BASE=ROOT.parent/'w6/seeds'
records=[]
for family,name in enumerate(('c8_32.s','c8_13_k32.s')):
    p=parse((BASE/name).read_text())
    cmpseen=False
    moves=[]
    for i,(op,a,b) in enumerate(p):
        if op=='cmp':cmpseen=True
        if cmpseen and op=='mov':moves.append(i)
    found=[]
    # Use one or two changed initial writes. Leave all comparisons in place.
    for width in (1,2):
        for positions in itertools.combinations(moves,width):
            for ops in itertools.product(CONDS,repeat=width):
                q=list(p)
                for i,op in zip(positions,ops):q[i]=(op,p[i][1],p[i][2])
                try:d=run_detail(q,WEAK)
                except AssertionError:continue
                ok=all(all(v==sorted(case)[int(a)] for v,case in zip(row[3],WEAK))
                       for (op,a,b),row in zip(q,d) if op=='out')
                if not ok:continue
                s=summary(q)
                if not s['partial_columns']:continue
                sig=tuple(q)
                if sig in [tuple(z) for z in found]:continue
                found.append(q)
    for i,q in enumerate(found[:8]):
        path=ROOT/f'programs/c8_guard_{family}_{i}.s'
        dump(q,path,source=f'w10_c8_guard_family_{family}')
        record={'path':str(path.relative_to(ROOT)),**summary(q)}
        core=[x for x in q if x[0]!='out']
        variants=sorted((snapshot_error(core[:j]+core[j+1:]),j,core[:j]+core[j+1:])
                        for j in range(len(core)))
        for j,(error,deleted,r) in enumerate(variants[:3]):
            target=ROOT/f'programs/c8_guard_{family}_{i}_delete_{j}.s'
            dump(r,target,source=f'w10_c8_partial_deletion_{deleted}_error120_{error}')
        record['best_deletion_error_120']=variants[0][0]
        records.append(record)
print(json.dumps(records,indent=2))
