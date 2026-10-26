#!/usr/bin/env python3
"""critic: turn a bf.cpp SAT path (log) into a model=out program file: r0..r{n-1} -> P_i, 'new' -> fresh S_j,
then place 'out j, R' at the first (reg, time) that holds sort_j on all weak orders (relaxed run, S = T)."""
import sys, re, itertools
log, n, iset, out = sys.argv[1], int(sys.argv[2]), sys.argv[3], sys.argv[4]
lines = open(log).read().split('\n')
i = max(k for k, l in enumerate(lines) if ' SAT ' in l and not 'UNSAT' in l)
path = [l.strip() for l in lines[i+1:] if l.startswith('  ')]
names = [f'P{j}' for j in range(n)]; prog = []; ns = 0
def nm(t):
    global ns
    if t == 'new': names.append(f'S{ns}'); ns += 1; return names[-1]
    if t == 'T': raise SystemExit('T source: needs a never-written scratch; not handled')
    return names[int(t[1:])]
for p in path:
    for part in p.split(';'):
        op, rest = part.strip().split(None, 1)
        a, b = [x.strip() for x in rest.split(',')]
        # bf indexes registers in creation order; 'new' is created by this instruction (dst)
        if a == 'new': A = nm('new'); B = names[int(b[1:])] if b != 'T' else nm('T')
        else: A = names[int(a[1:])]; B = names[int(b[1:])]
        prog.append((op, A, B))
wos = sorted({tuple(sorted(set(r)).index(v) for v in r) for r in itertools.product(range(n), repeat=n)})
BIG = 99
def run(x):
    R = {f'P{j}': x[j] for j in range(n)}; fl = 0; hist = [dict(R)]
    for op, a, b in prog:
        g = lambda r: R.get(r, BIG)
        if op == 'mov': R[a] = g(b)
        elif op == 'cmp': fl = (g(a) > g(b)) - (g(a) < g(b))
        elif {'cmovl': fl < 0, 'cmovg': fl > 0, 'cmovle': fl <= 0, 'cmovge': fl >= 0}[op]: R[a] = g(b)
        hist.append(dict(R))
    return hist
H = {x: run(x) for x in wos}
outs = {}
for j in range(n):
    for t in range(len(prog) + 1):
        regs = sorted({r for x in wos for r in H[x][t]})
        hit = [r for r in regs if all(H[x][t].get(r, BIG) == sorted(x)[j] for x in wos)]
        if hit: outs[j] = (t, hit[0]); break
assert len(outs) == n, outs
with open(out, 'w') as f:
    f.write(f'# n={n} iset={iset} model=out source=critic/bf.cpp ({log}) k={len(prog)}\n')
    for j, (t, r) in outs.items():
        if t == 0: f.write(f'out {j}, {r}\n')
    for t, (op, a, b) in enumerate(prog, 1):
        f.write(f'{op} {a}, {b}\n')
        for j, (tt, r) in outs.items():
            if tt == t: f.write(f'out {j}, {r}\n')
print(open(out).read())
