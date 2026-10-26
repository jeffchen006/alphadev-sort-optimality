#!/usr/bin/env python3
# d7: all comparator orders (linear extensions of the term dependency order) of netsk/sk<C>_*.txt skeletons.
# comparator (a,b) needs terms a,b; a term is produced by the comparator whose min/max it is. Writes netsk/ord<C>/sk<C>_<i>_<k>.txt
import sys, glob, os, itertools
C = sys.argv[1]; LIM = int(sys.argv[2]) if len(sys.argv) > 2 else 10**6
def fam(f):
    return sum(1 << S for S in range(32) if any(all(S >> int(ch) & 1 for ch in t) for t in f.split('|')))
os.makedirs('netsk/ord%s' % C, exist_ok=True)
tot = 0; counts = []
for fn in sorted(glob.glob('netsk/sk%s_*.txt' % C), key=lambda s: int(s.split('_')[-1][:-4])):
    sk = [tuple(l.strip().split(':')) for l in open(fn) if l.strip() and not l.startswith('#')]
    F = [(fam(a), fam(b)) for a, b in sk]
    prod = {}
    for i, (a, b) in enumerate(F): prod[a & b] = i; prod[a | b] = i
    dep = [set(prod[t] for t in (a, b) if t in prod and prod[t] < i) for i, (a, b) in enumerate(F)]
    n = len(F); orders = []
    def rec(done, seq):
        if len(orders) >= LIM: return
        if len(seq) == n: orders.append(list(seq)); return
        for i in range(n):
            if i not in done and dep[i] <= done:
                done.add(i); seq.append(i); rec(done, seq); seq.pop(); done.discard(i)
    rec(set(), [])
    counts.append(len(orders)); base = fn.split('/')[-1][:-4]
    for k, o in enumerate(orders):
        with open('netsk/ord%s/%s_%d.txt' % (C, base, k), 'w') as f:
            f.write('# d7 order %d of %s\n' % (k, base) + ''.join('%s:%s\n' % sk[i] for i in o))
    tot += len(orders)
print('classes', len(counts), 'orders total', tot, 'max per class', max(counts), 'min', min(counts))
