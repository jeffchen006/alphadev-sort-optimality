"""Print cube-tree sizes (UP-pruned) for an instance; save leaves at the given depth.
usage: tree_size.py n k depth outdir"""
import sys, json, os
from encode import Enc
import sim, cubes
n, k, depth, d = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3]), sys.argv[4]
R = 'canon,pcanon,comm,dead,flags,cmpord,movfresh,snapcmov,hcmp'.split(',')
e = Enc(n, k, None, 'I1', 'snap', R, True)
for t in sim.total_orders(n):
    e.add_type(t)
e.add_class_cuts()
os.makedirs(d, exist_ok=True)
e.dimacs(d + '/F.cnf', 'n=%d k=%d R=%d I1 snap rules=%s perms' % (n, k, e.R, ','.join(R)))
leaves, internal = cubes.build_tree(e, depth, print)
json.dump({'leaves': leaves, 'internal': len(internal)}, open(d + '/cubes.json', 'w'))
