"""Depth (critical path) and a simple throughput bound (cycles/call, steady state:
TPskl = max(L/4, #cmov/2), TPzen = max(L/6, #cmov/2), L = k + 2n incl. loads/stores) of every team program file for n <= 5, models U / E / Z2.
usage: python3 depth_all.py [files...]   (default: programs/*.s programs/out/*.s programs/found/*.s, n<=5)"""
import sys, os, glob
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from prog import parse_team, check, depth, LAT, counts
ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '../..')
files = sys.argv[1:] or sorted(glob.glob(ROOT + '/programs/*.s') + glob.glob(ROOT + '/programs/out/*.s') +
                               glob.glob(ROOT + '/programs/found/*.s'))
print('%-48s %2s %5s %3s %3s %3s %3s %4s %5s %5s  %s' % ('file', 'n', 'model', 'k', 'U', 'E', 'Z2', 'cmov', 'TPskl', 'TPzen', 'strict / per-output depth U'))
for f in files:
    try:
        n, p, model = parse_team(f)
    except Exception as e:
        print('%-48s skip (%s)' % (os.path.relpath(f, ROOT), e)); continue
    if n is None or n > 5 or 'memops' in f:
        continue
    c = counts(p)
    k = len(p) - c.get('load', 0) - c.get('store', 0)
    ok, _ = check(p, n, trials=5)
    d = {m: depth(p, LAT[m]) for m in LAT}
    ncmov = sum(v for o, v in c.items() if o.startswith('cmov'))
    tp_skl = max(len(p) / 4.0, ncmov / 2.0)       # incl. loads/stores in the 4-wide issue; cmov on p06
    tp_zen = max(len(p) / 6.0, ncmov / 2.0)       # Zen 3/4: 6-wide dispatch; cmov on ALU0/3
    print('%-48s %2d %5s %3d %3d %3d %3d %4d %5.2f %5.2f  %s %s' % (os.path.relpath(f, ROOT), n, model, k, d['U'][0], d['E'][0], d['Z2'][0],
                                                   ncmov, tp_skl, tp_zen, 'ok' if ok else 'FAIL', d['U'][1]))
