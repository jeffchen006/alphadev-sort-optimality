"""Stochastic local search for a relaxed DAG (no T) computing output j of sort-n at depth <= D
(upper-bound search only; a found DAG is compiled by lsched and judge-checked).
Layered DAG: layer-1 flags = input comparisons; layer l >= 2 value nodes sel(flag < l, a < l, b < l);
layer l >= 3 flag nodes cmp(value <= l-1, value <= l-1); root = value node at layer D.
usage: python3 rdls.py n j D [--width 10] [--iters 2000000] [--seed 1] [--out tree_file]"""
import sys, os, argparse, random, math
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from prog import weak_orders

ap = argparse.ArgumentParser()
ap.add_argument('n', type=int); ap.add_argument('j', type=int); ap.add_argument('D', type=int)
ap.add_argument('--width', type=int, default=10); ap.add_argument('--iters', type=int, default=2000000)
ap.add_argument('--seed', type=int, default=1); ap.add_argument('--out', default=None)
ap.add_argument('--T0', type=float, default=2.0)
a = ap.parse_args()
n, j, D = a.n, a.j, a.D
rnd = random.Random(a.seed)
W = np.array(weak_orders(n), dtype=np.int8)          # (NW, n) ranks
NW = len(W)
ar = np.arange(NW)
target = np.sort(W, axis=1)[:, j]

# node list: ('v', layer) or ('f', layer); base values = inputs 0..n-1 (layer 0); base flags = (i,k) (layer 1)
vnodes = [('in', i, 0) for i in range(n)]
fnodes = [('cmp1', i, k, 1) for i in range(n) for k in range(n) if i != k]
width = {}
for l in range(2, D + 1):
    width[l] = 1 if l == D else max(2, a.width - 2 * (l - 2))
spec = []   # free nodes in topological order: (kind, layer, index into vnodes/fnodes)
for l in range(2, D + 1):
    for _ in range(width[l]):
        vnodes.append(('sel', l)); spec.append(('v', l, len(vnodes) - 1))
    if 3 <= l < D:
        for _ in range(max(1, width[l] // 2)):
            fnodes.append(('cmp', l)); spec.append(('f', l, len(fnodes) - 1))
vlayer = [x[-1] if x[0] == 'in' else x[1] for x in vnodes]
flayer = [x[-1] if x[0] == 'cmp1' else x[1] for x in fnodes]
root = len(vnodes) - 1

def cands_v(l):
    return [i for i in range(len(vnodes)) if vlayer[i] < l]
def cands_f(l):
    return [i for i in range(len(fnodes)) if flayer[i] < l]
def cands_g(l):
    return [i for i in range(len(vnodes)) if vlayer[i] <= l - 1]

choice = {}
for kind, l, idx in spec:
    if kind == 'v':
        choice[('v', idx)] = [rnd.choice(cands_f(l)), rnd.choice(cands_v(l)), rnd.choice(cands_v(l))]
    else:
        choice[('f', idx)] = [rnd.choice(cands_g(l)), rnd.choice(cands_g(l))]

VAL = [None] * len(vnodes); FL = [None] * len(fnodes)
for i in range(n):
    VAL[i] = np.full(NW, i, dtype=np.int8)
for t, (_, i, k, _) in enumerate(fnodes[:n * (n - 1)]):
    FL[t] = W[:, i] < W[:, k]

def evaluate():
    for kind, l, idx in spec:
        c = choice[(kind, idx)]
        if kind == 'v':
            VAL[idx] = np.where(FL[c[0]], VAL[c[2]], VAL[c[1]])
        else:
            FL[idx] = W[ar, VAL[c[0]]] < W[ar, VAL[c[1]]]
    return int(np.sum(W[ar, VAL[root]] == target))

cur = evaluate()
best = cur
bestc = {k: list(v) for k, v in choice.items()}
for it in range(a.iters):
    T = a.T0 * (1 - it / a.iters) + 0.05
    kind, l, idx = rnd.choice(spec)
    c = choice[(kind, idx)]
    pos = rnd.randrange(len(c))
    old = c[pos]
    if kind == 'v':
        c[pos] = rnd.choice(cands_f(l) if pos == 0 else cands_v(l))
    else:
        c[pos] = rnd.choice(cands_g(l))
    new = evaluate()
    if new >= cur or rnd.random() < math.exp((new - cur) / T):
        cur = new
        if cur > best:
            best = cur; bestc = {k: list(v) for k, v in choice.items()}
            print('it=%d score=%d/%d' % (it, best, NW), flush=True)
            if best == NW:
                break
    else:
        c[pos] = old
choice = bestc
print('final %d/%d' % (best, NW))
if best == NW and a.out:
    def tree_v(i):
        x = vnodes[i]
        if x[0] == 'in':
            return ('in', x[1])
        c = choice[('v', i)]
        return ('sel', tree_f(c[0]), tree_v(c[1]), tree_v(c[2]))
    def tree_f(i):
        x = fnodes[i]
        if x[0] == 'cmp1':
            return ('cmp', ('in', x[1]), ('in', x[2]))
        c = choice[('f', i)]
        return ('cmp', tree_v(c[0]), tree_v(c[1]))
    open(a.out, 'w').write(repr(tree_v(root)) + '\n')
    print('tree saved', a.out)
