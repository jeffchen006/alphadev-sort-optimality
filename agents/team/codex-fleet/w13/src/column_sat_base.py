#!/usr/bin/env python3
"""Bounded column-program SAT search for A15.

One SSA node (single-assignment value) per mov/cmov. A mov allocates a fresh
register. A cmov consumes its old destination node; later reads of that node
are forbidden, except output snapshots. A fresh undefined destination is also
available. Comparisons must have defined operands on every encoded order.
This deliberately excludes comparisons of initial scratch garbage.

All counted instructions are grouped after comparisons. No instruction can
precede the first comparison. This is an explicit search restriction. There
is no register-count restriction: decoding allocates at most n + k registers.
All previous nodes can serve as output snapshots.

Pure lattice means each generated column is a full min/max polynomial. A
monotone Boolean truth table with endpoints 0/1 is linked to the column at
every input threshold. This is an exact test on the encoded weak orders.
"""
import argparse
import hashlib
import itertools
import json
from pathlib import Path
import resource
import subprocess
import time

PROJECT = Path('/path/to/repo')


def weak_orders(n):
    return [p for p in itertools.product(range(n), repeat=n)
            if set(p) == set(range(max(p) + 1))]


def network_flags(types, pairs):
    result = [[] for _ in pairs]
    for ty in types:
        row = list(ty)
        for j, (a, b) in enumerate(pairs):
            result[j].append((row[a] > row[b]) - (row[a] < row[b]))
            row[a], row[b] = min(row[a], row[b]), max(row[a], row[b])
    return result


def program_flags(types, path):
    instructions = []
    for line in Path(path).read_text().splitlines():
        line = line.split('#')[0].strip()
        if line:
            op, rest = line.split(None, 1)
            instructions.append((op, *[x.strip() for x in rest.split(',')]))
    traces = []
    for ty in types:
        regs = {f'P{i}': value for i, value in enumerate(ty)}
        flag, trace = 0, []
        for op, a, b in instructions:
            if op == 'out':
                continue
            if op == 'cmp':
                u, v = regs.get(a), regs.get(b)
                assert u is not None and v is not None
                flag = (u > v) - (u < v)
                trace.append(flag)
            elif op == 'mov' or {'cmovl': flag < 0, 'cmovle': flag <= 0,
                                  'cmovg': flag > 0, 'cmovge': flag >= 0}[op]:
                regs[a] = regs.get(b)
        traces.append(trace)
    return [list(row) for row in zip(*traces)]


class CNF:
    def __init__(self):
        self.nv = 0
        self.cs = []

    def new(self):
        self.nv += 1
        return self.nv

    def vec(self, n):
        return [self.new() for _ in range(n)]

    @staticmethod
    def neg(x):
        return not x if isinstance(x, bool) else -x

    def cl(self, *args):
        if any(x is True for x in args):
            return
        self.cs.append([x for x in args if x is not False])

    def eq(self, a, b, *guard):
        self.cl(*guard, self.neg(a), b)
        self.cl(*guard, a, self.neg(b))

    def eo(self, values):
        self.cl(*values)
        for a, b in itertools.combinations(values, 2):
            self.cl(-a, -b)

    def equal_value(self, bits, value, *guard):
        for b, bit in enumerate(bits):
            self.cl(*guard, bit if value >> b & 1 else self.neg(bit))

    def unequal_guard(self, bits, value):
        return [self.neg(bit) if value >> b & 1 else bit
                for b, bit in enumerate(bits)]

    def value_is(self, bits, value):
        q = self.new()
        self.equal_value(bits, value, -q)
        self.cl(q, *self.unequal_guard(bits, value))
        return q

    def dimacs(self, path):
        with open(path, 'w') as out:
            out.write(f'p cnf {self.nv} {len(self.cs)}\n')
            for cl in self.cs:
                out.write(' '.join(map(str, cl)) + ' 0\n')


