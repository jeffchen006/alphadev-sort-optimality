#!/usr/bin/env python3
"""Convert an upper 'free' (outputs = registers at end, named in header) or 'P' program into judge formats:
  out : register model + 'out j, R' lines at the end (MODEL.md 4.3), k = core length
  mem : exact AlphaDev model (P = memory): n loads, core, n stores; L = k + 2n
Usage: to_judge.py in.s n iset tag outdir   -> writes <outdir>/upper_<tag>_out.s and _mem.s
"""
import re, sys

fn, n, iset, tag, outdir = sys.argv[1], int(sys.argv[2]), sys.argv[3], sys.argv[4], sys.argv[5]
prog, outs, hdr = [], None, ''
for line in open(fn):
    if line.startswith('#') and not hdr:
        hdr = line.strip()
    if 'outputs:' in line:
        outs = [t.split('=')[-1] for t in line.split('outputs:')[1].split()]
    line = line.split('#')[0].strip()
    if line:
        op, rest = line.split(None, 1)
        d, s = [x.strip() for x in rest.split(',')]
        prog.append((op, d, s))
if outs is None:
    outs = ['P%d' % j for j in range(n)]
k = len(prog)
src = 'upper:%s' % fn.split('/')[-1]
# out format
with open('%s/upper_%s_out.s' % (outdir, tag), 'w') as f:
    f.write('# n=%d R=%d iset=%s model=out source=%s k=%d (AlphaDev L = k+2n = %d)\n' % (n, n + k, iset, src, k, k + 2 * n))
    for op, d, s in prog:
        f.write('%s %s, %s\n' % (op, d, s))
    for j, r in enumerate(outs):
        f.write('out %d, %s\n' % (j, r))
# mem format: register P_i -> S(base+i); scratch S_i -> S_i
maxs = max([int(x[1:]) for _, d, s in prog for x in (d, s) if x[0] == 'S'] + [-1])
base = maxs + 1
ren = lambda x: 'S%d' % (base + int(x[1:])) if x[0] == 'P' else x
lines = ['mov S%d, P%d' % (base + i, i) for i in range(n)]
lines += ['%s %s, %s' % (op, ren(d), ren(s)) for op, d, s in prog]
lines += ['mov P%d, %s' % (j, ren(r)) for j, r in enumerate(outs)]
with open('%s/upper_%s_mem.s' % (outdir, tag), 'w') as f:
    f.write('# n=%d R=%d iset=%s model=mem source=%s L=%d (k=%d)\n' % (n, base + 2 * n, iset, src, len(lines), k))
    f.write('\n'.join(lines) + '\n')
print('k=%d L=%d' % (k, len(lines)))
