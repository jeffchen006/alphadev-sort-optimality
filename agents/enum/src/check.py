#!/usr/bin/env python3
"""enum's own program checker (independent of shared/judge.py and agents/sat).

usage: python3 check.py FILE.s [--iset I0|I1]
Model: MODEL.md §1 + §4.3 (pseudo-instruction `out j, R`: output j = value of R at the last `out j`, else final Pj).
Checks:
  relaxed: all weak order types of the n inputs, scratch = T (larger than all inputs), flags = eq.
  strict : registers read before written ("garbage") get their own values; all weak orders of inputs+garbage;
           all 4 initial x86 flag states (zf, lt) in {(1,0),(0,1),(0,0),(1,1)}.
Prints PASS/FAIL, length k (outs not counted), number of registers.
"""
import itertools, re, sys

def weak_orders(m):
    """all dense-rank vectors of length m"""
    for r in itertools.product(range(m), repeat=m):
        k = max(r) + 1
        if set(r) == set(range(k)):
            yield r

def parse(path):
    hdr, prog = {}, []
    for line in open(path):
        if line.startswith('#') and not prog:
            hdr.update(re.findall(r'(\w+)=(\S+)', line))
        code = line.split('#', 1)[0].strip()
        if not code:
            continue
        m = re.fullmatch(r'(\w+)\s+(\w+)\s*,\s*(\w+)', code)
        if not m:
            raise SystemExit('cannot parse: %r' % code)
        prog.append(m.groups())
    return hdr, prog

COND = {'cmovl': lambda zf, lt: lt, 'cmovle': lambda zf, lt: zf or lt,
        'cmovg': lambda zf, lt: (not zf) and (not lt), 'cmovge': lambda zf, lt: not lt}

def run(prog, regs, flags):
    regs = dict(regs); zf, lt = flags; outs = {}
    for op, a, b in prog:
        if op == 'out':
            outs[int(a)] = regs[b]
        elif op == 'mov':
            regs[a] = regs[b]
        elif op == 'cmp':
            zf, lt = regs[a] == regs[b], regs[a] < regs[b]
        else:
            if COND[op](zf, lt):
                regs[a] = regs[b]
    return regs, outs

def main():
    path = sys.argv[1]
    iset = sys.argv[sys.argv.index('--iset') + 1] if '--iset' in sys.argv else None
    hdr, prog = parse(path)
    n = int(hdr['n']); iset = iset or hdr.get('iset', 'I1')
    allowed = {'mov', 'cmp', 'cmovl', 'cmovg', 'out'} | ({'cmovle', 'cmovge'} if iset == 'I1' else set())
    for op, a, b in prog:
        if op not in allowed:
            raise SystemExit('FAIL opcode %s not in %s' % (op, iset))
    names = sorted({x for op, a, b in prog for x in ((b,) if op == 'out' else (a, b))} | {'P%d' % i for i in range(n)})
    k = sum(op != 'out' for op, _, _ in prog)
    # garbage registers: scratch read before written
    written, garbage = {'P%d' % i for i in range(n)}, []
    for op, a, b in prog:
        reads = [b] if op in ('mov', 'out') else [a, b]
        for r in reads:
            if r not in written and r not in garbage:
                garbage.append(r)
        if op != 'cmp' and op != 'out':
            written.add(a)
    def check(vals, scratch, flags):
        regs = {r: scratch.get(r, None) for r in names}
        for i in range(n):
            regs['P%d' % i] = vals[i]
        fin, outs = run(prog, regs, flags)
        got = [outs.get(j, fin['P%d' % j]) for j in range(n)]
        return got == sorted(vals)
    T = 10 ** 6
    for w in weak_orders(n):
        if not check(w, {r: T for r in names}, (False, False) if False else (True, False)):
            print('FAIL relaxed: order type', w); return 1
    ng = len(garbage)
    for w in weak_orders(n + ng):
        scr = {r: w[n + i] for i, r in enumerate(garbage)}
        for fl in [(True, False), (False, True), (False, False), (True, True)]:
            if not check(w[:n], scr, fl):
                print('FAIL strict: inputs', w[:n], 'garbage', scr, 'flags(zf,lt)', fl); return 1
    print('PASS %s n=%d k=%d registers=%d garbage-read=%s iset=%s' % (path, n, k, len(names), garbage, iset))
    return 0

if __name__ == '__main__':
    sys.exit(main())
