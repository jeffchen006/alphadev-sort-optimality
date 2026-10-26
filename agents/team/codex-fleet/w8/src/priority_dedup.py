#!/usr/bin/env python3
"""Exclude one-swap skeletons from the two-swap low-column cases."""
import numpy as np,itertools,json,hashlib
from pathlib import Path
P=list(itertools.permutations(range(5)));PI={p:i for i,p in enumerate(P)}
IDX=np.array([[PI[tuple(t[s[i]] for i in range(5))] for t in P] for s in P])
INPUT=[bytes(48+p[i] for p in P) for i in range(5)]
def key(file):
    cols=[x[1:].encode() for l in Path(file).read_text().splitlines() if l.startswith('=') for x in l.split(':')]
    a,b=INPUT.index(cols[0]),INPUT.index(cols[1]);idx=[j for j,s in enumerate(P) if {s[a],s[b]}=={0,1}]
    if cols[2] in INPUT and cols[3] in INPUT:
        c,d=INPUT.index(cols[2]),INPUT.index(cols[3])
        if len({a,b,c,d})==4:idx=[j for j in idx if {P[j][c],P[j][d]}=={2,3}]
    sk=np.frombuffer(b''.join(cols),dtype=np.uint8).reshape(18,120);best=None
    for j in idx:
        v=sk[:,IDX[j]];parts=[]
        for k in range(0,18,2):
            x,y=v[k].tobytes(),v[k+1].tobytes();parts.append(x+y if x<y else y+x)
        q=b''.join(parts)
        if best is None or q<best:best=q
    return hashlib.sha256(best).digest()
def main():
    own=set()
    for r in json.loads(Path('sk/broad_nonlattice.json').read_text()):own.add(key(r['file']))
    kept=[];dup=0
    for r in json.loads(Path('sk/two_priority.json').read_text()):
        k=key(r['file'])
        if k in own:dup+=1;continue
        own.add(k);kept.append(r)
    Path('sk/two_priority_new.json').write_text(json.dumps(kept,indent=2)+'\n')
    print(json.dumps(dict(two_priority=651,excluded_one_swap_or_duplicate=dup,new=len(kept))),flush=True)
if __name__=='__main__':main()
