"""Completeness check of relax_joint.py on real programs: for a strict program P with depth d (model U)
and c = #cmp + #cmov, the joint encoding must be SAT at (D = per-output depths of P, K = c).
usage: python3 test_joint.py file.s [cl]"""
import sys, os, subprocess
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from prog import parse_team, depth, LAT, counts
f = sys.argv[1]; cl = sys.argv[2] if len(sys.argv) > 2 else '1'
n, p, model = parse_team(f)
d = depth(p, LAT['U' if cl == '1' else 'Z2'])
c = counts(p)
K = sum(v for o, v in c.items() if o.startswith('cmov') or o == 'cmp')
D = ','.join(map(str, d[1]))
print('%s: per-output depth %s, cmp+cmov = %d' % (f, D, K), flush=True)
subprocess.run([sys.executable, os.path.join(os.path.dirname(os.path.abspath(__file__)), 'relax_joint.py'),
                str(n), D, str(K), '--T', '--cl', cl])
