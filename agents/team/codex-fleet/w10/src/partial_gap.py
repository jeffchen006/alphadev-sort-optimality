#!/usr/bin/env python3
"""Round 4: at most B garbage-containing data columns [A15].

This extends partial_sat.Encoding without changing the older formulas.
Count each written SSA value with an undefined entry, not scratch names.
In gap mode, every other column must be a full lattice function.
In arbitrary mode, fully defined non-lattice columns are also allowed.
An exact has-undefined flag is used, rather than a selectable witness.
The formula requires a partial column that a later counted instruction reads.
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

from partial_sat import Encoding, PROJECT, program_flags, weak_orders


class GapEncoding(Encoding):
    def canonicalize(self):
        """Use only when flag columns are free and the first input pair is fixed."""
        n, m = self.n, self.m
        start = len(self.cs)
        for j in range(self.c):
            for a in range(n+m):
                for b in range(a):
                    self.cl(-self.cmp[j][0][a], -self.cmp[j][1][b])
        for g in range(m):
            self.cl(-self.mov[g], -self.high[g])
            self.cl(-self.mov[g], -self.inclusive[g])
        # Canonical first-reference order for the inputs outside the first pair.
        selectors = [p for g in range(m) for p in (self.dst[g], self.src[g])]
        selectors += [p for row in self.cmp for p in row]
        selectors += self.out
        seen = {j: [] for j in range(2, n)}
        for picks in selectors:
            for j in range(3, n):
                self.cl(-picks[j], *seen[j-1])
            for j in range(2, n):
                seen[j].append(picks[j])
        return len(self.cs)-start

    def restrict_columns(self, bound=3, pure=False, allow_nonlattice=False):
        start = self.nv, len(self.cs)
        self.garbage = []
        witnesses = []
        for g in range(self.m):
            column = self.val[self.n+g]
            undefined = [self.value_is(row, self.n) for row in column]
            has_undefined = self.new()
            self.garbage.append(has_undefined)
            # has_undefined <=> OR(undefined), including all-undefined columns.
            self.cl(-has_undefined, *undefined)
            for u in undefined:
                self.cl(-u, has_undefined)
            if pure:
                self.cl(-has_undefined)
            if not allow_nonlattice:
                first = len(self.cs)
                self.add_lattice(column)
                # A lattice constraint applies only when no entry is undefined.
                for i in range(first, len(self.cs)):
                    self.cs[i].append(has_undefined)
            # A witness must be defined on at least one execution and read later.
            witness = self.new()
            witnesses.append(witness)
            self.cl(-witness, has_undefined)
            self.cl(-witness, *[-u for u in undefined])
            uses = [self.src[h][self.n+g] for h in range(g+1, self.m)]
            uses += [self.dst[h][self.n+g] for h in range(g+1, self.m)]
            uses += [self.cmp[j][s][self.n+g]
                     for j in range(self.c) for s in range(2)]
            self.cl(-witness, *uses)
        if not pure:
            self.cl(*witnesses)
        # Pairwise combinations give an exact cardinality bound with no counters.
        for indices in itertools.combinations(self.garbage, bound+1):
            self.cl(*[-u for u in indices])
        self.gap_size = dict(variables=self.nv-start[0],
                             clauses=len(self.cs)-start[1])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--n', type=int, default=5)
    ap.add_argument('--k', type=int, default=31)
    ap.add_argument('--c', type=int, default=9)
    ap.add_argument('--bound', type=int, default=3)
    ap.add_argument('--mode', choices=['gap', 'pure', 'arbitrary'], default='gap')
    ap.add_argument('--cases', choices=['strict', 'weak'], default='strict')
    ap.add_argument('--flag-program')
    ap.add_argument('--blocks', help='Counts after each comparison; default free')
    ap.add_argument('--fixed')
    ap.add_argument('--free-first', action='store_true')
    ap.add_argument('--timeout', type=int, default=300)
    ap.add_argument('--proof', action='store_true')
    ap.add_argument('--tag', required=True)
    args = ap.parse_args()
    resource.setrlimit(resource.RLIMIT_AS, (2400*1024**2, 2400*1024**2))
    start = time.monotonic()
    types = (weak_orders(args.n) if args.cases == 'weak'
             else list(itertools.permutations(range(args.n))))
    flags = program_flags(types, args.flag_program) if args.flag_program else None
    if flags is not None:
        assert len(flags) == args.c
    blocks = None
    if args.blocks:
        counts = list(map(int, args.blocks.split(',')))
        assert len(counts) == args.c and sum(counts) == args.k-args.c
        blocks = [j for j, count in enumerate(counts) for _ in range(count)]
    enc = GapEncoding(args.n, args.k, args.c, types, 'full', flags=flags,
                      first_pair=not args.free_first, blocks=blocks, origin=True)
    enc.restrict_columns(args.bound, args.mode == 'pure', args.mode == 'arbitrary')
    symmetry_clauses = 0
    if flags is None and not args.free_first and not args.fixed:
        symmetry_clauses = enc.canonicalize()
    if args.fixed:
        enc.fix_program(Path(args.fixed).read_text())
    cnf = Path(args.tag+'.cnf')
    enc.dimacs(cnf)
    record = dict(vars(args), orders=len(types), variables=enc.nv,
                  clauses=len(enc.cs), gap_size=enc.gap_size,
                  symmetry_clauses=symmetry_clauses,
                  build_seconds=time.monotonic()-start,
                  cnf_sha256=hashlib.sha256(cnf.read_bytes()).hexdigest(),
                  count_kind='All satisfying programs: zero only if UNSAT; otherwise unknown',
                  registers='Unbounded creation-order values',
                  bound_kind='Written data columns with any undefined entry',
                  encoder_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
                  base_encoder_sha256=hashlib.sha256(Path(__file__).with_name('partial_sat.py').read_bytes()).hexdigest(),
                  flag_program_sha256=(hashlib.sha256(Path(args.flag_program).read_bytes()).hexdigest()
                                       if args.flag_program else None),
                  fixed_program_sha256=(hashlib.sha256(Path(args.fixed).read_bytes()).hexdigest()
                                        if args.fixed else None))
    Path(args.tag+'.built.json').write_text(json.dumps(record, indent=2)+'\n')
    print(json.dumps(dict(step='built', **record)), flush=True)
    enc.cs.clear()
    gc.collect()
    command = [str(PROJECT/'bin/kissat'), '--time='+str(args.timeout), str(cnf)]
    if args.proof:
        command.append(args.tag+'.drat')
    usage_before = resource.getrusage(resource.RUSAGE_CHILDREN)
    with open(args.tag+'.solver', 'w') as out:
        try:
            p = subprocess.run(command, stdout=out, stderr=subprocess.STDOUT,
                               timeout=args.timeout+5)
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
                cl = [int(x) for x in line.split()[:-1]]
                assert any((x in yes) if x > 0 else (-x not in yes) for x in cl)
        Path(args.tag+'.s').write_text(enc.decode(model))
        record['assignment_checked'] = True
        record['partial_nodes'] = [g for g, u in enumerate(enc.garbage) if u in yes]
    record['exhaustive_program_count'] = (0 if record['status'] == 'UNSATISFIABLE'
                                          else None)
    usage_after = resource.getrusage(resource.RUSAGE_CHILDREN)
    record['solver_cpu_seconds'] = ((usage_after.ru_utime-usage_before.ru_utime)+
                                    (usage_after.ru_stime-usage_before.ru_stime))
    record['solver_maxrss_kib'] = usage_after.ru_maxrss
    record['elapsed_seconds'] = time.monotonic()-start
    Path(args.tag+'.json').write_text(json.dumps(record, indent=2)+'\n')
    print(json.dumps(record), flush=True)


if __name__ == '__main__':
    main()
