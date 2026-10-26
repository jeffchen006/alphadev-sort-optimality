"""Synthesize a merge suffix after a fresh sort3 + sort2 prefix.

The shared instruction choices are encoded in CNF. Register values and flags
are encoded separately for each input case. Add counterexamples until all
541 weak orders pass an independent simulator. No earlier sort5 base is read.
"""
import argparse
import itertools
import json
import os
from pathlib import Path
import resource
import time

from pysat.card import CardEnc, EncType
from pysat.formula import IDPool
from pysat.solvers import Solver

HERE = Path(__file__).resolve().parent
OPS = ['mov', 'cmp', 'cmovl', 'cmovle', 'cmovg', 'cmovge']
PREFIX = [
    (1, 4, 3), (0, 5, 3), (2, 5, 4), (4, 3, 4),
    (1, 3, 2), (0, 6, 2), (2, 6, 3), (3, 3, 2),
    (1, 5, 6), (3, 2, 5), (4, 6, 5),
    (1, 0, 1), (0, 7, 0), (4, 0, 1), (4, 1, 7),
]


def cond(op, flag):
    lt, eq = flag
    return (True if op == 0 else lt if op == 2 else lt or eq if op == 3
            else not (lt or eq) if op == 4 else not lt)


def simulate(prog, w, initial=None):
    regs = list(w) + [7] * 20 if initial is None else list(initial[0])
    flag = (False, True) if initial is None else initial[1]
    snapshots = [tuple(regs)]
    for op, a, b in prog:
        if op == 1:
            flag = (regs[a] < regs[b], regs[a] == regs[b])
        elif cond(op, flag):
            regs[a] = regs[b]
        snapshots.append(tuple(regs))
    return regs, flag, snapshots


CASES = [w for w in itertools.product(range(5), repeat=5)
         if set(w) == set(range(max(w)+1))]


