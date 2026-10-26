#!/usr/bin/env python3
# C2 base CNF for one comparison count c (w10 round5 encoder, unchanged copy; sha256 recorded).
# usage: build.py C [K=31] [v2]  -> base_k{K}_c{C}.cnf + .json (variables, clauses, position_choices, hashes)
import sys, json, hashlib, itertools, time
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent))
c = int(sys.argv[1]); k = int(sys.argv[2]) if len(sys.argv) > 2 else 31
V2 = len(sys.argv) > 3 and sys.argv[3] == 'v2'   # v2: exceptions may be cmp operands (threshold_cmpx.py)
if V2: from threshold_cmpx import ThresholdEncoding
else: from threshold_sat import ThresholdEncoding
out = Path(__file__).parent.parent / 'base'; out.mkdir(exist_ok=True)
tag = out / (f'base_k{k}_c{c}' + ('_v2' if V2 else ''))
t0 = time.time()
types = list(itertools.permutations(range(5)))
# same call as threshold_sat.py main() with default flags: slots=None, first_pair=True, symmetry=True
enc = ThresholdEncoding(5, k, c, types, None, True, None, None, True)
enc.dimacs(Path(str(tag) + '.cnf'))
h = lambda p: hashlib.sha256(Path(p).read_bytes()).hexdigest()
src = Path(__file__).parent
rec = dict(n=5, k=k, c=c, orders=len(types), variables=enc.nv, clauses=len(enc.cs),
           position_choices=enc.positions, cnf_sha256=h(str(tag) + '.cnf'),
           encoder_sha256=h(src / ('threshold_cmpx.py' if V2 else 'threshold_sat.py')), variant='v2' if V2 else 'v1', base_sha256=h(src / 'partial_sat.py'),
           symmetry_sha256=h(src / 'partial_gap.py'), build_seconds=time.time() - t0)
Path(str(tag) + '.json').write_text(json.dumps(rec) + '\n')
print(c, k, rec['variables'], rec['clauses'], rec['cnf_sha256'][:16], len(enc.positions[0]))
