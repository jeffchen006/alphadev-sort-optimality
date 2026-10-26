#!/usr/bin/env python3
"""Own simulator (bounds agent) for M(n, R, I0/I1). Checks a program on all weak orders.
mode 'relaxed': scratch = T (+inf), flags = eq.  mode 'strict': random garbage scratch/flags too.
usage: sim.py n file.s
"""
import sys, itertools, random

BIG = float('inf')


def weak_orders(n):
    out = set()
    for t in itertools.product(range(n), repeat=n):
        s = sorted(set(t))
        if s == list(range(len(s))):
            out.add(t)
    return sorted(out)


def parse(text):
    prog = []
    for line in text.splitlines():
        line = line.split('#')[0].strip()
        if not line:
            continue
        op, rest = line.split(None, 1)
        d, s = [x.strip() for x in rest.split(',')]
        prog.append((op, d, s))
    return prog


def run(prog, n, x, scratch_init=None, flags=(False, False)):
    regs = {f'P{i}': x[i] for i in range(n)}
    lt, gt = flags
    get = lambda r: regs.get(r, BIG if scratch_init is None else scratch_init.get(r, BIG))
    for op, d, s in prog:
        if op == 'mov':
            regs[d] = get(s)
        elif op == 'cmp':
            a, b = get(d), get(s)
            lt, gt = a < b, a > b
        else:
            cond = {'cmovl': lt, 'cmovg': gt, 'cmovle': not gt, 'cmovge': not lt}[op]
            if cond:
                regs[d] = get(s)
    return [get(f'P{j}') for j in range(n)]


def check(prog, n, strict=False, trials=20):
    for e in weak_orders(n):
        x = [10 * v for v in e]
        if run(prog, n, x) != sorted(x):
            return False, e
        if strict:
            regs = {r for _, d, s in prog for r in (d, s) if r.startswith('S')}
            for _ in range(trials):
                g = {r: random.choice([-1, 5, 15, 25, 35, 45, 99]) for r in regs}
                fl = random.choice([(False, False), (True, False), (False, True)])
                if run(prog, n, x, g, fl) != sorted(x):
                    return False, ('strict', e, g, fl)
    return True, None


def counts(prog):
    c = {'cmp': 0, 'cmov': 0, 'mov': 0}
    for op, _, _ in prog:
        c['cmov' if op.startswith('cmov') else op] += 1
    return c


if __name__ == '__main__':
    n = int(sys.argv[1])
    prog = parse(open(sys.argv[2]).read())
    print(len(prog), counts(prog), 'relaxed', check(prog, n), 'strict', check(prog, n, strict=True))
