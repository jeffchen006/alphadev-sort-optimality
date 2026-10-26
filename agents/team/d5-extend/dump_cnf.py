import sys, random; sys.path.insert(0, '.')
from core_sat import CoreEnc
import sim as satsim
from d5lib import read_progs
pi = int(sys.argv[1]); keep = [int(x) for x in sys.argv[2].split(',')]; K = int(sys.argv[3]); nt = int(sys.argv[4]); out = sys.argv[5]
for i, p in enumerate(read_progs('/path/to/repo/agents/upper/runs/r4/s5k32_coll.txt.gz')):
    if i == pi: break
import core_sat
rules = [r for r in core_sat.RULES if r not in sys.argv[7].split(',')] if len(sys.argv) > 7 else core_sat.RULES
e = CoreEnc([p[i] for i in keep], K, R=int(sys.argv[6]), rules=rules, order=len(sys.argv) > 8)
for t in random.Random(0).sample(satsim.total_orders(5), nt): e.add_type(t)
e.dimacs(out); print(e.nvars, len(e.clauses))
