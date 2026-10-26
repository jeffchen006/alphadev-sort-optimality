#!/usr/bin/env python3
# d7: all comparator networks (channels unordered, comparator = (min,max) of 2 channel terms) with C comparators that
# sort 5; collect the pool = all terms produced; dedupe pools mod S5 x rev; write pools/net<C>_<i>.txt
import sys, itertools, pickle
from vnet import act
from decide import evcol
C = int(sys.argv[1])
X = tuple(sum(1 << S for S in range(32) if S >> i & 1) for i in range(5))
OUT = tuple(sorted(set()))  # filled below
# outputs: k-th smallest: fam = {S : |S| >= 5-k}  (value 1 iff at least 5-j ones? j-th smallest =1 iff #ones >= 5-j)
OUTS = frozenset(sum(1 << S for S in range(32) if bin(S).count('1') >= 5 - j) for j in range(5))
layer = {(frozenset(X), frozenset()): ()}
for step in range(C):
    nxt = {}
    for (ch, pool), seq in layer.items():
        chl = sorted(ch)
        for a, b in itertools.combinations(chl, 2):
            mn, mx = a & b, a | b
            if {mn, mx} == {a, b}: continue
            nch = set(ch); nch.discard(a); nch.discard(b); nch |= {mn, mx}
            if len(nch) < 5: continue
            k = (frozenset(nch), pool | {mn, mx})
            if k not in nxt: nxt[k] = seq + ((a, b),)
    layer = nxt
    print('step', step + 1, len(layer), file=sys.stderr)
done = [(p, seq) for (ch, p), seq in layer.items() if ch == OUTS]
print('sorting networks (distinct pools)', len(done), file=sys.stderr)
canon = {}
for p, seq in done:
    best = None
    for rev in (0, 1):
        for g in range(120):
            k = tuple(sorted(act(t, g, rev) for t in p))
            if best is None or k < best: best = k
    canon.setdefault(best, (p, seq))
print('mod S5 x rev', len(canon), 'pool sizes', sorted(len(p) for p, _ in canon.values()), file=sys.stderr)
from gates import tname
for i, (p, seq) in enumerate(canon.values()):
    with open('netsk/sk%d_%d.txt' % (C, i), 'w') as f:
        f.write('# d7 %d-comparator sorting network %d (one comparator order of its term-set class)\n' % (C, i) + ''.join('%s:%s\n' % (tname(a), tname(b)) for a, b in seq))
    terms = list(X) + sorted(p - set(X))
    with open('netsk/net%d_%d.txt' % (C, i), 'w') as f:
        for t in terms: f.write(' '.join(map(str, evcol(t))) + '\n')
