"""Knuth estimator of cube-and-conquer cost.
Random descent over the one-hot groups (op_i, d_i, s_i) with UP pruning (as cubes.py) to depth D (groups; 3 per step);
the product of branching factors estimates the number of leaves; the leaf is solved by kissat (time limit).
Estimate of total cost = mean(product * leaf time) (a lower bound if some leaves time out).
usage: knuth.py n k depth samples timeout seed [key=value ...]
keys: rules=..., cmpeq=c, mincmov=m, maxmov=v, blocks=b1-b2-..., classsteps=S (class cuts only at steps < S),
      classn=N (class cuts among N random permutations), noclass=1, dir=DIR"""
import os, random, subprocess, sys, time, json, math
from pysat.solvers import Solver
import cubes
from encode import Enc
import sim


def main():
    n, k, depth, samples, tmo, seed = [int(x) for x in sys.argv[1:7]]
    extra = dict(x.split('=') for x in sys.argv[7:])
    rules = extra.get('rules', 'canon,pcanon,comm,dead,flags,cmpord,movfresh,snapcmov,hcmp').split(',')
    blocks = tuple(int(x) for x in extra['blocks'].split('-')) if 'blocks' in extra else None
    t0 = time.time()
    e = Enc(n, k, None, 'I1', 'snap', rules, True, 0, int(extra.get('mincmov', 0)),
            cmpeq=int(extra['cmpeq']) if 'cmpeq' in extra else None,
            maxmov=int(extra['maxmov']) if 'maxmov' in extra else None, blocks=blocks)
    perms = sim.total_orders(n)
    for t in perms:
        e.add_type(t)
    if 'hcmp' in rules and not extra.get('noclass'):
        sub = None
        if 'classn' in extra:
            sub = sorted(random.Random(12345).sample(range(len(perms)), int(extra['classn'])))
        steps = int(extra['classsteps']) if 'classsteps' in extra else None
        e.add_class_cuts(steps=steps, subset=sub)
    d = extra.get('dir', 'cc/knuth_n%d_k%d' % (n, k))
    os.makedirs(d, exist_ok=True)
    F = os.path.join(d, 'F_s%d.cnf' % seed)
    e.dimacs(F)
    print('built %d vars %d clauses in %.0fs; %s' % (e.nvars, len(e.clauses), time.time() - t0, extra), flush=True)
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
        t1 = time.time()
        r = subprocess.run(['timeout', str(tmo), 'nice', '-n', '10', cubes.BIN + '/kissat', '-q', leaf],
                           capture_output=True, text=True)
        dt = time.time() - t1
        st = [l for l in r.stdout.splitlines() if l.startswith('s ')]
        st = st[0] if st else 'TIMEOUT'
        os.remove(leaf)
        out.append((prod, dt, st))
        print('sample %d: leaves~%.3g time %.1fs %s' % (smp, prod, dt, st), flush=True)
    os.remove(F)
    est = sum(p * t for p, t, _ in out) / len(out)
    nto = sum(1 for _, _, st in out if st == 'TIMEOUT')
    sat = sum(1 for _, _, st in out if st == 's SATISFIABLE')
    lt = [math.log10(t) for _, t, st in out if t > 0]
    print('ESTIMATE n=%d k=%d depth=%d %s: mean leaves %.3g, mean cost %.3g core-s = %.3g core-h%s; '
          'leaf time median %.1fs; timeouts %d/%d; SAT leaves %d' % (
              n, k, depth, extra, sum(p for p, _, _ in out) / len(out), est, est / 3600,
              ' (LOWER BOUND: timeouts)' if nto else '', sorted(t for _, t, _ in out)[len(out) // 2], nto, len(out), sat))


if __name__ == '__main__':
    main()
