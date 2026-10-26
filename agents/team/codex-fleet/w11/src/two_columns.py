#!/usr/bin/env python3
"""Two full exceptional versions: prefix and raw-comparison exact scopes.

The underlying threshold encoder is copied, unchanged, from w10. These new
queries fix early selection structure or compare original inputs throughout.
No lattice term pool is used. Exception selectors give an upper bound of two.
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

from threshold_sat import ThresholdEncoding
from partial_sat import PROJECT, program_flags


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def build(args):
    n, c, k = 5, args.c, args.k
    types = list(itertools.permutations(range(n)))
    flags = None
    pairs = None
    if args.raw:
        pair_orders = {
            'lex': list(itertools.combinations(range(n), 2)),
            'insert': [(i, j) for j in range(1, n) for i in range(j-1, -1, -1)],
            'round': [(0, 1), (2, 3), (0, 4), (1, 2), (3, 4),
                      (0, 2), (1, 3), (2, 4), (0, 3), (1, 4)],
        }
        pairs = pair_orders[args.raw]
        assert c == len(pairs)
        flags = [[(ty[a] > ty[b]) - (ty[a] < ty[b]) for ty in types]
                 for a, b in pairs]
    enc = ThresholdEncoding(n, k, c, types, first_pair=False,
                            flags=flags, symmetry=False)
    if args.prefix is not None:
        # Preserve all original inputs before the first non-lattice selection.
        d, s = [(0, 2), (1, 2), (2, 3)][args.prefix]
        enc.cl(enc.cmp[0][0][0])
        enc.cl(enc.cmp[0][1][1])
        enc.cl(enc.mov[0])
        enc.cl(enc.src[0][d])
        enc.cl(enc.blk[0][0])
        enc.cl(-enc.mov[1])
        enc.cl(enc.dst[1][n])
        enc.cl(enc.src[1][s])
        enc.cl(enc.blk[1][0])
        enc.cl(-enc.high[1])
        enc.cl(-enc.inclusive[1])
        enc.cl(enc.positions[0][1])
        # The comparison orientation symmetry is safe with fixed prefix.
        for j in range(c):
            for a in range(n+enc.m):
                for b in range(a):
                    enc.cl(-enc.cmp[j][0][a], -enc.cmp[j][1][b])
    if pairs is not None:
        for j, (a, b) in enumerate(pairs):
            enc.cl(enc.cmp[j][0][a])
            enc.cl(enc.cmp[j][1][b])
    if args.fixed:
        enc.fix_program(Path(args.fixed).read_text())
    return enc, pairs


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--k', type=int, default=31)
    ap.add_argument('--c', type=int, default=9)
    ap.add_argument('--prefix', type=int, choices=range(3))
    ap.add_argument('--raw', choices=['lex', 'insert', 'round'])
    ap.add_argument('--fixed')
    ap.add_argument('--timeout', type=int, default=600)
    ap.add_argument('--tag', required=True)
    args = ap.parse_args()
    resource.setrlimit(resource.RLIMIT_AS, (3*1024**3, 3*1024**3))
    started = time.monotonic()
    enc, pairs = build(args)
    cnf = Path(args.tag+'.cnf')
    cnf.parent.mkdir(parents=True, exist_ok=True)
    enc.dimacs(cnf)
    rec = dict(vars(args), variables=enc.nv, clauses=len(enc.cs),
               orders=120, exception_bound=2, lattice_shapes=7579,
               comparison_values='lattice', output_values='lattice',
               raw_pairs=pairs, source_hashes={p.name: sha(p) for p in
                   Path(__file__).parent.glob('*.py')}, cnf_sha256=sha(cnf),
               build_seconds=time.monotonic()-started)
    Path(args.tag+'.built.json').write_text(json.dumps(rec, indent=2)+'\n')
    print(json.dumps(dict(stage='built', **rec)), flush=True)
    enc.cs.clear()
    gc.collect()
    command = [str(PROJECT/'bin/kissat'), '--time='+str(args.timeout),
               str(cnf), args.tag+'.drat']
    before = resource.getrusage(resource.RUSAGE_CHILDREN)
    with open(args.tag+'.solver', 'w') as out:
        try:
            p = subprocess.run(command, stdout=out, stderr=subprocess.STDOUT,
                               timeout=args.timeout+10)
            rec['returncode'] = p.returncode
        except subprocess.TimeoutExpired:
            rec['returncode'] = 124
    rec['status'] = 'UNKNOWN'
    model = []
    for line in Path(args.tag+'.solver').read_text().splitlines():
        if line.startswith('s '):
            rec['status'] = line[2:].strip()
        if line.startswith('v '):
            model += [int(v) for v in line[2:].split() if int(v)]
    after = resource.getrusage(resource.RUSAGE_CHILDREN)
    rec.update(cpu_seconds=after.ru_utime+after.ru_stime-before.ru_utime-before.ru_stime,
               maxrss_kib=after.ru_maxrss, wall_seconds=time.monotonic()-started)
    if rec['status'] == 'SATISFIABLE':
        yes = set(x for x in model if x > 0)
        with cnf.open() as inp:
            next(inp)
            for line in inp:
                cl = list(map(int, line.split()[:-1]))
                assert any(x in yes if x > 0 else -x not in yes for x in cl)
        text = enc.decode(model).replace('source=w10_partial_sat', 'source=w11_two_columns')
        Path(args.tag+'.s').write_text(text)
        rec['assignment_checked'] = True
        rec['selected_exception_slots'] = [[g for g,x in enumerate(row) if x in yes]
                                            for row in enc.positions]
    if rec['status'] == 'UNSATISFIABLE':
        command = [str(PROJECT/'bin/drat-trim'), str(cnf), args.tag+'.drat', '-t', '180']
        with open(args.tag+'.proofcheck', 'w') as out:
            try:
                p = subprocess.run(command, stdout=out, stderr=subprocess.STDOUT, timeout=190)
                rec['proof_returncode'] = p.returncode
            except subprocess.TimeoutExpired:
                rec['proof_returncode'] = 124
        rec['proof_verified'] = 's VERIFIED' in Path(args.tag+'.proofcheck').read_text()
    elif rec['status'] == 'UNKNOWN':
        Path(args.tag+'.drat').unlink(missing_ok=True)
    Path(args.tag+'.json').write_text(json.dumps(rec, indent=2)+'\n')
    print(json.dumps(rec), flush=True)


if __name__ == '__main__':
    main()
