# V2 controls: fixed known program must be SAT in V2; original encoder result for comparison. usage: control_v2.py prog.s k c
import sys, itertools, time
sys.path.insert(0, 'src')
from pysat.solvers import Cadical153
import threshold_sat, threshold_cmpx
prog = open(sys.argv[1]).read(); k = int(sys.argv[2]); c = int(sys.argv[3])
types = list(itertools.permutations(range(5)))
for name, mod in (('V1', threshold_sat), ('V2', threshold_cmpx)):
    t0 = time.time()
    enc = mod.ThresholdEncoding(5, k, c, types, None, False, None, None, False)
    enc.fix_program(prog)
    s = Cadical153(bootstrap_with=enc.cs); r = s.solve()
    print(name, 'SAT' if r else 'UNSAT', f'{time.time()-t0:.1f}s', flush=True)
