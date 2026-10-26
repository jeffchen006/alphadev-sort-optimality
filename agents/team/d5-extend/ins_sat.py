"""pure insertion: x0<=x1<=x2<=x3 (all weak orders of 5 with this property), output sorted 5 (M_out snap, I1),
relaxed model (MODEL §2), agents/sat/encode.py rules canon,comm,dead,flags,cmpord,movfresh,snapcmov,hcmp (no pcanon:
inputs are not interchangeable here). Writes DIMACS for kissat."""
import sys; sys.path.insert(0, '/path/to/repo/agents/sat')
from encode import Enc
import sim
K = int(sys.argv[1]); out = sys.argv[2]
rules = ['canon', 'comm', 'dead', 'flags', 'cmpord', 'movfresh', 'snapcmov', 'hcmp']
ce = int(sys.argv[3]) if len(sys.argv) > 3 else None
e = Enc(5, K, iset='I1', outmode='snap', rules=rules, nop=True, cmpeq=ce)
T = [w for w in sim.weak_orders(5) if w[0] <= w[1] <= w[2] <= w[3]]
for t in T: e.add_type(t)
e.dimacs(out, 'pure insertion K=%d types=%d rules=%s' % (K, len(T), ','.join(rules)))
print(K, len(T), e.nvars, len(e.clauses))
