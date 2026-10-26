"""List (c, blocks) cases for n, K: c cmps (c >= cmin), blocks b_1..b_c >= 1, c + sum(b) <= K, sum(b) >= mmin.
usage: split_cases.py K cmin mmin [cmax]"""
import sys, itertools
K, cmin, mmin = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3])
cmax = int(sys.argv[4]) if len(sys.argv) > 4 else K


def comps(m, c):
    for cut in itertools.combinations(range(1, m), c - 1):
        p = (0,) + cut + (m,)
        yield tuple(p[i + 1] - p[i] for i in range(c))


for c in range(cmin, cmax + 1):
    for m in range(max(mmin, c), K - c + 1):
        for b in comps(m, c):
            print(c, '-'.join(map(str, b)))
