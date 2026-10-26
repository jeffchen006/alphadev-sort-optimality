#!/usr/bin/env python3
"""critic: independent simulator for AlphaDev AT&T asm in sort_functions_test.cc.
Checks each SortNAlphaDev on all weak orders, counts instructions, and tries
replacing cmovle->cmovl / cmovge->cmovg (does the program stay correct?)."""
import re, itertools, sys
SRC = sys.argv[1] if len(sys.argv) > 1 else '../spec/ext/alphadev/sort_functions_test.cc'
txt = open(SRC).read()
progs = {}
for m in re.finditer(r'void Sort(\d)AlphaDev\(int\* buffer\) \{\s*asm volatile\((.*?)\:', txt, re.S):
    lines = re.findall(r'"([^"]*?)\s*\\n"', m.group(2))
    progs[int(m.group(1))] = [l.strip() for l in lines]

def weak_orders(n):
    out = set()
    for r in itertools.product(range(n), repeat=n):
        s = sorted(set(r))
        out.add(tuple(s.index(v) for v in r))
    return sorted(out)

def parse_op(o):
    o = o.strip()
    if o.startswith('%'): return ('r', o[1:])
    m = re.match(r'(0x[0-9a-f]+|\d*)\(%0\)', o)
    assert m, o
    off = int(m.group(1), 16) if m.group(1).startswith('0x') else int(m.group(1) or 0)
    return ('m', off // 4)

def run(prog, mem, garbage, flags0):
    regs = {}
    flag = flags0  # result of (B - A) sign for AT&T cmp A,B : -1,0,1
    mem = list(mem)
    for ins in prog:
        op, rest = ins.split(None, 1)
        a, b = [parse_op(x) for x in rest.replace('%%', '%').split(',')]
        def get(x):
            if x[0] == 'm': return mem[x[1]]
            return regs.get(x[1], garbage)
        if op == 'mov':
            v = get(a)
            if b[0] == 'm': mem[b[1]] = v
            else: regs[b[1]] = v
        elif op == 'cmp':  # AT&T cmp A,B sets flags of B-A
            x, y = get(b), get(a)
            flag = (x > y) - (x < y)
        else:
            cond = {'cmovl': flag < 0, 'cmovg': flag > 0, 'cmovle': flag <= 0, 'cmovge': flag >= 0}[op]
            assert b[0] == 'r'
            if cond: regs[b[1]] = get(a)
    return mem

def check(prog, n):
    ok = True
    for wo in weak_orders(n):
        for g in (-100, 100):
            for f0 in (-1, 0, 1):
                if run(prog, wo, g, f0) != sorted(wo): ok = False
    return ok

for n, p in sorted(progs.items()):
    if n > 5: continue
    ops = [l.split()[0] for l in p]
    nmem = sum(1 for l in p if '(%0)' in l)
    print(f'sort{n}: len={len(p)} memmovs={nmem} core={len(p)-nmem} ops=' +
          str({o: ops.count(o) for o in sorted(set(ops))}) + f' correct={check(p, n)}')
    # each le/ge replaced individually and all at once
    idx = [i for i, l in enumerate(p) if l.split()[0] in ('cmovle', 'cmovge')]
    rep = lambda l: l.replace('cmovle', 'cmovl').replace('cmovge', 'cmovg')
    allrep = [rep(l) if i in idx else l for i, l in enumerate(p)]
    print(f'   strict (le->l, ge->g) all: correct={check(allrep, n)}; per-line: ' +
          ' '.join(f'{i+1}:{check([rep(l) if j == i else l for j, l in enumerate(p)], n)}' for i in idx))

print('single-deletion test (is any one instruction dead?):')
for n, p in sorted(progs.items()):
    if n > 5: continue
    dead = [i + 1 for i in range(len(p)) if check(p[:i] + p[i+1:], n)]
    print(f'  sort{n}: removable lines = {dead}')
