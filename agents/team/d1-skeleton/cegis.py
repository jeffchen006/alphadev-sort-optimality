#!/usr/bin/env python3
# usage: cegis.py k "a:b ..." [nscr|-] [timeout_per_call] [ninit]
# CEGIS over permutation types; UNSAT on a subset => UNSAT for the skeleton (sound).
import sys, time, os, random
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from rsat import *

def simulate(prog, ty):
    r = {'P%d' % i: ty[i] for i in range(N)}; fl = None; outs = {}
    for line in prog:
        op, rest = line.split(None, 1); d, s = [x.strip() for x in rest.split(',')]
        if op == 'out': outs[int(d)] = r[s]
        elif op == 'mov': r[d] = r[s]
        elif op == 'cmp': fl = flag(r[d], r[s])
        else:
            c = COND[op]
            if (fl == 'l' and 'l' in c) or (fl == 'g' and 'g' in c) or (fl == 'e' and c.endswith('e')): r[d] = r[s]
    return [outs.get(j) for j in range(N)] == sorted(ty)

def cegis(k, sk, nscr=None, to=None, ninit=8, seed=1, log=print, allt=None):
    allt = allt or perms()
    rng = random.Random(seed)
    cur = [allt[0]] + rng.sample(allt[1:], ninit - 1)
    t0 = time.time()
    while True:
        F = F_from_formulas(sk, cur)
        e = Enc(k, F, cur, nscr)
        st, m = solve(e, 'kissat', to, tag='c%d' % k)
        log('  types=%d vars=%d cls=%d -> %s (%.0fs)' % (len(cur), e.nv, len(e.cls), st, time.time() - t0))
        if st != 'SATISFIABLE':
            return st, None, cur
        prog = e.decode(m)
        bad = [ty for ty in allt if not simulate(prog, ty)]
        if not bad:
            return 'SAT', prog, cur
        cur += rng.sample(bad, min(len(bad), 4))

if __name__ == '__main__':
    k = int(sys.argv[1]); sk = [tuple(x.split(':')) for x in sys.argv[2].split()]
    nscr = int(sys.argv[3]) if len(sys.argv) > 3 and sys.argv[3] != '-' else None
    to = int(sys.argv[4]) if len(sys.argv) > 4 else None
    ninit = int(sys.argv[5]) if len(sys.argv) > 5 else 8
    st, prog, cur = cegis(k, sk, nscr, to, ninit, log=lambda s: print(s, flush=True))
    print('RESULT', st)
    if prog: print('\n'.join(prog))
