#!/usr/bin/env python3
# d7: min #cmp to compute all 18 gates of the DAG: BFS over computed-gate sets; a block = one cmp (p,q) of available
# terms + the closure of gates it decides (operands available). Ignores copies / registers.
import sys, pickle, itertools
G, dec, pool = pickle.load(open(sys.argv[1], 'rb'))
X = pool[:5]
gt = [g for g in G]; res = {}
# result term of gate i: recompute
for i, (op, a, b) in enumerate(G): res[i] = a & b if op == 'min' else a | b
N = len(G); FULL = (1 << N) - 1
decl = {pq: sum(1 << i for i in l) for pq, l in dec.items()}
def avail(mask): return set(X) | {res[i] for i in range(N) if mask >> i & 1}
layer = {0: None}; seen = {0: None}; ncmp = 0
while FULL not in seen:
    ncmp += 1; new = {}
    for m in layer:
        av = avail(m)
        for pq, dm in decl.items():
            if pq[0] not in av or pq[1] not in av: continue
            mm = m; ch = True
            while ch:
                ch = False
                for i in range(N):
                    if dm >> i & 1 and not mm >> i & 1 and G[i][1] in (av | avail(mm)) and G[i][2] in (av | avail(mm)):
                        mm |= 1 << i; ch = True
            if mm != m and mm not in seen: seen[mm] = (m, pq); new[mm] = 1
    layer = new
    print('cmps', ncmp, 'new states', len(new), 'max gates', max((bin(x).count('1') for x in new), default=0)); sys.stdout.flush()
    if not new: break
print('min cmps to compute all gates:', ncmp if FULL in seen else None)
