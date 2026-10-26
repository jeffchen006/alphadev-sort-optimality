#!/usr/bin/env python3
"""Additional explicit normal forms and redundant flag-history separation."""
import argparse
import gc
import itertools
import json
import os
from pathlib import Path
import resource
import time

from partial_shapes import PartialShapes, solve, digest, weak_orders


def strengthen(enc, mixed=True, useful=True, live=True, histories=False):
    before = enc.nv, len(enc.cs)
    if mixed:
        for e in range(enc.q):
            enc.cl(enc.positions[e][enc.m], *enc.defined[e])
    if useful:
        for j in range(enc.c):
            users = []
            for g in range(enc.m):
                u = enc.new()
                enc.cl(-u, enc.blk[g][j])
                enc.cl(-u, -enc.mov[g])
                enc.cl(u, -enc.blk[g][j], enc.mov[g])
                users.append(u)
            enc.cl(*users)
    if live:
        for g in range(enc.m):
            users = [p[enc.n+g] for h in range(g+1, enc.m)
                     for p in (enc.src[h], enc.dst[h])]
            for e in range(enc.q):
                enc.cl(-enc.ex[e][g], *users)
    if histories:
        ts = [t for t, case in enumerate(enc.types) if len(set(case)) == enc.n]
        for t, u in itertools.combinations(ts, 2):
            same = []
            for j in range(enc.c):
                s = enc.new()
                for f in range(3):
                    a, b = enc.fl[j][t][f], enc.fl[j][u][f]
                    enc.cl(-s, enc.neg(a), b)
                    enc.cl(-s, a, enc.neg(b))
                    enc.cl(enc.neg(a), enc.neg(b), s)
                same.append(s)
            enc.cl(*[-s for s in same])
    return dict(variables=enc.nv-before[0], clauses=len(enc.cs)-before[1],
                mixed=mixed, useful=useful, live=live, histories=histories)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--n', type=int, default=5)
    ap.add_argument('--k', type=int, default=31)
    ap.add_argument('--c', type=int, default=9)
    ap.add_argument('--q', type=int, default=3)
    ap.add_argument('--cases', choices=['strict','weak'], default='weak')
    ap.add_argument('--topology', type=int)
    ap.add_argument('--histories', action='store_true')
    ap.add_argument('--fixed')
    ap.add_argument('--free-first', action='store_true')
    ap.add_argument('--timeout', type=int, default=60)
    ap.add_argument('--tag', required=True)
    args = ap.parse_args()
    assert os.getpriority(os.PRIO_PROCESS, 0) == 19
    resource.setrlimit(resource.RLIMIT_AS, (2400*1024**2, 2400*1024**2))
    start = time.monotonic()
    types = weak_orders(args.n) if args.cases == 'weak' else list(itertools.permutations(range(args.n)))
    enc = PartialShapes(args.n, args.k, args.c, args.q, types, args.q,
                        first_pair=not args.free_first, symmetry=not args.fixed,
                        dependency=True, topology=args.topology)
    extra = strengthen(enc, histories=args.histories)
    if args.fixed:
        enc.fix_program(Path(args.fixed).read_text())
    print(json.dumps(dict(step='built', variables=enc.nv, clauses=len(enc.cs),
                          extra=extra, args=vars(args), build_seconds=time.monotonic()-start)), flush=True)
    record = solve(enc, args.tag, args.timeout, True)
    record.update(args=vars(args), strengthening=extra,
                  strong_source_sha256=digest(__file__), total_seconds=time.monotonic()-start,
                  process_maxrss_kib=resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,
                  nice=os.getpriority(os.PRIO_PROCESS, 0))
    Path(args.tag+'.json').write_text(json.dumps(record, indent=2)+'\n')
    print(json.dumps(record), flush=True)


if __name__ == '__main__':
    main()
