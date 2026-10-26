#!/usr/bin/env python3
# d7: print one program (index N in collection) with the lattice term in each register after each step.
# term notation: lattice polynomial, e.g. 0v1^2 means max(x0, min(x1,x2))... printed as minimal sets: "01|2" = max(min(x0,x1),x2)
import sys, gzip, itertools
COLL = '/path/to/repo/agents/upper/runs/r4/s5k32_coll.txt.gz'
def progs(fn):
    cur = None
    op = gzip.open if fn.endswith('.gz') else open
    for line in op(fn, 'rt'):
        if line.startswith('# prog') or line.startswith('# n='):
            if cur: yield cur
            cur = []
        elif line.strip() and not line.startswith('#'):
            cur.append(line.split('#')[0].strip())
    if cur: yield cur
# simulate over 0/1 inputs (32 subsets) + garbage None; enough to name lattice terms (judge checks correctness)
def run(prog):
    regs = {}
    for i in range(5): regs['P%d' % i] = [(S >> i) & 1 for S in range(32)]
    flags = [None] * 32
    rows = []
    for ins in prog:
        o, a = ins.split(None, 1); a = [x.strip() for x in a.split(',')]
        if o == 'out':
            rows.append((ins, a[1], regs.get(a[1]))); continue
        d, s = a
        D = regs.get(d, [None] * 32); Sv = regs.get(s, [None] * 32)
        if o == 'mov': regs[d] = list(Sv)
        elif o == 'cmp':
            flags = [None if D[k] is None or Sv[k] is None else (D[k] > Sv[k]) - (D[k] < Sv[k]) for k in range(32)]
        else:
            cond = {'cmovl': (-1,), 'cmovle': (-1, 0), 'cmovg': (1,), 'cmovge': (1, 0)}[o]
            nv = []
            for k in range(32):
                fl = flags[k]
                if fl is None: nv.append(D[k] if D[k] == Sv[k] else None)
                else: nv.append(Sv[k] if fl in cond else D[k])
            regs[d] = nv
        rows.append((ins, d, regs.get(d)))
    return rows
def name(col):
    if col is None: return '?'
    if any(v is None for v in col[1:31]): return 'T(' + ''.join('x' if v is None else str(v) for v in col) + ')'
    fam = [S for S in range(1, 32) if col[S] == 1]
    mins = [S for S in fam if not any(U != S and (U & S) == U for U in fam)]
    return '|'.join(''.join(str(i) for i in range(5) if S >> i & 1) for S in sorted(mins, key=lambda S: (bin(S).count('1'), S)))
if __name__ == '__main__':
    n = int(sys.argv[1]); fn = sys.argv[2] if len(sys.argv) > 2 else COLL
    for i, p in enumerate(progs(fn)):
        if i == n:
            for ins, d, col in run(p): print('%-18s %s = %s' % (ins, d, name(col)))
            break
