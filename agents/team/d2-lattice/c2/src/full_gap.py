#!/usr/bin/env python3
"""Full-column relaxation of the three-partial-column A15 gap.

At most B data columns may be non-lattice. Comparisons and outputs use lattice
columns. Every data value is fully defined. The same-length garbage-removal
construction maps the original partial-column class into this class.
Exception selectors need not denote genuinely non-lattice values: they give
an upper bound and therefore an overapproximation, never an underapproximation.
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
from partial_gap import GapEncoding


class FullEncoding(Encoding):
    canonicalize = GapEncoding.canonicalize

    def restrict(self, bound):
        self.exception = self.vec(self.m)
        for g in range(self.m):
            # A never-taken garbage-source cmov is an identity and can be
            # replaced by a mov from its old destination, with a fresh name.
            self.cl(-self.src[g][-1])
            # A full first cmov into scratch must always take; mov is equivalent.
            self.cl(-self.dst[g][-1], self.mov[g])
            column = self.val[self.n+g]
            for row in column:
                self.cl(*self.unequal_guard(row, self.n))
            first = len(self.cs)
            self.add_lattice(column)
            for i in range(first, len(self.cs)):
                self.cs[i].append(self.exception[g])
            for j in range(self.c):
                for side in range(2):
                    self.cl(-self.exception[g], -self.cmp[j][side][self.n+g])
            for j in range(self.n):
                self.cl(-self.exception[g], -self.out[j][self.n+g])
        for values in itertools.combinations(self.exception, bound+1):
            self.cl(*[-x for x in values])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--n', type=int, default=5)
    ap.add_argument('--k', type=int, default=31)
    ap.add_argument('--c', type=int, default=9)
    ap.add_argument('--bound', type=int, default=3)
    ap.add_argument('--cases', choices=['strict', 'weak'], default='strict')
    ap.add_argument('--flag-program')
    ap.add_argument('--fixed')
    ap.add_argument('--free-first', action='store_true')
    ap.add_argument('--timeout', type=int, default=600)
    ap.add_argument('--proof', action='store_true')
    ap.add_argument('--tag', required=True)
    args = ap.parse_args()
    assert 0 <= args.bound <= args.k-args.c
    resource.setrlimit(resource.RLIMIT_AS, (2400*1024**2, 2400*1024**2))
    start = time.monotonic()
    types = (weak_orders(args.n) if args.cases == 'weak'
             else list(itertools.permutations(range(args.n))))
    flags = program_flags(types, args.flag_program) if args.flag_program else None
    if flags is not None:
        assert len(flags) == args.c
    enc = FullEncoding(args.n, args.k, args.c, types, 'full', flags=flags,
                       first_pair=not args.free_first, origin=True)
    enc.restrict(args.bound)
    symmetry = 0
    if flags is None and not args.fixed and not args.free_first:
        symmetry = enc.canonicalize()
    if args.fixed:
        enc.fix_program(Path(args.fixed).read_text())
    cnf = Path(args.tag+'.cnf')
    enc.dimacs(cnf)
    record = dict(vars(args), mode='full-exceptions', blocks=None,
                  orders=len(types), variables=enc.nv, clauses=len(enc.cs),
                  symmetry_clauses=symmetry, build_seconds=time.monotonic()-start,
                  cnf_sha256=hashlib.sha256(cnf.read_bytes()).hexdigest(),
                  encoder_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
                  base_encoder_sha256=hashlib.sha256(Path(__file__).with_name('partial_sat.py').read_bytes()).hexdigest(),
                  symmetry_helper_sha256=hashlib.sha256(Path(__file__).with_name('partial_gap.py').read_bytes()).hexdigest(),
                  flag_program_sha256=(hashlib.sha256(Path(args.flag_program).read_bytes()).hexdigest()
                                       if args.flag_program else None),
                  fixed_program_sha256=(hashlib.sha256(Path(args.fixed).read_bytes()).hexdigest()
                                        if args.fixed else None),
                  bound_kind='At most B fully defined non-lattice written columns',
                  comparands='Lattice', output_columns='Lattice',
                  registers='Unbounded creation-order values')
    Path(args.tag+'.built.json').write_text(json.dumps(record, indent=2)+'\n')
    print(json.dumps(dict(step='built', **record)), flush=True)
    enc.cs.clear()
    gc.collect()
    cmd = [str(PROJECT/'bin/kissat'), '--time='+str(args.timeout), str(cnf)]
    if args.proof:
        cmd.append(args.tag+'.drat')
    before = resource.getrusage(resource.RUSAGE_CHILDREN)
    with open(args.tag+'.solver', 'w') as out:
        try:
            p = subprocess.run(cmd, stdout=out, stderr=subprocess.STDOUT,
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
                clause = [int(x) for x in line.split()[:-1]]
                assert any((x in yes) if x > 0 else (-x not in yes) for x in clause)
        Path(args.tag+'.s').write_text(enc.decode(model))
        record['assignment_checked'] = True
        record['selected_exception_slots'] = [g for g, x in enumerate(enc.exception) if x in yes]
    after = resource.getrusage(resource.RUSAGE_CHILDREN)
    record['solver_cpu_seconds'] = after.ru_utime-before.ru_utime+after.ru_stime-before.ru_stime
    record['solver_maxrss_kib'] = after.ru_maxrss
    record['elapsed_seconds'] = time.monotonic()-start
    record['exhaustive_program_count'] = 0 if record['status'] == 'UNSATISFIABLE' else None
    Path(args.tag+'.json').write_text(json.dumps(record, indent=2)+'\n')
    print(json.dumps(record), flush=True)


if __name__ == '__main__':
    main()
