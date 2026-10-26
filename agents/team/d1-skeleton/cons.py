import numpy as np, itertools, sys
sys.path.insert(0,'.')
from lattice import P, PA
cols = np.load('out/lat_cols.npy'); names = open('out/lat_names.txt').read().split('\n')
INV = np.argsort(PA, axis=1)                   # INV[t][v] = index i with x_i = v
IDX = INV[np.arange(120)[None, :], cols]       # [ncol,120]
NI = {n: i for i, n in enumerate(names)}
def consistent_mask(labels):
    # column consistent iff idx constant on each label class
    order = np.argsort(labels, kind='stable'); lab = labels[order]
    starts = np.r_[0, np.nonzero(np.diff(lab))[0] + 1]
    X = IDX[:, order]
    mx = np.maximum.reduceat(X, starts, axis=1); mn = np.minimum.reduceat(X, starts, axis=1)
    return (mx == mn).all(axis=1)
def norm(f):
    # formula -> canonical name in names (terms sorted by size then value)
    terms = [sum(1 << int(ch) for ch in t) for t in f.split('|')]
    terms = [t for t in terms if not any((u & t) == u and u != t for u in terms)]
    terms = sorted(set(terms), key=lambda s: (bin(s).count('1'), s))
    return '|'.join(''.join(str(i) for i in range(5) if s >> i & 1) for s in terms)
if __name__ == '__main__':
    sk = [l.strip().split(':') for l in open(sys.argv[1]) if l.strip() and l[0] != '#']
    labels = np.zeros(120, dtype=np.int64)
    for j, (a, b) in enumerate(sk):
        m = consistent_mask(labels)
        ca, cb = cols[NI[norm(a)]], cols[NI[norm(b)]]
        print('block', j, 'consistent lattice cols', m.sum(), 'operands consistent', m[NI[norm(a)]], m[NI[norm(b)]], 'classes', len(set(labels)))
        f = np.sign(ca.astype(int) - cb) + 1
        labels = labels * 3 + f
    print('final classes', len(set(labels)))
