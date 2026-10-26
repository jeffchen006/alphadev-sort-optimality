#!/usr/bin/env python3
"""Independent C2 encoder. No imports from another worker or earlier encoder.

Each data write is a new value version. Values use four threshold bits per
strict input order. All but at most two writes must agree with monotone subset
tables. Comparison operands may read either exceptional value.
"""
import argparse
import hashlib
import itertools
import json
from pathlib import Path
import re
import time


def sha(path):
    h = hashlib.sha256()
    with open(path, 'rb') as f:
        for b in iter(lambda: f.read(1 << 20), b''):
            h.update(b)
    return h.hexdigest()


class Formula:
    def __init__(self, path):
        self.path = Path(path)
        self.path.parent.mkdir(parents=True, exist_ok=True)
        self.body = self.path.with_suffix('.body')
        self.out = self.body.open('w')
        self.nv = self.nc = 0
        self.true = self.var()
        self.clause(self.true)

    def var(self):
        self.nv += 1
        return self.nv

    def clause(self, *xs):
        # Constants are simplified without changing variable numbering.
        if self.true in xs and xs != (self.true,):
            return
        xs = tuple(dict.fromkeys(x for x in xs if x != -self.true))
        if any(-x in xs for x in xs):
            return
        self.out.write(' '.join(map(str, xs)) + (' ' if xs else '') + '0\n')
        self.nc += 1

    def eq(self, a, b, guard=None):
        p = () if guard is None else (-guard,)
        self.clause(*p, -a, b)
        self.clause(*p, a, -b)

    def AND(self, *xs):
        if -self.true in xs:
            return -self.true
        xs = tuple(dict.fromkeys(x for x in xs if x != self.true))
        if not xs:
            return self.true
        if len(xs) == 1:
            return xs[0]
        z = self.var()
        for x in xs:
            self.clause(-z, x)
        self.clause(z, *(-x for x in xs))
        return z

    def OR(self, *xs):
        return -self.AND(*(-x for x in xs))

    def one(self, size):
        xs = [self.var() for _ in range(size)]
        self.clause(*xs)
        # Sequential at-most-one, independently written.
        seen = -self.true
        for x in xs:
            self.clause(-seen, -x)
            seen = self.OR(seen, x)
        return xs

    def mux(self, control, yes, no):
        if yes == no:
            return yes
        z = self.var()
        self.eq(z, yes, control)
        self.eq(z, no, -control)
        return z

    def select(self, choices, vectors):
        result = [self.var() for _ in vectors[0]]
        for sel, vector in zip(choices, vectors):
            for a, b in zip(result, vector):
                self.eq(a, b, sel)
        return result

    def finish(self):
        self.out.close()
        with self.path.open('w') as out, self.body.open() as inp:
            out.write(f'p cnf {self.nv} {self.nc}\n')
            for b in iter(lambda: inp.read(1 << 20), ''):
                out.write(b)
        self.body.unlink()


