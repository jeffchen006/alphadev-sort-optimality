#!/usr/bin/env python3
"""Insert two predicate refreshes into the known eight-comparison sorter."""
import itertools
import json
from pathlib import Path
import subprocess
import sys

BASE=Path('/path/to/repo/agents/team/d4-evolve/codex/work/position33_valid.txt')
prefix=''
if len(sys.argv)>1:
    BASE=Path(sys.argv[1])
    prefix=sys.argv[2]
P=list(itertools.permutations(range(5)))
ALL=(1<<120)-1
def masks(a,b):
    lt=sum(1<<i for i,(x,y) in enumerate(zip(a,b)) if x<y)
    gt=sum(1<<i for i,(x,y) in enumerate(zip(a,b)) if x>y)
    return tuple(sorted(set((lt,gt,ALL^lt,ALL^gt))-{0,ALL}))
def explicit(x):
    return '='+''.join(map(str,x))

r={'P%d'%i:tuple(p[i] for p in P) for i in range(5)}
pool=set(r.values())
blocks=[]
for line in BASE.read_text().splitlines():
    line=line.split('#',1)[0].strip()
    if not line or line.startswith('out'):
        continue
    op,args=line.split(None,1)
    d,s=map(str.strip,args.split(','))
    if op=='cmp':
        if blocks:
            blocks[-1]['pool']=set(pool)
        a,b=r[d],r[s]
        flags=[(x>y)-(x<y) for x,y in zip(a,b)]
        blocks.append(dict(pair=(a,b),mask=masks(a,b)))
    elif op=='mov':
        r[d]=r[s]
    else:
        take={'cmovl':{-1},'cmovle':{-1,0},'cmovg':{1},'cmovge':{0,1}}[op]
        r[d]=tuple(y if f in take else x for x,y,f in zip(r[d],r[s],flags))
    pool.update(r.values())
blocks[-1]['pool']=set(pool)

refresh=[]
for pos,bl in enumerate(blocks):
    groups={}
    for a,b in itertools.combinations(sorted(bl['pool']),2):
        m=masks(a,b)
        if m:
            groups.setdefault(m,[]).append((a,b))
    prior=set(b['mask'] for b in blocks[:pos+1])
    for m in prior:
        if m in groups:
            refresh.append((pos,m,groups[m]))

out=Path('sk/nonlattice10')
out.mkdir(parents=True,exist_ok=True)
n=0
for left,right in itertools.combinations(refresh,2):
    # Distinct insertion positions prevent adjacent identical refreshes.
    p,m,alts=left
    q,m2,alts2=right
    if p>=q or m==m2:
        continue
    n+=1
    lines=['# c8 nonlattice + refreshes after %d,%d alternatives=%d,%d base=%s'%
           (p+1,q+1,len(alts),len(alts2),BASE)]
    for pos,bl in enumerate(blocks):
        a,b=bl['pair']
        lines.append(explicit(a)+':'+explicit(b))
        if pos in (p,q):
            chosen=alts if pos==p else alts2
            lines.append(';'.join(explicit(a)+':'+explicit(b) for a,b in chosen))
    (out/(prefix+'p%02d_q%02d_%04d.txt'%(p+1,q+1,n))).write_text('\n'.join(lines)+'\n')
print(json.dumps(dict(base=str(BASE),base_comparisons=len(blocks),refresh_groups=len(refresh),
                      ten_comparison_skeletons=n)),flush=True)
if not prefix:
    newer=Path('/path/to/repo/agents/team/codex-fleet/w6/candidates/c8c_len32_c29288.s')
    if newer.exists():
        subprocess.run([sys.executable,__file__,str(newer),'w6_'],check=True)