class Merge:
    def __init__(self, args):
        self.args = args
        self.k, self.r = args.k, args.regs
        self.prefix = PREFIX[:11] if getattr(args, 'prefix', 'pair') == 'triple' else PREFIX
        self.defined = 7 if len(self.prefix)==11 else 8
        self.domain = 6 if self.r>self.defined else 5
        self.pool = IDPool()
        self.solver = Solver(name=args.solver)
        self.clauses = 0
        self.ops = [self.vars(6) for _ in range(self.k)]
        self.dst = [self.vars(self.r) for _ in range(self.k)]
        self.src = [self.vars(self.r) for _ in range(self.k)]
        for row in self.ops + self.dst + self.src:
            self.exactone(row)
        if args.cmps >= 0:
            enc = CardEnc.equals(lits=[o[1] for o in self.ops], bound=args.cmps,
                                 vpool=self.pool, encoding=EncType.seqcounter)
            self.adds(enc.clauses)
        for t in range(self.k):
            for a in range(self.r):
                for b in range(a):
                    self.add(-self.ops[t][1], -self.dst[t][a], -self.src[t][b])
        self.cmp_at = None
        if getattr(args, 'fixed', 'none') != 'none':
            nc = args.cmps
            assert nc == (5 if getattr(args,'prefix','pair') == 'triple' else 4)
            self.cmp_at = [self.vars(self.k) for _ in range(nc)]
            self.flip = self.vars(nc)
            for row in self.cmp_at:
                self.exactone(row)
            for t in range(self.k):
                column = [self.cmp_at[j][t] for j in range(nc)]
                for bit in column:
                    self.add(-bit, self.ops[t][1])
                self.add(-self.ops[t][1], *column)
                for a,b in itertools.combinations(column,2):
                    self.add(-a,-b)
            for j in range(1,nc):
                for t in range(self.k):
                    self.add(-self.cmp_at[j][t], *self.cmp_at[j-1][:t])
        # Shared output choices support any register at any instruction time.
        self.goals = [[self.vars(self.r) for _ in range(self.k + 1)] for _ in range(5)]
        for j in range(5):
            self.add(*(x for row in self.goals[j] for x in row))
        if getattr(args, 'creation_outputs', False):
            # A globally correct value column first occurs either initially
            # or in the register written by one instruction. Record it there.
            for j in range(5):
                for t in range(1, self.k+1):
                    for r in range(self.r):
                        self.add(-self.goals[j][t][r], self.dst[t-1][r])
                        self.add(-self.goals[j][t][r], -self.ops[t-1][1])
        self.used = []

    def vars(self, n):
        return [self.pool.id() for _ in range(n)]

    def add(self, *clause):
        self.solver.add_clause(list(clause))
        self.clauses += 1

    def adds(self, clauses):
        for clause in clauses:
            self.add(*clause)

    def exactone(self, row):
        self.add(*row)
        for a, b in itertools.combinations(row, 2):
            self.add(-a, -b)

    def eqif(self, gate, a, b):
        self.add(-gate, -a, b)
        self.add(-gate, a, -b)

    def case(self, w):
        assert w not in self.used
        self.used.append(w)
        initial, flag, _ = simulate(self.prefix, w)
        states = [[self.vars(self.domain) for _ in range(self.r)] for _ in range(self.k + 1)]
        for r in range(self.r):
            for v, bit in enumerate(states[0][r]):
                value=initial[r] if initial[r]<5 else 5
                self.add(bit if value == v else -bit)
        fl = self.vars(2)
        for bit, value in zip(fl, flag):
            self.add(bit if value else -bit)
        for t in range(self.k):
            left, right = self.vars(self.domain), self.vars(self.domain)
            self.exactone(left)
            self.exactone(right)
            for r in range(self.r):
                for v in range(self.domain):
                    self.eqif(self.dst[t][r], left[v], states[t][r][v])
                    self.eqif(self.src[t][r], right[v], states[t][r][v])
            take = self.pool.id()
            self.add(-self.ops[t][0], take)
            self.add(-self.ops[t][1], -take)
            if self.domain==6:
                # Unknown scratch values can survive on unselected cases.
                # Flags and selected write sources must use defined values.
                self.add(-self.ops[t][1],-left[5])
                self.add(-self.ops[t][1],-right[5])
                self.add(-take,-right[5])
            lt, eq = fl
            for op, literals in [(2, [lt]), (3, [lt, eq]), (4, [-lt, -eq]), (5, [-lt])]:
                g = self.ops[t][op]
                if op == 4:
                    for lit in literals:
                        self.add(-g, -take, lit)
                    self.add(-g, take, *[-x for x in literals])
                else:
                    self.add(-g, -take, *literals)
                    for lit in literals:
                        self.add(-g, take, -lit)
            nf = self.vars(2)
            self.eqif(-self.ops[t][1], nf[0], fl[0])
            self.eqif(-self.ops[t][1], nf[1], fl[1])
            for a in range(self.domain):
                for b in range(self.domain):
                    self.add(-self.ops[t][1], -left[a], -right[b], nf[0] if a < b else -nf[0])
                    self.add(-self.ops[t][1], -left[a], -right[b], nf[1] if a == b else -nf[1])
            if self.cmp_at is not None:
                a,b,c,d,e = [initial[i] for i in [0,1,2,6,3]]
                pair = (a,b)
                if self.args.prefix == 'triple':
                    a,b = min(a,b),max(a,b)
                fixed = ([(a,c),(b,e)] if self.args.fixed == 'extremes' else
                         [(a,d),(b,d)] if self.args.fixed == 'middle' else
                         [(a,d),(b,d),(a,c if a<d else e),(b,c if b<d else e)])
                if self.args.fixed == 'binary':
                    order = [int(i) for i in getattr(self.args,'predicate_order','0,1,2,3').split(',')]
                    assert sorted(order)==list(range(4))
                    fixed = [fixed[i] for i in order]
                if self.args.prefix == 'triple':
                    assert self.args.fixed == 'binary'
                    fixed = [pair]+fixed
                for j,(x,y) in enumerate(fixed):
                    at = self.cmp_at[j][t]
                    self.add(-at, nf[1] if x == y else -nf[1])
                    if x == y:
                        self.add(-at,-nf[0])
                    else:
                        self.eqif(at,nf[0],self.flip[j] if x>y else -self.flip[j])
            fl = nf
            for r in range(self.r):
                write = self.pool.id()
                self.add(-write, take)
                self.add(-write, self.dst[t][r])
                self.add(write, -take, -self.dst[t][r])
                for v in range(self.domain):
                    self.eqif(write, states[t+1][r][v], right[v])
                    self.eqif(-write, states[t+1][r][v], states[t][r][v])
        for j, goal in enumerate(sorted(w)):
            for t in range(self.k + 1):
                for r in range(self.r):
                    self.add(-self.goals[j][t][r], states[t][r][goal])

    def decode(self, model):
        model = set(v for v in model if v > 0)
        one = lambda row: next(i for i, v in enumerate(row) if v in model)
        prog = [(one(o), one(d), one(s)) for o, d, s in zip(self.ops, self.dst, self.src)]
        outs = [next((t, r) for t in range(self.k+1) for r in range(self.r)
                     if self.goals[j][t][r] in model) for j in range(5)]
        return prog, outs

    def run(self):
        began = time.process_time()
        # First cover all ten strict interleavings with internally ordered lists.
        for w in CASES:
            if (len(set(w)) == 5 and w[2] < w[3] < w[4]
                    and (getattr(self.args,'prefix','pair') == 'triple' or w[0] < w[1])):
                self.case(w)
        rounds = 0
        while time.process_time() - began < self.args.cpu:
            self.solver.conf_budget(self.args.conflicts)
            result = self.solver.solve_limited()
            elapsed = time.process_time() - began
            print('SOLVE', 'sat' if result is True else 'unsat' if result is False else 'limit',
                  'cases', len(self.used), 'vars', self.pool.top, 'clauses', self.clauses,
                  'cpu', round(elapsed, 3), 'stats', self.solver.accum_stats(), flush=True)
            if result is False:
                return {'status': 'UNSAT', 'cases': len(self.used), 'cpu': elapsed}
            if result is None:
                continue
            rounds += 1
            prog, outs = self.decode(self.solver.get_model())
            bad = []
            for w in CASES:
                p, f, _ = simulate(self.prefix, w)
                _, _, snapshots = simulate(prog, w, (p[:self.r], f))
                if any(snapshots[t][r] != sorted(w)[j] for j, (t, r) in enumerate(outs)):
                    bad.append(w)
            print('CANDIDATE', rounds, 'bad_cases', len(bad), 'program', prog, flush=True)
            if not bad:
                path = HERE/(self.args.stem + '.s')
                emit(path, prog, outs, self.prefix)
                return {'status': 'CANDIDATE', 'cases': len(self.used), 'cpu': elapsed,
                        'path': str(path), 'rounds': rounds}
            # All newly added counterexamples must have been absent from the CNF.
            assert not set(bad) & set(self.used)
            for w in bad[:self.args.batch]:
                self.case(w)
        return {'status': 'UNKNOWN', 'cases': len(self.used),
                'cpu': time.process_time()-began, 'rounds': rounds}


