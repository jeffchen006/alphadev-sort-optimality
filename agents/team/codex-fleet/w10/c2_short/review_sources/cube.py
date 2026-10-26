#!/usr/bin/env python3
# Cubes for one hard case: split on the sizes of cmp blocks 0 and 1 (blk[g][b] = data instruction g is in block b).
# Chain cubes on x_t = blk[t][b]: size=t <=> x_0..x_{t-1} true, x_t false (t < T); size>=T <=> x_0..x_{T-1} true.
# For each block the chain cubes are a syntactic partition (their disjunction is a tautology), so the nested product is
# a complete partition of the case: case UNSAT <=> every cube UNSAT. Block 1 chain starts at the first instruction after
# block 0 (s1), so it uses blk[s1+u][1].
# usage: cube.py C I J [v1|v2] [T0=6] [T1=6] -> cubes/<case>.json
import sys, json, itertools
from pathlib import Path
SRC = Path(__file__).resolve().parent; C2 = SRC.parent; sys.path.insert(0, str(SRC))
c, i, j = map(int, sys.argv[1:4]); var = sys.argv[4] if len(sys.argv) > 4 else 'v1'
T0 = int(sys.argv[5]) if len(sys.argv) > 5 else 6; T1 = int(sys.argv[6]) if len(sys.argv) > 6 else 6
if var == 'v2': from threshold_cmpx import ThresholdEncoding
else: from threshold_sat import ThresholdEncoding
suf = '_v2' if var == 'v2' else ''
base = json.loads((C2 / 'base' / f'base_k31_c{c}{suf}.json').read_text())
enc = ThresholdEncoding(5, 31, c, list(itertools.permutations(range(5))), None, True, None, None, True)
assert enc.nv == base['variables'] and len(enc.cs) == base['clauses'], 'encoder differs from base'
m = 31 - c
def chain(b, start, T):
    out = []
    for t in range(T):
        if start + t >= m: out.append(([enc.blk[g][b] for g in range(start, m)], t)); return out
        out.append(([enc.blk[start + u][b] for u in range(t)] + [-enc.blk[start + t][b]], t))
    if start + T <= m: out.append(([enc.blk[start + u][b] for u in range(T)], T))   # size >= T (no block-1 split)
    return out
cubes = []
for u0, s1 in chain(0, 0, T0):
    if s1 == T0 or s1 >= m: cubes.append(dict(units=u0, sizes=[f'>={s1}' if s1 == T0 else s1])); continue
    for u1, s2 in chain(1, s1, T1):
        cubes.append(dict(units=u0 + u1, sizes=[s1, s2 if s2 < T1 else f'>={T1}']))
name = ('v2_' if suf else '') + f'c{c}_{i:02d}_{j:02d}'
(C2 / 'cubes').mkdir(exist_ok=True)
(C2 / 'cubes' / f'{name}.json').write_text(json.dumps(dict(case=name, c=c, i=i, j=j, variant=var, T0=T0, T1=T1, cubes=cubes)) + '\n')
print(name, len(cubes), 'cubes')
