# flagalt.py in.txt out.txt : per cmp, all lattice operand pairs (consistent at the block) with the same flags
import sys, numpy as np
sys.path.insert(0, '.')
from cons import cols, names, consistent_mask, norm
NI = {n: i for i, n in enumerate(names)}
sk = [tuple(NI[norm(x)] for x in l.strip().split(':')) for l in open(sys.argv[1]) if l.strip() and l[0] != '#']
labels = np.zeros(120, dtype=np.int64); out = ['# flag-class alternatives of %s' % sys.argv[1]]; per = []
for a, b in sk:
    m = np.nonzero(consistent_mask(labels))[0]
    F = np.sign(cols[a].astype(int) - cols[b]); C = cols[m].astype(int)
    alts = []
    for i in range(len(m)):
        f = np.sign(C[i][None, :] - C)
        for jj in np.nonzero((f == F).all(axis=1))[0]:
            alts.append('%s:%s' % (names[m[i]], names[m[jj]]))
    first = '%s:%s' % (names[a], names[b])
    alts.remove(first); alts = [first] + alts
    per.append(len(alts)); out.append(';'.join(alts))
    labels = labels * 3 + F + 1
open(sys.argv[2], 'w').write('\n'.join(out) + '\n')
print(sys.argv[1], per)
