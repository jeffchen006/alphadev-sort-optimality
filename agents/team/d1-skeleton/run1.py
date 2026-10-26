#!/usr/bin/env python3
# usage: run1.py k "a:b a:b ..." [nscr] [solver] [timeout]
import sys, time, os
sys.path.insert(0, os.path.dirname(__file__))
from rsat import *
k = int(sys.argv[1]); sk = [tuple(x.split(':')) for x in sys.argv[2].split()]
nscr = int(sys.argv[3]) if len(sys.argv) > 3 and sys.argv[3] != '-' else None
solver = sys.argv[4] if len(sys.argv) > 4 else 'kissat'
to = int(sys.argv[5]) if len(sys.argv) > 5 else None
types = perms()
F = F_from_formulas(sk, types)
t0 = time.time(); e = Enc(k, F, types, nscr)
print('vars', e.nv, 'clauses', len(e.cls), 'enc %.1fs' % (time.time() - t0), flush=True)
st, m = solve(e, solver, to, tag='k%d' % k)
print('result', st, '%.1fs' % (time.time() - t0))
if st == 'SATISFIABLE':
    print('\n'.join(e.decode(m)))
