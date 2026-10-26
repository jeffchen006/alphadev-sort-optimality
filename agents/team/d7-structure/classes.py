#!/usr/bin/env python3
# d7: term-set classes (created lattice terms, mod S5 x rev) of all correct k=32 programs per source
import collections as C, pickle
from vnet import act
srcs = []
for l in open('ok_k32.txt'):
    if l.startswith('# prog'):
        s = l.split('src=')[1].strip().split('/')
        srcs.append(s[1] if s[1] != 'codex-fleet' else 'fleet/' + s[2])
cache = {}
def canon(ts):
    if ts not in cache:
        cache[ts] = min(tuple(sorted(act(t, g, r) for t in ts)) for r in (0, 1) for g in range(120))
    return cache[ts]
# reference: MCMC class = net9_155 terms (from decide_1.pkl pool)
G, dec, pool = pickle.load(open('decide_1.pkl', 'rb'))
mcmc = canon(frozenset(pool[5:23]))
cls = C.defaultdict(C.Counter); budget = {}; nN = C.defaultdict(C.Counter)
for l in open('ok_ana.txt'):
    p = l.split(); i = int(p[0]); lat = p[14].split(',')
    ts = frozenset(int(x, 16) for x in lat if x not in 'TN')
    k = canon(ts)
    cls[k][srcs[i]] += 1
    c = 9 if p[6][8:] else 8  # blocks string length = c
    c = len(p[6]); budget.setdefault(k, C.Counter())[(c, int(p[5]), int(p[4]))] += 1
    nN[k][sum(1 for x in lat if x == 'N')] += 1
print('term-set classes', len(cls), ' (MCMC class present:', mcmc in cls, ')')
ids = {k: n for n, k in enumerate(sorted(cls, key=lambda k: -sum(cls[k].values())))}
single = C.Counter()
for k in sorted(cls, key=lambda k: -sum(cls[k].values())):
    tot = sum(cls[k].values()); who = sorted(cls[k])
    if len(who) == 1: single[who[0]] += 1
    if ids[k] < 40:
        print('class %3d size %6d nterms %2d budgets %s srcs %s N-cols %s%s' % (ids[k], tot, len(k), dict(budget[k]), dict(cls[k]), dict(nN[k]), '  <= MCMC class' if k == mcmc else ''))
print('classes found by ONE source only:', dict(single))
print('classes per source:', dict(C.Counter(s for k in cls for s in cls[k])))
pickle.dump((dict(cls), budget, ids), open('classes.pkl', 'wb'))
