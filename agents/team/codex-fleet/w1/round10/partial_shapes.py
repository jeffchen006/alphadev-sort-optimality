#!/usr/bin/env python3
"""Direct partial-column SAT, with free lattice shapes and no register cap.

Written versions use creation indices. A conditional write consumes its old
destination. Outputs are historical snapshots. Only exceptional versions have
per-order undefined bits; all other versions use monotone threshold tables.
"""
import argparse
import gc
import hashlib
import itertools
import json
import os
from pathlib import Path
import resource
import subprocess
import time

from base_sat import CNF, Encoding, PROJECT, program_flags, weak_orders


class PartialShapes(CNF):
    decode = Encoding.decode
    fix_program = Encoding.fix_program

    def table(self, monotone=False):
        row = [False] + self.vec((1 << self.n)-2) + [True]
        if monotone:
            for mask in range(1 << self.n):
                for i in range(self.n):
                    if not mask >> i & 1:
                        self.cl(self.neg(row[mask]), row[mask | (1 << i)])
        return row

    def __init__(self, n=5, k=31, c=9, q=3, types=None, minimum=3,
                 flags=None, blocks=None, first_pair=True, symmetry=True,
                 slots=None, dependency=False, topology=None, output_requirements=True):
        super().__init__()
        self.n, self.k, self.c, self.m, self.q = n, k, c, k-c, q
        m = self.m
        assert 0 <= minimum <= q <= m
        self.types = types or list(itertools.permutations(range(n)))
        nt = len(self.types)
        self.masks = [[sum(1 << i for i, x in enumerate(ty) if x >= r)
                       for r in range(1, max(ty)+1)] for ty in self.types]
        self.mov = self.vec(m)
        self.dst = [self.vec(n+g+1) for g in range(m)]
        self.src = [self.vec(n+g+1) for g in range(m)]
        self.blk = [self.vec(c) for _ in range(m)]
        self.high = self.vec(m)
        self.inclusive = self.vec(m)
        self.cmp = [[self.vec(n+m) for _ in range(2)] for _ in range(c)]
        self.out = [self.vec(n+m) for _ in range(n)]
        self.truth = [[bool(mask >> i & 1) for mask in range(1 << n)] for i in range(n)]
        self.truth += [self.table(True) for _ in range(m)]
        self.positions = [self.vec(m+1) for _ in range(q)]
        self.ex = [p[:-1] for p in self.positions]
        for picks in self.positions:
            self.eo(picks)
        for e in range(q-1):
            for a in range(m+1):
                for b in range(m+1):
                    if (a == m and b < m) or (b < m and a >= b):
                        self.cl(-self.positions[e][a], -self.positions[e+1][b])
        for e in range(minimum):
            self.cl(-self.positions[e][m])
        if slots is not None:
            assert len(slots) <= q and list(slots) == sorted(set(slots))
            for e, slot in enumerate(list(slots)+[m]*(q-len(slots))):
                self.cl(self.positions[e][slot])

        self.defined = [self.vec(nt) for _ in range(q)]
        self.rows = [[self.vec(len(masks)) for masks in self.masks] for _ in range(q)]
        for e in range(q):
            # Each active exceptional version has at least one undefined entry.
            self.cl(self.positions[e][m], *[-v for v in self.defined[e]])
            for row in self.rows[e]:
                for a, b in zip(row, row[1:]):
                    self.cl(a, -b)

        for g in range(m):
            for picks in (self.src[g], self.dst[g], self.blk[g]):
                self.eo(picks)
            # Every mov allocates a new name. A cmov can also start a new name.
            self.cl(-self.mov[g], self.dst[g][-1])
            if g:
                for b in range(c):
                    for earlier in range(b):
                        self.cl(-self.blk[g-1][b], -self.blk[g][earlier])
            # A conditional write destroys the old destination version.
            for x, d in enumerate(self.dst[g][:-1]):
                for h in range(g+1, m):
                    self.cl(self.mov[g], -d, -self.src[h][x])
                    self.cl(self.mov[g], -d, self.mov[h], -self.dst[h][x])
                for j in range(c):
                    for b in range(j):
                        for side in range(2):
                            self.cl(self.mov[g], -d, -self.blk[g][b], -self.cmp[j][side][x])
            if blocks is not None:
                self.cl(self.blk[g][blocks[g]])

        self.fl = []
        for j in range(c):
            tables = [self.table(), self.table()]
            for side in range(2):
                self.eo(self.cmp[j][side])
                for x, pick in enumerate(self.cmp[j][side]):
                    if x >= n:
                        self.cl(-pick, *self.blk[x-n][:j])
                        for e in range(q):
                            self.cl(-pick, -self.ex[e][x-n])
                    for mask in range(1, (1 << n)-1):
                        self.eq(tables[side][mask], self.truth[x][mask], -pick)
            row = []
            for t, masks in enumerate(self.masks):
                ff = self.vec(3) if flags is None else [flags[j][t] == f for f in (-1, 0, 1)]
                self.cl(*ff)
                for a, b in itertools.combinations(ff, 2):
                    self.cl(self.neg(a), self.neg(b))
                for side, flag in ((0, ff[0]), (1, ff[2])):
                    differences = []
                    for mask in masks:
                        a, b = tables[side][mask], tables[1-side][mask]
                        d = self.new()
                        self.cl(-d, self.neg(a))
                        self.cl(-d, b)
                        self.cl(d, a, self.neg(b))
                        self.cl(-d, flag)
                        differences.append(d)
                    self.cl(self.neg(flag), *differences)
                row.append(ff)
            self.fl.append(row)
        if first_pair:
            self.cl(self.cmp[0][0][0])
            self.cl(self.cmp[0][1][1])

        self.dependency_witnesses = []
        edge_witnesses = {(e, f): [] for e in range(q) for f in range(e+1, q)}
        for g in range(m):
            operands = []
            for operand, picks in enumerate((self.dst[g], self.src[g])):
                table = self.table()
                use = self.vec(q)
                fresh = picks[-1]
                for x, pick in enumerate(picks):
                    ee = [self.ex[e][x-n] if n <= x < n+g else False for e in range(q)]
                    for e in range(q):
                        self.eq(use[e], ee[e], -pick)
                    if x < n+g:
                        for mask in range(1, (1 << n)-1):
                            self.eq(table[mask], self.truth[x][mask], -pick, *ee)
                operands.append((table, use, fresh))
                for e in range(q):
                    for f in range(e+1, q):
                        # Source is read by mov/cmov. Old destination only by cmov.
                        d = self.new()
                        terms = [self.ex[f][g], use[e]]
                        if operand == 0:
                            terms.append(-self.mov[g])
                        for term in terms:
                            self.cl(-d, term)
                        self.cl(d, *[-term for term in terms])
                        self.dependency_witnesses.append(d)
                        edge_witnesses[e, f].append(d)
            for t, masks in enumerate(self.masks):
                take = self.new()
                self.cl(-self.mov[g], take)
                for j in range(c):
                    for f in range(3):
                        target = self.inclusive[g] if f == 1 else (self.high[g] if f == 2 else -self.high[g])
                        self.eq(take, target, self.mov[g], -self.blk[g][j], self.neg(self.fl[j][t][f]))
                operand_defs = []
                for table, use, fresh in operands:
                    d = self.new()
                    self.cl(-fresh, -d)
                    for e in range(q):
                        self.eq(d, self.defined[e][t], -use[e])
                    self.cl(d, fresh, *use)
                    operand_defs.append(d)
                rd = self.new()
                self.eq(rd, operand_defs[1], -take)
                self.eq(rd, operand_defs[0], take)
                for e in range(q):
                    self.eq(rd, self.defined[e][t], -self.ex[e][g])
                self.cl(rd, *[self.ex[e][g] for e in range(q)])
                for r, mask in enumerate(masks):
                    actual = []
                    for table, use, fresh in operands:
                        bit = self.new()
                        for e in range(q):
                            self.eq(bit, self.rows[e][t][r], -use[e])
                        self.eq(bit, table[mask], *use)
                        actual.append(bit)
                    result = self.new()
                    self.eq(result, actual[1], -take, -rd)
                    self.eq(result, actual[0], take, -rd)
                    for e in range(q):
                        self.eq(result, self.rows[e][t][r], -self.ex[e][g], -rd)
                    self.eq(result, self.truth[n+g][mask], *[self.ex[e][g] for e in range(q)], -rd)
        if dependency:
            self.cl(*self.dependency_witnesses)
        self.edges = {}
        for index, (edge, witnesses) in enumerate(edge_witnesses.items()):
            ed = self.new()
            self.edges[edge] = ed
            self.cl(-ed, *witnesses)
            for w in witnesses:
                self.cl(-w, ed)
            if topology is not None:
                self.cl(ed if topology >> index & 1 else -ed)
        for j, picks in enumerate(self.out):
            self.eo(picks)
            for x, pick in enumerate(picks):
                if x >= n:
                    for e in range(q):
                        self.cl(-pick, -self.ex[e][x-n])
                if output_requirements:
                    for mask in range(1, (1 << n)-1):
                        self.eq(self.truth[x][mask], mask.bit_count() >= n-j, -pick)
        if symmetry and first_pair and flags is None:
            self.canonicalize()

    def canonicalize(self):
        n, m = self.n, self.m
        for j in range(self.c):
            for a in range(n+m):
                for b in range(a):
                    self.cl(-self.cmp[j][0][a], -self.cmp[j][1][b])
        for g in range(m):
            self.cl(-self.mov[g], -self.high[g])
            self.cl(-self.mov[g], -self.inclusive[g])
        selectors = [p for g in range(m) for p in (self.dst[g], self.src[g])]
        selectors += [p for row in self.cmp for p in row]
        selectors += self.out
        seen = {j: [] for j in range(2, n)}
        for picks in selectors:
            for j in range(3, n):
                self.cl(-picks[j], *seen[j-1])
            for j in range(2, n):
                seen[j].append(picks[j])


