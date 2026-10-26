#!/usr/bin/env python3
"""Proof-producing worker for independent CNF files.

An UNSAT result is accepted only after drat-trim verifies the saved proof.
Every formula and proof is retained. Budget exhaustion is a SPLIT result,
never an UNSAT claim. The queue runner replaces such a case by child cubes.
"""
import argparse
import itertools
import json
import os
from pathlib import Path
import resource
import subprocess
import sys
import time

from pysat.formula import CNF
from pysat.solvers import Solver
from independent_c2 import decode, sha

ROOT = Path('/path/to/repo')
CHECKER = ROOT/'agents/proofs/tools/bin/drat-trim'
BASE_CACHE = {}


def solve(base, tag, units=(), conflicts=0, solver='cadical195', clean=False,
          cache=False):
    started = time.monotonic()
    tag = Path(tag)
    tag.parent.mkdir(parents=True, exist_ok=True)
    meta = json.loads(Path(str(base)+'.json').read_text())
    original = Path(str(base)+'.cnf')
    formula = Path(str(tag)+'.cnf')
    with original.open() as inp, formula.open('w') as out:
        nv, nc = [int(x) for x in inp.readline().split()[2:]]
        out.write(f'p cnf {nv} {nc+len(units)}\n')
        for chunk in iter(lambda: inp.read(1 << 20), ''):
            out.write(chunk)
        for u in units:
            out.write(f'{u} 0\n')
    rec = dict(base=str(base), tag=str(tag), units=list(units),
               solver=solver, conflict_budget=conflicts,
               encoder_sha256=meta['encoder_sha256'],
               cnf_sha256=sha(formula), config=meta['config'])
    if cache:
        key = (str(base), meta['cnf_sha256'])
        if key not in BASE_CACHE:
            assert sha(original) == meta['cnf_sha256']
            BASE_CACHE[key] = CNF(from_file=str(original))
        cnf = BASE_CACHE[key]
        clauses = itertools.chain(cnf.clauses, ([u] for u in units))
    else:
        cnf = CNF(from_file=str(formula))
        clauses = cnf.clauses
    with Solver(name=solver, bootstrap_with=clauses,
                with_proof=True, use_timer=True) as s:
        if conflicts:
            s.conf_budget(conflicts)
            result = s.solve_limited()
        else:
            result = s.solve()
        rec.update(solver_seconds=s.time(), statistics=s.accum_stats())
        if result is False:
            proof = Path(str(tag)+'.drat')
            with proof.open('w') as out:
                for line in s.get_proof():
                    out.write(line+'\n')
            rec.update(status='UNSAT_UNCHECKED', proof_sha256=sha(proof),
                       proof_bytes=proof.stat().st_size)
        elif result is True:
            model = s.get_model()
            yes = set(x for x in model if x > 0)
            rec['assignment_checked'] = all(
                any((x in yes) if x > 0 else (-x not in yes) for x in clause)
                for clause in cnf.clauses) and all(
                    ((u in yes) if u > 0 else (-u not in yes)) for u in units)
            assert rec['assignment_checked']
            Path(str(tag)+'.model').write_text(' '.join(map(str, model))+' 0\n')
            candidate = Path(str(tag)+'.s')
            candidate.write_text(decode(meta, model))
            from verify import validate
            rec['validation'] = validate(candidate)
            rec['status'] = 'SAT_JUDGE_PASS'
        else:
            rec['status'] = 'SPLIT'
            # Propagate the cube independently of search decisions. The queue
            # splits only unresolved instruction selectors, never value bits.
            consistent, implied = s.propagate(assumptions=list(units))
            rec['implied_selectors'] = implied
            rec['propagation_consistent'] = consistent
    del cnf
    if result is False:
        checked = time.monotonic()
        with Path(str(tag)+'.check').open('w') as out:
            p = subprocess.run([str(CHECKER), str(formula), str(proof)],
                               stdout=out, stderr=subprocess.STDOUT)
        lines = Path(str(tag)+'.check').read_text().splitlines()
        rec.update(check_seconds=time.monotonic()-checked,
                   checker_returncode=p.returncode,
                   checker_sha256=sha(CHECKER),
                   verified=p.returncode == 0 and 's VERIFIED' in lines,
                   checker_tail=lines[-8:])
        assert rec['verified'], rec
        rec['status'] = 'UNSAT_VERIFIED'
    rec.update(wall_seconds=time.monotonic()-started,
               maxrss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss)
    Path(str(tag)+'.json').write_text(json.dumps(rec, indent=2)+'\n')
    if clean and rec['status'] in ('SPLIT', 'UNSAT_VERIFIED'):
        formula.unlink()
    print(json.dumps(rec), flush=True)
    return rec


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--base', required=True)
    ap.add_argument('--tag', required=True)
    ap.add_argument('--units', default='')
    ap.add_argument('--conflicts', type=int, default=0)
    ap.add_argument('--solver', default='cadical195')
    ap.add_argument('--clean', action='store_true')
    args = ap.parse_args()
    override = Path(args.tag).parent/'budget.json'
    if args.conflicts and override.exists():
        args.conflicts = int(json.loads(override.read_text())['conflicts'])
    if os.getpriority(os.PRIO_PROCESS, 0) < 10:
        os.nice(10-os.getpriority(os.PRIO_PROCESS, 0))
    resource.setrlimit(resource.RLIMIT_AS, (6 << 30, 6 << 30))
    solve(args.base, args.tag,
          [int(x) for x in args.units.split(',') if x],
          args.conflicts, args.solver, args.clean)


if __name__ == '__main__':
    main()