class Encoding:
    OPS = ('mov', 'cmovl', 'cmovle', 'cmovg', 'cmovge')

    def __init__(self, path, n=5, k=31, c=9, bound=2,
                 lattice_comparands=False, weak=False, useful=True,
                 conservation=True):
        self.n, self.k, self.c, self.m = n, k, c, k-c
        assert 0 < c <= k and self.m > 0
        self.f = f = Formula(path)
        self.orders = ([o for o in itertools.product(range(n), repeat=n)
                        if set(o) == set(range(max(o)+1))] if weak else
                       list(itertools.permutations(range(n))))
        # Even weak orders use all thresholds 1..n-1. Extra thresholds are zero.
        self.width = len(self.orders)*(n-1)
        self.values = [[f.true if order[v] >= t else -f.true
                        for order in self.orders for t in range(1, n)]
                       for v in range(n)]
        self.op = [f.one(5) for _ in range(self.m)]
        self.src = [f.one(n+i) for i in range(self.m)]
        # Last destination option is fresh, and is equivalent to mov.
        self.dst = [f.one(n+i+1) for i in range(self.m)]
        self.block = [f.one(c) for _ in range(self.m)]
        self.comparands = [[f.one(n+self.m), f.one(n+self.m)]
                           for _ in range(c)]
        self.outputs = [f.one(n+self.m) for _ in range(n)]
        self.exception = [f.var() for _ in range(self.m)]
        for subset in itertools.combinations(self.exception, bound+1):
            f.clause(*(-x for x in subset))
        self.shape = [[f.var() for _ in range(1 << n)]
                      for _ in range(self.m)]
        for i in range(self.m):
            f.eq(self.op[i][0], self.dst[i][-1])
            # Block indices cannot decrease along the data-write sequence.
            if i:
                for b in range(c):
                    f.clause(-self.block[i][b], *self.block[i-1][:b+1])
            shape = self.shape[i]
            f.clause(-shape[0])
            f.clause(shape[-1])
            for mask in range(1 << n):
                for bit in range(n):
                    if not (mask & (1 << bit)):
                        f.clause(-shape[mask], shape[mask | (1 << bit)])
            value = [f.var() for _ in range(self.width)]
            self.values.append(value)
            for q, order in enumerate(self.orders):
                for t in range(1, n):
                    mask = sum(1 << p for p in range(n) if order[p] >= t)
                    f.eq(value[q*(n-1)+t-1], shape[mask], -self.exception[i])

        # A full-value program starts with an input comparison after moving
        # fresh copies behind it. Input relabeling fixes the first pair.
        f.clause(self.comparands[0][0][0])
        f.clause(self.comparands[0][1][1])
        for j, pair in enumerate(self.comparands):
            for row in pair:
                for h in range(self.m):
                    f.clause(-row[n+h], *self.block[h][:j])
                    if lattice_comparands:
                        f.clause(-row[n+h], -self.exception[h])

        # cmov consumes its selected destination version. Once consumed, that
        # version cannot be read by a later data instruction or comparison.
        for i in range(self.m):
            for v, kill in enumerate(self.dst[i][:-1]):
                for later in range(i+1, self.m):
                    f.clause(-kill, -self.src[later][v])
                    f.clause(-kill, -self.dst[later][v])
                for j, pair in enumerate(self.comparands):
                    for row in pair:
                        f.clause(-kill, -row[v], *self.block[i][j:])

        self.flags = []
        for pair in self.comparands:
            a = f.select(pair[0], self.values)
            b = f.select(pair[1], self.values)
            flags = []
            for q in range(len(self.orders)):
                start = q*(n-1)
                lt = f.OR(*(f.AND(-a[t], b[t])
                            for t in range(start, start+n-1)))
                gt = f.OR(*(f.AND(a[t], -b[t])
                            for t in range(start, start+n-1)))
                flags.append((lt, gt))
            self.flags.append(flags)

        for i in range(self.m):
            source = f.select(self.src[i], self.values[:n+i])
            # The fresh mov destination has an arbitrary unused old value.
            old = f.select(self.dst[i], self.values[:n+i]+[self.values[0]])
            dataflags = f.select(self.block[i],
                                [[x for flags in block for x in flags]
                                 for block in self.flags])
            for q in range(len(self.orders)):
                lt, gt = dataflags[2*q:2*q+2]
                take = f.OR(self.op[i][0],
                            f.AND(self.op[i][1], lt),
                            f.AND(self.op[i][2], -gt),
                            f.AND(self.op[i][3], gt),
                            f.AND(self.op[i][4], -lt))
                for t in range(q*(n-1), (q+1)*(n-1)):
                    f.eq(self.values[n+i][t], source[t], take)
                    f.eq(self.values[n+i][t], old[t], -take)

        if useful:
            for j in range(c):
                f.clause(*(f.AND(self.block[i][j], -self.op[i][0])
                           for i in range(self.m)))
        for rank, row in enumerate(self.outputs):
            for v, choice in enumerate(row):
                for q, order in enumerate(self.orders):
                    expected = sorted(order)[rank]
                    for t in range(1, n):
                        bit = self.values[v][q*(n-1)+t-1]
                        f.clause(-choice, bit if expected >= t else -bit)
        if conservation:
            # No permitted instruction can recover an input value after its
            # final register copy is lost. A prior output snapshot is enough.
            equal = []
            for value in self.values:
                rows = []
                for q in range(len(self.orders)):
                    start = q*(n-1)
                    rows.append([f.AND(
                        value[start+r-1] if r else f.true,
                        -value[start+r] if r < n-1 else f.true)
                        for r in range(n)])
                equal.append(rows)
            for i in range(self.m):
                live = []
                for v in range(n+i+1):
                    first_kill = 0 if v < n else v-n+1
                    live.append(f.AND(*(-self.dst[h][v]
                                        for h in range(first_kill, i+1))))
                already = [f.OR(*row[:n+i+1]) for row in self.outputs]
                for q in range(len(self.orders)):
                    # For strict orders, rank r occurs once. Extra ranks in a
                    # weak order are irrelevant and must not be preserved.
                    for r in set(self.orders[q]):
                        out_rank = next(j for j, x in enumerate(sorted(self.orders[q]))
                                        if x == r)
                        f.clause(already[out_rank], *(
                            f.AND(live[v], equal[v][q][r])
                            for v in range(n+i+1)))
        self.config = dict(n=n, k=k, c=c, bound=bound, useful=useful,
                           weak=weak, lattice_comparands=lattice_comparands,
                           conservation=conservation)

    def fix_program(self, path):
        """Fix syntactic controls using an independent version-name parser."""
        f, n = self.f, self.n
        current = {f'P{i}': i for i in range(n)}
        data, block = 0, -1
        for line in Path(path).read_text().splitlines():
            line = line.partition('#')[0].strip()
            if not line:
                continue
            op, rest = line.split(None, 1)
            a, b = [s.strip() for s in rest.split(',')]
            if op == 'cmp':
                block += 1
                for row, reg in zip(self.comparands[block], (a, b)):
                    f.clause(row[current[reg]])
            elif op == 'out':
                f.clause(self.outputs[int(a)][current[b]])
            else:
                f.clause(self.op[data][self.OPS.index(op)])
                f.clause(self.block[data][block])
                f.clause(self.src[data][current[b]])
                if op != 'mov':
                    f.clause(self.dst[data][current[a]])
                current[a] = n+data
                data += 1
        assert (data, block+1) == (self.m, self.c)

    def metadata(self):
        return dict(config=self.config, orders=len(self.orders),
                    variables=self.f.nv, clauses=self.f.nc,
                    op=self.op, src=self.src, dst=self.dst,
                    block=self.block, comparands=self.comparands,
                    outputs=self.outputs, exception=self.exception,
                    encoder_sha256=sha(__file__))


