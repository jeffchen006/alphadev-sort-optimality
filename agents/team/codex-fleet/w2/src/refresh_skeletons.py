#!/usr/bin/env python3
"""Add a comparison from prior network terms; group equivalent predicates.

The grouping is exact on the 120 distinct input orders. All operand pairs
in one group support the same conditional move masks. The modified router
maps its conditional move opcode to the selected operand pair.
"""
import itertools
import json
from pathlib import Path

BASE = Path('/path/to/repo/agents/team/d1-skeleton/sk')
P = list(itertools.permutations(range(5)))
ALL = (1<<120)-1
def col(f):
    return tuple(max(min(p[int(ch)] for ch in term) for term in f.split('|')) for p in P)
def explicit(c):
    return '='+''.join(map(str,c))
def masks(a,b):
    lt=sum(1<<i for i,(x,y) in enumerate(zip(a,b)) if x<y)
    gt=sum(1<<i for i,(x,y) in enumerate(zip(a,b)) if x>y)
    return tuple(sorted(set((lt,gt,ALL^gt,ALL^lt))-{0,ALL}))

out=Path('sk/refresh')
out.mkdir(parents=True,exist_ok=True)
total=0
stats=[]
for fn in sorted(BASE.glob('vc*.txt')):
    sk=[tuple(col(f) for f in line.strip().split(':')) for line in fn.read_text().splitlines()
        if line and not line.startswith('#')]
    pool={tuple(p[i] for p in P) for i in range(5)}
    nbase=0
    for pos,(a,b) in enumerate(sk):
        pool.update((a,b))
        pool.update((tuple(map(min,a,b)),tuple(map(max,a,b))))
        # A refresh after this comparator can use all min/max terms made so
        # far, including values an ordinary five-wire network discards.
        if pos==8:
            continue
        groups={}
        for x,y in itertools.combinations(sorted(pool),2):
            m=masks(x,y)
            if not m: # Constant flags add no condition.
                continue
            groups.setdefault(m,[]).append((x,y))
        for gi,(m,alts) in enumerate(sorted(groups.items())):
            # Skip exact repeat pairs with no new operand alternatives.
            old={(x,y) for x,y in sk[:pos+1]}|{(y,x) for x,y in sk[:pos+1]}
            if len(alts)==1 and alts[0] in old:
                continue
            total+=1;nbase+=1
            nf=out/('%s_p%d_g%03d.txt'%(fn.stem,pos+1,gi))
            lines=['# refresh base=%s after=%d alternatives=%d'%(fn.name,pos+1,len(alts))]
            for j,(x,y) in enumerate(sk):
                lines.append(explicit(x)+':'+explicit(y))
                if j==pos:
                    lines.append(';'.join(explicit(u)+':'+explicit(v) for u,v in alts))
            nf.write_text('\n'.join(lines)+'\n')
    stats.append((fn.name,nbase))
Path('logs/refresh_generation.json').write_text(json.dumps(dict(total=total,bases=stats),indent=2)+'\n')
print(total,stats,flush=True)
