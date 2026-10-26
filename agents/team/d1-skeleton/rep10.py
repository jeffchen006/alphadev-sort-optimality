# rep10.py outdir base... : c=10 skeletons = base + repeat of cmp q inserted at a later position p (p >= q+2)
import sys, os
sys.path.insert(0, '.')
from cons import names, norm
from gensk import canon
NI = {n: i for i, n in enumerate(names)}
out = sys.argv[1]; os.makedirs(out, exist_ok=True); seen = set(); cnt = 0
for fn in sys.argv[2:]:
    sk = [tuple(NI[norm(x)] for x in l.strip().split(':')) for l in open(fn) if l.strip() and l[0] != '#']
    for q in range(len(sk)):
        for p in range(q + 2, len(sk) + 1):
            s2 = sk[:p] + [sk[q]] + sk[p:]
            k = canon(s2)
            if k in seen: continue
            seen.add(k); cnt += 1
            with open('%s/r%05d.txt' % (out, cnt), 'w') as f:
                f.write('# %s + repeat of cmp %d at position %d\n' % (fn, q + 1, p + 1))
                for a, b in s2: f.write('%s:%s\n' % (names[a], names[b]))
print(cnt)
