#!/usr/bin/env python3
"""d1-skeleton: D3 skeleton generator. An algorithm = function alg(x) -> list of compared (va, vb) value pairs,
run on every permutation x of ranks (lexicographic order). The i-th entries over all perms form the operand
columns of cmp i. Output: dagx skeleton file with explicit columns ("=<120 digits>:=<120 digits>").
Branch-free validity: operand index must be a function of the earlier flags (true for any decision tree whose
i-th comparison depends only on earlier outcomes) and every path must use the same number of cmps (pad)."""
import itertools, sys

P = list(itertools.permutations(range(5)))


class Cmp:
    def __init__(self, x):
        self.x = x
        self.log = []

    def lt(self, i, j):
        """compare elements by INDEX i, j; record values; return x[i] < x[j]"""
        self.log.append((self.x[i], self.x[j]))
        return self.x[i] < self.x[j]


def bin_insert(c, e, chain, pad_to=None):
    """insert index e into sorted list chain (indices) by binary search; pad to pad_to cmps with a
    redundant compare (e vs its final neighbour)"""
    lo, hi = 0, len(chain)
    n0 = len(c.log)
    while lo < hi:
        mid = (lo + hi) // 2
        if c.lt(e, chain[mid]):
            hi = mid
        else:
            lo = mid + 1
    if pad_to is not None:
        while len(c.log) - n0 < pad_to:
            nb = chain[lo] if lo < len(chain) else chain[-1]
            c.lt(e, nb)
    return chain[:lo] + [e] + chain[lo:]


def fj5(x):
    c = Cmp(x)
    a, b = (1, 0) if c.lt(0, 1) else (0, 1)   # a = larger
    cc, d = (3, 2) if c.lt(2, 3) else (2, 3)
    if c.lt(a, cc):
        A, B, C, D = cc, d, a, b
    else:
        A, B, C, D = a, b, cc, d
    L = bin_insert(c, 4, [D, C, A], pad_to=2)
    below = L[:L.index(A)]
    L2 = bin_insert(c, B, below, pad_to=2)
    return c.log


def sort4_net_insert(x, net=((0, 1), (2, 3), (0, 2), (1, 3), (1, 2)), first='mid'):
    """sort x0..x3 with a 5-comparator network (min to lower wire), then binary-insert x4 (3 cmps)."""
    c = Cmp(x)
    w = [0, 1, 2, 3]
    for i, j in net:
        if c.lt(w[j], w[i]):
            w[i], w[j] = w[j], w[i]
    bin_insert(c, 4, w, pad_to=3)
    return c.log


def merge23(x):
    """sort (x0,x1): 1 cmp; sort (x2,x3,x4): 3 cmps; insert min pair elt into 3-chain (2), max into the rest (2)."""
    c = Cmp(x)
    p = [0, 1] if c.lt(0, 1) else [1, 0]
    t = [2]
    t = bin_insert(c, 3, t, pad_to=1)
    t = bin_insert(c, 4, t, pad_to=2)
    L = bin_insert(c, p[0], t, pad_to=2)
    above = L[L.index(p[0]) + 1:] or [p[0]]
    L2 = bin_insert(c, p[1], above, pad_to=2)
    return c.log


ALGS = {'fj5': fj5, 'sort4ins': sort4_net_insert, 'merge23': merge23}


def write(alg, fn):
    logs = [alg(x) for x in P]
    c = len(logs[0])
    assert all(len(l) == c for l in logs), 'variable cmp count'
    with open(fn, 'w') as f:
        f.write('# %s c=%d\n' % (alg.__name__, c))
        for i in range(c):
            a = ''.join(str(l[i][0]) for l in logs)
            b = ''.join(str(l[i][1]) for l in logs)
            f.write('=%s:=%s\n' % (a, b))
    return c


if __name__ == '__main__':
    for name in sys.argv[1:]:
        print(name, write(ALGS[name], 'sk/d3_%s.txt' % name))