def decode(meta, model):
    yes = {x for x in model if x > 0}
    def selected(row):
        found = [i for i, v in enumerate(row) if v in yes]
        assert len(found) == 1, found
        return found[0]
    n = meta['config']['n']
    c = meta['config']['c']
    names = [f'P{i}' for i in range(n)]
    snapshots = [[] for _ in range(n+len(meta['op']))]
    for j, row in enumerate(meta['outputs']):
        snapshots[selected(row)].append(j)
    code = [f'# n={n} model=out iset=I1 source=w11_independent_c2']
    for v in range(n):
        code.extend(f'out {j}, {names[v]}' for j in snapshots[v])
    data = 0
    for block in range(c):
        a, b = [names[selected(row)] for row in meta['comparands'][block]]
        code.append(f'cmp {a}, {b}')
        while data < len(meta['op']) and selected(meta['block'][data]) == block:
            op = Encoding.OPS[selected(meta['op'][data])]
            src = names[selected(meta['src'][data])]
            dst = (f'S{data}' if op == 'mov' else
                   names[selected(meta['dst'][data])])
            code.append(f'{op} {dst}, {src}')
            names.append(dst)
            code.extend(f'out {j}, {dst}' for j in snapshots[n+data])
            data += 1
    assert data == len(meta['op'])
    return '\n'.join(code)+'\n'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--n', type=int, default=5)
    ap.add_argument('--k', type=int, default=31)
    ap.add_argument('--c', type=int, default=9)
    ap.add_argument('--bound', type=int, default=2)
    ap.add_argument('--lattice-comparands', action='store_true')
    ap.add_argument('--weak', action='store_true')
    ap.add_argument('--allow-unused-comparisons', action='store_true')
    ap.add_argument('--no-conservation', action='store_true')
    ap.add_argument('--fixed')
    ap.add_argument('--tag', required=True)
    args = ap.parse_args()
    started = time.monotonic()
    enc = Encoding(args.tag+'.cnf', args.n, args.k, args.c, args.bound,
                   args.lattice_comparands, args.weak,
                   not args.allow_unused_comparisons, not args.no_conservation)
    if args.fixed:
        enc.fix_program(args.fixed)
    meta = enc.metadata()
    enc.f.finish()
    meta.update(cnf_sha256=sha(args.tag+'.cnf'),
                build_seconds=time.monotonic()-started, fixed=args.fixed)
    Path(args.tag+'.json').write_text(json.dumps(meta)+'\n')
    print(json.dumps({k: v for k, v in meta.items()
                      if k not in ('op', 'src', 'dst', 'block', 'comparands',
                                   'outputs', 'exception')}), flush=True)


if __name__ == '__main__':
    main()
