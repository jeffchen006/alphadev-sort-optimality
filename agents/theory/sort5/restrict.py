#!/usr/bin/env python3
"""Idea 1 experiment: restrict a sort-n RS program (model=out file) to inputs where x_i is the max (or min),
then greedily delete instructions while outputs 0..n-2 (max case) / 1..n-1 (min case) stay correct on the restriction.
Prints the reduced length per restriction. Relaxed semantics (scratch = T > all, flags eq), strict permutations only.
usage: restrict.py FILE [n]"""
import sys, itertools
sys.path.insert(0, __file__.rsplit('/', 2)[0])
import check

def items(path):
    out, cur = [], []
    for line in open(path):
        l = line.split('#')[0].strip()
        if not l: continue
        op, rest = l.split(None, 1); a = [x.strip() for x in rest.split(',')]
        out.append(('out', int(a[0]), a[1]) if op == 'out' else (op, a[0], a[1]))
    return out

def run(seq, x, n):
    INF = 10**9; regs = {}; f = 'eq'; outs = {}
    val = lambda r: regs.get(r, x[int(r[1:])] if r[0] == 'P' else INF)
    for it in seq:
        op = it[0]
        if op == 'out': outs[it[1]] = val(it[2]); continue
        _, d, s = it
        if op == 'mov': regs[d] = val(s)
        elif op == 'cmp': a, b = val(d), val(s); f = 'lt' if a < b else 'gt' if a > b else 'eq'
        elif f in check.COND[op]: regs[d] = val(s)
    return outs

def ok(seq, tests, want):
    for x in tests:
        o = run(seq, x, len(x)); srt = sorted(x)
        if any(o.get(j) != srt[j] for j in want): return False
    return True

def reduce(seq, tests, want):
    seq = list(seq); changed = True
    while changed:
        changed = False
        for t in range(len(seq)):
            if seq[t][0] == 'out': continue
            cand = seq[:t] + seq[t+1:]
            if ok(cand, tests, want): seq = cand; changed = True; break
        if not changed:  # try: replace cmovX by mov (constant-firing) then retry deletions
            for t in range(len(seq)):
                if seq[t][0] in check.COND:
                    cand = seq[:t] + [('mov', seq[t][1], seq[t][2])] + seq[t+1:]
                    if ok(cand, tests, want) and any(ok(cand[:u] + cand[u+1:], tests, want) for u in range(len(cand)) if cand[u][0] != 'out'):
                        seq = cand; changed = True; break
    return seq

def main():
    path = sys.argv[1]; seq = items(path)
    n = int(sys.argv[2]) if len(sys.argv) > 2 else 1 + max(it[1] for it in seq if it[0] == 'out')
    k = sum(1 for it in seq if it[0] != 'out')
    perms = list(itertools.permutations(range(n)))
    res = []
    for i in range(n):
        for kind in ('max', 'min'):
            r = n - 1 if kind == 'max' else 0
            tests = [p for p in perms if p[i] == r]
            want = [j for j in range(n) if j != r]
            red = reduce(seq, tests, want)
            res.append((i, kind, sum(1 for it in red if it[0] != 'out')))
    print(path.split('/')[-1], 'k=%d' % k, ' '.join('%d%s:%d' % (i, kind[1], kk) for i, kind, kk in res),
          '| min reduced=%d (d_max=%d)' % (min(r[2] for r in res), k - min(r[2] for r in res)))

main()
