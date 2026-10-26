#!/usr/bin/env python3
# d7: canonical virtual networks (gate DAGs) of the optima, from gdump.txt, under S5 x reversal.
import sys, itertools, collections as C
PERMS = list(itertools.permutations(range(5)))
TAB = []
for p in PERMS:
    sm = [sum(1 << p[i] for i in range(5) if S >> i & 1) for S in range(32)]
    TAB.append([[sum(1 << sm[8 * b + j] for j in range(8) if v >> j & 1) for v in range(256)] for b in range(4)])
def act(f, g, rev):
    if rev:
        f = (~int('{:032b}'.format(f)[::-1], 2)) & 0xffffffff
    t = TAB[g]
    return t[0][f & 255] | t[1][f >> 8 & 255] | t[2][f >> 16 & 255] | t[3][f >> 24]
def canon(items):
    # items: list of tuples of fams (+ op strings); op min<->max under rev
    best = None
    for rev in (0, 1):
        for g in range(120):
            k = tuple(sorted(it(g, rev) for it in items))
            if best is None or k < best: best = k
    return best
if __name__ == '__main__':
    dag = C.Counter(); dagb = C.Counter(); cache1 = {}; cache2 = {}; rep = {}
    for line in open(sys.argv[1]):
        p = line.split(); i = int(p[1]); gs = p[2:p.index('|')]
        G = []
        for x in gs:
            op, a, b, ca, cb, own = x.split(':')
            G.append((op, int(a, 16), int(b, 16), int(ca, 16), int(cb, 16), int(own)))
        k1 = frozenset((op, frozenset((a, b))) for op, a, b, *_ in G)
        if k1 not in cache1:
            items = [(lambda op, a, b: (lambda g, rev: (({'min': 'max', 'max': 'min'}[op] if rev else op),) + tuple(sorted((act(a, g, rev), act(b, g, rev))))))(op, *sorted(ab)) for op, ab in k1]
            cache1[k1] = canon(items)
        c1 = cache1[k1]; dag[c1] += 1; rep.setdefault(c1, i)
        k2 = (k1, tuple(sorted((op, a, b, ca, cb) for op, a, b, ca, cb, own in G if not own)))
        if k2 not in cache2:
            items = [(lambda op, a, b: (lambda g, rev: ('g', ({'min': 'max', 'max': 'min'}[op] if rev else op),) + tuple(sorted((act(a, g, rev), act(b, g, rev))))))(op, *sorted(ab)) for op, ab in k1]
            items += [(lambda op, a, b, ca, cb: (lambda g, rev: ('b', ({'min': 'max', 'max': 'min'}[op] if rev else op),) + tuple(sorted((act(a, g, rev), act(b, g, rev)))) + tuple(sorted((act(ca, g, rev), act(cb, g, rev))))))(*t) for t in k2[1]]
            cache2[k2] = canon(items)
        dagb[cache2[k2]] += 1
    print('distinct gate DAGs (raw)', len(cache1), ' mod S5 x rev', len(dag))
    print('distinct (DAG, borrow set) mod S5 x rev', len(dagb))
    print('DAG class sizes', [v for _, v in dag.most_common()][:60])
    with open('vnet_classes.txt', 'w') as fo:
        for k, v in dag.most_common(): fo.write('%d %d\n' % (v, rep[k]))
