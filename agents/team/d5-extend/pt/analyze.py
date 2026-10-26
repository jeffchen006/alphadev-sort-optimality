"""classify operand columns of a dagx skeleton: lattice name, or one-select (flag_k gt ? A : B, A/B lattice), else '?'"""
import sys, itertools, numpy as np
D = '/path/to/repo/agents/team/d1-skeleton/out/'
names = open(D + 'lat_names.txt').read().split('\n')
cols = np.fromfile(D + 'lat_cols.u8', dtype=np.uint8).reshape(-1, 120)
lat = {bytes(c): names[i] for i, c in enumerate(cols)}
sk = []
for l in open(sys.argv[1]):
    l = l.strip()
    if not l or l.startswith('#'): continue
    for w in l.split():
        a, b = w.split(':'); sk.append((np.array([int(x) for x in a[1:]], np.uint8), np.array([int(x) for x in b[1:]], np.uint8)))
flags = [a > b for a, b in sk]  # gt per perm
def classify(c, j):
    if bytes(c) in lat: return lat[bytes(c)]
    for k in range(j):
        g = flags[k]
        # lattice columns matching c on gt types / on lt types
        A = [i for i in range(len(cols)) if (cols[i][g] == c[g]).all()]
        B = [i for i in range(len(cols)) if (cols[i][~g] == c[~g]).all()]
        if A and B: return 'sel(f%d ? %s : %s)' % (k + 1, names[A[0]], names[B[0]])
    return '?'
for j, (a, b) in enumerate(sk):
    print(j + 1, classify(a, j), '|', classify(b, j))
