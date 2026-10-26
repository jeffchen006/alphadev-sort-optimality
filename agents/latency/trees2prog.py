"""Compile saved RD trees (one file per output, python literal) into a strict I0 program (lsched).
usage: python3 trees2prog.py n D0,..,D{n-1} tree0 .. tree{n-1} [--out f.s]
A tree file may be 'dtree' to use the mux-tree of dtree.py for that output (not implemented: give files)."""
import sys, os, argparse, ast
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from lsched import compile_dag
from prog import check, depth, LAT, counts
ap = argparse.ArgumentParser()
ap.add_argument('n', type=int); ap.add_argument('D'); ap.add_argument('trees', nargs='+'); ap.add_argument('--out'); ap.add_argument('--i1', action='store_true'); ap.add_argument('--model', default='U')
a = ap.parse_args()
n = a.n; Ds = [int(x) for x in a.D.split(',')]
trees = [ast.literal_eval(open(f).read()) for f in a.trees]
r = compile_dag(trees, Ds, 1 if a.model == 'U' else 0, 1, a.i1)
if r is None:
    print('lsched failed'); sys.exit(1)
body, _, ns = r
prog = [('load', 'P%d' % i, i) for i in range(n)] + body
ok, _ = check(prog, n)
d = {m: depth(prog, LAT[m]) for m in LAT}
k = len(prog) - 2 * n
print('n=%d k=%d %s strict=%s depth U=%d %s E=%d Z2=%d' % (n, k, counts(prog), ok, d['U'][0], d['U'][1], d['E'][0], d['Z2'][0]))
if a.out:
    with open(a.out, 'w') as f:
        f.write(('# n=%d R=%d iset=' + ('I1' if a.i1 else 'I0') + ' model=out source=latency/trees2prog.py+rdls.py D=%s k=%d depthU=%d depthE=%d depthZ2=%d strict=%s\n') % (
            n, n + ns, a.D, k, d['U'][0], d['E'][0], d['Z2'][0], ok))
        for op, x, y in prog:
            if op == 'store':
                f.write('out %d, %s\n' % (x, y))
            elif op != 'load':
                f.write('%s %s, %s\n' % (op, x, y))