def emit(path, prog, outs, prefix=PREFIX):
    rn = lambda r: ('P'+str(r)) if r < 5 else ('S'+str(r-5))
    lines = ['# n=5 model=out iset=I1 source=w1-round5-fresh-merge']
    lines += [f'{OPS[op]} {rn(a)}, {rn(b)}' for op, a, b in prefix]
    for t in range(len(prog)+1):
        lines += [f'out {j}, {rn(r)}' for j, (ot, r) in enumerate(outs) if ot == t]
        if t < len(prog):
            op, a, b = prog[t]
            lines.append(f'{OPS[op]} {rn(a)}, {rn(b)}')
    path.write_text('\n'.join(lines)+'\n')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--k', type=int, default=16)
    ap.add_argument('--regs', type=int, default=8)
    ap.add_argument('--cmps', type=int, default=4)
    ap.add_argument('--cpu', type=float, default=300)
    ap.add_argument('--conflicts', type=int, default=1000)
    ap.add_argument('--batch', type=int, default=8)
    ap.add_argument('--solver', default='cadical195')
    ap.add_argument('--stem', default='merge16_c4')
    ap.add_argument('--creation-outputs', action='store_true')
    ap.add_argument('--fixed', choices=['none','extremes','middle','binary'],default='none')
    ap.add_argument('--prefix', choices=['pair','triple'],default='pair')
    ap.add_argument('--predicate-order',default='0,2,1,3')
    args = ap.parse_args()
    for w in CASES:
        p, _, _ = simulate(PREFIX, w)
        assert [p[0], p[1]] == sorted(w[:2])
        assert [p[2], p[6], p[3]] == sorted(w[2:])
    os.sched_setaffinity(0, {min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS, (2800*1024**2, 2800*1024**2))
    started = time.process_time()
    search = Merge(args)
    result = search.run()
    result.update({'args': vars(args), 'total_cpu': time.process_time()-started,
                   'vars': search.pool.top, 'clauses': search.clauses,
                   'stats': search.solver.accum_stats()})
    (HERE/(args.stem+'.json')).write_text(json.dumps(result, indent=2)+'\n')
    print('RESULT', result, flush=True)


if __name__ == '__main__':
    main()
