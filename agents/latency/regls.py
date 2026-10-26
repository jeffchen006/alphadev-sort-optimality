"""Register-level local search (upper bounds): a length-k I1 program over n+m registers whose snapshot
outputs (any register, any step) have depth <= D in model U (or E) and are correct on all weak orders
(relaxed: scratch = T, flags = eq).  A find is judge-checked (strict) by the caller.
usage: python3 regls.py n k D [--m 4] [--model U] [--iters 2e6] [--seed 1] [--out f.s] [--init f.s]"""
import sys, os, argparse, random, math
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from prog import weak_orders, check, depth as pdepth, LAT

ap = argparse.ArgumentParser()
ap.add_argument('n', type=int); ap.add_argument('k', type=int); ap.add_argument('D', type=int)
ap.add_argument('--m', type=int, default=4); ap.add_argument('--model', default='U')
ap.add_argument('--iters', type=float, default=2e6); ap.add_argument('--seed', type=int, default=1)
ap.add_argument('--out', default=None); ap.add_argument('--T0', type=float, default=3.0)
a = ap.parse_args()
n, k, D, m = a.n, a.k, a.D, a.m
R = n + m
rnd = random.Random(a.seed)
W = np.array(weak_orders(n), dtype=np.int16)
NW = len(W)
ar = np.arange(NW)
TV = n                                   # index of T
RK = np.concatenate([W, np.full((NW, 1), 100, dtype=np.int16)], axis=1)   # rank of value index, T = 100
target = np.sort(W, axis=1)              # (NW, n)
OPS = ['mov', 'cmp', 'cmovl', 'cmovg', 'cmovle', 'cmovge']
movlat = 1 if a.model == 'U' else 0

def rand_ins():
    op = rnd.choice(OPS)
    d = rnd.randrange(R); s = rnd.randrange(R)
    while s == d:
        s = rnd.randrange(R)
    return [op, d, s]

prog = [rand_ins() for _ in range(k)]

def score(prog):
    vals = np.zeros((R, NW), dtype=np.int16)
    for i in range(n):
        vals[i] = i
    vals[n:] = TV
    dep = [0] * R
    lt = np.zeros(NW, bool); gt = np.zeros(NW, bool); fd = 0
    best = np.zeros(n, dtype=np.int64)
    def snap():
        for r in range(R):
            if dep[r] <= D:
                rr = RK[ar, vals[r]]
                for j in range(n):
                    c = int(np.sum(rr == target[:, j]))
                    if c > best[j]:
                        best[j] = c
    snap()
    for op, d, s in prog:
        if op == 'mov':
            vals[d] = vals[s]; dep[d] = dep[s] + movlat
        elif op == 'cmp':
            a_, b_ = RK[ar, vals[d]], RK[ar, vals[s]]
            lt = a_ < b_; gt = a_ > b_; fd = max(dep[d], dep[s]) + 1
        else:
            cond = {'cmovl': lt, 'cmovg': gt, 'cmovle': ~gt, 'cmovge': ~lt}[op]
            vals[d] = np.where(cond, vals[s], vals[d]); dep[d] = max(dep[d], dep[s], fd) + 1
        snap()
    return int(best.sum())

goal = n * NW
cur = score(prog); bestv = cur; bestp = [list(x) for x in prog]
iters = int(a.iters)
for it in range(iters):
    T = a.T0 * (1 - it / iters) + 0.05
    i = rnd.randrange(k)
    old = list(prog[i])
    r = rnd.random()
    if r < 0.4:
        prog[i] = rand_ins()
    elif r < 0.7:
        prog[i][0] = rnd.choice(OPS)
    else:
        f = rnd.choice([1, 2]); prog[i][f] = rnd.randrange(R)
        if prog[i][1] == prog[i][2]:
            prog[i] = old
            continue
    new = score(prog)
    if new >= cur or rnd.random() < math.exp((new - cur) / T):
        cur = new
        if cur > bestv:
            bestv = cur; bestp = [list(x) for x in prog]
            print('it=%d score=%d/%d' % (it, bestv, goal), flush=True)
            if bestv == goal:
                break
    else:
        prog[i] = old
print('final %d/%d' % (bestv, goal), flush=True)
if bestv == goal and a.out:
    # rebuild snapshots: first (t, r) with depth <= D and correct value for each output
    names = ['P%d' % i for i in range(n)] + ['S%d' % i for i in range(m)]
    vals = np.zeros((R, NW), dtype=np.int16)
    for i in range(n):
        vals[i] = i
    vals[n:] = TV
    dep = [0] * R; lt = gt = np.zeros(NW, bool); fd = 0
    outs = {}
    lines = []
    def snap():
        for r in range(R):
            if dep[r] <= D:
                rr = RK[ar, vals[r]]
                for j in range(n):
                    if j not in outs and np.all(rr == target[:, j]):
                        outs[j] = r; lines.append('out %d, %s' % (j, names[r]))
    snap()
    for op, d, s in bestp:
        lines.append('%s %s, %s' % (op, names[d], names[s]))
        if op == 'mov':
            vals[d] = vals[s]; dep[d] = dep[s] + movlat
        elif op == 'cmp':
            a_, b_ = RK[ar, vals[d]], RK[ar, vals[s]]
            lt = a_ < b_; gt = a_ > b_; fd = max(dep[d], dep[s]) + 1
        else:
            cond = {'cmovl': lt, 'cmovg': gt, 'cmovle': ~gt, 'cmovge': ~lt}[op]
            vals[d] = np.where(cond, vals[s], vals[d]); dep[d] = max(dep[d], dep[s], fd) + 1
        snap()
    with open(a.out, 'w') as f:
        f.write('# n=%d R=%d iset=I1 model=out source=latency/regls.py k=%d D=%d latmodel=%s (strict check: judge)\n' % (n, R, k, D, a.model))
        f.write('\n'.join(lines) + '\n')
    print('saved', a.out)
