#!/usr/bin/env python3
"""x86 agent: re-colour the S registers of a straight-line program with as few registers as possible
(liveness + greedy colouring of the interference graph; a pure renaming of S names, semantics unchanged
for any initial scratch value that is never read -- the tool refuses programs that read an S before writing it).
Usage: regalloc.py IN.s OUT.s"""
import re, sys
lines = open(sys.argv[1]).read().splitlines()
hdr = [l for l in lines if l.startswith('#')]
ins = [re.split(r'[\s,]+', l.split('#')[0].strip()) for l in lines if l.split('#')[0].strip()]
def uses(i):
    op, d, s = i
    u = [s] if op != 'cmp' and op != 'out' else ([d, s] if op == 'cmp' else [s])
    if op.startswith('cmov'): u.append(d)
    return {r for r in u if r[0] == 'S'}
def defs(i):
    op, d, s = i
    return {d} if op in ('mov',) or op.startswith('cmov') else set()
live = set(); lives = []
for i in reversed(ins):
    live = (live - {r for r in defs(i) if r[0] == 'S'}) | uses(i)
    lives.append(set(live))
lives.reverse()
if lives and lives[0]:
    sys.exit('reads S before write: %s' % lives[0])
interf = {}
for k, i in enumerate(ins):
    after = lives[k + 1] if k + 1 < len(ins) else set()
    for d in defs(i):
        if d[0] != 'S': continue
        for r in after | {d}:
            if r != d:
                interf.setdefault(d, set()).add(r); interf.setdefault(r, set()).add(d)
        interf.setdefault(d, set())
col = {}
for r in sorted(interf, key=lambda r: int(r[1:])):
    used = {col[x] for x in interf[r] if x in col}
    c = 0
    while c in used: c += 1
    col[r] = c
ren = lambda r: 'S%d' % col[r] if r[0] == 'S' else r
out = hdr + ['# S registers re-coloured by agents/x86/src/regalloc.py: %d -> %d' % (len(col), len(set(col.values())))]
out += ['%s %s, %s' % (op, ren(d) if not d.isdigit() else d, ren(s)) for op, d, s in ins]
open(sys.argv[2], 'w').write('\n'.join(out) + '\n')
print(sys.argv[1], 'S:', len(col), '->', len(set(col.values())))