def digest(path):
    h = hashlib.sha256()
    with Path(path).open('rb') as src:
        for chunk in iter(lambda: src.read(1024*1024), b''):
            h.update(chunk)
    return h.hexdigest()


def solve(enc, tag, seconds=30, proof=False):
    tag = Path(tag)
    cnf = tag.with_suffix('.cnf')
    enc.dimacs(cnf)
    record = dict(variables=enc.nv, clauses=len(enc.cs), cnf=str(cnf),
                  cnf_sha256=digest(cnf), n=enc.n, k=enc.k, c=enc.c,
                  q=enc.q, orders=len(enc.types), tag=str(tag),
                  source_sha256=digest(__file__), base_sha256=digest(Path(__file__).with_name('base_sat.py')))
    enc.cs.clear()
    gc.collect()
    start = time.monotonic()
    before = resource.getrusage(resource.RUSAGE_CHILDREN)
    cmd = [str(PROJECT/'bin/kissat'), '--time='+str(seconds), str(cnf)]
    if proof:
        cmd.append(str(tag)+'.drat')
    with open(str(tag)+'.solver', 'w') as out:
        try:
            p = subprocess.run(cmd, stdout=out, stderr=subprocess.STDOUT, timeout=seconds+10)
            record['returncode'] = p.returncode
        except subprocess.TimeoutExpired:
            record['returncode'] = 124
    record['status'] = 'UNKNOWN'
    model = []
    for line in Path(str(tag)+'.solver').read_text().splitlines():
        if line.startswith('s '):
            record['status'] = line[2:].strip()
        if line.startswith('v '):
            model += [int(x) for x in line[2:].split() if int(x)]
    if record['status'] == 'SATISFIABLE':
        yes = {x for x in model if x > 0}
        with cnf.open() as src:
            next(src)
            for line in src:
                lits = [int(x) for x in line.split()[:-1]]
                assert any((x in yes) if x > 0 else (-x not in yes) for x in lits)
        record['assignment_checked'] = True
        record['partial_positions'] = [[i for i, x in enumerate(p) if x in yes][0]
                                       for p in enc.positions]
        Path(str(tag)+'.s').write_text(enc.decode(model).replace('source=w10_partial_sat', 'source=w1_partial_shapes'))
    after = resource.getrusage(resource.RUSAGE_CHILDREN)
    record.update(command=cmd, seconds=seconds,
                  solver_cpu_seconds=after.ru_utime-before.ru_utime+after.ru_stime-before.ru_stime,
                  maxrss_kib=after.ru_maxrss, elapsed_seconds=time.monotonic()-start,
                  exhaustive_program_count=0 if record['status'] == 'UNSATISFIABLE' else None)
    return record


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--n', type=int, default=5)
    ap.add_argument('--k', type=int, default=31)
    ap.add_argument('--c', type=int, default=9)
    ap.add_argument('--q', type=int, default=3)
    ap.add_argument('--minimum', type=int, default=3)
    ap.add_argument('--slots')
    ap.add_argument('--cases', choices=['strict', 'weak'], default='strict')
    ap.add_argument('--flag-program')
    ap.add_argument('--fixed')
    ap.add_argument('--blocks')
    ap.add_argument('--dependency', action='store_true')
    ap.add_argument('--topology', type=int)
    ap.add_argument('--free-first', action='store_true')
    ap.add_argument('--no-symmetry', action='store_true')
    ap.add_argument('--timeout', type=int, default=120)
    ap.add_argument('--proof', action='store_true')
    ap.add_argument('--tag', required=True)
    args = ap.parse_args()
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19
    resource.setrlimit(resource.RLIMIT_AS, (2400*1024**2, 2400*1024**2))
    start = time.monotonic()
    types = weak_orders(args.n) if args.cases == 'weak' else list(itertools.permutations(range(args.n)))
    flags = program_flags(types, args.flag_program) if args.flag_program else None
    if flags is not None:
        assert len(flags) == args.c
    slots = None if args.slots is None else tuple(int(x) for x in args.slots.split(',') if x)
    blocks = None
    if args.blocks:
        counts = list(map(int, args.blocks.split(',')))
        assert len(counts) == args.c and sum(counts) == args.k-args.c
        blocks = [j for j, count in enumerate(counts) for _ in range(count)]
    enc = PartialShapes(args.n, args.k, args.c, args.q, types, args.minimum,
                        flags, blocks, not args.free_first,
                        not args.no_symmetry and not args.fixed, slots, args.dependency, args.topology)
    if args.fixed:
        enc.fix_program(Path(args.fixed).read_text())
    print(json.dumps(dict(step='built', variables=enc.nv, clauses=len(enc.cs),
                          build_seconds=time.monotonic()-start, args=vars(args))), flush=True)
    record = solve(enc, args.tag, args.timeout, args.proof)
    record.update(args=vars(args), total_seconds=time.monotonic()-start,
                  fixed_sha256=digest(args.fixed) if args.fixed else None,
                  flag_program_sha256=digest(args.flag_program) if args.flag_program else None,
                  process_maxrss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,
                  nice=os.getpriority(os.PRIO_PROCESS, 0))
    Path(args.tag+'.json').write_text(json.dumps(record, indent=2)+'\n')
    print(json.dumps(record), flush=True)


if __name__ == '__main__':
    main()
