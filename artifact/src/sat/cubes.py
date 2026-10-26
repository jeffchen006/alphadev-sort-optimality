"""Cube-and-conquer with one combined, checkable proof.

Cubes = a decision tree over the one-hot groups op_0, d_0, s_0, op_1, ... (first `depth` groups).
A child whose cube gives a unit-propagation conflict on F is closed at once (its negation is RUP).
Each open leaf C is solved by kissat on F + units(C) with a DRAT proof; every lemma L of that proof is
weakened to L v -C (still RUP w.r.t. F + earlier weakened lemmas), deletions of original clauses are dropped.
Then bottom-up: for each tree node P, clause -P is RUP (children clauses -(P,x) + the ALO clause of the group).
The root gives the empty clause. Check: drat-trim F proof (or -L to LRAT + cake_lpr).

usage: python3 cubes.py <same args as cegis/encode> --depth G --jobs J --out DIR [--types perm|all|file]
"""
import argparse, json, os, subprocess, sys, time
from concurrent.futures import ThreadPoolExecutor
from pysat.solvers import Solver
from encode import Enc, ALL_RULES
import sim

BIN = '/path/to/repo/bin'


def groups(e):
    g = []
    for i in range(e.k):
        g.append(list(e.op[i].values()))
        g.append([l for l in e.d[i] if l is not False])
        g.append([l for l in e.s[i] if l is not False])
    return g


def build_tree(e, depth, log):
    """returns (leaves, nodes): nodes = list of prefixes (internal, in creation order)."""
    s = Solver(name='cadical195', bootstrap_with=e.clauses)
    G = groups(e)
    frontier = [[]]
    internal = []  # (prefix, [closed children literals])
    closed = 0
    for gi in range(depth):
        nxt = []
        for P in frontier:
            cl = []
            for x in G[gi]:
                ok, _ = s.propagate(assumptions=P + [x])
                if ok:
                    nxt.append(P + [x])
                else:
                    closed += 1
                    cl.append(x)
            internal.append((P, cl))
        log('depth %d: open %d (closed by UP so far %d)' % (gi + 1, len(nxt), closed))
        frontier = nxt
    s.delete()
    return frontier, internal


def solve_leaf(args):
    idx, cube, F_path, d, timeout = args
    if MODE == 'lrat':
        return solve_leaf_lrat(args)
    cnf = os.path.join(d, 'leaf%05d.cnf' % idx)
    prf = os.path.join(d, 'leaf%05d.drat' % idx)
    with open(F_path) as f:
        head = f.readline()
        while head.startswith('c'):
            head = f.readline()
        body = f.read()
    nv, nc = map(int, head.split()[2:4])
    with open(cnf, 'w') as f:
        f.write('p cnf %d %d\n' % (nv, nc + len(cube)))
        f.write(body)
        for l in cube:
            f.write('%d 0\n' % l)
    t0 = time.time()
    r = subprocess.run(['timeout', str(timeout), 'nice', '-n', '10', BIN + '/kissat', '-q', '--no-binary', cnf, prf],
                       capture_output=True, text=True)
    st = [l for l in r.stdout.splitlines() if l.startswith('s ')]
    os.remove(cnf)
    return idx, (st[0] if st else 'TIMEOUT'), time.time() - t0


MODE = 'lrat'


def sha256(path):
    import hashlib
    h = hashlib.sha256()
    with open(path, 'rb') as f:
        for b in iter(lambda: f.read(1 << 20), b''):
            h.update(b)
    return h.hexdigest()
CAKE = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'tools', 'cake_lpr')


