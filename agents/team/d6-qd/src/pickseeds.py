#!/usr/bin/env python3
"""pick diverse seeds: per semantic skeleton, up to PER programs with distinct (m, block pattern). Usage: desc.txt PER out.s"""
import sys, gzip, random
desc, per, outf = sys.argv[1], int(sys.argv[2]), sys.argv[3]
random.seed(7)
by = {}
for line in open(desc):
    i, c, m, v, blk, sh = line.split()
    by.setdefault(sh, {}).setdefault((m, blk), []).append(int(i))
pick = set()
for sh, d in by.items():
    keys = list(d); random.shuffle(keys)
    for k in keys[:per]:
        pick.add(random.choice(d[k]))
idx, out, keep = -1, open(outf, 'w'), False
for line in gzip.open('../../upper/runs/r4/s5k32_coll.txt.gz', 'rt'):
    if line.startswith('# prog'):
        idx += 1; keep = idx in pick
        if keep: out.write('# prog len=32 idx=%d\n' % idx)
        continue
    if keep and not line.startswith('out'):
        out.write(line)
print(len(by), 'skeletons', len(pick), 'seeds')
