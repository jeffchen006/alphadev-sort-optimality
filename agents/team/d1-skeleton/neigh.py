#!/usr/bin/env python3
"""neighbours of lattice skeletons: replace one cmp by another pair of lattice columns; keep validity
(each operand index-consistent at its block, each cmp refines the partition, 120 classes at the end).
Dedupe up to S5 x reversal (and vs the inputs). usage: neigh.py outdir base1.txt base2.txt ..."""
import sys, os, numpy as np
sys.path.insert(0, '.')
from cons import cols, names, consistent_mask, norm, IDX
from gensk import canon
NI = {n: i for i, n in enumerate(names)}
def load(fn):
    return [tuple(NI[norm(x)] for x in l.strip().split(':')) for l in open(fn) if l.strip() and l[0] != '#']
def flags(a, b): return np.sign(cols[a].astype(np.int64) - cols[b]) + 1
def cons1(labels, x):
    return len(np.unique(labels * 8 + IDX[x])) == len(np.unique(labels))
def valid(seq, start=0, labels=None):
    if labels is None: labels = np.zeros(120, dtype=np.int64)
    for j, (a, b) in enumerate(seq):
        if j > start and not (cons1(labels, a) and cons1(labels, b)): return False
        nl = labels * 3 + flags(a, b)
        if j >= start and len(np.unique(nl)) == len(np.unique(labels)): return False
        labels = nl
    return len(np.unique(labels)) == 120
outdir = sys.argv[1]; os.makedirs(outdir, exist_ok=True)
seen = set(); bases = []
for fn in sys.argv[2:]:
    s = load(fn); seen.add(canon(s)); bases.append(s)
cnt = 0
for bi, base in enumerate(bases):
    for j in range(len(base)):
        labels = np.zeros(120, dtype=np.int64)
        for a, b in base[:j]: labels = labels * 3 + flags(a, b)
        m = np.nonzero(consistent_mask(labels))[0]
        for ia, a in enumerate(m):
            for b in m[ia + 1:]:
                s2 = base[:j] + [(a, b)] + base[j + 1:]
                if not valid(s2, j, None): continue
                k = canon(s2)
                if k in seen: continue
                seen.add(k); cnt += 1
                with open('%s/n%05d.txt' % (outdir, cnt), 'w') as f:
                    f.write('# neighbour of base %d pos %d\n' % (bi, j))
                    for x, y in s2: f.write('%s:%s\n' % (names[x], names[y]))
        print('base', bi, 'pos', j, 'total', cnt, file=sys.stderr, flush=True)