def solve_leaf_lrat(args):
    """cadical LRAT proof of F + cube units, checked at once by cake_lpr, then deleted."""
    idx, cube, F_path, d, timeout = args
    cnf = os.path.join(d, 'leaf%05d.cnf' % idx)
    prf = os.path.join(d, 'leaf%05d.lrat' % idx)
    with open(F_path) as f:
        head = f.readline()
        while head.startswith('c'):
            head = f.readline()
        body = f.read()
    nv, nc = map(int, head.split()[2:4])
    with open(cnf, 'w') as f:
        f.write('p cnf %d %d\n' % (nv, nc + len(cube)))
        f.write(body)
        for l in cube:
            f.write('%d 0\n' % l)
    hcnf = sha256(cnf)
    t0 = time.time()
    r = subprocess.run(['timeout', str(timeout), 'nice', '-n', '10', BIN + '/cadical', '-q', '--lrat=true',
                        '--binary=false', cnf, prf], capture_output=True, text=True)
    st = [l for l in r.stdout.splitlines() if l.startswith('s ')]
    st = st[0] if st else 'TIMEOUT'
    t1 = time.time()
    hprf = '-'
    if st == 's UNSATISFIABLE':
        hprf = sha256(prf)
        c = subprocess.run(['nice', '-n', '10', CAKE, cnf, prf], capture_output=True, text=True)
        if 's VERIFIED UNSAT' not in c.stdout:
            st = 'CHECK-FAILED ' + (c.stdout + c.stderr)[-200:].replace('\n', ' ')
        else:
            st = 's UNSATISFIABLE (cake_lpr: %s)' % c.stdout.strip().replace('\n', ' | ')
    st += ' cnf_sha256=%s lrat_sha256=%s' % (hcnf, hprf)
    for p in (cnf, prf):
        if os.path.exists(p):
            os.remove(p)
    return idx, st, t1 - t0, time.time() - t1


def summary(F_clauses, nvars, leaves, internal, d):
    """summary CNF = F + negated leaf cubes; summary DRAT: closed children + internal nodes bottom-up."""
    S = os.path.join(d, 'summary.cnf')
    with open(S, 'w') as f:
        f.write('p cnf %d %d\n' % (nvars, len(F_clauses) + len(leaves)))
        for c in F_clauses:
            f.write(' '.join(map(str, c)) + ' 0\n')
        for cube in leaves:
            f.write(' '.join(str(-l) for l in cube) + ' 0\n')
    D = os.path.join(d, 'summary.drat')
    with open(D, 'w') as f:
        for P, cl in reversed(internal):
            for x in cl:
                f.write(' '.join(str(-l) for l in P + [x]) + ' 0\n')
            f.write(' '.join(str(-l) for l in P) + ' 0\n')
    return S, D


