"""Exact shared-selection DAG relaxation for fixed raw cross comparisons.

Each selected value costs one gate. Its two operands remain available for
free. Gates share earlier results. The six raw cross comparisons each occur
once, in any order. This intentionally removes register-copy costs.
"""
import argparse
import itertools
import json
import os
from pathlib import Path
import resource
import time

from pysat.formula import IDPool
from pysat.solvers import Solver
from rank_chains import data

HERE = Path(__file__).resolve().parent


class Dag:
    def __init__(self, args):
        self.args = args
        self.n = args.gates
        self.pairs = [(i, j) for i in range(2) for j in range(2, 5)]
        self.pool = IDPool()
        self.solver = Solver(name=args.solver)
        self.clauses = 0
        self.order = [self.variables(6) for _ in range(6)]
        for row in self.order:
            self.exactone(row)
        for p in range(6):
            self.exactone([self.order[b][p] for b in range(6)])
        if getattr(args,'order',None):
            order = [int(x) for x in args.order.split(',')]
            assert sorted(order) == list(range(6))
            for b,p in enumerate(order):
                self.add(self.order[b][p])
        self.block = [self.variables(6) for _ in range(self.n)]
        self.cnd = [self.variables(4) for _ in range(self.n)]
        self.a = [self.variables(5+i) for i in range(self.n)]
        self.b = [self.variables(5+i) for i in range(self.n)]
        for row in self.block + self.cnd + self.a + self.b:
            self.exactone(row)
        # Swapping the two data operands and complementing the condition
        # preserves a gate. I1 includes each complement (l/ge and le/g).
        for i in range(self.n):
            for a in range(5+i):
                for b in range(a):
                    self.add(-self.a[i][a], -self.b[i][b])
        for i in range(1, self.n):
            for b in range(6):
                for a in range(b):
                    self.add(-self.block[i-1][b], -self.block[i][a])
        self.out = [self.variables(5+self.n) for _ in range(5)]
        for row in self.out:
            self.exactone(row)
        self.used = []

    def variables(self, n):
        return [self.pool.id() for _ in range(n)]

    def add(self, *c):
        self.solver.add_clause(list(c))
        self.clauses += 1

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
        cols = [self.variables(5) for _ in range(5+self.n)]
        for i in range(5):
            for v in range(5):
                self.add(cols[i][v] if w[i] == v else -cols[i][v])
        block_masks = [self.variables(4) for _ in range(6)]
        for b in range(6):
            for p, (a, s) in enumerate(self.pairs):
                q = (w[a] > w[s]) - (w[a] < w[s])
                for c, take in enumerate([q < 0, q <= 0, q > 0, q >= 0]):
                    bit = block_masks[b][c]
                    self.add(-self.order[b][p], bit if take else -bit)
        for i in range(self.n):
            a, b = self.variables(5), self.variables(5)
            for s in range(5+i):
                for v in range(5):
                    self.eqif(self.a[i][s], a[v], cols[s][v])
                    self.eqif(self.b[i][s], b[v], cols[s][v])
            take = self.pool.id()
            for block in range(6):
                for c in range(4):
                    self.add(-self.block[i][block], -self.cnd[i][c], -take, block_masks[block][c])
                    self.add(-self.block[i][block], -self.cnd[i][c], take, -block_masks[block][c])
            for v in range(5):
                self.eqif(take, cols[5+i][v], b[v])
                self.eqif(-take, cols[5+i][v], a[v])
        for j, v in enumerate(sorted(w)):
            for s in range(5+self.n):
                self.add(-self.out[j][s], cols[s][v])

    def decode(self, model):
        model = set(x for x in model if x > 0)
        one = lambda r: next(i for i, x in enumerate(r) if x in model)
        return {'order': [one(r) for r in self.order],
                'gates': [(one(a), one(b), one(bl), one(c)) for a, b, bl, c
                          in zip(self.a, self.b, self.block, self.cnd)],
                'out': [one(r) for r in self.out]}

    def evaluate(self, plan, w):
        cols = list(w)
        for a, b, block, c in plan['gates']:
            x, y = self.pairs[plan['order'][block]]
            q = (w[x] > w[y]) - (w[x] < w[y])
            take = [q < 0, q <= 0, q > 0, q >= 0][c]
            cols.append(cols[b] if take else cols[a])
        return [cols[i] for i in plan['out']]

    def run(self):
        cases, _, _ = data()
        for w in cases:
            if len(set(w)) == 5:
                self.case(w)
        start = time.process_time()
        rounds = 0
        while time.process_time()-start < self.args.cpu:
            self.solver.conf_budget(self.args.conflicts)
            sat = self.solver.solve_limited()
            print('SOLVE', sat, 'cases', len(self.used), 'cpu', time.process_time()-start,
                  'stats', self.solver.accum_stats(), flush=True)
            if sat is False:
                return {'status': 'UNSAT', 'cpu': time.process_time()-start}
            if sat is None:
                continue
            rounds += 1
            plan = self.decode(self.solver.get_model())
            bad = [w for w in cases if self.evaluate(plan, w) != sorted(w)]
            if not bad:
                return {'status': 'SAT_DAG', 'cpu': time.process_time()-start,
                        'plan': plan, 'rounds': rounds}
            assert not set(bad) & set(self.used)
            for w in bad[:8]:
                self.case(w)
        return {'status': 'UNKNOWN', 'cpu': time.process_time()-start}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--gates', type=int, default=10)
    ap.add_argument('--cpu', type=float, default=300)
    ap.add_argument('--conflicts', type=int, default=2000)
    ap.add_argument('--solver', default='cadical195')
    ap.add_argument('--stem', default='rank_dag10')
    ap.add_argument('--order')
    args = ap.parse_args()
    os.sched_setaffinity(0, {min(os.sched_getaffinity(0))})
    resource.setrlimit(resource.RLIMIT_AS, (2800*1024**2, 2800*1024**2))
    search = Dag(args)
    result = search.run()
    result.update({'args': vars(args), 'cases': len(search.used),
                   'vars': search.pool.top, 'clauses': search.clauses,
                   'stats': search.solver.accum_stats()})
    (HERE/(args.stem+'.json')).write_text(json.dumps(result, indent=2)+'\n')
    print('RESULT', result, flush=True)


if __name__ == '__main__':
    main()
