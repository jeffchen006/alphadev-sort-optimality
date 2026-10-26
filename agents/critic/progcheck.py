#!/usr/bin/env python3
"""critic: own checker for MODEL.md §5 program files (Intel order, dest first).
Strict check: all weak orders; every scratch garbage from {-inf-ish, between values, equal to values, +big};
initial flags lt/gt/eq. Output: P_j = j-th smallest at the end (MODEL v0) and also 'snapshot' info.
usage: progcheck.py file.s [n]"""
import sys, re, itertools, random
f = sys.argv[1]
prog = []
n = None
for line in open(f):
    m = re.search(r'n=(\d+)', line)
    if line.lstrip().startswith('#'):
        if m and n is None: n = int(m.group(1))
        continue
    line = line.split('#')[0].strip()
    if not line: continue
    op, rest = line.split(None, 1)
    a, b = [x.strip() for x in rest.split(',')]
    assert op in ('mov', 'cmp', 'cmovl', 'cmovg', 'cmovle', 'cmovge', 'out'), op
    prog.append((op, a, b))
if len(sys.argv) > 2: n = int(sys.argv[2])
regs = sorted({x for o, a, b in prog for x in ((b,) if o == 'out' else (a, b))})
scr = [r for r in regs if r.startswith('S')]
def wo(n):
    s = set()
    for r in itertools.product(range(n), repeat=n):
        u = sorted(set(r)); s.add(tuple(u.index(v) for v in r))
    return sorted(s)
def run(x, garb, fl):
    R = {f'P{i}': x[i] for i in range(n)}
    R.update(garb)
    flag = fl
    outs = {}
    for op, a, b in prog:
        if op == 'out': outs[int(a)] = R[b]
        elif op == 'mov': R[a] = R[b]
        elif op == 'cmp': flag = (R[a] > R[b]) - (R[a] < R[b])
        else:
            c = {'cmovl': flag < 0, 'cmovg': flag > 0, 'cmovle': flag <= 0, 'cmovge': flag >= 0}[op]
            if c: R[a] = R[b]
    return [outs.get(j, R[f'P{j}']) for j in range(n)]
gvals = [-10] + [v + 0.5 for v in range(-1, n)] + list(range(n)) + [10**9]
random.seed(1)
bad = 0; tests = 0
for x in wo(n):
    want = sorted(x)
    gs = [{s: g for s in scr} for g in gvals] + [{s: random.choice(gvals) for s in scr} for _ in range(60)]
    for g in gs:
        for fl in (-1, 0, 1):
            tests += 1
            if run(x, g, fl) != want: bad += 1
ops = [o for o, _, _ in prog if o != 'out']
prog_len = len(ops)
print(f'{f}: n={n} len={prog_len} counts={ {o: ops.count(o) for o in sorted(set(ops))} } regs={len(regs)} tests={tests} fails={bad} -> {"CORRECT" if bad == 0 else "WRONG"}')
