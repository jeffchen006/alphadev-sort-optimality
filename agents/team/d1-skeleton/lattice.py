#!/usr/bin/env python3
# all lattice polynomials in x0..x4 (monotone Boolean functions, non-constant) as columns over 120 perms
import itertools, numpy as np
P = list(itertools.permutations(range(5)))
PA = np.array(P, dtype=np.int8)               # [120,5]
def mbf_all():
    # monotone functions as sets of minimal subsets (antichains) of {0..4}: enumerate up-sets via bitmask of 32 subsets
    subs = list(range(1, 32))
    res = []
    # brute: up-set U of nonempty subsets; iterate over antichains by recursion
    order = sorted(subs, key=lambda s: (bin(s).count('1'), s))
    def rec(i, chosen):
        if i == len(order):
            if chosen: res.append(tuple(chosen))
            return
        s = order[i]
        rec(i + 1, chosen)
        if all((c & s) != c for c in chosen):  # s not above a chosen one
            rec(i + 1, chosen + [s])
    rec(0, [])
    return res
def col_of(anti):
    v = np.full(120, -1, dtype=np.int8)
    for s in anti:
        idx = [i for i in range(5) if s >> i & 1]
        v = np.maximum(v, PA[:, idx].min(axis=1))
    return v
def name(anti):
    return '|'.join(''.join(str(i) for i in range(5) if s >> i & 1) for s in anti)
if __name__ == '__main__':
    A = mbf_all()
    print(len(A))
    cols = np.stack([col_of(a) for a in A])
    np.save('out/lat_cols.npy', cols)
    open('out/lat_names.txt', 'w').write('\n'.join(name(a) for a in A))