def combine(F_clauses, leaves, internal, d, out_path):
    Fset = set(tuple(sorted(c)) for c in F_clauses)
    with open(out_path, 'w') as out:
        for idx, cube in enumerate(leaves):
            neg = [-l for l in cube]
            cubeunits = set((l,) for l in cube)
            with open(os.path.join(d, 'leaf%05d.drat' % idx)) as f:
                for line in f:
                    line = line.strip()
                    if not line:
                        continue
                    if line.startswith('d '):
                        lits = [int(x) for x in line[2:].split()[:-1]]
                        key = tuple(sorted(lits))
                        if key in Fset or key in cubeunits:
                            continue  # never delete original clauses (other leaves need them)
                        out.write('d ' + ' '.join(map(str, lits + neg)) + ' 0\n')
                    else:
                        lits = [int(x) for x in line.split()[:-1]]
                        out.write(' '.join(map(str, lits + neg)) + ' 0\n')
            out.write(' '.join(map(str, neg)) + ' 0\n')  # the leaf clause itself (RUP: last lemma was empty)
        for P, cl in reversed(internal):
            for x in cl:
                out.write(' '.join(str(-l) for l in P + [x]) + ' 0\n')
            out.write(' '.join(map(str, [-l for l in P])) + ' 0\n')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('-n', type=int, required=True)
    ap.add_argument('-k', type=int, required=True)
    ap.add_argument('-R', type=int, default=None)
    ap.add_argument('--iset', default='I1')
    ap.add_argument('--outmode', default='snap')
    ap.add_argument('--rules', default='all')
    ap.add_argument('--mincmp', type=int, default=0)
    ap.add_argument('--mincmov', type=int, default=0)
    ap.add_argument('--types', default='perm')
    ap.add_argument('--depth', type=int, default=3)
    ap.add_argument('--jobs', type=int, default=8)
    ap.add_argument('--timeout', type=int, default=36000)
    ap.add_argument('--out', required=True)
    ap.add_argument('--noproof', action='store_true')
    ap.add_argument('--mode', default='lrat', choices=['lrat', 'drat'])
    a = ap.parse_args()
    global MODE
    MODE = a.mode
    os.makedirs(a.out, exist_ok=True)
    logf = open(os.path.join(a.out, 'log.txt'), 'a')

    def log(m):
        m = '[%s] %s' % (time.strftime('%H:%M:%S'), m)
        print(m, flush=True)
        logf.write(m + '\n'); logf.flush()

    rules = [r for r in ALL_RULES if a.outmode != 'fixed' or r != 'pcanon'] if a.rules == 'all' else \
        [r for r in a.rules.split(',') if r]
    nop = bool(set(rules) - {'canon', 'pcanon', 'comm', 'snapcmov'})
    e = Enc(a.n, a.k, a.R, a.iset, a.outmode, rules, nop, a.mincmp, a.mincmov)
    types = sim.total_orders(a.n) if a.types == 'perm' else sim.weak_orders(a.n) if a.types == 'all' else \
        [tuple(t) for t in json.load(open(a.types))]
    for t in types:
        e.add_type(t)
    if 'hcmp' in rules:
        e.add_class_cuts()
    desc = 'n=%d k=%d R=%d iset=%s outmode=%s rules=%s nop=%s mincmp=%d mincmov=%d types=%s(%d)' % (
        a.n, a.k, e.R, a.iset, a.outmode, ','.join(rules), nop, a.mincmp, a.mincmov, a.types, len(types))
    log(desc)
    F = os.path.join(a.out, 'F.cnf')
    e.dimacs(F, desc)
    leaves, internal = build_tree(e, a.depth, log)
    json.dump({'leaves': leaves, 'internal': len(internal)}, open(os.path.join(a.out, 'cubes.json'), 'w'))
    t0 = time.time()
    res = {}
    with ThreadPoolExecutor(a.jobs) as ex:
        for out in ex.map(solve_leaf, [(i, c, F, a.out, a.timeout) for i, c in enumerate(leaves)]):
            idx, st, dt = out[:3]
            res[idx] = st
            log('leaf %d/%d %s %.1fs%s' % (idx + 1, len(leaves), st, dt, ' check %.1fs' % out[3] if len(out) > 3 else ''))
            if 'SATISFIABLE' in st and 'UNSAT' not in st:
                log('SAT leaf found: %d' % idx)
    nun = sum(1 for v in res.values() if v.startswith('s UNSATISFIABLE'))
    log('leaves UNSAT %d / %d, wall %.0fs' % (nun, len(leaves), time.time() - t0))
    if nun == len(leaves) and MODE == 'lrat':
        S, D = summary(e.clauses, e.nvars, leaves, internal, a.out)
        L = os.path.join(a.out, 'summary.lrat')
        r = subprocess.run([BIN + '/drat-trim', S, D, '-L', L], capture_output=True, text=True)
        c = subprocess.run([CAKE, S, L], capture_output=True, text=True)
        ok = 's VERIFIED UNSAT' in c.stdout
        log('summary: drat-trim %s; cake_lpr %s' % ('VERIFIED' if 's VERIFIED' in r.stdout else 'FAIL',
                                                    c.stdout.strip()))
        log('all %d leaves cake_lpr VERIFIED, summary %s' % (len(leaves), 'VERIFIED' if ok else 'FAILED'))
        print('RESULT', 'UNSAT(certified)' if ok else 'UNSAT(summary-check-failed)', desc)
    elif nun == len(leaves) and not a.noproof:
        P = os.path.join(a.out, 'proof.drat')
        combine(e.clauses, leaves, internal, a.out, P)
        for i in range(len(leaves)):
            os.remove(os.path.join(a.out, 'leaf%05d.drat' % i))
        log('combined proof written: %s (%.1f MB)' % (P, os.path.getsize(P) / 1e6))
        print('RESULT UNSAT', desc)
    else:
        print('RESULT', 'NOT-ALL-UNSAT', desc)


if __name__ == '__main__':
    main()
