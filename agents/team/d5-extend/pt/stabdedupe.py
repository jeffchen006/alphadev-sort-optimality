"""dedupe completions of a fixed prefix under the prefix's stabilizer in S5 x reversal (sound symmetry reduction)."""
import sys
exec(open('../gx/canontpl.py').read().split('cnt = collections')[0])
P = int(sys.argv[2])
def key(ws, g):
    m, rev = g; out = []
    for s in ws:
        a, b = s.split(':'); a, b = tr(a[1:], m, rev), tr(b[1:], m, rev); out.append((min(a, b), max(a, b)))
    return out
lines = [l.split() for l in open(sys.argv[1])]
base = key(lines[0][:P], maps[0])
stab = [g for g in maps if key(lines[0][:P], g) == base]
seen = {}; 
for i, ws in enumerate(lines):
    k = min(tuple(key(ws[P:], g)) for g in stab)
    seen.setdefault(k, i)
with open(sys.argv[3], 'w') as fo:
    for k, i in sorted(seen.items(), key=lambda t: t[1]): fo.write(' '.join(lines[i]) + '\n')
print('stabilizer', len(stab), 'in', len(lines), 'out', len(seen))
