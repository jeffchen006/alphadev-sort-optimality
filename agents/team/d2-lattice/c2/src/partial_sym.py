#!/usr/bin/env python3
"""Round 3: free flags, canonical operands, and decision-history constraints.

This extends the saved round-2 encoder without changing it. Scratch register
names already disappear in its creation-ordered SSA nodes. Comparisons are
oriented by node number. P2/P3 are ordered by first use in a fixed selector
stream. Equal histories imply equal origin identities. On strict orders, a
history class after j comparisons has at most 2**(c-j) members: its next
comparison either always compares the same identity (one successor), or two
different identities (at most two successors).
"""
import argparse
import hashlib
import itertools
import json
from pathlib import Path
import resource
import subprocess
import time

from partial_sat import Encoding, PROJECT


class SymEncoding(Encoding):
    def strengthen(self, histories=True, capacity=True):
        assert self.origin and self.n == 4
        n, m, c = self.n, self.m, self.c
        before = (self.nv, len(self.cs))
        # Reversing cmp operands and every cmov direction in its block is exact.
        for j in range(c):
            for a in range(n+m):
                for b in range(a):
                    self.cl(-self.cmp[j][0][a], -self.cmp[j][1][b])
        # A mov does not inspect either condition selector.
        for g in range(m):
            self.cl(-self.mov[g], -self.high[g])
            self.cl(-self.mov[g], -self.inclusive[g])
        # The first comparison fixes P0/P1. Exchange of P2/P3 remains free.
        # Node selectors are a syntactic order, not an execution-time order.
        selectors = [p for g in range(m) for p in (self.dst[g], self.src[g])]
        selectors += [p for row in self.cmp for p in row]
        selectors += self.out
        seen2 = []
        for picks in selectors:
            self.cl(-picks[3], *seen2)
            seen2.append(picks[2])
        self.strengthening = {'symmetry_variables': self.nv-before[0],
                              'symmetry_clauses': len(self.cs)-before[1]}
        if not histories:
            return
        before = (self.nv, len(self.cs))
        nt = len(self.types)
        hist = {}
        for t, u in itertools.combinations(range(nt), 2):
            previous = True
            for j in range(c):
                sameflag = self.new()
                for f in range(3):
                    # Exactly one flag is true on each order.
                    a, b = self.fl[j][t][f], self.fl[j][u][f]
                    self.cl(-sameflag, self.neg(a), b)
                    self.cl(self.neg(a), self.neg(b), sameflag)
                same = self.new()
                self.cl(-same, previous)
                self.cl(-same, sameflag)
                self.cl(self.neg(previous), -sameflag, same)
                hist[t, u, j] = same
                for g in range(m):
                    for bit in range(self.nb):
                        self.eq(self.val[n+g][t][bit], self.val[n+g][u][bit],
                                -self.blk[g][j], -same)
                previous = same
            # Sorted identity sequences differ on different strict orders.
            self.cl(-previous)
        if capacity:
            for j in range(c-1):
                bound = 1 << (c-j-1)
                for t in range(nt):
                    members = [hist[min(t,u), max(t,u), j]
                               for u in range(nt) if u != t]
                    # The history class includes t, hence bound-1 other rows.
                    self.at_most(members, bound-1)
        self.strengthening.update(history_variables=self.nv-before[0],
                                  history_clauses=len(self.cs)-before[1])

    def at_most(self, literals, bound):
        """Sequential unary counter; one-way implications suffice for a bound."""
        if bound >= len(literals):
            return
        if bound == 0:
            for lit in literals:
                self.cl(-lit)
            return
        previous = []
        for i, lit in enumerate(literals):
            row = self.vec(min(i+1, bound))
            self.cl(-lit, row[0])
            for q, old in enumerate(previous):
                self.cl(-old, row[q])
                if q+1 < len(row):
                    self.cl(-old, -lit, row[q+1])
                else:
                    self.cl(-old, -lit)
            previous = row


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--k', type=int, default=19)
    ap.add_argument('--c', type=int, default=5)
    ap.add_argument('--mode', choices=['partial', 'full', 'lattice'], default='partial')
    ap.add_argument('--timeout', type=int, default=3600)
    ap.add_argument('--tag', required=True)
    ap.add_argument('--fixed')
    ap.add_argument('--no-histories', action='store_true')
    ap.add_argument('--no-capacity', action='store_true')
    args = ap.parse_args()
    resource.setrlimit(resource.RLIMIT_AS, (2400*1024**2, 2400*1024**2))
    start = time.monotonic()
    types = list(itertools.permutations(range(4)))
    enc = SymEncoding(4, args.k, args.c, types, args.mode, first_pair=True,
                      must_partial=args.mode == 'partial', origin=True)
    enc.strengthen(not args.no_histories, not args.no_capacity)
    if args.fixed:
        enc.fix_program(Path(args.fixed).read_text())
    cnf, proof = args.tag+'.cnf', args.tag+'.drat'
    enc.dimacs(cnf)
    record = dict(vars(args), n=4, cases='strict', orders=24,
                  flags='free', blocks='free', registers='unbounded SSA',
                  variables=enc.nv, clauses=len(enc.cs),
                  strengthening=enc.strengthening,
                  cnf_sha256=hashlib.sha256(Path(cnf).read_bytes()).hexdigest(),
                  build_seconds=time.monotonic()-start)
    print(json.dumps(dict(step='built', **record)), flush=True)
    cmd = [str(PROJECT/'bin/kissat'), '--time='+str(args.timeout), cnf, proof]
    with open(args.tag+'.solver', 'w') as output:
        try:
            p = subprocess.run(cmd, stdout=output, stderr=subprocess.STDOUT,
                               timeout=args.timeout+15)
            record['returncode'] = p.returncode
        except subprocess.TimeoutExpired:
            record['returncode'] = 124
    record['status'] = 'UNKNOWN'
    model = []
    for line in Path(args.tag+'.solver').read_text().splitlines():
        if line.startswith('s '):
            record['status'] = line[2:].strip()
        if line.startswith('v '):
            model.extend(int(x) for x in line[2:].split() if int(x))
    if record['status'] == 'SATISFIABLE':
        yes = set(x for x in model if x > 0)
        assert all(any((x in yes) if x > 0 else (-x not in yes) for x in cl)
                   for cl in enc.cs)
        Path(args.tag+'.s').write_text(enc.decode(model))
        record['assignment_checked'] = True
    record['elapsed_seconds'] = time.monotonic()-start
    record['children_cpu_seconds'] = resource.getrusage(resource.RUSAGE_CHILDREN).ru_utime
    Path(args.tag+'.json').write_text(json.dumps(record, indent=2)+'\n')
    print(json.dumps(record), flush=True)


if __name__ == '__main__':
    main()