class Encoding(CNF):
    def __init__(self, n, k, c, types, mode, flags=None, first_pair=True,
                 blocks=None, fixed=None, must_partial=False, origin=False,
                 live_all=False):
        super().__init__()
        self.n, self.k, self.c, self.types = n, k, c, types
        self.m = m = k - c
        self.mode = mode
        self.origin = origin
        self.nb = nb = n.bit_length()
        nt = len(types)
        assert m >= 0 and c > 0
        self.mov = self.vec(m)
        self.dst = [self.vec(n + g + 1) for g in range(m)]
        self.src = [self.vec(n + g + 1) for g in range(m)]
        self.blk = [self.vec(c) for g in range(m)]
        self.high = self.vec(m)
        self.inclusive = self.vec(m)
        self.cmp = [[self.vec(n + m) for _ in range(2)] for _ in range(c)]
        self.out = [self.vec(n + m) for _ in range(n)]
        self.val = [[[(bool((x if origin else ty[x]) >> b & 1)) for b in range(nb)]
                     for ty in types] for x in range(n)]
        self.val += [[self.vec(nb) for _ in types] for _ in range(m)]
        self.top = [bool(n >> b & 1) for b in range(nb)]
        self.partial = self.vec(m) if must_partial else []
        if origin and flags is not None:
            # Equal flag histories select equal input identities, even when
            # input ranks differ. This constraint follows from execution.
            for g in range(m):
                for j in range(c):
                    if blocks is not None and blocks[g] != j:
                        continue
                    groups = {}
                    for t in range(nt):
                        key = tuple(flags[q][t] for q in range(j+1))
                        if key not in groups:
                            groups[key] = t
                        else:
                            for b in range(nb):
                                self.eq(self.val[n+g][t][b], self.val[n+g][groups[key]][b],
                                        -self.blk[g][j])
        if must_partial:
            self.cl(*self.partial)
        for g in range(m):
            for picks in (self.dst[g], self.src[g], self.blk[g]):
                self.eo(picks)
            # Last choice is a fresh undefined register, canonical for mov.
            self.cl(-self.mov[g], self.dst[g][-1])
            # Fresh garbage sources are included; they remain unknown.
            if g:
                for b in range(c):
                    for earlier in range(b):
                        self.cl(-self.blk[g-1][b], -self.blk[g][earlier])
            # A conditional write destroys the prior destination's live range.
            for x, d in enumerate(self.dst[g][:-1]):
                for h in range(g+1, m):
                    self.cl(self.mov[g], -d, -self.src[h][x])
                    self.cl(self.mov[g], -d, self.mov[h], -self.dst[h][x])
                for j in range(c):
                    for b in range(j):
                        for side in range(2):
                            self.cl(self.mov[g], -d, -self.blk[g][b],
                                    -self.cmp[j][side][x])
            if blocks is not None:
                self.cl(self.blk[g][blocks[g]])
        for j in range(c):
            for side in range(2):
                self.eo(self.cmp[j][side])
                for g in range(m):
                    self.cl(-self.cmp[j][side][n+g], *self.blk[g][:j])
        if first_pair:
            self.cl(self.cmp[0][0][0])
            self.cl(self.cmp[0][1][1])
        for picks in self.out:
            self.eo(picks)
        self.fl = []
        for j in range(c):
            row = []
            for t in range(nt):
                if flags is None:
                    ff = self.vec(3)
                    self.eo(ff)
                else:
                    ff = [flags[j][t] == f for f in (-1, 0, 1)]
                row.append(ff)
            self.fl.append(row)
        for j in range(c):
            cv = [[self.vec(nb) for _ in types] for _ in range(2)]
            for side in range(2):
                for x, pick in enumerate(self.cmp[j][side]):
                    for t in range(nt):
                        for b in range(nb):
                            self.eq(cv[side][t][b], self.val[x][t][b], -pick)
                for t in range(nt):
                    # Compare only defined input values, never garbage.
                    self.cl(*self.unequal_guard(cv[side][t], n))
            for t in range(nt):
                for u, v in itertools.product(range(n), repeat=2):
                    uu, vv = (types[t][u], types[t][v]) if origin else (u, v)
                    f = (uu > vv) - (uu < vv)
                    guard = self.unequal_guard(cv[0][t], u)
                    guard += self.unequal_guard(cv[1][t], v)
                    self.cl(*guard, self.fl[j][t][f+1])
        for g in range(m):
            dv = [self.vec(nb) for _ in types]
            sv = [self.vec(nb) for _ in types]
            for x in range(n+g+1):
                vv = [self.top] * nt if x == n+g else self.val[x]
                for t in range(nt):
                    for b in range(nb):
                        self.eq(dv[t][b], vv[t][b], -self.dst[g][x])
                        self.eq(sv[t][b], vv[t][b], -self.src[g][x])
            for t in range(nt):
                for b in range(nb):
                    self.eq(self.val[n+g][t][b], sv[t][b], -self.mov[g])
                for j in range(c):
                    for f in range(3):
                        guard = [self.mov[g], -self.blk[g][j], self.neg(self.fl[j][t][f])]
                        if f == 1:
                            for take in (False, True):
                                v = sv[t] if take else dv[t]
                                gg = guard + ([-self.inclusive[g]] if take else [self.inclusive[g]])
                                for b in range(nb):
                                    self.eq(self.val[n+g][t][b], v[b], *gg)
                        else:
                            for high in (False, True):
                                take = (f == 2) == high
                                v = sv[t] if take else dv[t]
                                gg = guard + ([-self.high[g]] if high else [self.high[g]])
                                for b in range(nb):
                                    self.eq(self.val[n+g][t][b], v[b], *gg)
            if must_partial:
                undefs = [self.value_is(row, n) for row in self.val[n+g]]
                self.cl(-self.partial[g], -self.mov[g])
                self.cl(-self.partial[g], *undefs)
                self.cl(-self.partial[g], *[-q for q in undefs])
                # The partial result must be read by a later counted instruction.
                uses = [self.src[h][n+g] for h in range(g+1, m)]
                uses += [self.dst[h][n+g] for h in range(g+1, m)]
                uses += [self.cmp[j][s][n+g] for j in range(c) for s in range(2)]
                self.cl(-self.partial[g], *uses)
            if mode == 'lattice':
                self.add_lattice(self.val[n+g])
            if live_all:
                uses = [self.src[h][n+g] for h in range(g+1, m)]
                uses += [self.dst[h][n+g] for h in range(g+1, m)]
                uses += [self.cmp[j][s][n+g] for j in range(c) for s in range(2)]
                uses += [self.out[j][n+g] for j in range(n)]
                self.cl(*uses)
        for j in range(n):
            for x, pick in enumerate(self.out[j]):
                for t, ty in enumerate(types):
                    if origin:
                        for u in range(n+1):
                            if u == n or ty[u] != sorted(ty)[j]:
                                self.cl(-pick, *self.unequal_guard(self.val[x][t], u))
                    else:
                        self.equal_value(self.val[x][t], sorted(ty)[j], -pick)
        if fixed:
            self.fix_program(Path(fixed).read_text())

    def add_lattice(self, column):
        n = self.n
        truth = self.vec(1 << n)
        self.cl(-truth[0])
        self.cl(truth[-1])
        for mask in range(1 << n):
            for i in range(n):
                if not mask >> i & 1:
                    self.cl(-truth[mask], truth[mask | (1 << i)])
        for t, ty in enumerate(self.types):
            self.cl(*self.unequal_guard(column[t], n))
            for threshold in range(1, max(ty) + 1):
                mask = sum(1 << i for i, value in enumerate(ty) if value >= threshold)
                for value in range(n):
                    self.cl(*self.unequal_guard(column[t], value),
                            truth[mask] if (ty[value] if self.origin else value) >= threshold else -truth[mask])

    def fix_program(self, text):
        cur = {f'P{i}': i for i in range(self.n)}
        g, j = 0, -1
        for line in text.splitlines():
            line = line.split('#')[0].strip()
            if not line:
                continue
            op, rest = line.split(None, 1)
            a, b = [s.strip() for s in rest.split(',')]
            if op == 'out':
                self.cl(self.out[int(a)][cur[b]])
                continue
            if op == 'cmp':
                j += 1
                self.cl(self.cmp[j][0][cur[a]])
                self.cl(self.cmp[j][1][cur[b]])
                continue
            assert j >= 0 and g < self.m
            self.cl(self.mov[g] if op == 'mov' else -self.mov[g])
            self.cl(self.blk[g][j])
            self.cl(self.src[g][cur.get(b, self.n+g)])
            self.cl(self.dst[g][self.n+g if op == 'mov' else cur.get(a, self.n+g)])
            if op != 'mov':
                self.cl(self.high[g] if op in ('cmovg', 'cmovge') else -self.high[g])
                self.cl(self.inclusive[g] if op in ('cmovle', 'cmovge') else -self.inclusive[g])
            cur[a] = self.n+g
            g += 1
        assert g == self.m and j+1 == self.c

    def decode(self, model):
        yes = {x for x in model if x > 0}
        pick = lambda ls: next(i for i, x in enumerate(ls) if x in yes)
        n, m = self.n, self.m
        names = {x: f'P{x}' for x in range(n)}
        outnodes = [pick(row) for row in self.out]
        lines = [f'# n={n} R={n+2*m} model=out iset=I1 source=w10_partial_sat']
        nextscratch = 0

        def fresh():
            nonlocal nextscratch
            result = f'S{nextscratch}'
            nextscratch += 1
            return result

        def outputs(x):
            for j, node in enumerate(outnodes):
                if x == node:
                    lines.append(f'out {j}, {names[x]}')

        for x in range(n):
            outputs(x)
        g = 0
        for j in range(self.c):
            a, b = [pick(row) for row in self.cmp[j]]
            lines.append(f'cmp {names[a]}, {names[b]}')
            while g < m and pick(self.blk[g]) == j:
                d, s = pick(self.dst[g]), pick(self.src[g])
                source = fresh() if s == n+g else names[s]
                if self.mov[g] in yes:
                    dest, op = fresh(), 'mov'
                else:
                    dest = fresh() if d == n+g else names[d]
                    op = 'cmovg' if self.high[g] in yes else 'cmovl'
                    if self.inclusive[g] in yes:
                        op += 'e'
                lines.append(f'{op} {dest}, {source}')
                names[n+g] = dest
                outputs(n+g)
                g += 1
        assert g == m
        lines[0] = f'# n={n} R={n+nextscratch} model=out iset=I1 source=w10_partial_sat'
        return '\n'.join(lines) + '\n'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--n', type=int, default=4)
    ap.add_argument('--k', type=int, required=True)
    ap.add_argument('--c', type=int, required=True)
    ap.add_argument('--mode', choices=['partial', 'lattice', 'full'], required=True,
                    help='full permits any column and does not require a partial witness')
    ap.add_argument('--cases', choices=['weak', 'strict'], default='weak')
    ap.add_argument('--network', help='pairs such as 01,23,02,13,12; fixes flag columns only')
    ap.add_argument('--flag-program', help='fix flag columns to this program, leaving operands free')
    ap.add_argument('--blocks', help='number of data instructions after each comparison')
    ap.add_argument('--fixed')
    ap.add_argument('--free-first', action='store_true')
    ap.add_argument('--origin', action='store_true', help='store input identities instead of ranks')
    ap.add_argument('--live-all', action='store_true', help='require every data node to be read or output')
    ap.add_argument('--tag', required=True)
    ap.add_argument('--timeout', type=int, default=60)
    ap.add_argument('--proof', action='store_true')
    ap.add_argument('--release-clauses', action='store_true', help='free CNF memory before solving')
    args = ap.parse_args()
    resource.setrlimit(resource.RLIMIT_AS, (2400*1024*1024, 2400*1024*1024))
    start = time.monotonic()
    types = weak_orders(args.n) if args.cases == 'weak' else list(itertools.permutations(range(args.n)))
    flags = None
    assert not (args.network and args.flag_program)
    if args.network:
        pairs = [tuple(map(int, p)) for p in args.network.split(',')]
        assert len(pairs) == args.c
        flags = network_flags(types, pairs)
    if args.flag_program:
        flags = program_flags(types, args.flag_program)
        assert len(flags) == args.c
    blocks = None
    if args.blocks:
        counts = list(map(int, args.blocks.split(',')))
        assert len(counts) == args.c and sum(counts) == args.k - args.c
        blocks = [j for j, cnt in enumerate(counts) for _ in range(cnt)]
    enc = Encoding(args.n, args.k, args.c, types, args.mode, flags,
                   not args.free_first, blocks, args.fixed, args.mode == 'partial',
                   args.origin, args.live_all)
    cnf = args.tag + '.cnf'
    enc.dimacs(cnf)
    record = vars(args).copy()
    record.update(variables=enc.nv, clauses=len(enc.cs), orders=len(types),
                  build_seconds=time.monotonic()-start,
                  cnf_sha256=hashlib.sha256(Path(cnf).read_bytes()).hexdigest())
    if args.release_clauses:
        enc.cs.clear()
        import gc
        gc.collect()
    print(json.dumps(dict(step='built', **record)), flush=True)
    cmd = [str(PROJECT/'bin/kissat'), '--time='+str(args.timeout), cnf]
    if args.proof:
        cmd.append(args.tag + '.drat')

    def limit():
        resource.setrlimit(resource.RLIMIT_AS, (2400*1024*1024, 2400*1024*1024))

    with open(args.tag + '.solver', 'w') as log:
        try:
            p = subprocess.run(cmd, stdout=log, stderr=subprocess.STDOUT,
                               timeout=args.timeout+10, preexec_fn=limit)
            record['returncode'] = p.returncode
        except subprocess.TimeoutExpired:
            record['returncode'] = 124
    model = []
    record['status'] = 'UNKNOWN'
    for line in Path(args.tag + '.solver').read_text().splitlines():
        if line.startswith('s '):
            record['status'] = line[2:].strip()
        if line.startswith('v '):
            model += [int(x) for x in line[2:].split() if int(x)]
    record['elapsed_seconds'] = time.monotonic()-start
    if record['status'] == 'SATISFIABLE':
        # Independently check the complete satisfying assignment against CNF.
        yes = {x for x in model if x > 0}
        if args.release_clauses:
            with open(cnf) as source:
                next(source)
                for line in source:
                    cl = [int(x) for x in line.split()[:-1]]
                    assert any((lit in yes) if lit > 0 else (-lit not in yes) for lit in cl)
        else:
            assert all(any((lit in yes) if lit > 0 else (-lit not in yes) for lit in cl)
                       for cl in enc.cs)
        Path(args.tag + '.s').write_text(enc.decode(model))
        record['assignment_checked'] = True
    Path(args.tag + '.json').write_text(json.dumps(record, indent=2) + '\n')
    print(json.dumps(record), flush=True)


if __name__ == '__main__':
    main()
