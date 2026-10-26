# for a value skeleton: per cmp, number of lattice operand pairs (consistent at the block) with the same flag vector
import sys, numpy as np
sys.path.insert(0, '.')
from cons import cols, names, consistent_mask, norm
NI = {n: i for i, n in enumerate(names)}
sk = [tuple(NI[norm(x)] for x in l.strip().split(':')) for l in open(sys.argv[1]) if l.strip() and l[0] != '#']
labels = np.zeros(120, dtype=np.int64); tot = 1; per = []
for a, b in sk:
    m = np.nonzero(consistent_mask(labels))[0]
    F = np.sign(cols[a].astype(int) - cols[b])
    C = cols[m].astype(int)
    cnt = 0
    for i in range(len(m)):
        f = np.sign(C[i][None, :] - C)          # vs all
        cnt += int(((f == F).all(axis=1)).sum() + ((f == -F).all(axis=1)).sum()) // 1
    cnt //= 2  # unordered pairs counted twice (i,j)/(j,i) with flipped flags
    per.append(cnt); tot *= cnt
    labels = labels * 3 + F + 1
print(sys.argv[1], per, tot)
