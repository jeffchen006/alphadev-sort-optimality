"""Knuth estimator of cube-and-conquer cost.
Random descent over the one-hot groups (op_i, d_i, s_i) with UP pruning (as cubes.py) to depth D; the product of
branching factors estimates the number of leaves; the leaf is solved by kissat (time limit). Estimate of total cost
= mean(product * leaf time). usage: knuth.py CNF_DIR depth samples timeout seed  (CNF_DIR from tree_size.py: F.cnf)
Rebuilds the encoder from the header of F.cnf is not possible, so pass the encoder args via env ARGS (as gen_full)."""
import os, random, subprocess, sys, time, json
from pysat.solvers import Solver
from pysat.formula import CNF
import cubes
from encode import Enc
import sim


def main():
    n, k, depth, samples, tmo, seed = [int(x) for x in sys.argv[1:7]]
    extra = dict(x.split('=') for x in sys.argv[7:])
    rules = extra.get('rules', 'canon,pcanon,comm,dead,flags,cmpord,movfresh,snapcmov,hcmp').split(',')
    e = Enc(n, k, None, 'I1', 'snap', rules, True, 0, int(extra.get('mincmov', 0)),
            cmpeq=int(extra['cmpeq']) if 'cmpeq' in extra else None)
    for t in sim.total_orders(n):
        e.add_type(t)
    e.add_class_cuts()
    d = extra.get('dir', 'cc/knuth_n%d_k%d' % (n, k))
    os.makedirs(d, exist_ok=True)
    F = os.path.join(d, 'F.cnf')
    e.dimacs(F)
    G = cubes.groups(e)
    s = Solver(name='cadical195', bootstrap_with=e.clauses)
    rnd = random.Random(seed)
    out = []
    for smp in range(samples):
        P, prod = [], 1
        for gi in range(depth):
            ch = [x for x in G[gi] if s.propagate(assumptions=P + [x])[0]]
            if not ch:
                prod = 0
                break
            prod *= len(ch)
            P.append(rnd.choice(ch))
        if prod == 0:
            out.append((0, 0.0, 'closed'))
            print('sample %d: closed by UP at depth %d' % (smp, gi), flush=True)
            continue
        leaf = os.path.join(d, 'leaf_s%d_%d.cnf' % (seed, smp))
        with open(F) as f, open(leaf, 'w') as g:
            for line in f:
                if line.startswith('p'):
                    _, _, nv, nc = line.split()
                    g.write('p cnf %s %d\n' % (nv, int(nc) + len(P)))
                else:
                    g.write(line)
            for l in P:
                g.write('%d 0\n' % l)
        t0 = time.time()
        r = subprocess.run(['timeout', str(tmo), 'nice', '-n', '10', cubes.BIN + '/kissat', '-q', leaf],
                           capture_output=True, text=True)
        dt = time.time() - t0
        st = [l for l in r.stdout.splitlines() if l.startswith('s ')]
        st = st[0] if st else 'TIMEOUT'
        os.remove(leaf)
        out.append((prod, dt, st))
        print('sample %d: leaves~%.3g time %.1fs %s' % (smp, prod, dt, st), flush=True)
    est = sum(p * t for p, t, _ in out) / len(out)
    print('ESTIMATE n=%d k=%d depth=%d %s: mean leaves %.3g, mean cost %.3g core-s = %.3g core-h (timeouts %d/%d)' % (
        n, k, depth, extra, sum(p for p, _, _ in out) / len(out), est, est / 3600,
        sum(1 for _, _, st in out if st == 'TIMEOUT'), len(out)))


if __name__ == '__main__':
    main()
