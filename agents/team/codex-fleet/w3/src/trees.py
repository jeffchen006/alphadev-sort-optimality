#!/usr/bin/env python3
"""Enumerate depth-four sorting trees after the Ford-Johnson three-comparison prefix."""
import itertools, functools, json
P=list(itertools.permutations(range(5)))
# chain a < b < d, partner c < d, e free
PS=tuple(p for p in P if p[0]<p[1]<p[3] and p[2]<p[3])
@functools.lru_cache(None)
def trees(S, depth):
    if len(S)==1:
        return (None,)
    if depth<=0 or len(S)>2**depth:
        return ()
    ret=[]
    for a,b in itertools.combinations(range(5),2):
        L=tuple(i for i in S if PS[i][a]<PS[i][b]); R=tuple(i for i in S if PS[i][a]>PS[i][b])
        if not L or not R: continue
        lt,rt=trees(L,depth-1),trees(R,depth-1)
        for l in lt:
            for r in rt: ret.append((a,b,l,r))
    return tuple(ret)
if __name__=='__main__':
    ts=trees(tuple(range(len(PS))),4)
    print('residual permutations',len(PS),'trees',len(ts))
    from collections import Counter
    print('first pairs',Counter(t[:2] for t in ts))
    with open('sk/trees.json','w') as f: json.dump(ts,f)
