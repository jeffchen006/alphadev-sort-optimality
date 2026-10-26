#!/usr/bin/env python3
"""Add one final comparison from terms of the nine-comparison skeletons."""
from pathlib import Path
import itertools

P=list(itertools.permutations(range(5)))
ALL=(1<<120)-1
def col(f):
    return tuple(max(min(p[int(ch)] for ch in term) for term in f.split('|')) for p in P)
def masks(a,b):
    lt=sum(1<<i for i,(x,y) in enumerate(zip(a,b)) if x<y)
    gt=sum(1<<i for i,(x,y) in enumerate(zip(a,b)) if x>y)
    return tuple(sorted(set((lt,gt,ALL^lt,ALL^gt))-{0,ALL}))
def explicit(x):
    return '='+''.join(map(str,x))
BASE=Path('/path/to/repo/agents/team/d1-skeleton/sk')
out=Path('sk/refresh_tail')
out.mkdir(parents=True,exist_ok=True)
total=0
for fn in sorted(BASE.glob('vc*.txt')):
    sk=[tuple(col(f) for f in l.strip().split(':')) for l in fn.read_text().splitlines()
        if l and not l.startswith('#')]
    pool={tuple(p[i] for p in P) for i in range(5)}
    for a,b in sk:
        pool.update((a,b,tuple(map(min,a,b)),tuple(map(max,a,b))))
    groups={}
    for a,b in itertools.combinations(sorted(pool),2):
        m=masks(a,b)
        if m:
            groups.setdefault(m,[]).append((a,b))
    for j,alts in enumerate(groups.values()):
        total+=1
        lines=['# final refresh base=%s alternatives=%d'%(fn.name,len(alts))]
        lines.extend(explicit(a)+':'+explicit(b) for a,b in sk)
        lines.append(';'.join(explicit(a)+':'+explicit(b) for a,b in alts))
        (out/('%s_tail_%03d.txt'%(fn.stem,j))).write_text('\n'.join(lines)+'\n')
print('Final-comparison skeletons',total,flush=True)
