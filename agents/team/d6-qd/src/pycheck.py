#!/usr/bin/env python3
"""Independent strict checker (plain ints, no UNK abstraction).
Runs a .s program on all inputs in {0..n-1}^n (covers all weak order types), scaled/shifted,
with many garbage choices for scratch registers and all 3 initial flag states.
Models: P (outputs P_j), free (outputs = registers named in header 'outputs:'), mem (outputs M_j).
Usage: pycheck.py file.s n model
"""
import itertools, random, re, sys

def parse(fn):
    prog, outs = [], None
    for line in open(fn):
        if 'outputs:' in line:
            outs = [t.split('=')[-1] for t in line.split('outputs:')[1].split()]
        line = line.split('#')[0].strip()
        if not line:
            continue
        op, rest = line.split(None, 1)
        d, s = [x.strip() for x in rest.split(',')]
        prog.append((op, d, s))   # 'out j, R' kept as op 'out'
    return prog, outs

COND = {'cmovl': ('l',), 'cmovg': ('g',), 'cmovle': ('l', 'e'), 'cmovge': ('g', 'e'), 'cmove': ('e',), 'cmovne': ('l', 'g')}

def run(prog, init, flag):
    r = dict(init)
    for op, d, s in prog:
        if op == 'out':
            r['OUT%s' % d] = r[s]
        elif op == 'mov':
            r[d] = r[s]
        elif op == 'cmp':
            a, b = r[d], r[s]
            flag = 'l' if a < b else 'g' if a > b else 'e'
        elif op == 'xchg':
            r[d], r[s] = r[s], r[d]
        elif op in COND:
            if flag in COND[op]:
                r[d] = r[s]
        else:
            raise ValueError(op)
    return r

def main():
    fn, n, model = sys.argv[1], int(sys.argv[2]), sys.argv[3]
    prog, outs = parse(fn)
    if model == 'P':
        outs = ['P%d' % j for j in range(n)]
    elif model == 'mem':
        outs = ['P%d' % j for j in range(n)]   # judge convention: P = memory
    elif model == 'out':
        outs = ['OUT%d' % j for j in range(n)]
    pre = 'P'
    regs = set(x for op, d, s in prog for x in (d, s) if op != 'out')
    scratch = sorted(x for x in regs if x[0] == 'S')
    rng = random.Random(1)
    BIG = 2**31 - 1
    bad = 0
    tests = 0
    for xs in itertools.product(range(n), repeat=n):
        for scale, shift in ((1, 0), (7, -10)):
            vals = [v * scale + shift for v in xs]
            garb = [[-BIG - 1] * len(scratch), [BIG] * len(scratch)]
            garb += [[rng.randint(-20, 20) for _ in scratch] for _ in range(4)]
            garb += [[vals[rng.randrange(n)] for _ in scratch] for _ in range(2)]
            for g in garb:
                for fl in 'lge':
                    init = {'%s%d' % (pre, i): vals[i] for i in range(n)}
                    init.update({'OUT%d' % i: vals[i] for i in range(n)})   # no 'out j' -> final Pj (approx: start)
                    init.update(zip(scratch, g))
                    r = run(prog, init, fl)
                    tests += 1
                    if [r[o] for o in outs] != sorted(vals):
                        bad += 1
    print('%s: n=%d model=%s len=%d runs=%d failures=%d -> %s' % (fn, n, model, len(prog), tests, bad, 'OK' if bad == 0 else 'FAIL'))
    sys.exit(1 if bad else 0)

main()
