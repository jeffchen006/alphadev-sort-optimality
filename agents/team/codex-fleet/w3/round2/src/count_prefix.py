#!/usr/bin/env python3
"""Counting checks for information-tight seven-comparison strict sorting trees."""
import itertools,json
from pathlib import Path
P=list(itertools.permutations(range(5)))
rows=[]
for prefix,depth in [([(0,1)],5), ([(0,1),(2,3)],4)]:
    S=[p for p in P if all(p[a]<p[b] for a,b in prefix)]
    pairs=[]
    for a,b in itertools.combinations(range(5),2):
        lo=sum(p[a]<p[b] for p in S);hi=len(S)-lo
        pairs.append(dict(pair=[a,b],split=[lo,hi],possible=0<lo and 0<hi and max(lo,hi)<=2**depth))
    rows.append(dict(prefix=[list(p) for p in prefix],orders=len(S),remaining_after_next=depth,pairs=pairs))
assert [r['pair'] for r in rows[0]['pairs'] if r['possible']]==[[2,3],[2,4],[3,4]]
assert [r['pair'] for r in rows[1]['pairs'] if r['possible']]==[[0,2],[1,3]]
Path('round2/logs/prefix_count.json').write_text(json.dumps(rows,indent=2)+'\n')
print(json.dumps(rows))
