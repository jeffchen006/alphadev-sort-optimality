"""mkleaf.py DIR i OUT.cnf : write F.cnf of DIR plus unit clauses of leaf cube i (from cubes.json)."""
import json, sys
d, i, out = sys.argv[1], int(sys.argv[2]), sys.argv[3]
cube = json.load(open(d + '/cubes.json'))['leaves'][i]
with open(d + '/F.cnf') as f, open(out, 'w') as g:
    for line in f:
        if line.startswith('c'):
            continue
        if line.startswith('p'):
            _, _, nv, nc = line.split()
            g.write('p cnf %s %d\n' % (nv, int(nc) + len(cube)))
            continue
        g.write(line)
    for l in cube:
        g.write('%d 0\n' % l)
