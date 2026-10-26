#!/usr/bin/env python3
"""Collect ten-comparator value skeletons and rank them by term reuse.

Boolean truth tables name min/max terms. The zero-one principle applies to
the generated comparator networks. Routing remains a separate search.
"""
import itertools
import json
from pathlib import Path
import random

root = Path('sk/net10')
root.mkdir(parents=True, exist_ok=True)
X = tuple(sum(1 << s for s in range(32) if s >> i & 1) for i in range(5))

def name(t):
    mins = [s for s in range(1,32) if t >> s & 1 and
            all(not(t >> (s ^ (1 << i)) & 1) for i in range(5) if s >> i & 1)]
    return '|'.join(''.join(str(i) for i in range(5) if s >> i & 1)
                    for s in sorted(mins, key=lambda s:(s.bit_count(),s)))

seen = set()
records = []
network_count = 0
for ix, line in enumerate(Path('networks10.txt').open()):
    network_count += 1
    ch = list(X)
    sk = []
    pool = set(X)
    # Assign input names in first comparison-use order. This removes much
    # of the input permutation duplication without discarding schedules.
    remap = {}
    for ab in line.strip().split(','):
        a,b = map(int,ab.split('-'))
        for w in (a,b):
            if w not in remap:
                remap[w] = len(remap)
    ch = [X[remap[i]] for i in range(5)]
    for ab in line.strip().split(','):
        a,b = map(int,ab.split('-'))
        u,v = ch[a],ch[b]
        sk.append(tuple(sorted((u,v))))
        ch[a],ch[b] = u & v,u | v
        pool.update((ch[a],ch[b]))
    key = tuple(sk)
    if key in seen:
        continue
    seen.add(key)
    required = {t for ab in sk for t in ab} | set(ch)
    # Terms already supplied as inputs do not require conditional moves.
    lb = len(required - set(X))
    records.append((lb, len(pool)-5, ix, key))

random.Random(20261025).shuffle(records)
records.sort(key=lambda r:(r[0],r[1]))
manifest = []
for i,(lb,poolsize,ix,key) in enumerate(records):
    # A bounded first tranche, spread across all gate lower bounds.
    if i < 1000:
        fn = root / ('n%05d.txt' % i)
        fn.write_text('# network line=%d required_terms=%d pool_terms=%d\n' %
                      (ix+1,lb,poolsize) +
                      ''.join('%s:%s\n' % (name(u),name(v)) for u,v in key))
    manifest.append(dict(rank=i,line=ix+1,required_terms=lb,pool_terms=poolsize,
                         skeleton=key))
Path('network_manifest.json').write_text(json.dumps(manifest))
counts={}
for lb,_,_,_ in records:
    counts[lb]=counts.get(lb,0)+1
print(json.dumps(dict(input_networks=network_count,unique_skeletons=len(records),
                      required_terms=counts,written=min(1000,len(records)))),flush=True)
