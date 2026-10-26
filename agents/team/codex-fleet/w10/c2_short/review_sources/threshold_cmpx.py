#!/usr/bin/env python3
"""A15 SAT with shared Boolean tables and two exceptional full values.

Lattice shapes are free monotone truth tables on all input subsets.
Only the two selected exception values need separate entries per input order.
The encoded instruction semantics use threshold bits, not input identities.
"""
import argparse
import gc
import hashlib
import itertools
import json
from pathlib import Path
import resource
import subprocess
import time

from partial_sat import CNF, Encoding, PROJECT, program_flags, weak_orders
from partial_gap import GapEncoding


class ThresholdEncoding(CNF):
    decode = Encoding.decode
    fix_program = Encoding.fix_program
    canonicalize = GapEncoding.canonicalize

    def cl(self, *args):
        if any(x is True for x in args):
            return
        clause = set(x for x in args if x is not False)
        if any(-x in clause for x in clause):
            return
        self.cs.append(sorted(clause, key=lambda x: (abs(x), x)))

    def table(self, monotone=False):
        table = [False] + self.vec((1 << self.n)-2) + [True]
        if monotone:
            for mask in range(1 << self.n):
                for i in range(self.n):
                    if not mask >> i & 1:
                        self.cl(self.neg(table[mask]), table[mask | (1 << i)])
        return table

    def rows(self):
        result = [self.vec(len(masks)) for masks in self.masks]
        for row in result:
            for a, b in zip(row, row[1:]):
                self.cl(a, -b)
        return result

    def __init__(self, n=5, k=31, c=9, types=None, slots=None,
                 first_pair=True, flags=None, blocks=None, symmetry=True):
        super().__init__()
        self.n, self.k, self.c, self.m = n, k, c, k-c
        m = self.m
        self.types = types or list(itertools.permutations(range(n)))
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
        self.truth += [self.table(monotone=True) for _ in range(m)]
        self.exception_rows = [self.rows(), self.rows()]
        if slots is None:
            self.positions = [self.vec(m+1), self.vec(m+1)]
            for picks in self.positions:
                self.eo(picks)
            # Real positions are strictly increasing. m denotes no exception.
            for a in range(m+1):
                for b in range(m+1):
                    if (a == m and b < m) or (b < m and a >= b):
                        self.cl(-self.positions[0][a], -self.positions[1][b])
            self.ex = [picks[:-1] for picks in self.positions]
        else:
            assert len(slots) <= 2 and list(slots) == sorted(set(slots))
            self.positions = None
            self.ex = [[g == slot for g in range(m)]
                       for slot in list(slots)+[m]*(2-len(slots))]

        for g in range(m):
            for picks in (self.src[g], self.dst[g], self.blk[g]):
                self.eo(picks)
            self.cl(-self.mov[g], self.dst[g][-1])
            self.cl(-self.dst[g][-1], self.mov[g])
            self.cl(-self.src[g][-1])
            if g:
                for b in range(c):
                    for earlier in range(b):
                        self.cl(-self.blk[g-1][b], -self.blk[g][earlier])
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
        # d2-lattice V2: a cmp operand may be an exception (full non-lattice written value); its threshold bits
        # per input order are then the exception rows (same rule as for data operands below).
        for j in range(c):
            tables = [self.table(), self.table()]
            uses = [self.vec(2), self.vec(2)]
            for side in range(2):
                picks = self.cmp[j][side]
                self.eo(picks)
                for x, pick in enumerate(picks):
                    if x >= n:
                        self.cl(-pick, *self.blk[x-n][:j])
                    ee = [self.ex[s][x-n] if x >= n else False for s in range(2)]
                    for s in range(2):
                        self.eq(uses[side][s], ee[s], -pick)
                    for mask in range(1, (1 << n)-1):
                        self.eq(tables[side][mask], self.truth[x][mask], -pick, *ee)
            row = []
            for t, masks in enumerate(self.masks):
                ff = self.vec(3) if flags is None else [flags[j][t] == f for f in (-1, 0, 1)]
                bits = [[], []]
                for side in range(2):
                    for r, mask in enumerate(masks):
                        bit = self.new()
                        self.eq(bit, self.exception_rows[0][t][r], -uses[side][0])
                        self.eq(bit, self.exception_rows[1][t][r], -uses[side][1])
                        self.eq(bit, tables[side][mask], *uses[side])
                        bits[side].append(bit)
                for side, flag in ((0, ff[0]), (1, ff[2])):
                    differences = []
                    for r, mask in enumerate(masks):
                        a, b = bits[side][r], bits[1-side][r]
                        d = self.new()
                        self.cl(-d, self.neg(a))
                        self.cl(-d, b)
                        self.cl(d, a, self.neg(b))
                        self.cl(-d, flag)
                        differences.append(d)
                    self.cl(self.neg(flag), *differences)
                self.cl(self.neg(ff[1]), self.neg(ff[0]))
                self.cl(self.neg(ff[1]), self.neg(ff[2]))
                self.cl(ff[0], ff[1], ff[2])
                row.append(ff)
            self.fl.append(row)
        if first_pair:
            self.cl(self.cmp[0][0][0])
            self.cl(self.cmp[0][1][1])

        for g in range(m):
            operands = []
            for picks in (self.dst[g], self.src[g]):
                table = self.table()
                use = self.vec(2)
                for x, pick in enumerate(picks):
                    ee = [self.ex[s][x-n] if n <= x < n+g else False for s in range(2)]
                    for s in range(2):
                        self.eq(use[s], ee[s], -pick)
                    if x < n+g:
                        for mask in range(1, (1 << n)-1):
                            self.eq(table[mask], self.truth[x][mask], -pick, *ee)
                operands.append((table, use))
            for t, masks in enumerate(self.masks):
                take = self.new()
                self.cl(-self.mov[g], take)
                for j in range(c):
                    for f in range(3):
                        target = self.inclusive[g] if f == 1 else (self.high[g] if f == 2 else -self.high[g])
                        self.eq(take, target, self.mov[g], -self.blk[g][j], self.neg(self.fl[j][t][f]))
                for r, mask in enumerate(masks):
                    actual = []
                    for table, use in operands:
                        bit = self.new()
                        self.eq(bit, self.exception_rows[0][t][r], -use[0])
                        self.eq(bit, self.exception_rows[1][t][r], -use[1])
                        self.eq(bit, table[mask], *use)
                        actual.append(bit)
                    result = self.new()
                    self.eq(result, actual[1], -take)
                    self.eq(result, actual[0], take)
                    self.eq(result, self.exception_rows[0][t][r], self.neg(self.ex[0][g]))
                    self.eq(result, self.exception_rows[1][t][r], self.neg(self.ex[1][g]))
                    self.eq(result, self.truth[n+g][mask], self.ex[0][g], self.ex[1][g])

        for j, picks in enumerate(self.out):
            self.eo(picks)
            for x, pick in enumerate(picks):
                if x >= n:
                    for e in self.ex:
                        self.cl(-pick, self.neg(e[x-n]))
                for mask in range(1, (1 << n)-1):
                    self.eq(self.truth[x][mask], mask.bit_count() >= n-j, -pick)
        self.symmetry_clauses = 0
        if symmetry and first_pair and flags is None:
            self.symmetry_clauses = self.canonicalize()


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--n', type=int, default=5)
    ap.add_argument('--k', type=int, default=31)
    ap.add_argument('--c', type=int, default=9)
    ap.add_argument('--slots', help='comma-separated exact permitted exception positions; empty means none')
    ap.add_argument('--cases', choices=['strict', 'weak'], default='strict')
    ap.add_argument('--flag-program')
    ap.add_argument('--fixed')
    ap.add_argument('--blocks')
    ap.add_argument('--free-first', action='store_true')
    ap.add_argument('--no-symmetry', action='store_true')
    ap.add_argument('--timeout', type=int, default=300)
    ap.add_argument('--proof', action='store_true')
    ap.add_argument('--tag', required=True)
    args = ap.parse_args()
    resource.setrlimit(resource.RLIMIT_AS, (2400*1024**2, 2400*1024**2))
    start = time.monotonic()
    slots = None if args.slots is None else tuple(int(x) for x in args.slots.split(',') if x)
    types = weak_orders(args.n) if args.cases == 'weak' else list(itertools.permutations(range(args.n)))
    flags = program_flags(types, args.flag_program) if args.flag_program else None
    blocks = None
    if args.blocks:
        counts = list(map(int, args.blocks.split(',')))
        assert len(counts) == args.c and sum(counts) == args.k-args.c
        blocks = [j for j, count in enumerate(counts) for _ in range(count)]
    enc = ThresholdEncoding(args.n, args.k, args.c, types, slots, not args.free_first,
                            flags, blocks, not args.no_symmetry and not args.fixed)
    if args.fixed:
        enc.fix_program(Path(args.fixed).read_text())
    cnf = Path(args.tag+'.cnf')
    enc.dimacs(cnf)
    record = dict(vars(args), orders=len(types), variables=enc.nv, clauses=len(enc.cs),
                  build_seconds=time.monotonic()-start, cnf_sha256=digest(cnf),
                  encoder_sha256=digest(__file__),
                  base_sha256=digest(Path(__file__).with_name('partial_sat.py')),
                  symmetry_sha256=digest(Path(__file__).with_name('partial_gap.py')),
                  first_pair=not args.free_first, symmetry_clauses=enc.symmetry_clauses,
                  position_choices=enc.positions,
                  lattice_shapes='All monotone Boolean tables with endpoints 0 and 1',
                  exception_bound=2, comparison_values='Full lattice',
                  output_values='Full lattice', register_cap=None)
    Path(args.tag+'.built.json').write_text(json.dumps(record, indent=2)+'\n')
    print(json.dumps(dict(step='built', **record)), flush=True)
    enc.cs.clear()
    gc.collect()
    command = [str(PROJECT/'bin/kissat'), '--time='+str(args.timeout), str(cnf)]
    if args.proof:
        command.append(args.tag+'.drat')
    before = resource.getrusage(resource.RUSAGE_CHILDREN)
    with open(args.tag+'.solver', 'w') as out:
        try:
            p = subprocess.run(command, stdout=out, stderr=subprocess.STDOUT, timeout=args.timeout+5)
            record['returncode'] = p.returncode
        except subprocess.TimeoutExpired:
            record['returncode'] = 124
    record['status'] = 'UNKNOWN'
    model = []
    for line in Path(args.tag+'.solver').read_text().splitlines():
        if line.startswith('s '):
            record['status'] = line[2:].strip()
        if line.startswith('v '):
            model += [int(x) for x in line[2:].split() if int(x)]
    if record['status'] == 'SATISFIABLE':
        yes = {x for x in model if x > 0}
        with cnf.open() as source:
            next(source)
            for line in source:
                clause = [int(x) for x in line.split()[:-1]]
                assert any((x in yes) if x > 0 else (-x not in yes) for x in clause)
        Path(args.tag+'.s').write_text(enc.decode(model))
        record['assignment_checked'] = True
        record['selected_exception_slots'] = [[g for g, x in enumerate(row)
                                               if x is True or (x is not False and x in yes)]
                                              for row in enc.ex]
    after = resource.getrusage(resource.RUSAGE_CHILDREN)
    record['solver_cpu_seconds'] = after.ru_utime-before.ru_utime+after.ru_stime-before.ru_stime
    record['solver_maxrss_kib'] = after.ru_maxrss
    record['elapsed_seconds'] = time.monotonic()-start
    record['exhaustive_program_count'] = 0 if record['status'] == 'UNSATISFIABLE' else None
    Path(args.tag+'.json').write_text(json.dumps(record, indent=2)+'\n')
    print(json.dumps(record), flush=True)


if __name__ == '__main__':
    main()
