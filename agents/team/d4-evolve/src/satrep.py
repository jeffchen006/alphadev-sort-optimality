#!/usr/bin/env python3
"""d4-evolve SAT repair: keep a near-miss program of K slots, let the SAT solver change at most Q instructions
(any positions, any new instruction), output snapshots free (M_out). CEGIS over weak orders, relaxed model of
agents/sat/encode.py (scratch = T, flags = eq); a SAT result is then checked strictly with bin/evo -eval.
usage: satrep.py FILE Q [first last] [R_extra]"""
import sys, os, random, time, subprocess, tempfile
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '../../../..'))
sys.path.insert(0, os.path.join(ROOT, 'agents/sat'))
sys.path.insert(0, os.path.join(ROOT, 'agents/sort5-lab/tools'))
from encode import Enc
import d4eval as E
from pysat.solvers import Solver
from pysat.card import CardEnc, EncType

N = 5


def regmap(prog):
    m = {}
    for i in range(N): m['P%d' % i] = i
    for op, a, b in prog:
        for x in (a, b):
            if x not in m and x[0] == 'S': m[x] = N + len([y for y in m if y[0] == 'S'])
    return m


def repair(prog, Q, rextra=2, log=print, seed=0, tlimit=float(os.environ.get('TLIM', 1800))):
    prog = [x for x in prog if x[0] != 'out']
    K = len(prog)
    rm = regmap(prog)
    R = N + (len(rm) - N) + rextra
    e = Enc(N, K, R=R, iset='I1', outmode='snap', nop=False)
    ch = [e.new() for _ in range(K)]
    for i, (op, a, b) in enumerate(prog):
        e.cl(ch[i], e.op[i][op]); e.cl(ch[i], e.d[i][rm[a]]); e.cl(ch[i], e.s[i][rm[b]])
    chg = os.environ.get('CHG')  # 'a:b' = only slots a..b-1 may change
    if chg:
        a_, b_ = map(int, chg.split(':'))
        for i in range(K):
            if not (a_ <= i < b_): e.cl(-ch[i])
    card = CardEnc.atmost(lits=ch, bound=Q, top_id=e.nvars, encoding=EncType.seqcounter)
    e.nvars = max(e.nvars, card.nv)
    for c in card.clauses: e.cl(*c)
    allw = E.orders(N)
    fails = [w for w in allw if E.run(prog, N, w) != sorted(w)]
    rnd = random.Random(seed)
    init = rnd.sample(fails, min(8, len(fails))) + rnd.sample(allw, 4)
    s = Solver(name='cadical195')
    pushed = 0
    for t in init: e.add_type(t)
    t0 = time.time(); it = 0
    while True:
        for c in e.clauses[pushed:]: s.add_clause(c)
        pushed = len(e.clauses); it += 1
        t1 = time.time(); r = s.solve()
        log("  it %d types %d vars %d solve %.1fs total %.1fs %s" % (it, len(e.types), e.nvars, time.time() - t1, time.time() - t0, r))
        if not r:
            return 'UNSAT', len(e.types), time.time() - t0, None
        p, outmap = e.decode(s.get_model())
        names = {v: k for k, v in rm.items()}
        def nm(r):
            if r in names: return names[r]
            return 'S%d' % (r - N + 50)
        txt = []
        for i, (op, d, sr) in enumerate(p):
            txt.append((op, nm(d), nm(sr)))
            for j, (tm, reg) in enumerate(outmap):
                if tm == i + 1: txt.append(('out', str(j), nm(reg)))
        for j, (tm, reg) in enumerate(outmap):
            if tm == 0: txt.append(('out', str(j), nm(reg)))  # input slot (rare)
        bad = [w for w in allw if E.run(txt, N, w) != sorted(w)]
        if not bad:
            return 'SAT', len(e.types), time.time() - t0, txt
        if time.time() - t0 > tlimit:
            return 'TIMEOUT', len(e.types), time.time() - t0, None
        e.add_type(rnd.choice(bad))


if __name__ == '__main__':
    fn, Q = sys.argv[1], int(sys.argv[2])
    first = int(sys.argv[3]) if len(sys.argv) > 3 else 0
    last = int(sys.argv[4]) if len(sys.argv) > 4 else 10 ** 9
    rextra = int(sys.argv[5]) if len(sys.argv) > 5 else 2
    progs = E.parse_text(open(fn).read())
    for idx, p in enumerate(progs):
        if idx < first or idx >= last: continue
        res, nt, dt, txt = repair(p, Q, rextra)
        print('prog %d: Q=%d %s types=%d %.1fs' % (idx, Q, res, nt, dt), flush=True)
        if txt:
            body = E.fmt(txt)
            print('# prog SATREP src=%d Q=%d\n%s' % (idx, Q, body), flush=True)
            with open(fn + '.satrep_found.txt', 'a') as f:
                f.write('# prog SATREP src=%d Q=%d\n%s\n' % (idx, Q, body))
