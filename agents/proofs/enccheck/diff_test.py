"""Differential test: sat's CNF encoding (encode.Enc, rules=()) vs an INDEPENDENT simulator (this file).

For a program P (length k) and ONE order type t:
  CNF_t := Enc(n, k, ...) with only add_type(t), plus unit clauses that fix P (op, dst, src per step).
  claim: CNF_t is SAT  <=>  P is relaxed-correct on t (MODEL §2/§4.3) for SOME output choice.
Output choice per mode: snap = output j is one slot (input P_r at time 0, or the dst of step i just after step i,
not a cmp step), slots pairwise distinct; free = output j is the final value of a register, registers distinct;
fixed = output j is the final P_j.
The direction "P correct => CNF_t SAT" is the one the lower bound needs (no correct program is lost).
Usage: diff_test.py --satdir ../../sat -n 3 -k 4 --mode snap --iset I1 --count 2000 [--seed 1]
"""
import argparse, itertools, os, random, sys

ap = argparse.ArgumentParser()
ap.add_argument('--satdir', required=True, help='a frozen copy of sat code (vendor/sat_<sha>)')
ap.add_argument('-n', type=int, default=3)
ap.add_argument('-k', type=int, default=4)
ap.add_argument('--mode', default='snap', choices=['snap', 'free', 'fixed'])
ap.add_argument('--iset', default='I1')
ap.add_argument('--count', type=int, default=1000)
ap.add_argument('--seed', type=int, default=1)
ap.add_argument('--bias', type=float, default=0.7, help='prob. to draw from a "plausible" sorting-like step')
a = ap.parse_args()
sys.path.insert(0, os.path.abspath(a.satdir))
import encode  # noqa: E402
from pysat.solvers import Solver  # noqa: E402

n, k = a.n, a.k
R = n + k
OPS = ['mov', 'cmp', 'cmovl', 'cmovg'] + (['cmovle', 'cmovge'] if a.iset == 'I1' else [])
TOP = float('inf')


def weak_orders(n):  # all rank tuples with ranks 0..m-1 onto (independent of sat's sim.py)
    out = set()
    for rk in itertools.product(range(n), repeat=n):
        if set(rk) == set(range(max(rk) + 1)):
            out.add(rk)
    return sorted(out)


def run(prog, rk):
    """Return (final register values, slot values) on order type rk. Values: ranks, TOP for T."""
    reg = [rk[r] if r < n else TOP for r in range(R)]
    lt = gt = False
    slots = [rk[r] for r in range(n)]
    for (o, d, s) in prog:
        if o == 'cmp':
            lt, gt = reg[d] < reg[s], reg[d] > reg[s]
            slots.append(None)
            continue
        cond = {'mov': True, 'cmovl': lt, 'cmovg': gt, 'cmovle': not gt, 'cmovge': not lt}[o]
        if cond:
            reg[d] = reg[s]
        slots.append(reg[d])
    return reg, slots


def correct(prog, outs, rk):
    """outs[j] = slot (snap) / register (free) of output j; None for fixed."""
    reg, slots = run(prog, rk)
    want = sorted(rk)
    if a.mode == 'fixed':
        return all(reg[j] == want[j] for j in range(n))
    cells = slots if a.mode == 'snap' else reg
    return all(cells[outs[j]] is not None and cells[outs[j]] == want[j] for j in range(n))


def rand_outs(rnd, prog):
    if a.mode == 'fixed':
        return None
    if a.mode == 'free':
        return rnd.sample(range(R), n)
    ok = list(range(n)) + [n + i for i, (o, _, _) in enumerate(prog) if o != 'cmp']
    if len(ok) < n:
        return None
    return rnd.sample(ok, n)


def rand_prog(rnd):
    prog = []
    for i in range(k):
        o = rnd.choice(OPS)
        if rnd.random() < a.bias:  # mostly small register indices (inputs + first scratches)
            d, s = rnd.randrange(min(R, n + 2)), rnd.randrange(min(R, n + 2))
        else:
            d, s = rnd.randrange(R), rnd.randrange(R)
        prog.append((o, d, s))
    return prog


def cnf_sat(prog, outs, rk):
    e = encode.Enc(n, k, None, a.iset, a.mode, (), False)
    e.add_type(rk)
    units = []
    for i, (o, d, s) in enumerate(prog):
        units.append(e.op[i][o])
        units.append(e.d[i][d])
        units.append(e.s[i][s])
    if a.mode == 'snap':
        units += [e.osnap[j][outs[j]] for j in range(n)]
    elif a.mode == 'free':
        units += [e.out[j][outs[j]] for j in range(n)]
    with Solver(name='cadical195', bootstrap_with=e.clauses) as S:
        return S.solve(assumptions=units)


rnd = random.Random(a.seed)
types = weak_orders(n)
stats = {'agree_sat': 0, 'agree_unsat': 0, 'mismatch': 0}
for c in range(a.count):
    prog = rand_prog(rnd)
    outs = rand_outs(rnd, prog)
    if a.mode == 'snap' and outs is None:
        continue
    rk = rnd.choice(types)
    want = correct(prog, outs, rk)
    got = cnf_sat(prog, outs, rk)
    if want == got:
        stats['agree_sat' if got else 'agree_unsat'] += 1
    else:
        stats['mismatch'] += 1
        print('MISMATCH sim=%s cnf=%s type=%s prog=%s outs=%s' % (want, got, rk, prog, outs))
print('n=%d k=%d mode=%s iset=%s count=%d %s' % (n, k, a.mode, a.iset, a.count, stats))
sys.exit(1 if stats['mismatch'] else 0)
