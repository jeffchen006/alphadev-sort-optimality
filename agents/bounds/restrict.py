#!/usr/bin/env python3
"""Idea 1 (board/SORT5_IDEAS.md): restrict a sort-n M_out program to inputs where x_i is the MAX, simplify, and measure
d_i = k - k'_i (k' = length of the simplified sort-(n-1) program). Model: M_out, I1, T-relaxed, permutations.
In the restricted program x_i plays the role of T (+inf); the result is verified on all (n-1)! permutations with
x_i replaced by T (cmp(x_i, T) differs: lt vs eq, so verification is needed). Also the MIN restriction (x_i = -inf,
a constant our model does not have: reported, not usable for the bound as is).
usage: restrict.py n FILE [--max-progs N]   (FILE: '# prog' blocks or one .s program)
"""
import sys, itertools

BIG = 10 ** 6


def parse_blocks(path, limit=None):
    progs, cur = [], None
    for line in open(path):
        s = line.split('#')[0].strip()
        if line.startswith('# prog') or (cur is None and s):
            if cur:
                progs.append(cur)
                if limit and len(progs) >= limit:
                    return progs
            cur = []
        if s:
            o, rest = s.split(None, 1)
            a, b = [x.strip() for x in rest.split(',')]
            cur.append((o, a, b))
    if cur:
        progs.append(cur)
    return progs


def cond(o, lt, gt):
    return {'cmovl': lt, 'cmovg': gt, 'cmovle': not gt, 'cmovge': not lt}[o]


def simulate(prog, n, perms, val):
    """returns per-instruction info: cmp outcome tuple / cmov fire tuple, and per-instruction register snapshots."""
    regs = [dict() for _ in perms]
    for q, p in enumerate(perms):
        for i in range(n):
            regs[q][f'P{i}'] = i
    flags = [(False, False)] * len(perms)
    info = []
    get = lambda q, r: regs[q].get(r, 'T')
    for o, a, b in prog:
        if o == 'out':
            info.append(None)
            continue
        if o == 'cmp':
            out = []
            for q, p in enumerate(perms):
                x, y = val(p, get(q, a)), val(p, get(q, b))
                flags[q] = (x < y, x > y)
                out.append((x < y) - (x > y))
            info.append(('cmp', tuple(out)))
        elif o == 'mov':
            for q in range(len(perms)):
                regs[q][a] = get(q, b)
            info.append(('mov', None))
        else:
            fire = []
            for q in range(len(perms)):
                f = cond(o, *flags[q])
                fire.append(f)
                if f:
                    regs[q][a] = get(q, b)
            info.append(('cmov', tuple(fire)))
    return info


def reduce(prog, n, i, mode='max'):
    others = [j for j in range(n) if j != i]
    perms = [p for p in itertools.permutations(range(n)) if p[i] == (n - 1 if mode == 'max' else 0)]
    val = lambda p, s: BIG if s == 'T' else p[s]
    info = simulate(prog, n, perms, val)
    drop_out = n - 1 if mode == 'max' else 0
    # 1. fixed cmps, constant cmovs
    new = []
    for (ins, inf) in zip(prog, info):
        o, a, b = ins
        if o == 'out':
            if int(a) != drop_out:
                new.append(ins)
            continue
        if o == 'cmp':
            new.append(('cmp', a, b) if len(set(inf[1])) > 1 else ('fixedcmp', a, b))
        elif o == 'mov':
            new.append(ins)
        else:
            fs = set(inf[1])
            if fs == {True}:
                new.append(('mov', a, b))
            elif fs == {False}:
                pass
            else:
                new.append(ins)
    # 2. dead code elimination (backward liveness)
    while True:
        live = set()
        flags_live = False
        keep = [False] * len(new)
        for t in range(len(new) - 1, -1, -1):
            o, a, b = new[t]
            if o == 'out':
                keep[t] = True
                live.add(b)
            elif o in ('cmp', 'fixedcmp'):
                if o == 'cmp' and flags_live:
                    keep[t] = True
                    live.add(a); live.add(b)
                flags_live = False
            elif o == 'mov':
                if a in live:
                    keep[t] = True
                    live.discard(a); live.add(b)
            else:
                if a in live:
                    keep[t] = True
                    live.add(b); flags_live = True
        nn = [x for x, k in zip(new, keep) if k]
        if len(nn) == len(new):
            break
        new = nn
    # 3. copy coalescing: 'mov D,S' where S is never mentioned later -> delete, rename D to S afterwards
    changed = True
    while changed:
        changed = False
        for t, (o, a, b) in enumerate(new):
            if o == 'mov' and all(b not in (x, y) for (oo, x, y) in new[t + 1:]):
                new = new[:t] + [(oo, b if x == a else x, b if y == a else y) for (oo, x, y) in new[t + 1:]]
                changed = True
                break
    # rename: x_i register becomes a scratch holding T; other P's become inputs 0..n-2
    ren = {f'P{j}': f'P{r}' for r, j in enumerate(others)}
    ren[f'P{i}'] = 'SX'
    red = []
    for o, a, b in new:
        if o == 'out':
            j = int(a) - (1 if mode == 'min' else 0)
            red.append(('out', str(j), ren.get(b, b)))
        else:
            red.append((o, ren.get(a, a), ren.get(b, b)))
    return red


def check(red, m, mode='max'):
    """verify the reduced program sorts all m! permutations (x_i -> T for max; -> -inf for min)."""
    for p in itertools.permutations(range(m)):
        regs = {f'P{j}': p[j] for j in range(m)}
        regs['SX'] = BIG if mode == 'max' else -BIG
        lt = gt = False
        outs = {}
        get = lambda r: regs.get(r, BIG)
        for o, a, b in red:
            if o == 'out':
                outs[int(a)] = get(b)
            elif o == 'cmp':
                x, y = get(a), get(b)
                lt, gt = x < y, x > y
            elif o == 'mov':
                regs[a] = get(b)
            else:
                if cond(o, lt, gt):
                    regs[a] = get(b)
        for j in range(m):
            if j not in outs:
                outs[j] = regs.get(f'P{j}')
        if [outs[j] for j in range(m)] != sorted(p):
            return False
    return True


def length(prog):
    return sum(1 for o, _, _ in prog if o != 'out')


if __name__ == '__main__':
    n = int(sys.argv[1]); path = sys.argv[2]
    lim = int(sys.argv[sys.argv.index('--max-progs') + 1]) if '--max-progs' in sys.argv else None
    progs = parse_blocks(path, lim)
    from collections import Counter
    hist = {m: Counter() for m in ('max', 'min')}
    bad = Counter()
    for P in progs:
        k = length(P)
        for mode in ('max', 'min'):
            ds = []
            for i in range(n):
                red = reduce(P, n, i, mode)
                if not check(red, n - 1, mode):
                    bad[mode] += 1
                    ds.append(None)
                    continue
                ds.append(k - length(red))
            good = [d for d in ds if d is not None]
            if good:
                hist[mode][(max(good), min(good), sum(good))] += 1
    print(f'{len(progs)} programs, n={n}; failed verifications: {dict(bad)}')
    for mode in ('max', 'min'):
        print(mode, 'restriction: (max_i d_i, min_i d_i, sum_i d_i): count')
        for key, c in sorted(hist[mode].items()):
            print('  ', key, c)
