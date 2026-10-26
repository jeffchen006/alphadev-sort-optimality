#!/usr/bin/env python3
"""Statistics of collected programs (blocks '# prog len=..'). For each program: c=#cmp, m=#cmov, v=#mov,
x=#xchg; cmov-per-block = cmovs after each cmp until the next cmp (block 0 = before the first cmp, reported apart).
Usage: stats.py file1_coll.txt [...]"""
import sys, collections
progs, cur = [], None
for fn in sys.argv[1:]:
    for line in open(fn):
        if line.startswith('# prog'):
            cur = []; progs.append(cur)
        elif line.strip() and not line.startswith('#') and not line.startswith('out'):
            cur.append(line.split()[0])
cmv = collections.Counter(); blocks = collections.Counter(); minblock = collections.Counter(); pre = collections.Counter()
lens = collections.Counter(); ops = collections.Counter(); movpos = collections.Counter()
for p in progs:
    c = p.count('cmp'); m = sum(op.startswith('cmov') for op in p); v = p.count('mov'); x = p.count('xchg')
    lens[len(p)] += 1; cmv[(len(p), c, m, v) + ((x,) if x else ())] += 1
    for op in p: ops[op] += 1
    bl, b0, k = [], 0, None
    for op in p:
        if op == 'cmp':
            if k is not None: bl.append(k)
            k = 0
        elif op.startswith('cmov'):
            if k is None: b0 += 1
            else: k += 1
    if k is not None: bl.append(k)
    blocks[tuple(sorted(bl))] += 1; minblock[min(bl)] += 1; pre[b0] += 1
print('programs:', len(progs), ' lengths:', dict(sorted(lens.items())))
print('(k, c, m, v[, xchg]) : count')
for key, cnt in sorted(cmv.items()): print('  %s : %d' % (key, cnt))
print('min cmov per block : count', dict(sorted(minblock.items())))
print('cmov before first cmp : count', dict(sorted(pre.items())))
print('sorted cmov-per-block vectors (top 15):')
for key, cnt in blocks.most_common(15): print('  %s : %d' % (key, cnt))
print('opcode totals:', dict(ops))
